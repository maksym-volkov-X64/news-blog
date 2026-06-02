import { SourceFile, SyntaxKind, TypeNode } from "ts-morph";

/**
 * Reads Config.collections and Config.globals to discover which TS interfaces
 * should be generated as Dart models. Returns a set of TS interface names.
 */
function extractIncludedInterfaces(sourceFile: SourceFile): Set<string> {
  const included = new Set<string>();
  const configIface = sourceFile.getInterface("Config");
  if (!configIface) return included;

  for (const sectionName of ["collections", "globals"]) {
    const prop = configIface.getProperty(sectionName);
    if (!prop) continue;
    const typeNode = prop.getTypeNode();
    if (!typeNode || typeNode.getKind() !== SyntaxKind.TypeLiteral) continue;
    const typeLiteral = typeNode.asKindOrThrow(SyntaxKind.TypeLiteral);
    for (const memberProp of typeLiteral.getProperties()) {
      const memberType = memberProp.getTypeNode();
      if (!memberType) continue;
      if (memberType.getKind() === SyntaxKind.TypeReference) {
        const ref = memberType.asKindOrThrow(SyntaxKind.TypeReference);
        included.add(ref.getTypeName().getText());
      }
    }
  }

  return included;
}

export interface DartField {
  dartName: string; // Dart field name (camelCase)
  jsonKey: string; // Original JSON key from TS property name
  dartType: string; // Dart type name
  isNullable: boolean;
}

export interface DartClass {
  name: string;
  fields: DartField[];
}

function convertTypeNode(
  node: TypeNode,
  included: Set<string>,
): { type: string; nullable: boolean } {
  const kind = node.getKind();

  switch (kind) {
    case SyntaxKind.StringKeyword:
      return { type: "String", nullable: false };

    case SyntaxKind.NumberKeyword:
      return { type: "int", nullable: false };

    case SyntaxKind.BooleanKeyword:
      return { type: "bool", nullable: false };

    case SyntaxKind.UnknownKeyword:
    case SyntaxKind.AnyKeyword:
    case SyntaxKind.NeverKeyword:
    case SyntaxKind.UndefinedKeyword:
    case SyntaxKind.NullKeyword:
      return { type: "dynamic", nullable: true };

    // String/number literals like 'users', 'full', 42
    case SyntaxKind.LiteralType:
      return { type: "String", nullable: false };

    case SyntaxKind.ParenthesizedType:
      return convertTypeNode(
        node.asKindOrThrow(SyntaxKind.ParenthesizedType).getTypeNode(),
        included,
      );

    case SyntaxKind.UnionType: {
      const union = node.asKindOrThrow(SyntaxKind.UnionType);
      const types = union.getTypeNodes();

      function isNullish(t: TypeNode): boolean {
        if (t.getKind() === SyntaxKind.NullKeyword) return true;
        if (t.getKind() === SyntaxKind.UndefinedKeyword) return true;
        // `null` in TS AST appears as LiteralType wrapping NullKeyword
        if (t.getKind() === SyntaxKind.LiteralType && t.getText() === "null")
          return true;
        return false;
      }

      const hasNull = types.some(isNullish);
      const nonNull = types.filter((t) => !isNullish(t));

      if (nonNull.length === 1) {
        const inner = convertTypeNode(nonNull[0], included);
        return { type: inner.type, nullable: inner.nullable || hasNull };
      }
      // Multiple non-null types (e.g. number | User) → dynamic
      return { type: "dynamic", nullable: hasNull };
    }

    case SyntaxKind.ArrayType: {
      const arr = node.asKindOrThrow(SyntaxKind.ArrayType);
      const elem = convertTypeNode(arr.getElementTypeNode(), included);
      const elemStr = elem.nullable ? `${elem.type}?` : elem.type;
      return { type: `List<${elemStr}>`, nullable: false };
    }

    case SyntaxKind.TypeLiteral: {
      const literal = node.asKindOrThrow(SyntaxKind.TypeLiteral);
      // Index signature { [k: string]: unknown } → Map
      if (literal.getIndexSignatures().length > 0) {
        return { type: "Map<String, dynamic>", nullable: false };
      }
      // Inline object literal → Map (simplified)
      return { type: "Map<String, dynamic>", nullable: false };
    }

    case SyntaxKind.TypeReference: {
      const ref = node.asKindOrThrow(SyntaxKind.TypeReference);
      const name = ref.getTypeName().getText();
      if (included.has(name)) {
        return { type: `${name}Model`, nullable: false };
      }
      return { type: "dynamic", nullable: true };
    }

    default:
      return { type: "dynamic", nullable: true };
  }
}

// Convert kebab-case TS keys to camelCase Dart names
function toDartName(tsName: string): string {
  return tsName.replace(/-([a-z])/g, (_, c: string) => c.toUpperCase());
}

export function parseInterfaces(sourceFile: SourceFile): DartClass[] {
  const included = extractIncludedInterfaces(sourceFile);
  const classes: DartClass[] = [];

  for (const iface of sourceFile.getInterfaces()) {
    const name = iface.getName();
    if (!included.has(name)) continue;
    if (iface.getTypeParameters().length > 0) continue; // skip generic interfaces

    const fields: DartField[] = [];

    for (const prop of iface.getProperties()) {
      const jsonKey = prop.getName();
      const isOptional = prop.hasQuestionToken();
      const typeNode = prop.getTypeNode();

      let dartType: string;
      let isNullable: boolean;

      if (typeNode) {
        const result = convertTypeNode(typeNode, included);
        dartType = result.type;
        isNullable = result.nullable || isOptional;
      } else {
        dartType = "dynamic";
        isNullable = true;
      }

      fields.push({
        dartName: toDartName(jsonKey),
        jsonKey,
        dartType,
        isNullable,
      });
    }

    classes.push({ name: `${name}Model`, fields });
  }

  return classes;
}

import { SourceFile, SyntaxKind, TypeNode } from "ts-morph";

// Only generate these interfaces as Dart models
const INCLUDE_INTERFACES = new Set([
  "User",
  "Media",
  "Page",
  "PayloadKv",
  "PayloadLockedDocument",
  "PayloadPreference",
  "PayloadMigration",
]);

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

function convertTypeNode(node: TypeNode): { type: string; nullable: boolean } {
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
        const inner = convertTypeNode(nonNull[0]);
        return { type: inner.type, nullable: inner.nullable || hasNull };
      }
      // Multiple non-null types (e.g. number | User) → dynamic
      return { type: "dynamic", nullable: hasNull };
    }

    case SyntaxKind.ArrayType: {
      const arr = node.asKindOrThrow(SyntaxKind.ArrayType);
      const elem = convertTypeNode(arr.getElementTypeNode());
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
      if (INCLUDE_INTERFACES.has(name)) {
        return { type: name, nullable: false };
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
  const classes: DartClass[] = [];

  for (const iface of sourceFile.getInterfaces()) {
    const name = iface.getName();
    if (!INCLUDE_INTERFACES.has(name)) continue;
    if (iface.getTypeParameters().length > 0) continue; // skip generic interfaces

    const fields: DartField[] = [];

    for (const prop of iface.getProperties()) {
      const jsonKey = prop.getName();
      const isOptional = prop.hasQuestionToken();
      const typeNode = prop.getTypeNode();

      let dartType: string;
      let isNullable: boolean;

      if (typeNode) {
        const result = convertTypeNode(typeNode);
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

    classes.push({ name, fields });
  }

  return classes;
}

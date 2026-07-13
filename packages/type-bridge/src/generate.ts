import { Project } from "ts-morph";
import { parseInterfaces } from "./parser.js";
import { generateDartFile } from "./dart-generator.js";
import path from "path";
import { fileURLToPath } from "url";
import fs from "fs";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const payloadGeneratedTypePath =
  "apps/backend/src/cms/types/generated-types.ts";
const flutterTypesPath = "apps/app/lib/models/payload.dart";

export const rootDir = path.resolve(__dirname, "../../..");
export const inputPath = path.join(rootDir, payloadGeneratedTypePath);
export const outputPath = path.join(rootDir, flutterTypesPath);

export function runGenerate(): void {
  const project = new Project({
    skipAddingFilesFromTsConfig: true,
    compilerOptions: { skipLibCheck: true },
  });

  const sourceFile = project.addSourceFileAtPath(inputPath);
  const classes = parseInterfaces(sourceFile);
  const dartCode = generateDartFile(classes);

  fs.mkdirSync(path.dirname(outputPath), { recursive: true });
  fs.writeFileSync(outputPath, dartCode, "utf-8");

  console.log(
    `[type-bridge] Generated ${classes.length} classes → ${flutterTypesPath}`,
  );
  for (const cls of classes) {
    console.log(`  • ${cls.name} (${cls.fields.length} fields)`);
  }
}

import chokidar from "chokidar";
import path from "path";
import { runGenerate, inputPath } from "./generate.js";

console.log(`[type-bridge] Reading: ${inputPath}`);
runGenerate();

console.log(
  `[type-bridge] Watching ${path.basename(inputPath)} for changes...`,
);

chokidar
  .watch(inputPath, {
    ignoreInitial: true,
    awaitWriteFinish: { stabilityThreshold: 200, pollInterval: 100 },
  })
  .on("change", () => {
    console.log(
      `\n[type-bridge] ${path.basename(inputPath)} changed, regenerating...`,
    );
    try {
      runGenerate();
    } catch (err) {
      console.error("[type-bridge] Generation failed:", err);
    }
  });

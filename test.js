const fs = require("fs");

require(__dirname + "/database-designer-language.js");

const testFolder = __dirname + "/test/input";

const testFiles = fs.readdirSync(testFolder);

for(let index=0; index<testFiles.length; index++) {
  const testFile = testFiles[index];
  const testContents = fs.readFileSync(testFolder + "/" + testFile).toString();
  const ast = DatabaseDesignerLanguage.parse(testContents);
  const output = JSON.stringify(ast, null, 2);
  fs.writeFileSync(__dirname + "/test/output/" + testFile.replace(".model", ".json"), output, "utf8");
}

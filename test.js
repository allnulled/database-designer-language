const fs = require("fs");

require(__dirname + "/database-designer-language.js");

const testFolder = __dirname + "/test";

const testFiles = fs.readdirSync(testFolder);

for(let index=0; index<testFiles.length; index++) {
  const testFile = testFiles[index];
  const testContents = fs.readFileSync(testFolder + "/" + testFile).toString();
  const ast = DatabaseDesignerLanguage.parse(testContents);
  console.log(JSON.stringify(ast, null, 2));
}

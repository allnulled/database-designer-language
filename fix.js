const fs = require("fs");

const file = __dirname + "/database-designer-language.js";

const contents = fs.readFileSync(file).toString();

const contents2 = contents.replace("})(this);", "})(typeof window !== 'undefined' ? window : global);")

fs.writeFileSync(file, contents2, "utf8");
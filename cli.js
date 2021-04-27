const filterKey = (k, i, row) => {
  const dv = { w: 1, h: 1, x: 0, y: 0 };
  if (typeof k === "string") {
    if (typeof row[i - 1] === "object") {
      const obj = row[i - 1];
      return [obj.w || 1, obj.h || 1, obj.x || 0, obj.y || 0];
    } else {
      return [1, 1, 0, 0];
    }
  }
  return null;
};

const filterRow = (r) => r.map(filterKey).filter((x) => x);
const filterDesc = (kle) =>
  kle.map((r) => r instanceof Array && r).filter((x) => x);

const fs = require("fs");
const path = require("path");

const MIN_PADDING = 5;

// Non-blocking example with fs.readFile
// const args = process.argv.splice(2);]
const {
  _: [filePath],
  thickness = 3,
  padding = MIN_PADDING,
  rXY,
  rZ,
} = require("minimist")(process.argv.slice(2));

if (filePath) {
  console.log(`Generating case based on ${filePath}`);

  const fileName = path.basename(filePath, ".json");
  const kle = fs.readFileSync(filePath, "utf-8");
  const layout = JSON.stringify(filterDesc(JSON.parse(kle)).map(filterRow));

  if (padding < MIN_PADDING) {
    console.log(
      `Warning: The minimum padding is ${MIN_PADDING}, reset to ${MIN_PADDING}!`
    );
  }

  let result = "";
  result += "include <../scad/case.scad>;" + "\n";
  result += `layout = ${layout};` + "\n";
  result += `print_plates(layout`;
  [thickness, Math.max(padding, MIN_PADDING), rXY, rZ].map((v) => {
    if (v) result += `,${v}`;
  });
  result += ");\n";

  fs.writeFile(`keyboards/${fileName}.scad`, result, function (err) {
    if (err) return console.log(`Error: Can not reslove ${filePath}.`);
    console.log(`Done: Please check {repo_root}/keyboards/${fileName}.scad`);
  });
} else {
  console.log("Missing required arguments: keyboard_layout_editor.json");
}

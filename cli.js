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
  // common
  padding,
  rXY,
  // case
  thickness,
  rZ,
  easyReinforce,
  // lasercut
  pOffset,
  pRadius
} = require("minimist")(process.argv.slice(3));

if (filePath) {
  const type = process.argv[2]

  console.log(`Generating ${type} files based on ${filePath}`);

  const fileName = path.basename(filePath, ".json");
  const kle = fs.readFileSync(filePath, "utf-8");
  const layout = JSON.stringify(filterDesc(JSON.parse(kle)).map(filterRow));

  if (padding < MIN_PADDING) {
    console.log(
      `Warning: The minimum padding is ${MIN_PADDING}, reset to ${MIN_PADDING}!`
    );
  }

  let result = "";
  let params = {}

  if (type === 'lasercut') {
    result += "include <../scad/plates.scad>;" + "\n";
    result += `layout = ${layout};` + "\n";
    result += `laser_cut_plates(layout`;

    if (pOffset) {
      let tmp = pOffset.split(',')
      if (tmp.length !== 9 ) {
        console.log('invalid pOffest length')
        return
      }
      if (!tmp.every(x => x >= 0) ) {
        console.log('invalid pOffest value')
        return
      }
    }
  
    params = {
      padding: Math.max(padding, MIN_PADDING),
      rXY,
      curved_plates_offsets: pOffset && `[${pOffset}]`,
      pRadius
    };
  }

  if (type === 'case') {
    result += "include <../scad/case.scad>;" + "\n";
    result += `layout = ${layout};` + "\n";
    result += `print_plates(layout`;
  
    params = {
      thickness,
      padding: Math.max(padding, MIN_PADDING),
      rXY,
      rZ,
      easyReinforce,
    };
  }
  

  Object.keys(params).map((k) => {
    if (params[k]) result += `,${k}=${params[k]}`;
  });
  result += ");\n";

  fs.writeFile(`keyboards/${fileName}_${type}.scad`, result, function (err) {
    if (err) return console.log(`Error: Can not reslove ${filePath}.`);
    console.log(`Done: Please check {repo_root}/keyboards/${fileName}_${type}.scad`);
  });
} else {
  console.log("Missing required arguments: keyboard_layout_editor.json");
}

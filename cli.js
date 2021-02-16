const filterKey = (k, i, row) => {
  const dv = { w: 1, h:1, x: 0, y: 0 }
  if (typeof k === "string") {
    if (typeof row[i-1] === 'object') {
      const obj = row[i-1]
      return [obj.w || 1, obj.h || 1, obj.x || 0, obj.y || 0]
    } else {
      return [1, 1, 0, 0]
    }
  }
  return null
}

const filterRow = (r) =>  r.map(filterKey).filter(x => x)
const filterDesc = (kle) => kle.map(r => r instanceof Array && r).filter(x => x)

const fs = require('fs');
const path = require('path');

// Non-blocking example with fs.readFile
// const args = process.argv.splice(2);]
const {
  _: [cliType, filePath],
  angle = 6,
  padding = 10,
  top = 6,
  reinforce = 3.5,
  middle = 6,
  bottom = 0
} = require('minimist')(process.argv.slice(2));

console.log('Using ' + filePath);
console.log('Generating ' + cliType)

const fileName = path.basename(filePath, '.json');
const kle = fs.readFileSync(filePath, 'utf-8');
const layout = JSON.stringify(filterDesc(JSON.parse(kle)).map(filterRow));

let result = ''

result += 'use <../utils.scad>;' + '\n'
result += `layout = ${layout};` + '\n'
if (cliType === 'case') result += `case(layout,${angle},${padding},${top},${reinforce},${middle},${bottom});` + '\n'
if (cliType === 'plate') result += 'plate(layout);' + '\n'

fs.writeFile(`scad/result/${fileName}_${cliType}.scad`, result, function (err) {
  if (err) return console.log(err);
  console.log('Done');
});
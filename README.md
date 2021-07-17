## Open source GH60 case

These are scripts that generate case/plate for gh60 compactible PCB, including

- top frame
- reinforce frame
- thick structural frame
- angled bottom block
- switch plate (optional, can use other generic plate)

This is designed to be

- [x] laser-cut-able
- [x] Sandwiched by screws with muliple layers

### How to use

cli

```
  yarn case <your_layout_from_keyboard_layout_editor.json>;
  yarn lasercut <your_layout_from_keyboard_layout_editor.json>;

  <!-- case can take some parameters to customize -->
  <!-- The minimum input of padding is 5. -->
  <!-- When padding is set to 5mm, -->
  <!-- the real padding is 5 - 0.3 * 2 = 4.4mm -->
  <!-- screw hole radius is the default rXY, which is border radius -->
  yarn case test-case/gh60.json --padding 10 --rXY 3 --rZ 1.5
  <!-- or for lasercut files -->
  <!-- pOffset is an array with 9 number -->
  <!-- it adds buffer to each plate -->
  <!-- useful for making stacked case more stereoscopic -->
  yarn lasercut <your_layout_from_keyboard_layout_editor.json> --padding 10 --rXY 3 --pOffset 0,0,0,3,6,9,0,6,3;
  <!-- or less stereoscopic -->
  yarn lasercut <your_layout_from_keyboard_layout_editor.json> --padding 10 --rXY 3 --pOffset 0,0,0,0,0,0,0,0,0;
```

results are placed in {repo_root}/keyboards

### TODO

- [x] Basic scad scripts
- [x] An cli interface
- [x] Any tilted angle by adding extra feet
- [x] lasercut files
- [ ] revamp case.scad with plates.scad
- [ ] Vertical stab
- [ ] Alps switches plate
- [ ] Plate mount stab
- [x] Screws holes (Other assembly methods)
- [ ] An web interface
- [ ] Better docs

## Open source GH60 case

These are scripts that generate case/plate for gh60 compactible PCB, including
- top frame
- reinforce frame
- thick structural frame
- angled bottom block
- switch plate (optional, can use other generic plate)

This is not yet finished, and can only be
- [x] 3D printed
- [x] Machined from a block
- [x] Glued with acrylic layers
- [ ] Sandwiched by screws with muliple layers (TODO)

### How to use
cli
```
  yarn case <your_layout_from_keyboard_layout_editor.json>;
  yarn plate <your_layout_from_keyboard_layout_editor.json>
```

results are placed in scad/result

### TODO

- [x] Basic scad scripts
- [x] An cli interface
- [ ] Vertical stab
- [ ] Alps switches plate
- [ ] Plate mount stab
- [ ] Screws holes (Other assembly methods)
- [ ] An web interface
- [ ] Better docs
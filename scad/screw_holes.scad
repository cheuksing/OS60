// This is a simplified version of a scripts
// Some changes is also made.

// For credits
// Title: ISO/DIN standard Screw Holes
// Author: Carlo Wood
// Date: 26/8/2016
// License: Creative Commons - Share Alike - Attribution


$fn = 32;

M2_dk = 3.8;
M2_dk_r = M2_dk / 2;
M2_d = 2;
M2_d_r = M2_d / 2;
M2_k = 1.2;

// Global variables.
screw_hole_fn = 32;                      // Number of segments for a full circle.
screw_hole_length_extend = 0.1;          // Extra length of the non-threaded part of the screw hole.
screw_hole_height_extend = 0.1;          // Extra distance the hole extends above the surface.
screw_hole_cylinderhead_spacing = 0.1;   // Extra radius of hole around screw head.
screw_hole_countersunk_delta = 0.1;      // Extra depth of countersunk screw hole.

// also works for radius
function get_hole_dia(d = M2_d, fn = $fn) = d / cos(180 / fn);

module hole(r) {
  circle(get_hole_dia(r));
}

module screw_hole (d = M2_d, dk = M2_dk, k = M2_k, l = 10, fn = $fn) {
  tt = 2;	// Ratio between base and height of cone.
  pk = d / tt;
  ch = pk + (k + screw_hole_countersunk_delta) + screw_hole_height_extend;
  cb = ch * tt;

  translate ([0, 0, -screw_hole_height_extend]) {
    cylinder(h = l + screw_hole_height_extend, d = get_hole_dia(d));
    cylinder(d1 = get_hole_dia(cb), d2 = get_hole_dia(d), h = ch - (d / tt));
  }
}

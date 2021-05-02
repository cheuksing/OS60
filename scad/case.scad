include <./polyround.scad>;
include <./screw_holes.scad>;

$fn=14;
// I don't want to do calculations
big_value = 100;
border_buffer = 0.3;

key_size = 19.05;

gh60_dim = [285, 94.6];

gh60_holes_radius = 2.5;

default_layout = [[[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[2,1,0,0]],[[1.5,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1.5,1,0,0]],[[1.75,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[2.25,1,0,0]],[[2.25,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[2.75,1,0,0]],[[1.25,1,0,0],[1.25,1,0,0],[1.25,1,0,0],[6.25,1,0,0],[1.25,1,0,0],[1.25,1,0,0],[1.25,1,0,0],[1.25,1,0,0]]];

function holes_offset(padding) = (padding - border_buffer) / 2 + border_buffer;

function holes_array(padding) = [
	// left-top
	[0 - holes_offset(padding), 0 - holes_offset(padding)],
	// middle-top
	[gh60_dim[0] + holes_offset(padding), 0 - holes_offset(padding)],
	// right-top
	[(gh60_dim[0] + 2 * holes_offset(padding)) / 2, 0 - holes_offset(padding)],
	// left-bottom
	[0 - holes_offset(padding), gh60_dim[1] + holes_offset(padding)],
	// middle-bottom
	[gh60_dim[0] + holes_offset(padding), gh60_dim[1] + holes_offset(padding)],
	// right-bottom
	[(gh60_dim[0] + 2 * holes_offset(padding)) / 2, gh60_dim[1] + holes_offset(padding)],
];

module screws_cutoff (holes_radius = gh60_holes_radius) {
	holes = [
		[25.2, 27.9],
		[gh60_dim[0] - 24.95, 26.9],
		[128.2, 47],
		[190.5, 85.2]
	];

	for (i = holes) {
		translate([i[0],i[1], 0])
			circle(holes_radius);
	}

	translate([1.5, 56.5])
	hull() {
		translate([-3.5, 0, 0])
			circle(holes_radius);
			circle(holes_radius);
	}

	translate([gh60_dim[0] - 1.5, 56.5])
	hull() {
		translate([3.5, 0, 0])
			circle(holes_radius);
			circle(holes_radius);
	}
};

module button_cutoff (width = 11, height = 12) {
	mid = [25.2 + 3.95, 20.3 + 27.9];
	polygon([
		[mid[0] - (width / 2), mid[1] - (height / 2)],
		[mid[0] + (width / 2), mid[1] - (height / 2)],
		[mid[0] + (width / 2), mid[1] + (height / 2)],
		[mid[0] - (width / 2), mid[1] + (height / 2)]
	]);
}

module usb_cutoff (padding) {
	// a 12 x padding is cutted
	width = 12;
	// height = 15;
	mid = 25.2 - 7;
	right = mid + (width / 2);
	left = mid - (width / 2);

	polygon([
		[left, - padding],
		[right, - padding],
		[right, 0],
		[left, 0]
	]);
}

module front_feet_border (outline, rXY = 0) {
	polygon(
		polyRound([
			[0 - outline, 0 - outline, rXY],
			[gh60_dim[0] + outline, 0 - outline, rXY],
			[gh60_dim[0] + outline, 20 - outline, rXY],
			[0 - outline, 20 - outline, rXY],
		])
	);
};

module back_feet_border (outline, rXY = 0) {
	polygon(
		polyRound([
			[0 - outline, gh60_dim[1] + outline, rXY],
			[gh60_dim[0] + outline, gh60_dim[1] + outline, rXY],
			[gh60_dim[0] + outline, gh60_dim[1] + outline - 20, rXY],
			[0 - outline, gh60_dim[1] + outline - 20, rXY],
		])
	);
};

module front_feet_border_with_holes (padding, outline, rXY = M2_dk_r, feet_num = 4) {
	difference () {
		front_feet_border (outline);

		ha = holes_array(padding);
		bp = (ha[2][0] - ha[0][0]) / feet_num;
		for (i = [ 1 : feet_num - 1 ] ) {
			translate([ha[0][0] + bp * i, 0 - outline + 10])
				circle(6);
			translate([ha[2][0] + bp * i, 0 - outline + 10])
				circle(6);
		}
	}
}

module back_feet_border_with_holes (padding, outline, rXY = M2_dk_r, feet_num = 4) {
	ha = holes_array(padding);
	bp = (ha[5][0] - ha[3][0]) / feet_num;

	difference () {
		back_feet_border (outline);

		for (i = [ 1 : feet_num - 1 ] ) {
			translate([ha[3][0] + bp * i, gh60_dim[1] + outline - 10])
				circle(6);
			translate([ha[5][0] + bp * i, gh60_dim[1] + outline - 10])
				circle(6);
		}
	}
}

module feets_extends (thickness, padding, rXY = M2_dk_r, rZ = 1.5) {
	outline =  padding + max(rXY, rZ);

	linear_extrude(thickness)
		difference () {
			union () {
				front_feet_border(outline);
				back_feet_border(outline);
			}
				structural_nuts(thickness, padding, M2_d);
		}
}

module feets (thickness, padding, rXY = M2_dk_r, rZ = 1.5) {
	outline =  padding + max(rXY, rZ);

	union () {
		linear_extrude(thickness)
			front_feet_border_with_holes(padding, outline, rXY);

		linear_extrude(thickness)
			back_feet_border_with_holes(padding, outline, rXY);
	}
}

module feets_plate(thickness, padding, rXY = M2_dk_r, rZ = 1.5) {
	outline =  padding + max(rXY, rZ);

	union() {
		extrudeWithRadius(thickness, rZ, rZ, 3) {
		// linear_extrude(thickness) {
			union () {
				front_feet_border(outline, rXY);
				back_feet_border(outline, rXY);
			}
		}
	}
}

module border (padding = 0, rXY = 0) {
	polygon(
		polyRound([
			[0 - padding, 0 - padding, rXY],
			[gh60_dim[0] + padding, 0 - padding, rXY],
			[gh60_dim[0] + padding, gh60_dim[1] + padding, rXY],
			[0 - padding, gh60_dim[1] + padding, rXY]
		])
	);
};

function getCenterX(list, c = 0, stop) = 
 c < len(list) - 1 && c < stop
  ? list[c][0] + list[c][2] + getCenterX(list, c + 1, stop) 
  : list[c][0] / 2 + list[c][2];

function getCenterY(list, c = 0, stop, k) = 
 c < len(list) - 1 && c < stop
  ? 1 + list[c][0][3] + getCenterY(list, c + 1, stop, k) 
  : list[c][k][1] / 2 + list[c][0][3];

stabs = [
	// 2u measured
	11.90,
	// 3u from swillkb
	19.05,
	// 6.25u from swillkb
	50,
	// 7u  from swillkb
	57.15
];

stabs_hole = [7, 16];

function _stabWidth(x, y, i, w, h) = [
	x - stabs[i] - w / 2,
	x + stabs[i] + w / 2,
	y - h / 2,
	y + h / 2
];

function _stabPath(left, right, top, bottom, w) = [
	[
		[left, top],
		[left + w, top],
		[left + w, bottom],
		[left, bottom]
	],
	[
		[right, top],
		[right - w, top],
		[right - w, bottom],
		[right, bottom]
	]
];

module  cut_stabs (x, y, i, hole = stabs_hole) {
	w = hole[0];
	h = hole[1];
	s = _stabWidth(x, y, i, w, h);
	p = _stabPath(s[0], s[1], s[2], s[3], w);
	polygon(p[0]);
	polygon(p[1]);
}

module cut_key (layout = default_layout, size = 14, simpleStab = false) {
	for (r = [ 0 : len(layout) - 1 ] ) {
		row = layout[r];
		for (k = [ 0 : len(row) - 1 ] ) {
			key = row[k];
			w = key[0];
			h = key[1];
			x_off = key[2];
			y_off = key[3];
			centerX = (getCenterX(row, 0, k)) * key_size;
			centerY = (getCenterY(layout, 0, r, k)) * key_size;
			translate([centerX, centerY, 0])
				square(size, true);

			// stab rect 7 x 16
			if (w >= 7) {
				cut_stabs(centerX, centerY, 3, simpleStab ? [stabs_hole[0] + 3, stabs_hole[1] + 2.5] : stabs_hole);
			} else if (w >= 6.25) {
				cut_stabs(centerX, centerY, 2, simpleStab ? [stabs_hole[0] + 3, stabs_hole[1] + 2.5] : stabs_hole);
			} else if (w >= 3) {
				cut_stabs(centerX, centerY, 1, simpleStab ? [stabs_hole[0] + 3, stabs_hole[1] + 2.5] : stabs_hole);
			} else if (w >= 2) {
				cut_stabs(centerX, centerY, 0, simpleStab ? [stabs_hole[0] + 3, stabs_hole[1] + 2.5] : stabs_hole);
			}
		}
	}
}

module plate (layout = default_layout, thickness=1.5) {
	difference() {
		linear_extrude(thickness)
			difference() {
				border(0);
				screws_cutoff();
				cut_key(layout);
			}
	}
}

module usb_frame (thickness, padding, outline) {
	linear_extrude(thickness)
	difference() {
		border(outline);
		border(border_buffer);
		usb_cutoff(outline);
		structural_nuts(thickness, padding);
	}
}

module topest_frame (thickness, padding, outline) {
	linear_extrude(thickness)
	difference() {
		border(outline);
		border(border_buffer);
	}
}

module top_frame (thickness, padding, outline) {
	linear_extrude(thickness)
	difference() {
		border(outline);
		border(border_buffer);
		structural_nuts(thickness, padding);
	}
}

module reinforce(layout = default_layout, thickness, padding, outline) {
	linear_extrude(thickness)
	difference() {
		border(outline);

		button_cutoff(key_size, 12);
		screws_cutoff(M2_d_r);
		// 15.6, see mx spec
		// moded to 16.8 for cleaner stab cutoff
		cut_key(layout, 16.8, true);

		structural_nuts(thickness, padding);
	}
}

module bottom_plate(thickness, padding, outline) {
	linear_extrude(thickness)
		difference() {
			border(outline);
			structural_nuts(thickness, padding, M2_d);
		}
}

module flat_plate(thickness=10, padding = 10, rXY = M2_dk_r, rZ = 1.5) {
	union() {
		extrudeWithRadius(thickness, rZ, rZ, 3)
		// linear_extrude(thickness)
		border(padding, rXY);
	}
}

function get_plate_z(k, thickness, seperator) = - k * (thickness + seperator);

colors = [
	"#686868",
	"#ff5c57",
	"#5af78e",
	"#f3f99d",
	"#57c7ff",
	"#ff6ac1",
	"#9932CC",
	"#eff0eb",
];

module print_plates(layout = default_layout, thickness = 3, padding = 10, rXY = M2_dk_r, rZ = 1.5, seperator = 10) {
	plates = [7, 6, 5, 4, 4, 3, 2, 1, 0];
	// plates = [7, 6, 5, 4, 4, 3, 1, 0];
	outline =  padding + max(rXY, rZ);

	for (k = [ 0 : len(plates) - 1 ] ) {
		p = plates[k];

		translate([0, 0, get_plate_z(k, thickness, seperator)]) {
			if (p <= 5) {
				intersection() {
					translate([0, 0, -0.01])
						color(colors[p]) flat_plate(thickness + 0.02, outline + 0.01, rXY, rZ);

					if (p == 0) {
						difference () {
							color(colors[p]) topest_frame(thickness, padding, outline);
							structural_screws(thickness, padding);
						}
					} else if (p == 1) {
						color(colors[p]) top_frame(thickness, padding, outline);
					} else if (p == 2) color(colors[p]) plate(layout, 1.5);
					else if (p == 3) {
						color(colors[p]) reinforce(layout, thickness, padding, outline);
					} else if (p == 4) {
						color(colors[p]) usb_frame(thickness, padding, outline);
					} else if (p == 5) {
						color(colors[p]) bottom_plate(thickness, padding, outline);
					}
				}
			} else {
				intersection () {
					translate([0, 0, -0.01])
						color(colors[p]) feets_plate(thickness + 0.02, padding + 0.01, rXY, rZ);
					
					if (p == 6) {
						color(colors[p]) feets_extends(thickness, padding, rXY, rZ);
					} else if (p == 7) {
						difference () {
							color(colors[p]) feets(thickness, padding, rXY, rZ);
							structural_screws(thickness, padding, true);
						}
					}
				}
			}
		}
	}
}

module flat_head_M2 () {
	screw_hole(l = 10, fn = $fn);
}

module structural_screws (thickness, padding, flip) {
	holes = holes_array(padding);

	for (i = holes) {
		translate([i[0],i[1], flip ? thickness : 0]) {
			if (flip == true) {
				rotate([0, 180, 0])
				flat_head_M2();
			} else {
				flat_head_M2();
			}
		}
	}
}

module structural_nuts (thickness, padding, d = M2_dk) {
	for (i = holes_array(padding)) {
		translate([i[0], i[1]]) {
			circle(d = d);
		}
	}
}
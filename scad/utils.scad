include <./polyround.scad>;
include <./screw_holes.scad>;

$fn=8;
// I don't want to do calculations
big_value = 100;
border_buffer = 0.3;

key_size = 19.05;

gh60_dim = [285, 94.6];

gh60_holes_radius = 2.5;

default_layout = [[[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[2,1,0,0]],[[1.5,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1.5,1,0,0]],[[1.75,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[2.25,1,0,0]],[[2.25,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[2.75,1,0,0]],[[1.25,1,0,0],[1.25,1,0,0],[1.25,1,0,0],[6.25,1,0,0],[1.25,1,0,0],[1.25,1,0,0],[1.25,1,0,0],[1.25,1,0,0]]];

M2_hole_dk_r=screw_standard[ISO2009][screw_hole_dk][M2] / 2;
M2_hole_d_r=screw_standard[ISO2009][screw_hole_d][M2] / 2;

function holes_offset(padding) = (padding - border_buffer) / 2;

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

module front_feet_border (padding = 0, rXY = M2_hole_dk_r) render() {
	polygon(
		polyRound([
			[0 - padding, 0 - padding, rXY],
			[gh60_dim[0] + padding, 0 - padding, rXY],
			[gh60_dim[0] + padding, 20 - padding, rXY],
			[0 - padding, 20 - padding, rXY]
		])
	);
};

module back_feet_border (padding = 0, rXY = M2_hole_dk_r) render() {
	polygon(
		polyRound([
			[0 - padding, gh60_dim[1] + padding, rXY],
			[gh60_dim[0] + padding, gh60_dim[1] + padding, rXY],
			[gh60_dim[0] + padding, gh60_dim[1] + padding - 20, rXY],
			[0 - padding, gh60_dim[1] + padding - 20, rXY]
		])
	);
};

module front_feet_border_with_holes (padding = 0, rXY = M2_hole_dk_r, feet_num = 0) {
	difference () {
		front_feet_border (padding, rXY);

		if (feet_num > 0) {
			ha = holes_array(padding);
			bp = (ha[2][0] - ha[0][0]) / feet_num;
			for (i = [ 1 : feet_num - 1 ] ) {
				translate([ha[0][0] + bp * i, ha[0][1] + (20 - padding) / 2])
					circle(6);
				translate([ha[2][0] + bp * i, ha[0][1] + (20 - padding) / 2])
					circle(6);
			}
		}
	}
}

module back_feet_border_with_holes (padding = 0, rXY = M2_hole_dk_r, feet_num = 0) {
	difference () {
		back_feet_border (padding, rXY);

		if (feet_num > 0) {
			ha = holes_array(padding);
			bp = (ha[5][0] - ha[3][0]) / feet_num;
			for (i = [ 1 : feet_num - 1 ] ) {
				translate([ha[3][0] + bp * i, ha[3][1] - (20 - padding) / 2])
					circle(6);
				translate([ha[5][0] + bp * i, ha[3][1] - (20 - padding) / 2])
					circle(6);
			}
		}
	}
}

module feets (thickness=10, padding = 10, rXY = M2_hole_dk_r, rZ = 1.5, isBottom = false) render() {
	offset =  padding + rXY + rZ;

	intersection () {
		extrudeWithRadius(thickness, rZ, rZ, $fn)
			front_feet_border(offset, rXY);

		if (!isBottom) bottom_plate(thickness, offset, M2_hole_d_r);

		linear_extrude(thickness)
			front_feet_border_with_holes(offset, rXY, isBottom ? 4 : 0);
	}

	intersection () {
		extrudeWithRadius(thickness, rZ, rZ, $fn)
			back_feet_border(offset, rXY);

		if (!isBottom) bottom_plate(thickness, offset, M2_hole_d_r);

		linear_extrude(thickness)
			back_feet_border_with_holes(offset, rXY, isBottom ? 4 : 0);
	}
}

module border (padding = 0, round = 0) render() {
	polygon(
		polyRound([
			[0 - padding, 0 - padding, round],
			[gh60_dim[0] + padding, 0 - padding, round],
			[gh60_dim[0] + padding, gh60_dim[1] + padding, round],
			[0 - padding, gh60_dim[1] + padding, round]
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
				cut_stabs(centerX, centerY, 3, simpleStab ? [stabs_hole[0] + 3, stabs_hole[1] + 1.8] : stabs_hole);
			} else if (w >= 6.25) {
				cut_stabs(centerX, centerY, 2, simpleStab ? [stabs_hole[0] + 3, stabs_hole[1] + 1.8] : stabs_hole);
			} else if (w >= 3) {
				cut_stabs(centerX, centerY, 1, simpleStab ? [stabs_hole[0] + 3, stabs_hole[1] + 1.8] : stabs_hole);
			} else if (w >= 2) {
				cut_stabs(centerX, centerY, 0, simpleStab ? [stabs_hole[0] + 3, stabs_hole[1] + 1.8] : stabs_hole);
			}
		}
	}
}

module plate (layout = default_layout, thickness=1.5) {
	difference() {
		// extrudeWithRadius(thickness, 0.2, 0.2, 5)
		linear_extrude(thickness)
			difference() {
				border(0);
				screws_cutoff();
				cut_key(layout);
			}
	}
}

module usb_frame (thickness=10, padding = 10) render() {
	linear_extrude(thickness)
	difference() {
		border(padding);
		border(border_buffer);
		usb_cutoff(padding);
		structural_nuts(thickness, padding);
	}
}

module top_frame (thickness=10, padding = 10, mid_frame = false) render() {
	linear_extrude(thickness)
	difference() {
		border(padding);
		border(border_buffer);
		if (mid_frame == true) structural_nuts(thickness, padding);
	}
}

module reinforce(layout = default_layout, thickness=10, padding = 10) render() {
	linear_extrude(thickness)
	difference() {
		// extrudeWithRadius(thickness, 0.2, 0.2, 5)
		border(padding);

		button_cutoff(key_size, 12);
		screws_cutoff(screw_hole_d[M2] / 2);
		// 15.6, see mx spec
		// moded to 16.8 for cleaner stab cutoff
		cut_key(layout, 16.8, true);

		structural_nuts(thickness, padding);
	}
}

module bottom_plate(thickness=10, padding = 10) {
	linear_extrude(thickness)
		difference() {
			border(padding);
			structural_nuts(thickness, padding, screw_hole_d);
		}
}

module flat_plate(thickness=10, padding = 10, rXY = M2_hole_dk_r, rZ = 1.5) render() {
	// linear_extrude(thickness)
	extrudeWithRadius(thickness, rZ, rZ, $fn)
		border(padding + rXY + rZ, rXY);
}

function get_plate_z(k, thickness, seperator) = - k * (thickness + seperator);

module print_plates(layout = default_layout, thickness = 3, padding = 10, rXY = M2_hole_dk_r, rZ = 1.5, seperator = 10) {
	plates = [5, 5, 4, 3, 3, 2, 1, 0, 0];
	offset =  padding + rXY + rZ;

	difference() {
		for (k = [ 0 : len(plates) - 1 ] ) {
			p = plates[k];

			translate([0, 0, get_plate_z(k, thickness, seperator)]) {
				if (p == 0) {
					intersection () {
						top_frame(thickness, offset, k != len(plates) - 1);
						flat_plate(thickness, padding);
					}
				} else if (p == 1) plate(layout, 1.5);
				else if (p == 2) {
					intersection () {
						reinforce(layout, thickness, offset);
						flat_plate(thickness, padding);
					}
				} else if (p == 3) {
					intersection () {
						usb_frame(thickness, offset);
						flat_plate(thickness, padding);
					}
				} else if (p == 4) {
					intersection () {
						bottom_plate(thickness, offset);
						flat_plate(thickness, padding);
					}
				} else if (p == 5) {
					feets(thickness, padding, rXY, rZ, k == 0);
				}
			}
		}

		translate([0, 0, get_plate_z(0, thickness, seperator)])
			structural_screws(thickness, offset, true);

		translate([0, 0, get_plate_z(len(plates) - 1, thickness, seperator)])
			structural_screws(thickness, offset);
	}
}

module flat_head_M2 () render () {
	screw_hole(ISO2009, M2, 10, 0, $fn);
}

module structural_screws (thickness, padding, isTop) {
	holes = holes_array(padding);

	for (i = holes) {
		translate([i[0],i[1], isTop ? thickness : 0]) {
			if (isTop == true) {
				rotate([0, 180, 0])
				flat_head_M2();
			} else {
				flat_head_M2();
			}
		}
	}
}

module structural_nuts (thickness, padding, r = M2_hole_dk_r) {
	for (i = holes_array(padding)) {
		translate([i[0], i[1]]) {
			circle(r);
		}
	}
}
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

function holes_offset(padding) = (padding) / 2 + border_buffer;

function holes_array(padding) = [
	// left-top
	[0 - holes_offset(padding), 0 - holes_offset(padding)],
	// middle-top
	[(gh60_dim[0] + holes_offset(padding) * 2) / 2, 0 - holes_offset(padding)],
	// right-top
	[gh60_dim[0] + holes_offset(padding), 0 - holes_offset(padding)],
	// left-bottom
	[0 - holes_offset(padding), gh60_dim[1] + holes_offset(padding)],
	// middle-bottom
	[(gh60_dim[0] + holes_offset(padding) * 2) / 2, gh60_dim[1] + holes_offset(padding)],
	// right-bottom
	[gh60_dim[0] + holes_offset(padding), gh60_dim[1] + holes_offset(padding)],
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
			hole(holes_radius);
	}

	translate([1.5, 56.5])
	hull() {
		translate([-3.5, 0, 0])
			hole(holes_radius);
			hole(holes_radius);
	}

	translate([gh60_dim[0] - 1.5, 56.5])
	hull() {
		translate([3.5, 0, 0])
			hole(holes_radius);
			hole(holes_radius);
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

module usb_cutoff (padding, innerPadding = 0) {
	// a 12 x padding is cutted
	width = 12;
	// height = 15;
	mid = 25.2 - 7;
	right = mid + (width / 2);
	left = mid - (width / 2);

	polygon([
		[left, - padding],
		[right, - padding],
		[right, innerPadding],
		[left, innerPadding]
	]);
}

function get_front_feet_border(padding) = [
	[0 - padding, 0 - padding],
	[gh60_dim[0] + padding, 0 - padding],
	[gh60_dim[0] + padding, 20 - padding],
	[0 - padding, 20 - padding],
];

function get_back_feet_border(padding) = [
	[0 - padding, gh60_dim[1] + padding],
	[gh60_dim[0] + padding, gh60_dim[1] + padding],
	[gh60_dim[0] + padding, gh60_dim[1] + padding - 20],
	[0 - padding, gh60_dim[1] + padding - 20],
];

module front_feet_border (padding) {
	polygon(get_front_feet_border(padding));
}

module back_feet_border (padding) {
	polygon(get_back_feet_border(padding));
}

module front_feet_border_with_holes (padding, outline, feet_num = 4) {
	difference () {
		front_feet_border(outline);

		ha = holes_array(padding);
		bp = (ha[1][0] - ha[0][0]) / feet_num;
		for (i = [ 1 : feet_num - 1 ] ) {
			translate([ha[0][0] + bp * i, 0 - outline + 10])
				hole(6);
			translate([ha[1][0] + bp * i, 0 - outline + 10])
				hole(6);
		}
	}
}

module back_feet_border_with_holes (padding, outline, feet_num = 4) {
	ha = holes_array(padding);
	bp = (ha[1][0] - ha[0][0]) / feet_num;

	difference () {
		back_feet_border (outline);

		for (i = [ 1 : feet_num - 1 ] ) {
			translate([ha[3][0] + bp * i, gh60_dim[1] + outline - 10])
				hole(6);
			translate([ha[4][0] + bp * i, gh60_dim[1] + outline - 10])
				hole(6);
		}
	}
}

function add_rXY(l, rXY = 0) = [
	[l[0][0], l[0][1], rXY],
	[l[1][0], l[1][1], rXY],
	[l[2][0], l[2][1], rXY],
	[l[3][0], l[3][1], rXY],
];

function get_border(padding = 0) = [
	[0 - padding, 0 - padding],
	[gh60_dim[0] + padding, 0 - padding],
	[gh60_dim[0] + padding, gh60_dim[1] + padding],
	[0 - padding, gh60_dim[1] + padding]
];

module border (padding = 0, rXY = 0) {
	polygon(
		polyRound(add_rXY(get_border(padding), rXY))
	);
}

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

module cut_key (layout = default_layout, size = 14, isReinforce = false) {
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

			large_holes = [stabs_hole[0] + 3, stabs_hole[1] + 2.5];

			stabIndex = w >= 7 ? 3 : w >= 6.25 ? 2 : w >= 3 ? 1 : 0;
			// stab rect 7 x 16
			if (w >= 7) {
				cut_stabs(centerX, centerY, stabIndex, isReinforce ? large_holes : stabs_hole);
			} else if (w >= 6.25) {
				cut_stabs(centerX, centerY, stabIndex, isReinforce ? large_holes : stabs_hole);
			} else if (w >= 3) {
				cut_stabs(centerX, centerY, stabIndex, isReinforce ? large_holes : stabs_hole);
			} else if (w >= 2) {
				cut_stabs(centerX, centerY, stabIndex, isReinforce ? large_holes : stabs_hole);
			}

			if (w >= 2 && isReinforce) {
				s = _stabWidth(centerX, centerY, stabIndex, large_holes[0], large_holes[1]);

				// extra space for stab wires
				polygon([
					[s[0], centerY - 16],
					[s[1], centerY - 16],
					[s[1], centerY],
					[s[0], centerY],
				]);
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

module structural_nuts (padding, d = M2_dk) {
	for (i = holes_array(padding)) {
		translate([i[0], i[1]]) {
			hole(d / 2);
		}
	}
}

function get_plate_z(k, thickness, seperator) = - k * (thickness + seperator);

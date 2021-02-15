include <Round-Anything/polyround.scad>;

key_size = 19.05;

gh60_dim = [285, 94.6];

gh60_holes_radius = 2.5;

default_layout = [[[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[2,1,0,0]],[[1.5,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1.5,1,0,0]],[[1.75,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[2.25,1,0,0]],[[2.25,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[1,1,0,0],[2.75,1,0,0]],[[1.25,1,0,0],[1.25,1,0,0],[1.25,1,0,0],[6.25,1,0,0],[1.25,1,0,0],[1.25,1,0,0],[1.25,1,0,0],[1.25,1,0,0]]];

module screws_cutoff (holes_radius = gh60_holes_radius) {
	holes = [
		[25.2, 27.9],
		[gh60_dim[0] - 24.95, 26.9],
		[128.2, 47],
		[190.5, 85.2]
	];

	union () {
		for (i = holes) {
			translate([i[0],i[1], 0])
				circle(holes_radius, $fn = 50);
		}

		translate([1.5, 56.5])
		hull() {
			translate([-3.5, 0, 0])
				circle(holes_radius, $fn = 50);
				circle(holes_radius, $fn = 50);
		}

		translate([gh60_dim[0] - 1.5, 56.5])
		hull() {
			translate([3.5, 0, 0])
				circle(holes_radius, $fn = 50);
				circle(holes_radius, $fn = 50);
		}
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

module usb_cutoff (frame_width) {
	// a 12 x 15 is cutted
	width = 12;
	height = 15;
	mid = 25.2 - 7;
	right = mid + (width / 2);
	left = mid - (width / 2);

	if (frame_width == undef) {
		polygon([
			[left, 0],
			[right, 0],
			[right, height],
			[left, height]
		]);
	} else {
		polygon([
			[left, - frame_width],
			[right, - frame_width],
			[right, 0],
			[left, 0]
		]);
	}
}

module border (padding = 0, round = 0) {
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

function getCenterY(list, c = 0, stop) = 
 c < len(list) - 1 && c < stop
  ? list[c][0][1] + list[c][0][3] + getCenterY(list, c + 1, stop) 
  : list[c][0][1] / 2 + list[c][0][3];

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

function _stabWidth(x, y, i) = [
	x - stabs[i] - 3.5,
	x + stabs[i] + 3.5,
	y - 8,
	y + 8
];

function _stabPath(left, right, top, bottom) = [
	[
		[left, top],
		[left + 7, top],
		[left + 7, bottom],
		[left, bottom]
	],
	[
		[right, top],
		[right - 7, top],
		[right - 7, bottom],
		[right, bottom]
	]
];

module  cut_stabs  (x, y, i) {
	s = _stabWidth(x, y, i);
	p = _stabPath(s[0], s[1], s[2], s[3]);
	polygon(p[0]);
	polygon(p[1]);
}

module cut_key (layout = default_layout, size = 14) {
	for (r = [ 0 : len(layout) - 1 ] ) {
		row = layout[r];
		for (k = [ 0 : len(row) - 1 ] ) {
			key = row[k];
			w = key[0];
			h = key[1];
			x_off = key[2];
			y_off = key[3];
			centerX = (getCenterX(row, 0, k)) * key_size;
			centerY = (getCenterY(layout, 0, r)) * key_size;
			translate([centerX, centerY, 0])
				square(size, true);

			// stab rect 7 x 16
			if (w >= 7) {
				cut_stabs(centerX, centerY, 3);
			} else if (w >= 6.25) {
				cut_stabs(centerX, centerY, 2);
			} else if (w >= 3) {
				cut_stabs(centerX, centerY, 1);
			} else if (w >= 2) {
				cut_stabs(centerX, centerY, 0);
			}
		}
	}
}

module plate (layout = default_layout, thickness=1.5) {
	difference() {
		extrudeWithRadius(thickness, 0.2, 0.2, 5)
			border(0, 2);
		translate([0, 0, -1]) {
			linear_extrude(thickness + 2) {
				union () {
					screws_cutoff();
					cut_key(layout);
				}
			}
		}
	}
}

module base (layout = default_layout, angle = 10, height=5, padding = 10) {
	difference() {
		translate([- padding, 0, 0])
		rotate([90, 0, 90])
		linear_extrude(gh60_dim[0] + padding * 2)
		polygon([
			[- padding, 0],
			[gh60_dim[1] + padding, 0],
			[gh60_dim[1] + padding, height],
			[- padding, gh60_dim[1] * sin(angle) + height]
		]);

		linear_extrude(gh60_dim[0] + padding * 2)
		border(2);
	}
}

module usb_frame (thickness=10, padding = 10) {
	linear_extrude(thickness)
	difference() {
		border(padding);
		border(2);
		usb_cutoff(padding);
	}
}

module top_frame (thickness=10, padding = 10) {
	linear_extrude(thickness)
	difference() {
		border(padding);
		border(2);
	}
}

module reinforce(layout = default_layout, thickness=10, padding = 10) {
	difference() {
		linear_extrude(thickness)
		// extrudeWithRadius(thickness, 0.2, 0.2, 5)
			border(padding, 0);
		translate([0, 0, -1]) {
			linear_extrude(thickness + 2) {
				union () {
					button_cutoff();
					screws_cutoff();
					// 15.6, see mx spec
					// moded to 16.8 for cleaner stab cutoff
					cut_key(layout, 16.8);
					// usb_cutoff(padding);
				}
			}
		}
	}
}

module case(layout = default_layout, angle = 6, top = 6, bottom = 0, usb = 6, rein = 3.5) {
	render () {
		layers = [5, 3.5, 6];
		translate([0, 0, - usb - rein - top])
			top_frame(top);
		translate([0, 0, - usb - rein])
			reinforce(default_layout, rein);
		translate([0, 0, - usb])
			usb_frame(usb);

		base(default_layout, angle, bottom);
	}
}

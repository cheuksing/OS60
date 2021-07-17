include <./utils.scad>;
include <./plates.scad>;

module feets_extends (thickness, padding, rXY = M2_dk_r, rZ = 1.5) {
	outline =  padding + max(rXY, rZ);

	linear_extrude(thickness, convexity = 10)
		difference () {
			union () {
				front_feet_border(outline);
				back_feet_border(outline);
			}
				structural_nuts(padding, M2_d);
		}
}

module feets (thickness, padding, rXY = M2_dk_r, rZ = 1.5) {
	outline =  padding + max(rXY, rZ);

	union () {
		linear_extrude(thickness, convexity = 10)
			front_feet_border_with_holes(padding, outline);

		linear_extrude(thickness, convexity = 10)
			back_feet_border_with_holes(padding, outline);
	}
}

module feets_plate(thickness, padding, rXY = M2_dk_r, rZ = 1.5) {
	outline =  padding + max(rXY, rZ);
	union () {
		polyRoundExtrude(add_rXY(get_front_feet_border(outline), rXY), thickness, rZ, rZ, 3, 10);
		polyRoundExtrude(add_rXY(get_back_feet_border(outline), rXY), thickness, rZ, rZ, 3, 10);
	}
}


module plate (layout = default_layout, thickness=1.5) {
	difference() {
		linear_extrude(thickness, convexity = 10)
			plate_2d(layout);
	}
}

module usb_frame (thickness, padding, outline) {
	linear_extrude(thickness, convexity = 10)
	difference() {
		border(outline);
		border(border_buffer);
		usb_cutoff(outline);
		structural_nuts(padding);
	}
}

module topest_frame (thickness, padding, outline) {
	linear_extrude(thickness, convexity = 10)
	difference() {
		border(outline);
		border(border_buffer);
	}
}

module top_frame (thickness, padding, outline) {
	linear_extrude(thickness, convexity = 10)
	difference() {
		border(outline);
		border(border_buffer);
		structural_nuts(padding);
	}
}

module reinforce(layout = default_layout, thickness, padding, outline) {
	linear_extrude(thickness, convexity = 10)
	difference() {
		border(outline);

		button_cutoff(key_size, 12);
		screws_cutoff(M2_d_r);
		// 15.6, see mx spec
		// moded to 16.8 for cleaner stab cutoff
		cut_key(layout, 16.8, true);

		structural_nuts(padding);
	}
}

module bottom_plate(thickness, padding, outline) {
	linear_extrude(thickness, convexity = 10)
		difference() {
			border(outline);
			structural_nuts(padding, M2_d);
		}
}

module flat_plate(thickness=10, padding = 10, rXY = M2_dk_r, rZ = 1.5) {
	polyRoundExtrude(add_rXY(get_border(padding), rXY), thickness, rZ, rZ, 3, 10);
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

module print_plates(layout = default_layout, thickness = 3, padding = 10, rXY = M2_dk_r, rZ = 1.5, seperator = 10, easyReinforce = false) {
	plates = [7, 6, 5, 4, 4, 3, 2, 1, 0];
	outline =  padding + max(rXY, rZ);

	for (k = [ 0 : len(plates) - 1 ] ) {
		p = plates[k];

		translate([0, 0, get_plate_z(k, thickness, seperator)]) {

			if (easyReinforce && p == 3) {
				intersection() {
					translate([0, 0, -0.01])
						color(colors[p]) flat_plate(3 + 0.02, padding + 0.01, rXY, 0);
						color(colors[p]) reinforce(layout, 3, padding, outline);
				}
			} else if (p <= 5) {
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

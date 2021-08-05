include <./utils.scad>;

module plate_2d(layout = default_layout, pRadius = M2_d_r) {
	difference() {
		border(0);
		screws_cutoff(pRadius);
		cut_key(layout);
    button_cutoff();
	}
}

module usb_frame_2d(padding, buffer = 0, pRadius = gh60_holes_radius) {
  outline = padding + buffer;
	difference() {
		border(outline);
		border(border_buffer);
		usb_cutoff(outline);
		structural_nuts(padding);
    screws_cutoff(max(pRadius, gh60_holes_radius));
	}
}

module topest_frame_2d(padding, buffer = 0) {
  outline = padding + buffer;
	difference() {
		border(outline);
		border(border_buffer);
    structural_nuts(padding, M2_d);
	}
}

module top_frame_2d(padding, buffer = 0) {
  outline = padding + buffer;
	difference() {
		border(outline);
		border(border_buffer);
		structural_nuts(padding);
	}
}

module reinforce_2d(layout = default_layout, padding, buffer = 0) {
  outline = padding + buffer;
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

module bottom_plate_2d(padding, buffer = 0) {
  outline = padding + buffer;
  difference() {
    border(outline);
    structural_nuts(padding, M2_d);
    button_cutoff();
    // usb_cutoff(outline, 12);
    usb_cutoff(outline, 0);
  }
}

module feets_extends_2d(padding, buffer = 0) {
  outline = padding + buffer;

  difference () {
    union () {
      front_feet_border(outline);
      back_feet_border(outline);
    }
    structural_nuts(padding, M2_d);
  }
}

module feets_2d(padding, buffer = 0) {
  outline = padding + buffer;

  difference () {
    union () {
      front_feet_border_with_holes(padding, outline);
      back_feet_border_with_holes(padding, outline);
    }
    structural_nuts(padding, M2_d);
  }
}

module rounded_plate_2d(padding = 10, buffer = 0, rXY = M2_dk_r) {
  outline = padding + buffer;
	polygon(polyRound(add_rXY(get_border(outline), rXY)));
}

module rounded_feet_2d(padding = 10, buffer = 0, rXY = M2_dk_r) {
	outline = padding + buffer;
	union () {
		polygon(polyRound(add_rXY(get_front_feet_border(outline), rXY)));
		polygon(polyRound(add_rXY(get_back_feet_border(outline), rXY)));
	}
}

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

module round_everything(padding = 10, buffer = 0, rXY = M2_dk_r, isFeet) {
  intersection() {
    if (isFeet) {
      rounded_feet_2d(padding, buffer, rXY);
    } else {
      rounded_plate_2d(padding, buffer, rXY);
    }
    children();
  }
}

default_curved_plates_offsets = [
// feet1,feet2,bottom,usb1,usb2,reinforce,0,top1,top2
// 0,0,0,2,4,6,0,4,2
0,0,0,2,4,4,0,4,2
// 0,0,0,0,0,0,0,0,0
];

plates = [7, 6, 5, 4, 4, 3, 2, 1, 0];

module print_plates_2d(
  layout = default_layout,
  padding = 10,
  rXY = M2_dk_r,
  curved_plates_offsets = default_curved_plates_offsets,
  pRadius = M2_d_r,
  type,
  zIndex,
) {
  round_everything(padding, curved_plates_offsets[zIndex], rXY, type > 5) {
    if (type == 0) topest_frame_2d(padding, curved_plates_offsets[zIndex]);
    else if (type == 1) top_frame_2d(padding, curved_plates_offsets[zIndex]);
    else if (type == 2) plate_2d(layout, pRadius);
    else if (type == 3) reinforce_2d(layout, padding, curved_plates_offsets[zIndex]);
    else if (type == 4) usb_frame_2d(padding, curved_plates_offsets[zIndex], pRadius);
    else if (type == 5) bottom_plate_2d(padding, curved_plates_offsets[zIndex]);
    else if (type == 6) feets_extends_2d(padding);
    else if (type == 7) feets_2d(padding);
  }
}

module preview_plates_2d(
  layout = default_layout,
  padding = 10,
  rXY = M2_dk_r,
  pRadius = M2_d_r,
  seperator = 10,
  curved_plates_offsets = default_curved_plates_offsets
) {
  preview_thickness = 3;

	for (k = [ 0 : len(plates) - 1 ] ) {
		p = plates[k];
		translate([0, 0, get_plate_z(k, preview_thickness, seperator)]) {
      color(colors[p], 0.6)
      linear_extrude(preview_thickness) {
        print_plates_2d(
          layout = layout,
          padding = padding,
          rXY = rXY,
          curved_plates_offsets = curved_plates_offsets,
          pRadius = pRadius,
          type = p,
          zIndex = k
        );
      }
		}
	}
}

module laser_cut_plates(
  layout = default_layout,
  padding = 10,
  rXY = M2_dk_r,
  curved_plates_offsets = default_curved_plates_offsets,
  pRadius = M2_d_r,
) {
	for (k = [ 0 : len(plates) - 1 ] ) {
		p = plates[k];
		translate([400 * k, 0]) {
      color(colors[p], 0.6)
      print_plates_2d(
        layout = layout,
        padding = padding,
        rXY = rXY,
        curved_plates_offsets = curved_plates_offsets,
        pRadius = pRadius,
        type = p,
        zIndex = k
      );
		}
	}
}
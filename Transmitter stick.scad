
include <../BH-Lib/all.scad>;

// these are for the Taranis - may need adjustment for other transmitters
TX_STICK_HEIGHT = 21;
TX_STICK_RAD = 2;
TX_STICK_THREAD_DEPTH = 12.5;
TX_STICK_THREAD_RAD = SCREW_M3_DIM[0] / 2;

TOLERANCE_FIT = 0.125;
TOLERANCE_CLEAR = 0.25;

module transmitter_stick(
		h, // above stick base
		head_h,
		r, // of top portion
		knobs = 8,
		surround = 1.5,
		stick_h = TX_STICK_HEIGHT,
		stick_r = TX_STICK_RAD,
		thread_depth = TX_STICK_THREAD_DEPTH,
		thread_r = TX_STICK_THREAD_RAD,
		tolerance_fit = TOLERANCE_FIT,
		tolerance_clear = TOLERANCE_CLEAR,
	) {

	surround_r = thread_r + tolerance_clear + surround;

	difference() {
		union() {

			// shaft taper
			translate([0, 0, stick_h - thread_depth])
			cylinder(h = surround_r, r1 = stick_r, r2 = surround_r);

			// shaft
			translate([0, 0, stick_h - thread_depth + surround_r])
			cylinder(h = h - stick_h + thread_depth - surround_r, r = surround_r);

			// head base/support
			translate([0, 0, h - head_h - surround_r])
			cylinder(h = surround_r, r1 = surround_r, r2 = r);

			// head
			translate([0, 0, h - head_h / 2])
			cylinder(h = head_h, r = r, f = head_h / 4, center = true);
		}

		// inset
		translate([0, 0, h])
		rounded_cylinder(h = head_h, r1 = r * 0.7, r2 = r, f = head_h / 4);

		// knobs
		translate([0, 0, h + 0.2])
		for (a = [0 : knobs / 2 - 1])
		rotate([0, 0, 360 / knobs * a])
		resize([r * 3, head_h, head_h])
		rotate([45, 0])
		cube(head_h, true);

		// threads
		cylinder(h = stick_h + tolerance_clear, r = thread_r + tolerance_fit);
	}

	// mock stick
	%
	union() {
		cylinder(h = stick_h - thread_depth , r = stick_r);

		translate([0, 0, stick_h - thread_depth])
		cylinder(h = thread_depth, r = thread_r);
	}
}

$fs = 0.5;

//show_half()
transmitter_stick(24, 4, 8);

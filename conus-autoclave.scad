/*
 ******************************************************************************************
 *                                                                                        *
 *                     The autoclave with cutted conus form inside                        *
 *                                                                                        *
 ******************************************************************************************
 * The cutted conus volume:                                                               *
 *   V (cut. conus) = 1/3 * pi * h(conus) * (r1^2 + r1 * r2 + r2^2)                       *
 *                                                                                        *
 * Therefore the volume of two cutted conus plus the cylinder is:                         *
 *   V (full) = 2/3 * pi * h(conus) * (r1^2 + r1 * r2 + r2^2) + pi * H(cylinder) * r1^2   *
 *                                                                                        *
 * From WolframAlpha:                                                                     *
 *   V = 2/3* pi*5*(8^2 + 8*1.5 + 1.5^2) + pi*6*8^2 = 2025                                *
 ******************************************************************************************
 */


/*
 ******************************************************************************************
 * Set SHOW to true to look inside the cylinder.                                          *
 * Otherwise set SHOW to false to the final rendering.                                    *
 ******************************************************************************************
 */
SHOW = true;


/*
 ******************************************************************************************
 *                               Variables                                                *
 ******************************************************************************************
 */
h_wall = 2;

d1_insideCuttedConus = 16;
d2_insideCuttedConus = 3;
h_insideCuttedConus = 5;

h_insideCylinder = 6;

d_outsideCylinder = d1_insideCuttedConus + h_wall*2;
h_outsideCylinder = h_insideCuttedConus*2 + h_insideCylinder + h_wall*2;


/*
 ******************************************************************************************
 *                               Modules                                                  *
 ******************************************************************************************
 */
module insideVolume()
{
	module insideCuttedConus()
	{
		translate([0, 0, h_insideCylinder/2]) cylinder(d1 = d1_insideCuttedConus, d2 = d2_insideCuttedConus, h = h_insideCuttedConus, $fn=360, center=false);
	}

	insideCuttedConus();
	mirror([0,0,1]) insideCuttedConus();

	cylinder(h = h_insideCylinder, d = d1_insideCuttedConus, $fn = 360, center=true);
}


/*
 ******************************************************************************************
 *                               Two Kind of Main                                         *
 ******************************************************************************************
 */
module diffMain()
{
	difference()
	{
		cylinder(d = d_outsideCylinder, h = h_outsideCylinder, $fn = 360, center=true);
		insideVolume();
	}
}


module showMain()
{
		insideVolume();
		#cylinder(d = d_outsideCylinder, h = h_outsideCylinder, $fn = 360, center=true);
}


module main()
{
	if (SHOW)
	{
		showMain();
	}
	else
		diffMain();
}


/*
 ******************************************************************************************
 *                                     Main                                               *
 ******************************************************************************************
 */
main();

/*
 ******************************************************************************************
 *                                                                                        *
 *                     The autoclave with cutted cone form inside                         *
 *                                                                                        *
 ******************************************************************************************
 * The cutted cone volume:                                                                *
 *   V (cut. cone) = 1/3 * pi * h(cone) * (r1^2 + r1 * r2 + r2^2)                         *
 *                                                                                        *
 * Therefore the volume of two cutted cone plus the cylinder is:                          *
 *   V (full) = 2/3 * pi * h(cone) * (r1^2 + r1 * r2 + r2^2) + pi * H(cylinder) * r1^2    *
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

d1_insideCuttedCone = 16;
d2_insideCuttedCone = 3;
h_insideCuttedCone = 5;

h_insideCylinder = 6;

d_outsideCylinder = d1_insideCuttedCone + h_wall*2;
h_outsideCylinder = h_insideCuttedCone*2 + h_insideCylinder + h_wall*2;


/*
 ******************************************************************************************
 *                               Modules                                                  *
 ******************************************************************************************
 */
module insideVolume()
{
	module insideCuttedCone()
	{
		translate([0, 0, h_insideCylinder/2]) cylinder(d1 = d1_insideCuttedCone, d2 = d2_insideCuttedCone, h = h_insideCuttedCone, $fn=360, center=false);
	}

	insideCuttedCone();
	mirror([0,0,1]) insideCuttedCone();

	cylinder(h = h_insideCylinder, d = d1_insideCuttedCone, $fn = 360, center=true);
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

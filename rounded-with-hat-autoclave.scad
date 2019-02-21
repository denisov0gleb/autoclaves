/*
 ******************************************************************************************
 *                                                                                        *
 *                     The autoclave with sphere inside and cone china-hat                *
 *                                                                                        *
 ******************************************************************************************
 * The sphere volume:                                                                     *
 *   V (sphere) = 4/3 * pi * r1^3                                                         *
 *                                                                                        *
 * Therefore the volume of two half-spheres plus the cylinder is:                         *
 *   V (full) = 4/3 * pi * r1^3 + pi * H(cylinder) * r1^2                                 *
 *                                                                                        *
 * From WolframAlpha:                                                                     *
 *   V = 4/3* pi*7.5^2 + pi*3*7.5^2 = 2297                                                *
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

d_insideSphere = 15;

h_insideCylinder = 3;

d_outsideCylinder = d_insideSphere + h_wall*2;
h_outsideCylinder = d_insideSphere + h_insideCylinder + h_wall*2;

h_hatCylinder = 5;


/*
 ******************************************************************************************
 *                               Modules                                                  *
 ******************************************************************************************
 */
module insideVolume()
{
	module insideSphere()
	{
		translate([0, 0, h_outsideCylinder/2 - d_insideSphere/2 - h_wall]) sphere(d = d_insideSphere, $fn=360, center=true);
	}

	insideSphere();
	mirror([0,0,1]) insideSphere();

	translate([0,0,0]) cylinder(h = h_insideCylinder, d = d_insideSphere, $fn = 360, center=true);
}


module coneHat()
{
	cylinder(d1 = d_outsideCylinder, d2 = 0, h = h_hatCylinder, $fn = 360);
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
	translate([0, 0, h_outsideCylinder/2]) coneHat();
}


module showMain()
{
	insideVolume();
	#cylinder(d = d_outsideCylinder, h = h_outsideCylinder, $fn = 360, center=true);
	translate([0, 0, h_outsideCylinder/2]) coneHat();
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

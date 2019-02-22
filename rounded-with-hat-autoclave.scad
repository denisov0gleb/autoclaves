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
 *                                                                                        *
 ******************************************************************************************
 *                                                                                        *
 * Based on round-autoclave.scad                                                          *
 *                                                                                        *
 ******************************************************************************************
 */
use <rounded-autoclave.scad>


/*
 ******************************************************************************************
 *                               Variables                                                *
 ******************************************************************************************
 */
include <variables.scad>


/*
 ******************************************************************************************
 * Set SHOW to true to look inside the cylinder.                                          *
 * Otherwise set SHOW to false to the final rendering.                                    *
 ******************************************************************************************
 */
SHOW = true;


/*
 ******************************************************************************************
 *                               Modules                                                  *
 ******************************************************************************************
 */
module insideVolume()
{
	module insideSphere()
	{
		translate([0, 0, h_outsideCylinder_ROUND/2 - d_insideSphere/2 - h_wall]) sphere(d = d_insideSphere, $fn=360, center=true);
	}

	insideSphere();
	mirror([0,0,1]) insideSphere();

	translate([0,0,0]) cylinder(h = h_insideCylinder, d = d_insideSphere, $fn = 360, center=true);
}


module coneHat()
{
	cylinder(d1 = d_outsideCylinder_ROUND, d2 = 0, h = h_hatCylinder, $fn = 360);
}


/*
 ******************************************************************************************
 *                               Autoclave module                                         *
 ******************************************************************************************
 */
module withHatAutoclave()
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
 *                               Two Kind of Main                                         *
 ******************************************************************************************
 */
module diffMain()
{
	difference()
	{
		cylinder(d = d_outsideCylinder_ROUND, h = h_outsideCylinder_ROUND, $fn = 360, center=true);
		roundedInsideVolume();
	}
	translate([0, 0, h_outsideCylinder_ROUND/2]) coneHat();
}


module showMain()
{
	roundedInsideVolume();
	#cylinder(d = d_outsideCylinder_ROUND, h = h_outsideCylinder_ROUND, $fn = 360, center=true);
	translate([0, 0, h_outsideCylinder_ROUND/2]) coneHat();
}


/*
 ******************************************************************************************
 *                                     Main                                               *
 ******************************************************************************************
 */
withHatAutoclave();

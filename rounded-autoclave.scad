/*
 ******************************************************************************************
 *                                                                                        *
 *                     The autoclave with sphere inside                                   *
 *                                                                                        *
 ******************************************************************************************
 * The sphere volume:                                                                     *
 *   V (sphere) = 4/3 * pi * r1^3                                                         *
 *                                                                                        *
 * Therefore the volume of two half-spheres plus the cylinder is:                         *
 *   V (full) = 4/3 * pi * r1^3 + pi * H(cylinder) * r1^2                                 *
 *                                                                                        *
 * From WolframAlpha:                                                                     *
 *   V = 4/3* pi*(8.74/2)^3 + pi*3*7.5^2 = 349.57                                                *
 ******************************************************************************************
 */


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
SHOW = false;


/*
 ******************************************************************************************
 *                               Modules                                                  *
 ******************************************************************************************
 */
module roundedInsideVolume()
{
	module insideSphere()
	{
		translate([0, 0, h_insideCylinder_ROUND/2]) sphere(d = d_insideSphere, $fn=fn_insideSphere, center=true);
	}

	insideSphere();
	mirror([0,0,1]) insideSphere();

	cylinder(h = h_insideCylinder_ROUND, d = d_insideSphere, $fn=fn_insideSphere, center=true);
}


/*
 ******************************************************************************************
 *                               Autoclave module                                         *
 ******************************************************************************************
 */
module roundedAutoclave(h_up_var)
{
	if (SHOW)
	{
		showMain(h_up_var);
	}
	else
		diffMain(h_up_var);
}


/*
 ******************************************************************************************
 *                               Two Kind of Main                                         *
 ******************************************************************************************
 */
module diffMain(h_up_var)
{
    height = d_insideSphere + h_up_var + h_Bottom;
	difference()
	{
		translate([0, 0, height/2-h_Bottom-d_insideSphere/2])cylinder(d =               d_outsideCylinder_ROUND, h = height, $fn = fn_outsideCylinder, center=true);
        roundedInsideVolume();
    }
}



module showMain(h_up_var)
{
    height = d_insideSphere + h_up_var + h_Bottom;
roundedInsideVolume();
	#translate([0, 0, height/2-h_Bottom-d_insideSphere/2])cylinder(d = d_outsideCylinder_ROUND, h = height, $fn = fn_outsideCylinder, center=true);
}


/*
 ******************************************************************************************
 *                                     Main                                               *
 ******************************************************************************************
 */
for (i=[0.5:0.5:2])
{  
    translate([(d_outsideCylinder_ROUND+25)*i,0,0]) roundedAutoclave(i);
}


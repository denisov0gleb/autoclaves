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
 *   V = 4/3* pi*7.5^2 + pi*3*7.5^2 = 2297                                                *
 ******************************************************************************************
 */

/*
 ******************************************************************************************
 * Set SHOW to true to look inside the cylinder.                                          *
 * Otherwise set SHOW to false to the final rendering.                                    *
 ******************************************************************************************
 */
SHOW = false;


/*
 ******************************************************************************************
 *                               Variables                                                *
 ******************************************************************************************
 */
include <variables.scad>



/*
 ******************************************************************************************
 *                               Modules                                                  *
 ******************************************************************************************
 */
module insideVolume()
{
	module insideSphere()
	{
		translate([0, 0, h_outsideCylinder/2 - d_insideSphere/2 - h_wall]) sphere(d = d_insideSphere, $fn=fn_insideSphere, center=true);
	}

	insideSphere();
	mirror([0,0,1]) insideSphere();

	cylinder(h = h_insideCylinder_ROUND, d = d_insideSphere, $fn=fn_insideSphere, center=true);
}


module roundedAutoclave()
{
	if (SHOW)
	{
		insideVolume();
		#translate([0, 0, -h_wallBottom + h_wall]) cylinder(d = d_outsideCylinder_ROUND, h = h_outsideCylinder_ROUND, $fn = 360, center=true);
	}
	else
	{
		difference()
		{
			translate([0, 0, -h_wallBottom + h_wall]) cylinder(d = d_outsideCylinder_ROUND, h = h_outsideCylinder_ROUND, $fn = 360, center=true);
			insideVolume();
		}
	}
}


module manyAutoclaves()
{
	for (i = [0 : xAxisAutoclaves - 1])
	{
		for (j = [0 : yAxisAutoclaves - 1])
		{
			translate([i * (d_insideSphere + h_wall), j * (d_insideSphere + h_wall), 0]) roundedAutoclave();
		}
	}
}


/*
 ******************************************************************************************
 *                                     The Main                                           *
 ******************************************************************************************
 */
module main()
{
	manyAutoclaves();
}


/*
 ******************************************************************************************
 *                                     Main                                               *
 ******************************************************************************************
 */
main();

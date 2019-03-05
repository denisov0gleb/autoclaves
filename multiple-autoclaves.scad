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


module manyAutoclaves()
{
	for (i = [0 : xAxisAutoclaves - 1])
	{
		for (j = [0 : yAxisAutoclaves - 1])
		{
			translate([i * d_outsideCylinder, j * d_outsideCylinder, 0]) insideVolume();
		}
	}
}

module autoclavesCase()
{

	function x_cube() = xAxisAutoclaves * d_outsideCylinder;
	function y_cube() = yAxisAutoclaves * d_outsideCylinder;
	function z_cube() = h_outsideCylinder;

	module roundCorner(move=[0, 0, 0])
	{
		translate([move[0]-d_outsideCylinder/2, move[1]-d_outsideCylinder/2, move[2]]) cylinder(d =
		d_roundCornerCase, h = h_outsideCylinder, $fn=fn_roundCornerCase, center=true);
	}

	hull()
	{
		roundCorner([r_roundCornerCase, r_roundCornerCase, 0]);
		roundCorner([r_roundCornerCase, -r_roundCornerCase + y_cube(), 0]);
		roundCorner([-r_roundCornerCase + x_cube(), -r_roundCornerCase + y_cube(), 0]);
		roundCorner([-r_roundCornerCase + x_cube(), r_roundCornerCase, 0]);
	}
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
		autoclavesCase();
		manyAutoclaves();
	}
}


module showMain()
{
	manyAutoclaves();
	#autoclavesCase();
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

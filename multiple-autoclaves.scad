/*
 ******************************************************************************************
 *                                                                                        *
 *                          Multiple autoclave                                            *
 *                                                                                        *
 ******************************************************************************************
 *                                                                                        *
 * Usage:                                                                                 *
 *   change xAxisAutoclaves and yAxisAutoclaves to needed amount of autoclaves in matrix  *
 *                                                                                        *
 ******************************************************************************************
 */


/*
 ******************************************************************************************
 *                               Variables                                                *
 ******************************************************************************************
 */
include <variables.scad>

xAxisAutoclaves = 5; // amount x
yAxisAutoclaves = 5; // amount y


/*
 ******************************************************************************************
 * Set SHOW to true to look inside the cylinder.                                          *
 * Otherwise set SHOW to false to the final rendering.                                    *
 ******************************************************************************************
 */
SHOW = true;


/*
 ******************************************************************************************
 *                       Different forms of autoclaves                                    *
 ******************************************************************************************
 *                                                                                        *
 * Usage:                                                                                 *
 *   use <your-name-of-autoclave.scad>                                                    *
 *                                                                                        *
 *   change the name of the autoclave inside form module in currentUseAutoclave module    *
 *                                                                                        *
 ******************************************************************************************
 */
use <rounded-autoclave.scad>
use <cone-autoclave.scad>
use <rounded-with-hat-autoclave.scad>


module currentUseAutoclave()
{
 roundedInsideVolume();
}


/*
 ******************************************************************************************
 *                               Modules                                                  *
 ******************************************************************************************
 */
module manyAutoclaves()
{
	for (i = [0 : xAxisAutoclaves - 1])
	{
		for (j = [0 : yAxisAutoclaves - 1])
		{
			translate([i * d_outsideCylinder, j * d_outsideCylinder, 0]) currentUseAutoclave();
		}
	}
}


module autoclavesCase()
{
	function x_cube() = xAxisAutoclaves * d_outsideCylinder;
	function y_cube() = yAxisAutoclaves * d_outsideCylinder;
	function z_cube() = h_outsideCylinder;

	translate([-d_outsideCylinder/2, -d_outsideCylinder/2, -h_outsideCylinder/2]) cube([x_cube(), y_cube(), z_cube()], center=false);
}


/*
 ******************************************************************************************
 *                                   Autoclaves                                           *
 ******************************************************************************************
 */
module autoclaves()
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
		autoclavesCase();
		manyAutoclaves();
	}
}


module showMain()
{
	manyAutoclaves();
	#autoclavesCase();
}


/*
 ******************************************************************************************
 *                                     Main                                               *
 ******************************************************************************************
 */
autoclaves();

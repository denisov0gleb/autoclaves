/*
 ******************************************************************************************
 *                                                                                        *
 *                     The autoclave with sphere inside                                   *
 *                                                                                        *
 ******************************************************************************************
 * The sphere volume:                                                                     *
 *   V (sphere) = 4/3 * pi * r1^3                                                         *
 *                                                                                        *
 * From WolframAlpha:                                                                     *
 *   V = 4/3* pi * 4.93^3 = 502 mcL                                                         *
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
		translate([0, 0, h_insideCylinder_ROUND/2]) sphere(d = d_insideSphere, $fn=fn_insideSphere, center=true);
	}

	module full()
	{
		insideSphere();
		mirror([0,0,1]) insideSphere();
		cylinder(h = h_insideCylinder_ROUND, d = d_insideSphere, $fn=fn_insideSphere, center=true);
	}

	translate([0, 0, (h_outsideCylinder_ROUND-h_insideVolume)/2 - h_wallUp]) full();
}


module roundedAutoclave()
{
	if (SHOW)
	{
		insideVolume();
		#cylinder(d = d_outsideCylinder_ROUND, h = h_outsideCylinder_ROUND, $fn = fn_outsideCylinder, center=true);
	}
	else
	{
		difference()
		{
			cylinder(d = d_outsideCylinder_ROUND, h = h_outsideCylinder_ROUND, $fn = fn_outsideCylinder, center=true);
			insideVolume();
		}
	}
}


module smoothWall(dis1, dis2)
{
	function smoothR(dis1, dis2, Ro) = (Ro + Ro*dis1 / dis2)/(dis1 / dis2*dis1 / dis2 - 1);

	Rs = smoothR(d_insideSphere + xy_distance, dis2, d_outsideCylinder_ROUND/2);
	Rf = d_outsideCylinder_ROUND/2 + Rs;
	H1 = sqrt(Rf*Rf - dis1*dis1/4);
	yPos = H1 * (dis1 - dis2) / dis1;

	module smooth()
	{
		difference()
		{
			union()
			{
				rotate([0, 0, 45]) cube([dis2/sqrt(2), dis2/sqrt(2), h_outsideCylinder_ROUND], center=true);
				translate([0, yPos/2, 0]) cube([dis2, yPos, h_outsideCylinder_ROUND], center=true);
			}
			translate([0, -dis2/2, 0]) cylinder(r = dis2/sqrt(2), h = h_outsideCylinder_ROUND + 4, $fn=fn_outsideCylinder, center=true);
		}
	}

	for (i = [0 : xAxisAutoclaves - 2])
	{
		translate([dis1/2 + i*dis1, -yPos, 0]) smooth();
		translate([dis1/2 + i*dis1, dis1*(yAxisAutoclaves - 1) + yPos, 0]) rotate([0, 0, 180]) smooth();
	}

	for (j = [0 : yAxisAutoclaves - 2])
	{
		translate([-yPos, dis1/2 + dis1*j, 0]) rotate([0, 0, -90]) smooth([0, 0, 0]);
		translate([dis1*(xAxisAutoclaves - 1) + yPos, dis1/2 + dis1*j, 0]) rotate([0, 0, 90]) smooth([0, 0, 0]);
	}
}


module manyAutoclaves()
{
	for (i = [0 : xAxisAutoclaves - 1])
	{
		for (j = [0 : yAxisAutoclaves - 1])
		{
			translate([i * (d_insideSphere + xy_distance), j * (d_insideSphere + xy_distance), 0]) roundedAutoclave();
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
	smoothWall(d_insideSphere + xy_distance, d_smooth);
}


/*
 ******************************************************************************************
 *                                     Main                                               *
 ******************************************************************************************
 */
main();

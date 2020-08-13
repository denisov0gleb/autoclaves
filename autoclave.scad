/*
 ******************************************************************************************
 *                                                                                        *
 *                     The autoclave with sphere inside                                   *
 *                                                                                        *
 ******************************************************************************************
 */

/*
 ******************************************************************************************
 * Set SHOW to true to look inside the cylinder.                                          *
 * Otherwise set SHOW to false to the final rendering.                                    *
 ******************************************************************************************
 */
SHOW = false;

use <threads.scad>


/*
 ******************************************************************************************
 * The sphere volume:                                                                     *
 *   V (sphere) = 4/3 * pi * r^3                                                          *
 *                                                                                        *
 * Therefore the volume of two half-spheres plus the cylinder is:                         *
 *                                                                                        *
 *   V = 4/3* pi*r_cavitySphere^3 + pi*h_insideCylinder*r_cavitySphere^2                  *
 ******************************************************************************************
 */


/*
 ******************************************************************************************
 *                               Variables                                                *
 ******************************************************************************************
 */

FN_ALL = 200;

r_cavitySphere = 7.8;
wallInside = 6;
groundInside = 6;
roofOutside = 6;

d_inside = r_cavitySphere*2 + wallInside*2;
d_insideRing = d_inside - 3;
h_inside = r_cavitySphere*1.5 + groundInside;
h_insideRing = 2;


wallOutside = 6;
d_outside = r_cavitySphere*2 + wallInside*2 + wallOutside*2;
h_outside = r_cavitySphere*2 + roofOutside;

separate = 1;

/*
 ******************************************************************************************
 *                               Modules                                                  *
 ******************************************************************************************
 */

module Cavity()
{
	sphere(r = r_cavitySphere, $fn = FN_ALL);
}


module AutoclaveInside()
{
	module inside()
	{
		translate([0, 0, -r_cavitySphere/4 - groundInside/2 - h_inside/2]) 
			metric_thread (diameter=d_inside+1.75, pitch=5, length=h_inside, thread_size=2.5, angle=45, leadin=2,internal=false);
			/* cylinder(d = d_inside, h = h_inside, $fn=FN_ALL, center=true); */
	}

	
	module insideRing()
	{
		color("red")
		translate([0, 0, h_insideRing/2 + r_cavitySphere/2])
			difference()
			{
				cylinder(d = d_inside, h = h_insideRing, $fn=FN_ALL, center=true);
				cylinder(d = d_insideRing, h = h_insideRing+1, $fn=FN_ALL, center=true);
			}
	}
	
	inside();
	insideRing();

}


module AutoclaveOutside()
{
	module insideCut()
	{
		translate([0, 0, -r_cavitySphere/4 - groundInside/2]) 
			cylinder(d = d_inside+separate, h = h_inside, $fn=FN_ALL, center=true);
	}

	module insideRingCut()
	{
		translate([0, 0, h_insideRing/2 + r_cavitySphere/2+separate/2-0.01])
			difference()
			{
				cylinder(d = d_inside+separate, h = h_insideRing+separate, $fn=FN_ALL, center=true);
				cylinder(d = d_insideRing-separate, h = h_insideRing+1+separate, $fn=FN_ALL, center=true);
			}
	}


	module outside()
	{
		difference()
		{
			translate([0, 0, h_outside/2 - r_cavitySphere]) 
				cylinder(d = d_outside, h = h_outside, $fn=FN_ALL, center=true);

			translate([0, 0, -r_cavitySphere/4 - groundInside/2 - h_inside/2]) 
				metric_thread (diameter=d_inside+1.80, pitch=5, length=h_inside, thread_size=2.5, angle=45,
				leadin=2,internal=true);
			/* insideCut(); */
			insideRingCut();
		}
	}
	
	outside();
}


/*
 ******************************************************************************************
 *                               Autoclave module                                         *
 ******************************************************************************************
 */
module main()
{
	if (SHOW)
	{
		Cavity();
		#AutoclaveOutside();
		#AutoclaveInside();
	}
	else
	{
		difference()
		{
			union()
			{
				/* color("red") AutoclaveInside(); */
				AutoclaveOutside();
			}
			Cavity();
		}
	}
}


/*
 ******************************************************************************************
 *                                     Main                                               *
 ******************************************************************************************
 */
main();



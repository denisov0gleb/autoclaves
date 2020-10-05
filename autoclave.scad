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
TEST = false;

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

h_stopper = 2;

/*
 * Fractions of sphere:
 */
fr1 = 4;
fr2 = 5;

z_pillarPos = -4;

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

	module column()
	{
		translate([6, 0, 0]) 
			cylinder(d = 7, h = 10, $fn=FN_ALL, center=true);
	}

	module pillar()
	{
		hull()
		{
			column();
			mirror([1,0,0]) column();
			mirror([1,1,0]) column();
			mirror([1,-1,0]) column();
		}
	}
	
		
	module inside()
	{

		if (TEST)
		{
			color("blue")
				translate([0, 0, -r_cavitySphere*(fr2-fr1)/fr2]) 
				cylinder(d = d_inside, h = r_cavitySphere*2*fr1/fr2, $fn=FN_ALL, center=true);
		}
		else
		{
			translate([0, 0, -r_cavitySphere*(fr2-fr1)/fr2 - r_cavitySphere*fr1/fr2]) 
				metric_thread (diameter=d_inside+1.75, pitch=5, length=r_cavitySphere*2*fr1/fr2, thread_size=2.5, angle=45, leadin=2,internal=false);
		}


		hull()
		{
		translate([0, 0, -r_cavitySphere - h_stopper/2]) 
			cylinder(d = d_inside + 7, h = h_stopper, $fn=FN_ALL, center=true);
		translate([0, 0, -r_cavitySphere - h_stopper + z_pillarPos]) color("red") scale([1, 1, 0.1]) pillar();
		}
		translate([0, 0, -groundInside - r_cavitySphere - h_stopper + z_pillarPos + 1]) pillar();
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
}


module AutoclaveOutside()
{
	module insideCut()
	{
		translate([0, 0, -r_cavitySphere/4 - groundInside/2]) 
			cylinder(d = d_inside+separate, h = h_inside, $fn=FN_ALL, center=true);
	}


	module outside()
	{
		difference()
		{
			translate([0, 0, h_outside/2 - r_cavitySphere]) 
				cylinder(d = d_outside, h = h_outside, $fn=FN_ALL, center=true);

			if(TEST)
			{

			color("blue")
				translate([0, 0, -r_cavitySphere*(fr2-fr1)/fr2]) 
				cylinder(d = d_inside, h = r_cavitySphere*2*fr1/fr2, $fn=FN_ALL, center=true);
					/* insideCut(); */
			}
			else
			{
				translate([0, 0, -r_cavitySphere*(fr2-fr1)/fr2 - r_cavitySphere*fr1/fr2]) 
					metric_thread (diameter=d_inside+1.85, pitch=5, length=r_cavitySphere*2*fr1/fr2 + 0.5, thread_size=2.5, angle=45, leadin=2,internal=true);
			}
		}

		c = 5;
		translate([0, 0, -r_cavitySphere + h_outside - c/2]) cube([d_outside + 20, c, c], center=true);
		translate([0, 0, -r_cavitySphere + h_outside - c/2]) cube([c, d_outside + 20, c], center=true);
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
		/* AutoclaveOutside(); */
		#AutoclaveInside();
	}
	else
	{
		difference()
		{
			union()
			{
				AutoclaveInside();
				/* AutoclaveOutside(); */
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

/*
 ******************************************************************************************
 *                               Variables for autoclaves                                 *
 ******************************************************************************************
 *                                                                                        *
 * Usage:                                                                                 *
 *   include <variables.scad>                                                             *
 *                                                                                        *
 ******************************************************************************************
 */


/*
 ******************************************************************************************
 *                               Universal variables                                      *
 ******************************************************************************************
 */
xy_wall = 5;
h_wallUp = 5;
h_wallBottom = 6;

xy_distance = 6;


/*
 ******************************************************************************************
 *                               Rounded autoclave                                        *
 ******************************************************************************************
 */
d_insideSphere = 3.91*2;

h_insideCylinder_ROUND = 0;

d_outsideCylinder_ROUND = d_insideSphere + xy_wall*2;
h_outsideCylinder_ROUND = d_insideSphere + h_insideCylinder_ROUND + h_wallUp + h_wallBottom;

h_insideVolume = d_insideSphere + h_insideCylinder_ROUND;

fn_insideSphere = 100;

fn_outsideCylinder = 200;


/*
 ******************************************************************************************
 *                               Multiple autoclaves                                      *
 ******************************************************************************************
 */
xAxisAutoclaves = 2; // amount x
yAxisAutoclaves = 1; // amount y

d_smooth = 4;

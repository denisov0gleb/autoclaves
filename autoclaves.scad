// Set true of false
SHOW_CAVITY = false;

fn_all = 80;


/*
 ******************************************************************************************
 *                               Functions                                                *
 ******************************************************************************************
 */
function dFromVolume(volume) = pow(volume * 6 / PI, 1/3);
function volumeFromD(d) = PI * pow(d,3) / 6;

/*
 ******************************************************************************************
 *                               Modules                                                  *
 ******************************************************************************************
 */
module sphereCavity(dia)
{
	sphere(d = dia, $fn=fn_all);
}


module centerCavityInAutoclave(height, dia, top)
{
	translate([0, 0, height/2 - dia/2 - top]) children(0);
}


/*
 ******************************************************************************************
 *                               Autoclaves                                               *
 ******************************************************************************************
 */

/*
 * Usage:
 *
 * autoclave(volume=1000, d=12.408, bottom=5, top=5, wall=5);
 *   or
 * autoclave(volume=1000, bottom=5, top=5, wall=5);
 *   or
 * autoclave(d=12.408, bottom=5, top=5, wall=5);
 */
module autoclave(volume, d, bottom, top, wall)
{
	dia = d ? d : dFromVolume(volume);
	vol = volume ? volume : volumeFromD(dia);

	echo("     Autoclave parameters are:");
	echo(Volume=vol, d=dia, bottom=bottom, top=top, wall=wall);

	h_cyl = dia + bottom + top;
	d_cyl = dia + 2*wall;

	if(!SHOW_CAVITY)
	{
		difference()
		{
			cylinder(d = d_cyl, h = h_cyl, $fn = fn_all, center=true);
			centerCavityInAutoclave(h_cyl, dia, top) sphereCavity(dia);
		}
	}
	else
	{
		centerCavityInAutoclave(h_cyl, dia, top) sphereCavity(dia);
		#cylinder(d = d_cyl, h = h_cyl, $fn = fn_all, center=true);
	}
}


/*
 * Usage:
 * autoclave_3x3(volume=1000, bottom=5, top=5, wall=5, delta=2);
 *   or
 * autoclave_3x3(volume=1000, bottom=5, top=5, wall=5);
 */
module autoclave_3x3(volume, d, bottom, top, wall, delta=1)
{
	dia = d ? d : dFromVolume(volume);
	vol = volume ? volume : volumeFromD(dia);

	h_cyl = dia + bottom + top;
	d_cyl = dia + 2*wall;

	D = d_cyl/2 + dia/2; // Distance between centers
	delta = delta ? delta: 1; // additional separation
	for(i = [0 : 2])
		for(j = [0 : 2])
			translate([i*(D + delta), j*(D + delta), 0])
				autoclave(volume=vol, d=dia, bottom=bottom, top=top, wall=wall);
}


/*
 * Usage:
 * autoclave_nxn(volume=1000, bottom=5, top=5, wall=5);
 *   or
 * autoclave_nxn(volume=1000, bottom=5, top=5, wall=5, n=5);
 */
module autoclave_nxn(n, volume, d, bottom, top, wall, delta=1)
{
	number = n ? n : 2;
	dia = d ? d : dFromVolume(volume);
	vol = volume ? volume : volumeFromD(dia);

	h_cyl = dia + bottom + top;
	d_cyl = dia + 2*wall;

	D = d_cyl/2 + dia/2; // Distance between centers
	delta = delta ? delta: 1; // additional separation
	for(i = [0 : number - 1])
		for(j = [0 : number - 1])
			translate([i*(D + delta), j*(D + delta), 0])
				autoclave(volume=vol, d=dia, bottom=bottom, top=top, wall=wall);
}


/*
 ******************************************************************************************
 *                                     Main                                               *
 ******************************************************************************************
 */

// Single autoclave:
autoclave(volume=1000, bottom=5, top=5, wall=5);

// 3x3 autoclave:
// autoclave_3x3(volume=1000, bottom=5, top=5, wall=5);

// nxn autoclave:
// autoclave_nxn(volume=1000, bottom=5, top=5, wall=5, n=5);

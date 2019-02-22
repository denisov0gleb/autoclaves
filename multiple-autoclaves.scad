x=5;//amount x

y=5;//amount y

heightC=10;//h diff cylinder
rad=14.67;
wall=4;//wall thickness
heightAll=rad*2+heightC+wall*2; //full height
volume=(rad+wall)*2;
module empty()
{
    translate([0,0,rad+wall]) sphere(r=rad, $fn=300);//bottom
    translate([0,0,rad+wall]) cylinder(r=rad, h=heightC, $fn=300);//cyl
    translate([0,0,rad+wall+heightC]) sphere(r=rad, $fn=300);//upper
}
module allEmpties()
{
for (i= [0:x-1])
{
//translate([i*40,0,0]) empty();

    for (a= [0:y-1])
    {
        translate([i* volume, a* volume,0]) empty();
    }
}
}
difference()
{
    cube([volume*x,volume*y,heightAll]);

    translate([wall+rad,wall+rad,0]) allEmpties();
}
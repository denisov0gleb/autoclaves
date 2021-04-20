# Autoclaves #

[OpenSCAD](http://www.openscad.org) file to generate autoclaves for 3D printing by polypropylene.

Keep generated *STL* files in **STLs** folder.

## Capabilities ##

You can specify autoclave volume (in microliters) and/or inside cavity diameter (in millimeters).

**All** wall thickness are required.

### Single autoclave ###

*Examples:*

1. Both volume and diameter are given:
```openscad
autoclave(volume=1000, d=12.408, bottom=5, top=5, wall=5);
```

2. Only volume is given, diameter is calculated:
```openscad
autoclave(volume=1000, bottom=5, top=5, wall=5);
```

3. Only diameter is given, volume is calculated:
```openscad
autoclave(d=12.408, bottom=5, top=5, wall=5);
```

### 3x3 autoclave ###

Additional distance separator **delta**. By default **delta = 1**.

1. Only **volume** is given, **diameter** is calculated, **delta** is changed:
```openscad
autoclave_3x3(volume=1000, bottom=5, top=5, wall=5, delta=2);
```

2. Only **volume** is given, **diameter** is calculated, **delta** is default:
```openscad
autoclave_3x3(volume=1000, bottom=5, top=5, wall=5);
```


### Squared nxn autoclave ###

**n** - number of autoclaves in each row. By default **n = 2**.

Additional distance separator **delta**. By default **delta = 1**.

1. Only **volume** is given, **diameter** is calculated, **n** and **delta** are default:
```openscad
autoclave_nxn(volume=1000, bottom=5, top=5, wall=5);
```

2. Only **volume** is given, **diameter** is calculated, **delta** is default:
```openscad
autoclave_nxn(volume=1000, bottom=5, top=5, wall=5, n=5);
```


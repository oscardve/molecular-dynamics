# To center the molecule at the origin:
set sel [atomselect top all]
$sel moveby [vecscale -1 [measure center $sel]]

# To find a vector pointing towards the trajectory,
# select any two atoms aligned in this direction:  
set vec1 [measure center [atomselect top "index 1"]]
set vec2 [measure center [atomselect top "index 2"]]
set vec12 [vecsub  $vec1 $vec2]

# Align this vector of the protein with the x axis:
$sel move [transvecinv $vec12]

# Rotate -90 about y in order to align it with the z axis:
$sel move [transaxis y -90]

# Save the changes and exit:
$sel writepdb z.pdb

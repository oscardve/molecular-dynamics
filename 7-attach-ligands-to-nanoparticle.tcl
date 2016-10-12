The following is the procedure followed for the building of the Au144 NP functionalized by the MUS ligand:

I. Generate a pdb file containing one MUS ligand. The "Molefacture" plugin of VMD was employed, and the result was the following:

CRYST1    0.000    0.000    0.000  90.00  90.00  90.00 P 1           1
ATOM      1  C   MUS O   1       4.090   2.532   3.536  0.80  0.00      O1   C
ATOM      2  H2  MUS O   1       4.662   3.013   4.200  0.80  0.00      O1   H
ATOM      3  H3  MUS O   1       4.624   2.315   2.719  0.80  0.00      O1   H
ATOM      4  C2  MUS O   1       2.942   3.416   3.149  0.80  0.00      O1   C
ATOM      5  H4  MUS O   1       2.299   2.889   2.411  0.80  0.00      O1   H
ATOM      6  H5  MUS O   1       2.315   3.666   4.033  0.80  0.00      O1   H
ATOM      7  C3  MUS O   1       3.416   4.694   2.523  0.80  0.00      O1   C
ATOM      8  H6  MUS O   1       4.056   5.246   3.243  0.80  0.00      O1   H
ATOM      9  H7  MUS O   1       4.021   4.491   1.613  0.80  0.00      O1   H
ATOM     10  C4  MUS O   1       2.268   5.582   2.145  0.80  0.00      O1   C
ATOM     11  H8  MUS O   1       1.669   5.820   3.050  0.80  0.00      O1   H
ATOM     12  C5  MUS O   1       2.757   6.875   1.561  0.80  0.00      O1   C
ATOM     13  H9  MUS O   1       1.596   5.092   1.408  0.80  0.00      O1   H
ATOM     14  H10 MUS O   1       3.304   7.368   2.237  0.80  0.00      O1   H
ATOM     15  H11 MUS O   1       3.304   6.694   0.744  0.80  0.00      O1   H
ATOM     16  C6  MUS O   1       1.575   7.716   1.181  0.80  0.00      O1   C
ATOM     17  H12 MUS O   1       0.960   7.176   0.430  0.80  0.00      O1   H
ATOM     18  H13 MUS O   1       0.933   7.925   2.063  0.80  0.00      O1   H
ATOM     19  C7  MUS O   1       1.999   9.023   0.578  0.80  0.00      O1   C
ATOM     20  H14 MUS O   1       2.611   9.590   1.313  0.80  0.00      O1   H
ATOM     21  H15 MUS O   1       2.618   8.861  -0.331  0.80  0.00      O1   H
ATOM     22  C8  MUS O   1       0.818   9.869   0.207  0.80  0.00      O1   C
ATOM     23  H16 MUS O   1       0.204  10.067   1.112  0.80  0.00      O1   H
ATOM     24  C9  MUS O   1       1.256  11.190  -0.352  0.80  0.00      O1   C
ATOM     25  H17 MUS O   1       0.172   9.364  -0.543  0.80  0.00      O1   H
ATOM     26  H18 MUS O   1       1.779  11.695   0.335  0.80  0.00      O1   H
ATOM     27  H19 MUS O   1       1.815  11.046  -1.168  0.80  0.00      O1   H
ATOM     28  C10 MUS O   1       0.043  11.989  -0.726  0.80  0.00      O1   C
ATOM     29  H20 MUS O   1      -0.546  11.436  -1.490  0.80  0.00      O1   H
ATOM     30  H21 MUS O   1      -0.612  12.156   0.156  0.80  0.00      O1   H
ATOM     31  C11 MUS O   1       0.416  13.322  -1.304  0.80  0.00      O1   C
ATOM     32  H22 MUS O   1       1.000  13.901  -0.556  0.80  0.00      O1   H
ATOM     33  H23 MUS O   1       1.046  13.201  -2.211  0.80  0.00      O1   H
ATOM     34  S2  MUS O   1      -0.797  14.125  -1.668  0.80  0.00      O1   S
ATOM     35  O   MUS O   1      -1.424  14.282  -0.764  0.80  0.00      O1   O
ATOM     36  O2  MUS O   1      -0.511  15.123  -2.064  0.80  0.00      O1   O
ATOM     37  O3  MUS O   1      -1.418  13.606  -2.430  0.80  0.00      O1   O
END

II. Since every sulfur is part of a residue containing three gold atoms and two sulfur atoms, all bound covalently together, the topology of the structure should contain all atoms of such residue, each with a unique name. For this purpose, a copy of the MUS residue was made and placed in the same pdb file, along with the three gold atoms. At the end, there should be one pdb file containing all such residues, along with the gold atoms at the core. When combining multiple pdb files into one, the following Linux script may be employed:

#name of output file containing all ligands:
> ligall.pdb

#suppose there are 30 pdb files, called lig0.pdb, lig1.pdb, etc...:
number=0
until [ "$number" -ge 30 ]; do
    cat lig$number.pdb >> ligall.pdb
    number=$((number + 1))
done

#merge the pdb containing the core with the pdb containing the ligands:
cat core.pdb ligall.pdb > out.pdb

#remove all the lines containing the words "END" and "CRYST1":
sed -i '/END/d' out.pdb
sed -i '/CRYST1/d' out.pdb

#add the first and last lines of the pdb file:
sed -i '1s/^/CRYST1    0.000    0.000    0.000  90.00  90.00  90.00 P 1           1\n/' out.pdb
echo 'END' >> out.pdb

III. Now that all the ligands and the core are contained in the same pdb file, the ligands may be arranged symmetrically around the core with the following script:

for {set i 1} {$i<=30} {incr i} {
  #Move the ligand so that C lies at the origin:
  set sel [atomselect top "name C and resid $i"]
  set x0 [$sel get x]
  set y0 [$sel get y]
  set z0 [$sel get z]
  set x0 [expr -1*$x0]
  set y0 [expr -1*$y0]
  set z0 [expr -1*$z0]
  [atomselect top "resid $i and (not name AU AUS AUSB SG SGB)"] moveby [list $x0 $y0 $z0]
  
  #Find the phi angle of the vector from the origin to C11:
  set sel [atomselect top "name C11 and resid $i"]
  set x0 [$sel get x]
  set y0 [$sel get y]
  set phi1 [expr atan2($y0,$x0)]
  
  #Find the phi angle of the vector from the origin to SG:
  set sel [atomselect top "name SG and resid $i"]
  set x0 [$sel get x]
  set y0 [$sel get y]
  set phi2 [expr atan2($y0,$x0)]
  
  #Find the first Euler angle (about the z axis) and rotate the ligand:
  set dphi [expr ($phi2-$phi1)]
  set rotaboutz [transaxis z $dphi rad]
  [atomselect top "resid $i and (not name AU AUS AUSB SG SGB)"] move $rotaboutz
  
  #Repeat for the second Euler angle (angle xi, about the x axis):
  set sel [atomselect top "name C11 and resid $i"]
  set y0 [$sel get y]
  set z0 [$sel get z]
  set xi1 [expr atan2($z0,$y0)]
  set sel [atomselect top "name SG and resid $i"]
  set y0 [$sel get y]
  set z0 [$sel get z]
  set xi2 [expr atan2($z0,$y0)]
  set dxi [expr ($xi2-$xi1)]
  set rotaboutx [transaxis x $dxi rad]
  [atomselect top "resid $i and (not name AU AUS AUSB SG SGB)"] move $rotaboutx
  
  #Repeat for the third Euler angle (angle nu, about the y axis):
  set sel [atomselect top "name C11 and resid $i"]
  set x0 [$sel get x]
  set z0 [$sel get z]
  set nu1 [expr atan2($x0,$z0)]
  set sel [atomselect top "name SG and resid $i"]
  set x0 [$sel get x]
  set z0 [$sel get z]
  set nu2 [expr atan2($x0,$z0)]
  set dnu [expr ($nu2-$nu1)]
  set rotabouty [transaxis y $dnu rad]
  [atomselect top "resid $i and (not name AU AUS AUSB SG SGB)"] move $rotabouty
  
  #Find vector from C to SG:
  set sel [atomselect top "name C and resid $i"]
  set x0 [$sel get x]
  set y0 [$sel get y]
  set z0 [$sel get z]
  set sel [atomselect top "name SG and resid $i"]
  set x1 [$sel get x]
  set y1 [$sel get y]
  set z1 [$sel get z]
  set dx [expr $x1-$x0]
  set dy [expr $y1-$y0]
  set dz [expr $z1-$z0]
  set vecCSG [list $dx $dy $dz]
  set abs [veclength $vecCSG]
  set abs [expr 1/$abs]
  set vecCSGunit [vecscale $abs $vecCSG]
  
  #Find vector from SG to SGB:
  set sel [atomselect top "name SG and resid $i"]
  set x0 [$sel get x]
  set y0 [$sel get y]
  set z0 [$sel get z]
  set sel [atomselect top "name SGB and resid $i"]
  set x1 [$sel get x]
  set y1 [$sel get y]
  set z1 [$sel get z]
  set dx [expr $x1-$x0]
  set dy [expr $y1-$y0]
  set dz [expr $z1-$z0]
  set vecSGSGB [list $dx $dy $dz]
  
  #Find vector from C12 to C:
  set sel [atomselect top "name C12 and resid $i"]
  set x0 [$sel get x]
  set y0 [$sel get y]
  set z0 [$sel get z]
  set sel [atomselect top "name C and resid $i"]
  set x1 [$sel get x]
  set y1 [$sel get y]
  set z1 [$sel get z]
  set dx [expr $x1-$x0]
  set dy [expr $y1-$y0]
  set dz [expr $z1-$z0]
  set vecC12C [list $dx $dy $dz]
  
  #Find angle between the SG-SGB and the C12-C vectors:
  set cross1 [veccross $vecC12C $vecCSG]
  set cross2 [veccross $vecCSG $vecSGSGB]
  set cross3 [veccross $cross1 $cross2]
  set dot1 [vecdot $cross1 $cross2]
  set dot2 [vecdot $cross3 $vecCSGunit]
  set angle  [expr atan2($dot2,$dot1)]
  
  #Rotate the ligand about the axis going from C to SG using the previous angle:
  set rotaboutvec [transabout $vecCSG $angle rad]
  [atomselect top "resid $i and (not name AU AUS AUSB SG SGB)"] move $rotaboutvec
  
  #Displace the ligand radially towards atom SG in the surface:
  set sel [atomselect top "name SG and resid $i"]
  set x0 [$sel get x]
  set y0 [$sel get y]
  set z0 [$sel get z]
  set theta [expr atan2(sqrt($x0*$x0+$y0*$y0),$z0)]
  set phi [expr atan2($y0,$x0)]
  set rf [expr sqrt($x0*$x0+$y0*$y0+$z0*$z0)+25]
  set dx [expr $rf*sin($theta)*cos($phi)]
  set dy [expr $rf*sin($theta)*sin($phi)]
  set dz [expr $rf*cos($theta)]
  [atomselect top "resid $i and (not name AU AUS AUSB SG SGB)"] moveby [list $dx $dy $dz]
}
[atomselect top all] writepdb np.pdb

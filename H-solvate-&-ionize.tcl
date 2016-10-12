#generate a water box around the system, of dimensions given by the coordinates in brackets:
package require solvate
solvate in.psf in.pdb -minmax { { -50 -50 -50 } { 50 50 70 } } -o wb ;# where: {{ xmin  ymin zmin }{ xmax ymax zmax }}

#neutralize the system and generate a NaCl concentration of 150 mM:
package require autoionize
autoionize -psf wb.psf -pdb wb.pdb -sc 0.15 -o out

However, if the desired ion is not part of the standard VMD options, it will become necessary to replace every ion by the new atom or molecule, for which I wrote the following scripts. Suppose we wish to replace every chloride by a hydroxide:

set outfile [open "coor-cl.r" w]
set clindex [[atomselect top "name CLA"] get {x y z}]
foreach {i} $clindex {
puts $outfile "$i"
}
close $outfile
set sel [atomselect top "not water and not name CLA"]
$sel writepdb zwi2.pdb

Now load the pdb file containing one hydroxide molecule and make a copy of the molecule at every place chloride was located previously:

[atomselect top all] moveby [vecscale -1 [measure center [atomselect top all]]]; #center
set infile [open "coor-cl.r" r]
set content [split [read $infile] \n];# each element contains one row
set empty [lsearch $content ""]; set content [lreplace $content $empty $empty]; #remove empty rows
set i 1
foreach {row} $content {
 set vcl $row
 [atomselect top all] moveby $row
 [atomselect top all] set resid $i
 [atomselect top all] writepdb oh-$i.pdb
 [atomselect top all] moveby [vecscale -1 [measure center [atomselect top all]]]; #center
 set i [expr $i+1]
}

Next use the Linux terminal to merge all the hydroxide molecules into one file:

number=1
until [ "$number" -ge 1000 ]; do
    cat oh-$number.pdb >> ohall.pdb
    number=$((number + 1))
done
cat zwi2.pdb ohall.pdb > zwi3.pdb
sed -i '/END/d' zwi3.pdb
sed -i '/CRYST1/d' zwi3.pdb
sed -i '1s/^/CRYST1    0.000    0.000    0.000  90.00  90.00  90.00 P 1           1\n/' zwi3.pdb
echo 'END' >> zwi3.pdb

Finally, generate a new psf file of the system, solvate, and ionize, as done previously.

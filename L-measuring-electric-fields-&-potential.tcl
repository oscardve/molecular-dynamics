# Set Output:
set outfile [open "pmba.dat" w] ;# w -> erase file and open for writing

# Set Frames:
set framei 1000
set framef 1100
set frames [expr $framef-$framei]

# Variables:
set dr -0.1
set r_max 40
set V_old 0

#Calculate for all distances <= $r_max:
for {set r $r_max} {$r>0} {set r [expr $r+$dr]} { ;# for {initialization} {test} {increment} {}

  #Calculate charge of sphere (units of Cx10-19) with radius r and of all frames in the trajectory > $framei:
  set q 0 ;#reset charge to 0
  for {set fr $framei} {$fr < $framef} {incr fr} {
  set center [measure center [atomselect top "resname NPAU"]]
  set xcenter [lindex $center 0]
  set ycenter [lindex $center 1]
  set zcenter [lindex $center 2]
  set sel [atomselect top "(x-$xcenter)**2 + (y-$ycenter)**2 + (z-$zcenter)**2 < $r**2" frame $fr]
    set q [expr $q + [eval vecsum {[$sel get charge]}] ] ;# vecsum {1 2 3} = 6 (sum charges of atoms)
    $sel delete
  }

  #The electric field without multiplying by the Coulomb constant E [e/(A^2)]:
  set E($r) [expr ($q/$frames)/$r**2]

  #The potential at r : 
  #dV (Volts) = - E*dr = (E e/A^2)*[ (8.987E9 N.m^2/C^2) * (1.602E-19 C/e) / (1E-10 m/A)^2 ] * (dr A)*(1E-10 m/A) 
  #= (E e/A^2) * (dr A) * (14.397 N.m.A/C.e) = 14.397*E*dr Volts
  set V($r) [expr $V_old - $E($r)*$dr*14.397]
  set V_old $V($r)

  puts $outfile "[expr $r/10]	$E($r)	$V($r)" ;# save the charge density at distance r
  puts "[expr $r/10]	$E($r)	$V($r)" ;# print the value in the tk console
}

close $outfile

If the charge distribution is not geometrically simple, the PMEpot plugin of VMD can be used:

I. Using a 150x150x500 grid (i.e. 150 points along x and y, and 500 points along z):
package require pmepot
set all [atomselect top "all"]
pmepot -sel $all -frames all -xscfile box.xsc -grid {150 150 500} -dxfile eqpot.dx -ewaldfactor 0.25

II. However, the output file called "eqpot.dx" is not written in a way which is plottable by programs like GNUplot. The electric potential is spread out over three columns. They may be combined into one column with the following command at the Linux terminal:
awk '{print $1"\n"$2"\n"$3}' eqpot.dx > vv.dat #and don't forget to erase the beginning and ending

III. Suppose you wish to plot the electric potential along the z axis, with x=y=0. Then, if you look at the "eqpot.dx" file, the first lines contain the location of the origin and the displacements along the x, y, z axes:
origin -48.395 -48.395 -72.7829
delta 0.762127 0 0
delta 0 0.762127 0
delta 0 0 0.762125

Therefore, we need to create a column with the z values across the box:
cstyle=\tiny]
cz=500
oz=-72.9533
dz=0.762125
fz=$(echo "$oz+$cz*$dz" | bc -l) #final value of z
seq $oz $dz $fz > vz.dat #start, increment, end

IV. Now we find the line of the "vv.dat" file containing the first value of potential along z, and extract the potential going along the z axis:
v0=$(echo "$cz*$cy*$cx/2+$cz*$cy/2" | bc) #line containing first value
vf=$(echo "$v0+$cz" | bc) #line containing last value
sed -n "$v0,$vf p" vv.dat > vv2.dat #save from line $v0 to line $vf

V. Finally, we merge the z values with the potential values into one file:
paste vz.dat vv2.dat > vnah2o.dat


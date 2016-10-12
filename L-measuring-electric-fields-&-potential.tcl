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

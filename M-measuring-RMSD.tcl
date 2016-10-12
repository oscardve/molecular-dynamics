# Set Output:
set outFile [open "rmsd.dat" w]

# Set initial values:
set startFrame 0
set numFrame [molinfo top get numframes]

# The inner Au114 core:
set reference1 [atomselect top "segname O1 or name AUS AUSB" frame $startFrame]
set compare1 [atomselect top "segname O1 or name AUS AUSB"]; #comparison frame

# The outer Au30S60 core:
set reference2 [atomselect top "segname O2 and name AU or name SG SGB" frame $startFrame]
set compare2 [atomselect top "segname O2 and name AU or name SG SGB"]; #comparison frame

# Gold core:
set reference3 [atomselect top "name AU AUS AUSB" frame $startFrame]
set compare3 [atomselect top "name AU AUS AUSB"]; #comparison frame

# The Ligand:
set reference4 [atomselect top "name C7 C27 O2 O20 N N2 HN1 HN2 HN3 HN21 HN22 HN23" frame $startFrame]
set compare4 [atomselect top "name C7 C27 O2 O20 N N2 HN1 HN2 HN3 HN21 HN22 HN23"]; #comparison frame

# The terminal group:
set reference5 [atomselect top "name S S2 O O2 O3 O4 O5 O6" frame $startFrame]
set compare5 [atomselect top "name S S2 O O2 O3 O4 O5 O6"]; #comparison frame

puts "Initialization complete... Starting at t = [expr $startFrame./1000] s..." 

# Calculation loop:
for {set frame $startFrame} {$frame < $numFrame} {incr frame} {
  set t [expr $frame./1000]; # time in ns (1 dcd frame -> 1 ps ; also use ./ to include decimals)

  #Note: using the "move" command more than once on an atom selection modifies the coordinates and thus the results. 
  #Therefore, reload the trajectory file after each use.

  # Inner core:
  $compare1 frame $frame; #get correct frame
  set trans_mat1 [measure fit $compare1 $reference1]; #compute frame transformation
  $compare1 move $trans_mat1
  set rmsd1 [expr [measure rmsd $compare1 $reference1]/10.0]

  # Outer core:
  $compare2 frame $frame; #get correct frame
  set trans_mat2 [measure fit $compare2 $reference2]; #compute frame transformation
  $compare2 move $trans_mat2
  set rmsd2 [expr [measure rmsd $compare2 $reference2]/10.0]

  # Gold core:
  $compare3 frame $frame; #get correct frame
  set trans_mat3 [measure fit $compare3 $reference3]; #compute frame transformation
  $compare3 move $trans_mat3
  set rmsd3 [expr [measure rmsd $compare3 $reference3]/10.0]

  # Ligand:
  $compare4 frame $frame; #get correct frame
  set trans_mat4 [measure fit $compare4 $reference4]; #compute frame transformation
  $compare4 move $trans_mat4
  set rmsd4 [expr [measure rmsd $compare4 $reference4]/10.0]

  # Terminal group:
  $compare4 frame $frame; #get correct frame
  set trans_mat4 [measure fit $compare4 $reference4]; #compute frame transformation
  $compare4 move $trans_mat4
  set rmsd4 [expr [measure rmsd $compare4 $reference4]/10.0]

  # Write to output:
  puts $outFile "$t $rmsd1 $rmsd2 $rmsd3 $rmsd4"
  puts "$t $rmsd1 $rmsd2 $rmsd3 $rmsd4"
}
close $outFile

However, when measuring the rmsd of particles which go through the boundaries of the water box, for example in order to obtain the diffusion constant (which requires simply squaring the rmsd and dividing by twice the time), it becomes necessary to unwrap the trajectory, so that when the particle reaches the boundary, it may continue without reappearing on the opposite side of the unit cell. This is done in VMD with the following two lines:
animate goto start
pbc unwrap -first now


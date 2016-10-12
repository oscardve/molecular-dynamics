#Output file:
set outFile [open "rvst.dat" w]

#Atomic selections:
set L1 [atomselect top "resname AZA"]
set P1 [atomselect top "protein"]
set frames [molinfo top get numframes]

for {set frame 0} {$frame < $frames} {incr frame} {

  #Update selections to the new frame:
  $L1 frame $frame
  $P1 frame $frame
  
  #Measure centers of mass of each selection:
  set rL1 [measure center $L1 weight mass]
  set rP1 [measure center $P1 weight mass]
  
  #Measure separation between the centers of mass:
  set r [expr [veclength [vecsub $rL1 $rP1]]]
  
  #Output the results:
  puts $outFile "$frame $r"
  puts "$frame $r"
}
close $outFile

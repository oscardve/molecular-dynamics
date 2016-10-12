set Tav 0
set Pav 0
set Psav 0
set tav 0
set pav 0
set rav 0
set L1 [atomselect top "name AUC1 and segname O2"]
set L2 [atomselect top "name AUC2 and segname O3"]
set L3 [atomselect top "name AUC1 and segname O3"]
set P1 [atomselect top "name AUC2 and segname O8"]
set P2 [atomselect top "name AU1 and segname O7"]
set P3 [atomselect top "name AU1 and segname O8"]
set frame0 8352
set outfile [open "bound3.dat" w]
set nFrames [molinfo top get numframes]

for {set frame $frame0} {$frame < $nFrames} {incr frame} {
  set t [expr ($frame-$frame0)/1000.0]; # time in ns
  
  #Get frame
  $L1 frame $frame
  $L2 frame $frame
  $L3 frame $frame
  $P1 frame $frame
  $P2 frame $frame
  $P3 frame $frame
  
  #Centers of mass:
  set rL1 [measure center $L1 weight mass]
  set rL2 [measure center $L2 weight mass]
  set rL3 [measure center $L3 weight mass]
  set rP1 [measure center $P1 weight mass]
  set rP2 [measure center $P2 weight mass]
  set rP3 [measure center $P3 weight mass]
  
  #Theta (in degrees): ?= P1-L1-L2
  set v21 [vecsub $rP1 $rL1]
  set v23 [vecsub $rL2 $rL1]
  set Theta [expr acos([vecdot $v21 $v23]/([veclength $v21]*[veclength $v23])) * 180.0/$M_PI]
  
  #Phi: P1-L1-L2-L3
  set v12 [vecsub $rL1 $rP1]
  set v23 [vecsub $rL2 $rL1]
  set v34 [vecsub $rL3 $rL2]
  set c1 [veccross $v12 $v23]
  set c2 [veccross $v23 $v34]
  set x [vecdot $c1 $c2]
  set y [vecdot [veccross $c1 $c2] [vecscale $v23 [expr 1/[veclength $v23]]]]
  set Phi [expr atan2($y,$x) * 180.0/$M_PI]
  
  #Psi: P2-P1-L1-L2
  set v12 [vecsub $rP1 $rP2]
  set v23 [vecsub $rL1 $rP1]
  set v34 [vecsub $rL2 $rL1]
  set c1 [veccross $v12 $v23]
  set c2 [veccross $v23 $v34]
  set x [vecdot $c1 $c2]
  set y [vecdot [veccross $c1 $c2] [vecscale $v23 [expr 1/[veclength $v23]]]]
  set Psi [expr atan2($y,$x) * 180.0/$M_PI]
  
  #theta: L1-P1-P2
  set v21 [vecsub $rL1 $rP1]
  set v23 [vecsub $rP2 $rP1]
  set theta [expr acos([vecdot $v21 $v23]/([veclength $v21]*[veclength $v23])) * 180.0/$M_PI]
  
  #phi: L1-P1-P2-P3 
  set v12 [vecsub $rP1 $rL1]
  set v23 [vecsub $rP2 $rP1]
  set v34 [vecsub $rP3 $rP2]
  set c1 [veccross $v12 $v23]
  set c2 [veccross $v23 $v34]
  set x [vecdot $c1 $c2]
  set y [vecdot [veccross $c1 $c2] [vecscale $v23 [expr 1/[veclength $v23]]]]
  set phi [expr atan2($y,$x) * 180.0/$M_PI]
  
  #r (in nm): P1-L1
  set r [expr [veclength [vecsub $rL1 $rP1]]]
  
  puts "$frame of $nFrames"
  puts $outfile "$t $Theta $Phi $Psi $theta $phi $r"
  set Tav [expr $Tav + $Theta]
  set Pav [expr $Pav + $Phi]
  set Psav [expr $Psav + $Psi]
  set tav [expr $tav + $theta]
  set pav [expr $pav + $phi]
  set rav [expr $rav + $r]
}
close $outfile

set Tav [expr $Tav/($nFrames-$frame0)]
set Pav [expr $Pav/($nFrames-$frame0)]
set Psav [expr $Psav/($nFrames-$frame0)]
set tav [expr $tav/($nFrames-$frame0)]
set pav [expr $pav/($nFrames-$frame0)]
set rav [expr $rav/($nFrames-$frame0)]

puts "Last values:"
puts "$t $Theta $Phi $Psi $theta $phi $r"
puts "Average values:"
puts "$Tav $Pav $Psav $tav $pav $rav"

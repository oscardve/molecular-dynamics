#output file:
set outfile [open "concentrations.dat" w]

#distance range:
set rMin 0.1
set dr 0.1
set rMax 50

#frame range:
set framei 0
set framef [molinfo top get numframes]

#atomic selections:
set gold [atomselect top "name AUC1 AUC2 AU1 AU2 AU3"]
set origin [measure center $gold]
set all [atomselect top all]
$all moveby [vecinv $origin]
set n10 [[atomselect top "name AUC1 AUC2 AU1 AU2 AU3 and x**2+y**2+z**2<$rMin**2"] num]
set n20 [[atomselect top "name C7 C14 C21 C28 and x**2+y**2+z**2<$rMin**2"] num]
set n30 [[atomselect top "name SOD and x**2+y**2+z**2<$rMin**2"] num]
set n40 [[atomselect top "name CLA and x**2+y**2+z**2<$rMin**2"] num]

for {set r $rMin} {$r<=$rMax} {set r [expr $r+$dr]} {

	set n1 0
	set n2 0
	set n3 0
	set n4 0
	
	for {set fr $framei} {$fr < $framef} {incr fr} {
	  
		#update frame:
		molinfo top set frame $fr
		set origin [measure center $gold]
		$all moveby [vecinv $origin]
		set sel1 [atomselect top "name AUC1 AUC2 AU1 AU2 AU3 and x**2+y**2+z**2<$r**2"]
		
		#sum over frames for each distance interval:
		set n1 [expr $n1+ [$sel1 num]]
		$sel1 delete
		set sel2 [atomselect top "name C7 C14 C21 C28 and x**2+y**2+z**2<$r**2"]
		set n2 [expr $n2+ [$sel2 num]]
		$sel2 delete
		set sel3 [atomselect top "name SOD and x**2+y**2+z**2<$r**2"]
		set n3 [expr $n3+ [$sel3 num]]
		$sel3 delete
		set sel4 [atomselect top "name CLA and x**2+y**2+z**2<$r**2"]
		set n4 [expr $n4+ [$sel4 num]]
		$sel4 delete		
	}
	
	#divide by number of frames and by volume:
	set n1f [expr ($n1-$n10)/(4*3.14*$r**2*$dr*($framef-$framei))]
	set n10 $n1
	set n2f [expr ($n2-$n20)/(4*3.14*$r**2*$dr*($framef-$framei))]
	set n20 $n2
	set n3f [expr ($n3-$n30)/(4*3.14*$r**2*$dr*($framef-$framei))]
	set n30 $n3
	set n4f [expr ($n4-$n40)/(4*3.14*$r**2*$dr*($framef-$framei))]
	set n40 $n4
	
	#save to output file:	
	puts $outfile "$r $n1f $n2f $n3f $n4f"
	puts "$r of $rMax"
}
close $outfile

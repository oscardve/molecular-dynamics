#output file:
set outfile [open "hbonds.dat" w]
set numFrame [molinfo top get numframes];# number of frames

#set selections of interest (in this case for the aquaporin 4 protein):
set sel1 [atomselect top "resname AZM"]
set sel2 [atomselect top "water"]
set sel3 [atomselect top "protein"]

#initialize variables:
set avg1 0.0
set avg2 0.0

for {set fr 0} {$fr < $numFrame} {incr fr} {
  
  #update frame:
  molinfo top set frame $fr
	
  #measure hydrogen bonds for this frame:
  set sel12 [llength [lindex [measure hbonds 3.5 30 $sel1 $sel2] 0]]
  set sel21 [llength [lindex [measure hbonds 3.5 30 $sel2 $sel1] 0]]
  set sel13 [llength [lindex [measure hbonds 3.5 30 $sel1 $sel3] 0]]
  set sel31 [llength [lindex [measure hbonds 3.5 30 $sel3 $sel1] 0]]
  set hbonds1 [expr $sel12 + $sel21]
  set hbonds2 [expr $sel13 + $sel31]	
  
  #accumulate hydrogen bond count:
  set avg1 [expr $avg1 + $hbonds1]
  set avg2 [expr $avg2 + $hbonds2]
  
  #output to file and console:
  puts $outfile "$fr $hbonds1 $hbonds2"
  puts "$fr of $numFrame"
}
close $outfile

#output average number of hydrogen bonds to console:
puts "Average no. of H-bonds with water = [expr $avg1/$numFrame]"
puts "Average no. of H-bonds with protein = [expr $avg2/$numFrame]"

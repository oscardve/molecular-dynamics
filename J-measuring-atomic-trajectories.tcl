# Select the atoms whose coordinates are of interest:
set sel1 [atomselect top "index 1"]
set sel2 [atomselect top "index 2"]
set sel3 [atomselect top "index 3"]
set outfile [open "xyz.dat" w]; # set output file for writing
set numFrame [molinfo top get numframes]; # total number of frames

# Loop over every frame:
for {set fr 0} {$fr < $numFrame} {incr fr} {
  molinfo top set frame $fr ;# update the frame of the top molecule
  puts $outfile "$fr [measure center $sel1] [measure center $sel2] [measure center $sel3]"
}
close $outfile

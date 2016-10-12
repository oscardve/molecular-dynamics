#measure the size in angstrom units:
set size [measure minmax [atomselect top all]]
set cell [vecsub [lindex $size 1] [lindex $size 0]]
puts "x (A) = [lindex $cell 0]"
puts "y (A) = [lindex $cell 1]"
puts "z (A) = [lindex $cell 2]"

#measure the center of mass:
puts "origin = [measure center [atomselect top all]]"

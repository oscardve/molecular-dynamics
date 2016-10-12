First create a file containing all the bonds to be added, and their spring constants and equilibrium values. A harmonic potential is introduced to every bond length:

#output file:
set outFile [open "bonds.dat" w]

#spring constant of the new bond interactions:
set k 10000

#indices of all the gold atoms:
set ids [[atomselect top "name AUC1 AUC2 AU1 AU2 AU3"] get index]

#for each atom-to-atom distance which is less than 8 angstrom,
#generate a harmonic potential whose equilibrium value is the original distance:
foreach {id1} $ids {
	foreach {id2} $ids {
		if {$id2 > $id1} { 
			set ref [measure bond "$id1 $id2"]
			if {$ref<8} {puts $outFile "bond $id1 $id2 $k $ref"}
		}
	}
}

After generating the "bonds.dat" file, the following lines are added to the NAMD configuration file:

extraBonds      on; #enable extra bonded terms?
extraBondsFile  bonds.dat;#file containing extra bonded terms

In this way, the core is made to behave extremely rigidly, while still being allowed to be translated and rotated freely.

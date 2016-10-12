Suppose you wish to mutate residue number 178 of the human protein aquaporin 4 to a new user-defined residue called "CYG" contained in a topology file called "top\_CYG.inp". This protein contains four monomers, each denoted by a different "segname". Each monomer should first be separated into a different pdb file, and mutated before merging again into a tetramer. The program "psfgen" may be employed in the following way:

foreach {i} {1 2 3 4} { 
[atomselect top "segname P$i"] writepdb prot$i.pdb }
[atomselect top "not protein"] writepdb notprot.pdb
[atomselect top "not protein"] writepsf notprot.psf
package require psfgen
topology top_CYG.inp
topology top_all36_prot.rtf
resetpsf
foreach {i} {1 2 3 4} {
  segment P$i {
    pdb prot$i.pdb
    mutate 178 CYG
  }
}
foreach {i} {1 2 3 4} { coordpdb prot$i.pdb }
guesscoord
readpsf notprot.psf
coordpdb notprot.pdb
writepsf aqp4.psf
writepdb aqp4.pdb

if {0} { 
JOB DESCRIPTION
This program calculates the amount of ionic and h-bond interactions between the terminal groups of an AuNP and the solvent 
(NaCl and water) in which it is immersed.
}

# Set Output:
set system mpsmps
set outFile [open "dat-contacts-$system.r" w]

# Set initial values:
set cutoff 3.5;# for both ionic contacts and H-bonds
set srad 1.4;# extend each atomic radius by srad to calculate the SASA
set angle 30;# for H-bonds
set numFrame [molinfo top get numframes]
#set startFrame [expr $numFrame - 1000];# analyze the last 1 ns of the simulation
set startFrame 0

# Set selections:
set selNa [atomselect top "name SOD"]
set selCl [atomselect top "name CLA"]
set selWater [atomselect top "water"]
set selWaterOxygen [atomselect top "water and oxygen"]
set selTGroup [atomselect top "segname O2 O4 and name S S2 O O2 O3 O4 O5 O6"]
set selPhobic [atomselect top "segname O2 O4 and not name AU AUS AUSB SG SGB S S2 O O2 O3 O4 O5 O6"]
set com1 [atomselect top "resname NPAU and segname O1 and resid 1 2 10 11 19 20 28 29 37 38 46 47"]
set com2 [atomselect top "resname NPAU and segname O3 and resid 1 2 10 11 19 20 28 29 37 38 46 47"]
# (note1: "only non-hydrogen atoms are considered in either selection")
# (for mpm use: N N2 H11 H12 H13 H24 H25 H26)
puts "Initialization Complete."

for {set fr $startFrame} {$fr < $numFrame} {incr fr} {

  # Update frame of (nonchanging) selections:
  $selNa frame $fr
  $selCl frame $fr
  $selWater frame $fr
  $selWaterOxygen frame $fr
  $selTGroup frame $fr
  $selPhobic frame $fr
  $com1 frame $fr
  $com2 frame $fr

  ### TERMINAL GROUP - NACL INTERACTIONS ###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # Ionic contacts between the terminal groups and Na+:
  # (note1: multiple contacts may be made per ion)
  # (note2: "contacts" returns 2 lists: indices from 1st selection, and indices from 2nd selection)
  set NaNum 0
  set NaConNum 0
  set index [measure contacts $cutoff $selNa $selTGroup]
  set NaIndex [lindex $index 0]; #indices of ions making contact
  if { [llength $NaIndex] > 0 } { 
    set NaWithin [lsort -unique $NaIndex]; #remove all repeated indices
    set selNaWithin [atomselect top "index $NaWithin"]
    set NaNum [$selNaWithin num]; #amount of ions making contacts with the terminal group
    set NaConNum [llength $NaIndex];# amount of ionic contacts
  }

  # Ionic contacts between the terminal groups and Cl-:
  set ClNum 0
  set ClConNum 0
  set index [measure contacts $cutoff $selCl $selTGroup]
  set ClIndex [lindex $index 0]; #indices of ions making contact
  if { [llength $ClIndex] > 0 } { 
    set ClWithin [lsort -unique $ClIndex]; #remove all repeated indices
    set selClWithin [atomselect top "index $ClWithin"]
    set ClNum [$selClWithin num]; #amount of ions making contacts with the terminal group
    set ClConNum [llength $ClIndex];# amount of ionic contacts
  }

  # H-bonds between the positive terminal groups' hydrogens (donor) and Cl- (acceptor):
  # (note1: 1st selection is the donor, 2nd is the acceptor)
  # (note2: "hbonds" returns 3 lists: donor indices, acceptor indices, hydrogen indices)
  set tGroupClHB 0
  if { [llength $ClIndex] > 0 } { 
    set index [measure hbonds $cutoff $angle $selTGroup $selClWithin]
    set tGroupClHB [llength [lindex $index 0]]  
  }

  ### TERMINAL GROUP - WATER INTERACTIONS ###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # H-bonds between the terminal groups' hydrogens (donor) and water's oxygen (acceptor), useful for AuNP+:
  set index [measure hbonds $cutoff $angle $selTGroup $selWater]
  set tGroupWaterHB [llength [lindex $index 0]]

  # H-bonds between the terminal groups (acceptor) and water's hydrogens (donor), useful for AuNP-:
  set index [measure hbonds $cutoff $angle $selWater $selTGroup]
  set waterTGroupHB [llength [lindex $index 0]]

  ### NACL - WATER INTERACTIONS NEAR THE TERMINAL GROUP ###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # Ionic contacts between water's oxygen and the Na+ in contact with the terminal groups:
  set NaWaterOxygenConNum 0
  if { [llength $NaIndex] > 0 } { 
    set index [measure contacts $cutoff $selWaterOxygen $selNaWithin]
    set NaWaterOxygenConNum [llength [lindex $index 0]]
  }
  # H-bonds between water's hydrogen (donor) and the Cl- in contact with the terminal groups (acceptor):
  set ClWaterHB 0
  if { [llength $ClIndex] > 0 } { 
    set index [measure hbonds $cutoff $angle $selWater $selClWithin]
    set ClWaterHB [llength [lindex $index 0]] 
  }
  ### SOLVENT-ACCESSIBLE SURFACE AREA OF THE HYDROPHOBIC PORTION OF THE LIGAND ###~~~~~~~~~~~~~~~

  set sasa [measure sasa $srad $selPhobic]

  ### SEPARATION BETWEEN CENTERS OF MASS ###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  set center1 [measure center $com1]
  set z1 [lindex $center1 2]
  set center2 [measure center $com2]
  set z2 [lindex $center2 2]
  set dist [expr abs($z1-$z2)/10];#convert the com separation to nm

  # Output:
  puts $outFile "$dist $NaNum $NaConNum $ClNum $ClConNum $tGroupClHB $tGroupWaterHB $waterTGroupHB $NaWaterOxygenConNum 
  $ClWaterHB $sasa"
  puts "$dist $NaNum $NaConNum $ClNum $ClConNum $tGroupClHB $tGroupWaterHB $waterTGroupHB $NaWaterOxygenConNum 
  $ClWaterHB $sasa"
}

close $outFile

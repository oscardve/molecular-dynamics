# Set Output:
set system pmbmpmbm
set outFile [open "sasa-$system.dat" w]

# Set initial values:
set numFrame [molinfo top get numframes]
set startFrame 0
set srad 1.4;# extend each atomic radius by srad to calculate the SASA

# Set selections:
set selPhobic [atomselect top "segname O2 O4 and not name AU AUS AUSB SG SGB C7 C27 O2 O20 N N2 HN1 HN2 HN3 HN22 HN21 HN23"]

set com1 [atomselect top "resname NPAU and segname O1 and resid 1 2 10 11 19 20 28 29 37 38 46 47"]
set com2 [atomselect top "resname NPAU and segname O3 and resid 1 2 10 11 19 20 28 29 37 38 46 47"]
puts "Initialization Complete."

for {set fr $startFrame} {$fr < $numFrame} {incr fr} {

  # Update frame of (nonchanging) selections:
  $selPhobic frame $fr
  $com1 frame $fr
  $com2 frame $fr
  
  ### SOLVENT-ACCESSIBLE SURFACE AREA OF THE HYDROPHOBIC PORTION OF THE LIGAND 

  set sasa [measure sasa $srad $selPhobic]

  ### SEPARATION BETWEEN CENTERS OF MASS 
  
  set center1 [measure center $com1]
  set z1 [lindex $center1 2]
  set center2 [measure center $com2]
  set z2 [lindex $center2 2]
  set dist [expr abs($z1-$z2)/10];#convert the com separation to nm

  # Output:
  puts $outFile "$dist $sasa"
  puts "$dist $sasa"
}
close $outFile

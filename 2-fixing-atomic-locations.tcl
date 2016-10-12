I. For an NAMD simulation through VMD:

# Set beta=0 for all atoms:
[atomselect top all] set beta 0

# Set beta=1 for the fixed atoms:
[atomselect top "index 1"] set beta 1

# Generate input file:
[atomselect top all] writepdb z-fix.pdb

II. For a GROMACS simulation:

#Create an index.ndx file containing the group which you want to fix:
gmx make_ndx -f conf.gro

#the group will contain atoms with the following names 
#(note: if the group already appears there, then you don't need to create an index.ndx file)
a AUC1 AUC2 AU1 AU2 AU3 S1 S2 S3 S4

#rename the new group (which in this case was number 14) to "CORE":
name 14 CORE

#save and quit (this will generate a file "index.ndx" containing all of the groups):
q

#Add the following lines to the .mdp file in order to fix the group:
freezegrps = CORE
freezedim = Y Y Y  ; Y or N for x,y,z (one column each)

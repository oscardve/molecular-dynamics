The following is an all-purpose and commented NAMD input file that I wrote and used intensively during my PhD studies:

########################################################################################################
## JOB DESCRIPTION                                         					      ##
########################################################################################################

if {0} {

This is an all-purpose NAMD input file I wrote with comments for every parameter.

Notes:
1. The default values for each parameter are stated as def=...
2. To activate and function change 0 to 1. To deactivate change 1 to 0.
3. Everything starting with the # symbol will not be read by NAMD.
}

########################################################################################################
## ADJUSTABLE PARAMETERS                       							      ##
########################################################################################################

## SETTING VARIABLES ---------------------------------------------------------------------------------##

## Input/Output:
set input           0/z0; #input prefix
set output          1/z1; #output prefix
set restart	    	0; #continue from restart files?

## Ensemble:
set constantT	    1; #activate constant temperature controls?
set constantP	    1; #activate constant pressure controls?
set collVar         0; #activate a collective variable?
set min		    	1; #minimize energy?
set MD              1; #do molecular dynamics?

## Simulation:
timestep            1; #length of time step to solve Newtonian eq. (femtoseconds) ;def=1
set temperature     298; #random vels. are assigned to atoms from a Maxwell distribution
set minSteps	    10000; #minimization steps
set runSteps	    250000; #MD/Collvars steps
if {$collVar && !$MD} {
numsteps            $runSteps; #equivalent to "run" (which must be deactivated, or "numsteps" will be overriden
}

## INPUT FILES --------------------------------------------------------------------------------------##

## System:
coordinates         0/z0.pdb; #initial coordinates
structure           0/z0.psf; #topology

## Restart:
if {$restart} {
binCoordinates      $input.restart.coor; #binary initial coordinates
extendedSystem	    $input.restart.xsc; #read the periodic cell parameters from an xsc file
#firsttimestep 	    0 ;#last step of previous run;def=0
}
if {$restart && [file exists $input.restart.vel]} {
binVelocities       $input.restart.vel; #binary initial velocities
} else { 
temperature         $temperature; # initial vels. are determined by either T or the vel./binvel., not by both
}
if {$restart && [file exists $input.restart.colvars.state]} {
colvarsInput        $input.restart.colvars.state
#file containing the current state of all coll. vars. (used when continuing a prev. simulation)
}
  

########################################################################################################
## SIMULATION PARAMETERS                                   				              ##
########################################################################################################

## INPUT PARAMETERS ----------------------------------------------------------------------------------##

## Force-field:
paraTypeCharmm      on; # the parameter file is in the CHARMM format
parameters          0/par_all36_cgenff_captopril.inp
parameters          0/par_all27_prot_lipidNBFIX.prm

## Tabulated nonbonded interaction (replace normal vdw inter. (not elec.) by user-supplied energy tables):
if {0} {
tabulatedEnergies       yes; #will tabulated energies be used for vdw inter. between pairs of atom types?
tabulatedEnergiesFile   ../../0common/tabul_AUAU.dat; #provide energy table for each inter. type in parameter file
tableInterpType         linear; #(or cubic) specify order for interpolating between energy table entries
}

## PERIODIC BOUNDARY CONDITIONS ----------------------------------------------------------------------##

## Unit cell (do not set the periodic cell basis if you have also specified an .xsc restart file):
dcdUnitCell         yes; #write unit cell data to dcd file?;def=yes if periodic cell
if {!$restart} { 
cellBasisVector1    106.14999771118164    0.    0.; #system length in x
cellBasisVector2    0.    104.70999908447266    0.; #system length in y
cellBasisVector3    0.    0.    112.78800201416016; #system length in z
cellOrigin          -0.2274264544248581  -0.16160894930362701  5.305692672729492; #geometric center of syst.;def=0 0 0
}

## Wrapping:
wrapWater           on; #wrap water coords. around periodic boundaries (translate to other side)?;def=off
wrapAll             on; #wrap all contiguous clusters of bonded atoms around periodic boundaries?;def=off
#wrapNearest 	    off; #use for non-rectangular unit cells;def=off

## FORCE-FIELD PARAMETERS ----------------------------------------------------------------------------##

## Basic dynamics:
exclude             scaled1-4; #neglect non-bonded inters. of 1-2, 1-3 bonded atoms; weaken for 1-4
1-4scaling          1; #turn on 1-4 atom electrostatic interactions to the maximum (0->1)
#COMmotion           no; #will the initial motion of the center of mass of the system be allowed?def=no
#dielectric          1.0; #when >1, the elec. forces are lessened;def=1
#zeroMomentum        no; #remove momentum before every electrostatics step;def=no

## Cut-offs:
switching           on; #switching functions smoothly take elec. and vdw interactions to 0 at cutoff;def=off
switchdist          9; #distance at which modification of inter. begins, to allow approach to 0
cutoff              10; #max. distance of elec. and vdw interaction
pairlistdist        12; #max. distance between atoms with elec. and vdw interaction;def=cutoff
#hgroupcutoff        2.8; #should be twice the largest distance between H and its mother (added to margin);def=2.5

## INTEGRATOR  ---------------------------------------------------------------------------------------##

## Multiple timesteps & space partitioning (parallelism):
nonbondedFreq       2; #how often nonbonded inter. are calculated;def=1
fullElectFrequency  4; #how often elec. inter. are calculated;def=nonbondedFreq
stepspercycle       20; #steps before atoms are reassigned pairlists (verifying pairlistdist);def=20
#margin              3.0; #determines size of space cubes used to partition the system ;def=0@NVT,>0@NPT
#splitpatch          hydrogen; #def=hydrogen

## Shake/rattle:
rigidBonds          water; #which bonds involving H are rigid (non-vibrating): none,water,all;def=none
#rigidtolerance      0.00001
#rigiditerations     400

## PME for full-system periodic electrostatics:
PME                yes; #turn on Particle Mesh Ewald;def=no
PMEGridSizeX       128; #number of grid points in x dimension (grid spacing = length in x / pmegridsizex)
PMEGridSizeY       128; #number of grid points in y dimension
PMEGridSizeZ       128; #number of grid points in z dimension
#PMETolerance       10e-6;def=10e-6
#PMEInterpOrder     4;def=4
#PMEGridSpacing     1.0

## ENSEMBLE ---------------------------------------------------------------##

## Constant temperature control. 
#Langevin dynamics: additional damping and random forces are introduced:
if {$constantT} {
langevin            on; #do langevin dynamics;def=off
langevinDamping     5; #damping coefficient (gamma, 1/ps, increase when T is increasing)
langevinTemp        $temperature; #random noise at this level
#langevinHydrogen    on; #couple bath to hydrogens?;def=on
}

## Constant pressure control. 
#Langevin piston Nose-Hoover method: The unit cell ('piston') is adjusted and the atomic coordinates rescaled. 
#Langevin dynamics is applied to the piston, coupling it to a 'heat bath' by controlling its fluctuations.
if {$constantP} {
useGroupPressure      yes; #needed for 2fs steps (needed for rigid bonds);def=no
useFlexibleCell       yes; #no for water box, yes for membrane (anisotropic systems);def=no
useConstantArea       yes; #no for water box, maybe for membrane (fix the lipid cross-sectional area);def=no
langevinPiston        on; #def=off
langevinPistonTarget  1.01325; #recommendation=1.01325 bar (=1 atm)
langevinPistonPeriod  200.; #oscillation period;recommendation=200fs
langevinPistonDecay   50.; #oscillation decay time (smaller->larger random forces);recommendation<=langevinPistonPeriod
langevinPistonTemp    $temperature; #coupled to heat bath
#strainrate           0.  0.  0.;#def=0.  0.  0.
}

## OUTPUT --------------------------------------------------------------------------------------------##

## Output file names:
outputname          $output; #file prefix for output coords, vels & restart files
#restartname        abf_window1; #file prefix for restart files
binaryoutput        yes; #the final output files will be writen in binary rather than pdb format;def=yes
binaryrestart       yes; #the restart files will be written in binary rather than pdb format;def=yes
dcdfile             ${output}.dcd; #stores the trajectory of all atom position coordinates
#velDCDfile	    ${output}vel.dcd; #stores the trajectory of all atom velocities
xstFile             ${output}.xst; #records periodic cell parameters and extended system variables

## Output frequencies:
restartfreq         1000; #time steps between writing coord. and vel. to restart files
dcdfreq             1000; #time steps between writing coords. to dcd file
#velDCDfreq	    1000; # timesteps between writing velocities to trajectory file
xstFreq             1000; #time steps between writing extended system configuration to xst file
outputEnergies      100; #time steps between output of system energies to .log file;def=1
#outputpressure     100; #def=0

########################################################################################################
## EXTRA PARAMETERS                           		  					      ##
########################################################################################################

## CONSTRAINTS & RESTRAINTS --------------------------------------------------------------------------##

## Fixed-atoms constraint:
if {0} {
fixedAtoms          yes; #whether or not fixed atoms are present
fixedAtomsFile      5/fix5.pdb; #pdb file to use for the fixed atom flags for each atom
fixedAtomsCol       B; #set beta non-zero to fix an atom
fixedAtomsForces    on; #whether or not forces between fixed atoms are calculated (they affect pressure)
}

## Harmonic constraints: each tagged atom is harmonically constrained (in all three spatial dimensions) to a reference point 
#which moves with constant velocity.
if {0} {
constraints         on; #are constraints active?
consexp             2; #exponent for harmonic constraint energy function
consref             5/res5.pdb;#pdb containing constraint reference positions
conskfile           5/res5.pdb;#pdb containing force constant values
conskcol            O; #column of pdb file containing force constant
selectConstraints   on; #restrain only selected cartesian components of the coordinates
selectConstrX       off; #restrain x components of coordinates
selectConstrY       off
selectConstrZ       on
}

#Extra bonds:
if {0} {
extraBonds      on; #enable extra bonded terms?
extraBondsFile  bonds.dat;#file containing extra bonded terms
}

## SMD -----------------------------------------------------------------------------------------------##

## Constant velocity SMD:
if {0} {
SMD	 	on; #should SMD harmonic constraint be applied?
SMDFile		2/smd2.ref; #forces are applied to nonzero occupancy atoms
SMDk		5; #SMD harmonic constraint force constant kcal/(mol*A^2)
SMDVel   	0.00002; #abs. value of velocity of the SMD center of mass (A/timestep)
SMDDir          0   0   -1; #direction of COM movement
SMDOutputFreq   100; #freq. of printing current timestep, COM position of restrained atoms, and force applied to COM (pN)
#use ft.tcl to make ft.dat and plot Fvst
}

## Constant force SMD: Apply constant forces to some atoms.
if {0} {
constantforce       yes; #apply const. forces?
consforcefile       z-smd.pdb;#pdb file containing forces: F = (X,Y,Z)*Occupancy kcal/(mol*A)
#consForceScaling   1.0; #scaling factor for constant forces
}

## TCL FORCES ----------------------------------------------------------------------------------------##

if {0} {
tclforces           on
set waterCheckFreq  100
set lipidCheckFreq  100
set allatompdb      aqp_popcwi.pdb
tclForcesScript     keep_water_out.tcl
#set linaccel	    "30 0 0"
#set angaccel        1
tclforcesscript     keep_water_out.tcl
}

## COLLECTIVE VARIABLES  ----------------------------------------------------------------------------##

if {$collVar} {
colvars         on; #enable the coll. vars. module
colvarsConfig   2/restrain.in; #defines all coll. vars. and their biasing/analysis methods
}

########################################################################################################
## EXECUTION SCRIPT                                        					      ##
########################################################################################################

## MINIMIZATION --------------------------------------------------------------------------------------##

if {$min} {
minimize        $minSteps; #iterations to vary atom positions to search for local minimum in potential
reinitvels	$temperature; #since minimization zeros velocities
}

## RUN -----------------------------------------------------------------------------------------------##

if {$MD} {
run 		$runSteps
}

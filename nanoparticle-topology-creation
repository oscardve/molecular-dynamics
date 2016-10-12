I present here the procedure that I made for the generation of the topology file of the Au18 gold nanoparticle.

The Au18 NP is made up of two types of residue:
* A dimer made up of four gold atoms and three sulfur atoms. Its charge when functionalized by pMBA thus becomes -3 electrons.
* A trimer made up of five gold atoms and four sulfur atoms. Its charge when functionalized by pMBA is then -4 electrons.

All atomic types, masses and charges except for the gold atoms were taken from the CHARMM36 general force field. Three different types of gold were defined in order to tune the interaction parameters to the original structure: CORE1, CORE2 and AU1.

The interaction parameters involving the gold atoms were defined with the purpose of preserving the initial structure. This was achieved by measuring manually all the bond lengths, angles and dihedral angles of the gold atoms in the original structure file, and then employing these measurements as the equilibrium values of every harmonic potential. In this way, the following parameters were added to the CHARMM36 force field:

BONDS
SG311  CORE1  223.4  2.45 ! ODV
SG311  AU1    223.4  2.38 ! ODV
SG311  CORE2  223.4  2.45 ! ODV

ANGLES
CORE1  SG311  AU1    50.0   80.0 ! ODV
SG311  AU1    SG311  50.0  180.0 ! ODV
AU1    SG311  AU1    50.0  102.0 ! ODV
AU1    SG311  CORE2  50.0  102.0 ! ODV
AU1    SG311  CG2R61 50.0  103.0 ! ODV
CORE1  SG311  CG2R61 50.0  103.0 ! ODV
CORE2  SG311  CG2R61 50.0  103.0 ! ODV

DIHEDRALS
X      SG311  AU1  X  0.0000  4  0.00 ! ODV
CORE1  SG311  X    X  0.0000  4  0.00 ! ODV
CORE2  SG311  X    X  0.0000  4  0.00 ! ODV

NONBONDED
SG311  0.0  -0.4500   2.00
CORE1  0.0  -0.10585  1.66 ! ODV
AU1    0.0  -0.10585  1.66 ! ODV
CORE2  0.0  -0.10585  1.66 ! ODV

The topology file defines the mass of each atomic type, it associates an atomic type and a charge to each atom name, and it defines all of the covalent bonds:

MASS     1 CORE1   	196.9665  AU
MASS     1 AU1   	196.9665  AU
MASS     1 CORE2   	196.9665  AU
MASS     1 SG311    32.06000  S
MASS     1 CG2R61   12.01100  C
MASS     1 HGR61    1.00800   H
MASS     1 CG2O3    12.01100  C
MASS     1 OG2D2    15.99940  O

AUTO ANGLES DIHE

RESI  DIM     -3.00
GROUP
ATOM    AUC1    CORE1   0
ATOM    S1      SG311   0
ATOM    AU1     AU1     0
ATOM    S2      SG311   0
ATOM    AU2     AU1     0
ATOM    S3      SG311   0
ATOM    AUC2    CORE2   0
GROUP
ATOM   C1    CG2R61 	-0.115
ATOM   C2    CG2R61 	-0.115
ATOM   H2    HGR61 		 0.115
ATOM   C3    CG2R61 	 0.000
ATOM   H3    HGR61 		 0.115
ATOM   C4    CG2R61 	-0.115
ATOM   C5    CG2R61 	-0.115
ATOM   H5    HGR61 		 0.115
ATOM   C6    CG2R61 	-0.1
ATOM   H6    HGR61 		 0.115
ATOM   C7    CG2O3 	 	 0.62
ATOM   O1    OG2D2 		-0.76
ATOM   O2    OG2D2 		-0.76
GROUP
ATOM   C8    CG2R61 	-0.115
ATOM   C9    CG2R61 	-0.115
ATOM   H9    HGR61 		 0.115
ATOM   C10    CG2R61 	 0.000
ATOM   H10    HGR61 	 0.115
ATOM   C11    CG2R61 	-0.115
ATOM   C12    CG2R61 	-0.115
ATOM   H12    HGR61 	 0.115
ATOM   C13    CG2R61 	-0.1
ATOM   H13    HGR61 	 0.115
ATOM   C14    CG2O3 	 0.62
ATOM   O3    OG2D2 		-0.76
ATOM   O4    OG2D2 		-0.76
GROUP
ATOM   C15    CG2R61 	-0.115
ATOM   C16    CG2R61 	-0.115
ATOM   H16    HGR61 	 0.115
ATOM   C17    CG2R61 	 0.000
ATOM   H17    HGR61 	 0.115
ATOM   C18    CG2R61 	-0.115
ATOM   C19    CG2R61 	-0.115
ATOM   H19    HGR61 	 0.115
ATOM   C20    CG2R61 	-0.1
ATOM   H20    HGR61 	 0.115
ATOM   C21    CG2O3 	 0.62
ATOM   O5    OG2D2 		-0.76
ATOM   O6    OG2D2 		-0.76

BOND AUC1 S1
BOND S1 AU1
BOND AU1 S2
BOND S2 AU2
BOND AU2 S3
BOND S3 AUC2
BOND S1 C1  C1 C2  C2 C3  C3 C4  
BOND C4 C5  C5 C6  C6 C1
BOND C2 H2  C3 H3  C5 H5  C6 H6
BOND C4 C7  C7 O1  C7 O2
BOND S2 C8  C8 C9  C9 C10  C10 C11  
BOND C11 C12  C12 C13  C13 C8
BOND C9 H9  C10 H10  C12 H12  C13 H13
BOND C11 C14  C14 O3  C14 O4
BOND S3 C15  C15 C16  C16 C17  C17 C18  
BOND C18 C19  C19 C20  C20 C15
BOND C16 H16  C17 H17  C19 H19  C20 H20
BOND C18 C21  C21 O5  C21 O6

RESI  TRI     -4.00
GROUP
ATOM    AUC1    CORE1   0
ATOM    S1      SG311   0
ATOM    AU1     AU1     0
ATOM    S2      SG311   0
ATOM    AU2     AU1     0
ATOM    S3      SG311   0
ATOM    AU3     AU1     0
ATOM    S4      SG311   0
ATOM    AUC2    CORE2   0
GROUP
ATOM   C1    CG2R61 	-0.115
ATOM   C2    CG2R61 	-0.115
ATOM   H2    HGR61 		 0.115
ATOM   C3    CG2R61 	 0.000
ATOM   H3    HGR61 		 0.115
ATOM   C4    CG2R61 	-0.115
ATOM   C5    CG2R61 	-0.115
ATOM   H5    HGR61 		 0.115
ATOM   C6    CG2R61 	-0.1
ATOM   H6    HGR61 		 0.115
ATOM   C7    CG2O3 	 	 0.62
ATOM   O1    OG2D2 		-0.76
ATOM   O2    OG2D2 		-0.76
GROUP
ATOM   C8    CG2R61 	-0.115
ATOM   C9    CG2R61 	-0.115
ATOM   H9    HGR61 		 0.115
ATOM   C10    CG2R61 	 0.000
ATOM   H10    HGR61 	 0.115
ATOM   C11    CG2R61 	-0.115
ATOM   C12    CG2R61 	-0.115
ATOM   H12    HGR61 	 0.115
ATOM   C13    CG2R61 	-0.1
ATOM   H13    HGR61 	 0.115
ATOM   C14    CG2O3 	 0.62
ATOM   O3    OG2D2 		-0.76
ATOM   O4    OG2D2 		-0.76
GROUP
ATOM   C15    CG2R61 	-0.115
ATOM   C16    CG2R61 	-0.115
ATOM   H16    HGR61 	 0.115
ATOM   C17    CG2R61 	 0.000
ATOM   H17    HGR61 	 0.115
ATOM   C18    CG2R61 	-0.115
ATOM   C19    CG2R61 	-0.115
ATOM   H19    HGR61 	 0.115
ATOM   C20    CG2R61 	-0.1
ATOM   H20    HGR61 	 0.115
ATOM   C21    CG2O3 	 0.62
ATOM   O5    OG2D2 		-0.76
ATOM   O6    OG2D2 		-0.76
GROUP
ATOM   C22    CG2R61 	-0.115
ATOM   C23    CG2R61 	-0.115
ATOM   H23    HGR61 	 0.115
ATOM   C24    CG2R61 	 0.000
ATOM   H24    HGR61 	 0.115
ATOM   C25    CG2R61 	-0.115
ATOM   C26    CG2R61 	-0.115
ATOM   H26    HGR61 	 0.115
ATOM   C27    CG2R61 	-0.1
ATOM   H27    HGR61 	 0.115
ATOM   C28    CG2O3 	 0.62
ATOM   O7    OG2D2 		-0.76
ATOM   O8    OG2D2 		-0.76

BOND AUC1 S1
BOND S1 AU1
BOND AU1 S2
BOND S2 AU2
BOND AU2 S3
BOND S3 AU3
BOND AU3 S4
BOND S4 AUC2
BOND S1 C1  C1 C2  C2 C3  C3 C4  
BOND C4 C5  C5 C6  C6 C1
BOND C2 H2  C3 H3  C5 H5  C6 H6
BOND C4 C7  C7 O1  C7 O2
BOND S2 C8  C8 C9  C9 C10  C10 C11  
BOND C11 C12  C12 C13  C13 C8
BOND C9 H9  C10 H10  C12 H12  C13 H13
BOND C11 C14  C14 O3  C14 O4
BOND S3 C15  C15 C16  C16 C17  C17 C18  
BOND C18 C19  C19 C20  C20 C15
BOND C16 H16  C17 H17  C19 H19  C20 H20
BOND C18 C21  C21 O5  C21 O6
BOND S4 C22  C22 C23  C23 C24  C24 C25  
BOND C25 C26  C26 C27  C27 C22
BOND C23 H23  C24 H24  C26 H26  C27 H27
BOND C25 C28  C28 O7  C28 O8

END

Once the topology file is created, the pdb and the topology file are employed to generate the structure (psf) file through the "psfgen" program:

#First separate the residues into different pdb files:
[atomselect top "resid 1"] writepdb O1.pdb
[atomselect top "resid 2"] writepdb O2.pdb
[atomselect top "resid 3"] writepdb O3.pdb
[atomselect top "resid 4"] writepdb O4.pdb

#Then merge all the pdb files with the topology:
package require psfgen 	 
topology top_au18pmba.inp
segment O1 { pdb O1.pdb }
coordpdb O1.pdb O1
segment O2 { pdb O2.pdb }
coordpdb O2.pdb O2
segment O3 { pdb O3.pdb }
coordpdb O3.pdb O3
segment O4 { pdb O4.pdb }
coordpdb O4.pdb O4
writepdb out.pdb 	 
writepsf out.psf

The Au18 NP is now ready to be simulated in NAMD. Additional files are still required in order to specify the characteristics of the simulation, but they are independent of the system to be simulated.

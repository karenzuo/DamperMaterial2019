# AnalysisOptn_3.tcl 

# AnalysisOptn "EigenDefault": Type: Eigen 
# ---------------------------------------- 
# Constraint Handler 
constraints  Plain 
# Convergence Test 
test  NormUnbalance  +1.000000E-006    25     0     2 
# Integrator 
integrator  Newmark  +5.000000E-001  +2.500000E-001 
# Solution Algorithm 
algorithm  Newton 
# DOF Numberer 
numberer  RCM 
# System of Equations 
system  ProfileSPD 
# Analysis Type 
analysis  Transient 

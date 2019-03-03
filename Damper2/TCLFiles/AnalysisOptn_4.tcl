# AnalysisOptn_4.tcl 

# AnalysisOptn "LoadingP": Type: Static 
# ------------------------------------- 
# Constraint Handler 
constraints  Transformation 
# Convergence Test 
test  NormDispIncr  +1.000000E-005    25     0     2 
# Integrator 
integrator  LoadControl  +2.500000E-003 
# Solution Algorithm 
algorithm  Newton 
# DOF Numberer 
numberer  RCM 
# System of Equations 
system  BandGeneral 
# Analysis Type 
analysis  Static 

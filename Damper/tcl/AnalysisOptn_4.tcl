# AnalysisOptn_4.tcl 

# AnalysisOptn "LoadingP": Type: Static 
# ------------------------------------- 
# Constraint Handler 
constraints  Transformation 
# Convergence Test 
test  NormDispIncr  +1.000000E-004   500     0     2 
# Integrator 
integrator  LoadControl  +1.000000E-002 
# Solution Algorithm 
algorithm  Newton 
# DOF Numberer 
numberer  Plain 
# System of Equations 
system  BandGeneral 
# Analysis Type 
analysis  Static 

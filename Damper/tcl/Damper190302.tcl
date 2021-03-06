# Damper.tcl 

######################## 
# Analysis-Sequence  1 #
######################## 

# Start of model generation 
# ========================= 

# Create ModelBuilder 
# ------------------- 
model  BasicBuilder  -ndm  2  -ndf  3 

# Define geometry 
# --------------- 
source  NodeCoord.tcl 

# Define Single Point Constraints 
# ------------------------------- 
source  SPConstraint.tcl 

# Define nodal masses 
# ------------------- 
source  NodeMass.tcl 

# Define Multi Point Constraints 
# ------------------------------ 
source  MPConstraint.tcl 

# Define material(s) 
# ------------------ 
source  Materials.tcl 

# Define section(s) 
# ----------------- 
source  Sections.tcl 

# Define geometric transformation(s) 
# ---------------------------------- 
source  GeoTran.tcl 

# Define element(s) 
# ----------------- 
source  Elements.tcl 

# Define time series 
# ------------------ 
source  TimeSeries.tcl 

# Start of anaysis generation 
# =========================== 

# Get Initial Stiffness 
# --------------------- 
initialize 

# Analysis: LoadingP 
# ++++++++++++++++++ 

# Define load pattern 
# ------------------- 
source  LoadPattern_3.tcl 

# Define recorder(s) 
# -------------------- 
source  Recorder_3.tcl 

# Define analysis options 
# ----------------------- 
source  AnalysisOptn_4.tcl 

analyze   100 

# Clean up 
# -------- 
wipe 


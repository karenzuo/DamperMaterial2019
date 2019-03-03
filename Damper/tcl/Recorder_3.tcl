# Recorder_3.tcl 

# Node Recorder "DefoShape":    fileName    <nodeTag>    dof    respType 
recorder  Node  -file  LoadingP_Node_DefoShape_Dsp.out  -time -nodeRange 1  2 -dof  1  2  3  disp 

# Node Recorder "Node2F":    fileName    <nodeTag>    dof    respType 
recorder  Node  -file  LoadingP_Node_Node2F_RFrc.out  -time -node  2 -dof  1  2  3  reaction 

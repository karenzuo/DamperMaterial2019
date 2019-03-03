function [MatData,Result] = DamperHys(action,MatData,edp)
tag = MatData(1,1);             %material tag
k1 =  MatData(1,2);             %Stiffness k1
k2 = MatData(1,3);              %Stiffness k2
k3 = MatData(1,4);              %Stiffness k3
ey = MatData(1,5);              %Stiffness ey
eu = MatData(1,6);              %Stiffness eu

% trial variables
stressT = MatData(1,7);         %trial stress       
strainT = MatData(1,8);         %trial strain   
tangentT = MatData(1,9);        %trial tangent   
dstrainT = MatData(1,10);       %trial delta strain 

% commit state variables
stressC = MatData(1,11);        %commit stress 
strainC = MatData(1,12);        %commit strain 
tangentC = MatData(1,13);       %commit tangent 
dstrainC = MatData(1,14);       %commit delta strain 
strainCmin = MatData(1,15);     %commit strain min 
strainCmax = MatData(1,16);     %commit strain max 



switch action
    
    case 'initialize'
        stressT = 0;
        strainT = 0;
        tangentT = 0;
        dstrainT = 0;
        stressC = 0;
        strainC = 0;
        tangentC = 0;
        dstrainC = 0;
        strainCmin = 0;
        strainCmax = 0;
        strainCend = 0;
        Result = 0;
        
    case 'setTrialStrain'
        strainT = edp;
        Result = 0;
        
    case 'getStress'
        % Determine change in strain from last state
        dstrainT = strainT - strainC;         %Trial-Commit
        
        %%%%%%%%%%%%%% 1 %%%%%%%%%%%%%%%%%%%%%
        if  strainT >= strainCmax
            strainCmax = strainT;
            if strainT > 0 && strainT < ey
                Result = stressC + k1*dstrainT;
                tangentT = k1;
            else % if strainT > ey && strainT < eu
                Result = stressC + k2*dstrainT;
                tangentT = k2;
            end
            
        %%%%%%%%%%%%%%%%%%%%%% 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        elseif strainT <= strainCmin
            strainCmin = strainT;
            if strainT < 0 && strainT > -ey
                Result = stressC + k1*dstrainT;
                tangentT = k1;
            else % if strainT > -eu && strainT< -ey
                Result = stressC + k2*dstrainT;
                tangentT = k2;
            end
        
        %%%%%%%%%%%%%%%%%%%%%%%%  3  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        elseif dstrainT >0 && dstrainC < 0        % direction from - to +
            if strainT > -ey && strainT < ey
                Result = stressC + k1*dstrainT;
                tangentT = k1;
            elseif strainT < -ey
                Result = -k1*ey + (strainT+ey)*k3;
                tangentT = 1e10; %stub
            elseif strainT > ey
                Result = k1*ey + (strainT-ey)*k2;
                tangentT = k2;
            end
        
        elseif dstrainT < 0 && dstrainC > 0       % direction from + to -
            if strainT > -ey && strainT < ey
                Result = stressC + k1*dstrainT;
                tangentT = k1;
            elseif strainT > ey
                Result = k1*ey + (strainT-ey)*k3;
                tangentT = 1e10; %stub
            elseif strainT < -ey
                Result = -k1*ey + (strainT+ey)*k2;
                tangentT = k2;
            end
            
        %%%%%%%%%%%%%%%%%%%%%%%  4  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        elseif dstrainT > 0
            if strainT < -ey
                Result = stressC + k3*dstrainT;
                tangentT = k3;
            elseif strainT > -ey && strainT < ey
                Result = stressC + k1*dstrainT;
                tangentT = k1;
            else  %           if straintT > ey && strainT < eu
                Result = stressC + k2*dstrainT;
                tangentT = k2;
            end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%  5  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        elseif dstrainT <= 0
            if strainT < eu && strainT > ey
                Result = stressC + k3*dstrainT;
                tangentT = k3;
            elseif strainT > -ey && strainT < ey
                Result = stressC + k1*dstrainT;
                tangentT = k1;
            else % if straintT > -eu && strainT < -ey
                Result = stressC + k2*dstrainT;
                tangentT = k2;
            end
        end
        stressT = Result;
        strainC = strainT;
        stressC = stressT;
        tangentC = tangentT;
        dstrainC = dstrainT;  

        
        % ======================================================================
    case 'getInitialStiffness'
        Result = k1;
        
        % ======================================================================
    case 'getInitialFlexibility'
        Result = 1/k1;
        
        % ======================================================================
    case 'commitState'
        % State variables
        strainC = strainT;
        stressC = stressT;
        tangentC = tangentT;
        dstrainC = dstrainT;
        Result = 0;
        
end

% Record
MatData(1,1) = tag;      % unique material tag
MatData(1,2) = k1;
MatData(1,3) = k2;
MatData(1,4) = k3;
MatData(1,5) = ey;
MatData(1,6) = eu;
% trial variables
MatData(1,7) = stressT;
MatData(1,8) = strainT;
% state history variables
MatData(1,9) = tangentT;
MatData(1,10) = dstrainT;
MatData(1,11) = stressC;
MatData(1,12) = strainC;
MatData(1,13) = tangentC;
MatData(1,14) = dstrainC;
MatData(1,15) = strainCmin;
MatData(1,16) = strainCmax;
end
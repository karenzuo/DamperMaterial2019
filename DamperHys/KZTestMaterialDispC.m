% =========================================================================
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%% Material Testing Template V2 %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% =========================================================================

%% Testing template for Concrete01 material

% clean start
clear all; close all; clc;
% Load loading protocol file
load('LP.mat');
Time = lp(:,1);
V = lp(:,2);

% Material property
% Element = 'Elastic';
% Element = 'BLElastic';
% Element = 'BLHysteretic';
% Element = 'ElasticNoTension';
Element = 'DamperHys';   % Material type name

MatData = zeros(1,50);

% User input material properties
MatData(1,1) = 1;       % unique material tag
MatData(1,2) = 1801;    % k1
MatData(1,3) = 3120;    % k2
MatData(1,4) = 480;     % k3
MatData(1,5) = 38;      % ey
MatData(1,6) = 150;     % eu
% trial variables

MatData(1,7) = 0;      % stressT
MatData(1,8) = 0;      % strainT

% state history variables
MatData(1,9) = 0;      % tangentT
MatData(1,10) = 0;     % dstrainT
MatData(1,11) = 0;     % stressC
MatData(1,12) = 0;     % strainC
MatData(1,13) = 0;     % tangentC
MatData(1,14) = 0;     % dstrainC
MatData(1,15) = 0;     % strainCmin
MatData(1,16) = 0;     % stressCmax
MatData(1,17) = 0;     % strainCend
% initialize the material
[MatData,~] = feval(Element,'initialize',MatData);
[MatData,E] = feval(Element,'getInitialStiffness',MatData);
[MatData,Fs] = feval(Element,'getInitialFlexibility',MatData);
 
% loop through the force vector
P = zeros(length(V),1);
for nn = 1:length(P)
    [MatData,~] = feval(Element,'setTrialStrain',MatData,V(nn));
    [MatData,P(nn)] = feval(Element,'getStress',MatData);
    [MatData,~] = feval(Element,'commitState',MatData);
end
 
figure;
plot(V,P)
xlabel('Strain')
ylabel('Stress')
grid

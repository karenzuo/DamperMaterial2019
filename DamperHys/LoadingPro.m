% loading function


clear;
clc;
Amp = [20 40 60 80 100];
Increment = 1;
nCycles = 1;
k=1;
dt = 0.01;
V(1) = 0;
Time(1) = 0;

for i = 1:length(Amp)
    for j = 1:nCycles
        while (V(k)<Amp(i))
            k = k+1;
            Time(k) = k*dt;
            V(k) = V(k-1)+Increment;
        end
        while(V(k)>-Amp(i))
            k = k+1;
            Time(k) = k*dt;
            V(k) = V(k-1)-Increment;
        end
        while(V(k)<0)
            k=k+1;
            Time(k) = k*dt;
            V(k) = V(k-1)+Increment;
        end
    end
end

% LOADING_PROTOCOL  CONSTANTS
% loadingProtocol   variable1
% loading_protocol  variable1
plot(Time,V);
lp = [Time', V'];
save('LP.mat', 'lp');
clear all;
close all;
load ../Data/3HourCycle0803.mat

startind = 50000;
endind = 60000;
[return_val supply_val blackboard_val] = ...
    baseline_calibration(return_ori,supply_ori,black_ori,startind,endind);
return_val = return_val(424:end);
supply_val = supply_val(424:end);


endind = 60000;
resol = 100;
t_f=endind; T=t_f*resol; tau=1/resol; %%% discretize in time
t=linspace(0,t_f,T+1);
D=1;
points=10;%%% discretize in space
dx=D/points;

% get the supply(n)
measure_supply = supply_val(1:endind);
measure_return = return_val(1:endind);

supply = kron(measure_supply,ones(resol,1));
return_m = kron(measure_return,ones(resol,1));

%% Pump data, value in seconds
t1 = pump_ori(1);
t2 = pump_ori(2);
t3 = pump_ori(3);
t4 = pump_ori(4);
t5 = pump_ori(5);
t6 = pump_ori(6);
t7 = length(t)-(t1+t2+t3+t4+t5+t6)*resol;
%%
rate_person = 0.8333; %ppm/second
V=[zeros(1,t1),rate_person*ones(1,t2),0*ones(1,t3),rate_person*ones(1,t4)...
    ,0*rate_person*ones(1,t5),rate_person*ones(1,t6),...
    zeros(1,round(t7/resol))];


X(1)=0;
u(:,1)=400*ones(points,1);

b=-.025;
bx=.01;
a=.0006;
Ue=400;

L1 = 2;
L2 = .02;
[u_hat u_err V_hat]= simulateobserver...
    (return_m,supply,b,bx,a,L1,L2,Ue,points,T,tau,dx);
A = [-a,1;0,0];
C = [bx/a*(exp(-a/b)-1),(bx/(-a*b)+bx/a^2*(1-exp(-a/b)))];

simulate_V = [];
for i = 1:endind
    simulate_V = [simulate_V nanmean(V_hat((1+(i-1)*resol):i*resol))]; %mean(u(10,(1+(i-1)*100):i*100))];
end
start_i = 5000;
end_i = 40000;

mse = nanmean((V(start_i:end_i)/rate_person-...
    round(medfilt1(simulate_V(start_i:end_i),1200)/rate_person)).^2)
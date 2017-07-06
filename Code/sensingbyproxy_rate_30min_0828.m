clear all;
load ../Data/30minCycle0828.mat

startind = 30000;
endind = 40000;
[return_val supply_val blackboard_val] = ...
    baseline_calibration(return_ori,supply_ori,black_ori,startind,endind);
return_val = return_val(223:end);
supply_val = supply_val(223:end);


endind = 40000;
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
t2 = pump_ori(2);%
t3 = pump_ori(3);
t4 = pump_ori(4);%
t5 = pump_ori(5);
t6 = pump_ori(6);%
t7 = pump_ori(7);
t8 = pump_ori(8);%
t9 = pump_ori(9);
t10 = pump_ori(10);%
t11 = pump_ori(11);
t12 = pump_ori(12);%
t13 = pump_ori(13);
t14 = pump_ori(14);%
t15 = pump_ori(15);
t16 = pump_ori(16);%
t17 = pump_ori(17);
t18 = pump_ori(18);%
t19 = pump_ori(19);
t20 = pump_ori(20);%

t21 = length(t)-(t1+t2+t3+t4+t5+t6+t7+t8+t9+t10+...
    t11+t12+t13+t14+t15+t16+t17+t18+t19+t20)*resol;
rate_person = 0.8333; %ppm/second
V=[zeros(1,t1),1*rate_person*ones(1,t2),0*rate_person*ones(1,t3),1*rate_person*ones(1,t4)...
    ,0*rate_person*ones(1,t5),1*rate_person*ones(1,t6),0*rate_person*ones(1,t7),...
    1*rate_person*ones(1,t8),0*rate_person*ones(1,t9),1*rate_person*ones(1,t10),...
    0*rate_person*ones(1,t11),1*rate_person*ones(1,t12),0*rate_person*ones(1,t13),...
    1*rate_person*ones(1,t14),0*rate_person*ones(1,t15),1*rate_person*ones(1,t16),...
    0*rate_person*ones(1,t17),1*rate_person*ones(1,t18),0*rate_person*ones(1,t19),...
    1*rate_person*ones(1,t20),zeros(1,t21)];


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

window = 500;
start_i = 1000;
end_i = 26000;

mse = nanmean((V(start_i:end_i)/rate_person-...
    round(medfilt1(simulate_V(start_i:end_i),window)/rate_person)).^2)
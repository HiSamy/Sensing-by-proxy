function [u_hat u_err V_hat]= simulateobserver(return_m,supply,b,bx,a,L1,L2,Ue,points,T,tau,dx)
X_hat = zeros(1,T);
u_hat = 400*ones(points+1,T);
V_hat = zeros(1,T);
r_vec = nan(points+1,1);
for j_x = 0:points
    x_v = j_x/points;
    r_vec(j_x+1) = L1*bx/a*(exp(-a*x_v/b)-1)+...
        L2*(bx*x_v/(-b*a)+bx/a^2*(1-exp(-a*x_v/b)));
end


for n=2:T-1
    
    u_hat(1,n) = supply(n); 
    for j = 2:points+1 
        gradx = (u_hat(j,n)-u_hat(j-1,n))/dx;
        
        u_hat(j,n+1)=u_hat(j,n)+tau*(b*gradx+bx*X_hat(n-1)+...
            r_vec(j)*(return_m(n-1)-u_hat(points+1,n-1)));
        m=0;
        while isnan(u_hat(j,n+1))&& m<n
            u_hat(j,n+1) = u_hat(j,n-m);
            m = m+1;
        end
        if isnan(u_hat(j,n+1))
            u_hat(j,n+1) = supply(n);
        end
            
    end
    
    V_hat(n+1)=V_hat(n)+tau*(L2*(return_m(n)-u_hat(points+1,n))); %equ. (8)
    if V_hat(n+1)<0
        V_hat(n+1) = 0;
    end
    X_hat(n+1)=X_hat(n)+tau*(-a*X_hat(n)+V_hat(n)+...
        L1*(return_m(n)-u_hat(points+1,n))); 
end
u_err = return_m - u_hat(points+1,:)';
function u = simulatereturn(V,supply,b,bx,a,Ue,points,T,tau,dx)
X = zeros(1,T);
u = 400*ones(points,T);
for n=1:T-1
    X(n+1)=X(n)+tau*(-a*X(n)+V(n));
    u(1,n) = supply(n);
    for j = 2:points
        gradx = (u(j,n)-u(j-1,n))/dx;
        u(j,n+1)=u(j,n)+tau*(b*gradx+bx*X(n));
        m=0;
        while isnan(u(j,n+1))&& m<n
            u(j,n+1) = u(j,n-m);
            m = m+1;
        end
        if isnan(u(j,n+1))
            u(j,n+1) = supply(n);
        end
    end
end
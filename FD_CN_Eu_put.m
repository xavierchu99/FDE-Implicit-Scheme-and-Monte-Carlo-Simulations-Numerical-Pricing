% Names of group members: Xavier Chu
function OptVal=FD_CN_Eu_put(S0, X, r, q, T, sigma, I, N, xmin, xmax)
% set up grid parameters
dt = T/N; dx = (xmax-xmin)/I;
d = 1/(4*dx)*(r-q-sigma^2/2); e = sigma^2/(4*dx^2);
% Finite difference grid
UGrid = zeros(I+1,N+1); 
% Boundary conditions
UGrid(1,:) = X*exp(-r*(T-(0:dt:T))) - exp(xmin)*exp(-q*(T-(0:dt:T))); % at xmin;
UGrid(I+1,:) = 0; % at xmax, unlikely to have positive payoff 
% Terminal condition
priceVector = exp(xmin:dx:xmax);
UGrid(:,N+1) = max(X-priceVector,0);
% Forming required vectors for setting up of tri-diagonal matrix
i=(1:I-1)';
a = (e - d); b = -(2*e + 1/dt + r/2); c = (e+d);
alpha = (d-e); beta = (2*e+r/2-1/dt); gamma = -(d+e);
a = repelem(a,I-1)';b = repelem(b,I-1)';c = repelem(c,I-1)';
alpha = repelem(alpha,I-1)';beta = repelem(beta,I-1)';gamma = repelem(gamma,I-1)';
% Set up sparse tri-diagonal matrix of coefficients, A and B respectively
A = spdiags([c, b, a], -1:1, I-1,I-1)';
B = spdiags([gamma, beta, alpha], -1:1, I-1,I-1)';
ishift=1;
for n=N:-1:1 % backward time recursive
    Vnp1=UGrid(i+ishift,n+1); % set up right hand side vector
    RhsB = B*Vnp1;
    RhsB(1) =RhsB(1) + alpha(1)*UGrid(0+ishift,n+1) -a(1) *UGrid(0+ishift,n); 
    RhsB(I-1)=RhsB(I-1) + gamma(I-1)*UGrid(I+ishift,n+1)-c(I-1)*UGrid(I+ishift,n);
    UGrid(i+ishift,n)=A\RhsB; % solve linear system
end
% retrieving index of underlier price S0, in truncated domain of x
kfloor = floor((log(S0)-xmin)/dx);
% perform linear interpolation to improve accuracy of option value estimate
OptVal = LinearInterpolate(log(S0),kfloor*dx+xmin,(kfloor+1)*dx+xmin,UGrid(kfloor+ishift,1), UGrid((kfloor+1)+ishift,1));
end
%%
function value = LinearInterpolate(x,x0,x1,f0,f1)
value = (x1-x)./(x1-x0).*f0 + (x-x0)./(x1-x0).*f1;
end




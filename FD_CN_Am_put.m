function OptVal=FD_CN_Am_put(S0, X, r, q, T, sigma, I, N, xmin, xmax, omega, eps)
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
% Payoff vector used for comparison against continuation value for interior
% points in PSOR algorithm below
payoffVector = max(X-priceVector,0);
payoffVector = payoffVector(2:I);
% Forming required vectors for setting up of tri-diagonal matrix
a = (e - d); b = -(2*e + 1/dt + r/2); c = (e+d);
alpha = (d-e); beta = (2*e+r/2-1/dt); gamma = -(d+e);
a1 = repelem(a,I-1)';b1 = repelem(b,I-1)';c1 = repelem(c,I-1)';
alpha1 = repelem(alpha,I-1)';beta1 = repelem(beta,I-1)';gamma1 = repelem(gamma,I-1)';
% Set up sparse tri-diagonal matrix of coefficients, B 
B = spdiags([gamma1, beta1, alpha1], -1:1, I-1,I-1)';
ishift = 1; 
% Set up right hand side vector of linear system Ax=b, which is vectorb
% Formula for computing vectorb is given in the RHS of the 
% matrix vector form in presented in A3.1(i)
Unp1 = UGrid(2:I,N+1); % interior points of terminal option values
vectorb = B*Unp1;
vectorb(1) = vectorb(1) + alpha1(1)*UGrid(0+ishift,N+1) -a1(1) *UGrid(0+ishift,N); 
vectorb(I-1)= vectorb(I-1) + gamma1(I-1)*UGrid(I+ishift,N+1)-c1(I-1)*UGrid(I+ishift,N);
% backward time recursive
for n=N:-1:1 
    % Solve linear system using PSOR algorithm in every iteration
    Un = psor(I-1,a,b,c,Unp1,eps,omega,vectorb,payoffVector);
    % Set up the variables for the next iteration
    Unp1 = Un;
    vectorb = B*Unp1;
    vectorb(1) = vectorb(1) + alpha1(1)*UGrid(0+ishift,N+1) - a1(1)*UGrid(0+ishift,N); 
    vectorb(I-1) = vectorb(I-1) + gamma1(I-1)*UGrid(I+ishift,N+1) - c1(I-1)*UGrid(I+ishift,N);
end
% retrieving index of underlier price S0, in truncated domain of x
kfloor = floor((log(S0)-xmin)/dx);
% Since kfloor is the index for the full length of the vector,
% we need to minus 1 from kfloor when indexing from the interior points
% vector, Un
OptVal = LinearInterpolate(log(S0),kfloor*dx+xmin,(kfloor+1)*dx+xmin,Un(kfloor-1+ishift), Un((kfloor-1+1)+ishift));
end
%%
function value = LinearInterpolate(x,x0,x1,f0,f1)
value = (x1-x)./(x1-x0).*f0 + (x-x0)./(x1-x0).*f1;
end
%%
function Vn = psor(M, a, b, c, Vnplus, eps, omega, B,phi)
converged = false;
Vk = Vnplus;
Vkplus = Vk;
Vgs = Vkplus;
while (converged == false)
    % split into 3 cases: 1) i = 1, 2) i = 2:M-1, 3) i = M
    % in each case, compute the gauss-seidel iterate and then perform SOR
    % to obtain SOR iterate which will then be compared against the vector 
    % phi, max(SOR iterate, phi) where phi corresponds to the corresponding
    % component of the linear system we are solving
    % This would be the outline for Projected SOR algorithm for computing
    % the price of an American option
    Vgs(1) = 1/b * (-c*Vk(2)+ B(1));
    Vkplus(1) = max((1-omega)*Vk(1)+omega*Vgs(1),phi(1));
    for i=2:M-1 % compute iterate k+1
        Vgs(i) = 1/b * (-a*Vkplus(i-1) - c*Vk(i+1) + B(i));
        Vkplus(i) = max(((1-omega)*Vk(i) + omega*Vgs(i)), phi(i));
    end
    Vgs(M) = 1/b * (-a*Vkplus(M-1)+B(M));
    Vkplus(M) = max((1-omega)*Vk(M)+omega*Vgs(M),phi(M));
    if ((norm(Vk-Vkplus)) < eps)
        converged = true;
    end
    Vk = Vkplus;
end
Vn = Vk;
end

% Names of group members: Xavier Chu
function MC_noCV=MC_NoCV_3AssetDP(S0, X, sigma, C, r, q, T, no_samples)
% S0, sigma, q are vectors
% c is 3 × 3 correlation matrix
mu1 = r-q(1)-sigma(1)^2/2;
mu2 = r-q(2)-sigma(2)^2/2;
mu3 = r-q(3)-sigma(3)^2/2;
% random standard normal numbers
r1 = randn(no_samples,1);  
r2 = randn(no_samples,1);
r3 = randn(no_samples,1);
% computing correlated epsilons for each of the 3 assets
p12 = C(1,2); p13 = C(1,3); p23 = C(2,3);
e1 = r1;
e2 = p12 * r1 +sqrt(1-p12^2) * r2;
e3 = p13 * r1 + (p23-p13*p12)/(sqrt(1-p12^2)) * r2 +...
    sqrt((1+2*p23*p12*p13-p12^2-p13^2-p23^2)/(1-p12^2)) * r3;
% terminal prices
ST1=S0(1)*exp(mu1*T+e1*sigma(1)*sqrt(T)); 
ST2=S0(2)*exp(mu2*T+e2*sigma(2)*sqrt(T));
ST3=S0(3)*exp(mu3*T+e3*sigma(3)*sqrt(T));
V = zeros(no_samples,1);
for i = 1:no_samples
    if max(max(ST1(i), ST2(i)), ST3(i)) < X
        V(i) = 1;
    end
end
% Discounting the mean of vector V to obtain option estimate
MC_noCV = exp(-r*T)*mean(V);
end
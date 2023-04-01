function MC_CV=MC_CV_3AssetDP(S0, X, sigma, C, r, q, T, no_samples)
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
% Vector of terminal prices 
ST1=S0(1)*exp(mu1*T+e1*sigma(1)*sqrt(T));  
ST2=S0(2)*exp(mu2*T+e2*sigma(2)*sqrt(T));  
ST3=S0(3)*exp(mu3*T+e3*sigma(3)*sqrt(T));  
% estimate beta parameter
FA = zeros(no_samples,1);
FB = zeros(no_samples,1);
for i = 1:no_samples
    if max(ST1(i), max(ST2(i), ST3(i))) < X 
        FA(i) = 1;
    end
    if ST1(i) < X 
        FB(i) = FB(i) + 1;
    end
    if ST2(i) < X 
        FB(i) = FB(i) + 1;
    end
    if ST3(i) < X
        FB(i) = FB(i) + 1;
    end   
end
% Discounting the vector FA and FB to obtain vector of option estimates
FA = exp(-r*T) * FA;
% FB multiplied by 1/3, since equally weighted basket of 3 single-asset
% digital put
FB = exp(-r*T) * FB * (1/3); 
% estimating beta, formula given in lecture notes
FA_bar = mean(FA); FB_bar = mean(FB);
betahat = dot((FA - FA_bar),(FB - FB_bar)) / norm(FB - FB_bar)^2;
% Referencing BS_Digital_Put written in A3.2(i) to compute exact value of
% control variate portfolio
FB_BS = (BS_Digital_Put(S0(1), X, r, q(1),  T, sigma(1))...
    + BS_Digital_Put(S0(2), X, r, q(2),  T, sigma(2))...
    + BS_Digital_Put(S0(3), X, r, q(3),  T, sigma(3))) * (1/3); 
MC_CV = FA_bar - betahat * (FB_bar - FB_BS);
end

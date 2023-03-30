% Names of group members: Xavier Chu
%% (ii)
X = 1; T = 1; S0 = 0.92; sigma = 0.48; q = 0.01; r = 0.05;
xmin = -5; xmax = 2;

k = 2:7;
I = 7 * 2.^k; N = 2.^k;
norows = length(I);
optvaluesii = zeros(norows,1);
for i = 1:norows
    optvaluesii(i) = FD_CN_Eu_put(S0,X,r,q,T,sigma,I(i),N(i),xmin,xmax);
end
optvaluesii
T1 = table(I',N',optvaluesii);
T1.Properties.VariableNames = ["I","N","Option Value Estimates"];
T1
%% Plotting of results in (ii)
plot(I,optvaluesii,'r*-')
title('European Vanilla Put (Crank-Nicholson Scheme)')
xlabel('I sub-intervals')
ylabel('Option Value Estimates($)')

%% (iii)
omega = 1.3; eps = 1e-06;
optvaluesiii = zeros(norows,1);
for i = 1:norows
    optvaluesiii(i) = FD_CN_Am_put(S0,X,r,q,T,sigma,I(i),N(i),xmin,xmax,omega,eps);
end
optvaluesiii
T2 = table(I',N',optvaluesiii);
T2.Properties.VariableNames = ["I","N","Option Value Estimates"];
T2

%% Plotting of results in (iii)
figure;
plot(I,optvaluesiii,'r*-')
title('American Vaniila Put (Crank-Nicholson Scheme)')
xlabel('I sub-intervals')
ylabel('Option Value Estimates($)')

%% (iii)
C = [1 0.48 0.27; 0.48 1 0.94; 0.27 0.94 1];
S0 = [9.5 10.5 8.8]; sigma = [0.3 0.25 0.38];
q = [0.02 0.03 0.01]; X = [10.5 11.5 12.5];
r = 0.05; T = 0.5;

valuesiii = zeros(3,2);
optvalues = zeros(30,1);
noruns = 30;
for i = 1:length(X)
    for j = 1:noruns
        optvalues(j,1) = MC_NoCV_3AssetDP(S0, X(i), sigma, C, r, q, T, 100);
    end
    valuesiii(i,:) = [mean(optvalues), std(optvalues)];
end
valuesiii

%% (iv)
pricebundles = [1000 10000 100000];
valuesiv1000 = zeros(3,2);
valuesiv10000 = zeros(3,2);
valuesiv100000 = zeros(3,2);
optvalues = zeros(30,1);

for i =1:length(X)
    for j = 1:noruns
        optvalues(j,1) = MC_NoCV_3AssetDP(S0, X(i), sigma, C, r, q, T, pricebundles(1));
    end
    valuesiv1000(i,:) = [mean(optvalues), std(optvalues)];
end
valuesiv1000
%%
optvalues = zeros(30,1);
for i =1:length(X)
    for j = 1:noruns
        optvalues(j,1) = MC_NoCV_3AssetDP(S0, X(i), sigma, C, r, q, T, pricebundles(2));
    end
    valuesiv10000(i,:) = [mean(optvalues), std(optvalues)];
end
valuesiv10000
%%
optvalues = zeros(30,1);
for i =1:length(X)
    for j = 1:noruns
        optvalues(j,1) = MC_NoCV_3AssetDP(S0, X(i), sigma, C, r, q, T, pricebundles(3));
    end
    valuesiv100000(i,:) = [mean(optvalues), std(optvalues)];
end
valuesiv100000

%% Tabulation of numerical results for (iii) and (iv)
X = [10.5 11.5 12.5];
pb100 = table(valuesiii(:,1),valuesiii(:,2));
pb100.Properties.VariableNames = ["mean estimate","standard error"];
pb1000 = table(valuesiv1000(:,1),valuesiv1000(:,2));
pb1000.Properties.VariableNames = ["mean estimate","standard error"];
pb10000 = table(valuesiv10000(:,1),valuesiv10000(:,2));
pb10000.Properties.VariableNames = ["mean estimate","standard error"];
pb100000 = table(valuesiv100000(:,1),valuesiv100000(:,2));
pb100000.Properties.VariableNames = ["mean estimate","standard error"];

T1 = table(X',pb100,pb1000,pb10000,pb100000);
T1.Properties.VariableNames = ["X (Strike Price $)", "100 Price-Path Bundles",...
    "1000 Price-Path Bundles", "10000 Price-Path Bundles", "100000 Price-Path Bundles"];
T1

%% (v)

valuesv = zeros(3,2);
optvalues = zeros(30,1);
noruns = 30;
for i = 1:length(X)
    for j = 1:noruns
        optvalues(j,1) = MC_CV_3AssetDP(S0, X(i), sigma, C, r, q, T, 100);
    end
    valuesv(i,:) = [mean(optvalues), std(optvalues)];
end
valuesv

%% 
pricebundles = [1000 10000 100000];
valuesv1000 = zeros(3,2);
valuesv10000 = zeros(3,2);
valuesv100000 = zeros(3,2);
optvalues = zeros(30,1);

for i =1:length(X)
    for j = 1:noruns
        optvalues(j,1) = MC_CV_3AssetDP(S0, X(i), sigma, C, r, q, T, pricebundles(1));
    end
    valuesv1000(i,:) = [mean(optvalues), std(optvalues)];
end
valuesv1000
%%

optvalues = zeros(30,1);
for i =1:length(X)
    for j = 1:noruns
        optvalues(j,1) = MC_CV_3AssetDP(S0, X(i), sigma, C, r, q, T, pricebundles(2));
    end
    valuesv10000(i,:) = [mean(optvalues), std(optvalues)];
end
valuesv10000
%%
optvalues = zeros(30,1);
for i =1:length(X)
    for j = 1:noruns
        optvalues(j,1) = MC_CV_3AssetDP(S0, X(i), sigma, C, r, q, T, pricebundles(3));
    end
    valuesv100000(i,:) = [mean(optvalues), std(optvalues)];
end
valuesv100000


%% Tabulation of numerical results for (v)
% Comparison of 100 vs 1000 price-paths
X = [10.5 11.5 12.5];

MC_CV100 = table(valuesv(:,1),valuesv(:,2));
MC_CV100.Properties.VariableNames = ["mean estimate","standard error"];

MC_CV1000 = table(valuesv1000(:,1),valuesv1000(:,2));
MC_CV1000.Properties.VariableNames = ["mean estimate","standard error"];

T2 = table(X',pb100,MC_CV100,pb1000,MC_CV1000);
T2.Properties.VariableNames = ["X (Strike Price $)", "Crude MC(100 Price-Paths)",... 
    "MC Control Variate(100 Price-Paths)", "Crude MC(1000 Price-Paths)",...
    "MC Control Variate(1000 Price-Paths)"];
T2
%%
% Comparison of 10000 vs 100000 price-paths
MC_CV10000 = table(valuesv10000(:,1),valuesv10000(:,2));
MC_CV10000.Properties.VariableNames = ["mean estimate","standard error"];

MC_CV100000 = table(valuesv100000(:,1),valuesv100000(:,2));
MC_CV100000.Properties.VariableNames = ["mean estimate","standard error"];

T3 = table(X',pb10000,MC_CV10000,pb100000,MC_CV100000);
T3.Properties.VariableNames = ["X (Strike Price $)", "Crude MC(10000 Price-Paths)",... 
    "MC Control Variate(10000 Price-Paths)", "Crude MC(100000 Price-Paths)",...
    "MC Control Variate(100000 Price-Paths)"];
T3


# FDE-Implicit-Scheme-and-Monte-Carlo-Simulations-Numerical-Pricing

This repository contains MATLAB code for numerical pricing of financial derivatives using finite difference methods and Monte Carlo simulations. The code is based on implicit finite difference schemes and variance reduction techniques.

## Finite Difference Methods

The code in this repository implements the Crank-Nicolson method, which is an implicit finite difference scheme for pricing financial derivatives. The Crank-Nicolson method is a popular and accurate method for solving partial differential equations, and it is widely used in financial engineering.

The following Crank-Nicolson finite difference schemes are included in this repository:

- `FD_CN_Am_put.m`: Code for pricing American put options using the Crank-Nicolson method.
- `FD_CN_Eu_put.m`: Code for pricing European put options using the Crank-Nicolson method.

## Monte Carlo Simulations

The code in this repository also includes Monte Carlo simulations for pricing financial derivatives. Monte Carlo simulations are a popular method for pricing options, and they are often used in situations where other methods may not be feasible.

The following Monte Carlo simulations are included in this repository:

- `MC_CV_3AssetDP.m`: Code for pricing three-asset digital put options using Monte Carlo simulations with control variates.
- `MC_NoCV_3AssetDP.m`: Code for pricing three-asset digital put options using Monte Carlo simulations without control variates.

## Digital Put Options

The code in this repository also includes an implementation of the Black-Scholes formula for pricing digital put options, which are options that pay a fixed amount if the underlying asset price is below a certain strike price at expiration.

The following digital put option pricing function is included in this repository:

- `BS_Digital_Put.m`: Code for pricing digital put options using the Black-Scholes formula.

Each file contains detailed comments explaining the code and its usage.

## Disclaimer

The code in this repository is provided for educational and research purposes only. It should not be used for actual trading or financial decision-making.

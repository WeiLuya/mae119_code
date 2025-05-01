% MAE 119 Introduction to Renewable Energy
% Spring 2025
% Prof. Hidalgo-Gonzalez
% Homework 2

%%
clear all
clc

% interest rate for Net Present Value calculations
rate = 4/100; % 4.0%

% data for generator dispatch problem

D = 365; % days in a year
Y = 20; % years simulated
T = 24; % hours simulated in each day
t= (1:T); % vector of time


 d = 40*[0.4 0.4 0.4 0.65 ...
     0.65 0.6  0.6  0.65  ...
     0.8  0.85  0.8  0.8  ...
     0.75  0.6  0.5  0.3  ...
     0.3  0.4  0.54  0.6  ...
     0.75  0.7  0.6  0.5 ]; % daily demand in MWh

n = 4; % number of dispatchable generators (2 hard coal and 2 OCGT plants) to choose from, in addition to  a solar plant

solar_cap_fact = [zeros(1,6) sin(pi*[0:12]/12) zeros(1,length(d)-6-length(0:12))]; % capacity factor of the potential solar plant = power_available/installed_capacity

% (To be used in Part II only: capacity factor of the potential wind plant = power_available/installed_capacity)
wind_cap_fact = [0.3277    0.2865    0.3303    0.3073    0.2994...
    0.3071    0.2980    0.2988    0.3149    0.3141    0.3142 ...
    0.5*0.3067    0.5*0.2879    0.5*0.3072    0.5*0.3163    0.5*0.3049    0.5*0.3103 ...
    0.3914    0.4008    0.3879    0.3889    0.3999 0.4153    0.3923]; 


Pmax = [10 5 10 15];  % Maximum generator capacities in MW [hard coal, hard coal, OCGT, OCGT] due to land constraints
Pmax_solar = 40; % Maximum capacity in MW for solar plant due to land constraints
Pmin = [0 0 0 0]; % generator minimum capacities in MW
Pmin_solar = 0;

ramp_hard_coal = 0.015 % 1.5% [% Pnom/minute]
hourly_ramp_hard_coal = ramp_hard_coal*60; % [% Pnom/h]

ramp_ocgt = 0.08 % 1.5% [% Pnom/min]
hourly_ramp_ocgt = ramp_ocgt*60; % [% Pnom/h]

R = [hourly_ramp_hard_coal*Pmax(1) hourly_ramp_hard_coal*Pmax(2) hourly_ramp_ocgt*Pmax(3) hourly_ramp_ocgt*Pmax(4)];  % ramp-rate limits [MWh]

% source:
% https://www.eia.gov/electricity/annual/html/epa_08_04.html
% 
fuel_cost_per_MWh_2018 = [25.4 25.4 27.35 27.35]; % $/MWh, 2018
%
%fuel_cost_per_MWh_2019 = [24.28 24.28 23.11 23.11]; % $/MWh, 2019 This
%cost won't be used



% Investment costs (or capital costs per MW of built capacity). From https://atb.nrel.gov/

capital_cost_solar_plant_per_MW = 1200000; % dollars/MW, denoted as M_i in the pdf
capital_cost_wind_plant_per_MW = 1300000;  % dollars/MW, denoted as M_i in the pdf
capital_cost_coal_plant = 4200000; % dollars/MW, denoted as M_i in the pdf
capital_cost_gas_plant = 2600000; % dollars/MW, denoted as M_i in the pdf


% Emission rates of pounds of CO_2 per kWh for each tech (https://www.eia.gov/tools/faqs/faq.php?id=74&t=11)
co2_coal = 2.30; % pounds per kWh
co2_gas = 0.97; % pounds per kWh
co2_solar = 0;
% Remember to convert these to pounds/MWh for consistency in your units

% co2_emissions = [];

%% Solution


%% Optimal capacity and hourly dispatch



cvx_begin

variables p(n,T) p_solar(1,T) installed_thermal_capacity(1,n) installed_solar_capacity(1);

% To-do: add constraints for upper and lower bounds for installed capacity

% To-do: add constraints for upper and lower bounds for dispatched
% electricity

% To-do: add constraint that will make the output of the solar plant
% (p_solar) equal to its capacity factor times the installed capacity
% (similar to lecture, but now the installed capacity is the variable
% installed_solar_capacity)


sum(p,1) + p_solar >= d;

abs(p(:,2:T)-p(:,1:T-1)) <= R'*ones(1,T-1);

% To-do: Calculate annual fuel costs, then calculate its net present value
% To-do: Calculate the investment cost

%minimize (NPV_total_fuel_cost + Investment_cost)

cvx_end



% white background for plots:
set(gcf,'color','w');

   subplot(3,1,1)
   plot(t,d, 'LineWidth',2.0);
   title('Demand')
   xlabel('Hours')
   ylabel('MWh')
   subplot(3,1,2)
   plot(t,p, t, p_solar, 'LineWidth',2.0);
   title('Generation')
   xlabel('Hours')
   ylabel('MWh')
   legend('coal 1', 'coal 2', 'gas 1', 'gas 2', 'solar')
   subplot(3,1,3)
   plot(t, sum(p)+p_solar, t, d, 'LineWidth',2.0)
   title('Gen and demand')
   xlabel('Hours')
   ylabel('MWh')
   legend('generation', 'demand')
print -depsc gen_dispatch

installed_thermal_capacity
installed_solar_capacity

%% LCOE for each generator from using the optimal dispatch obtained above




%% Part II:



%% Baseline, no RPS



%% RPS



%% Summary figs
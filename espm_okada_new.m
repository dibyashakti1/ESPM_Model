% This script computes two additional dislocations required for the ESPM
% using the function: "espm_geometry"

% Input to calculate geometry: DIP, LD (Locking Depth), T (Plate thickness)
% Known value of LD (Locking Depth) and DIP may be used or can be extracted from
% the grid search method by using 2D-Okada dislocation model (single fault)

% Created by: Dibyashakti, 11 Apr, 2025

% Last modified on: Dibyashakti, 11 Apr, 2025

clear all
close all
clc
addpath(genpath(pwd))

%%

% input synthetic GNSS observation locations
nobs = 200;
E=linspace(-5e5,5e5,nobs*2);
N=0*E;

LD = 20e3;
T = 80e3;

WIDTH = 1e9;
LENGTH = 1e9;
STRIKE = 0;
DIP=10;
RAKE=90;
SLIP=20;
OPEN=0;

%% Dislocation estimation and plot

[lockfault,lockfaultext,normalfault,horzplate] = espm_geometry(DIP,LD,T);

%%
% calculate based on the trigonometry of the dip angle
xoffset_fault1 = LD/tand(DIP);

% fault1: deep dislocation
faultE1 = xoffset_fault1+cosd(DIP)*WIDTH/2;
DEPTH1 = LD + sind(DIP)*WIDTH/2;
faultN=0;
[uE1,uN1,uZ1] = okada85(E-faultE1,N-faultN,DEPTH1,STRIKE,DIP,LENGTH,WIDTH,RAKE,SLIP,OPEN);

%%
% fault 2: deep normal fault
xoffset_fault2 = normalfault(1,1);
faultE2 = xoffset_fault2 + cosd(DIP)*WIDTH/2;
DEPTH2 = T + sind(DIP)*WIDTH/2;
[uE2,uN2,uZ2] = okada85(E-faultE2,N-faultN,DEPTH2,STRIKE,DIP,LENGTH,WIDTH,RAKE,-SLIP,OPEN);

%%
% fault 3: horizontal detachment at the base of India
faultE3 = xoffset_fault2 - WIDTH/2;
DEPTH3 = T;
[uE3,uN3,uZ3] = okada85(E-faultE3,N-faultN,DEPTH3,STRIKE,0,LENGTH,WIDTH,RAKE,-SLIP,OPEN);

%% Plot summation/resultant of the horizontal and vertical displacements

uEtot=uE1+uE2+uE3;
uZtot=uZ1+uZ2+uZ3;

figure(1),clf,hold on
set(gcf,'position',[200,300,800,400])

% subtract start value to place the horizontal reference frame in India
plot(E/1e3,-uEtot+uEtot(1),'b','LineWidth',1.5)
plot(E/1e3,-uE1+uE1(1),'k','LineWidth',1.5)

plot(E/1e3,uZtot,'r','LineWidth',1.5)
plot(E/1e3,uZ1,'m','LineWidth',1.5)
%quiver(E,N,uE2,uN2)
legend('ESPM horiz','DDisloc horiz','ESPM vertical','DDisloc vertical','location','northwest')
set(gca,'FontSize',13,'FontWeight','Bold','LineWidth',1.5) 
title(['Dip =  ' num2str(DIP), ' ; LD = ' num2str(LD/1000), ' ; Slip = ' num2str(SLIP), ' ; T =  ' num2str(T/1000),])

%%

figure(2),clf,hold on
set(gcf,'position',[200,300,800,400])

uEtotlos = uEtot*cosd(38.17);
uZtotlos = uZtot*cosd(38.17);

% subtract start value to place the horizontal reference frame in India
plot(E/1e3,-uEtotlos+uEtotlos(1),'b','LineWidth',1.5)
plot(E/1e3,-uE1+uE1(1),'k','LineWidth',1.5)

plot(E/1e3,uZtotlos,'r','LineWidth',1.5)
plot(E/1e3,uZ1,'m','LineWidth',1.5)
%quiver(E,N,uE2,uN2)
legend('ESPM horiz','DDisloc horiz','ESPM vertical','DDisloc vertical','location','northwest')
set(gca,'FontSize',13,'FontWeight','Bold','LineWidth',1.5) 
title(['Dip =  ' num2str(DIP), ' ; LD = ' num2str(LD/1000), ' ; Slip = ' num2str(SLIP), ' ; T =  ' num2str(T/1000),])


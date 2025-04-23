function [lockfault,lockfaultext,normalfault,horzplate] = espm_geometry(DIP,LD,T)

% This function calculates the geometries/co-ordinates (distance and depth) of the
% three dislocations (two diping and one horizontal faults)

% Inputs: DIP, LD (Locking Depth), T (Plate thickness)
% Known value of LD (Locking Depth) and DIP may be used or can be extracted from
% the grid search method by using 2D-Okada dislocation model (single fault)

% Created by: Dibyashakti, 11 Apr, 2025

% Last modified on: Dibyashakti, 11 Apr, 2025

tic
%%  Defining the First Locked fault
% dip1=10;
% dip=(180-dip1)*pi/180;
% LD = 19.8;  % Locking depth (km) from Okada 2d model
LW = fix(LD/tand(DIP)); % Locking width (km), considering dip and LD 
fprintf('Locking width is %.2f km\n',LW/1e3)

fprintf('Defining the Dislocations/Faults....wait\n')

%   Defining the Locked fault
dist_range = [-500e3,500e3];
nobs = 1;
dist = [0:nobs:LW];
lockfault = [];

for ii = 1:length(dist)
    
    lockfault = [lockfault;[dist(ii),dist(ii)*tand(DIP)]];
        
end

%   Defining the downdip extension of Locked fault
dist2 = [dist(end)+1:nobs:dist_range(2)];
lockfaultext = [];
for ii = 1:length(dist2)
    
    lockfaultext = [lockfaultext;[dist2(ii),dist2(ii)*tand(DIP)]];
        
end

% set(gcf,'position',[200,300,1200,300])
% 
% plot(dist,-lockfault(:,2),'-kx',"LineWidth",1)
% hold on
% plot(dist2,-lockfaultext(:,2)','-r',"LineWidth",1)
% % plot(distw,zeros(size(distw)),'-r',"LineWidth",1)
% 
% xlim([-500e3 500e3])
% ylim([-100e3 0])

%% Defining Second and Third Downgoing plate (Dipping) by finding the Corner point

% T = 40; % Plate Thickness/Width

% Get the slope of the First Locked fault
slope = lockfault(5,1)/lockfault(5,2);  

% Top x and y co-ordinates of the Second Downgoing plate (Dipping)
plate2 = [-T*sind(DIP),T*cosd(DIP)];

spac_dist = sqrt(1+(lockfault(2,2)*lockfault(2,2)));

distf = [dist,dist2];

% for jj = 1:length(distf)
%     
% lockfault2x(jj) = plate2(:,1)+ spac_dist*cosd(dip1)*distf(jj);
% lockfault2y(jj) = plate2(:,2)+ spac_dist*sind(dip1)*distf(jj);
% 
% end

%% 
% Corner point/Bending point
x0 = ((T-plate2(2))+slope*plate2(1))/slope;

% Second Downgoing plate (Dipping)
for jj = 1:length(distf)
    
lockfault2x(jj) = x0 + spac_dist*cosd(DIP)*distf(jj);
lockfault2y(jj) = T + spac_dist*sind(DIP)*distf(jj);

end

normalfault = [lockfault2x',lockfault2y'];

%%
% Second Downgoing plate (Horizontal)

plate3x = [x0:-1:-500e3]';
plate3y = ones(length(plate3x),1)*(-T);

horzplate = [plate3x,plate3x];

fprintf('Defining the Dislocations/Faults....Done\n')

%%
figure(4)
set(gcf,'position',[200,300,1200,350])

plot(dist/1e3,-lockfault(:,2)/1e3,'-kx',"LineWidth",1.5)
hold on
plot(dist2/1e3,-lockfaultext(:,2)'/1e3,'-r',"LineWidth",1.5)
% plot(distw,zeros(size(distw)),'-r',"LineWidth",1)
hold on
plot(lockfault2x/1e3,-lockfault2y/1e3,'b',"LineWidth",1.5)
plot(plate3x/1e3,plate3y/1e3,'g',"LineWidth",1)
set(gca,'FontSize',11,'FontWeight','Bold','LineWidth',1.5) 
xlim([-500 500])
ylim([-200 0])

toc

end


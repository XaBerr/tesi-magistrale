clear all;
close all;
clc;
set(0, 'defaultAxesFontSize', 20);




%% ESP1
filenameAliceCoarse = "martellate/Alice_coarse_hammer_8.txt";
filenameBobCoarse = "martellate/bob_coarse_hammer_8.txt";
filenameBobFine = "martellate/bob_fine_hammer_8.txt";

figure();
[Acoarse_dx, Acoarse_dy, Acoarse_cstatus] = load_file(filenameAliceCoarse);
t = (1 : length(Acoarse_dx)) * 0.017;
index = t > 0;
ax1 = subplot(3,1,1);
hold(ax1, 'on');
patch([14 50 50 14], [27 27 -27 -27], 'y');
patch([60 125 125 60], [27 27 -27 -27], 'y');
alpha(0.1);
p1 = plot(ax1, t(index), Acoarse_dx(index), 'color', "Red", 'Marker', '.');
p2 = plot(ax1, t(index), Acoarse_dy(index), 'color', "Blue", 'Marker', '.');
p3 = plot(ax1, t(index), Acoarse_cstatus(index), 'k-', 'LineWidth', 3);
grid on;
ylabel('Distance [px]');
title("Alice Coarse");
legend([p1 p2 p3], ["\Delta x" "\Delta y" "One shot on/off"]);

[Bcoarse_dx, Bcoarse_dy, Bcoarse_cstatus] = load_file(filenameBobCoarse);
ax2 = subplot(3,1,2);
t = (1 : length(Bcoarse_dx)) * 0.017;
index = t > 0;
hold(ax2, 'on');
patch([14 50 50 14], [500 500 -500 -500], 'y');
patch([60 125 125 60], [500 500 -500 -500], 'y');
alpha(0.1);
p1 = plot(ax2, t(index), Bcoarse_dx(index), 'color', "Red", 'Marker', '.');
p2 = plot(ax2, t(index), Bcoarse_dy(index), 'color', "Blue", 'Marker', '.');
p3 = plot(ax2, t(index), Bcoarse_cstatus(index), 'k-', 'LineWidth', 3);
grid on;
ylabel('Distance [px]');
title("Bob Coarse");
legend([p1 p2 p3], ["\Delta x" "\Delta y" "One shot on/off"]);

[Bfine_dx, Bfine_dy, Bfine_cstatus] = load_file(filenameBobFine);
ax3 = subplot(3,1,3);
t = (1 : length(Bfine_dx)) * 0.0135;
index = t > 0;
hold(ax3, 'on');
patch([14 50 50 14], [500 500 -500 -500], 'y');
patch([60 125 125 60], [500 500 -500 -500], 'y');
alpha(0.1);
p1 = plot(ax3, t(index), Bfine_dx(index), 'color', "Red", 'Marker', '.');
p2 = plot(ax3, t(index), Bfine_dy(index), 'color', "Blue", 'Marker', '.');
p3 = plot(ax3, t(index), Bfine_cstatus(index), 'k-', 'LineWidth', 3);
grid on;
xlabel('Time [s]');
ylabel('Distance [px]');
title("Bob Fine");
legend([p1 p2 p3], ["\Delta x" "\Delta y" "One shot on/off"]);

%% ESP1
filenameAliceCoarse = "martellate/Alice_coarse_hammer.txt";
filenameBobCoarse = "martellate/bob_coarse_hammer.txt";

figure();
[Acoarse_dx, Acoarse_dy, Acoarse_cstatus] = load_file(filenameAliceCoarse);
t = (1 : length(Acoarse_dx)) * 0.017;
index = t > 18 & t < 28;
t = t - 18;
ax1 = subplot(2,1,1);
plot(ax1, t(index), Acoarse_dx(index), 'color', "Red", 'Marker', '.');
hold(ax1, 'on');
plot(ax1, t(index), Acoarse_dy(index), 'color', "Blue", 'Marker', '.');
plot(ax1, t(index), Acoarse_cstatus(index), 'k-', 'LineWidth', 3);
grid on;
ylabel('Distance [px]');
title("Alice Coarse");
legend(["\Delta x" "\Delta y" "One shot on/off"]);

[Bcoarse_dx, Bcoarse_dy, Bcoarse_cstatus] = load_file(filenameBobCoarse);
ax2 = subplot(2,1,2);
t = (1 : length(Bcoarse_dx)) * 0.017;
index = t > 18 & t < 28;
t = t - 18;
plot(ax2, t(index), Bcoarse_dx(index), 'color', "Red", 'Marker', '.');
hold(ax2, 'on');
plot(ax2, t(index), Bcoarse_dy(index), 'color', "Blue", 'Marker', '.');
plot(ax2, t(index), Bcoarse_cstatus(index), 'k-', 'LineWidth', 3);
grid on;
ylabel('Distance [px]');
title("Bob Coarse");
legend(["\Delta x" "\Delta y" "One shot on/off"]);




%% FUNCTIONS

function [deltax, deltay, controllerstatus] = load_file(filename)
    fid = fopen(filename);
    data = textscan(fid,'%f%f%f%f%s', 'Delimiter', ';', 'HeaderLines',1);
    assignin('base','data',data);
    fclose(fid);

    xtarget = data{1};
    ytarget = data{2};
    deltax = data{3};
    deltay = data{4};
    controllerstatus = data{5};
    pos_on = find(strcmp(controllerstatus,'on'));
    controllerstatus = zeros(length(controllerstatus), 1);
    controllerstatus(pos_on) = max([max(abs(deltay)) max(abs(deltax))]);
end
clear all
close all

% filenameAliceCoarse = 'Alice_coarse_hammer_8.txt';
% filenameBobCoarse = 'bob_coarse_hammer_8.txt';
% filenameBobFine = 'bob_fine_hammer_8.txt';

filenameAliceCoarse = 'Alice_coarse_hammer.txt';
filenameBobCoarse = 'bob_coarse_hammer.txt';
% filenameBobFine = 'bob_fine_hammer.txt';


[Acoarse_dx, Acoarse_dy, Acoarse_cstatus] = load_file(filenameAliceCoarse);
[Bcoarse_dx, Bcoarse_dy, Bcoarse_cstatus] = load_file(filenameBobCoarse);
% [Bfine_dx, Bfine_dy, Bfine_cstatus] = load_file(filenameBobFine);

figure(1);
ax1 = subplot(3,1,1);
ax2 = subplot(3,1,2);
ax3 = subplot(3,1,3);

plot(ax1, Acoarse_dx, 'r.');
hold(ax1, 'on');
plot(ax1, Acoarse_dy, 'b.');
plot(ax1, Acoarse_cstatus, 'k-');

plot(ax2, Bcoarse_dx, 'r.');
hold(ax2, 'on');
plot(ax2, Bcoarse_dy, 'b.');
plot(ax2, Bcoarse_cstatus, 'k-');


% plot(ax3, Bfine_dx, 'r.');
% hold(ax3, 'on');
% plot(ax3, Bfine_dy, 'b.');
% plot(ax3, Bfine_cstatus, 'k-');







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
controllerstatus(pos_on) = max([max(abs(deltay)) max(abs(deltax))])

end
clear all;
close all;

%% FILE SELECTION
filename1 = 'fluttuazioni_stufetta/stufetta_control_off_100Hz.txt';
filename2 = 'fluttuazioni_stufetta/stufetta_control_on_100Hz.txt';
% filename1 = 'stufetta_caldo_controloff_100Hz.txt';
% filename2 = 'stufetta_caldo_PIDON_100Hz.txt';
% filename2 = 'stufetta_caldo_singleshot_r20_100Hz.txt'; % brutto comunque
% filename1 = 'telefono_serietemporale_100Hz.txt';
% filename1 = 'salti_controlOFF.txt';
% filename2 = 'salti_PIDON.txt';


%% PLOT
figure(1);
ax1 = subplot(1,3,1);
ax2 = subplot(1,3,2);
ax3 = subplot(1,3,3);
plot_scatter(ax1, filename1, 'red');
plot_scatter(ax1, filename2, 'blue');
hold(ax1, 'on');
grid(ax1, 'on');
legend(ax1, 'PID OFF', 'PID ON')
plot_timeseries(ax2, filename1)
plot_timeseries(ax3, filename2)


%% FUNCTIONS
function [] = plot_timeseries(ax, filename)
fid = fopen(filename);
data = textscan(fid,'%f%f%f%f', 'Delimiter', ';', 'HeaderLines',1);
assignin('base','data',data);
fclose(fid);

xtarget = data{1};
ytarget = data{2};
deltax = data{3};
deltay = data{4};

% x = xtarget + deltax;
% y = ytarget + deltay;
x = deltax - mean(deltax);
y = deltay - mean(deltay);
hold(ax, 'on');
t = 1:length(x);
t=t*0.1;
plot(ax, t, x, 'color', 'red', 'Marker', '.');
plot(ax, t, y, 'color', 'blue', 'Marker', '.');

% xlabel(ax, 'Delta X (pixel)');
% ylabel(ax, 'Delta Y (pixel)');
% ylim([-150 150]);
xlim([0 max(t)]);
ylim([-2*max(x) 2*max(x)]);
xlabel(ax, 'Time (s)')

end

function [] = plot_scatter(ax, filename, color)
fid = fopen(filename);
data = textscan(fid,'%f%f%f%f', 'Delimiter', ';', 'HeaderLines',1);
assignin('base','data',data);
fclose(fid);

xtarget = data{1};
ytarget = data{2};
deltax = data{3};
deltay = data{4};

% x = xtarget + deltax;
% y = ytarget + deltay;
x = deltax % - mean(deltax);
y = deltay % - mean(deltay);
hold(ax, 'on');
plot(ax, x,y, 'color', color, 'Marker', 'x', 'linestyle', 'none');
xlabel(ax, 'Delta X (pixel)');
ylabel(ax, 'Delta Y (pixel)');
ylim([-150 150]);
xlim([-150 150]);
end
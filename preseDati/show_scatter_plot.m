clear all;
close all;
clc;
set(0, 'defaultAxesFontSize', 20);

%% FILE SELECTION
simulation = input('Choose the simulation: ');
switch simulation
    case 1
        filename1 = 'fluttuazioni_stufetta/stufetta_control_off_100Hz.txt';
        filename2 = 'fluttuazioni_stufetta/stufetta_control_on_100Hz.txt';
    case 2
        filename1 = 'fluttuazioni_stufetta/stufetta_control_off_100Hz_2.txt';
        filename2 = 'fluttuazioni_stufetta/stufetta_control_on_100Hz_2.txt';
    case 3
        filename1 = 'fluttuazioni_stufetta/stufetta_caldo_controlloOFF_10Hz.txt';
        filename2 = 'fluttuazioni_stufetta/stufetta_control_on_100Hz.txt';
%         filename2 = 'fluttuazioni_stufetta/stufetta_caldo_PIDON_10Hz.txt';
    case 4
        filename1 = 'fluttuazioni_stufetta/stufetta_caldo_controloff_100Hz.txt';
        filename2 = 'fluttuazioni_stufetta/stufetta_caldo_PIDON_100Hz.txt';
%     case 5
%         filename1 = 'fluttuazioni_stufetta/stufetta_caldo_controlloOFF_10Hz.txt';
%         filename2 = 'fluttuazioni_stufetta/stufetta_caldo_PIDON_10Hz.txt';
%     case 6
%         filename1 = 'fluttuazioni_stufetta/stufetta_caldo_controlloOFF_10Hz.txt';
%         filename2 = 'fluttuazioni_stufetta/stufetta_caldo_PIDON_10Hz.txt';
        
end


%% PLOT
figure(1);
ax1 = subplot(1,3,1);
ax2 = subplot(1,3,2);
ax3 = subplot(1,3,3);
plot_scatter(ax1, filename1, 'red', true);
plot_scatter(ax1, filename2, 'blue', true);
hold(ax1, 'on');
grid(ax1, 'on');
legend(ax1, 'PID OFF', 'PID ON')
plot_timeseries(ax2, filename1);
plot_timeseries(ax3, filename2);


%% FUNCTIONS
function data = fileOpen(filename)
    fid = fopen(filename);
    data = textscan(fid, '%f;%f;%f;%f', 'HeaderLines', 1);
    assignin('base', 'data', data);
    fclose(fid);
end

function data = importfile(filename, startRow, endRow)
    delimiter = ';';
    if nargin<=2
        startRow = 2;
        endRow = inf;
    end
    formatSpec = '%f%f%f%f%[^\n\r]';
    fileID = fopen(filename,'r');

    dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines', startRow(1)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    for block=2:length(startRow)
        frewind(fileID);
        dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines', startRow(block)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
        for col=1:length(dataArray)
            dataArray{col} = [dataArray{col};dataArrayBlock{col}];
        end
    end
    fclose(fileID);
    data = table(dataArray{1:end-1}, 'VariableNames', {'targetx','targety','deltax','deltay'});
end

function [] = plot_timeseries(ax, filename)
    data = fileOpen(filename);
    deltax = data{3};
    deltay = data{4};

    x = deltax - mean(deltax);
    y = deltay - mean(deltay);
    hold(ax, 'on');
    t = 1:length(x);
    t=t*0.1;
    plot(ax, t, x, 'color', 'red', 'Marker', '.');
    plot(ax, t, y, 'color', 'blue', 'Marker', '.');

    xlim([0 max(t)]);
    ylim([-2*max(x) 2*max(x)]);
    xlabel(ax, 'Time (s)')
end

function [] = plot_scatter(ax, filename, color, meanRemoved)
    data = fileOpen(filename);
    deltax = data{3};
    deltay = data{4};
    if meanRemoved
        x = deltax - mean(deltax);
        y = deltay - mean(deltay);
    else
        x = deltax;
        y = deltay;
    end
    hold(ax, 'on');
    plot(ax, x,y, 'color', color, 'Marker', 'x', 'linestyle', 'none');
    xlabel(ax, 'Delta X (pixel)');
    ylabel(ax, 'Delta Y (pixel)');
    ylim([-150 150]);
    xlim([-150 150]);
end
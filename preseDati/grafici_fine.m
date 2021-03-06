clear all;
close all;
% clc;
set(0, 'defaultAxesFontSize', 20);

%% FILE SELECTION
simulation = input('Choose the simulation: ');
switch simulation
    case 1
        filename1 = "fluttuazioni_vari_rumori/stufetta_caldo_controloff_100Hz.txt";
        filename2 = "fluttuazioni_vari_rumori/stufetta_caldo_PIDON_100Hz.txt";
        plot_timeseries(filename1);
        ylim([-0.50 0.50]);
        legend(["\Delta x" "\Delta y"]);
        plot_timeseries(filename2);
        ylim([-0.50 0.50]);
        legend(["\Delta x" "\Delta y"]);
        plot_scatter([filename1 filename2], ["red" "blue"]);
        ylim([-0.50 0.50]);
        legend(["PID off" "PID on"]);
%     case 2
%         filename1 = "fluttuazioni_vari_rumori/stufetta_caldo_singleshot_r10_100Hz.txt";
%         filename2 = "fluttuazioni_vari_rumori/stufetta_caldo_singleshot_r30_100Hz.txt";
%         plot_timeseries(filename1);
%         ylim([-500 500]);
%         legend(["\Delta x" "\Delta y"]);
%         plot_timeseries(filename2);
%         ylim([-500 500]);
%         legend(["\Delta x" "\Delta y"]);
%         plot_scatter([filename1 filename2], ["red" "blue"]);
%         ylim([-500 500]);
%         legend(["r = 10 px" "r = 30 px"]);
    case 3
        filename1 = "fluttuazioni_vari_rumori/stufetta_caldo_controloff_100Hz.txt";
        filename2 = "fluttuazioni_vari_rumori/stufetta_caldo_singleshot_r30_100Hz.txt";
        plot_timeseries(filename1);
        ylim([-5 5]);
        legend(["\Delta x" "\Delta y"]);
        plot_timeseries(filename2);
        ylim([-5 5]);
        legend(["\Delta x" "\Delta y"]);
        plot_scatter([filename1 filename2], ["red" "blue"]);
        ylim([-5 5]);
        legend(["One shot off" "One shot on"]);
end


%% FUNCTIONS
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

function [] = plot_timeseries(filename)
    data = importfile(filename);
    x = data.deltax / 100;
    y = data.deltay / 100;
    t = (1 : length(x)) * 0.0135;
    figure();
    hold on;
    grid on;
    plot(t, x, 'color', "Red", 'Marker', '.');
    plot(t, y, 'color', "Blue", 'Marker', '.');
    xlabel('Time [s]');
    ylabel('Distance [mm]');
    xlim([0 max(t)]);
    hold off;
    mx = mean(x);
    my = mean(y);
    vx = sqrt(var(x));
    vy = sqrt(var(y));
    fprintf("%s: m:(%.2f,%.2f) v:(%.2f,%.2f)\n", filename, mx, my, vx, vy);
end

function [] = plot_scatter(filenames, colors)
    figure();
    hold on;
    grid on;
    limitex = [];
    limitey = [];
    for i = 1 : size(filenames, 2)
        data = importfile(filenames(i));
        x = data.deltax / 100;
        y = data.deltay / 100;
        plot(x, y, 'color', colors(i), 'Marker', 'x', 'linestyle', 'none');
        limitex = [max(abs(x)) limitex];
        limitey = [max(abs(y)) limitey];
    end
    xlabel('\Delta x [mm]');
    ylabel('\Delta y [mm]');
    limite = max([limitex limitey]);
    ylim([-limite limite]);
    xlim([-limite limite]);
    hold off;
end
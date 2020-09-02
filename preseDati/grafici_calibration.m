clear all;
close all;
clc;
set(0, 'defaultAxesFontSize', 20);

%% MAIN
files = struct("data", [], "volt", 0);
n = 0;
for i = 1 : 0.25 : 4
    n = n + 1;
    files(n).data = importfile("calibrazione_primo_stock_100_Hz/volt_" + i + "_" + i + "_" + i + "_" + i + ".txt");
    files(n).volt = i;
end

x = files(1).data.deltax + files(1).data.targetx;
y = files(1).data.deltax + files(1).data.targetx;

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
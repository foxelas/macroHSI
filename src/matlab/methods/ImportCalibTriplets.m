function [] = ImportCalibTriplets(queryParams)
% ImportCalibTriplets prepares triplet .mat files using database info and a
% queryCondition search criterion 
%
%   Usage:  
%   queryParams = {{'hands', false}, 618};
%   ImportCalibTriplets(queryParams);
%
%   ImportCalibTriplets(); %imports the entire selected DB 

StartLogger;
Initialization;

experiment = strcat('import_', GetSetting('database'));
SetSetting('experiment', experiment);

readAll = false; 
if nargin < 1 || isempty(queryParams)
    readAll = true; 
    queryParams = []; 
end 

if ~iscell(queryParams)
    dataDate = queryParams;
    queryParams = {[], [], [], [], dataDate};
end 

if readAll
    outRows = GetDB();
else
    [~, ~, outRows] = Query(queryParams{:});
end 

setId = ~ismember(outRows.Content, GetSetting('blackContent')) & ~ismember(outRows.Content, GetSetting('whiteContent'));
outRows = outRows(setId, :);

isTest = GetSetting('isTest');
if isTest
    integrationTimes = [outRows.IntegrationTime];
    dates = [outRows.CaptureDate];

    hasConfiguration = strcmp('Configuration',outRows.Properties.VariableNames);
    if hasConfiguration 
        configurations = [outRows.Configuration];
    end 
end 

for i = 1:size(outRows,1)
    target = GetValueFromTable(outRows, 'Target', i);
    content = GetValueFromTable(outRows, 'Content', i);
    
    if isTest
        SetSetting('integrationTime', integrationTimes(i));
        SetSetting('dataDate', num2str(dates(i)));
        if hasConfiguration 
            SetSetting('configuration', configurations{i});
        end 
    end 
    [spectralData] = ReadHSIData(content, target, experiment);
end

end 
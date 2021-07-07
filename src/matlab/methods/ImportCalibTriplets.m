function [] = ImportCalibTriplets(dataDate, experiment, queryParams)
% ImportCalibTriplets prepares triplet .mat files using database info and a
% queryCondition search criterion 
%
%   Usage:  
%   queryParams = {[], {'hands', false}, 618};
%   ImportCalibTriplets('20200112', 'handsDb');

StartLogger;
normalization = 'byPixel';

Initialization;

if nargin < 3 
    queryParams = {[], [], [], [], dataDate};
end 

[~, ~, outRows] = Query(queryParams{:});

setId = ~ismember(outRows.Content, 'lightsOff') & ~ismember(outRows.Content, 'whiteReflectance');
outRows = outRows(setId, :);

integrationTimes = [outRows.IntegrationTime];
dates = [outRows.CaptureDate];
configurations = [outRows.Configuration];
for i = 1:size(outRows,1)
    target = GetValueFromTable(outRows, 'Target', i);
    content = GetValueFromTable(outRows, 'Content', i);
    SetSetting('integrationTime', integrationTimes(i));
    SetSetting('dataDate', num2str(dates(i)));
    SetSetting('configuration', configurations{i});
    [spectralData] = ReadHSIData(content, target, experiment);
end

end 
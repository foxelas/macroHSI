function [] = ImportCalibTriplets(queryCondition, experiment)
% ImportCalibTriplets prepares triplet .mat files using database info and a
% queryCondition search criterion 
%
%   Usage:  
%   ImportCalibTriplets({'hand', false}, 'hands')
StartLogger;
normalization = 'byPixel';

Initialization;

[~, targetIDs, outRows] = Query([], queryCondition);
integrationTimes = [outRows.IntegrationTime];
dates = [outRows.CaptureDate];
configurations = [outRows.Configuration];
for i = 1:length(targetIDs)
    target = GetValueFromTable(outRows, 'Target', i);
    content = GetValueFromTable(outRows, 'Content', i);
    SetSetting('integrationTime', integrationTimes(i));
    SetSetting('dataDate', num2str(dates(i)));
    SetSetting('configuration', configurations{i});
    [spectralData] = ReadHSIData(content, target, experiment);
end

end 
function [] = InitializeDataGroup(experiment, condition)
% InitializeDataGroup reads a group of hsi data, prepares .mat files,
% prepared normalized files and returns montage previews of contents
%
%   Usage:
%   InitializeDataGroup('handsOnly',{'hand', false})

StartLogger;

%% Setup

dataDate = '20201218';
%configuration = 'singleLightClose';
integrationTime = 200;
normalization = 'byPixel';

Initialization;

SetSetting('cropBorders', true);

%% Read h5 data
[filenames, targetIDs, outRows] = Query([], condition);
integrationTimes = [outRows.IntegrationTime];
dates = [outRows.CaptureDate];
configurations = [outRows.Configuration];

for i = 1:length(targetIDs)
    id = targetIDs(i);
    %target = GetValueFromTable(outRows, 'Target', i);
    %content =  GetValueFromTable(outRows, 'Content', i);
    SetSetting('integrationTime', integrationTimes(i));
    SetSetting('dataDate', num2str(dates(i)));
    SetSetting('configuration', configurations{i});

    targetName = num2str(id);
    spectralData = ReadStoredHSI(targetName);
    dispImage = GetDisplayImage(rescale(spectralData), 'rgb');
    figure(1);
    imshow(dispImage);
    SetSetting('plotName', DirMake(GetSetting('savedir'), GetSetting('experiment'), 'rgb', StrrepAll(filenames{i})));
    SavePlot(1);

    spectralData = NormalizeHSI(targetName);
    dispImage = GetDisplayImage(rescale(spectralData), 'rgb');
    figure(2);
    imshow(dispImage);
    SetSetting('plotName', DirMake(GetSetting('savedir'), GetSetting('experiment'), 'normalized', StrrepAll(filenames{i})));
    SavePlot(2);
end

path1 = fullfile(GetSetting('savedir'), GetSetting('experiment'), 'normalized');
Plots(1, @MontageFolderContents, path1, '*.jpg', 'Normalized');
path1 = fullfile(GetSetting('savedir'), GetSetting('experiment'), 'rgb');
Plots(2, @MontageFolderContents, path1, '*.jpg', 'sRGB');

end
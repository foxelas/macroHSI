%% Prepares a database for hand HSI

%% Setup 
StartLogger;
experiment = 'handsOnly';
dataDate = '20201218';
%configuration = 'singleLightClose';
integrationTime = 200;
normalization = 'byPixel';

Initialization;

SetSetting('cropBorders', true);

%% Read h5 data 
[filenames, targetIDs, outRows] = Query([], {'hand', false});
integrationTimes = [outRows.IntegrationTime];
dates = [outRows.CaptureDate];
configurations = [outRows.Configuration];

for i = 1:length(targetIDs)
    id = targetIDs(i);
    target = GetValueFromTable(outRows, 'Target', i);
    content =  GetValueFromTable(outRows, 'Content', i);
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
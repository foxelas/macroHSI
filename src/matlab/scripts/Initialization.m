
%% Initialization
disp('Initialization started');

userSettingsFile = '..\..\conf\hsiUserSettings.csv';
originDir = 'D:\elena\mspi';

%% Main
SetOpt(userSettingsFile);

%% Other settings
if ~exist('dataDate', 'var')
    dataDate = '20210127';
    warning('Setting default date: 20210127.');
end
SetSetting('dataDate', dataDate);

indir = fullfile(originDir, '2_saitamaHSI', strcat('saitama', dataDate, '_test'), 'h5');
if exist('indirFolder', 'var') && ~isempty(indirFolder)
    indir = fullfile(originDir, '2_saitamaHSI', strcat('saitama', dataDate, '_test'), indirFolder, 'h5');
end

if ~exist('dataBase', 'var')
    dataBase = 'calib';
    warning('Setting default database for calibration: calib.');
end
SetSetting('database', dataBase);

SetSetting('datadir', indir);
matdir = fullfile(originDir, 'matfiles\hsi');
SetSetting('matdir', matdir);

if exist('experiment', 'var')
    SetSetting('experiment', experiment);
    SetSetting('saveFolder', experiment);
end

if exist('integrationTime', 'var')
    SetSetting('integrationTime', integrationTime);
end

if ~exist('configuration', 'var')
    configuration = 'singleLightClose';
end
SetSetting('configuration', configuration);

if ~exist('normByPixel', 'var')
    normByPixel = true;
end
SetSetting('normByPixel', normByPixel);

if exist('targetPosition', 'var')
    SetSetting('targetPosition', targetPosition);
end

if exist('normalization', 'var')
    SetSetting('normalization', normalization);
end

if exist('colorPatchOrder', 'var')
    SetSetting('colorPatchOrder',  colorPatchOrder); 
end 

disp('Initialization finished');


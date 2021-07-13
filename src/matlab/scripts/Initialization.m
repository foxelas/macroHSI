
%% Initialization
disp('Initialization started');

userSettingsFile = '..\..\conf\hsiUserSettings.csv';
originDir = 'D:\elena\mspi';

%% Main
SetOpt(userSettingsFile);

%% Other settings
SetSetting('mspiDir', originDir);


if GetSetting('isTest')
    if ~exist('dataDate', 'var')
        dataDate = '20210127';
        warning('Setting default date: 20210127.');
    end
    SetSetting('dataDate', dataDate);
    
    testDir = fullfile(GetSetting('mspiDir'), GetSetting('hsiTestDir'));
    indir = fullfile(testDir, strcat('saitama', dataDate, '_test'), 'h5');
    if exist('indirFolder', 'var') && ~isempty(indirFolder)
        indir = fullfile(testDir, strcat('saitama', dataDate, '_test'), indirFolder, 'h5');
    end  
else 
    hsiSkinDir = fullfile(GetSetting('mspiDir'), GetSetting('hsiDataDir'));
    indir = fullfile(hsiSkinDir, 'h5');
end 
SetSetting('datadir', indir);

if exist('database', 'var')
    SetSetting('database', dataBase);
end

matdir = fullfile(GetSetting('mspiDir'), 'matfiles\hsi');
SetSetting('matdir', matdir);

if exist('experiment', 'var')
    SetSetting('experiment', experiment);
    SetSetting('saveFolder', experiment);
end

if exist('integrationTime', 'var')
    SetSetting('integrationTime', integrationTime);
end

if exist('configuration', 'var')
    SetSetting('configuration', configuration);
end

if exist('targetPosition', 'var')
    SetSetting('targetPosition', targetPosition);
end

if exist('normalization', 'var')
    SetSetting('normalization', normalization);
end

if exist('colorPatchOrder', 'var')
    SetSetting('colorPatchOrder', colorPatchOrder);
end

disp('Initialization finished');

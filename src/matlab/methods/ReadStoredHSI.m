function [spectralData] = ReadStoredHSI(targetName)
    basedir = fullfile(GetSetting('matdir'), ...
        strcat(GetSetting('database'), 'Triplets'), targetName);

    targetFilename = strcat(basedir, '_target.mat'); 
    load(targetFilename, 'spectralData');
end 
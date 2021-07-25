function [basedir] = GetMatSaveFolder(targetName)
%GetMatSaveFolder returns the directory where .mat files are saved 
%
%   Usage:
%   basedir = GetMatSaveFolder('Triplets');

basedir = DirMake(GetSetting('matdir'), strcat(GetSetting('database'), targetName, '\'));
end 
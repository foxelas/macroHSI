function [spectralData] = ReadStoredHSI(targetName)
% ReadStoredHSI reads a stored HSI from a _target mat file
%
%   Usage:
%   [spectralData] = ReadStoredHSI(targetName)

basedir = strcat(GetMatSaveFolder('Triplets'), targetName);

targetFilename = strcat(basedir, '_target.mat');
load(targetFilename, 'spectralData');
end
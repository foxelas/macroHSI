function [spectralData, imageXYZ, wavelengths] = LoadH5Data(filename)
%LOADH5DATA loads info from h5 file
%
%   Usage:
%   [spectralData, imageXYZ, wavelengths] = LoadH5Data(filename)
%   returns spectralData, XYZ image and capture wavelengths
%

database = GetSetting('database');
filename = strrep(filename, '.hsm', '.h5');
saveFilename = DirMake(GetSetting('matdir'), database, strcat(filename, '.mat'));

if ~exist(saveFilename, 'file')
    currentFile = AdjustFilename(filename);
    %h5disp(currentFile);
    %h5info(currentFile);

    spectralData = double(h5read(currentFile, '/SpectralImage'));

    wavelengths = h5read(currentFile, '/Wavelengths');
    imageX = h5read(currentFile, '/MeasurementImages/Tristimulus_X');
    imageY = h5read(currentFile, '/MeasurementImages/Tristimulus_Y');
    imageZ = h5read(currentFile, '/MeasurementImages/Tristimulus_Z');
    imageXYZ = cat(3, imageX, imageY, imageZ);

    save(saveFilename, 'spectralData', 'imageXYZ', 'wavelengths', '-v7.3');
else
    load(saveFilename, 'spectralData', 'imageXYZ', 'wavelengths');
end

end

function currentFile = AdjustFilename(filename)
indir = GetSetting('datadir');

filenameParts = strsplit(filename, '_');
dataDate = filenameParts{1};
if ~contains(indir, dataDate)
    filenameParts = strsplit(indir, '\\saitama');
    ending = filenameParts{2};
    filenameParts = strsplit(ending, '_');
    oldDate = filenameParts{1};
    indir = strrep(indir, oldDate, dataDate);
end

currentFile = fullfile(indir, filename);
end
function [] = ImportCalibMat(targetDir, integrationTime)
% ImportCalibMat prepares .mat files and rgb composites for images that
% are added in the database for the first time
%
%   Usage:
%   ImportHSIFromH5('D:\data', 618)

Initialization;

nameList = dir(fullfile(targetDir, '*.h5'));

for i = 1:numel(nameList)
    filename = fullfile(nameList(i).folder, nameList(i).name);
    [spectralData, ~, ~] = LoadH5Data(filename);
    dispImage = GetDisplayImage(rescale(spectralData), 'rgb');
    figure(1);
    imshow(dispImage);
    SetSetting('plotName', strrep(filename, '.h5', '.jpg'));
    SavePlot(1);
end


end
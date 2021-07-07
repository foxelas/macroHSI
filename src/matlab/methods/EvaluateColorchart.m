function [T, measuredSpectra, adjustedSpectra, alphaCoeff] = EvaluateColorchart(targetName, allowRoiSelection, selectedPatches, altExpectedSpectra)
%EVALUATECOLORCHART returns measured curves end evaluations in comparison
%to expected colorchart curves
%
%   [T, measuredSpectra, adjustedSpectra] = evaluateColorchart(
%   targetName, allowRoiSelection, selectedPatches) returns values for
%   evaluation of the colorchart
%
%   Input parameters
%   -targetName: targetName of HSI file to read
%   -allowRoiSelection: whether manual selection of colorchart ROI is
%   allowed
%   -selectedPatches: indexes of available patches to be used [Optional]
%   -altExpectedSpectra: to set alternative expectedSpectra [Optional]
%
%   Output parameters
%   -T: table including GOF, NMSE, RMSE of the evalueation of measured with
%   expected spectra
%   -measuredSpectra: measured spectra from the HSI
%   -adjustedSpectra: measured spectra from the HSI after adjustment
%   -alphaCoeff: coefficient used for level adjustment

experiment = GetSetting('experiment');
patchOrder = GetExpectedValues('colorchartOrder', experiment);
[expectedSpectra, patchNames, expectedWavelengths] = GetExpectedValues();

if nargin < 2
    allowRoiSelection = false;
end

if nargin < 3 || isempty(selectedPatches)
    selectedPatches = 1:length(patchNames);
end

if nargin >= 4 
    standardSpectra = altExpectedSpectra;
else 
    standardSpectra = expectedSpectra(selectedPatches, :);
end 
patchNames = patchNames(selectedPatches);    

option = GetSetting('normalization');

fileConditions = GetFileConditions('colorchart', targetName);
[filename, tableId] = GetFilename(fileConditions{:});
spectralData = NormalizeHSI(num2str(tableId));
dispImage = GetDisplayImage(spectralData, 'rgb');
wavelengths = GetWavelengths(size(spectralData,3));

[colorMasks, chartMask] = GetColorchartMasks(dispImage, allowRoiSelection, filename);
actualSpectralVals = GetSpectrumCurves(spectralData, colorMasks, chartMask);

[reorderedSpectralVals, lineNames] = ReorderSpectra(actualSpectralVals, patchOrder, patchNames, wavelengths, expectedWavelengths);
% [reorderedSpectralValsRaw, ~] = reorderSpectra(actualSpectralVals, chartColorOrder, spectraColorOrder, wavelengths, expectedWavelengths);
measuredSpectra = reorderedSpectralVals;

if ~strcmp(option, 'raw')
    [T, adjustedSpectra, alphaCoeff] = CompareSpectra(standardSpectra, measuredSpectra, lineNames);
else
    T = [];
    adjustedSpectra = [];
    alphaCoeff = [];
    plots(1, @PlotColorChartSpectra, measuredSpectra, lineNames, 'measured-raw', [0, 0.005], false);
end

end
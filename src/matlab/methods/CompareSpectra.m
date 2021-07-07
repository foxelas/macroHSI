function [T, adjusted, alphaCoeff] = CompareSpectra(expected, measured, lineNames)
%COMPARESPECTRA compares expected and measured spectra
%
%   T = CompareSpectra(expected, measured, lineNames) returns a table with
%   comparison differences for three metrics, Goodness-Of-Fit, Normalized
%   Mean Square Error and Root Mean Square Error
%
%   [T, adjusted, alpha] = CompareSpectra(expected, measured, lineNames) 
%   returns table T and also adjusted values after adjustment
%

%% Standard (expected) color patch spectra
Plots(4, @PlotColorChartSpectra, expected, lineNames, 'expected');
Plots(5, @PlotColorChartSpectra, measured, lineNames, 'measured');

m = size(expected, 2);
x = GetWavelengths(m, 'babel');

% Limit to Range [420,730]nm 
measured = AdjustRange(measured);
expected = AdjustRange(expected);
measuredDecim = AdjustRange(measured, 'standard');

difference = expected - measuredDecim;
Plots(6, @PlotColorChartSpectra, difference, lineNames, 'difference');

gofs = ApplyRowFunc(@GoodnessOfFit, measuredDecim, expected);
nmses = ApplyRowFunc(@Nmse, measuredDecim, expected);
rmses = ApplyRowFunc(@Rmse, measuredDecim, expected);

%% Standard (expected) color patch spectra after adjustment
[adjusted, alphaCoeff] = AdjustSpectra(measured, lineNames, 'toRatio');

Plots(7, @PlotColorChartSpectra, adjusted, lineNames, 'measured-adjusted');

adjustedDecim = AdjustRange(adjusted, 'standard');
differenceAdjusted = expected - adjustedDecim;
Plots(8, @PlotColorChartSpectra, differenceAdjusted, lineNames, 'difference-adjusted');

gofsAdj = ApplyRowFunc(@GoodnessOfFit, adjustedDecim, expected);
nmsesAdj = ApplyRowFunc(@Nmse, adjustedDecim, expected);
rmsesAdj = ApplyRowFunc(@Rmse, adjustedDecim, expected);

T = table(lineNames, gofs, nmses, rmses, gofsAdj, nmsesAdj, rmsesAdj, ...
    'VariableNames', {'Patch', 'GoF', 'NMSE', 'RMSE', 'AdjGoF', 'AdjNMSE', 'AdjRMSE'});

end
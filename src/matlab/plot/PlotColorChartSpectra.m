function [] = PlotColorChartSpectra(vals, curveNames, currentCase, ylimits, showsAverageLine, fig)

%% PlotColorChartSpectra plots single or multiple spectra at the same time
%     Input arguments
%     vals: spectra values with dimensions [number of points x number of wavelengths x number of methods]
%     [optional] curveNames: name of points to be plotted
%     [optional] currentCase: name of case to be plotted
%     [optional] ylimits: limits of the y axis
%     [optional] showsAverageLine: meaningful only for plotting spectra from multiple methods
%     [optional] fig: number of figure
%
%     Output
%     None

[n, m, l] = size(vals);

hideLegend = false;
if nargin < 2
    curveNames = cell(n, 1);
    hideLegend = true;
end

prefix = '';
if nargin < 3
    currentCase = 'raw';
else
    parts = strsplit(currentCase, '_');
    currentCase = parts{1};
    if length(parts) > 1
        prefix = strcat(char(join(parts(2:end), '_')), '_');
    end
end

if nargin < 4 || isempty(ylimits)
    ylimits = [0, 2];
end

hasMultiple = l ~= 1;

if nargin < 5 || isempty(showsAverageLine)
    showsAverageLine = hasMultiple;
end

%% Set titles etc
figName = strcat(prefix, currentCase);

hasReflectanceRatio = true;
switch currentCase
    case 'expected'
        figTitle = 'Standard Spectra for Color Patches from Babel Color';
        ylimits = [0, 1];
    case 'measured'
        figTitle = 'Measured Spectra';
    case 'measured-raw'
        figTitle = 'Raw Measured Spectra';
        hasReflectanceRatio = false;
    case 'measured-adjusted'
        figTitle = 'Measured Spectra after Adjustment';
        ylimits = [0, 1];
    case 'difference'
        figTitle = 'Difference for [Expected vs Measured] spectra';
        hasReflectanceRatio = false;
        ylimits = [-1, 1];
    case 'difference-adjusted'
        figTitle = 'Difference for [Expected vs Measured] after Adjustment';
        hasReflectanceRatio = false;
        ylimits = [-1, 1];
    case '1x1window'
    case '2x2window'
    case '3x3window'
        parts = strsplit(currentCase, 'x');
        windowDim = str2num(parts(1));
        sprintf('Spectra from random points of the white image %dx%d spatial smoothing', windowDim, windowDim)
        hasReflectanceRatio = false;
    otherwise
        error('Unsupported data name.');
end

if contains(currentCase, 'difference')
    ylab = 'Difference of Reflectance Spectra (a.u.)';
elseif hasReflectanceRatio
    ylab = 'Reflectance Spectrum (%)';
else
    ylab = 'Reflectance Spectrum (a.u.)';
end

plotColors = GetColorChartColors(curveNames);
if isempty(plotColors)
    colors = hsv(n+1);
    plotColors = colors(2:end, :);
end

if hasMultiple

    %% For multiple spectra from different methods
    x = GetWavelengths(m);

    %% Prepare Legend
    h = zeros(n, 1);

    for i = 1:n
        hold on;
        h(i) = plot(nan, nan, 'DisplayName', curveNames{i}, 'Color', plotColors(i, :), 'LineWidth', 0.5);
        hold off;
    end
    if showsAverageLine
        hold on;
        h(n+1) = plot(nan, nan, '--', 'DisplayName', 'Multiple Capture Average', 'Color', 'k', 'LineWidth', 1.5);
        hold off;
    end

    %% Plot Spectra
    for i = 1:n
        if hasMultiple
            for k = 1:size(vals, 3)
                spectrum = squeeze(vals(i, :, k));
                [spectrum, x] = AdjustTargetWavelengths(spectrum);
                hold on;
                plot(x, spectrum, 'Color', plotColors(i, :), 'LineWidth', 0.5);
                hold off;
            end
            if showsAverageLine
                spectrum = squeeze(mean(vals(i, :, :), 3));
                [spectrum, x] = AdjustTargetWavelengths(spectrum);
                hold on;
                plot(x, spectrum, '--', 'Color', plotColors(i, :), 'LineWidth', 1.5);
                hold off;
            end
        end
    end

else

    %% For spectra from same origin
    h = zeros(n, 1);
    for i = 1:n
        spectrum = AdjustTargetWavelengths(vals(i, :), 'del');
        x = GetWavelengths(length(spectrum));
        [spectrum, x] = AdjustTargetWavelengths(spectrum);
        hold on
        h(i) = plot(x, spectrum, 'DisplayName', curveNames{i}, 'Color', plotColors(i, :), 'LineWidth', 1.5);
        hold off;
    end
end

xlim([420, 730]);
ylim(ylimits);
if strcmp(currentCase, 'raw')
    yticks(0:0.001:0.005);
    xlim([380, 780]);
end

if hasReflectanceRatio
    yline(1, '--', '100%', 'LineWidth', 3, 'DisplayName', 'Max Value');
end

xlabel('Wavelength (nm)', 'FontSize', 15);
ylabel(ylab, 'FontSize', 15);
title(figTitle, 'FontSize', 15);
if ~hideLegend
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %         legend(h, 'Location', 'EastOutside');
    legend(h, 'Location', 'SouthEast');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set(gcf, 'units', 'normalized', 'outerposition', [0, 0, 1, 1]);

%%To disable showing exponent power on the corner
ax = gca;
ax.YAxis.Exponent = 0;

plotName = fullfile(GetSetting('savedir'), GetSetting('saveFolder'), strcat(figName, '.png'));

SetSetting('plotName', plotName);
SavePlot(fig);
end
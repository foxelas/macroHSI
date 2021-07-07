function [] = PlotSpectra(curves, names, wavelengths, yLabel, figTitle, colors, fig)
%PlotSpectra plots a collection of spectrum curves 
%
%   Usage: 
%   PlotSpectra(curves, names, wavelengths, yLabel, figTitle, fig)

[curveN, xN] = size(curves);

if nargin < 2 
    names = cell(curveN,1);
    for i = 1:curveN
        names{i} = 's' + num2str(i);
    end 
end 

if nargin < 3 
    wavelengths = getWavelengths(xN);
end 

if nargin < 4 
    yLabel = 'Measured reflectance (a.u.)';
end 

if nargin < 5 
    figTitle = '';
end

if nargin < 6
    lineColorMap = GetLineColorMap('custom', names); %'custom-hsv'
    key = keys(lineColorMap);
    colors = cell(curveN, 1);
    for i = 1:curveN
        colors{i} = lineColorMap(key{i});
    end
end


    
x = wavelengths; 
h = zeros(curveN,1);
for i = 1:curveN
    spectrum = curves(i,:);
    hold on
    h(i) = plot(x, spectrum, 'DisplayName', names{i}, 'Color', colors{i}, 'LineWidth', 1.5);
    hold off;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if hasReflectanceRatio 
%     yline(1,'--','100%','LineWidth',3, 'DisplayName', 'Max Value');
% end

xlabel('Wavelength (nm)', 'FontSize', 15);
ylabel(yLabel, 'FontSize', 15);
title(figTitle, 'FontSize', 15);
legend(h, 'Location', 'SouthEast');
xlim([min(wavelengths), max(wavelengths)]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     set(gcf, 'units','normalized','outerposition',[0 0 1 1]);

%%To disable showing exponent power on the corner
ax = gca;
ax.YAxis.Exponent = 0;

SavePlot(fig);

end 
function [] = PlotClusterCentroids(C, fig)
% PlotClusterCentroids plots the centroid clusters after clustering 
%
%   Usage:
%   Plots(2, @PlotClusterCentroids, C);

[q, w] = size(C);
x = GetWavelengths(w);
colors = jet(q);
hold on;
for i = 1:q
    plot(x, C(i, :), 'DisplayName', strcat('Centroid ', num2str(i)), 'LineWidth', 2, 'Color', colors(i,:));
end
hold off;
legend('Location', 'NorthWest');
xlabel('Wavelength (nm)');
ylabel('Centroid Spectrum');

SetSetting('plotName', fullfile(GetSetting('savedir'), GetSetting('experiment'), ...
    strcat('kmeans_', num2str(q), '_centroids.jpg')));

SavePlot(fig);

end 
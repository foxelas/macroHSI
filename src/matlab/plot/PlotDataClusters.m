function [] = PlotDataClusters(X, dimredMethod, labels, C, fig)
%PlotDataClusters shows a reduced dimension view of the dataset using
%specific lalbels and also cluster centroids when provided 
%
%   Usage:
%   Plots(1, @PlotDataClusters, X, 'tsne', labels, C);

q = length(unique(labels));

showsCentroids = ~(isempty(C) | strcmp(dimredMethod, 'tsne'));

[coeff, scores, ~] = TrainDimred(X, dimredMethod, 3, labels);

clusterColor = jet(q);

hold on;
for i = 1:q
    labId = labels == i;
    vals = scores(labId, :);
    scatter3(vals(:, 1), vals(:, 2), vals(:, 3), 'MarkerEdgeColor', 'k', 'MarkerFaceColor', clusterColor(i,:));
end

if showsCentroids
    for i = 1:q
        transC = C(i, :) * coeff;
        scatter3(transC(1), transC(2), transC(3), 30, 'k', 'd', 'filled');
        text(transC(1), transC(2), transC(3), strcat('C', num2str(i)))
    end
end 

hold off;
grid on;
view(40, 35);

SavePlot(fig);
end 
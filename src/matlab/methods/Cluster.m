function Cluster(imgList, method, q, hasMask)


[imgList, imgN] = CheckImageList(imgList);

if nargin < 2
    method = 'kmeans';
end

if nargin < 3
    q = 2;
end

if nargin < 4
    hasMask = true; %use all image samples or only specimen samples
end

rng default % For reproducibility

imgDims = cellfun(@(x) size(x), imgList, 'un', 0);
if ~hasMask % Uses all pixels in the image
    flatDims = cellfun(@(x) size(x, 1)*size(x, 2), imgList);
    endIdx = cumsum(flatDims);
    startIdx = [0, endIdx(1:end-1)] + 1;
    flattenedList = cellfun(@(x) reshape(x, [size(x, 1) * size(x, 2), size(x, 3)]), imgList, 'un', 0);
else % Uses only foreground pixels in the image
    maskList = cellfun(@(x) GetForegroundMask(x), imgList, 'un', 0);
    flatDims = cellfun(@(x) sum(x, 'all'), maskList);
    endIdx = cumsum(flatDims);
    startIdx = [0, endIdx(1:end-1)] + 1;
    flattenedList = cellfun(@(x) reshape(x, [size(x, 1) * size(x, 2), size(x, 3)]), imgList, 'un', 0);
    flattenedList = cellfun(@(x, y) x(reshape(y, [size(x, 1), 1]), :), flattenedList, maskList, 'un', 0);
end
X = cat(1, flattenedList{:});

switch method
    case 'kmeans'
        [idx, C] = kmeans(X, q);
    otherwise
        warning('Unsupported clustering method.')
end

%%%%%Result visualization
close all;

clusterNames = cellfun(@(x) num2str(x), num2cell(1:q), 'UniformOutput', false);

for i = 1:imgN
    labels = idx(startIdx(i):endIdx(i));
    if hasMask
        mask = maskList{i};
    else
        mask = [];
    end
    labelImg = RecoverReducedHsi(labels, imgDims{i}, mask);
    img = imgList{i};

    %% Overlay labels
    SetSetting('plotName', fullfile(GetSetting('savedir'), GetSetting('experiment'), strcat('kmeans_', num2str(q), '_', num2str(i), '.jpg')));
    Plots(1, @PlotOverlay, img, labelImg);

    %% Pring data clusters
    SetSetting('plotName', fullfile(GetSetting('savedir'), GetSetting('experiment'), strcat('kmeans_tsne', num2str(q), '_', num2str(i), '.jpg')));
    Plots(3, @PlotDataClusters, X(startIdx(i):endIdx(i), :), 'tsne', labels, C);
end

%% Print centroids
Plots(2, @PlotClusterCentroids, C)

end
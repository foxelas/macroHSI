function Cluster(imgList, method, q)


[imgList, imgN] = CheckImageList(imgList);

if nargin < 2 
    method = 'kmeans';
end 

if nargin < 3 
    q = 2;
end 

hasMask = true;
rng default % For reproducibility

imgDims = cellfun(@(x) size(x), imgList, 'un', 0);
if ~hasMask
    flatDims = cellfun(@(x) size(x,1) * size(x,2), imgList);
    endIdx = cumsum(flatDims);
    startIdx = [0, endIdx(1:end-1)] + 1;
    flattenedList = cellfun(@(x) reshape(x, [size(x,1)*size(x,2), size(x,3)]), imgList, 'un', 0);
else 
    maskList = cellfun(@(x) GetForegroundMask(x), imgList, 'un', 0);
    flatDims = cellfun(@(x) sum(x, 'all'), maskList);
    endIdx = cumsum(flatDims);
    startIdx = [0, endIdx(1:end-1)] + 1;
    flattenedList = cellfun(@(x) reshape(x, [size(x,1)*size(x,2), size(x,3)]), imgList, 'un', 0);
    flattenedList = cellfun(@(x, y) x(reshape(y, [size(x,1), 1]), :), flattenedList, maskList, 'un', 0);
end 
X = cat(1,flattenedList{:});

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
    B = labeloverlay(GetDisplayImage(img), labelImg, 'Colormap', 'jet');
    figure(1); 
    imshow(B);
    SetSetting('plotName', fullfile(GetSetting('savedir'), GetSetting('experiment'), strcat('kmeans_', num2str(q), '_', num2str(i), '.jpg')));
    SavePlot(1);
end 

%% Print centroids
figure(2);
w = GetWavelengths(size(C,2));
colors = jet(q);
hold on;
for i = 1:q
    plot(w, C(i, :), 'DisplayName', strcat('Centroid ', num2str(i)), 'LineWidth', 2, 'Color', colors(i,:));
end
hold off;
legend('Location', 'NorthWest');
xlabel('Wavelength (nm)');
ylabel('Centroid Spectrum');
SetSetting('plotName', fullfile(GetSetting('savedir'), GetSetting('experiment'), strcat('kmeans_', num2str(q), '_centroids.jpg')));
SavePlot(2);

end 
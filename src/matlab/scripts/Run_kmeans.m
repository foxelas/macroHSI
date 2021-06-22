
%% Clustering

q = 2;
rng(1); % For reproducibility
[idx, C] = kmeans(X, q);

hasMask = size(X, 1) ~= (size(norm1, 1) * size(norm1, 2) + size(norm2, 1) * size(norm2, 2));
if ~hasMask
    splitIndex = size(norm1, 1) * size(norm1, 2);
else
    splitIndex = size(maskedPixels1, 1);
end
labels = zeros(size(X, 1), 1);
labels(1:splitIndex) = 1; %tissue1 label 1, tissue 2 label 0

redHsi1 = idx(1:splitIndex, :);
redHsi2 = idx((splitIndex + 1):end, :);
if hasMask
    [redHsi1] = RecoverReducedHsi(redHsi1, size(norm1), mask1);
    [redHsi2] = RecoverReducedHsi(redHsi2, size(norm2), mask2);
else
    [redHsi1] = RecoverReducedHsi(redHsi1, size(norm1));
    [redHsi2] = RecoverReducedHsi(redHsi2, size(norm2));
end

%% Overlay labels
B = labeloverlay(GetDisplayImage(raw1), redHsi1);
figure;
imshow(B);
B = labeloverlay(GetDisplayImage(raw2), redHsi2);
figure;
imshow(B);

%% Print centroids
figure(1);
hold on;
for i = 1:q
    plot(w, C(i, :)*0.93, 'DisplayName', strcat('Centroid ', num2str(i)), 'LineWidth', 2)
end
legend();
xlabel('Wavelength (nm)');
ylabel('Centroid Spectrum');

%% Plot in 3d Plot
%tsne for representation
% [scores, loss] = tsne(X,'Algorithm','barneshut','NumPCAComponents',50, 'NumDimensions',3, 'NumPrint',2, 'Verbose', 1);

% %rica for representation
% rng default % For reproducibility
% Mdl = rica(X,3,'IterationLimit',100, 'Lambda', 1);
% coeff = Mdl.TransformWeights;
% scores = X * coeff;

%pca for representation
%[coeff, scores, ~, ~, ~] = pca(X, 'NumComponents', 3);

clusterColor = {'b', 'r', 'g', 'm', 'y'};
figure(1);
clf;
hold on;
for i = 1:q
    labId = idx == i;
    trueLabel = labels(labId);
    vals = scores(labId, :);
    tissue1 = vals(trueLabel == 1, :);
    tissue2 = vals(trueLabel == 0, :);
    scatter3(tissue1(:, 1), tissue1(:, 2), tissue1(:, 3), strcat(clusterColor{i}));
    scatter3(tissue2(:, 1), tissue2(:, 2), tissue2(:, 3), strcat(clusterColor{i}));
end
for i = 1:q
    transC = C(i, :) * coeff;
    scatter3(transC(1), transC(2), transC(3), 30, 'k', 'd', 'filled');
    text(transC(1), transC(2), transC(3), strcat('C', num2str(i)))
end
hold off;
view(40, 35)

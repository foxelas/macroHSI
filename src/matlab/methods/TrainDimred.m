function [coeff, scores, ds] = TrainDimred(X, method, q, labels)
%TrainDimred reduces the dimensions of a dataset
%
%   Input arguments
%   X: input data as a matrix with M observations and N columns
%   methods: 'rica', 'pca'
%   q: number of components to be retained
%   [Optional] labels: in case of supervised method
%
%   Return arguments
%   coeff: the transformation matrix (for linear cases)
%   scores: the transformed feature vectors
%   ds: a struct with all relevant outputs depending on the
%   dimension reduction method
%
%   Usage:
%   [coeff, scores, ds] = TrainDimred(X, method, q)
%   [coeff, scores, ds] = TrainDimred(X, 'pca', 10); result.Explained;
%   [coeff, scores, ds] = TrainDimred(X, 'rica', 40); result.Objective;
%

if nargin < 3
    q = 10;
end

if nargin < 4
    labels = [];
end

rng default % For reproducibility

switch method
    case 'pca'

        %% PCA
        [coeff, scores, latent, tsquared, explained] = pca(X, 'NumComponents', q);
        ds = struct('Method', 'pca', 'Transform', coeff, 'Latent', latent, 'Tsquared', tsquared, 'Explained', explained, 'RetainedNum', q);

    case 'rica'

        %% RICA
        Mdl = rica(X, q, 'IterationLimit', 100, 'Lambda', 1);
        coeff = Mdl.TransformWeights;
        scores = transform(Mdl, X); %X * coeff;
        objective = Mdl.FitInfo.Objective;
        ds = struct('Method', 'rica', 'Transform', coeff, 'RetainedNum', q, 'Objective', objective, 'Model', Mdl);

    case 'sf'

        %% SF: sparse filtering feature extraction
        Mdl = sparsefilt(X, q, 'IterationLimit', 100, 'Standardize', false);
        coeff = Mdl.TransformWeights;
        scores = transform(Mdl, X); %X * coeff;
        fitInfo = Mdl.FitInfo;
        ds = struct('Method', 'sf', 'Transform', coeff, 'RetainedNum', q, 'FitInfo', fitInfo, 'Model', Mdl);

    case 'lda'

        %% LDA
        Mdl = fitcdiscr(X, labels, 'ClassNames', unique(labels), 'DiscrimType', 'linear', 'OptimizeHyperparameters', 'auto', ...
            'HyperparameterOptimizationOptions', struct('AcquisitionFunctionName', 'expected-improvement-plus'));
        coeff = Mdl.Coeffs;
        scores = X * coeff;
        ds = struct('Method', 'lda', 'Transform', coeff, 'RetainedNum', q, 'Model', Mdl);

    case 'qda'

        %% QDA
        Mdl = fitcdiscr(X, labels, 'ClassNames', unique(labels), 'DiscrimType', 'quadratic', 'OptimizeHyperparameters', 'auto', ...
            'HyperparameterOptimizationOptions', struct('AcquisitionFunctionName', 'expected-improvement-plus'));
        coeff = Mdl.Coeffs;
        scores = X * coeff;
        ds = struct('Method', 'qda', 'Transform', coeff, 'RetainedNum', q, 'Model', Mdl);

    case 'tsne'

        %% TSNE
        coeff = [];
        [scores, loss] = tsne(X, 'Algorithm', 'barneshut', 'NumPCAComponents', 50, 'NumDimensions', q, 'NumPrint', 2, 'Verbose', 1);
        ds = struct('Method', 'tsne', 'Loss', loss, 'RetainedNum', q, 'Algorithm', 'barneshut', 'NumPCAComponents', 50);

        %% Otherwise
    otherwise
        warning('Unsupported dimension reduction method');
end


end

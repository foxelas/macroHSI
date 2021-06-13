%% Read data 
hasRead = false;
if hasRead 
    load('D:\elena\mspi\matfiles\hsi\calibTriplets\94_white.mat')
    load('D:\elena\mspi\matfiles\hsi\calibTriplets\94_black.mat')
    load('D:\elena\mspi\matfiles\hsi\calibTriplets\94_target.mat')
    norm1= (spectralData - blackReflectance) ./ (fullReflectanceByPixel - blackReflectance + 0.0000001);
    flt1 = reshape(norm1, [size(norm1,1)* size(norm1,2), size(norm1, 3)]);

    load('D:\elena\mspi\matfiles\hsi\calibTriplets\67_white.mat')
    load('D:\elena\mspi\matfiles\hsi\calibTriplets\67_black.mat')
    load('D:\elena\mspi\matfiles\hsi\calibTriplets\67_target.mat')
    norm2 = (spectralData - blackReflectance) ./ (fullReflectanceByPixel - blackReflectance + 0.0000001);
    flt2 = reshape(norm2, [size(norm2,1)* size(norm2,2), size(norm2, 3)]);

    [mask2, maskedPixels2] = GetMaskFromFigure(norm2);
    save('norm2_goodPixels.mat', 'norm2', 'mask2', 'maskedPixels2');

    [mask1, maskedPixels1] = GetMaskFromFigure(norm1);
    save('norm1_goodPixels.mat', 'norm1', 'mask1', 'maskedPixels1', '-v7.3');
    flt = [maskedPixels1; maskedPixels2];
    
    Xraw401 = [flt1; flt2];
    Xmask401 = flt;
    w = [420:730];
    Xraw = Xraw401(:, w - 380 + 1);
    Xmask = X401(:, w - 380 + 1);
end 


%% Select methods, dataset 
method = 'rica'; %'pca', 'rica'
X = Xmask; 

%% PCA 
if strcmp(method, 'pca')
    [coeff, score, latent, tsquared, explained] = pca(X, 'NumComponents', 10, 'Algorithm', 'eig');

    figure; plot(explained(1:10)); title('Explained Variance');  xlabel('Order'); ylabel('Explained Variance');

    figure; plot(latent(1:10)); title('Eigenvalues');  xlabel('Order'); ylabel('Eigenvalue');

    figure;hold on; plot(w , coeff(:,1), 'DisplayName', 'Eig1')
    plot(w, coeff(:,2), 'DisplayName', 'Eig2')
    plot(w , coeff(:,3), 'DisplayName', 'Eig3')
    hold off;
    title('Eigenvectors');
    xlabel('Spectrum');
    ylabel('Coefficient');
    xlim([380, 780]); 
    legend()
end 

%% RICA
if strcmp(method, 'rica')
    rng default % For reproducibility
    q = 40;
    Mdl = rica(X,q,'IterationLimit',100); 
    coeff = Mdl.TransformWeights; 
    scores = X * coeff;
    
    curdir = 'python\ica';
    folder = 'exp3_norm_cropped'; %'exp1_raw_full';
    saveto = fullfile(GetSetting('savedir'), curdir, folder);
    DirMake(saveto);
    
    fig = figure(1); clf(fig);
    plot(Mdl.FitInfo.Iteration, Mdl.FitInfo.Objective); 
    xlabel('iterations'); 
    ylabel('Objection function value'); 
    title('Minimization progress')
    SetSetting('plotName', fullfile(saveto, 'minimize'));
    SavePlot(1);
    
    hasMask = size(X, 1) ~= (size(norm1,1) * size(norm1, 2) + size(norm2,1) * size(norm2, 2));
    if ~hasMask
        splitIndex = size(norm1,1) * size(norm1, 2);
    else 
        splitIndex = size(maskedPixels1,1);
    end 
    redHsi1 = scores(1:splitIndex, :);
    redHsi2 = scores((splitIndex + 1):end, :);
    
    if hasMask
        [redHsi1] = RecoverReducedHsi(redHsi1, size(norm1), mask1);
        [redHsi2] = RecoverReducedHsi(redHsi2, size(norm2), mask2);
    else
        [redHsi1] = RecoverReducedHsi(redHsi1, size(norm1));
        [redHsi2] = RecoverReducedHsi(redHsi2, size(norm2));
    end 
    SetSetting('plotName', fullfile(saveto, 'img1_pcs'));
    Plots(1, @PlotSubimageMontage, redHsi1, 'Tissue1', 6);
    SetSetting('plotName', fullfile(saveto, 'img2_pcs'));
    Plots(2, @PlotSubimageMontage, redHsi2, 'Tissue2', 6);
    
    
end 

   
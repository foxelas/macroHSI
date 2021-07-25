function spectralData = NormalizeHSI(targetName, option)
%NormalizeHSI returns spectral data from HSI image
%
%   Usage:
%   spectralData = NormalizeHSI('sample2',) returns a
%   cropped HSI with 'byPixel' normalization
%
%   spectralData = NormalizeHSI('sample2', 'raw')
%

if nargin < 2 || isempty(option)
    option = GetSetting('normalization');
end

basedir = strcat(GetMatSaveFolder('Triplets'), targetName);

targetFilename = strcat(basedir, '_target.mat');
load(targetFilename, 'spectralData');
[m, n, w] = size(spectralData);

whiteFilename = strcat(basedir, '_white.mat');

useBlack = true;
if useBlack && ~strcmp(option, 'raw')
    blackFilename = strcat(basedir, '_black.mat');
    load(blackFilename, 'blackReflectance');
end

switch option
    case 'raw'
        %do nothing
        useBlack = false;

    case 'byPixel'
        load(whiteFilename, 'fullReflectanceByPixel');
        whiteReflectance = fullReflectanceByPixel;
        clear 'fullReflectanceByPixel';

    case 'uniSpectrum'
        load(whiteFilename, 'uniSpectrum');
        whiteReflectance = reshape(repmat(uniSpectrum, m*n, 1), m, n, w);

    case 'bandmax'
        load(whiteFilename, 'bandmaxSpectrum');
        whiteReflectance = reshape(repmat(bandmaxSpectrum, m*n, 1), m, n, w);

    case 'forExternalNormalization'
        useBlack = false;
        spectralData = (spectralData - blackReflectance);

    otherwise
        error('Unsupported setting for normalization.');
end

%%%%Checks for size discrepancies
if useBlack
    if ~isequal(size(spectralData), size(blackReflectance))
        cropMask = getCaptureROImask(m, n);
        blackReflectance = blackReflectance(any(cropMask, 2), any(cropMask, 1), :);
        warning('Crop the image value: black');
    end
    if ~isequal(size(spectralData), size(whiteReflectance))
        cropMask = getCaptureROImask(m, n);
        whiteReflectance = whiteReflectance(any(cropMask, 2), any(cropMask, 1), :);
        warning('Crop the image value: white');
    end
    
    %% Cleanup wrong spectral values before normalization 
    spectralData = max(spectralData, 0);

%     spectralDataRow = reshape(spectralData, [m*n, w]);
%     maxSpectrum = max(reshape(whiteReflectance, [m*n, w]), [], 1);
%     maxSpectrum = min(maxSpectrum, 2* 0.001);
%     spectralDataRow = min(spectralDataRow, maxSpectrum);
%     spectralData = reshape(spectralDataRow, [m, n, w]);

    %% Normalization
    spectralData = NormalizeImage(spectralData, whiteReflectance, blackReflectance);
    spectralData = min(spectralData, 2);
    
    %% Further check 
    spectralData = max(spectralData, 0);
    
    %% Crop usable dimensions 
    if strcmp(option, 'byPixel')
        spectralData = AdjustRange(spectralData);
    end   

end


% figure(4);imshow(squeeze(spectralData(:,:,100)));

end

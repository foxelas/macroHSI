function [outSpectra] = AdjustRange(inSpectra, options)
%AdjustRange crops the spectral range with AdjustTargetWavelengths for
%multiple spectra at the same time
%
%   Usage:
%   outSpectra = AdjustRange(inSpectra)

if nargin < 2
    options = 'crop';
end

if ndims(inSpectra) < 3
    for i = 1:size(inSpectra, 1)
        inSpectrum = inSpectra(i, :);
        outSpectra(i, :) = AdjustTargetWavelengths(inSpectrum, options);
    end
else
    [m, n, w] = size(inSpectra);
    colSpec = reshape(inSpectra, [m * n, w]);
    cropColSpec = ApplyRowFunc(@AdjustTargetWavelengths, colSpec, 'crop');
    outSpectra = reshape(cropColSpec, [m, n, size(cropColSpec, 2)]);
end
end
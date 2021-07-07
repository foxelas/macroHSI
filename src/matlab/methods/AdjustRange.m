function [outSpectra] = AdjustRange(inSpectra, options)
%AdjustRange crops the spectral range with AdjustTargetWavelengths for
%multiple spectra at the same time 
%
%   Usage:
%   outSpectra = AdjustRange(inSpectra)
    
    if nargin < 2 
        options = 'crop';
    end
    
    for i = 1:size(inSpectra,1)
        inSpectrum = inSpectra(i,:);
        outSpectra(i,:) = AdjustTargetWavelengths(inSpectrum, options);
    end 
end 
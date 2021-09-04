function [outSpectrum, newWavelengths] = AdjustTargetWavelengths(inSpectrum, options)
%AdjustTargetWavelengths adds the target wavelengths of the spectrum
% like pad, crop or decimate
%
%   Usage:
%   [outSpectrum, newWavelengths] = AdjustTargetWavelengths(inSpectrum, 'add') adds padding to inSpectrum
%   [outSpectrum, newWavelengths] = AdjustTargetWavelengths(inSpectrum, 'del') removes padding from inSpectrum
%   [outSpectrum, newWavelengths] = AdjustTargetWavelengths(inSpectrum, 'crop') crops to range 420:730nm
%   [outSpectrum, newWavelengths] = AdjustTargetWavelengths(inSpectrum, 'standard') crops to 36 wavelengths


if nargin < 2
    options = 'crop';
end

m = length(inSpectrum);
newWavelengths = GetWavelengths(m);

switch options
    case 'add'
        x = GetWavelengths(m, 'index');
        if m > 100
            outSpectrum = zeros(401, 1);
        else
            outSpectrum = zeros(36, 1);
        end
        outSpectrum(x) = inSpectrum;

    case 'del'
        isPadded = true;
        if m == 36
            cutoff = 15;
        elseif m == 401
            cutoff = 150;
        else
            isPadded = false;
        end

        if isPadded && isempty(nonzeros(inSpectrum(1:cutoff)))
            idStart = find(inSpectrum, 1);
            outSpectrum = inSpectrum(idStart:end);

        elseif isPadded && isempty(nonzeros(inSpectrum((end -cutoff):end)))
            idEnd = find(inSpectrum, 1, 'last');
            outSpectrum = inSpectrum(1:idEnd);

        else
            outSpectrum = inSpectrum;
        end
        newWavelengths = GetWavelengths(401);

    case 'crop'
        x = GetWavelengths(m);
        ids = x >= 420 & x <= 730;
        newWavelengths = x(ids);
        outSpectrum = inSpectrum(ids);

    case 'standard'
        spectralWavelengths = 380:10:730;
        x = GetWavelengths(m);
        [~, idx] = ismember(spectralWavelengths', x);
        idx = nonzeros(idx);
        outSpectrum = inSpectrum(idx);
        newWavelengths = spectralWavelengths;

    otherwise
        error('Unsupported options');
end
end
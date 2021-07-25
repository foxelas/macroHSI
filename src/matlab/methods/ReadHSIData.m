function [spectralData] = ReadHSIData(content, target, blackIsCapOn)
%%ReadHSIData returns the three images necessary for data analysis
%
%   Usage:
%   [raw] = ReadHSIData(target, experiment, blackIsCapOn)

if nargin < 4
    blackIsCapOn = false;
end

basedir = GetMatSaveFolder('Triplets');

%% Target image
fcTarget = GetFileConditions(content, target);
[filename, tableId] = GetFilename(fcTarget{:});
saveName = fullfile(basedir, num2str(tableId));
[spectralData, ~, ~] = LoadH5Data(filename);
saveFolder = num2str(tableId); 

if ~exist(strcat(saveName, '_target.mat'), 'file') || ~exist(strcat(saveName, '_black.mat'), 'file') || ~exist(strcat(saveName, '_white.mat'), 'file')
    figure(1);
    imshow(GetDisplayImage(spectralData, 'rgb'));
    SetSetting('plotName', DirMake(GetSetting('savedir'), GetSetting('experiment'), saveFolder, strcat(target, '_', num2str(GetSetting('integrationTime')))));
    SavePlot(1);
    save(strcat(saveName, '_target.mat'), 'spectralData', '-v7.3');

    if ~strcmp(GetSetting('normalization'), 'raw')

        %% White image
        fcWhite = GetFileConditions(GetSetting('whiteContent'), target);
        fcWhite = [fcWhite, -1, 'white'];
        filename = GetFilename(fcWhite{:});
        [white, ~, wavelengths] = LoadH5Data(filename);
        figure(2);
        imshow(GetDisplayImage(white, 'rgb'));
        SetSetting('plotName', DirMake(GetSetting('savedir'), GetSetting('experiment'), saveFolder, strcat('0_white_', num2str(GetSetting('integrationTime')))));
        SavePlot(2);

        %%UniSpectrum
        uniSpectrum = GetSpectraFromMask(white);
        SetSetting('plotName', DirMake(GetSetting('savedir'), GetSetting('experiment'), saveFolder, strcat('0_white_unispectrum_', num2str(GetSetting('integrationTime')))));
        Plots(4, @PlotSpectra, uniSpectrum, {'99%-white'}, wavelengths,  'Spetral Measurement (a.u.)', 'Reflectance Spectrum of White Balance Sheet', {'b'});

        %%BandMax
        [m, n, w] = size(white);
        bandmaxSpectrum = max(reshape(white, m*n, w), [], 1);
        SetSetting('plotName', DirMake(GetSetting('savedir'), GetSetting('experiment'), saveFolder, strcat('0_white_bandmax_', num2str(GetSetting('integrationTime')))));
        Plots(5, @PlotSpectra, bandmaxSpectrum, {'Bandmax spectrum'}, wavelengths, 'Spetral Measurement (a.u.)', 'Bandmax Spectrum for the current Image', {'b'});

        fullReflectanceByPixel = white;
        save(strcat(saveName, '_white.mat'), 'fullReflectanceByPixel', 'uniSpectrum', 'bandmaxSpectrum', '-v7.3');

        %% Black Image
        if blackIsCapOn
            fcBlack = GetFileConditions('capOn', target);
        else
            fcBlack = GetFileConditions(GetSetting('blackContent'), target); % 'lightsOff'
        end
        fcBlack = [fcBlack, -1, 'black'];
        filename = GetFilename(fcBlack{:});
        [blackReflectance, ~, ~] = LoadH5Data(filename);
        figure(3);
        imshow(GetDisplayImage(blackReflectance, 'rgb'));
        SetSetting('plotName', DirMake(GetSetting('savedir'), GetSetting('experiment'), saveFolder, strcat('0_black_', num2str(GetSetting('integrationTime')))));
        SavePlot(3);

        save(strcat(saveName, '_black.mat'), 'blackReflectance', '-v7.3');
    else
        disp('Read only capture data, ignore white and black images.');
    end
end

end
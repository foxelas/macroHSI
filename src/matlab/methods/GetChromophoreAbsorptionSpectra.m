function [extCoeffEumelanin2, extCoeffHbO, extCoeffHbR] = GetChromophoreAbsorptionSpectra()
%%GETCHROMOPHOREABSORPTIONSPECTRA reutrns spectra for the main skin
%   chromophores 
%
%   Usage:
%   [extCoeffEumelanin2, extCoeffHbO, extCoeffHbR] = GetChromophoreAbsorptionSpectra();

    webdir = GetSetting('webdir');
    eumelaninFilename = 'eumelanin_absroption.csv';
    hbFilename = 'hb_absorption_spectra_prahl.csv';
    eumelaninData = delimread(fullfile(webdir, eumelaninFilename), ',', 'num');
    eumelaninData = eumelaninData.num;
    hbData = delimread(fullfile(webdir, hbFilename), ',', 'num');
    hbData = hbData.num;

    eumelaninLambda = eumelaninData(:, 1);
    % extCoeffEumelanin1 = eumelaninData(:, 2);
    extCoeffEumelanin2 = eumelaninData(:, 3);

    % hbAmount = 150; %   A typical value of x for whole blood is x=150 g Hb/liter.
    % convertHbfun = @(x) 2.303 * hbAmount * x / 64500;
    hbLambda = hbData(:, 1);
    extCoeffHbO = hbData(:, 2);
    extCoeffHbR = hbData(:, 3);
    % absCoeffHbO = convertHbfun(extCoeffHbO);
    % absCoeffHbR = convertHbfun(extCoeffHbR);

    fig = figure(1);
    clf;
    hold on;
    %plot(eumelaninLambda, extCoeffEumelanin1, 'DisplayName', 'Eumelanin1', 'LineWidth', 2); %cm-1 / (mg/ml)
    plot(eumelaninLambda, extCoeffEumelanin2, 'DisplayName', 'Eumelanin', 'LineWidth', 2); %cm-1 / (moles/liter)
    plot(hbLambda, extCoeffHbO, 'DisplayName', 'HbO', 'LineWidth', 2); %cm-1/M
    plot(hbLambda, extCoeffHbR, 'DisplayName', 'HbR', 'LineWidth', 2); %cm-1/M
    hold off
    xlim([300, 800]);
    xlabel('Wavelength (nm)', 'FontSize', 15);
    ylabel('Extinction Coefficient (cm^{-1}/ M)', 'FontSize', 15);
    l = legend('Location', 'northeastoutside');
    l.FontSize = 13;

    set(gca, 'yscale', 'log');
    %set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0, 1, 1]);

    saveEps = getSetting('saveEps');
    SetSetting('saveEps', true);
    SetSetting('plotName', fullfile(GetSetting('savedir'), getSetting('common'), 'skinChromophoreExtinctionCoeff'));
    SavePlot(fig);
%     SetSetting('saveEps', saveEps);

    save('parameters\extinctionCoefficients.mat', 'extCoeffEumelanin2', 'extCoeffHbO', 'extCoeffHbR', 'eumelaninLambda', 'hbLambda');

end
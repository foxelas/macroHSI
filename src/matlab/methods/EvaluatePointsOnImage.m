function [] = EvaluatePointsOnImage(imgList, coordinates, descriptionList, isNormalized)
% EvaluatePointsOnImage shows different spectra on the image
%
%   Usage:
%   EvaluatePointsOnImage({i1, i2}, [50, 50; 200, 200], {'Raw - 4000ms', 'Raw
%   - 618 ms'}, true);

[imgList, imgN] = CheckImageList(imgList);

i1 = imgList{1};
if isNormalized
    w = 311;
else
    w = size(i1, 3);
end

if numel(descriptionList) ~= size(coordinates, 1)
    warning('Missing names or coordinates');
end
curvesN = size(coordinates, 1);
basedir = fullfile(GetSetting('savedir'), GetSetting('experiment'), 'InitialAnalysis');
figure(1);
imshow(rescale(GetDisplayImage(i1, 'no-bg')));
lineColorMap = GetLineColorMap('custom', cell(curvesN, 1)); %'custom-hsv'

hold on;
for i = 1:size(coordinates, 1)
    plot(coordinates(i, 2), coordinates(i, 1), 'x', 'MarkerSize', 20, 'color', lineColorMap(num2str(i)), 'LineWidth', 5);
end
hold off;
SetSetting('plotName', fullfile(basedir, 'pointsOnImage.jpn'));
SavePlot(1);

curves = zeros(curvesN*imgN, w);
names = cell(curvesN*imgN, 1);
colors = cell(curvesN*imgN, 1);

k = 0;
for j = 1:imgN
    img = imgList{j};
    for i = 1:curvesN
        k = k + 1;
        if isNormalized
            curves(k, :) = AdjustRange(img(coordinates(i, 1), coordinates(i, 2), :), 'crop');
        else
            curves(k, :) = img(coordinates(i, 1), coordinates(i, 2), :);
        end
        names{k} = strrep(descriptionList{i}, '-', strcat(num2str(j), ' -'));
    end
end
lineColorMap = GetLineColorMap('custom', names); %'custom-hsv'

k = 0;
for j = 1:imgN
    img = imgList{j};
    for i = 1:curvesN
        k = k + 1;
        if imgN ~= 1
            colors(k) = lineColorMap(names{j});
        else
            colors{k} = lineColorMap(names{i});
        end
    end
end


if isNormalized
    SetSetting('plotName', fullfile(basedir, 'sampleCurves_norm.jpn'));
    Plots(2, @PlotSpectra, curves, names, GetWavelengths(311), 'Reflectance', 'Normalized Measurements', colors);
else
    SetSetting('plotName', fullfile(basedir, 'sampleCurves_raw.jpn'));
    Plots(2, @PlotSpectra, curves, names, GetWavelengths(401), 'Measurement', 'Raw Measurements', colors);
end

end
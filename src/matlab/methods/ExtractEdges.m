function [edges] = ExtractEdges(img, keptEdges)
% ExtractEdges returns the edges of sectionImg
%
%   Usage:
%   edges = ExtractEdges(sectionImg, 'top');

if nargin < 2
    keptEdges = 'top';
end

grayImg = im2double(rgb2gray(img));

%% With Hugh transform
% Parameters
minLength = 40; % 10
fillGap = 8; %5
thresholdCoeff = 0.3; %0.3
numPeaks = 8; %5
edgeMethod = 'canny';
theta = [-90:0.5:-80, 80:0.5:89];

BW = edge(grayImg, edgeMethod);
figure(1);
imshow(BW);

[H, theta, rho] = hough(BW, 'Theta', theta);
figure(2);
imshow(imadjust(rescale(H)), [], ...
    'XData', theta, ...
    'YData', rho, ...
    'InitialMagnification', 'fit');
xlabel('\theta (degrees)')
ylabel('\rho')
axis on
axis normal
hold on
colormap(gca, hot)
P = houghpeaks(H, numPeaks, 'threshold', ceil(thresholdCoeff*max(H(:))), 'Theta', theta);
x = theta(P(:, 2));
y = rho(P(:, 1));
plot(x, y, 's', 'color', 'black');
lines = houghlines(BW, theta, rho, P, 'FillGap', fillGap, 'MinLength', minLength);
hold off;

figure(3), imshow(grayImg), hold on
max_len = 0;
lengths = zeros(length(lines), 1);
for k = 1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
    plot(xy(:, 1), xy(:, 2), 'LineWidth', 2, 'Color', 'green');

    % Plot beginnings and ends of lines
    plot(xy(1, 1), xy(1, 2), 'x', 'LineWidth', 2, 'Color', 'yellow');
    plot(xy(2, 1), xy(2, 2), 'x', 'LineWidth', 2, 'Color', 'red');

    % Determine the endpoints of the longest line segment
    len = norm(lines(k).point1-lines(k).point2);
    lengths(k) = len;
    if (len > max_len)
        max_len = len;
        xy_long = xy;
    end
end
% highlight the longest line segment
plot(xy_long(:, 1), xy_long(:, 2), 'LineWidth', 2, 'Color', 'red');
hold off;


% % sort lines by order of length
% [~, sortId] = sort(lengths);
% linesSorted = lines(sortId);
% for k=1:3
%     initPos = flip(lines(k).point1);
%     [P, J] = RegionGrowing(1, grayImg, initPos, 30);
% end

% Draw line mask
lineMask = false(size(grayImg));
for k = 1:length(lines)
    initPos = (lines(k).point1);
    lastPos = (lines(k).point2);
    %hLine = imline(gca, initPos,lastPos);
    hLine = drawline('Position', [initPos(1), initPos(2); lastPos(1), lastPos(2)]);
    lineMask = lineMask | hLine.createMask();
end
figure(4);
imshow(lineMask);

% watershed transform
D = -bwdist(~BW);
L = watershed(D);
figure(5);
imshow(label2rgb(L, 'jet', 'w'));
linePoints = L(lineMask);

a = [unique(linePoints); max(linePoints)];
counts = [a(1:end-1), histcounts(linePoints(:), a)'];
segThres = 0.05 * length(linePoints);
acceptedSegsId = counts(:, 2) > segThres & counts(:, 1) > 0;
acceptedSegsLabel = counts(acceptedSegsId, 1);
maskWatershed = false(size(grayImg));
for i = 1:length(acceptedSegsLabel)
    maskWatershed = maskWatershed | (L == acceptedSegsLabel(i));
end
figure(6);
imshow(maskWatershed);
mask = maskWatershed & lineMask;

figure(7);
imshow(mask);

edges = lines;
end
function ExtractGroundTruth(sampleId)

%   ExtractGroundTruth('001')

infoStruct = GetSampleAssosiatedInfo(sampleId);

SetSetting('normalization', 'byPixel');

targetId = num2str(infoStruct.RawHSIID); % raw surface
raw = NormalizeHSI(targetId);
front = LoadMacroRGB(infoStruct.FrontMacroID, 'front');
cut = LoadMacroRGB(infoStruct.CutMacroID, 'cut');
section = LoadMacroRGB(infoStruct.SectionMacroID, 'section');

% Register ex-vivo raw HSI to front-face RGB
Register(front, raw, 'front2hsi');

% Register front RGB to cut RGB
Register(front, cut, 'cut2front');

% Register cut RGB to section RGB
Register(cut, section, 'section2cut');

I2 = rgb2gray(section);
level = 0.4;
BW = im2bw(I2, level);
D = -bwdist(~BW);
D(~BW) = -Inf;
L = watershed(D);
figure;
imshow(label2rgb(L, 'jet', 'w'));
mask = L > 1;
figure;
imshow(mask);
v = imclose(mask, strel('disk', 1));
figure;
imshow(v);
d = edge(v, 'Canny');
figure;
imshow(d);

end
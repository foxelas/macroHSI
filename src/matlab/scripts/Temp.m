experiment = 'test2020628';
dataDate = '20210628';
ImportTriplets(dataDate);
SetSetting('experiment', experiment);

imgList = {i1, i2};
coordinates = [400,300; 200, 150];
descriptionList = {'Raw - 4000ms', 'Raw - 618ms'};
isNormalized = false; 
EvaluatePointsOnImage(imgList, coordinates, descriptionList, isNormalized);

imgList = {i1./w1, i2./w2};
descriptionList = {'Normalized - 4000ms', 'Normalized - 618ms'};
EvaluatePointsOnImage(imgList, coordinates, descriptionList, isNormalized); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SetSetting('integrationTime', 618);
SetSetting('dataDate', dataDate);
SetSetting('isRotated', false);
SetSetting('experiment', 'testCalibration');
SetSetting('colorPatchOrder', 'redRight');
targetName = 'colorchart';
allowRoiSelection = true;
[T, measuredSpectra, adjustedSpectra, alphaCoeff] = EvaluateColorchart(targetName,allowRoiSelection);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SetSetting('normalization', 'raw');
i1 = NormalizeHSI(num2str(132));

imgList = {i1};
coordinates = [350,300; 200,150];
descriptionList = {'P1', 'P2'};
isNormalized = false; 
EvaluatePointsOnImage(imgList, coordinates, descriptionList, isNormalized);

SetSetting('normalization', 'byPixel');
norm1 = NormalizeHSI(num2str(132));
imgList = {norm1};
descriptionList = {'P1', 'P2'};
isNormalized = true;
EvaluatePointsOnImage(imgList, coordinates, descriptionList, isNormalized); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Import Data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ImportTriplets('20210706');
ImportMacroRGB()
experiment = 'sample001';
SetSetting('experiment', experiment);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

targetId = num2str(147);  % raw backside
SetSetting('normalization', 'raw');
i1 = NormalizeHSI(targetId);

imgList = {i1};
coordinates = [ 84, 103; 127, 87; 95, 138; 104, 167];
descriptionList = {'P1', 'P2', 'P3', 'P4'};
isNormalized = false; 
EvaluatePointsOnImage(imgList, coordinates, descriptionList, isNormalized);

SetSetting('normalization', 'byPixel');
norm1 = NormalizeHSI(targetId);
imgList = {norm1};
isNormalized = true;
EvaluatePointsOnImage(imgList, coordinates, descriptionList, isNormalized); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

targetId = num2str(150);   % raw surface
SetSetting('normalization', 'raw');
i1 = NormalizeHSI(targetId);

imgList = {i1};
coordinates = [ 41, 51; 137, 72; 57, 99; 84,103; 118, 119];
descriptionList = {'Blood', 'Pigmented', 'Nonpigmented', 'Bruise', 'Pen Mark'};
isNormalized = false; 
EvaluatePointsOnImage(imgList, coordinates, descriptionList, isNormalized);

SetSetting('normalization', 'byPixel');
norm1 = NormalizeHSI(targetId);
imgList = {norm1};
isNormalized = true;
EvaluatePointsOnImage(imgList, coordinates, descriptionList, isNormalized); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

targetId = num2str(153);   % fixed sections
SetSetting('normalization', 'raw');
i1 = NormalizeHSI(targetId);

imgList = {i1};
coordinates = [ 225, 109; 298, 117; 234, 156; 111, 129; 132, 113; 23, 128];
descriptionList = {'Dark1', 'Bright1', 'CleanMargin', 'Dark2', 'GraySurrounding', 'Bright2'};
isNormalized = false; 
EvaluatePointsOnImage(imgList, coordinates, descriptionList, isNormalized);

SetSetting('normalization', 'byPixel');
norm1 = NormalizeHSI(targetId);
imgList = {norm1};
isNormalized = true;
EvaluatePointsOnImage(imgList, coordinates, descriptionList, isNormalized); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
targetId = num2str(150); % raw surface
SetSetting('normalization', 'byPixel');
norm1 = NormalizeHSI(targetId);

norm1 = DeleteBg(norm1);
figure;
imshow(GetDisplayImage(norm1));
imgList = {norm1};
SetSetting('experiment', 'kmeans-clustering');
Cluster(imgList, 'kmeans', 3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
targetId = num2str(147); 
SetSetting('normalization', 'byPixel');
norm1 = NormalizeHSI(targetId);

norm1 = DeleteBg(norm1);
figure;
imshow(GetDisplayImage(norm1));
imgList = {norm1};
SetSetting('experiment', 'kmeans-clustering');
Cluster(imgList, 'kmeans', 3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
infoStruct = GetSampleAssosiatedInfo('001');

% Registration 
targetId = num2str(infoStruct.RawHSIID); % raw surface
SetSetting('normalization', 'byPixel');
norm1 = NormalizeHSI(targetId);

front = LoadMacroRGB(infoStruct.FrontMacroID, 'front');
Register(front, norm1, 'front2hsi');

cut = LoadMacroRGB(infoStruct.CutMacroID, 'cut');
Register(front, cut, 'cut2front');

section = LoadMacroRGB(infoStruct.SectionMacroID, 'section');
Register(cut, section, 'section2cut');

I2 = rgb2gray(section);
level = 0.4;
BW = im2bw(I2,level);
D = -bwdist(~BW);
D(~BW) = -Inf;
L = watershed(D); figure; imshow(label2rgb(L,'jet','w'));
mask = L>1; figure; imshow(mask);
v = imclose(mask, strel('disk', 1)); figure; imshow(v);
d = edge(v, 'Canny');figure; imshow(d);

experiment = 'test2021628';
dataDate = '20210628';
ImportCalibTriplets(dataDate, experiment);

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

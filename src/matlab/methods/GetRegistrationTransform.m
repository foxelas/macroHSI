function [tform, recovered] = GetRegistrationTransform(img1, img2, method)

close all;
if nargin < 3
    method = 'surf';
end

fixed = img1;
moving = img2;

savedir = GetSetting('savedir');
childDir = GetSetting('registration');
savedir = fullfile(savedir, childDir, method);

SetSetting('plotName', fullfile(savedir, strcat('original.png')));
Plots(1, @PlotDualMontage, fixed, moving, 'Images to be registered');
        
        
switch method
    case 'surf'
        ptsFixed = detectSURFFeatures(fixed,'MetricThreshold',50,'NumScaleLevels',6);
        ptsMoving = detectSURFFeatures(moving,'MetricThreshold',50,'NumScaleLevels',6);
        %             cornersFixed = detectFASTFeatures(fixed);
        %             cornersMoving= detectFASTFeatures(moving);
        [featuresFixed, validPtsFixed] = extractFeatures(fixed, ptsFixed);
        [featuresMoving, validPtsMoving] = extractFeatures(moving, ptsMoving);
        
        indexPairs = matchFeatures(featuresFixed, featuresMoving);
        matchedFixed = validPtsFixed(indexPairs(:, 1));
        matchedMoving = validPtsMoving(indexPairs(:, 2));
        
        SetSetting('plotName', fullfile(savedir, strcat('fused1.png')));
        Plots(1, @PlotRegistrationPoints, fixed, moving, matchedFixed, matchedMoving, 'Putatively matched points (including outliers)');
        [tform, inlierMoving, inlierFixed] = estimateGeometricTransform( ...
            matchedMoving, matchedFixed, 'similarity');
        
        SetSetting('plotName', fullfile(savedir, strcat('fused2.png')));
        Plots(2, @PlotRegistrationPoints, fixed, moving, inlierFixed, inlierMoving, 'Matching points (inliers only)');
        
    case 'regconfig'
        [optimizer, metric] = imregconfig('multimodal');
        movingRegisteredDefault = imregister(moving, fixed, 'affine', optimizer, metric);
        
        SetSetting('plotName', fullfile(savedir, strcat('fused1.png')));
        Plots(2, @PlotDualMontage, fixed, movingRegisteredDefault, 'A: Default Registration');
        
        disp(optimizer)
        disp(metric)
        optimizer.InitialRadius = optimizer.InitialRadius / 3.5;
        movingRegisteredAdjustedInitialRadius = imregister(moving, fixed, 'affine', optimizer, metric);
        
        SetSetting('plotName', fullfile(savedir, strcat('fused2.png')));
        Plots(3, @PlotDualMontage, fixed, movingRegisteredAdjustedInitialRadius, 'B: Adjusted InitialRadius');
        
        optimizer.MaximumIterations = 800;
        movingRegisteredAdjustedInitialRadius300 = imregister(moving, fixed, 'affine', optimizer, metric);
        SetSetting('plotName', fullfile(savedir, strcat('fused3.png')));
        Plots(4, @PlotDualMontage, fixed, movingRegisteredAdjustedInitialRadius300, 'C: Adjusted InitialRadius, MaximumIterations = 300');
        
        tform = imregtform(moving, fixed, 'similarity', optimizer, metric);
        Rfixed = imref2d(size(fixed));
        movingRegisteredRigid = imwarp(moving, tform, 'OutputView', Rfixed);
        
        SetSetting('plotName', fullfile(savedir, strcat('fused4.png')));
        Plots(5, @PlotDualMontage, fixed, movingRegisteredRigid, 'D: Registration Based on Similarity Transformation Model');
        
        movingRegisteredAffineWithIC = imregister(moving, fixed, 'affine', optimizer, metric, ...
            'InitialTransformation', tform);
        SetSetting('plotName', fullfile(savedir, strcat('fused5.png')));
        Plots(6, @PlotDualMontage, fixed, movingRegisteredAffineWithIC, 'E: Registration from Affine Model Based on Similarity Initial Condition');
    
    case 'controlPoints'
        [mp,fp] = cpselect(moving, fixed, 'Wait',true);
        tform = fitgeotrans(mp,fp,'projective');

    otherwise
        disp('Unsupported registration method.');
end

Tinv = tform.invert.T;

ss = Tinv(2, 1);
sc = Tinv(1, 1);
scaleRecovered = sqrt(ss*ss+sc*sc)
thetaRecovered = atan2(ss, sc) * 180 / pi

outputView = imref2d(size(fixed));
recovered = imwarp(moving, tform, 'OutputView', outputView);

SetSetting('plotName', fullfile(savedir, strcat('finalRegistered.png')));
Plots(10, @PlotDualMontage, fixed, recovered, 'Fixed vs Registered Moving');

figure(11); imshowpair(fixed,recovered); title('Overlay');
SetSetting('plotName', fullfile(savedir, strcat('overlay.jpg')));SavePlot(11);
%figure(12);imshowpair(fixed,recovered, 'diff'); title('Differenece');
[ssimval,ssimmap] = ssim(fixed, recovered);
figure(13); imshow(ssimmap,[]); title(['Local SSIM Map with Global SSIM Value: ',num2str(ssimval)])
colorbar;
SetSetting('plotName', fullfile(savedir, strcat('ssim.jpg')));SavePlot(13);
end
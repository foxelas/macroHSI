function [] = Register(img1, img2, regType)

switch regType 
    case 'front2hsi'
        rgb = img1;
        hsi = img2;
        
        moving = FlipEnhanceHSI(hsi); 
        static = PrepareRGB(rgb);
        
        method = 'controlPoints'; %'regconfig'; %'surf';
        [tform, recovered] = GetRegistrationTransform(static, moving, method);        
        %[tform2, recovered2] = GetRegistrationTransform(static, recovered, 'surf');
        
    case 'cut2front'
        moving = PrepareRGB(img1); 
        static = PrepareRGB(img2);
        method = 'controlPoints'; %'regconfig'; %'surf';
        [tform, recovered] = GetRegistrationTransform(static, moving, method);    

    case 'section2cut'
        topEdges = ExtractEdges(img2, 'top');
        projectedEdges = ProjectEdges(topEdges, 'trapezoid');
        method = 'manual';
        GetRegistrationTransform(method);
        
    case 'hsi2section'
    otherwise
        error('Not supported registration type.')
end

end 

function [outImg] = FlipEnhanceHSI(img)
    outImg = FlipHSI(img);
    outImg = Enhance(outImg);
end 

function [outImg] = FlipHSI(img)

    outImg = GetDisplayImage(img, 'channel', 150);
    outImg = imrotate(flip(outImg), 90);
end 

function [outImg] = Enhance(img)
    windowWidth = 3; 
    kernel = -1 * ones(windowWidth);
    kernel(ceil(windowWidth/2), ceil(windowWidth/2)) = -sum(kernel(:)) - 1 + windowWidth^2 ;
    kernel = kernel / sum(kernel(:));
    outImg = imfilter(img, kernel);
end 

function [outImg] = PrepareRGB(img)
    outImg = im2double(rgb2gray(img));
end 
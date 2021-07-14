function [outImg, mask] = DeleteBg(img)
% DeleteBg turns all background pixels to zero using a simple mask 
%
%   Usage: 
%   [img, mask] = DeleteBg(img);
    
    mask = GetForegroundMask(img);
    
    [~,~,w] = size(img);
    outImg = img;
    mask3d = repmat(mask, [1, 1, w]);
    outImg(~mask3d) = 0;
end 
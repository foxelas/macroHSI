function [mask] = GetForegroundMask(img, method)
%GetBackgroundMask returns a mask of foreground 

if nargin < 2 
    method = 'simple';
end 

switch method 
    case 'simple'
        rb = GetDisplayImage(img, 'channel', 100);
        mask1 = imfill( ~(rescale(rb) < 0.1), 'holes');
        rg = GetDisplayImage(img, 'channel', 200);
        mask2 = imfill( ~(rescale(rg) < 0.1), 'holes');
        rr = GetDisplayImage(img, 'channel', 300);
        mask3 = imfill( ~(rescale(rr) < 0.1), 'holes');
        mask = mask1 | mask2 | mask3;
        mask = ~imclose(~mask, strel('disk', 2));
    otherwise 
        warning('Unsupported method');
end 
    
end 
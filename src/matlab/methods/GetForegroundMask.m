function [mask] = GetForegroundMask(img, method)
%GetBackgroundMask returns a mask of foreground

if nargin < 2
    method = 'simple';
end

switch method
    case 'simple'
        if size(img, 3) > 3
            rb = GetDisplayImage(img, 'channel', 100);
            rg = GetDisplayImage(img, 'channel', 200);
            rr = GetDisplayImage(img, 'channel', 300);
        else
            rb = img(:, :, 3);
            rg = img(:, :, 2);
            rr = img(:, :, 1);
        end
        mask1 = imfill(~(rescale(rb) < 0.1), 'holes');
        mask2 = imfill(~(rescale(rg) < 0.1), 'holes');
        mask3 = imfill(~(rescale(rr) < 0.1), 'holes');
        mask = mask1 | mask2 | mask3;
        mask = ~imclose(~mask, strel('disk', 2));
    otherwise
        warning('Unsupported method');
end

end
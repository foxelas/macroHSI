function [outImg] = ApplySmoothingFilterOnHSI(img)
% ApplySmoothingFilterOnHSI smooths out the spectrum of an images with
% scratches etc, like the white reference image

disp1 = GetDisplayImage(img);

outImg = zeros(size(img));
for i = 1:size(img, 3)
    outImg(:, :, i) = medfilt2(img(:, :, i));
end
disp2 = GetDisplayImage(outImg);

figure(1);
montage({disp1, disp2});

end
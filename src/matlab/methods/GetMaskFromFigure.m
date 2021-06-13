function [mask, maskedPixels] = GetMaskFromFigure(I)
%%GetMaskFromFigure returns a mask corresponding to a polygon selection on
%%the figure, as well as the marked pixel vectors belogning to the mask.
    [~,~,w] = size(I);
    if w > 3
        Irgb = GetDisplayImage(I);
    else 
        Irgb = I;
    end 
    [m,n,~] = size(I);
    
    mask = roipoly(Irgb);
    
    IFlat = reshape(I, [m*n, w]);
    maskFlat = reshape(mask, [m*n, 1]);
    maskedPixels = IFlat(maskFlat, :);
end
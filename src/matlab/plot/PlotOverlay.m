function [] = PlotOverlay(img, labelImg, fig)
% PlotOverlay displays an image with overlayed labels 
%
%   Usage:
%   Plots(1, @PlotOverlay, img, labelImg)

    if size(img,3) > 3 
        img = GetDisplayImage(img);
    end 
    
    B = labeloverlay(img, labelImg, 'Colormap', 'jet');
    imshow(B);
    
    SavePlot(fig);
    
end
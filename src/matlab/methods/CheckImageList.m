function [imgList, imgN] = CheckImageList(imgList)
% CheckImageList is an assisting functions that converts a single image to
% an image list, in order to use the function both for image input and
% imageList input 

if ~iscell(imgList)
    imgList = {imgList};
end 
imgN = numel(imgList);

end
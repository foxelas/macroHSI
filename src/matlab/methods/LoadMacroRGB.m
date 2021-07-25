function [img] = LoadMacroRGB(id, content)
%LoadMacroRGB loads the macro RGB image with id and content 
%
%   Usage:
%   img = LoadMacroRGB(1, 'front');

    filename = strcat(GetMatSaveFolder('MacroRGB'), num2str(id), '_', content, '.mat');
    load(filename, 'img');
end 
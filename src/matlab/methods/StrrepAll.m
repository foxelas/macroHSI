function [outname] = StrrepAll(inname)
%     StrrepAll fomats an inname to outname
%
%     Usage:
%     [outname] = StrrepAll(inname)

[~, outname] = fileparts(inname);
outname = strrep(outname, '\', ' ');
outname = strrep(outname, '_', ' ');
outname = strrep(outname, '.csv', '');
outname = strrep(outname, '.mat', '');

end
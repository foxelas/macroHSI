function [P, J] = RegionGrowing(method, I, initPos, maxDist, varargin)
%thresVal, tfMean, tfFillHoles, tfSimplify

switch method
    case 1
        % Author:  Daniel Kellner, 2011, braggpeaks{}googlemail.com
        %I is 2D or 3D
        %maxDist default Inf
        if length(varargin) > 1
            thresVal = varargin(1);
        else
            thresVal = [];
        end
        if length(varargin) > 2
            [P, J] = regionGrowing(I, initPos, thresVal, maxDist, varargin{2:end});
        else
            [P, J] = regionGrowing(I, initPos, thresVal, maxDist);
        end
    case 2
        % Author: D. Kroon, University of Twente
        %I is grayscale only
        %maxDist default 0.2
        P = [];
        x = initPos(1);
        y = initPos(2);
        J = regiongrowing(I, x, y, maxDist);
    otherwise
        error('Not supported method');
end
end

function normI = NormalizeImage(I, white, black, method)

%% Normalize a given array I with max and min arrays, white and black
%  according to methon 'method'
%
%   Usage:
%   normI = NormalizeImage(I, white, black, method)

if nargin < 4
    method = 'scaling';
end

enableSmoothWhite = false;
if enableSmoothWhite
    white = ApplySmoothingFilterOnHSI(white);
end

switch method
    case 'scaling'
        denom = white - black;
        denom(denom <= 0) = 0.000000001;
        normI = (I - black) ./ denom;

    otherwise
        error('Unsupported normalization method.');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%NeedToDisable%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(3);
clf;
hold on;
plot(380:780, mean(reshape(white, [size(white, 1) * size(white, 2), size(white, 3)])), 'DisplayName', 'Average White');
plot(380:780, mean(reshape(black, [size(black, 1) * size(black, 2), size(black, 3)])), 'DisplayName', 'Average Black');

plot(380:780, min(reshape(white, [size(white, 1) * size(white, 2), size(white, 3)])), 'DisplayName', 'Min White');
plot(380:780, min(reshape(black, [size(black, 1) * size(black, 2), size(black, 3)])), 'DisplayName', 'Min Black');
hold off;legend
min_white_minus_black = min(white(:)-black(:))

end
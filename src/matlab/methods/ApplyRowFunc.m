function result = ApplyRowFunc(funcName, varargin)
%APPLYROWFUNC applies a function on each row
%
%   Usage:
%   result = ApplyRowFunc(func, varargin) applies function func with
%   arguments varargin on each row of varargin
%

applyToGivenRow = @(func, matrix, restArgs) @(row) func(matrix(row, :), restArgs{:});
newApplyToRows = @(func, matrix, restArgs) arrayfun(applyToGivenRow(func, matrix, restArgs), 1:size(matrix,1), 'UniformOutput', false)';
takeAll = @(x) reshape([x{:}], size(x{1},2), size(x,1))';
genericApplyToRows  = @(func, matrix, restArgs) takeAll(newApplyToRows(func, matrix, restArgs));

targetArray = varargin{1};
varargin = varargin(2:end);
result = genericApplyToRows(funcName, targetArray, varargin);
        
end
function [filepath] = DirMake(varargin)
%     DirMake creates a new directory
%
%     Usage:
%     [filepath] = DirMake(filepath)

if nargin == 1
    filepath = varargin{1};
else
    filepath = fullfile(varargin{:});
end
filedir = fileparts(filepath);
if ~exist(filedir, 'dir')
    mkdir(filedir);
    if  ~contains(filedir, GetSetting('savedir'))
        addpath(filedir);
    end
end
end
function dataTable = GetDB(tableName)
%GetDB returns a DB table as a matlab table
%
%   Usage:
%   dataTable = GetDB()
%   dataTable = GetDB('macroRGB')

if nargin < 1
    tableName = 'DataInfo';
end

switch tableName
    case 'MacroRGB'
        doubleOpts = {'ID', 'CaptureDate'};
    case 'DataInfo'
        doubleOpts = {'ID', 'IntegrationTime', 'IsUnfixed', 'IsBackside', 'CaptureDate', 'CaptureDate'};
    otherwise
        error('Unsupported table name');
end

fullTableName = strcat(GetSetting('database'), 'DB', tableName, 'Table', '.xlsx');

infile = fullfile(GetSetting('datasetSettingsDir'), fullTableName);
opts = detectImportOptions(infile);
opts = setvartype(opts, doubleOpts, 'double');
dataTable = readtable(infile, opts);

end

function dataTable = GetDB()
%GetDB returns the db structure as a table
%
%   Usage:
%   dataTable = GetDB()

infile = fullfile(GetSetting('datasetSettingsDir'), strcat(GetSetting('database'), 'DB.xlsx'));
opts = detectImportOptions(infile);
opts = setvartype(opts,{'ID','IntegrationTime','IsUnfixed','IsBackside','CaptureDate', 'SampleID'},'double');
dataTable = readtable(infile, opts); %'Sheet', 'capturedData'
end

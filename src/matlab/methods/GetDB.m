function dataTable = GetDB()
%%Returns the db structure
dataTable = readtable(fullfile(GetSetting('datasetSettingsDir'), strcat(GetSetting('database'), 'DB.xlsx')), 'Sheet','capturedData');
end 

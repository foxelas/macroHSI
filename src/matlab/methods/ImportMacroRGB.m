function [] = ImportMacroRGB()
%%ImportMacroRGB imports RGB images taken during macropathology
%
%   Usage: 
%   ImportMacroRGB(); 

folderName = 'MacroRGB';
basedir = GetMatSaveFolder(folderName);

infolder = fullfile(GetSetting('mspiDir'), GetSetting('macroDataDir'));

outRows = GetDB(folderName);
id = ismember(outRows.Content, 'front')...
    | ismember(outRows.Content, 'cut') ...
    | ismember(outRows.Content, 'section');

dataTable = outRows(id, :);
for i = 1:size([dataTable.ID],1)
    row =  dataTable(i,:); 
    filename = fullfile(infolder, row.SampleID{1}, row.Filename{1});
    img = imread(filename);
    img = imcrop(img);
    savename = DirMake(basedir, strcat( num2str(row.ID), '_', row.Content{1}, '.mat'));
    save(savename, 'img');
end 

end 
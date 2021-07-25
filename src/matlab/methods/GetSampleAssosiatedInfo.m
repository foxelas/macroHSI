function  infoStruct = GetSampleAssosiatedInfo(sampleID)
%%GetSampleAssosiatedInfo returns a struct containing all file IDs related
%%to a specific tissue sample 
%
%   Usage:
%   infoStruct = GetSampleAssosiatedInfo('001');

    infoStruct = struct('SampleID', [], 'RawHSIID', [], 'SectionHSIID', [], ...
        'FrontMacroID', [], 'CutMacroID', [], 'SectionMacroID', []);
    
    infoStruct.SampleID = sampleID;
    
    dataTable = GetDB();
    setId = ismember(dataTable.SampleID, sampleID) ...
        & ismember(dataTable.Content, 'tissue');
    dataTable = dataTable(setId, :);
    
    %RawHSIID
    setId = ismember(dataTable.Target, strcat(sampleID,'_raw'));
    outRow = dataTable(setId,:);
    infoStruct.RawHSIID = outRow.ID;
    
    %SectionHSIID
    setId = ismember(dataTable.Target, strcat(sampleID,'_fix'));
    outRow = dataTable(setId,:);
    infoStruct.SectionHSIID = outRow.ID;
    
    dataTable = GetDB('MacroRGB');
    setId = ismember(dataTable.SampleID, sampleID);
    dataTable = dataTable(setId, :);
    
    %FrontMacroID
    setId = ismember(dataTable.Content, strcat('front'));
    outRow = dataTable(setId,:);
    infoStruct.FrontMacroID = outRow.ID;  
    
    %CutMacroID
    setId = ismember(dataTable.Content, strcat('cut'));
    outRow = dataTable(setId,:);
    infoStruct.CutMacroID = outRow.ID;  
    
    %SectionMacroID
    setId = ismember(dataTable.Content, strcat('section'));
    outRow = dataTable(setId,:);
    infoStruct.SectionMacroID = outRow.ID;

end 
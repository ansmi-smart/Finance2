report 50004 "DWH Data processing"
{
    Caption = 'DWH Loading data';
    ProcessingOnly = true;
    UseRequestPage = false;

    procedure ProcessAllData()
    var
        LoadedData: Record "DWH integration log";
        Archive: Record "DWH integration archive log";
    begin
        if LoadedData.FindSet() then begin
            repeat
                Archive.TransferFields(LoadedData, true);
                Archive.Insert();
                LoadedData.Delete();
            until LoadedData.Next() = 0;
        end;
    end;
}
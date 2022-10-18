report 50008 "DWH Deleting personal data"
{
    Caption = 'DWH Deleting personal data';
    ProcessingOnly = true;
    UseRequestPage = false;

    trigger OnPreReport()
    var
        Customer: Record Customer;
    begin
        if (Customer.FindSet()) then
            repeat
                if (Customer."Case ID Expiration Date" <> 0D) then
                    ClearCustomerPersonalData(Customer);
            until Customer.Next() = 0;
    end;

    procedure ClearCustomerPersonalData(Customer: Record Customer)
    var
        CaseIDInfo: Label 'You cannot delete the debtor`s personal data, because Case ID expired data are not over yet';
        Position, DataPos : Integer;
        Data: array[5] of text;
    begin
        Data[1] := Customer.Name;
        Data[2] := Customer.Address;
        Data[3] := Customer."Post Code";
        Data[4] := Customer."Fiscal Code";
        Data[5] := Customer.SDI;
        if (Customer."Case ID Expiration Date" <> 0D) then
            if (Customer."Case ID Expiration Date" < WorkDate()) then begin
                for DataPos := 1 to ArrayLen(Data) do begin
                    for Position := 1 to StrLen(Data[DataPos]) do begin
                        if (Data[DataPos] [Position] <> ' ') then
                            Data[DataPos] := Data[DataPos].Replace(Data[DataPos] [Position], '*');
                    end;
                end;
                Customer.Name := Data[1];
                Customer.Address := Data[2];
                Customer."Post Code" := Data[3];
                Customer."Fiscal Code" := Data[4];
                Customer.SDI := Data[5];
                Customer.Modify();
            end else
                Message(CaseIDInfo);
    end;
}

report 50008 "DWH Deleting personal data"
{
    Caption = 'DWH Deleting personal data';
    ProcessingOnly = true;
    UseRequestPage = false;

    trigger OnPreReport()
    var
        Customer: Record Customer;
    begin
        Customer.SetFilter("Case ID Expiration Date", '<', WorkDate());
        if (Customer.FindSet()) then
            repeat
                if (Customer."Case ID Expiration Date" <> 0D) then
                    ClearCustomerPersonalData(Customer);
            until Customer.Next() = 0;
    end;

    procedure ClearCustomerPersonalData(Customer: Record Customer)
    var
        CaseIDInfo: Label 'You cannot delete the debtor`s personal data, because Case ID expired data are not over yet';
    begin
        if (Customer."Case ID Expiration Date" < WorkDate()) then begin
            Customer.Name := '*****';
            Customer.Address := '*****';
            Customer."Post Code" := '*****';
            Customer."Fiscal Code" := '*****';
            Customer.SDI := '*****';
            Customer.Modify();
        end else
            Message(CaseIDInfo);
    end;
}

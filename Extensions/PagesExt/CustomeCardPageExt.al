pageextension 50008 "Custome Card Page Ext." extends "Customer Card"
{

    layout
    {
        addafter("No.")
        {
            field(CaseID; Rec."Case ID")
            {
                Caption = 'Case ID';
            }
            field("Case ID Expiration Date"; Rec."Case ID Expiration Date")
            {
                Caption = 'Case ID Expiration Date';
            }
        }

        addafter("Full Name")
        {

            field("Fiscal Code"; Rec."Fiscal Code")
            {
                Caption = 'Fiscal Code';
            }
            field(SDI; Rec.SDI)
            {
                Caption = 'SDI';
            }
        }
    }
    actions
    {
        addafter(Attachments)
        {
            action("Clear client's personal data")
            {
                Caption = 'Clear client`s personal data';
                Image = ClearLog;
                Promoted = true;
                PromotedCategory = Category9;

                trigger OnAction()
                var
                    DataProcessing: Report "DWH Deleting personal data";
                begin
                    DataProcessing.ClearCustomerPersonalData(Rec);
                end;
            }
        }
    }
}

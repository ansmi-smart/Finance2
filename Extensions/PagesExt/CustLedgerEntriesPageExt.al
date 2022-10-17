pageextension 50005 "Cust. Ledger Entries Page Ext." extends "Customer Ledger Entries"
{
    layout
    {
        addafter("Entry No.")
        {
            field(CaseID; Rec."Case ID")
            {
                Caption = 'Case ID';
            }
        }
    }
}

pageextension 50009 "Posted Sales Inv. Page Ext." extends "Posted Sales Invoices"
{
    layout
    {
        addafter("No.")
        {
            field(CaseID; Rec.CaseID)
            {
                Caption = 'Case ID';
            }
        }
    }
}

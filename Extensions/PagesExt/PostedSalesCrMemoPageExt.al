pageextension 50012 "Posted Sales Cr. Memo Page Ext" extends "Posted Sales Credit Memo"
{
    layout
    {
        addafter("No.")
        {
            field(CaseID; Rec."Case ID")
            {
                Caption = 'Case ID';
            }
        }
    }
}

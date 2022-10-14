pageextension 50012 "Posted Sales Cr. Memo Page Ext" extends "Posted Sales Credit Memo"
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

pageextension 50013 "Posted Sales Cr. Memos PageExt" extends "Posted Sales Credit Memos"
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

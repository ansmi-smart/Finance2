pageextension 50001 "General Journal Page Ext" extends "General Journal"
{
    layout
    {
        addafter("Account Name")
        {
            field(CaseID; Rec.CaseID)
            {
                ApplicationArea = All;
            }
        }
    }
}

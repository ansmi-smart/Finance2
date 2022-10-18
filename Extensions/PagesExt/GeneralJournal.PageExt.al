pageextension 50001 "General Journal Page Ext" extends "General Journal"
{
    layout
    {
        addafter("Account No.")
        {
            field(CaseID; Rec."Case ID")
            {
            }
        }
    }
}

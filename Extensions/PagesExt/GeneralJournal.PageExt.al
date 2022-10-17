pageextension 50001 "General Journal Page Ext" extends "General Journal"
{
    layout
    {
        addafter("Account Name")
        {
            field(CaseID; Rec."Case ID")
            {
                ApplicationArea = All;
            }
        }
    }
}

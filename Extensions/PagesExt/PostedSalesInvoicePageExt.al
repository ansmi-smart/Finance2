pageextension 50007 "Posted Sales Invoice Page Ext." extends "Posted Sales Invoice"
{
    layout
    {
        addafter("No.")
        {
            field(CaseID; Rec."Case ID")
            {
            }
        }
    }
}

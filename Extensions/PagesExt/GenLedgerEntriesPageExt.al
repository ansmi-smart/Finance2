pageextension 50006 "Gen. Ledger Entries Page Ext." extends "General Ledger Entries"
{
    layout
    {
        addafter("Entry No.")
        {
            field(CaseID; Rec."Case ID")
            {
            }
        }
    }
}

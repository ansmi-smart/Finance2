tableextension 50003 "Sales Credit Memo Table Ext." extends "Sales Cr.Memo Header"
{
    fields
    {
        field(50001; "Case ID"; Code[20])
        {
            Caption = 'Case ID';
            FieldClass = FlowField;
            CalcFormula = lookup(Customer."Case ID" where("No." = field("Sell-to Customer No.")));
        }
    }
}
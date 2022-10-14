tableextension 50003 "Sales Credit Memo Table Ext." extends "Sales Cr.Memo Header"
{
    fields
    {
        field(50001; CaseID; Code[20])
        {
            Caption = 'CaseID';
            FieldClass = FlowField;
            CalcFormula = lookup(Customer.CaseID where("No." = field("Sell-to Customer No.")));
        }
    }
}
tableextension 50002 "Sales Invoice Table Ext." extends "Sales Invoice Header"
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

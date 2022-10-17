tableextension 50002 "Sales Invoice Table Ext." extends "Sales Invoice Header"
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

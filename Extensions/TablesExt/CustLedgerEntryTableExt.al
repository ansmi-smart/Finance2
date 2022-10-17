tableextension 50010 "Cust. Ledger Entry Table Ext." extends "Cust. Ledger Entry"
{
    fields
    {
        field(50001; "Case ID"; Code[20])
        {
            Caption = 'Case ID';
            FieldClass = FlowField;
            CalcFormula = lookup(Customer."Case ID" where("No." = field("Customer No.")));
        }
    }
}

tableextension 50010 "Cust. Ledger Entry Table Ext." extends "Cust. Ledger Entry"
{
    fields
    {
        field(50001; CaseID; Code[20])
        {
            Caption = 'CaseID';
            FieldClass = FlowField;
            CalcFormula = lookup(Customer.CaseID where("No." = field("Customer No.")));
        }
    }
}

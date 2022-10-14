tableextension 50001 "G/L Entry Table Ext." extends "G/L Entry"
{
    fields
    {
        field(50002; CaseID; Code[20])
        {
            Caption = 'CaseID';
            FieldClass = FlowField;
            CalcFormula = lookup(Customer.CaseID where("No." = field("G/L Account No.")));
        }
    }
}

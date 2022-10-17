tableextension 50001 "G/L Entry Table Ext." extends "G/L Entry"
{
    fields
    {
        field(50002; "Case ID"; Code[20])
        {
            Caption = 'Case ID';
            FieldClass = FlowField;
            CalcFormula = lookup(Customer."Case ID" where("No." = field("Source No.")));
        }
    }
}

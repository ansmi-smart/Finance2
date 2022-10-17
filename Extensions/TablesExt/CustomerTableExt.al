tableextension 50009 "Customer Table Ext." extends Customer
{
    fields
    {
        field(12101; "Fiscal Code"; Text[250])
        {
            Caption = 'Fiscal Code ';
        }

        field(50000; "Case ID"; Code[20])
        {
            Caption = 'Case ID';
            FieldClass = Normal;
        }
        field(50001; "Case ID Expiration Date"; Date)
        {
            Caption = 'Case ID Expiration Date';
        }
        field(50002; "SDI"; text[12])
        {
            Caption = 'SDI';
        }
    }
}


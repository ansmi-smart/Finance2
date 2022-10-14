tableextension 50009 "Customer Table Ext." extends Customer
{
    fields
    {
        field(50000; CaseID; Code[20])
        {
            Caption = 'CaseID';
            FieldClass = Normal;
        }
    }

}

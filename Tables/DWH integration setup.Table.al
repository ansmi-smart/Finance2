table 50006 "DWH integration setup"
{
    Caption = 'DWH integration setup';
    DrillDownPageID = "DWH integration setup";
    LookupPageID = "DWH integration setup";

    fields
    {
        field(1; "Api URL"; Text[250])
        {
            Caption = 'Api URL';
        }
        field(2; "Login"; Text[50])
        {
            Caption = 'Login';
        }
        field(3; "Password"; Text[50])
        {
            Caption = 'Api URL';
            ExtendedDatatype = Masked;
        }
        field(4; "Default Gen. Bus. Post. Group"; Code[20])
        {
            Caption = 'Default Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group".Code;
        }
        field(5; "Default VAT Bus. Posting Group"; Code[20])
        {
            Caption = 'Default VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group".Code;
        }
        field(6; "Default Customer Post. Group "; Code[20])
        {
            Caption = 'Default Customer Posting Group ';
            TableRelation = "Customer Posting Group".Code;
        }
        field(7; "Expense Gen. Journal Template "; Code[20])
        {
            Caption = 'Expense General Journal Template ';
            TableRelation = "Gen. Journal Template".Name;
        }
        field(8; "Expense General Journal Batch "; Code[20])
        {
            Caption = 'Expense General Journal Batch ';
            TableRelation = "Gen. Journal Batch".Name;
        }
        field(9; "Payments Gen. Journal Template"; Code[20])
        {
            Caption = 'Payments General Journal Template';
            TableRelation = "Gen. Journal Template".Name;
        }
        field(10; "Payments Gen. Journal Batch "; Code[20])
        {
            Caption = 'Payments General Journal Batch ';
            TableRelation = "Gen. Journal Batch".Name;
        }
        field(12; "Invoice default G/L Account"; Code[20])
        {
            Caption = 'Invoice default G/L Account';
            TableRelation = "G/L Account"."No.";
        }

        field(13; "Default Bank Account"; Code[20])
        {
            Caption = 'Default Bank Account';
            TableRelation = "Bank Account"."No.";
        }
        field(14; "Def. Exp. Debit G/L Account"; Code[20])
        {
            Caption = 'Default Expenses Debit G/L Account';
            TableRelation = "G/L Account"."No.";
        }
        field(15; "Def. Exp. Credit G/L Account"; Code[20])
        {
            Caption = 'Default Expenses Credit G/L Account';
            TableRelation = "G/L Account"."No.";
        }
    }
}
table 50006 "DWH integration setup"
{
    Caption = 'DWH integration setup';
    DrillDownPageID = "DWH integration setup";
    LookupPageID = "DWH integration setup";

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Api URL"; Text[250])
        {
            Caption = 'Api URL';
        }
        field(3; "Login"; Text[50])
        {
            Caption = 'Login';
        }
        field(4; "Password"; Text[50])
        {
            Caption = 'Password';
            ExtendedDatatype = Masked;
        }
        field(5; "Default Gen. Bus. Post. Group"; Code[20])
        {
            Caption = 'Default Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group".Code;
        }
        field(6; "Default VAT Bus. Posting Group"; Code[20])
        {
            Caption = 'Default VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group".Code;
        }
        field(7; "Default Customer Post. Group"; Code[20])
        {
            Caption = 'Default Customer Posting Group';
            TableRelation = "Customer Posting Group".Code;
        }
        field(8; "Expense Gen. Journal Template"; Code[20])
        {
            Caption = 'Expense General Journal Template';
            TableRelation = "Gen. Journal Template".Name;
        }
        field(9; "Expense General Journal Batch"; Code[20])
        {
            Caption = 'Expense General Journal Batch';
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Expense Gen. Journal Template"));
        }
        field(10; "Payments Gen. Journal Template"; Code[20])
        {
            Caption = 'Payments General Journal Template';
            TableRelation = "Gen. Journal Template".Name;
        }
        field(11; "Payments Gen. Journal Batch"; Code[20])
        {
            Caption = 'Payments General Journal Batch';
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Payments Gen. Journal Template"));
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
        field(16; "Max. processing amount"; Integer)
        {
            Caption = 'Max. processing amount';
        }
        field(17; "Authorization Code"; Text[100])
        {
            Caption = 'Authorization Code';
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

}
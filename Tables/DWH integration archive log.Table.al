table 50002 "DWH integration archive log"
{
    Caption = 'DWH integration archive log';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "Debtor Name"; Text[250])
        {
            Caption = 'Debtor Name';
        }
        field(3; "Debtor Tax Code"; Text[250])
        {
            Caption = 'Debtor Tax Code';
        }
        field(4; "Debtor Address"; Text[250])
        {
            Caption = 'Debtor Address';
        }
        field(5; "Case ID"; Code[20])
        {
            Caption = 'Case ID';
            ExtendedDatatype = Masked;
        }
        field(6; "Case Expiration Date"; Date)
        {
            Caption = 'Case Expiration Date';
        }
        field(7; "SDI"; Integer)
        {
            Caption = 'SDI';
        }
        field(8; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionMembers = " ","Payment","Refund","Invoice";
            OptionCaption = ' ,Payment,Refund,Invoice;';
        }
        field(9; "Transaction ID"; Text[20])
        {
            Caption = 'Transaction ID';
        }
        field(10; "Portfolio ID"; Code[30])
        {
            Caption = 'Portfolio ID';
        }
        field(11; "Portfolio Name"; Code[30])
        {
            Caption = 'Portfolio Name';
        }
        field(12; "Batch ID"; Code[30])
        {
            Caption = 'Batch ID';
        }
        field(13; "Batch Name"; Text[50])
        {
            Caption = 'Batch Name';
        }
        field(14; "Segment ID"; Text[50])
        {
            Caption = 'Segment ID';
        }
        field(15; "Segment Name"; Text[50])
        {
            Caption = 'Segment Name';
        }
        field(16; "Flow ID"; Text[50])
        {
            Caption = 'Flow ID';
        }
        field(17; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(18; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
        }
        field(19; "Description"; Text[250])
        {
            Caption = 'Description';
        }
        field(20; "G\L Local Account"; Code[20])
        {
            Caption = 'GL\Local Account';
        }
        field(21; "Quantity"; Integer)
        {
            Caption = 'Quantity';
            InitValue = 1;
        }
        field(22; "Amount"; Decimal)
        {
            Caption = 'Amount';
        }
        field(23; "Account Type"; Option)
        {
            Caption = 'Account Type';
            OptionMembers = " ","G/L Account","Debtor","Customer","Vendor","Bank Account","Fixed Asset","IC Partner";
            OptionCaption = ' ,G/L Account,Debtor,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
        }
        field(24; "Account No."; Code[20])
        {
            Caption = 'Account No.';
        }
        field(25; "Bal. Account Type"; Option)
        {
            Caption = 'Bal. Account Type';
            OptionMembers = " ","G/L Account","Customer","Vendor","Bank Account","Fixed Asset","IC Partner";
            OptionCaption = ' ,G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
        }
        field(26; "Bal. Account No."; Code[20])
        {
            Caption = 'Bal. Account No.';
        }
        field(27; "Correction"; Boolean)
        {
            Caption = 'Correction';
        }
        field(28; "Invoiced"; Boolean)
        {
            Caption = 'Invoiced';
        }
        field(29; "Meta Check"; Option)
        {
            Caption = 'Meta Check';
            OptionMembers = " ","Invoice","Expense";
            OptionCaption = ' ,Invoice,Expense';
        }
        field(30; "Meta Marte Insert Date"; DateTime)
        {
            Caption = 'Meta Marte Insert Date';
        }
        field(31; "Meta DWH Insert Date"; DateTime)
        {
            Caption = 'Meta DWH Insert Date';
        }
        field(32; "Processing counter"; Integer)
        {
            Caption = 'Processing counter';
        }
        field(33; "Error Massage"; Text[250])
        {
            Caption = 'Error Massage';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}

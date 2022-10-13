table 50004 "DWH integration archive log"
{
    Caption = 'DWH integration archive log';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(2; "DebtorName"; Text[250])
        {
            Caption = 'DebtorName';
        }
        field(3; "DebtorTaxCode"; Text[250])
        {
            Caption = 'DebtorTaxCode';
        }
        field(4; "DebtorAddress"; Text[250])
        {
            Caption = 'DebtorAddress';
        }
        field(5; "CaseID"; Code[20])
        {
            Caption = 'CaseID';
            ExtendedDatatype = Masked;
        }
        field(6; "CaseExpirationDate"; Date)
        {
            Caption = 'CaseExpirationDate';
        }
        field(7; "SDI"; Integer)
        {
            Caption = 'SDI';
        }
        field(8; "DocumentType"; Option)
        {
            Caption = 'DocumentType';
            OptionMembers = " ","Payment","Refund","Invoice";
        }
        field(9; "TransactionID"; Text[20])
        {
            Caption = 'TransactionID';
        }
        field(10; "PortfolioID"; Code[30])
        {
            Caption = 'PortfolioID';
        }
        field(11; "PortfolioName"; Code[30])
        {
            Caption = 'PortfolioName';
        }
        field(12; "BatchID"; Code[30])
        {
            Caption = 'BatchID';
        }
        field(13; "BatchName"; Text[50])
        {
            Caption = 'BatchName';
        }
        field(14; "SegmentID"; Text[50])
        {
            Caption = 'SegmentID';
        }
        field(15; "SegmentName"; Text[50])
        {
            Caption = 'SegmentName';
        }
        field(16; "FlowID"; Text[50])
        {
            Caption = 'FlowID';
        }
        field(17; "PostingDate"; Date)
        {
            Caption = 'PostingDate';
        }
        field(18; "CurrencyCode"; Code[10])
        {
            Caption = 'CurrencyCode';
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
        field(23; "AccountType"; Option)
        {
            Caption = 'AccountType';
            OptionMembers = " ","G/L Account","Debtor","Customer","Vendor","Bank Account","Fixed Asset","IC Partner";
        }
        field(24; "AccountNo"; Code[20])
        {
            Caption = 'AccountNo';
        }
        field(25; "Bal. AccountType"; Option)
        {
            Caption = 'Bal. AccountType';
            OptionMembers = " ","G/L Account","Customer","Vendor","Bank Account","Fixed Asset","IC Partner";
        }
        field(26; "Bal. AccountNo"; Code[20])
        {
            Caption = 'Bal. AccountNo';
        }
        field(27; "Correction"; Boolean)
        {
            Caption = 'Correction';
        }
        field(28; "Invoiced"; Boolean)
        {
            Caption = 'Invoiced';
        }
        field(29; "meta_Chck"; Option)
        {
            Caption = 'meta_Chck';
            OptionMembers = " ","Invoice","Expense";
        }
        field(30; "meta_MarteInsertDate"; DateTime)
        {
            Caption = 'meta_MarteInsertDate';
        }
        field(31; "meta_DWHInsertDate"; DateTime)
        {
            Caption = 'meta_DWHInsertDate';
        }
    }

    keys
    {
        key(PK; "Line No.")
        {
            Clustered = true;
        }
    }
}

codeunit 50000 DWHProcessing
{
    TableNo = "DWH integration log";

    trigger OnRun()
    begin
        DWHintegrationlog := Rec;
        Code();
    end;

    var
        DWHintegrationlog: Record "DWH integration log";
        DWHsetup: Record "DWH integration setup";
        GenJournal: Record "Gen. Journal Line";
        DimensionCode: Code[20];
        DimensionValues: Record "Dimension Value";
        GenLedgerSetup: Record "General Ledger Setup";
        ValidatedDimCode: Code[20];


    procedure Code()
    begin
        DWHsetup.Get();

        if (DWHintegrationlog.DocumentType = DWHintegrationlog.DocumentType::Invoice) and (DWHintegrationlog.Correction = false) and (DWHintegrationlog.Invoiced = true) then begin
            CreateSalesDocument(DWHintegrationlog);
        end else
            CreateGenJournalLines(DWHintegrationlog);
    end;

    procedure CreateSalesDocument(DWHLog: Record "DWH integration log")
    var
        SalesHeader: Record "Sales Header";
        SalesLines: Record "Sales Line";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        SalesHeader.Init();
        SalesHeader.Validate("No.", NoSeriesMgt.GetNextNo(SalesHeader.GetNoSeriesCode(), DWHLog."Posting Date", true));
        SalesHeader.Validate("Document Type", SalesHeader."Document Type"::Invoice);
        SalesHeader.Validate("Posting Date", DWHLog."Posting Date");
        SalesHeader.Validate("Document Date", DWHLog."Posting Date");
        SalesHeader.Validate("Sell-to Customer No.", GetNoAndCreateCustomer(DWHLog));
        SalesHeader."Currency Code" := DWHLog."Currency Code";
        SalesHeader.Validate("Posting Description", DWHLog.Description);
        SalesHeader.Validate(Correction, DWHLog.Correction);
        ValidatedDimCode := CreteDimension(DWHLog);
        SalesHeader.ValidateShortcutDimCode(GetPotrafoglioFieldNo('PORTAFOGLIO'), ValidatedDimCode);
        ValidatedDimCode := DWHLog."Flow ID";
        SalesHeader.ValidateShortcutDimCode(GetPotrafoglioFieldNo('FLOW'), ValidatedDimCode);
        SalesHeader.Insert();

        SalesLines.Init();
        SalesLines.Validate("Document Type", SalesHeader."Document Type");
        SalesLines."Document No." := SalesHeader."No.";
        SalesLines.Validate("Line No.", 10000);
        SalesLines.Validate(Type, SalesLines.Type::"G/L Account");
        SalesLines.Validate("No.", DWHsetup."Invoice default G/L Account");
        SalesLines.Validate(Quantity, DWHLog.Quantity);
        SalesLines.Validate(Amount, DWHLog.Amount);
        SalesLines.Insert();
    end;

    procedure CreateGenJournalLines(DWHLog: Record "DWH integration log")
    begin
        GenJournal.Init();
        GenJournal.Validate("Journal Template Name", 'GENERAL');
        GenJournal.Validate("Journal Batch Name", 'DEFAULT');
        GenJournal.Validate("Line No.", GenJournal.GetNewLineNo(GenJournal."Journal Template Name", GenJournal."Journal Batch Name"));
        GenJournal.Validate("Posting Date", WorkDate());
        if (DWHLog.DocumentType = DWHLog.DocumentType::" ") then begin
            GenJournal.Validate("Document Type", GenJournal."Document Type"::Invoice);
            GenJournal.Validate("Account Type", GenJournal."Account Type"::"G/L Account");
            GenJournal.Validate("Account No.", DWHsetup."Def. Exp. Debit G/L Account");
            GenJournal.Validate("Bal. Account Type", GenJournal."Bal. Account Type"::"G/L Account");
            GenJournal.Validate("Bal. Account No.", DWHsetup."Def. Exp. Credit G/L Account");
        end else begin
            GenJournal.Validate("Document Type", DWHLog.DocumentType);
            GenJournal.Validate("Account Type", GenJournal."Account Type"::Customer);
            GenJournal.Validate("Account No.", GetNoAndCreateCustomer(DWHLog));
            GenJournal.Validate("Bal. Account Type", GenJournal."Bal. Account Type"::"Bank Account");
            GenJournal.Validate("Bal. Account No.", DWHsetup."Default Bank Account");
        end;
        GenJournal.Validate("Document No.", DWHLog."Transaction ID");
        GenJournal.Validate(Description, DWHLog.Description);
        GenJournal.Validate("Case ID", DWHLog."Case ID");
        GenJournal."Currency Code" := DWHLog."Currency Code";
        if (DWHLog.DocumentType = DWHLog.DocumentType::Payment) then
            DWHLog.Amount := (-1) * DWHLog.Amount;
        GenJournal.Validate(Amount, DWHLog.Amount);
        ValidatedDimCode := CreteDimension(DWHLog);
        GenJournal.ValidateShortcutDimCode(GetPotrafoglioFieldNo('PORTAFOGLIO'), ValidatedDimCode);
        ValidatedDimCode := DWHLog."Flow ID";
        GenJournal.ValidateShortcutDimCode(GetPotrafoglioFieldNo('FLOW'), ValidatedDimCode);
        GenJournal.Insert();
    end;

    procedure GetNoAndCreateCustomer(DWHLog: Record "DWH integration log"): Code[20]
    var
        Customer: Record Customer;
    begin
        Customer.SetRange(Name, DWHLog."Debtor Name");
        if (Customer.FindFirst) then
            exit(Customer."No.")
        else begin
            Customer.Init();
            Customer.Get(Customer.CreateNewCustomer(DWHLog."Debtor Name", false));
            Customer."Case ID" := DWHLog."Case ID";
            Customer."Case ID Expiration Date" := DWHLog."Case Expiration Date";
            Customer.SDI := Format(DWHLog.SDI);
            if (DWHLog."Debtor Tax Code" <> '  ') then begin
                if (DWHLog."Debtor Tax Code".Contains('-')) then begin
                    Customer.Validate("Fiscal Code", DWHLog."Debtor Tax Code".Substring(1, DWHLog."Debtor Tax Code".IndexOf('-') - 1));
                    Customer.Validate("VAT Registration No.", DWHLog."Debtor Tax Code".Substring(DWHLog."Debtor Tax Code".IndexOf('-') + 1));
                end else
                    Customer.Validate("Fiscal Code", DWHLog."Debtor Tax Code");
                Customer.Validate("VAT Registration No.", DWHLog."Debtor Tax Code".Substring(DWHLog."Debtor Tax Code".IndexOf('-') + 1));
            end;
            if (DWHLog."Debtor Address" <> '  ') then begin
                Customer.Validate(Address, DWHLog."Debtor Address".Substring(1, StrLen(DWHLog."Debtor Address") - 5));
                Customer.Validate("Post Code", DWHLog."Debtor Address".Substring(StrLen(DWHLog."Debtor Address") - 5));
            end;
            Customer.Validate("Gen. Bus. Posting Group", DWHsetup."Default Gen. Bus. Post. Group");
            Customer.Validate("VAT Bus. Posting Group", DWHsetup."Default VAT Bus. Posting Group");
            Customer.Validate("Customer Posting Group", DWHsetup."Default Customer Post. Group");
            Customer.Modify(true);
            exit(Customer."No.")
        end;
    end;

    procedure CreteDimension(LoadedData: Record "DWH integration log"): Code[20]
    var
        PotrafoglioField: Code[20];
        FlowField: Code[20];
    begin
        DimensionCode := GetDimension(LoadedData);
        DimensionValues.SetRange("Dimension Code", 'PORTAFOGLIO');
        DimensionValues.SetRange(Code, DimensionCode);
        if (not DimensionValues.FindFirst) then begin
            DimensionValues.Init;
            DimensionValues.Validate("Dimension Code", 'PORTAFOGLIO');
            DimensionValues.Validate(Code, DimensionCode);
            DimensionValues.Validate(Name, DimensionCode);
            DimensionValues.Insert(true);
        end;
        DimensionValues.SetRange("Dimension Code", 'FLOW');
        DimensionValues.SetRange(Code, LoadedData."Flow ID");
        if (not DimensionValues.FindFirst) then begin
            DimensionValues.Init;
            DimensionValues.Validate("Dimension Code", 'FLOW');
            DimensionValues.Validate(Code, LoadedData."Flow ID");
            DimensionValues.Validate(Name, LoadedData."Flow ID");
            DimensionValues.Insert(true);
        end;
        exit(DimensionCode);
    end;

    procedure GetPotrafoglioFieldNo(DimCode: Code[20]): Integer
    begin
        GenLedgerSetup.get();
        case DimCode of
            GenLedgerSetup."Shortcut Dimension 1 Code":
                exit(1);
            GenLedgerSetup."Shortcut Dimension 2 Code":
                exit(2);
            GenLedgerSetup."Shortcut Dimension 3 Code":
                exit(3);
            GenLedgerSetup."Shortcut Dimension 4 Code":
                exit(4);
            GenLedgerSetup."Shortcut Dimension 5 Code":
                exit(5);
            GenLedgerSetup."Shortcut Dimension 6 Code":
                exit(6);
            GenLedgerSetup."Shortcut Dimension 7 Code":
                exit(7);
            GenLedgerSetup."Shortcut Dimension 8 Code":
                exit(8);
        end;
    end;

    procedure GetDimension(LoadedData: Record "DWH integration log"): Code[20]
    var
        DimensionCode: Code[20];
    begin
        DimensionCode := '';
        if (LoadedData."Portfolio ID" <> ' ') then
            DimensionCode := getZeros(4, StrLen(LoadedData."Portfolio ID")) + LoadedData."Portfolio ID" + '.';
        if (LoadedData."Batch ID" <> ' ') then
            DimensionCode += getZeros(3, StrLen(LoadedData."Batch ID")) + LoadedData."Batch ID" + '.';
        if (LoadedData."Segment ID" <> ' ') then begin
            DimensionCode += getZeros(2, StrLen(LoadedData."Segment ID")) + LoadedData."Segment ID";
            exit(DimensionCode);
        end else
            exit('000000');
    end;

    local procedure getZeros(Amount: Integer; Existed: integer): Text
    var
        Zeros: Text[4];
    begin
        case Amount - Existed of
            0:
                Zeros := '';
            1:
                Zeros := '0';
            2:
                Zeros := '00';
            3:
                Zeros := '000';
        end;
        exit(Zeros);
    end;
}
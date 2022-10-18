report 50004 "DWH Data processing"
{
    Caption = 'DWH Loading data';
    ProcessingOnly = true;
    UseRequestPage = false;


    trigger OnPreReport()
    begin
        ProcessAllData();
    end;

    procedure ProcessAllData()
    var
        LoadedData: Record "DWH integration log";
        Archive: Record "DWH integration archive log";
        EntryNo: Integer;
    begin
        if LoadedData.FindSet() then begin
            repeat
                if (Archive.FindSet()) then
                    EntryNo := Archive.Count + 1
                else
                    EntryNo := 1;
                Archive.TransferFields(LoadedData, true);
                Archive."Entry No." := EntryNo;
                Archive.Insert();
                CreateSalesDocument(LoadedData);
                AddGenJournalLines(LoadedData);
                LoadedData.Delete();
            until LoadedData.Next() = 0;
        end;
    end;

    var
        Customer: Record Customer;
        DWHsetup: Record "DWH integration setup";
        GenJournal: Record "Gen. Journal Line";
        DimensionCode: Code[20];
        DimensionValues: Record "Dimension Value";
        GenLedgerSetup: Record "General Ledger Setup";
        SalesRecSetup: Record "Sales & Receivables Setup";

    procedure CreateSalesDocument(LoadedData: Record "DWH integration log")
    var
        SalesHeader: Record "Sales Header";
        SalesLines: Record "Sales Line";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Account: Record "G/L Account";
    begin
        SalesHeader.Init();
        SalesHeader.Validate("No.", NoSeriesMgt.GetNextNo(SalesHeader.GetNoSeriesCode(), LoadedData."Posting Date", true));
        if (LoadedData.DocumentType = LoadedData.DocumentType::Invoice) and (LoadedData.Correction = false) and (LoadedData.Invoiced = true) then
            SalesHeader.Validate("Document Type", SalesHeader."Document Type"::Invoice)
        else
            SalesHeader.Validate("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.Validate("Posting Date", LoadedData."Posting Date");
        SalesHeader.Validate("Document Date", LoadedData."Posting Date");
        // dimension flow?*/
        Customer.Init();
        Customer.SetRange(Name, LoadedData."Debtor Name");
        if (Customer.FindFirst) then
            SalesHeader.Validate("Sell-to Customer No.", Customer."No.")
        else begin
            Customer.Init();
            SalesRecSetup.Get();
            Customer."No." := NoSeriesMgt.GetNextNo(SalesRecSetup."Customer Nos.", LoadedData."Posting Date", true);
            Customer.Validate(Name, LoadedData."Debtor Name");
            Customer.Validate("Case ID", LoadedData."Case ID");
            Customer.Validate("Case ID Expiration Date", LoadedData."Case Expiration Date");
            Customer.Validate(SDI, Format(LoadedData.SDI));
            if (LoadedData."Debtor Tax Code" <> '  ') then begin
                if (LoadedData."Debtor Tax Code".Contains('-')) then begin
                    Customer.Validate("Fiscal Code", LoadedData."Debtor Tax Code".Substring(1, LoadedData."Debtor Tax Code".IndexOf('-') - 1));
                    Customer.Validate("VAT Registration No.", LoadedData."Debtor Tax Code".Substring(LoadedData."Debtor Tax Code".IndexOf('-') + 1));
                end else
                    Customer.Validate("Fiscal Code", LoadedData."Debtor Tax Code");
                Customer.Validate("VAT Registration No.", LoadedData."Debtor Tax Code".Substring(LoadedData."Debtor Tax Code".IndexOf('-') + 1));
            end;
            if (LoadedData."Debtor Address" <> '  ') then begin
                Customer.Validate(Address, LoadedData."Debtor Address".Substring(1, StrLen(LoadedData."Debtor Address") - 5));
                Customer.Validate("Post Code", LoadedData."Debtor Address".Substring(StrLen(LoadedData."Debtor Address") - 5));
            end;
            DWHsetup.Get();
            Customer.Validate("Gen. Bus. Posting Group", DWHsetup."Default Gen. Bus. Post. Group");
            Customer.Validate("VAT Bus. Posting Group", DWHsetup."Default VAT Bus. Posting Group");
            Customer.Validate("Customer Posting Group", DWHsetup."Default Customer Post. Group");
            Customer.Insert();
            SalesHeader.Validate("Sell-to Customer No.", Customer."No.");
        end;
        SalesHeader."Currency Code" := LoadedData."Currency Code";
        SalesHeader.Validate("Posting Description", LoadedData.Description);
        SalesHeader.Validate(Correction, LoadedData.Correction);
        DimensionCode := GetDimension(LoadedData);
        DimensionValues.Init;
        GenLedgerSetup.get();
        DimensionValues.SetRange("Dimension Code", GenLedgerSetup."Global Dimension 1 Code");
        DimensionValues.SetRange(Code, DimensionCode);
        if (DimensionValues.FindFirst) then begin
            SalesHeader."Shortcut Dimension 1 Code" := DimensionCode
        end else begin
            DimensionValues.Init();
            DimensionValues.Validate("Dimension Code", GenLedgerSetup."Global Dimension 1 Code");
            DimensionValues.Validate(Code, DimensionCode);
            DimensionValues.Validate(Name, DimensionCode);
            DimensionValues.Insert();
            SalesHeader."Shortcut Dimension 1 Code" := DimensionCode
        end;
        SalesHeader.Insert();

        SalesLines.Init();
        SalesLines.Validate("Document Type", SalesHeader."Document Type");
        SalesLines."Document No." := SalesHeader."No.";
        SalesLines.Validate("Line No.", 10000);
        SalesLines.Validate(Type, SalesLines.Type::"G/L Account");
        Account.Init();
        DWHsetup.Get();
        Account.SetRange("No.", DWHsetup."Invoice default G/L Account");
        if (Account.FindFirst) then
            SalesLines.Validate("No.", Account."No.");
        SalesLines.Validate(Quantity, LoadedData.Quantity);
        SalesLines.Validate("Unit Price", LoadedData.Amount);
        SalesLines.Insert();
    end;

    procedure AddGenJournalLines(LoadedData: Record "DWH integration log")
    begin
        GenJournal.Init();
        DWHsetup.Get();
        GenJournal.Validate("Journal Template Name", 'GENERAL');
        GenJournal.Validate("Journal Batch Name", 'DEFAULT');
        GenJournal.Validate("Line No.", GenJournal.GetNewLineNo(GenJournal."Journal Template Name", GenJournal."Journal Batch Name"));
        GenJournal.Validate("Posting Date", WorkDate());
        if (LoadedData.DocumentType = LoadedData.DocumentType::" ") then begin
            GenJournal.Validate("Document Type", GenJournal."Document Type"::Invoice);
            GenJournal.Validate("Account Type", GenJournal."Account Type"::"G/L Account");
            GenJournal.Validate("Account No.", DWHsetup."Def. Exp. Debit G/L Account");
            GenJournal.Validate("Bal. Account Type", GenJournal."Bal. Account Type"::"G/L Account");
            GenJournal.Validate("Bal. Account No.", DWHsetup."Def. Exp. Credit G/L Account");
        end else begin
            GenJournal.Validate("Document Type", LoadedData.DocumentType);
            GenJournal.Validate("Account Type", GenJournal."Account Type"::Customer);
            Customer.Init();
            Customer.SetRange(Name, LoadedData."Debtor Name");
            if (Customer.FindFirst) then
                GenJournal.Validate("Account No.", Customer."No.");
            GenJournal.Validate("Bal. Account Type", GenJournal."Bal. Account Type"::"Bank Account");
            GenJournal.Validate("Bal. Account No.", DWHsetup."Default Bank Account");
        end;
        GenJournal.Validate("Document No.", LoadedData."Transaction ID");
        GenJournal.Validate(Description, LoadedData.Description);
        GenJournal.Validate("Case ID", LoadedData."Case ID");
        GenJournal."Currency Code" := LoadedData."Currency Code";
        if (LoadedData.DocumentType = LoadedData.DocumentType::Payment) then
            LoadedData.Amount := (-1) * LoadedData.Amount;
        GenJournal.Validate(Amount, LoadedData.Amount);

        DimensionCode := GetDimension(LoadedData);
        DimensionValues.Init;
        GenLedgerSetup.get();
        DimensionValues.SetRange("Dimension Code", GenLedgerSetup."Global Dimension 1 Code");
        DimensionValues.SetRange(Code, DimensionCode);
        if (DimensionValues.FindFirst) then begin
            GenJournal."Shortcut Dimension 1 Code" := DimensionCode
        end else begin
            DimensionValues.Validate(Code, DimensionCode);
            DimensionValues.Validate(Name, DimensionCode);
            DimensionValues.Insert();
        end;
        GenJournal.Insert();
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

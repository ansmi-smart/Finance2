report 50004 "DWH Data processing"
{
    Caption = 'DWH Loading data';
    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {
        dataitem(DWHintegrationlog; "DWH integration log")
        {
            trigger OnPreDataItem()
            begin
                DWHsetup.Get();
            end;

            trigger OnAfterGetRecord()
            var
                data: Record "DWH integration log";
            begin
                /*if not DWHProcessing.Run(DWHintegrationlog) then begin
                DWHintegrationlog."Processing counter" += 1;
                DWHintegrationlog."Error Massage" := GetLastErrorText();
                DWHintegrationlog.Modify();
                end else begin*/
                if DWHintegrationlog."Processing counter" <= DWHsetup."Max. processing amount" then begin
                    if (DWHintegrationlog.DocumentType = DWHintegrationlog.DocumentType::Invoice) and (DWHintegrationlog.Correction = false) and (DWHintegrationlog.Invoiced = true) then begin
                        CreateSalesDocument(DWHintegrationlog);
                    end else
                        AddGenJournalLines(DWHintegrationlog);
                    data.get(DWHintegrationlog."Entry No.");
                    data.Delete(true);
                end;
                // end;
            end;
        }
    }

    var
        DWHProcessing: Codeunit DWHProcessing;
        Customer: Record Customer;
        DWHsetup: Record "DWH integration setup";
        GenJournal: Record "Gen. Journal Line";
        DimensionCode: Code[20];
        DimensionValues: Record "Dimension Value";
        GenLedgerSetup: Record "General Ledger Setup";
        ValidatedDimCode: Code[20];

    procedure CreateSalesDocument(LoadedData: Record "DWH integration log")
    var
        SalesHeader: Record "Sales Header";
        SalesLines: Record "Sales Line";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        SalesHeader.Init();
        SalesHeader.Validate("No.", NoSeriesMgt.GetNextNo(SalesHeader.GetNoSeriesCode(), LoadedData."Posting Date", true));
        SalesHeader.Validate("Document Type", SalesHeader."Document Type"::Invoice);
        SalesHeader.Validate("Posting Date", LoadedData."Posting Date");
        SalesHeader.Validate("Document Date", LoadedData."Posting Date");
        SalesHeader.Validate("Sell-to Customer No.", GetNoAndCreateCustomer(LoadedData));
        SalesHeader."Currency Code" := LoadedData."Currency Code";
        SalesHeader.Validate("Posting Description", LoadedData.Description);
        SalesHeader.Validate(Correction, LoadedData.Correction);
        if (LoadedData."Flow ID" <> '') then
            ValidatedDimCode := CreteDimension(LoadedData);
        SalesHeader.ValidateShortcutDimCode(GetPotrafoglioFieldNo('PORTAFOGLIO'), ValidatedDimCode);
        ValidatedDimCode := LoadedData."Flow ID";
        SalesHeader.ValidateShortcutDimCode(GetPotrafoglioFieldNo('FLOW'), ValidatedDimCode);
        SalesHeader.Insert();

        SalesLines.Init();
        SalesLines.Validate("Document Type", SalesHeader."Document Type");
        SalesLines."Document No." := SalesHeader."No.";
        SalesLines.Validate("Line No.", 10000);
        SalesLines.Validate(Type, SalesLines.Type::"G/L Account");
        SalesLines.Validate("No.", DWHsetup."Invoice default G/L Account");
        SalesLines.Validate(Quantity, LoadedData.Quantity);
        SalesLines.Validate(Amount, LoadedData.Amount);
        SalesLines.Insert();
    end;

    procedure GetNoAndCreateCustomer(LoadedData: Record "DWH integration log"): Code[20]
    begin
        Customer.SetRange("Fiscal Code", LoadedData."Debtor Tax Code".Substring(1, LoadedData."Debtor Tax Code".IndexOf('-') - 1));
        if (Customer.FindFirst) then
            exit(Customer."No.")
        else begin
            Customer.Init();
            Customer.Get(Customer.CreateNewCustomer(LoadedData."Debtor Name", false));
            Customer."Case ID" := LoadedData."Case ID";
            Customer."Case ID Expiration Date" := LoadedData."Case Expiration Date";
            Customer.SDI := Format(LoadedData.SDI);
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
            Customer.Validate("Gen. Bus. Posting Group", DWHsetup."Default Gen. Bus. Post. Group");
            Customer.Validate("VAT Bus. Posting Group", DWHsetup."Default VAT Bus. Posting Group");
            Customer.Validate("Customer Posting Group", DWHsetup."Default Customer Post. Group");
            Customer.Modify(true);
            exit(Customer."No.")
        end;
    end;

    procedure AddGenJournalLines(LoadedData: Record "DWH integration log")
    begin
        GenJournal.Init();
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
            GenJournal.Validate("Account No.", GetNoAndCreateCustomer(LoadedData));
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
        if (LoadedData."Flow ID" <> '') then
            ValidatedDimCode := CreteDimension(LoadedData);
        GenJournal.ValidateShortcutDimCode(GetPotrafoglioFieldNo('PORTAFOGLIO'), ValidatedDimCode);
        ValidatedDimCode := LoadedData."Flow ID";
        GenJournal.ValidateShortcutDimCode(GetPotrafoglioFieldNo('FLOW'), ValidatedDimCode);
        GenJournal.Insert();
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

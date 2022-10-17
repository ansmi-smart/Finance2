report 50004 "DWH Data processing"
{
    Caption = 'DWH Loading data';
    ProcessingOnly = true;
    UseRequestPage = false;


    trigger OnInitReport()
    begin
        ProcessAllData();
    end;

    procedure ProcessAllData()
    var
        LoadedData: Record "DWH integration log";
        Archive: Record "DWH integration archive log";
        LineNo: Integer;
    begin
        if LoadedData.FindSet() then begin
            repeat
                if (Archive.FindSet()) then
                    LineNo := Archive.Count + 1
                else
                    LineNo := 1;
                Archive.TransferFields(LoadedData, true);
                Archive."Line No." := LineNo;
                Archive.Insert();
                CreateSalesDocument(LoadedData);
                AddGenJournalLines(LoadedData);
                LoadedData.Delete();
            until LoadedData.Next() = 0;
        end;
    end;

    procedure CreateSalesDocument(LoadedData: Record "DWH integration log")
    var
        SalesHeader: Record "Sales Header";
        SalesLines: Record "Sales Line";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Customer: Record Customer;
        DWHsetup: Record "DWH integration setup";
        GenJournal: Record "Gen. Journal Line";
        Account: Record "G/L Account";
    begin
        SalesHeader.Init();
        SalesHeader.Validate("No.", NoSeriesMgt.GetNextNo(SalesHeader.GetNoSeriesCode(), LoadedData.PostingDate, true));
        if (LoadedData.DocumentType = LoadedData.DocumentType::Invoice) and (LoadedData.Correction = false) and (LoadedData.Invoiced = true) then
            SalesHeader.Validate("Document Type", SalesHeader."Document Type"::Invoice)
        else
            SalesHeader.Validate("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.Validate("Posting Date", LoadedData.PostingDate);
        SalesHeader.Validate("Document Date", LoadedData.PostingDate);
        SalesHeader."Shortcut Dimension 1 Code" := GetDimension(LoadedData);
        // dimension flow?*/
        Customer.Init();
        Customer.SetRange(Name, LoadedData.DebtorName);
        if (Customer.FindFirst) then
            SalesHeader.Validate("Sell-to Customer No.", Customer."No.")
        else begin
            Customer.Init();
            Customer."No." := NoSeriesMgt.GetNextNo('CUST', LoadedData.PostingDate, true);
            Customer.Validate(Name, LoadedData.DebtorName);
            Customer.Validate(CaseID, LoadedData.CaseID);
            Customer.Validate("Case ID Expiration Date", LoadedData.CaseExpirationDate);
            Customer.Validate(SDI, Format(LoadedData.SDI));
            if (LoadedData.DebtorTaxCode <> '  ') then begin
                if (LoadedData.DebtorTaxCode.Contains('-')) then begin
                    Customer.Validate("Fiscal Code", LoadedData.DebtorTaxCode.Substring(1, LoadedData.DebtorTaxCode.IndexOf('-') - 1));
                    Customer.Validate("VAT Registration No.", LoadedData.DebtorTaxCode.Substring(LoadedData.DebtorTaxCode.IndexOf('-') + 1));
                end else
                    Customer.Validate("Fiscal Code", LoadedData.DebtorTaxCode);
                Customer.Validate("VAT Registration No.", LoadedData.DebtorTaxCode.Substring(LoadedData.DebtorTaxCode.IndexOf('-') + 1));
            end;
            if (LoadedData.DebtorAddress <> '  ') then begin
                Customer.Validate(Address, LoadedData.DebtorAddress.Substring(1, StrLen(LoadedData.DebtorAddress) - 5));
                Customer.Validate("Post Code", LoadedData.DebtorAddress.Substring(StrLen(LoadedData.DebtorAddress) - 5));
            end;
            DWHsetup.Get();
            Customer.Validate("Gen. Bus. Posting Group", DWHsetup."Default Gen. Bus. Post. Group");
            Customer.Validate("VAT Bus. Posting Group", DWHsetup."Default VAT Bus. Posting Group");
            Customer.Validate("Customer Posting Group", DWHsetup."Default Customer Post. Group ");
            Customer.Insert();
            SalesHeader.Validate("Sell-to Customer No.", Customer."No.");
        end;
        SalesHeader."Currency Code" := LoadedData.CurrencyCode;
        SalesHeader.Validate("Posting Description", LoadedData.Description);
        SalesHeader.Validate(Correction, LoadedData.Correction);
        SalesHeader.Insert();

        SalesLines.Init();
        SalesLines.Validate("Document Type", SalesHeader."Document Type");
        SalesLines."Document No." := SalesHeader."No.";
        SalesLines.Validate("Line No.", 10000);
        SalesLines.Validate(Type, SalesLines.Type::"G/L Account");
        Account.SetRange("No.", DWHsetup."Invoice default G/L Account");
        SalesLines."No." := Account."No.";
        SalesLines.Validate(Quantity, LoadedData.Quantity);
        SalesLines.Validate("Unit Price", LoadedData.Amount);
        SalesLines.Insert();
    end;

    procedure GetDimension(LoadedData: Record "DWH integration log"): Code[20]
    begin

    end;

    procedure AddGenJournalLines(LoadedData: Record "DWH integration log")
    var
        Customer: Record Customer;
        DWHsetup: Record "DWH integration setup";
        GenJournal: Record "Gen. Journal Line";
    begin
        GenJournal.Init();
        DWHsetup.Get();
        GenJournal.Validate("Journal Template Name", 'GENERAL');
        GenJournal.Validate("Journal Batch Name", 'DEFAULT');
        GenJournal.Validate("Line No.", 10000 * (GenJournal.Count + 1));
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
            Customer.SetRange(Name, LoadedData.DebtorName);
            if (Customer.FindFirst) then
                GenJournal.Validate("Account No.", Customer."No.");
            GenJournal.Validate("Bal. Account Type", GenJournal."Bal. Account Type"::"Bank Account");
            GenJournal.Validate("Bal. Account No.", DWHsetup."Default Bank Account");
        end;
        GenJournal.Validate("Document No.", LoadedData.TransactionID);
        GenJournal.Validate(Description, LoadedData.Description);
        GenJournal.Validate(CaseID, LoadedData.CaseID);
        GenJournal."Currency Code" := LoadedData.CurrencyCode;
        if (LoadedData.DocumentType = LoadedData.DocumentType::Payment) then
            LoadedData.Amount := (-1) * LoadedData.Amount;
        GenJournal.Validate(Amount, LoadedData.Amount);
        GenJournal.Insert();
    end;
}

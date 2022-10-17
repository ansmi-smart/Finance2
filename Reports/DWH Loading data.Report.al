report 50003 "DWH Loading data"
{
    Caption = 'DWH Loading data';
    ApplicationArea = all;
    UsageCategory = Documents;
    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {
        dataitem("DWH integration log"; "DWH integration log")
        {

        }
    }
    trigger OnPreReport()
    begin
        Import();
    end;

    procedure Import()
    var
        Buffer: Record "Excel Buffer" temporary;
        InS: InStream;
        Filename: Text;
        Row: Integer;
        LastRow: Integer;
        GenJnlAcc: Enum "Gen. Journal Account Type";
        TempData: Text;
    begin
        if UploadIntoStream('Choose .xls file for import', '', '', Filename, InS) then begin
            Buffer.OpenBookStream(InS, 'Sheet1');
            Buffer.ReadSheet();
            Buffer.setrange("Column No.", 4);
            Buffer.FindLast();
            LastRow := Buffer."Row No.";
            Buffer.Reset();
            "DWH integration log".Init();
            for Row := 2 to LastRow do begin
                "DWH integration log"."Line No." := "DWH integration log".Count + GetNumber(Buffer, 1, Row);
                "DWH integration log".DebtorName := GetText(Buffer, 2, Row);
                "DWH integration log".DebtorTaxCode := GetText(Buffer, 3, Row);
                "DWH integration log".DebtorAddress := GetText(Buffer, 4, Row);
                "DWH integration log".CaseID := GetText(Buffer, 5, Row);
                "DWH integration log".CaseExpirationDate := GetDate(Buffer, 6, Row);
                "DWH integration log".SDI := 0000000;
                EVALUATE("DWH integration log".DocumentType, GetText(Buffer, 8, Row));
                "DWH integration log".TransactionID := GetText(Buffer, 9, Row);
                "DWH integration log".PortfolioID := GetText(Buffer, 10, Row);
                "DWH integration log".PortfolioName := GetText(Buffer, 11, Row);
                "DWH integration log".BatchID := GetText(Buffer, 12, Row);
                "DWH integration log".BatchName := GetText(Buffer, 13, Row);
                "DWH integration log".SegmentID := GetText(Buffer, 14, Row);
                "DWH integration log".SegmentName := GetText(Buffer, 15, Row);
                "DWH integration log".FlowID := GetText(Buffer, 16, Row);
                "DWH integration log".PostingDate := GetDate(Buffer, 17, Row);
                "DWH integration log".CurrencyCode := GetText(Buffer, 18, Row);
                "DWH integration log".Description := GetText(Buffer, 19, Row);
                "DWH integration log"."G\L Local Account" := GetText(Buffer, 20, Row);
                "DWH integration log".Amount := GetNumber(Buffer, 22, Row);
                EVALUATE("DWH integration log".AccountType, GetText(Buffer, 23, Row));
                "DWH integration log".AccountNo := GetText(Buffer, 24, Row);
                EVALUATE("DWH integration log"."Bal. AccountType", GetText(Buffer, 25, Row));
                "DWH integration log"."Bal. AccountNo" := GetText(Buffer, 26, Row);
                "DWH integration log".Correction := GetBoolean(Buffer, 27, Row);
                "DWH integration log".Invoiced := GetBoolean(Buffer, 28, Row);
                TempData := GetText(Buffer, 29, Row);
                if (TempData = 'Error - both empty') then TempData := ' ';
                EVALUATE("DWH integration log"."Meta Check", TempData);
                "DWH integration log"."Meta Marte Insert Date" := GetDateTime(Buffer, 30, Row);
                "DWH integration log"."Meta DWH Insert Date" := GetDateTime(Buffer, 31, Row);
                "DWH integration log".Insert();
            end;
        end;
    end;

    procedure GetText(var Buffer: Record "Excel Buffer" temporary; Col: Integer; Row: Integer): Text
    begin
        if Buffer.Get(Row, col) then
            if (Buffer."Cell Value as Text" <> 'NULL') then
                exit(Buffer."Cell Value as Text")
            else
                exit(' ');
    end;

    procedure GetNumber(var Buffer: Record "Excel Buffer" temporary; Col: Integer; Row: Integer): Decimal
    var
        D: Decimal;
    begin
        if Buffer.Get(Row, Col) then begin
            Evaluate(d, Buffer."Cell Value as Text");
            exit(d);
        end;

    end;

    procedure GetBoolean(var Buffer: Record "Excel Buffer" temporary; Col: Integer; Row: Integer): Boolean
    begin
        if Buffer.Get(Row, col) then
            if Buffer."Cell Value as Text" = '1' then
                exit(true)
            else
                exit(false);
    end;

    procedure GetDate(var Buffer: Record "Excel Buffer" temporary; Col: Integer; Row: Integer): Date
    var
        D: Date;
    begin
        if Buffer.Get(Row, col) then begin
            if (Buffer."Cell Value as Text" <> 'NULL') then
                Evaluate(D, Buffer."Cell Value as Text");
            exit(D);
        end;
    end;

    procedure GetDateTime(var Buffer: Record "Excel Buffer" temporary; Col: Integer; Row: Integer): DateTime
    var
        DT: DateTime;
        Day, Month, Year : Integer;
        TheTime: Time;
    begin
        if Buffer.Get(Row, col) then begin
            if (Buffer."Cell Value as Text" <> 'NULL') then begin
                evaluate(Day, copystr(Buffer."Cell Value as Text", 6, 2));
                evaluate(Month, copystr(Buffer."Cell Value as Text", 9, 2));
                evaluate(Year, copystr(Buffer."Cell Value as Text", 1, 4));
                evaluate(TheTime, copystr(Buffer."Cell Value as Text", 12, 12));
                DT := createdatetime(DMY2DATE(Day, Month, Year), TheTime);
                exit(DT);
            end;
        end;
    end;
}

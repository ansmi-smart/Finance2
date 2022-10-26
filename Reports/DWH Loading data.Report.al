report 50003 "DWH Loading data"
{
    Caption = 'DWH Loading data';
    ApplicationArea = all;
    UsageCategory = Documents;
    ProcessingOnly = true;
    UseRequestPage = false;

    trigger OnPreReport()
    begin
        Import();
    end;

    var
        DWHintegrationlog: Record "DWH integration log";

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
            DWHintegrationlog.Init();
            for Row := 2 to LastRow do begin
                DWHintegrationlog."Entry No." := 0;
                DWHintegrationlog."Debtor Name" := GetText(Buffer, 2, Row);
                DWHintegrationlog."Debtor Tax Code" := GetText(Buffer, 3, Row);
                DWHintegrationlog."Debtor Address" := GetText(Buffer, 4, Row);
                DWHintegrationlog."Case ID" := GetText(Buffer, 5, Row);
                DWHintegrationlog."Case Expiration Date" := GetDate(Buffer, 6, Row);
                DWHintegrationlog.SDI := 0000000;
                EVALUATE(DWHintegrationlog.DocumentType, GetText(Buffer, 8, Row));
                DWHintegrationlog."Transaction ID" := GetText(Buffer, 9, Row);
                DWHintegrationlog."Portfolio ID" := GetText(Buffer, 10, Row);
                DWHintegrationlog."Portfolio Name" := GetText(Buffer, 11, Row);
                DWHintegrationlog."Batch ID" := GetText(Buffer, 12, Row);
                DWHintegrationlog."Batch Name" := GetText(Buffer, 13, Row);
                DWHintegrationlog."Segment ID" := GetText(Buffer, 14, Row);
                DWHintegrationlog."Segment Name" := GetText(Buffer, 15, Row);
                DWHintegrationlog."Flow ID" := GetText(Buffer, 16, Row);
                DWHintegrationlog."Posting Date" := GetDate(Buffer, 17, Row);
                DWHintegrationlog."Currency Code" := GetText(Buffer, 18, Row);
                DWHintegrationlog.Description := GetText(Buffer, 19, Row);
                DWHintegrationlog."G\L Local Account" := GetText(Buffer, 20, Row);
                DWHintegrationlog.Amount := GetNumber(Buffer, 22, Row);
                EVALUATE(DWHintegrationlog."Account Type", GetText(Buffer, 23, Row));
                DWHintegrationlog."Account No." := GetText(Buffer, 24, Row);
                EVALUATE(DWHintegrationlog."Bal. Account Type", GetText(Buffer, 25, Row));
                DWHintegrationlog."Bal. Account No." := GetText(Buffer, 26, Row);
                DWHintegrationlog.Correction := GetBoolean(Buffer, 27, Row);
                DWHintegrationlog.Invoiced := GetBoolean(Buffer, 28, Row);
                TempData := GetText(Buffer, 29, Row);
                if (TempData = 'Error - both empty') then TempData := ' ';
                EVALUATE(DWHintegrationlog."Meta Check", TempData);
                DWHintegrationlog."Meta Marte Insert Date" := GetDateTime(Buffer, 30, Row);
                DWHintegrationlog."Meta DWH Insert Date" := GetDateTime(Buffer, 31, Row);
                DWHintegrationlog."Processing counter" := 0;
                DWHintegrationlog.Insert();
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

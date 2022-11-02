report 50003 "DWH Loading data"
{
    Caption = 'DWH Loading data';
    ApplicationArea = all;
    UsageCategory = Documents;
    ProcessingOnly = true;
    UseRequestPage = false;

    trigger OnPreReport()
    begin
        //Import();
        GetDataFromAPI();
    end;

    var
        DWHintegrationlog: Record "DWH integration log";

    procedure GetDataFromAPI()
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        ImportURL: Text;
        DWHSetup: Record "DWH integration setup";
        ResponseString: Text;
        ResponseArray: JsonArray;
        ResponseObject: JsonObject;
        JToken: JsonToken;
        i: Integer;
        TempDate: Text;
    begin
        DWHSetup.FindFirst();
        ImportURL := DWHSetup."Api URL" + '2022-10-27?code=' + DWHSetup."Authorization Code";
        Client.DefaultRequestHeaders.Add('Accept', 'application/Json');
        Client.Get(ImportURL, Response);
        if Response.IsSuccessStatusCode then begin
            Response.Content().ReadAs(ResponseString);
            ResponseString := ResponseString.Replace('gL\\Local Account', 'GLAccount');
            ResponseArray.ReadFrom(ResponseString);
            for i := 0 to 1 do begin
                ResponseArray.Get(i, JToken);
                ResponseObject := JToken.AsObject();
                DWHintegrationlog.Init();
                DWHintegrationlog."Entry No." := 0;
                DWHintegrationlog."Debtor Name" := GetJsonToken(ResponseObject, 'debtorName').AsValue().AsText();
                DWHintegrationlog."Debtor Tax Code" := GetJsonToken(ResponseObject, 'debtorTaxCode').AsValue().AsText();
                DWHintegrationlog."Debtor Address" := GetJsonToken(ResponseObject, 'debtorAddress').AsValue().AsText();
                DWHintegrationlog."Case ID" := GetJsonToken(ResponseObject, 'caseID').AsValue().AsText();
                TempDate := GetJsonToken(ResponseObject, 'caseExpirationDate').AsValue().AsText();
                Evaluate(DWHintegrationlog."Case Expiration Date", TempDate.Substring(1, 10));
                DWHintegrationlog.SDI := GetJsonToken(ResponseObject, 'sdi').AsValue().AsInteger();
                if (Format(GetJsonToken(ResponseObject, 'portfolioID').AsValue()) <> 'null') then
                    EVALUATE(DWHintegrationlog.DocumentType, GetJsonToken(ResponseObject, 'documentType').AsValue().AsText());
                DWHintegrationlog."Transaction ID" := GetJsonToken(ResponseObject, 'transactionID').AsValue().AsText();
                if (Format(GetJsonToken(ResponseObject, 'portfolioID').AsValue()) <> 'null') then
                    DWHintegrationlog."Portfolio ID" := GetJsonToken(ResponseObject, 'portfolioID').AsValue().AsText();
                if (Format(GetJsonToken(ResponseObject, 'portfolioName').AsValue()) <> 'null') then
                    DWHintegrationlog."Portfolio Name" := GetJsonToken(ResponseObject, 'portfolioName').AsValue().AsText();
                if (Format(GetJsonToken(ResponseObject, 'batchID').AsValue()) <> 'null') then
                    DWHintegrationlog."Batch ID" := GetJsonToken(ResponseObject, 'batchID').AsValue().AsText();
                if (Format(GetJsonToken(ResponseObject, 'batchName').AsValue()) <> 'null') then
                    DWHintegrationlog."Batch Name" := GetJsonToken(ResponseObject, 'batchName').AsValue().AsText();
                if (Format(GetJsonToken(ResponseObject, 'segmentID').AsValue()) <> 'null') then
                    DWHintegrationlog."Segment ID" := GetJsonToken(ResponseObject, 'segmentID').AsValue().AsText();
                if (Format(GetJsonToken(ResponseObject, 'segmentName').AsValue()) <> 'null') then
                    DWHintegrationlog."Segment Name" := GetJsonToken(ResponseObject, 'segmentName').AsValue().AsText();
                DWHintegrationlog."Flow ID" := GetJsonToken(ResponseObject, 'flowID').AsValue().AsText();
                TempDate := GetJsonToken(ResponseObject, 'postingDate').AsValue().AsText();
                Evaluate(DWHintegrationlog."Posting Date", TempDate.Substring(1, 10));
                if (Format(GetJsonToken(ResponseObject, 'currencyCode').AsValue()) <> 'null') then
                    DWHintegrationlog."Currency Code" := GetJsonToken(ResponseObject, 'currencyCode').AsValue().AsText();
                if (Format(GetJsonToken(ResponseObject, 'description').AsValue()) <> 'null') then
                    DWHintegrationlog.Description := GetJsonToken(ResponseObject, 'description').AsValue().AsText();
                if (Format(GetJsonToken(ResponseObject, 'GLAccount').AsValue()) <> 'null') then
                    DWHintegrationlog."G\L Local Account" := GetJsonToken(ResponseObject, 'GLAccount').AsValue().AsText();
                if (Format(GetJsonToken(ResponseObject, 'quantity').AsValue()) <> 'null') then
                    DWHintegrationlog.Quantity := GetJsonToken(ResponseObject, 'quantity').AsValue().AsInteger();
                if (Format(GetJsonToken(ResponseObject, 'amount').AsValue()) <> 'null') then
                    DWHintegrationlog.Amount := GetJsonToken(ResponseObject, 'amount').AsValue().AsDecimal();
                EVALUATE(DWHintegrationlog."Account Type", GetJsonToken(ResponseObject, 'accountType').AsValue().AsText());
                DWHintegrationlog."Account No." := GetJsonToken(ResponseObject, 'accountNo').AsValue().AsText();
                if (Format(GetJsonToken(ResponseObject, 'bal AccountType').AsValue()) <> 'null') then
                    EVALUATE(DWHintegrationlog."Bal. Account Type", GetJsonToken(ResponseObject, 'bal AccountType').AsValue().AsText());
                if (Format(GetJsonToken(ResponseObject, 'bal AccountNo').AsValue()) <> 'null') then
                    DWHintegrationlog."Bal. Account No." := GetJsonToken(ResponseObject, 'bal AccountNo').AsValue().AsText();
                if (GetJsonToken(ResponseObject, 'correction').AsValue().AsInteger() = 1) then
                    DWHintegrationlog.Correction := true
                else
                    DWHintegrationlog.Correction := false;

                if (GetJsonToken(ResponseObject, 'invoiced').AsValue().AsInteger() = 1) then
                    DWHintegrationlog.Invoiced := true
                else
                    DWHintegrationlog.Invoiced := false;
                EVALUATE(DWHintegrationlog."Meta Check", GetJsonToken(ResponseObject, 'meta_Chck').AsValue().AsText());
                DWHintegrationlog."Meta Marte Insert Date" := GetJsonToken(ResponseObject, 'meta_MarteInsertDate').AsValue().AsDateTime();
                DWHintegrationlog."Meta DWH Insert Date" := GetJsonToken(ResponseObject, 'meta_DWHInsertDate').AsValue().AsDateTime();
                DWHintegrationlog.Insert();
            end;
        end;
    end;

    procedure GetJsonToken(JObject: JsonObject; TokenKey: text) JsonToken: JsonToken
    begin
        if not JObject.Get(TokenKey, JsonToken) then
            Error('No such token with key %1', TokenKey);
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

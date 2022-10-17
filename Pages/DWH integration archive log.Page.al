page 50005 "DWH integration archive log"
{
    Caption = 'DWH integration archive log';
    ApplicationArea = all;
    UsageCategory = Lists;
    PageType = List;
    SourceTable = "DWH integration archive log";
    //Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(DebtorName; Rec."Debtor Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Debtor Name field.';
                }
                field(DebtorTaxCode; Rec."Debtor Tax Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Debtor Tax Code field.';
                }
                field(DebtorAddress; Rec."Debtor Address")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Debtor Address field.';
                }
                field(CaseID; Rec."Case ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Case ID field.';
                }
                field(CaseExpirationDate; Rec."Case Expiration Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Case Expiration Date field.';
                }
                field(SDI; Rec.SDI)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SDI field.';
                }
                field(DocumentType; Rec."Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document Type field.';
                }
                field(TransactionID; Rec."Transaction ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transaction ID field.';
                }
                field(PortfolioID; Rec."Portfolio ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Portfolio ID field.';
                }
                field(PortfolioName; Rec."Portfolio Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Portfolio Name field.';
                }
                field(BatchID; Rec."Batch ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Batch ID field.';
                }
                field(BatchName; Rec."Batch Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Batch Name field.';
                }
                field(SegmentID; Rec."Segment ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Segment ID field.';
                }
                field(SegmentName; Rec."Segment Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Segment Name field.';
                }
                field(FlowID; Rec."Flow ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Flow ID field.';
                }
                field(PostingDate; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }
                field(CurrencyCode; Rec."Currency Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Currency Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("GL\Local Account"; Rec."G\L Local Account")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the G\L Local Account field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field(AccountType; Rec."Account Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account Type field.';
                }
                field(AccountNo; Rec."Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Account No. field.';
                }
                field("Bal. AccountType"; Rec."Bal. Account Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bal. Account Type field.';
                }
                field("Bal. AccountNo"; Rec."Bal. Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bal. Account No. field.';
                }
                field(Correction; Rec.Correction)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Correction field.';
                }
                field(Invoiced; Rec.Invoiced)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Invoiced field.';
                }
                field(meta_Chck; Rec."Meta Check")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Meta Check field.';
                }
                field(meta_MarteInsertDate; Rec."Meta Marte Insert Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Meta Marte Insert Date field.';
                }
                field(meta_DWHInsertDate; Rec."Meta DWH Insert Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Meta DWH Insert Date field.';
                }
            }

        }
    }

    actions
    {
        area(Processing)
        {
            action("Transfer data from archive to Log")
            {
                Caption = 'Transfer data from archive to Log';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    Archive: Page "DWH integration archive log";
                    LoadedData: Record "DWH integration log";
                    LineNo: Integer;
                begin
                    CurrPage.SetSelectionFilter(Rec);
                    Rec.FindSet();

                    repeat
                        if LoadedData.FindSet() then
                            LineNo := LoadedData.Count + 1
                        else
                            LineNo := 1;
                        LoadedData.TransferFields(Rec, true);
                        LoadedData."Line No." := LineNo;
                        LoadedData.Insert();
                        Rec.Delete();
                    until Rec.Next() = 0;
                end;
            }
        }
    }

}

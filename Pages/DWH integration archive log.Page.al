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
                }
                field(DebtorTaxCode; Rec."Debtor Tax Code")
                {
                    ApplicationArea = All;
                }
                field(DebtorAddress; Rec."Debtor Address")
                {
                    ApplicationArea = All;
                }
                field(CaseID; Rec."Case ID")
                {
                    ApplicationArea = All;
                }
                field(CaseExpirationDate; Rec."Case Expiration Date")
                {
                    ApplicationArea = All;
                }
                field(SDI; Rec.SDI)
                {
                    ApplicationArea = All;
                }
                field(DocumentType; Rec."Document Type")
                {
                    ApplicationArea = All;
                }
                field(TransactionID; Rec."Transaction ID")
                {
                    ApplicationArea = All;
                }
                field(PortfolioID; Rec."Portfolio ID")
                {
                    ApplicationArea = All;
                }
                field(PortfolioName; Rec."Portfolio Name")
                {
                    ApplicationArea = All;
                }
                field(BatchID; Rec."Batch ID")
                {
                    ApplicationArea = All;
                }
                field(BatchName; Rec."Batch Name")
                {
                    ApplicationArea = All;
                }
                field(SegmentID; Rec."Segment ID")
                {
                    ApplicationArea = All;
                }
                field(SegmentName; Rec."Segment Name")
                {
                    ApplicationArea = All;
                }
                field(FlowID; Rec."Flow ID")
                {
                    ApplicationArea = All;
                }
                field(PostingDate; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field(CurrencyCode; Rec."Currency Code")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("GL\Local Account"; Rec."G\L Local Account")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field(AccountType; Rec."Account Type")
                {
                    ApplicationArea = All;
                }
                field(AccountNo; Rec."Account No.")
                {
                    ApplicationArea = All;
                }
                field("Bal. AccountType"; Rec."Bal. Account Type")
                {
                    ApplicationArea = All;
                }
                field("Bal. AccountNo"; Rec."Bal. Account No.")
                {
                    ApplicationArea = All;
                }
                field(Correction; Rec.Correction)
                {
                    ApplicationArea = All;
                }
                field(Invoiced; Rec.Invoiced)
                {
                    ApplicationArea = All;
                }
                field(meta_Chck; Rec."Meta Check")
                {
                    ApplicationArea = All;
                }
                field(meta_MarteInsertDate; Rec."Meta Marte Insert Date")
                {
                    ApplicationArea = All;
                }
                field(meta_DWHInsertDate; Rec."Meta DWH Insert Date")
                {
                    ApplicationArea = All;
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

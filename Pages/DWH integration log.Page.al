page 50001 "DWH integration log"
{
    Caption = 'DWH integration log';
    ApplicationArea = all;
    UsageCategory = Lists;
    PageType = List;
    SourceTable = "DWH integration log";

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
                field(DocumentType; Rec.DocumentType)
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
                field("Processing counter"; Rec."Processing counter")
                {
                    ApplicationArea = All;
                }
                field("Error Massage"; Rec."Error Massage")
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
            action("Process all data")
            {
                Caption = 'Process all data';
                Promoted = true;
                PromotedCategory = Process;
                Image = ImportExcel;
                RunObject = report "DWH Data processing";
            }
        }
    }
}

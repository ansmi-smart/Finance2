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
                field(DocumentType; Rec.DocumentType)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the DocumentType field.';
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
            action("Process all data")
            {
                Caption = 'Process all data';
                Promoted = true;
                PromotedCategory = Process;
                Image = ImportExcel;

                trigger OnAction()
                var
                    ProcessData: Report "DWH Data processing";
                begin
                    ProcessData.ProcessAllData();
                end;
            }
        }
    }
}

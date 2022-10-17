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
                field(DebtorName; Rec.DebtorName)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the DebtorName field.';
                }
                field(DebtorTaxCode; Rec.DebtorTaxCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the DebtorTaxCode field.';
                }
                field(DebtorAddress; Rec.DebtorAddress)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the DebtorAddress field.';
                }
                field(CaseID; Rec.CaseID)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the CaseID field.';
                }
                field(CaseExpirationDate; Rec.CaseExpirationDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the CaseExpirationDate field.';
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
                field(TransactionID; Rec.TransactionID)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the TransactionID field.';
                }
                field(PortfolioID; Rec.PortfolioID)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the PortfolioID field.';
                }
                field(PortfolioName; Rec.PortfolioName)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the PortfolioName field.';
                }
                field(BatchID; Rec.BatchID)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the BatchID field.';
                }
                field(BatchName; Rec.BatchName)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the BatchName field.';
                }
                field(SegmentID; Rec.SegmentID)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SegmentID field.';
                }
                field(SegmentName; Rec.SegmentName)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SegmentName field.';
                }
                field(FlowID; Rec.FlowID)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the FlowID field.';
                }
                field(PostingDate; Rec.PostingDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the PostingDate field.';
                }
                field(CurrencyCode; Rec.CurrencyCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the CurrencyCode field.';
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
                field(AccountType; Rec.AccountType)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the AccountType field.';
                }
                field(AccountNo; Rec.AccountNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the AccountNo field.';
                }
                field("Bal. AccountType"; Rec."Bal. AccountType")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bal. AccountType field.';
                }
                field("Bal. AccountNo"; Rec."Bal. AccountNo")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bal. AccountNo field.';
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

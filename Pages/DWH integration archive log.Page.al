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
                field(meta_Chck; Rec.meta_Chck)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the meta_Chck field.';
                }
                field(meta_MarteInsertDate; Rec.meta_MarteInsertDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the meta_MarteInsertDate field.';
                }
                field(meta_DWHInsertDate; Rec.meta_DWHInsertDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the meta_DWHInsertDate field.';
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

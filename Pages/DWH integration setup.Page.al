page 50007 "DWH integration setup"
{
    Caption = 'DWH integration setup';
    PageType = Card;
    SourceTable = "DWH integration setup";
    ApplicationArea = all;
    UsageCategory = Administration;
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Api URL"; Rec."Api URL")
                {
                    ApplicationArea = All;
                }
                field(Login; Rec.Login)
                {
                    ApplicationArea = All;
                }
                field(Password; Rec.Password)
                {
                    ApplicationArea = All;
                }
                field("Default Gen. Bus. Post. Group"; Rec."Default Gen. Bus. Post. Group")
                {
                    ApplicationArea = All;
                }
                field("Default VAT Bus. Posting Group"; Rec."Default VAT Bus. Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Default Customer Post. Group "; Rec."Default Customer Post. Group")
                {
                    ApplicationArea = All;
                }
                field("Expense Gen. Journal Template "; Rec."Expense Gen. Journal Template")
                {
                    ApplicationArea = All;
                }
                field("Expense General Journal Batch "; Rec."Expense General Journal Batch")
                {
                    ApplicationArea = All;
                }
                field("Payments Gen. Journal Template"; Rec."Payments Gen. Journal Template")
                {
                    ApplicationArea = All;
                }
                field("Payments Gen. Journal Batch "; Rec."Payments Gen. Journal Batch")
                {
                    ApplicationArea = All;
                }
                field("Invoice default G/L Account"; Rec."Invoice default G/L Account")
                {
                    ApplicationArea = All;
                }
                field("Default Bank Account"; Rec."Default Bank Account")
                {
                    ApplicationArea = All;
                }
                field("Def. Exp. Debit G/L Account"; Rec."Def. Exp. Debit G/L Account")
                {
                    ApplicationArea = All;
                }
                field("Def. Exp. Credit G/L Account "; Rec."Def. Exp. Credit G/L Account")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}

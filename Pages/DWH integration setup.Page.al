page 50007 "DWH integration setup"
{
    Caption = 'DWH integration setup';
    PageType = Card;
    SourceTable = "DWH integration setup";
    ApplicationArea = all;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Api URL"; Rec."Api URL")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Api URL field.';
                }
                field(Login; Rec.Login)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Login field.';
                }
                field(Password; Rec.Password)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Api URL field.';
                }
                field("Default Gen. Bus. Post. Group"; Rec."Default Gen. Bus. Post. Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Default Gen. Bus. Posting Group field.';
                }
                field("Default VAT Bus. Posting Group"; Rec."Default VAT Bus. Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Default VAT Bus. Posting Group field.';
                }
                field("Default Customer Post. Group "; Rec."Default Customer Post. Group ")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Default Customer Posting Group  field.';
                }
                field("Expense Gen. Journal Template "; Rec."Expense Gen. Journal Template ")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Expense General Journal Template  field.';
                }
                field("Expense General Journal Batch "; Rec."Expense General Journal Batch ")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Expense General Journal Batch  field.';
                }
                field("Payments Gen. Journal Template"; Rec."Payments Gen. Journal Template")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payments General Journal Template field.';
                }
                field("Payments Gen. Journal Batch "; Rec."Payments Gen. Journal Batch ")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payments General Journal Batch  field.';
                }
                field("Invoice default G/L Account"; Rec."Invoice default G/L Account")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Invoice default G/L Account field.';
                }
                field("Default Bank Account"; Rec."Default Bank Account")
                {

                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Invoice default Default Bank Account field.';
                }
                field("Def. Exp. Debit G/L Account"; Rec."Def. Exp. Debit G/L Account")
                {

                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Default Expenses Debit G/L Account field.';
                }
                field("Def. Exp. Credit G/L Account "; Rec."Def. Exp. Credit G/L Account")
                {

                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Default Expenses Credit G/L Account field.';
                }
            }
        }
    }
}

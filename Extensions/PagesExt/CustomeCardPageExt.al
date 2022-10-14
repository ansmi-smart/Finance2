pageextension 50008 "Custome Card Page Ext." extends "Customer Card"
{

    layout
    {
        addafter("No.")
        {
            field(CaseID; Rec.CaseID)
            {
                Caption = 'Case ID';
            }
        }
    }
    actions
    {
        addlast(Approval)
        {
            action("Clear client's personal data")
            {
                Caption = 'Clear client`s personal data';
                Image = Check;
                Promoted = true;
                PromotedCategory = Category5;
                trigger OnAction()
                begin
                    Message('test');
                end;
            }
        }
    }
}

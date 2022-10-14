pageextension 50008 "Custome Card Page Ext." extends "Customer Card"
{
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

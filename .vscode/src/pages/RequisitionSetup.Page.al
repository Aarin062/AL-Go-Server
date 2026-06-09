page 50106 "Custom Requisition Setup"
{
    PageType = Card;
    SourceTable = "Custom Requisition Setup";
    UsageCategory = Administration;
    ApplicationArea = All;
    Caption = 'Custom Requisition Setup';

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Requisition Nos."; Rec."Requisition Nos.") { ApplicationArea = All; }
            }
        }
    }

    // 💡 This trigger automatically forces the single row to exist when the page opens!
    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}
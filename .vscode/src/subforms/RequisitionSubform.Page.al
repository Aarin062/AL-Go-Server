page 50101 "Requisition Subform"
{
    PageType = ListPart;
    SourceTable = "Custom Requisition Line";
    Caption = 'Lines';
    AutoSplitKey = true; // Auto-generates Line Nos.

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Item No."; Rec."Item No.") { ApplicationArea = All; }
                field(Description; Rec.Description) 
                { 
                    ApplicationArea = All; 
                    Editable = false; // Auto-filled
                }
                field(Quantity; Rec.Quantity) { ApplicationArea = All; }
                field("Unit Price"; Rec."Unit Price") { ApplicationArea = All; }
                field("Line Amount"; Rec."Line Amount") { ApplicationArea = All; }
            }
        }
    }
}
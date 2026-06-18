page 50104 "Fuel Log Card"
{
    PageType = Card;
    SourceTable = "Fuel Log";
    Caption = 'Fuel Log Entry';

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General Information';
                field("Log No."; Rec."Log No.") { ApplicationArea = All; }
                field("Vehicle No."; Rec."Vehicle No.") { ApplicationArea = All; }
                field("Driver No."; Rec."Driver No.") { ApplicationArea = All; }
                field("Date"; Rec."Date") { ApplicationArea = All; }
            }
            group(FuelDetails)
            {
                Caption = 'Fuel & Odometer Details';
                field("Current Odometer Reading"; Rec."Current Odometer Reading") { ApplicationArea = All; }
                field("Fuel Type"; Rec."Fuel Type") { ApplicationArea = All; }
                field(Quantity; Rec.Quantity) { ApplicationArea = All; }
                field("Price per Liter"; Rec."Price per Liter") { ApplicationArea = All; }
                
                field("Total Amount"; Rec."Total Amount") 
                { 
                    ApplicationArea = All; 
                    Style = Strong; 
                }
            }
        }
    }
}
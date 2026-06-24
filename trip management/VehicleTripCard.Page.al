page 50106 "Vehicle Trip Card"
{
    PageType = Card;
    SourceTable = "Vehicle Trip";
    Caption = 'Trip Detail';

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General Information';
                field("Trip No."; Rec."Trip No.") { ApplicationArea = All; }
                field("Vehicle No."; Rec."Vehicle No.") { ApplicationArea = All; }
                field("Driver No."; Rec."Driver No.") { ApplicationArea = All; }
                field(Purpose; Rec.Purpose) { ApplicationArea = All; MultiLine = true; }
            }
            group(RouteAndDates)
            {
                Caption = 'Route & Schedule';
                field("Start Date"; Rec."Start Date") { ApplicationArea = All; }
                field("End Date"; Rec."End Date") { ApplicationArea = All; }
                field(Source; Rec.Source) { ApplicationArea = All; }
                field(Destination; Rec.Destination) { ApplicationArea = All; }
            }
            group(Mileage)
            {
                Caption = 'Odometer Tracking';
                field("Start Kilometer"; Rec."Start Kilometer") { ApplicationArea = All; }
                field("End Kilometer"; Rec."End Kilometer") { ApplicationArea = All; }
                field("Total Distance"; Rec."Total Distance") 
                { 
                    ApplicationArea = All; 
                    Style = Strong; 
                }
            }
        }
    }
}
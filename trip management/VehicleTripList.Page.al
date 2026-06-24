page 50107 "Vehicle Trip List"
{
    PageType = List;
    SourceTable = "Vehicle Trip";
    CardPageId = "Vehicle Trip Card";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Vehicle Trips';
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Trip No."; Rec."Trip No.") { ApplicationArea = All; }
                field("Vehicle No."; Rec."Vehicle No.") { ApplicationArea = All; }
                field("Driver No."; Rec."Driver No.") { ApplicationArea = All; }
                field("Start Date"; Rec."Start Date") { ApplicationArea = All; }
                field(Destination; Rec.Destination) { ApplicationArea = All; }
                field("Total Distance"; Rec."Total Distance") { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ImportTrips)
            {
                ApplicationArea = All;
                Caption = 'Import Trips (CSV)';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = xmlport "Import Vehicle Trips";
            }
        }
    }
}
page 50101 "Company Vehicle List"
{
    PageType = List;
    SourceTable = "Company Vehicle";
    CardPageId = "Company Vehicle Card";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Company Vehicles';
    Editable = false; // Force users to edit via the Card page

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Vehicle No."; Rec."Vehicle No.")
                {
                    ApplicationArea = All;
                }
                field("Registration No."; Rec."Registration No.")
                {
                    ApplicationArea = All;
                }
                field("Vehicle Name"; Rec."Vehicle Name")
                {
                    ApplicationArea = All;
                }
                field("Vehicle Type"; Rec."Vehicle Type")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ImportVehicles)
            {
                ApplicationArea = All;
                Caption = 'Import Vehicles (CSV)';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Import a CSV file to create or update company vehicles.';
                RunObject = xmlport "Import Company Vehicles";
            }
        }
    }
}
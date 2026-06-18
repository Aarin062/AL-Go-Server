page 50100 "Company Vehicle Card"
{
    PageType = Card;
    SourceTable = "Company Vehicle";
    Caption = 'Company Vehicle';

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("Vehicle No."; Rec."Vehicle No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique vehicle number.';
                }
                field("Registration No."; Rec."Registration No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the license plate or registration number.';
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

            group(Details)
            {
                Caption = 'Details';

                field(Brand; Rec.Brand)
                {
                    ApplicationArea = All;
                }
                field(Model; Rec.Model)
                {
                    ApplicationArea = All;
                }
                field("Purchase Date"; Rec."Purchase Date")
                {
                    ApplicationArea = All;
                }
                field("Purchase Cost"; Rec."Purchase Cost")
                {
                    ApplicationArea = All;
                }
                field("Current Mileage"; Rec."Current Mileage")
                {
                    ApplicationArea = All;
                }
                field("Assigned Driver"; Rec."Assigned Driver")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
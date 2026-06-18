page 50103 "Driver List"
{
    PageType = List;
    SourceTable = Driver;
    CardPageId = "Driver Card";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Drivers';
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Driver No."; Rec."Driver No.") { ApplicationArea = All; }
                field("Driver Name"; Rec."Driver Name") { ApplicationArea = All; }
                field("License No."; Rec."License No.") { ApplicationArea = All; }
                field("License Expiry Date"; Rec."License Expiry Date") { ApplicationArea = All; }
                field(Status; Rec.Status) { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ImportDrivers)
            {
                ApplicationArea = All;
                Caption = 'Import Drivers (CSV)';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = xmlport "Import Drivers";
            }
        }
    }
}
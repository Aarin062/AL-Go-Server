page 50105 "Fuel Log List"
{
    PageType = List;
    SourceTable = "Fuel Log";
    CardPageId = "Fuel Log Card";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Fuel Logs';
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Log No."; Rec."Log No.") { ApplicationArea = All; }
                field("Date"; Rec."Date") { ApplicationArea = All; }
                field("Vehicle No."; Rec."Vehicle No.") { ApplicationArea = All; }
                field("Driver No."; Rec."Driver No.") { ApplicationArea = All; }
                field(Quantity; Rec.Quantity) { ApplicationArea = All; }
                field("Total Amount"; Rec."Total Amount") { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ImportFuelLogs)
            {
                ApplicationArea = All;
                Caption = 'Import Fuel Logs (CSV)';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = xmlport "Import Fuel Logs";
            }
        }
    }
}
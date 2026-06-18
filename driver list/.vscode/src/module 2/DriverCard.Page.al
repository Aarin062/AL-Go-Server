page 50102 "Driver Card"
{
    PageType = Card;
    SourceTable = Driver;
    Caption = 'Driver';

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Driver No."; Rec."Driver No.") { ApplicationArea = All; }
                field("Driver Name"; Rec."Driver Name") { ApplicationArea = All; }
                field(Status; Rec.Status) { ApplicationArea = All; }
                field(Department; Rec.Department) { ApplicationArea = All; }
            }
            group(ContactAndLicense)
            {
                Caption = 'Contact & License Info';
                field("Contact No."; Rec."Contact No.") { ApplicationArea = All; }
                field("License No."; Rec."License No.") { ApplicationArea = All; }
                field("License Expiry Date"; Rec."License Expiry Date") { ApplicationArea = All; }
            }
        }
    }
}
page 50101 "Employee Advance Subform"
{
    PageType = ListPart;
    SourceTable = "Employee Advance Line";
    Caption = 'Expense Lines';
    AutoSplitKey = true; 
    DelayedInsert = true; 

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Expense Type"; Rec."Expense Type")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = All;
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = All;
                }
                field("Is Urgent"; Rec."Is Urgent")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
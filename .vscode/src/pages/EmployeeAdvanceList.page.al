page 50102 "Employee Advance List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists; 
    SourceTable = "Employee Advance Header";
    Caption = 'Employee Advance Requests';
    CardPageId = "Employee Advance Card"; 
    Editable = false; 

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Request No."; Rec."Request No.")
                {
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    // ui effect
                    StyleExpr = StatusStyleTxt; 
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    var
        StatusStyleTxt: Text;

    trigger OnAfterGetRecord()
    begin
        // Pending is Yellow, Approved is Green, Rejected is Red
        case Rec.Status of
            Rec.Status::"Pending Approval": StatusStyleTxt := 'Ambiguous'; 
            Rec.Status::Approved: StatusStyleTxt := 'Favorable';
            Rec.Status::Rejected: StatusStyleTxt := 'Unfavorable';
            else StatusStyleTxt := 'Standard';
        end;
    end;
}
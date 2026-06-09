enum 50100 "Requisition Status"
{
    Extensible = true;
    
    value(0; Draft) { Caption = 'Draft'; }
    value(1; "Pending Approval") { Caption = 'Pending Approval'; }
    value(2; Approved) { Caption = 'Approved'; }
    value(3; Rejected) { Caption = 'Rejected'; }
}
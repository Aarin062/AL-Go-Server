enum 50100 "Advance Status"
{
    Extensible = true;

    value(0; Open) { Caption = 'Open'; }
    value(1; "Pending Approval") { Caption = 'Pending Approval'; }
    value(2; Approved) { Caption = 'Approved'; }
    value(3; Rejected) { Caption = 'Rejected'; }
    value(4; Posted) { Caption = 'Posted'; }
}

enum 50101 "Expense Type"
{
    Extensible = true;

    value(0; Travel) { Caption = 'Travel'; }
    value(1; Food) { Caption = 'Food'; }
    value(2; Accommodation) { Caption = 'Accommodation'; }
    value(3; Miscellaneous) { Caption = 'Miscellaneous'; }
}
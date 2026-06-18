enum 50100 "Company Vehicle Type"
{
    Extensible = true;

    value(0; " ") { Caption = ' '; }
    value(1; Car) { Caption = 'Car'; }
    value(2; Truck) { Caption = 'Truck'; }
    value(3; Van) { Caption = 'Van'; }
    value(4; Motorcycle) { Caption = 'Motorcycle'; }
    value(5; Other) { Caption = 'Other'; }
}

enum 50101 "Company Vehicle Status"
{
    Extensible = true;

    value(0; Active) { Caption = 'Active'; }
    value(1; "In Maintenance") { Caption = 'In Maintenance'; }
    value(2; "Out of Service") { Caption = 'Out of Service'; }
}
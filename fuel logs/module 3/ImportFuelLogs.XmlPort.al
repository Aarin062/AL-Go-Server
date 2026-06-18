xmlport 50102 "Import Fuel Logs"
{
    Direction = Import;
    Format = VariableText;
    FieldSeparator = ',';
    UseRequestPage = false;

    schema
    {
        textelement(Root)
        {
            tableelement(LogRec; "Fuel Log")
            {
                AutoUpdate = true;

                fieldelement(LogNo; LogRec."Log No.") { }
                fieldelement(VehicleNo; LogRec."Vehicle No.") { FieldValidate = yes; }
                fieldelement(DriverNo; LogRec."Driver No.") { }
                fieldelement(Date; LogRec.Date) { }
                fieldelement(FuelType; LogRec."Fuel Type") { }
                fieldelement(Quantity; LogRec.Quantity) { FieldValidate = yes; }
                fieldelement(Price; LogRec."Price per Liter") { FieldValidate = yes; }
                fieldelement(Odometer; LogRec."Current Odometer Reading") { FieldValidate = yes; }
            }
        }
    }
}
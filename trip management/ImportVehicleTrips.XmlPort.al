xmlport 50103 "Import Vehicle Trips"
{
    Direction = Import;
    Format = VariableText;
    FieldSeparator = ',';
    UseRequestPage = false;

    schema
    {
        textelement(Root)
        {
            tableelement(TripRec; "Vehicle Trip")
            {
                AutoUpdate = true;

                fieldelement(TripNo; TripRec."Trip No.") { }
                fieldelement(VehicleNo; TripRec."Vehicle No.") { FieldValidate = yes; }
                fieldelement(DriverNo; TripRec."Driver No.") { }
                fieldelement(StartDate; TripRec."Start Date") { }
                fieldelement(EndDate; TripRec."End Date") { FieldValidate = yes; }
                fieldelement(Source; TripRec.Source) { }
                fieldelement(Destination; TripRec.Destination) { }
                fieldelement(Purpose; TripRec.Purpose) { }
                fieldelement(StartKm; TripRec."Start Kilometer") { FieldValidate = yes; }
                fieldelement(EndKm; TripRec."End Kilometer") { FieldValidate = yes; }
            }
        }
    }
}
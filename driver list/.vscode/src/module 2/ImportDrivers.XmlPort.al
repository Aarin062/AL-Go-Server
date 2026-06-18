xmlport 50101 "Import Drivers"
{
    Direction = Import;
    Format = VariableText;
    FieldSeparator = ',';
    UseRequestPage = false;

    schema
    {
        textelement(Root)
        {
            tableelement(DriverRec; Driver)
            {
                AutoUpdate = true;

                fieldelement(DriverNo; DriverRec."Driver No.") { }
                fieldelement(DriverName; DriverRec."Driver Name") { }
                fieldelement(ContactNo; DriverRec."Contact No.") { }
                fieldelement(LicenseNo; DriverRec."License No.") { }
                
                // FieldValidate ensures the past-date error triggers during import
                fieldelement(LicenseExpiry; DriverRec."License Expiry Date") { FieldValidate = yes; }
                
                fieldelement(Department; DriverRec.Department) { }
                fieldelement(Status; DriverRec.Status) { }
            }
        }
    }
}
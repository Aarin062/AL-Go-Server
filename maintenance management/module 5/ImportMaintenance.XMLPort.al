xmlport 50104 "Import Maintenance"
{
    Direction = Import;
    Format = VariableText;
    FieldSeparator = ',';
    UseRequestPage = false;

    schema
    {
        textelement(Root)
        {
            tableelement(MaintRec; "Maintenance Log")
            {
                AutoUpdate = true;

                fieldelement(LogNo; MaintRec."Log No.") { }
                fieldelement(VehicleNo; MaintRec."Vehicle No.") { FieldValidate = yes; }
                fieldelement(Date; MaintRec."Maintenance Date") { }
                fieldelement(Type; MaintRec."Maintenance Type") { }
                fieldelement(Vendor; MaintRec.Vendor) { }
                fieldelement(Cost; MaintRec.Cost) { FieldValidate = yes; }
                fieldelement(Description; MaintRec.Description) { }
                fieldelement(NextServiceKm; MaintRec."Next Service Kilometer") { FieldValidate = yes; }
            }
        }
    }
}
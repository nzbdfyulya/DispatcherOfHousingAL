tableextension 50121 "YULPI Sales & Rec Setup" extends "Sales & Receivables Setup"
{
    fields
    {
        field(12493; "Repairman Nos."; Code[20])
        {
            TableRelation = "No. Series";
            Caption = 'Repairman Nos.';
            DataClassification = ToBeClassified;
        }
        field(12494; "Request Nos."; Code[20])
        {
            TableRelation = "No. Series";
            Caption = 'Request Nos.';
            DataClassification = ToBeClassified;
        }
    }
}

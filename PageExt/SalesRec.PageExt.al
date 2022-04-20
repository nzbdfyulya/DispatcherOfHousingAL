pageextension 50121 "YULPI Sales Rec Setup" extends "Sales & Receivables Setup"
{
    layout
    {
        addlast("Number Series")
        {
            field("Repairman Nos."; Rec."Repairman Nos.")
            {
                ApplicationArea = All;
            }
            field("Request Nos."; Rec."Request Nos.")
            {
                ApplicationArea = All;
            }

        }
    }

}
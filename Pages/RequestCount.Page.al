page 50123 "Request Count"
{
    PageType = CardPart;
    Caption = 'Request Count';

    SourceTable = Request;
    Editable = false;

    layout
    {
        area(Content)
        {
            group("Request Count")
            {
                field("Customer Request Count"; "Customer Request Count")
                {
                    Caption = 'Customer Request Count';
                    Editable = false;
                    ApplicationArea = All;

                }
                field("Address Request Count"; "Address Request Count")
                {
                    Caption = 'Address Request Count';
                    Editable = false;
                    ApplicationArea = All;

                }
            }
        }
    }

    actions
    {

    }

    trigger OnAfterGetCurrRecord()
    begin
        CustomerRequest.SETRANGE("Customer No.", Rec."Customer No.");
        "Customer Request Count" := CustomerRequest.COUNT;


        AddressRequest.SETRANGE("Customer City", Rec."Customer City");
        AddressRequest.SETRANGE("Customer Street", Rec."Customer Street");
        AddressRequest.SETRANGE("Customer House No.", Rec."Customer House No.");

        "Address Request Count" := AddressRequest.COUNT;
    end;

    var
        "Customer Request Count": Integer;
        "Address Request Count": Integer;
        CustomerRequest: Record Request;
        AddressRequest: Record Request;

}
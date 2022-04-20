report 50121 "Requests Report"
{
    UsageCategory = Administration;
    Caption = 'Requests Report';
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Report/RequestsReport.rdlc';

    dataset
    {
        dataitem(Repairman; Repairman)
        {

            column(Code_Repairman; Repairman."Code")
            {
            }
            column(Name_Repairman; Repairman.Name)
            {
            }
            column(Email_Repairman; Repairman."E-mail")
            {
            }
            column(PhoneNo_Repairman; Repairman."Phone No.")
            {
            }
            column(RequestCategory_Repairman; Repairman."Request Category")
            {
            }

            dataitem(Request; Request)
            {
                DataItemLink = "Repairman Code" = FIELD("Code");
                DataItemTableView = SORTING("No.") WHERE(Status = CONST(Posted));
                column(No_Request; Request."No.")
                {
                }
                column(UserID_Request; Request."User ID")
                {
                }
                column(CreationDate_Request; Request."Creation Date")
                {
                }
                column(CreationTime_Request; Request."Creation Time")
                {
                }
                column(Status_Request; Request.Status)
                {
                }
                column(RepairmanCode_Request; Request."Repairman Code")
                {
                }
                column(RepairmanName_Request; Request."Repairman Name")
                {
                }
                column(CustomerNo_Request; Request."Customer No.")
                {
                }
                column(CustomerFullName_Request; Request."Customer Full Name")
                {
                }
                column(CustomerPhoneNo_Request; Request."Customer Phone No.")
                {
                }
                column(CustomerCity_Request; Request."Customer City")
                {
                }
                column(CustomerStreet_Request; Request."Customer Street")
                {
                }
                column(CustomerHouseNo_Request; Request."Customer House No.")
                {
                }
                column(PostedDate_Request; Request."Posting Date")
                {
                }
                column(CustomerRoom_Request; Request."Customer Room")
                {
                }

                trigger OnPreDataItem()
                begin
                    IF PostingDate <> 0D THEN
                        Request.SETRANGE("Posting Date", PostingDate);
                end;
            }
            trigger OnPreDataItem()
            begin
                IF RepairmanFilter <> '' THEN
                    Repairman.SETFILTER(Code, RepairmanFilter);
            end;



        }

    }


    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    field(RepairmanFilter; RepairmanFilter)
                    {
                        Caption = 'Repairman Code';
                        TableRelation = Repairman.Code;
                        ApplicationArea = all;
                    }
                    field(PostingDate; PostingDate)
                    {
                        Caption = 'Posting Date';
                        ApplicationArea = all;
                    }
                }
            }
        }

        actions
        {
        }
    }

    trigger OnInitReport()
    begin
        CountRequest := Request.COUNT;
    end;


    var
        NameRepairman: Text;
        RepairmanFilter: Text;
        RepairmanCode: Code[10];
        PostingDate: Date;
        CountRequest: Integer;

}
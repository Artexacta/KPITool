<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" 
    CodeFile="TestDatePicker.aspx.cs" Inherits="_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script src="../Scripts/moment.min.js"></script>
    <script src="../Scripts/es.js"></script>
    <script src="../Scripts/en.js"></script>
    <script src="../Scripts/bootstrap-datetimepicker.min.js"></script>
    <link href="../App_Themes/Captura/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

    <!-- http://eonasdan.github.io/bootstrap-datetimepicker -->
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" Runat="Server">
    <div class="container">
        <div class="tile">
            <div class="t-header">
            </div>
            <div class="t-body tb-padding" style="padding-top: 0; ">
                <div class="row">
                    <div class="col-md-6">
                        <div class="input-group date" id="datePicker">
                            <asp:TextBox ID="DateTextBox" runat="server" CssClass="form-control" />
                            <span class="input-group-addon">
                                <span class="fa fa-calendar"></span>
                            </span>
                        </div>

                        <br />

                        <asp:TextBox ID="DecimalTextBox" runat="server" TextMode="Number" CssClass="form-control" />

                    </div>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        var lang = <%= Resources.ImportData.Language %>
        $(document).ready(function () {
            $('#datePicker').datetimepicker({
                format: 'L',
                locale: lang
            });
        });
    </script>

</asp:Content>


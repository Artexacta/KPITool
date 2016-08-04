<%@ Control Language="C#" AutoEventWireup="true" CodeFile="TourControl.ascx.cs" Inherits="UserControls_TourControl" %>
<asp:HyperLink ID="showTourBtn" runat="server" NavigateUrl="#"
    CssClass="btn btn-default" style="display: none" Text="<%$ Resources: Glossary, TourButtonLabel %>">   
</asp:HyperLink>
<asp:HiddenField ID="ResetTourHiddenField" runat="server" Value="false" />
<asp:HiddenField ID="ShowTourHiddenField" runat="server" Value="false" />
<asp:HiddenField ID="ForceShowTour" runat="server" Value="false" />
<asp:HiddenField ID="ItemsHiddenField" runat="server" />
<asp:Label ID="ControlSettingsControlName" runat="server" Visible="false"></asp:Label>
<asp:HiddenField ID="UserIdHiddenField" runat="server" Value="0" />
<asp:HiddenField ID="TourIdHiddenField" runat="server" />
<asp:PlaceHolder ID="ScriptBlock" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            if ($("#<%= ResetTourHiddenField.ClientID %>").val() == "true") {
                var storageKeys = Object.keys(localStorage);
                for (var i in storageKeys) {
                    var key = storageKeys[i];
                    if (key.indexOf("<%= ClientID %>") >= 0)
                        localStorage.removeItem(key);
                }
                $("#<%= ResetTourHiddenField.ClientID %>").val("false");
            }
            <%= ClientID %>_showTour();
            $("#<%= showTourBtn.ClientID %>").show();
            $("#<%= ShowTourHiddenField.ClientID %>").val("false");

            $("#<%= showTourBtn.ClientID %>").click(function () {
                var storageKeys = Object.keys(localStorage);
                for (var i in storageKeys) {
                    var key = storageKeys[i];
                    if (key.indexOf("<%= ClientID %>") >= 0)
                        localStorage.removeItem(key);
                }
                $("#<%= ForceShowTour.ClientID %>").val("true");
                $("#<%= ShowTourHiddenField.ClientID %>").val("true");
                <%= ClientID %>_showTour();
                return false;
            });
        });

        function <%= ClientID %>_showTour() {
            if ($("#<%= ShowTourHiddenField.ClientID %>").val() == "true") {
                var tour = new Tour({
                    name: "<%= ClientID %>",
                    steps: JSON.parse($("#<%= ItemsHiddenField.ClientID %>").val()),
                    backdrop: true,
                    storage: false,
                    onEnd: function (tour) {
                        $.ajax({
                            type: "POST",
                            url: "<%= VirtualPathUtility.ToAbsolute("~/UserControls/TourHandler.ashx") %>?userId=" + $("#<%= UserIdHiddenField.ClientID %>").val() + "&tourId=" +
                                $("#<%= TourIdHiddenField.ClientID %>").val(),
                            data: null,
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            success: function (data) { },
                            failure: function(response) {
                                console.log(response ? JSON.stringify(response) : "error");
                            }
                        });
                    }
                });

                // Initialize the tour
                if ($("#<%= ForceShowTour.ClientID %>").val() == "true") {
                    $("#<%= ForceShowTour.ClientID %>").val("false");
                    tour.init(true);
                } else
                    tour.init();
                // Start the tour
                tour.start();
                $("#<%= showTourBtn.ClientID %>").show();
                $("#<%= ShowTourHiddenField.ClientID %>").val("false");
            }
        }
    </script>
</asp:PlaceHolder>
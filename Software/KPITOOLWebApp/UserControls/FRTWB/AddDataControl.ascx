<%@ Control Language="C#" AutoEventWireup="true" CodeFile="AddDataControl.ascx.cs" Inherits="UserControls_FRTWB_AddDataControl" %>

<label><asp:Literal ID="OrganizationLabel" runat="server" Text="Organization" /></label>
<asp:Label ID="OrganizationRequired" runat="server" Text="Required" CssClass="label label-danger" Visible="false" />
<asp:TextBox ID="OrganizationTextBox" runat="server" CssClass="form-control" placeholder="[ Select an organization ]" />
<div class="has-error m-b-10">
    <asp:CustomValidator ID="OrganizationCustomValidator" runat="server" Display="Dynamic" ValidationGroup="AddData" 
        ErrorMessage="You must select an Organization." ClientValidationFunction="OrganizationCustomValidator_Validate" />
</div>

<div id="pnlKPI" runat="server" visible="false" style="color: #2196f3; ">
    <i id="addIcon" runat="server" class="zmdi zmdi-plus-circle-o zmdi-hc-fw"></i>
    <asp:LinkButton ID="AddArea" runat="server" Text="Area" href="#" style="margin-right: 5px; " />
    <asp:LinkButton ID="AddProject" runat="server" Text="Project" href="#" style="margin-right: 5px; " />
    <asp:LinkButton ID="AddActivity" runat="server" href="#" Text="Activity" style="margin-right: 5px; " />
    <asp:LinkButton ID="AddPeople" runat="server" href="#" Text="People" style="margin-right: 5px; " />
</div>

<div id="pnlArea" runat="server" visible="false">
    <label><asp:Literal ID="AreaLabel" runat="server" Text="Area" /></label>
    <asp:TextBox ID="AreaTextBox" runat="server" CssClass="form-control" placeholder="[ Select an area ]" />
</div>

<div id="pnlProject" runat="server" visible="false">
    <label><asp:Literal ID="ProjectLabel" runat="server" Text="Project" /></label>
    <asp:TextBox ID="ProjectTextBox" runat="server" CssClass="form-control" placeholder="[ Select a project ]" />
</div>

<div id="pnlActivity" runat="server" visible="false">
    <label><asp:Literal ID="ActivityLabel" runat="server" Text="Activity" /></label>
    <asp:DropDownList ID="ActivityComboBox" runat="server" CssClass="form-control m-b-10" 
        DataValueField="AreaId" DataTextField="AreaName">
        <asp:ListItem Value="-1" Selected="True">[ Select an activity ]</asp:ListItem>
    </asp:DropDownList>
</div>

<div id="pnlPeople" runat="server" visible="false">
    <label><asp:Literal ID="PeopleLabel" runat="server" Text="People" /></label>
    <asp:DropDownList ID="PeopleComboBox" runat="server" CssClass="form-control m-b-10" 
        DataValueField="AreaId" DataTextField="AreaName">
        <asp:ListItem Value="-1" Selected="True">[ Select a person ]</asp:ListItem>
    </asp:DropDownList>
</div>

<script type="text/javascript">
    function OrganizationCustomValidator_Validate(sender, args) {
        args.IsValid = true;

        var type = $("#<%= DataTypeHiddenField.ClientID %>").val();
        var value = $('#<%= OrganizationIdHiddenField.ClientID %>').val();

        if ((type == "PRJ" || type == "PPL" || type == "KPI") && value == "") {
            args.IsValid = false;
        }
    }

    $('#<%= OrganizationTextBox.ClientID %>').typeahead({
        hint: true,
        highlight: true,
        minLength: 1,
        source: function (request, response) {
            $.ajax({
                url: '<%=ResolveUrl("~/AutoCompleteWS/ComboBoxWebServices.aspx/Get_Organizations") %>',
                data: "{ 'filter': '" + request + "'}",
                dataType: "json",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    items = [];
                    map = {};
                    $.each(data.d, function (i, item) {
                        var id = item.OrganizationID;
                        var name = item.Name;
                        map[name] = { id: id, name: name };
                        items.push(name);
                    });
                    response(items);
                },
                error: function (response) {
                    alert(response.responseText);
                },
                failure: function (response) {
                    alert(response.responseText);
                }
            });

            $('#<%= OrganizationIdHiddenField.ClientID %>').val("");
            $("#<%= AreaTextBox.ClientID %>").val("");
            $("#<%= AreaIdHiddenField.ClientID %>").val("");
            $("#<%= ProjectTextBox.ClientID %>").val("");
            $("#<%= ProjectIdHiddenField.ClientID %>").val("");
        },
        updater: function (item) {
            $('#<%= OrganizationIdHiddenField.ClientID %>').val(map[item].id);
            $("#<%= AreaTextBox.ClientID %>").val("");
            $("#<%= AreaIdHiddenField.ClientID %>").val("");
            $("#<%= ProjectTextBox.ClientID %>").val("");
            $("#<%= ProjectIdHiddenField.ClientID %>").val("");
            return item;
        }
    });

    $('#<%= AreaTextBox.ClientID %>').typeahead({
        hint: true,
        highlight: true,
        minLength: 1,
        source: function (request, response) {
            $.ajax({
                url: '<%=ResolveUrl("~/AutoCompleteWS/ComboBoxWebServices.aspx/Get_Areas") %>',
                data: "{ 'organizationId': '" + $('#<%= OrganizationIdHiddenField.ClientID %>').val() + "', 'filter': '" + request + "' }",
                dataType: "json",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    items = [];
                    map = {};
                    $.each(data.d, function (i, item) {
                        var id = item.AreaID;
                        var name = item.Name;
                        map[name] = { id: id, name: name };
                        items.push(name);
                    });
                    response(items);
                },
                error: function (response) {
                    alert(response.responseText);
                },
                failure: function (response) {
                    alert(response.responseText);
                }
            });

            $("#<%= AreaIdHiddenField.ClientID %>").val("");
            $("#<%= ProjectTextBox.ClientID %>").val("");
            $("#<%= ProjectIdHiddenField.ClientID %>").val("");
        },
        updater: function (item) {
            $("#<%= AreaIdHiddenField.ClientID %>").val(map[item].id);
            $("#<%= ProjectTextBox.ClientID %>").val("");
            $("#<%= ProjectIdHiddenField.ClientID %>").val("");
            return item;
        }
    });

    $('#<%= ProjectTextBox.ClientID %>').typeahead({
        hint: true,
        highlight: true,
        minLength: 1,
        source: function (request, response) {
            $.ajax({
                url: '<%=ResolveUrl("~/AutoCompleteWS/ComboBoxWebServices.aspx/Get_Projects") %>',
                data: "{ 'organizationId': '" + $('#<%= OrganizationIdHiddenField.ClientID %>').val() + "', 'areaId': '" + $('#<%= AreaIdHiddenField.ClientID %>').val() + "', 'filter': '" + request + "' }",
                dataType: "json",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    items = [];
                    map = {};
                    $.each(data.d, function (i, item) {
                        var id = item.ProjectID;
                        var name = item.Name;
                        map[name] = { id: id, name: name };
                        items.push(name);
                    });
                    response(items);
                },
                error: function (response) {
                    alert(response.responseText);
                },
                failure: function (response) {
                    alert(response.responseText);
                }
            });

            $("#<%= ProjectIdHiddenField.ClientID %>").val("");
        },
        updater: function (item) {
            $("#<%= ProjectIdHiddenField.ClientID %>").val(map[item].id);
            return item;
        }
    });

</script>

<asp:HiddenField ID="DataTypeHiddenField" runat="server" />
<asp:HiddenField ID="OrganizationIdHiddenField" runat="server" />
<asp:HiddenField ID="AreaIdHiddenField" runat="server" />
<asp:HiddenField ID="ProjectIdHiddenField" runat="server" />
<asp:HiddenField ID="ActivityIdHiddenField" runat="server" />
<asp:HiddenField ID="PeopleIdHiddenField" runat="server" />

<asp:ObjectDataSource ID="OrganizationObjectDataSource" runat="server" OldValuesParameterFormatString="original_{0}" 
    TypeName="Artexacta.App.Organization.BLL.OrganizationBLL" SelectMethod="GetAllOrganizations" 
    OnSelected="OrganizationObjectDataSource_Selected">
</asp:ObjectDataSource>
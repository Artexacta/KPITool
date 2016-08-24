<%@ Control Language="C#" AutoEventWireup="true" CodeFile="SearchDataControl.ascx.cs" Inherits="UserControls_FRTWB_SearchDataControl" %>

<div style="padding-left: 15px">
    <div class="row">
        <label>
            <asp:Literal ID="OrganizationLabel" runat="server" Text="<% $Resources: Organization, TitleOrganizationName %>" /></label>
        <asp:TextBox ID="OrganizationTextBox" runat="server" CssClass="form-control" placeholder="<% $Resources: Organization, LabelSelectOrganization %>" Width="200px" />
    </div>

    <div class="row">
        <div id="pnlArea" runat="server">
            <label>
                <asp:Label ID="AreaLabel" runat="server" Text="<% $Resources: Organization, LabelAreaName %>" /></label>
            <asp:TextBox ID="AreaTextBox" runat="server" CssClass="form-control" placeholder="<% $Resources: Organization, LabelSelectArea %>" />
        </div>
    </div>
    <div class="row">
        <div id="pnlPeople" runat="server">
            <label>
                <asp:Literal ID="PeopleLabel" runat="server" Text="People" /></label>
            <asp:TextBox ID="PeopleTextBox" runat="server" CssClass="form-control" placeholder="<% $Resources: People, LabelSelectPerson %>" />
        </div>
    </div>
    <div class="row">
        <div id="pnlProject" runat="server">
            <label>
                <asp:Literal ID="ProjectLabel" runat="server" Text="<% $Resources: Project, labelProjectName %>" /></label>
            <asp:TextBox ID="ProjectTextBox" runat="server" CssClass="form-control" placeholder="<% $Resources: Project, LabelSelectProject %>" />
        </div>
    </div>
    <div class="row">
        <div id="pnlActivity" runat="server">
            <label>
                <asp:Literal ID="ActivityLabel" runat="server" Text="<% $Resources: Activity, LabelName %>" /></label>
            <asp:TextBox ID="ActivityTextBox" runat="server" CssClass="form-control" placeholder="<% $Resources: Activity, LabelSelectActivity %>" />
        </div>
    </div>

</div>
<script type="text/javascript">
    function OrganizationTextBox_OnChange() {
        if ($('#<%= OrganizationTextBox.ClientID %>').val() == "") {
            $('#<%= OrganizationIdHiddenField.ClientID %>').val("0");
            $("#<%= AreaTextBox.ClientID %>").val("");
            $("#<%= AreaIdHiddenField.ClientID %>").val("0");
            $("#<%= PeopleTextBox.ClientID %>").val("");
            $("#<%= PersonaIdHiddenField.ClientID %>").val("0");
            $("#<%= ProjectTextBox.ClientID %>").val("");
            $("#<%= ProjectIdHiddenField.ClientID %>").val("0");
            $("#<%= ActivityTextBox.ClientID %>").val("");
            $("#<%= ActivityIdHiddenField.ClientID %>").val("0");
        }
    }

    function AreaTextBox_OnChange() {
        if ($('#<%= AreaTextBox.ClientID %>').val() == "") {
            $("#<%= AreaIdHiddenField.ClientID %>").val("0");
            $("#<%= PeopleTextBox.ClientID %>").val("");
            $("#<%= PersonaIdHiddenField.ClientID %>").val("0");
            $("#<%= ProjectTextBox.ClientID %>").val("");
            $("#<%= ProjectIdHiddenField.ClientID %>").val("0");
            $("#<%= ActivityTextBox.ClientID %>").val("");
            $("#<%= ActivityIdHiddenField.ClientID %>").val("0");
        }
    }

    function ProjectTextBox_OnChange() {
        if ($('#<%= ProjectTextBox.ClientID %>').val() == "") {
            $("#<%= ProjectIdHiddenField.ClientID %>").val("0");
            $("#<%= ActivityTextBox.ClientID %>").val("");
            $("#<%= ActivityIdHiddenField.ClientID %>").val("0");
        }
    }

    function OrganizationCustomValidator_Validate(sender, args) {
        args.IsValid = true;

        var type = $("#<%= DataTypeHiddenField.ClientID %>").val();
        var value = $('#<%= OrganizationIdHiddenField.ClientID %>').val();

        if ((type == "PRJ" || type == "PPL" || type == "KPI") && value == "0") {
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

            $('#<%= OrganizationIdHiddenField.ClientID %>').val("0");
            $("#<%= AreaTextBox.ClientID %>").val("");
            $("#<%= AreaIdHiddenField.ClientID %>").val("0");
            $("#<%= ProjectTextBox.ClientID %>").val("");
            $("#<%= ProjectIdHiddenField.ClientID %>").val("0");
            var type = $("#<%= DataTypeHiddenField.ClientID %>").val();
        },
        updater: function (item) {
            $('#<%= OrganizationIdHiddenField.ClientID %>').val(map[item].id);
            $("#<%= AreaTextBox.ClientID %>").val("");
            $("#<%= AreaIdHiddenField.ClientID %>").val("0");
            $("#<%= ProjectTextBox.ClientID %>").val("");
            $("#<%= ProjectIdHiddenField.ClientID %>").val("0");

            var type = $("#<%= DataTypeHiddenField.ClientID %>").val();
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

            $("#<%= AreaIdHiddenField.ClientID %>").val("0");
            $("#<%= ProjectTextBox.ClientID %>").val("");
            $("#<%= ProjectIdHiddenField.ClientID %>").val("0");
        },
        updater: function (item) {
            $("#<%= AreaIdHiddenField.ClientID %>").val(map[item].id);
            $("#<%= ProjectTextBox.ClientID %>").val("");
            $("#<%= ProjectIdHiddenField.ClientID %>").val("0");
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

            $("#<%= ProjectIdHiddenField.ClientID %>").val("0");
        },
        updater: function (item) {
            $("#<%= ProjectIdHiddenField.ClientID %>").val(map[item].id);
            return item;
        }
    });

        $('#<%= ActivityTextBox.ClientID %>').typeahead({
        hint: true,
        highlight: true,
        minLength: 1,
        source: function (request, response) {
            $.ajax({
                url: '<%=ResolveUrl("~/AutoCompleteWS/ComboBoxWebServices.aspx/Get_Activities") %>',
                data: "{ 'organizationId': '" + $('#<%= OrganizationIdHiddenField.ClientID %>').val() + "', 'areaId': '" + $('#<%= AreaIdHiddenField.ClientID %>').val() + "', 'projectId': '" + $('#<%= ProjectIdHiddenField.ClientID %>').val() + "', 'filter': '" + request + "' }",
                dataType: "json",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    items = [];
                    map = {};
                    $.each(data.d, function (i, item) {
                        var id = item.ActivityID;
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

            $("#<%= ActivityIdHiddenField.ClientID %>").val("0");
        },
        updater: function (item) {
            $("#<%= ActivityIdHiddenField.ClientID %>").val(map[item].id);
            return item;
        }
    });


    $('#<%= PeopleTextBox.ClientID %>').typeahead({
        hint: true,
        highlight: true,
        minLength: 1,
        source: function (request, response) {
            $.ajax({
                url: '<%=ResolveUrl("~/AutoCompleteWS/ComboBoxWebServices.aspx/Get_People") %>',
                data: "{ 'organizationId': '" + $('#<%= OrganizationIdHiddenField.ClientID %>').val() + "', 'areaId': '" + $('#<%= AreaIdHiddenField.ClientID %>').val() + "', 'filter': '" + request + "' }",
                dataType: "json",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    items = [];
                    map = {};
                    $.each(data.d, function (i, item) {
                        var id = item.PersonId;
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

            $("#<%= PersonaIdHiddenField.ClientID %>").val("0");
        },
         updater: function (item) {
             $("#<%= PersonaIdHiddenField.ClientID %>").val(map[item].id);
            return item;
        }
     });
</script>

<asp:HiddenField ID="DataTypeHiddenField" runat="server" />
<asp:HiddenField ID="OrganizationIdHiddenField" runat="server" Value="0" />
<asp:HiddenField ID="AreaIdHiddenField" runat="server" Value="0" />
<asp:HiddenField ID="ProjectIdHiddenField" runat="server" Value="0" />
<asp:HiddenField ID="ActivityIdHiddenField" runat="server" Value="0" />
<asp:HiddenField ID="PersonaIdHiddenField" runat="server" Value="0" />
<asp:HiddenField ID="KPIIdHiddenField" runat="server" />
<asp:HiddenField ID="ReadOnlyHiddenField" runat="server" />

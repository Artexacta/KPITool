<%@ Control Language="C#" AutoEventWireup="true" CodeFile="SearchDataControl.ascx.cs" Inherits="UserControls_FRTWB_SearchDataControl" %>

<div class="col-md-4">
    <label>
        <asp:Literal ID="OrganizationLabel" runat="server" Text="Organization" /></label>
    <asp:TextBox ID="OrganizationTextBox" runat="server" CssClass="form-control" placeholder="[ Select an organization ]" />
</div>
<div id="pnlKPI" runat="server" visible="false" style="margin: 5px 0; position: relative;">
    <div id="pnlKPIDisabled" runat="server" style="color: #9e9e9e; display: block;">
        <i id="addIconDisabled" runat="server" class="fa fa-plus-circle"></i>
        <asp:Label ID="AddAreaLabel" runat="server" Text="Area" Style="margin: 0 5px;" />
        <asp:Label ID="AddProjectLabel" runat="server" Text="Project" Style="margin: 0 5px;" />
        <asp:Label ID="AddActivityLabel" runat="server" Text="Activity" Style="margin: 0 5px;" />
        <asp:Label ID="AddPeopleLabel" runat="server" Text="People" Style="margin: 0 5px;" />
    </div>
    <div id="pnlKPIEnabled" runat="server" style="color: #2196f3; display: none;">
        <i id="addIconEnabled" runat="server" class="fa fa-plus-circle"></i>
        <div id="pnlAddArea" runat="server" class="btn-group btn-addData">
            <asp:LinkButton ID="AddAreaButton" runat="server" Text="Area" Style="margin: 0 5px;" class="dropdown-toggle" data-toggle="dropdown" />
            <div class="dropdown-menu">
                <asp:TextBox ID="KPIAreaTextBox" runat="server" CssClass="form-control" placeholder="[ Select an area ]" />
            </div>
        </div>
        <div id="pnlAddProject" runat="server" class="btn-group btn-addData">
            <asp:LinkButton ID="AddProjectButton" runat="server" Text="Project" Style="margin: 0 5px;" class="dropdown-toggle" data-toggle="dropdown" />
            <div class="dropdown-menu">
                <asp:TextBox ID="KPIProjectTextBox" runat="server" CssClass="form-control" placeholder="[ Select a project ]" />
            </div>
        </div>
        <div id="pnlAddActivity" runat="server" class="btn-group btn-addData">
            <asp:LinkButton ID="AddActivityButton" runat="server" Text="Activity" Style="margin: 0 5px;" class="dropdown-toggle" data-toggle="dropdown" />
            <div class="dropdown-menu">
                <asp:TextBox ID="KPIActivityTextBox" runat="server" CssClass="form-control" placeholder="[ Select an activity ]" />
            </div>
        </div>
        <div id="pnlAddPeople" runat="server" class="btn-group btn-addData">
            <asp:LinkButton ID="AddPeopleButton" runat="server" Text="People" Style="margin: 0 5px;" class="dropdown-toggle" data-toggle="dropdown" />
            <div class="dropdown-menu">
                <asp:TextBox ID="KPIPeopleTextBox" runat="server" CssClass="form-control" placeholder="[ Select a person ]" />
            </div>
        </div>
    </div>
</div>

<div id="pnlArea" runat="server">
    <label>
        <asp:Label ID="AreaLabel" runat="server" Text="Area" /></label>
    <asp:TextBox ID="AreaTextBox" runat="server" CssClass="form-control" placeholder="[ Select an area ]" />
</div>

<div id="pnlProject" runat="server" visible="false">
    <label>
        <asp:Literal ID="ProjectLabel" runat="server" Text="Project" /></label>
    <asp:TextBox ID="ProjectTextBox" runat="server" CssClass="form-control" placeholder="[ Select a project ]" />
</div>

<div id="pnlActivity" runat="server" visible="false">
    <label>
        <asp:Literal ID="ActivityLabel" runat="server" Text="Activity" /></label>
    <asp:DropDownList ID="ActivityComboBox" runat="server" CssClass="form-control m-b-10"
        DataValueField="AreaId" DataTextField="AreaName">
        <asp:ListItem Value="-1" Selected="True">[ Select an activity ]</asp:ListItem>
    </asp:DropDownList>
</div>

<div id="pnlPeople" runat="server" visible="false">
    <label>
        <asp:Literal ID="PeopleLabel" runat="server" Text="People" /></label>
    <asp:DropDownList ID="PeopleComboBox" runat="server" CssClass="form-control m-b-10"
        DataValueField="AreaId" DataTextField="AreaName">
        <asp:ListItem Value="-1" Selected="True">[ Select a person ]</asp:ListItem>
    </asp:DropDownList>
</div>

<script type="text/javascript">
    function OrganizationTextBox_OnChange() {
        if ($('#<%= OrganizationTextBox.ClientID %>').val() == "") {
            $('#<%= OrganizationIdHiddenField.ClientID %>').val("0");
            $("#<%= AreaTextBox.ClientID %>").val("");
            $("#<%= AreaIdHiddenField.ClientID %>").val("0");
            $("#<%= ProjectTextBox.ClientID %>").val("");
            $("#<%= ProjectIdHiddenField.ClientID %>").val("0");
            var type = $("#<%= DataTypeHiddenField.ClientID %>").val();
            if (type == "KPI") {
                $("#<%= pnlKPIDisabled.ClientID %>").show();
                $("#<%= pnlKPIEnabled.ClientID %>").hide();
                RemoveArea();
            }
        }
    }

    function AreaTextBox_OnChange() {
        if ($('#<%= AreaTextBox.ClientID %>').val() == "") {
            $("#<%= AreaIdHiddenField.ClientID %>").val("0");
            $("#<%= ProjectTextBox.ClientID %>").val("");
            $("#<%= ProjectIdHiddenField.ClientID %>").val("0");
        }
    }

    function ProjectTextBox_OnChange() {
        if ($('#<%= ProjectTextBox.ClientID %>').val() == "") {
            $("#<%= ProjectIdHiddenField.ClientID %>").val("0");
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
            if (type == "KPI") {
                $("#<%= pnlKPIDisabled.ClientID %>").show();
                $("#<%= pnlKPIEnabled.ClientID %>").hide();
                RemoveArea();
            }
        },
        updater: function (item) {
            $('#<%= OrganizationIdHiddenField.ClientID %>').val(map[item].id);
            $("#<%= AreaTextBox.ClientID %>").val("");
            $("#<%= AreaIdHiddenField.ClientID %>").val("0");
            $("#<%= ProjectTextBox.ClientID %>").val("");
            $("#<%= ProjectIdHiddenField.ClientID %>").val("0");

            var type = $("#<%= DataTypeHiddenField.ClientID %>").val();
            if (type == "KPI") {
                $("#<%= pnlKPIDisabled.ClientID %>").hide();
                $("#<%= pnlKPIEnabled.ClientID %>").show();

                $("#<%= pnlAddArea.ClientID %>").show();
                $("#<%= pnlAddProject.ClientID %>").show();
                $("#<%= pnlAddActivity.ClientID %>").show();
                $("#<%= pnlAddPeople.ClientID %>").show();
            }
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

        $('#<%= KPIAreaTextBox.ClientID %>').typeahead({
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
        },
        updater: function (item) {
            $("#<%= AreaIdHiddenField.ClientID %>").val(map[item].id);
            $("#<%= pnlAddArea.ClientID %>").hide();
            $('#<%= KPIAreaTextBox.ClientID %>').val("");
            return item;
        }
    });

    $('#<%= KPIProjectTextBox.ClientID %>').typeahead({
        hint: true,
        highlight: true,
        minLength: 1,
        source: function (request, response) {
            $.ajax({
                url: '<%=ResolveUrl("~/AutoCompleteWS/ComboBoxWebServices.aspx/Get_Projects") %>',
                data: "{ 'organizationId': '" + $('#<%= OrganizationIdHiddenField.ClientID %>').val()
                    + "', 'areaId': '" + $('#<%= AreaIdHiddenField.ClientID %>').val() + "', 'filter': '" + request + "' }",
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
        },
        updater: function (item) {
            $("#<%= ProjectIdHiddenField.ClientID %>").val(map[item].id);
            $("#<%= pnlAddProject.ClientID %>").hide();
            $('#<%= KPIProjectTextBox.ClientID %>').val("");
            $("#<%= PersonaIdHiddenField.ClientID %>").val("0");
            $("#<%= pnlAddPeople.ClientID %>").hide();
            return item;
        }
    });

    $('#<%= KPIActivityTextBox.ClientID %>').typeahead({
        hint: true,
        highlight: true,
        minLength: 1,
        source: function (request, response) {
            $.ajax({
                url: '<%=ResolveUrl("~/AutoCompleteWS/ComboBoxWebServices.aspx/Get_Activities") %>',
                data: "{ 'organizationId': '" + $('#<%= OrganizationIdHiddenField.ClientID %>').val()
					+ "', 'areaId': '" + $('#<%= AreaIdHiddenField.ClientID %>').val()
					+ "', 'projectId': '" + $('#<%= ProjectIdHiddenField.ClientID %>').val()
					+ "', 'filter': '" + request + "' }",
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
        },
        updater: function (item) {
            $("#<%= ActivityIdHiddenField.ClientID %>").val(map[item].id);
            $("#<%= pnlAddActivity.ClientID %>").hide();
            $('#<%= KPIActivityTextBox.ClientID %>').val("");

            $("#<%= pnlAddProject.ClientID %>").hide();

            $("#<%= PersonaIdHiddenField.ClientID %>").val("0");
            $("#<%= pnlAddPeople.ClientID %>").hide();

            $("#<%= pnlKPI.ClientID %>").hide();
            return item;
        }
    });

    $('#<%= KPIPeopleTextBox.ClientID %>').typeahead({
        hint: true,
        highlight: true,
        minLength: 1,
        source: function (request, response) {
            $.ajax({
                url: '<%=ResolveUrl("~/AutoCompleteWS/ComboBoxWebServices.aspx/Get_People") %>',
                data: "{ 'organizationId': '" + $('#<%= OrganizationIdHiddenField.ClientID %>').val()
					+ "', 'areaId': '" + $('#<%= AreaIdHiddenField.ClientID %>').val()
					+ "', 'filter': '" + request + "' }",
                dataType: "json",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    items = [];
                    map = {};
                    $.each(data.d, function (i, item) {
                        var id = item.PersonID;
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
        },
        updater: function (item) {
            $("#<%= PersonaIdHiddenField.ClientID %>").val(map[item].id);
            $("#<%= pnlAddPeople.ClientID %>").hide();
            $('#<%= KPIPeopleTextBox.ClientID %>').val("");

            $("#<%= ProjectIdHiddenField.ClientID %>").val("0");
            $("#<%= pnlAddProject.ClientID %>").hide();

            $("#<%= ActivityIdHiddenField.ClientID %>").val("0");
            $("#<%= pnlAddActivity.ClientID %>").hide();

            $("#<%= pnlKPI.ClientID %>").hide();
            return item;
        }
    });

    function RemoveArea() {
        $("#<%= AreaIdHiddenField.ClientID %>").val("0");
        $('#<%= KPIAreaTextBox.ClientID %>').val("");
        $("#<%= pnlAddArea.ClientID %>").show();

        RemoveProject();
        RemovePeople();
        return false;
    }

    function RemoveProject() {
        $("#<%= ProjectIdHiddenField.ClientID %>").val("0");
        $('#<%= KPIProjectTextBox.ClientID %>').val("");
        $("#<%= pnlAddProject.ClientID %>").show();

        $("#<%= pnlAddPeople.ClientID %>").show();

        RemoveActivity();
        return false;
    }

    function RemoveActivity() {
        $("#<%= ActivityIdHiddenField.ClientID %>").val("0");
        $('#<%= KPIActivityTextBox.ClientID %>').val("");
        $("#<%= pnlAddActivity.ClientID %>").show();

        if ($("#<%= ProjectIdHiddenField.ClientID %>").val() == "0") {
            $("#<%= pnlAddProject.ClientID %>").show();
            $("#<%= pnlAddPeople.ClientID %>").show();

        } else {
            $("#<%= pnlAddProject.ClientID %>").hide();
            $("#<%= pnlAddPeople.ClientID %>").hide();
        }

        $("#<%= pnlKPI.ClientID %>").show();
        return false;
    }

    function RemovePeople() {
        $("#<%= PersonaIdHiddenField.ClientID %>").val("0");
        $('#<%= KPIPeopleTextBox.ClientID %>').val("");
        $("#<%= pnlAddPeople.ClientID %>").show();

        $("#<%= pnlKPI.ClientID %>").show();
        if ($("#<%= ActivityIdHiddenField.ClientID %>").val() == "0") {
            $("#<%= pnlAddActivity.ClientID %>").show();
        }
        if ($("#<%= ProjectIdHiddenField.ClientID %>").val() == "0") {
            $("#<%= pnlAddProject.ClientID %>").show();
        }

        return false;
    }
</script>

<asp:HiddenField ID="DataTypeHiddenField" runat="server" />
<asp:HiddenField ID="OrganizationIdHiddenField" runat="server" Value="0" />
<asp:HiddenField ID="AreaIdHiddenField" runat="server" Value="0" />
<asp:HiddenField ID="ProjectIdHiddenField" runat="server" Value="0" />
<asp:HiddenField ID="ActivityIdHiddenField" runat="server" Value="0" />
<asp:HiddenField ID="PersonaIdHiddenField" runat="server" Value="0" />
<asp:HiddenField ID="KPIIdHiddenField" runat="server" />
<asp:HiddenField ID="ReadOnlyHiddenField" runat="server" />

<asp:ObjectDataSource ID="OrganizationObjectDataSource" runat="server" OldValuesParameterFormatString="original_{0}"
    TypeName="Artexacta.App.Organization.BLL.OrganizationBLL" SelectMethod="GetAllOrganizations"
    OnSelected="OrganizationObjectDataSource_Selected"></asp:ObjectDataSource>

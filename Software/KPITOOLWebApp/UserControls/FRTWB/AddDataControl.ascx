<%@ Control Language="C#" AutoEventWireup="true" CodeFile="AddDataControl.ascx.cs" Inherits="UserControls_FRTWB_AddDataControl" %>

<label><asp:Literal ID="OrganizationLabel" runat="server" Text="Organization" /></label>
<asp:Label ID="OrganizationRequired" runat="server" Text="Required" CssClass="label label-danger" Visible="false" />
<asp:TextBox ID="OrganizationTextBox" runat="server" CssClass="form-control" placeholder="[ Select an organization ]" />
<div class="has-error m-b-10">
    <asp:CustomValidator ID="OrganizationCustomValidator" runat="server" Display="Dynamic" ValidationGroup="AddData" 
        ErrorMessage="You must select an Organization." ClientValidationFunction="OrganizationCustomValidator_Validate" />
</div>

<div id="pnlKPI" runat="server" visible="false" style="margin: 5px 0; position: relative; ">
    <div id="pnlKPIDisabled" runat="server" style="color: #9e9e9e; display: block; ">
        <i id="addIconDisabled" runat="server" class="fa fa-plus-circle"></i>
        <asp:Label ID="AddAreaLabel" runat="server" Text="Area" style="margin: 0 5px; " />
        <asp:Label ID="AddProjectLabel" runat="server" Text="Project" style="margin: 0 5px; " />
        <asp:Label ID="AddActivityLabel" runat="server" Text="Activity" style="margin: 0 5px; " />
        <asp:Label ID="AddPeopleLabel" runat="server" Text="People" style="margin: 0 5px; " />
    </div>
    <div id="pnlKPIEnabled" runat="server" style="color: #2196f3; display: none; ">
        <i id="addIconEnabled" runat="server" class="fa fa-plus-circle"></i>
        <div id="pnlAddArea" runat="server" class="btn-group btn-addData">
            <asp:LinkButton ID="AddAreaButton" runat="server" Text="Area" style="margin: 0 5px; " class="dropdown-toggle" data-toggle="dropdown" />
            <div class="dropdown-menu">
                <asp:TextBox ID="KPIAreaTextBox" runat="server" CssClass="form-control" placeholder="[ Select an area ]" />
            </div>
        </div>
        <div id="pnlAddProject" runat="server" class="btn-group btn-addData">
            <asp:LinkButton ID="AddProjectButton" runat="server" Text="Project" style="margin: 0 5px; " class="dropdown-toggle" data-toggle="dropdown" />
            <div class="dropdown-menu">
                <asp:TextBox ID="KPIProjectTextBox" runat="server" CssClass="form-control" placeholder="[ Select a project ]" />
            </div>
        </div>
        <div id="pnlAddActivity" runat="server" class="btn-group btn-addData">
            <asp:LinkButton ID="AddActivityButton" runat="server" Text="Activity" style="margin: 0 5px; " class="dropdown-toggle" data-toggle="dropdown" />
            <div class="dropdown-menu">
                <asp:TextBox ID="KPIActivityTextBox" runat="server" CssClass="form-control" placeholder="[ Select an activity ]" />
            </div>
        </div>
        <div id="pnlAddPeople" runat="server" class="btn-group btn-addData">
            <asp:LinkButton ID="AddPeopleButton" runat="server" Text="People" style="margin: 0 5px; " class="dropdown-toggle" data-toggle="dropdown" />
            <div class="dropdown-menu">
                <asp:TextBox ID="KPIPeopleTextBox" runat="server" CssClass="form-control" placeholder="[ Select a person ]" />
            </div>
        </div>
    </div>
</div>

<div id="pnlKPIData" runat="server" style="border: 1px solid #e8e8e8; padding: 6px 12px; display: none; ">
    <div id="pnlKPIArea" runat="server" style="display: none; margin: 0 10px; ">
        <asp:Label ID="KPIAreaLabel" runat="server" Text="Area: " Font-Bold="true" />
        <asp:Label ID="KPIAreaText" runat="server" />
        <asp:LinkButton ID="RemoveAreaButton" runat="server" Text="<i class='fa fa-minus-circle'></i>" CssClass="text-danger" 
            ToolTip="Delete" OnClientClick="return RemoveArea();" />
    </div>
    <div id="pnlKPIProject" runat="server" style="display: none; margin: 0 10px; ">
        <asp:Label ID="KPIProjectLabel" runat="server" Text="Project: " Font-Bold="true" />
        <asp:Label ID="KPIProjectText" runat="server" />
        <asp:LinkButton ID="RemoveProjectButton" runat="server" Text="<i class='fa fa-minus-circle'></i>" CssClass="text-danger" 
            ToolTip="Delete" OnClientClick="return RemoveProject();" />
    </div>
    <div id="pnlKPIActivity" runat="server" style="display: none; margin: 0 10px; ">
        <asp:Label ID="KPIActivityLabel" runat="server" Text="Activity: " Font-Bold="true" />
        <asp:Label ID="KPIActivityText" runat="server" />
        <asp:LinkButton ID="RemoveActivityButton" runat="server" Text="<i class='fa fa-minus-circle'></i>" CssClass="text-danger" 
            ToolTip="Delete" OnClientClick="return RemoveActivity();" />
    </div>
    <div id="pnlKPIPeople" runat="server" style="display: none; margin: 0 10px; ">
        <asp:Label ID="KPIPeopleLabel" runat="server" Text="People: " Font-Bold="true" />
        <asp:Label ID="KPIPeopleText" runat="server" />
        <asp:LinkButton ID="RemovePeopleButton" runat="server" Text="<i class='fa fa-minus-circle'></i>" CssClass="text-danger" 
            ToolTip="Delete" OnClientClick="return RemovePeople();" />
    </div>
</div>

<div id="pnlArea" runat="server">
    <label><asp:Label ID="AreaLabel" runat="server" Text="Area" /></label>
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
    }).on("change", function (event, suggestion) {
        if (suggestion == undefined) {
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
    }).on("change", function (event, suggestion) {
        if (suggestion == undefined) {
            $("#<%= AreaIdHiddenField.ClientID %>").val("0");
            $("#<%= ProjectTextBox.ClientID %>").val("");
            $("#<%= ProjectIdHiddenField.ClientID %>").val("0");
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
    }).on("change", function (event, suggestion) {
        if (suggestion == undefined) {
            $("#<%= ProjectIdHiddenField.ClientID %>").val("0");
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
            $("#<%= KPIAreaText.ClientID %>").text(map[item].name);
            $("#<%= pnlKPIArea.ClientID %>").fadeIn().css("display", "inline");
            $("#<%= pnlAddArea.ClientID %>").hide();
            $('#<%= KPIAreaTextBox.ClientID %>').val("");

            $("#<%= pnlKPIData.ClientID %>").show();
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
            $("#<%= KPIProjectText.ClientID %>").text(map[item].name);
            $("#<%= pnlKPIProject.ClientID %>").fadeIn().css("display", "inline");
            $("#<%= pnlAddProject.ClientID %>").hide();
            $('#<%= KPIProjectTextBox.ClientID %>').val("");

            $("#<%= PersonaIdHiddenField.ClientID %>").val("0");
            $("#<%= KPIPeopleText.ClientID %>").text("");
            $("#<%= pnlKPIPeople.ClientID %>").hide();
            $("#<%= pnlAddPeople.ClientID %>").hide();

            $("#<%= pnlKPIData.ClientID %>").show();
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
            $("#<%= KPIActivityText.ClientID %>").text(map[item].name);
            $("#<%= pnlKPIActivity.ClientID %>").fadeIn().css("display", "inline");
            $("#<%= pnlAddActivity.ClientID %>").hide();
            $('#<%= KPIActivityTextBox.ClientID %>').val("");

            $("#<%= pnlAddProject.ClientID %>").hide();

            $("#<%= PersonaIdHiddenField.ClientID %>").val("0");
            $("#<%= KPIPeopleText.ClientID %>").text("");
            $("#<%= pnlKPIPeople.ClientID %>").hide();
            $("#<%= pnlAddPeople.ClientID %>").hide();

            $("#<%= pnlKPIData.ClientID %>").show();
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
            $("#<%= KPIPeopleText.ClientID %>").text(map[item].name);
            $("#<%= pnlKPIPeople.ClientID %>").fadeIn().css("display", "inline");
            $("#<%= pnlAddPeople.ClientID %>").hide();
            $('#<%= KPIPeopleTextBox.ClientID %>').val("");

            $("#<%= ProjectIdHiddenField.ClientID %>").val("0");
            $("#<%= KPIProjectText.ClientID %>").text("");
            $("#<%= pnlKPIProject.ClientID %>").hide();
            $("#<%= pnlAddProject.ClientID %>").hide();

            $("#<%= ActivityIdHiddenField.ClientID %>").val("0");
            $("#<%= KPIActivityText.ClientID %>").text("");
            $("#<%= pnlKPIActivity.ClientID %>").hide();
            $("#<%= pnlAddActivity.ClientID %>").hide();

            $("#<%= pnlKPIData.ClientID %>").show();
            $("#<%= pnlKPI.ClientID %>").hide();
            return item;
        }
    });

    function RemoveArea() {
        $("#<%= AreaIdHiddenField.ClientID %>").val("0");
        $("#<%= KPIAreaText.ClientID %>").text("");
        $('#<%= KPIAreaTextBox.ClientID %>').val("");
        $("#<%= pnlKPIArea.ClientID %>").hide();
        $("#<%= pnlAddArea.ClientID %>").show();
        $("#<%= pnlKPIData.ClientID %>").hide();

        RemoveProject();
        RemovePeople();
        return false;
    }

    function RemoveProject() {
        $("#<%= ProjectIdHiddenField.ClientID %>").val("0");
        $("#<%= KPIProjectText.ClientID %>").text("");
        $('#<%= KPIProjectTextBox.ClientID %>').val("");
        $("#<%= pnlKPIProject.ClientID %>").hide();
        $("#<%= pnlAddProject.ClientID %>").show();

        $("#<%= KPIPeopleText.ClientID %>").text("");
        $("#<%= pnlAddPeople.ClientID %>").show();

        RemoveActivity();
        return false;
    }

    function RemoveActivity() {
        $("#<%= ActivityIdHiddenField.ClientID %>").val("0");
        $("#<%= KPIActivityText.ClientID %>").text("");
        $('#<%= KPIActivityTextBox.ClientID %>').val("");
        $("#<%= pnlKPIActivity.ClientID %>").hide();
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
        $("#<%= KPIPeopleText.ClientID %>").text("");
        $('#<%= KPIPeopleTextBox.ClientID %>').val("");
        $("#<%= pnlKPIPeople.ClientID %>").hide();
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

<asp:ObjectDataSource ID="OrganizationObjectDataSource" runat="server" OldValuesParameterFormatString="original_{0}" 
    TypeName="Artexacta.App.Organization.BLL.OrganizationBLL" SelectMethod="GetAllOrganizations" 
    OnSelected="OrganizationObjectDataSource_Selected">
</asp:ObjectDataSource>
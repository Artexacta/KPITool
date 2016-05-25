﻿<%@ Page Title="Share KPI" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" 
    CodeFile="ShareKpi.aspx.cs" Inherits="Kpi_ShareKpi" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" Runat="Server">
    <div class="row">
        <div class="col-md-1">
            <div class="page-header">
                <app:AddButton ID="TheAddButton" runat="server" />
            </div>
        </div>
        <div class="col-md-11">
            <h1 class="text-center">
                <asp:Literal ID="TitleLabel" runat="server" Text="Share KPI" />
            </h1>
        </div>
    </div>
    <div class="container">
        <div class="row">
            <div class="col-md-12">
                <h3>
                    <asp:Literal ID="SubtitleLabel" runat="server" Text="You are sharing a KPI: " />
                    <asp:Literal ID="KPINameLiteral" runat="server" />
                </h3>
            </div>
        </div>
    </div>

    <div class="container">
        <div class="tile">
            <div class="t-header">
                <div class="th-title">Users with permissions for this KPI:</div>
            </div>
            <div class="t-body tb-padding" style="padding-top: 0; ">
                <div class="row">
                    <div class="col-md-12">
                        <div class="table-responsive">
                            <asp:GridView ID="PermissionsGridView" runat="server" Width="100%" GridLines="None" DataSourceID="PermissionsObjectDataSource"  
                                CssClass="table table-striped table-bordered table-hover" AutoGenerateColumns="False" OnRowDataBound="PermissionsGridView_RowDataBound" 
                                OnRowCommand="PermissionsGridView_RowCommand">
                                <HeaderStyle CssClass="rgHeader head" />
                                <FooterStyle CssClass="foot" />
                                <AlternatingRowStyle CssClass="altRow" />
                                <EmptyDataRowStyle CssClass="gridNoData" />
                                <Columns>
                                    <asp:TemplateField HeaderText="Edit" ItemStyle-Width="50px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" Visible="false">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="EditButton" runat="server" Text="<i class='fa fa-pencil'></i>" CommandName="EditData" ToolTip="Edit" 
                                                CssClass="text-success" CommandArgument='<%# Eval("UserName") %>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Delete" ItemStyle-Width="50px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="DeleteButton" runat="server" Text="<i class='fa fa-minus-circle'></i>" CommandName="DeleteData" ToolTip="Delete" 
                                                CssClass="text-danger" CommandArgument='<%# Eval("UserName") %>' OnClientClick="return confirm('¿Are you sure to delete the user and his permissions?')" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField HeaderText="User" DataField="UserInfo" ItemStyle-Width="350px"  />
                                    <asp:TemplateField HeaderText="Permissions">
                                        <ItemTemplate>
                                            <asp:Label ID="Permissions" runat="server" Text='<%# Eval("PermissionsActionForDisplay") %>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <EmptyDataTemplate>
                                    <p class="text-center">
                                        There are no users with permissions for this KPI
                                    </p>
                                </EmptyDataTemplate>
                            </asp:GridView>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-12 m-t-20">
                        <asp:LinkButton ID="InviteUserButton" runat="server" CssClass="btn btn-primary" Text="Invite more users" OnClientClick="return OpenInviteUserModal()" />
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="container">
        <div class="row">
            <div class="col-md-12">
                <asp:HyperLink ID="ReturnLink" runat="server" NavigateUrl="~/Kpi/KpiList.aspx" Text="Back to KPI list"
                    CssClass="btn btn-info">
                </asp:HyperLink>
            </div>
        </div>
    </div>

    <!-- INVTE USERS MODAL -->
    <div id="InviteUserModal" class="myCustomBg">
        <div class="myCustomModal">
            <div class="modal-header">
                <h4 class="modal-title">Invite user</h4>
            </div>
            <div class="modal-body">
                <div class="middle-box">
                    <div class="form-group">
                        <label><asp:Literal ID="UserLabel" runat="server" Text="User:" /></label>
                        <asp:CheckBox ID="EveryoneCheckBox" runat="server" Text="Everyone can see this KPI" style="margin-left: 15px; " />
                        <asp:TextBox ID="UserTextBox" runat="server" CssClass="form-control" placeholder="[ Select an user ]" />
                        <asp:HiddenField ID="UserInvitedIdHiddenField" runat="server" />
                        <div class="has-error m-b-10">
                            <asp:CustomValidator ID="UserCustomValidator" runat="server" Display="Dynamic" ValidationGroup="InviteUser" 
                                ErrorMessage="You must select an User." ClientValidationFunction="UserCustomValidator_Validate" />
                        </div>
                    </div>

                    <div class="form-group">
                        <label><asp:Literal ID="PermissionsListLabel" runat="server" Text="Permission:" /></label>
                        <br />
                        <asp:DropDownList ID="ObjectActionComboBox" runat="server" DataSourceID="ObjectActionObjectDataSource" 
                            DataTextField="ObjectActionName" DataValueField="ObjectActionID" CssClass="form-control m-b-10" />
                        <asp:HiddenField ID="ObjectActionIdHiddenField" runat="server" />
                        <div class="has-error m-b-10">
                            <asp:CustomValidator ID="ObjectActionCustomValidator" runat="server" Display="Dynamic" ValidationGroup="InviteUser" 
                                ErrorMessage="You must select a permission." ClientValidationFunction="ObjectActionCustomValidator_Validate" />
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer btn-colors">
                <asp:LinkButton ID="SaveUserButton" runat="server" CssClass="btn btn-primary" ValidationGroup="InviteUser" 
                    OnClientClick="return VerifiyData()" OnClick="SaveUserButton_Click" Text="Add User" />
                <a class="btn btn-danger" href="javascript:CloseInviteUserModal();">Cancel</a>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        $(document).ready(function () {
            if ($("#<%= ShowInviteUserModal.ClientID %>").val() == 'true') {
                OpenInviteUserModal();
                $("#<%= ShowInviteUserModal.ClientID %>").val('false');
            }
        });

        function OpenInviteUserModal() {
            $("#InviteUserModal").css("display", "block");
            return false;
        }

        function CloseInviteUserModal() {
            $("#InviteUserModal").css("display", "none");
            $('#<%= UserInvitedIdHiddenField.ClientID %>').val("");
            $('#<%= UserTextBox.ClientID %>').val("");
            $("#<%= UserTextBox.ClientID %>").prop('disabled', false);
            $("#<%= EveryoneCheckBox.ClientID%>").attr('checked', false);
            $("#<%= ObjectActionComboBox.ClientID %>").prop('disabled', false);
            $("#<%= ObjectActionComboBox.ClientID %>").val("");
            $("#<%= ObjectActionIdHiddenField.ClientID %>").val("");
            for (i = 0; i < Page_Validators.length; i++) {
                $(Page_Validators[i]).css('display', 'none');
            }
        }

        function UserTextBox_OnChange() {
            if ($('#<%= UserTextBox.ClientID %>').val() == "") {
                $('#<%= UserInvitedIdHiddenField.ClientID %>').val("");
            }
        }

        $('#<%= UserTextBox.ClientID %>').typeahead({
            hint: true,
            highlight: true,
            minLength: 1,
            source: function (request, response) {
                $.ajax({
                    url: '<%=ResolveUrl("~/AutoCompleteWS/ComboBoxWebServices.aspx/Get_User") %>',
                    data: "{ 'filter': '" + request + "'}",
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (data) {
                        items = [];
                        map = {};
                        $.each(data.d, function (i, item) {
                            var id = item.UserId;
                            var name = item.FullName;
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

                $('#<%= UserInvitedIdHiddenField.ClientID %>').val("");
            },
            updater: function (item) {
                $('#<%= UserInvitedIdHiddenField.ClientID %>').val(map[item].id);
                return item;
            }
        });

        $("#<%= EveryoneCheckBox.ClientID%>").change(function () {
            if ($(this).is(':checked')) {
                $('#<%= UserInvitedIdHiddenField.ClientID %>').val("");
                $('#<%= UserTextBox.ClientID %>').val("");
                $("#<%= UserTextBox.ClientID %>").prop('disabled', true);

                // select VIEW_KPI
                $("#<%= ObjectActionComboBox.ClientID %>").val("VIEW_KPI");
                $("#<%= ObjectActionIdHiddenField.ClientID %>").val("VIEW_KPI");
                $("#<%= ObjectActionComboBox.ClientID %>").prop('disabled', true);

            } else {
                $("#<%= UserTextBox.ClientID %>").prop('disabled', false);
                // unselect VIEW_KPI
                $("#<%= ObjectActionComboBox.ClientID %>").val("");
                $("#<%= ObjectActionIdHiddenField.ClientID %>").val("");
                $("#<%= ObjectActionComboBox.ClientID %>").prop('disabled', false);
            }
        });

        $("#<%= ObjectActionComboBox.ClientID %>").change(function () {
            $("#<%= ObjectActionIdHiddenField.ClientID %>").val($(this).val());
        });

        function UserCustomValidator_Validate(sender, args) {
            args.IsValid = true;

            if (!$("#<%= EveryoneCheckBox.ClientID%>").is(':checked')) {
                var value = $('#<%= UserInvitedIdHiddenField.ClientID %>').val();
                if (value == null || value == "") {
                    args.IsValid = false;
                }
            }
        }

        function ObjectActionCustomValidator_Validate(sender, args) {
            args.IsValid = true;

            var value = $('#<%= ObjectActionIdHiddenField.ClientID %>').val();
            if (value == null || value == "") {
                args.IsValid = false;
            }
        }

        function VerifiyData() {
            if (Page_ClientValidate("InviteUser") == true) {

                var param = JSON.stringify({ 'kpiId': $("#<%= KPIIdHiddenField.ClientID %>").val(), 'userId': $("#<%= UserInvitedIdHiddenField.ClientID %>").val() });
                var data;
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "ShareKpi.aspx/VerifiyUser",
                    data: param,
                    dataType: "json",
                    async: false,
                    success: function (msg) {
                        data = msg.d;
                    }
                });

                if (data) {
                    if (confirm("El usuario ya estaba registrado por lo que los permisos se sobreescribirán por los seleccionados. ¿Está seguro de continuar?")) {
                        return true;
                    } else {
                        return false;
                    }
                } else {
                    return true;
                }
            } else {
                return false;
            }
        }
    </script>

    <asp:HiddenField ID="ObjectTypeIdHiddenField" runat="server" />
    <asp:HiddenField ID="KPIIdHiddenField" runat="server" />
    <asp:HiddenField ID="ShowInviteUserModal" runat="server" Value="false" />

    <asp:ObjectDataSource ID="PermissionsObjectDataSource" runat="server" OldValuesParameterFormatString="original_{0}"
        TypeName="Artexacta.App.PermissionObject.BLL.PermissionObjectBLL" SelectMethod="GetPermissionsByObject"
        OnSelected="ObjectDataSource_Selected">
        <SelectParameters>
            <asp:ControlParameter ControlID="ObjectTypeIdHiddenField" PropertyName="Value" Name="objectTypeId" Type="String" />
            <asp:ControlParameter ControlID="KPIIdHiddenField" PropertyName="Value" Name="objectId" Type="Int32" />
        </SelectParameters>
    </asp:ObjectDataSource>

    <asp:ObjectDataSource ID="ObjectActionObjectDataSource" runat="server" OldValuesParameterFormatString="original_{0}"
        TypeName="Artexacta.App.ObjectAction.BLL.ObjectActionBLL" SelectMethod="GetObjectActionsForKPI"
        OnSelected="ObjectDataSource_Selected">
        <SelectParameters>
            <asp:ControlParameter ControlID="KPIIdHiddenField" PropertyName="Value" Name="kpiId" Type="Int32" />
        </SelectParameters>
    </asp:ObjectDataSource>

</asp:Content>

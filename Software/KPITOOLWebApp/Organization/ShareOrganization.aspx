<%@ Page Title="<%$ Resources:ShareData, PageTitleOrganization %>" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" 
    CodeFile="ShareOrganization.aspx.cs" Inherits="Organization_ShareOrganization" %>

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
                <asp:Literal ID="TitleLabel" runat="server" Text="<%$ Resources:ShareData, PageTitleOrganization %>" />
            </h1>
        </div>
    </div>
    <div class="container">
        <div class="row">
            <div class="col-md-12">
                <h3>
                    <asp:Literal ID="SubtitleLabel" runat="server" Text="<%$ Resources:ShareData, SubtitleLabelOrganization %>" />
                    <asp:Literal ID="OrganizationNameLiteral" runat="server" />
                </h3>
            </div>
        </div>
    </div>

    <div class="container">
        <div class="tile">
            <div class="t-header">
                <div class="th-title"><asp:Literal ID="UserPermissionsOrganizationLabel" runat="server" Text="<%$ Resources:ShareData, UserPermissionsOrganizationLabel %>" /></div>
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
                                    <asp:TemplateField HeaderText="<%$ Resources:ShareData, EditColumn %>" ItemStyle-Width="50px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" Visible="false">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="EditButton" runat="server" Text="<i class='fa fa-pencil'></i>" CommandName="EditData" ToolTip="<%$ Resources:ShareData, EditColumn %>" 
                                                CssClass="text-success" CommandArgument='<%# Eval("UserName") %>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="<%$ Resources:ShareData, DeleteColumn %>" ItemStyle-Width="50px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="DeleteButton" runat="server" Text="<i class='fa fa-minus-circle'></i>" CommandName="DeleteData" ToolTip="<%$ Resources:ShareData, DeleteColumn %>" 
                                                CssClass="text-danger" CommandArgument='<%# Eval("UserName") %>' OnClientClick="<%$ Resources:ShareData, ConfirmDeleteUserPermission %>" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField HeaderText="<%$ Resources:ShareData, UserColumn %>" DataField="UserInfo" ItemStyle-Width="350px"  />
                                    <asp:TemplateField HeaderText="<%$ Resources:ShareData, PermissionsColumn %>">
                                        <ItemTemplate>
                                            <asp:Label ID="Permissions" runat="server" Text='<%# Eval("PermissionsActionForDisplay") %>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <EmptyDataTemplate>
                                    <p class="text-center">
                                        <asp:Literal ID="NoDataRows" runat="server" Text="<%$ Resources:ShareData, NoDataRowsOrganization %>" />
                                    </p>
                                </EmptyDataTemplate>
                            </asp:GridView>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-12 m-t-20">
                        <asp:LinkButton ID="InviteUserButton" runat="server" CssClass="btn btn-primary" Text="<%$ Resources:ShareData, InviteUserButton %>" OnClientClick="return OpenInviteUserModal()" />
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="container">
        <div class="row">
            <div class="col-md-12">
                <asp:HyperLink ID="ReturnLink" runat="server" NavigateUrl="~/Organization/ListOrganizations.aspx" Text="<%$ Resources:ShareData, ReturnOrganizationLink %>" CssClass="btn btn-info">
                </asp:HyperLink>
            </div>
        </div>
    </div>

    <!-- INVTE USERS MODAL -->
    <div id="InviteUserModal" class="myCustomBg">
        <div class="myCustomModal">
            <div class="modal-header">
                <h4 class="modal-title"><asp:Literal ID="InviteUserModalTitle" runat="server" Text="<%$ Resources:ShareData, InviteUserModalTitle %>" /></h4>
            </div>
            <div class="modal-body">
                <div class="middle-box">
                    <div class="form-group">
                        <label><asp:Literal ID="UserLabel" runat="server" Text="<%$ Resources:ShareData, UserLabel %>" /></label>
                        <asp:CheckBox ID="EveryoneCheckBox" runat="server" Text="<%$ Resources:ShareData, EveryoneCheckBox %>" style="margin-left: 15px; " />
                        <asp:TextBox ID="UserTextBox" runat="server" CssClass="form-control" placeholder="<%$ Resources:ShareData, UserTextBoxPlaceHolder %>" />
                        <asp:HiddenField ID="UserInvitedIdHiddenField" runat="server" />
                        <div class="has-error m-b-10">
                            <asp:CustomValidator ID="UserCustomValidator" runat="server" Display="Dynamic" ValidationGroup="InviteUser" 
                                ClientValidationFunction="UserCustomValidator_Validate" />
                        </div>
                    </div>

                    <div class="form-group">
                        <label><asp:Literal ID="PermissionsListLabel" runat="server" Text="<%$ Resources:ShareData, PermissionsListLabel %>" /></label>
                        <br />
                        <asp:Repeater ID="ObjectActionRepeater" runat="server" DataSourceID="ObjectActionObjectDataSource" OnItemDataBound="ObjectActionRepeater_ItemDataBound">
                            <ItemTemplate>
                                <div class="actionCheckBoxList" style="padding-right: 35px; display: inline; ">
                                    <asp:CheckBox ID="ActionCheckBox" runat="server" />
                                    <asp:Label ID="ActionLabel" runat="server" Text='<%# Eval("ObjectActionName") %>' />
                                    <asp:HiddenField ID="ActionId" runat="server" Value='<%# Eval("ObjectActionID") %>' />
                                </div>
                            </ItemTemplate>
                            <FooterTemplate>
                                <asp:Label ID="lblEmptyData" runat="server" Visible='<%# ((Repeater)Container.NamingContainer).Items.Count == 0 %>' Text="<%$ Resources:ShareData, lblEmptyData %>" />
                            </FooterTemplate>
                        </asp:Repeater>
                        <div class="has-error m-b-10">
                            <asp:CustomValidator ID="ObjectActionCustomValidator" runat="server" Display="Dynamic" ValidationGroup="InviteUser" 
                                ErrorMessage="<%$ Resources:ShareData, ObjectActionCustomValidator %>" ClientValidationFunction="ObjectActionCustomValidator_Validate">
                            </asp:CustomValidator>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer btn-colors">
                <asp:LinkButton ID="SaveUserButton" runat="server" CssClass="btn btn-primary" ValidationGroup="InviteUser" 
                    OnClientClick="return VerifiyData()" OnClick="SaveUserButton_Click" Text="<%$ Resources:ShareData, SaveUserButton %>" />
                <a class="btn btn-danger" href="javascript:CloseInviteUserModal();"><asp:Literal ID="CancelButton" runat="server" Text="<%$ Resources:ShareData, CancelButton %>" /></a>
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
            $('.actionCheckBoxList :checkbox').each(function () {
                this.checked = false;
                this.disabled = false;
            });
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

                // disabled OWNER
                $('.actionCheckBoxList :checkbox').each(function () {
                    if ($(this).next().next().val() == "OWN") {
                        this.checked = false;
                        this.disabled = true;
                    }
                });
            } else {
                $("#<%= UserTextBox.ClientID %>").prop('disabled', false);
                // enabled OWNER
                $('.actionCheckBoxList :checkbox').each(function () {
                    if ($(this).next().next().val() == "OWN") {
                        this.checked = false;
                        this.disabled = false;
                    }
                });
            }
        });

        function ActionCheckBox_change(item, actionId) {
            if (item.checked && actionId == "OWN") {
                UnCheckAndDisableAllActions(item);
            } else if (!item.checked && actionId == "OWN") {
                EnableAllActions(item);
            }
        }

        function UnCheckAndDisableAllActions(item) {
            $('.actionCheckBoxList :checkbox').each(function () {
                if (this != item) {
                    this.checked = false;
                    this.disabled = true;
                }
            });
        }

        function EnableAllActions(item) {
            $('.actionCheckBoxList :checkbox').each(function () {
                if (this != item) {
                    this.disabled = false;
                }
            });
        }

        function UserCustomValidator_Validate(sender, args) {
            args.IsValid = false;

            if (!$("#<%= EveryoneCheckBox.ClientID%>").is(':checked')) {
                var value = $('#<%= UserInvitedIdHiddenField.ClientID %>').val();
                if (value == null || value == "") {
                    args.IsValid = false;
                    $(sender).text(<%= Resources.ShareData.UserCustomValidator %>);
                } else {
                    var param = JSON.stringify({ 'userId': $("#<%= UserInvitedIdHiddenField.ClientID %>").val() });
                    var data;
                    $.ajax({
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        url: "ShareOrganization.aspx/VerifiyActualUser",
                        data: param,
                        dataType: "json",
                        async: false,
                        success: function (msg) {
                            data = msg.d;
                        },
                        error: function (XMLHttpRequest, textStatus, errorThrown) {
                            alert(textStatus + ": " + jQuery.parseJSON(XMLHttpRequest.responseText).Message);
                        },
                        failure: function () {
                            alert(<%= Resources.ShareData.VerifyActualUserFail %>);
                        }
                    });

                    if (data) {
                        args.IsValid = false;
                        $(sender).text(<%= Resources.ShareData.UserActualCustomValidator %>);
                    } else {
                        args.IsValid = true;
                    }
                }
            }
        }

        function ObjectActionCustomValidator_Validate(sender, args) {
            args.IsValid = false;

            $('.actionCheckBoxList :checkbox').each(function () {
                if (this.checked) {
                    args.IsValid = true;
                    return;
                }
            });
        }

        function VerifiyData() {
            if (Page_ClientValidate("InviteUser") == true) {

                var param = JSON.stringify({ 'organizationId': $("#<%= OrganizationIdHiddenField.ClientID %>").val(), 'userId': $("#<%= UserInvitedIdHiddenField.ClientID %>").val() });
                var data;
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: "ShareOrganization.aspx/VerifiyUser",
                    data: param,
                    dataType: "json",
                    async: false,
                    success: function (msg) {
                        data = msg.d;
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        alert(textStatus + ": " + jQuery.parseJSON(XMLHttpRequest.responseText).Message);
                    },
                    failure: function () {
                        alert(<%= Resources.ShareData.VerifiyDataFail %>);
                    }
                });

                if (data) {
                    if (confirm(<%= Resources.ShareData.ConfirmOverwritePermissions %>)) {
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
    <asp:HiddenField ID="OrganizationIdHiddenField" runat="server" />
    <asp:HiddenField ID="ShowInviteUserModal" runat="server" Value="false" />

    <asp:ObjectDataSource ID="PermissionsObjectDataSource" runat="server" OldValuesParameterFormatString="original_{0}"
        TypeName="Artexacta.App.PermissionObject.BLL.PermissionObjectBLL" SelectMethod="GetPermissionsByObject"
        OnSelected="ObjectDataSource_Selected">
        <SelectParameters>
            <asp:ControlParameter ControlID="ObjectTypeIdHiddenField" PropertyName="Value" Name="objectTypeId" Type="String" />
            <asp:ControlParameter ControlID="OrganizationIdHiddenField" PropertyName="Value" Name="objectId" Type="Int32" />
        </SelectParameters>
    </asp:ObjectDataSource>

    <asp:ObjectDataSource ID="ObjectActionObjectDataSource" runat="server" OldValuesParameterFormatString="original_{0}" 
        TypeName="Artexacta.App.ObjectAction.BLL.ObjectActionBLL" SelectMethod="GetObjectActionsForOrganization" 
        OnSelected="ObjectDataSource_Selected">
        <SelectParameters>
            <asp:ControlParameter ControlID="OrganizationIdHiddenField" PropertyName="Value" Name="organizationId" Type="Int32" />
        </SelectParameters>
    </asp:ObjectDataSource>

</asp:Content>


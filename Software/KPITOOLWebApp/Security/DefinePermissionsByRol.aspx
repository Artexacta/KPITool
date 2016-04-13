<%@ Page Title="Definir permisos a Roles" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="DefinePermissionsByRol.aspx.cs" Inherits="Security_DefinePermissionsByRol" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="Server">
    <div class="ibox float-e-margins">
        <div class="ibox-title">
            <h5>
                <asp:Label ID="TituloLabel" runat="server" Text="Definir permisos a Roles" CssClass="title"></asp:Label></h5>
            <div class="ibox-tools">
                <a class="collapse-link">
                    <i class="fa fa-chevron-up"></i>
                </a>
            </div>
        </div>
        <div class="ibox-content">
            <div class="row">
                <div class="col-md-12">
                    <div class="row">
                        <div class="col-md-4">
                            <asp:Label ID="SelectLabel" runat="server" Text="Seleccionar Rol:"></asp:Label>
                            <telerik:RadComboBox ID="RoleDropDownList" runat="server" AutoPostBack="True" DataSourceID="RoleObjectDataSource" Height="30"
                                OnDataBound="RoleDropDownList_DataBound" OnSelectedIndexChanged="RoleDropDownList_SelectedIndexChanged" Skin="aetemplate" EnableEmbeddedSkins="false">
                            </telerik:RadComboBox>
                            <asp:LinkButton ID="AddNewRoleLinkButton" runat="server" CausesValidation="False"
                                OnClick="AddNewRoleLinkButton_Click" CssClass="btn btn-primary min-letter">
								<i class="fa fa-plus"></i> Adicionar Nuevo Rol
                            </asp:LinkButton>
                        </div>
                    </div>
                </div>
                <div class="col-md-12">
                    <p>
                        <asp:Label ID="ChangeLabel" runat="server" Text="Cambiar permisos para el Rol:"></asp:Label>
                        <asp:Label ID="RoleLabel" runat="server" ForeColor="#333333" Font-Bold="True"></asp:Label>
                    </p>
                    <div class="table-responsive">
                        <asp:GridView ID="RolePermissionGridView" runat="server" AutoGenerateColumns="False"
                            DataSourceID="RolePermissionObjectDataSource" CssClass="table table-striped table-bordered table-hover" GridLines="None">
                            <HeaderStyle CssClass="rgHeader head" />
                            <FooterStyle CssClass="foot" />
                            <AlternatingRowStyle CssClass="altRow" />
                            <EmptyDataRowStyle CssClass="gridNoData" />
                            <RowStyle CssClass="" />
                            <Columns>
                                <asp:TemplateField HeaderText="Rol" SortExpression="Role">
                                    <ItemTemplate>
                                        <asp:Label ID="Label2" runat="server" Text='<%# Bind("Role") %>' Width="120px"></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle Width="120px" />
                                    <ItemStyle Width="120px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="" SortExpression="RoleHasPermission">
                                    <ItemTemplate>
                                        <asp:CheckBox ID="CheckBox1" runat="server" Checked='<%# Bind("RoleHasPermission") %>' />
                                    </ItemTemplate>
                                    <HeaderTemplate>
                                        <asp:LinkButton ID="SelectAllLinkButton" runat="server" OnClick="SelectAllLinkButton_Click"
                                            CssClass="text-info">
                                            <i class="fa fa-caret-down"></i> Seleccionar Todo
                                        </asp:LinkButton>
                                    </HeaderTemplate>
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="PermissionID" SortExpression="PermissionID" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="Label1" runat="server" Text='<%# Bind("PermissionID") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Description" HeaderText="Descripción del permiso" SortExpression="Description"
                                    ItemStyle-Width="350px" ItemStyle-HorizontalAlign="Center" />
                            </Columns>
                        </asp:GridView>
                    </div>
                    <div class="text-center" style="margin: 15px 0;">
                        <asp:LinkButton ID="SavePermissionsButton" runat="server" OnClick="SavePermissionsButton_Click"
                            CssClass="btn btn-primary">
					<i class="fa fa-floppy-o"></i> Grabar permisos
                        </asp:LinkButton>
                        <asp:LinkButton ID="ResetPermissionsButton" runat="server" OnClick="ResetPermissionsButton_Click"
                            CssClass="btn btn-info">
					<i class="fa fa-refresh"></i> Resetear permisos
                        </asp:LinkButton>
                    </div>
                </div>
            </div>
        </div>
        <script type="text/javascript">
            $(document).ready(function () {
                $(':checkbox').iCheck({
                    checkboxClass: 'icheckbox_square-green',
                    radioClass: 'iradio_square-green',
                });
                $("#ctl00_cp_AddNewRoleLinkButton").css("margin-top", "5px");
            });
        </script>
    </div>

    <asp:ObjectDataSource ID="RoleObjectDataSource" runat="server" OnSelected="RoleObjectDataSource_Selected"
        SelectMethod="GetAllDefinedRoles" TypeName="Artexacta.App.Security.BLL.SecurityBLL"
        OldValuesParameterFormatString="original_{0}"></asp:ObjectDataSource>
    <asp:ObjectDataSource ID="RolePermissionObjectDataSource" runat="server" OnSelected="PermissionObjectDataSource_Selected"
        SelectMethod="GetPermissionsForRole" TypeName="Artexacta.App.Permissions.Role.BLL.PermissionRoleBLL"
        OldValuesParameterFormatString="original_{0}">
        <SelectParameters>
            <asp:ControlParameter ControlID="RoleDropDownList" Name="Role" PropertyName="SelectedValue"
                Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
</asp:Content>


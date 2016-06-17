<%@ Page Title="<%$ Resources:SecurityData, PageTitlePermissionRole %>" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="DefinePermissionsByRol.aspx.cs" Inherits="Security_DefinePermissionsByRol" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="Server">
    <div class="ibox float-e-margins">
        <div class="ibox-title">
            <h5><asp:Literal ID="TituloLabel" runat="server" Text="<%$ Resources:SecurityData, PageTitlePermissionRole %>"></asp:Literal></h5>
            <div class="ibox-tools">
                <a class="collapse-link">
                    <i class="fa fa-chevron-up"></i>
                </a>
            </div>
        </div>
        <div class="ibox-content">
            <div class="row">
                <div class="col-md-4 m-b-10">
                    <asp:Label ID="SelectRolLabel" runat="server" Text="<%$ Resources:SecurityData, RoleLabel %>"></asp:Label>
                    <asp:DropDownList ID="RoleDropDownList" runat="server" DataSourceID="RoleObjectDataSource" AutoPostBack="true" CssClass="form-control m-b-10" 
                        OnSelectedIndexChanged="RoleDropDownList_SelectedIndexChanged" OnDataBound="RoleDropDownList_DataBound" />
                    <asp:LinkButton ID="AddNewRoleLinkButton" runat="server" CausesValidation="False" Visible="false" 
                        OnClick="AddNewRoleLinkButton_Click" CssClass="btn btn-primary min-letter" Text="<%$ Resources:SecurityData, AddNewRoleButton %>">
                    </asp:LinkButton>
                </div>
            </div>

            <div class="row">
                <div class="col-md-12">
                    <p>
                        <asp:Label ID="ChangePermissionLabel" runat="server" Text="<%$ Resources:SecurityData, ChangePermissionLabel %>"></asp:Label>
                        <asp:Label ID="RoleLabel" runat="server" ForeColor="#333333" Font-Bold="True"></asp:Label>
                    </p>
                    <div class="table-responsive">
                        <asp:GridView ID="RolePermissionGridView" runat="server" AutoGenerateColumns="False" 
                            DataSourceID="RolePermissionObjectDataSource" CssClass="table table-striped table-bordered table-hover" GridLines="None">
                            <HeaderStyle CssClass="rgHeader head" />
                            <FooterStyle CssClass="foot" />
                            <AlternatingRowStyle CssClass="altRow" />
                            <EmptyDataRowStyle CssClass="gridNoData" />
                            <Columns>
                                <asp:TemplateField HeaderText="<%$ Resources:SecurityData, RoleColumn %>">
                                    <ItemTemplate>
                                        <asp:Label ID="Label2" runat="server" Text='<%# Bind("Role") %>' Width="120px"></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle Width="120px" />
                                    <ItemStyle Width="120px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="">
                                    <ItemTemplate>
                                        <asp:CheckBox ID="CheckBox1" runat="server" Checked='<%# Bind("RoleHasPermission") %>' CssClass="i-checks" />
                                    </ItemTemplate>
                                    <HeaderTemplate>
                                        <asp:LinkButton ID="SelectAllLinkButton" runat="server" OnClick="SelectAllLinkButton_Click"
                                            CssClass="text-info" Text="<%$ Resources:SecurityData, SelectAllButton %>">
                                        </asp:LinkButton>
                                    </HeaderTemplate>
                                    <HeaderStyle Width="200px" />
                                    <ItemStyle HorizontalAlign="Center" Width="200px" />
                                </asp:TemplateField>
                                <asp:BoundField DataField="Description" HeaderText="<%$ Resources:SecurityData, DescriptionColumn %>" ItemStyle-HorizontalAlign="Center" />
                            </Columns>
                        </asp:GridView>
                    </div>
                    <div class="text-center" style="margin: 15px 0;">
                        <asp:LinkButton ID="SavePermissionsButton" runat="server" OnClick="SavePermissionsButton_Click" 
                            CssClass="btn btn-primary" Text="<%$ Resources:SecurityData, SavePermissionsButton %>">
                        </asp:LinkButton>
                        <asp:LinkButton ID="ResetPermissionsButton" runat="server" OnClick="ResetPermissionsButton_Click" 
                            CssClass="btn btn-info" Text="<%$ Resources:SecurityData, ResetPermissionsButton %>">
                        </asp:LinkButton>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        $(document).ready(function () {
            $('.i-checks').find('input:checkbox').each(function () {
                var attr = $(this).attr('checked');
                if (typeof attr == typeof undefined || attr != 'checked') {
                    $(this).removeClass("icheckbox_square-green");
                    $(this).removeClass("iradio_square-green");
                } else {
                    $(this).addClass("icheckbox_square-green");
                    $(this).addClass("iradio_square-green");
                }
            });
        });
    </script>

    <asp:ObjectDataSource ID="RoleObjectDataSource" runat="server" OnSelected="RoleObjectDataSource_Selected" 
        SelectMethod="GetAllDefinedRoles" TypeName="Artexacta.App.Security.BLL.SecurityBLL" 
        OldValuesParameterFormatString="original_{0}">
    </asp:ObjectDataSource>

    <asp:ObjectDataSource ID="RolePermissionObjectDataSource" runat="server" OnSelected="PermissionObjectDataSource_Selected" 
        SelectMethod="GetPermissionsForRole" TypeName="Artexacta.App.Permissions.Role.BLL.PermissionRoleBLL" 
        OldValuesParameterFormatString="original_{0}">
        <SelectParameters>
            <asp:ControlParameter ControlID="RoleDropDownList" Name="Role" PropertyName="SelectedValue" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
</asp:Content>


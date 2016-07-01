<%@ Page Title="<%$ Resources:SecurityData, PageTitlePermissionUser %>" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="DefinepermissionsByUser.aspx.cs" Inherits="Security_DefinepermissionsByUser" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="Server">
    <div class="tile icons-demo">
        <div class="t-header">
            <div class="th-title">
                <asp:Literal ID="TitleLabel" runat="server" Text="<%$ Resources:SecurityData, PageTitlePermissionUser %>"></asp:Literal>
            </div>
        </div>
        <div class="t-body tb-padding">
            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <asp:Label ID="NameLabel" runat="server" Text="<%$ Resources:UserData, UserNameLabel %>"></asp:Label>
                        <asp:TextBox ID="UserNameTextBox" runat="server" CssClass="form-control" MaxLength="50"></asp:TextBox>
                        <div class="has-error m-b-10">
                            <asp:RegularExpressionValidator ID="NameFormatRegularExpressionValidator" runat="server" Display="Dynamic" 
                                ControlToValidate="UserNameTextBox" ErrorMessage="<%$ Resources:UserData, UserNameRegularExpressionValidator %>" 
                                ValidationExpression="<%$ Resources:Validations, UserNameFormat %>" ValidationGroup="SearchUser" />
                        </div>
                    </div>
                    <div class="form-group">
                        <asp:Label ID="FullNameLabel" runat="server" Text="<%$ Resources:UserData, FullNameLabel %>"></asp:Label>
                        <asp:TextBox ID="FullnameTextBox" runat="server" CssClass="form-control" MaxLength="250"></asp:TextBox>
                        <div class="has-error m-b-10">
                            <asp:RegularExpressionValidator ID="FormatNombreRegularExpressionValidator" runat="server" ControlToValidate="FullNameTextBox" 
                                Display="Dynamic" ErrorMessage="<%$ Resources:UserData, FormatNombreRegularExpressionValidator %>" 
                                ValidationExpression="<%$ Resources: Validations, DescriptionFormat %>" ValidationGroup="SearchUser" />
                        </div>
                    </div>
                    <div class="buttonsPanel text-center">
                        <asp:LinkButton ID="SubmitButton" runat="server" CssClass="btn btn-primary" ValidationGroup="SearchUser" 
                            OnClick="SubmitButton_Click" Text="<%$ Resources:SecurityData, SearchUserButton %>">
                        </asp:LinkButton>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-md-12 m-b-10 m-t-10">
                    <div class="table-responsive">
                        <asp:GridView ID="EmployeeGridView" runat="server" AllowPaging="True" AutoGenerateColumns="False" 
                            DataKeyNames="UserId,FullName" DataSourceID="UserObjectDataSource" OnDataBound="EmployeeGridView_DataBound" 
                            OnSelectedIndexChanged="EmployeeGridView_SelectedIndexChanged" 
                            PageSize="5" Visible="False" CssClass="table table-striped table-bordered table-hover" GridLines="None">
                            <HeaderStyle CssClass="rgHeader head" />
                            <FooterStyle CssClass="foot" />
                            <AlternatingRowStyle CssClass="altRow" />
                            <EmptyDataRowStyle CssClass="gridNoData" />
                            <Columns>
                                <asp:TemplateField HeaderText="<%$ Resources:SecurityData, SelectColumn %>" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="80px">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="SelectImageButton" runat="server" CommandName="Select" CssClass="text-success" Text="<i class='fa fa-pencil'></i>" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Username" HeaderText="<%$ Resources:UserData, UserNameColumn %>" ItemStyle-Width="140px" />
                                <asp:BoundField DataField="FullName" HeaderText="<%$ Resources:UserData, FullNameColumn %>" ItemStyle-Width="180px" ItemStyle-HorizontalAlign="Center" />
                            </Columns>
                            <EmptyDataTemplate>
                                <asp:Label ID="EmptyRowUser" runat="server" Text="<%$ Resources:UserData, EmptyRowUser %>"></asp:Label>
                            </EmptyDataTemplate>
                        </asp:GridView>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-md-12 m-t-10">
                    <asp:Panel ID="PermissionPanel" runat="server" Visible="False" DefaultButton="SavePermissionsButton" CssClass="frame">
                        <asp:Label ID="SelectUserLabel" runat="server" Text="<%$ Resources:SecurityData, SelectUserLabel %>" Visible="False"></asp:Label>
                        <asp:Label ID="ChangeLabel" runat="server" Text="<%$ Resources:SecurityData, ChangePermissionUserLabel %>" Visible="False"></asp:Label>
                        <asp:Label ID="UserLabel" runat="server" Font-Bold="True"></asp:Label><br />
                        <div style="clear: both;">
                        </div>
                        <div class="table-responsive">
                            <asp:GridView ID="EmployeePermissionsGridView" runat="server" AutoGenerateColumns="False" 
                                DataSourceID="UserPermissionsObjectDataSource" DataKeyNames="UserId,PermissionId" 
                                CssClass="table table-striped table-bordered table-hover" GridLines="None">
                                <HeaderStyle CssClass="rgHeader head" />
                                <FooterStyle CssClass="foot" />
                                <AlternatingRowStyle CssClass="altRow" />
                                <EmptyDataRowStyle CssClass="gridNoData" />
                                <RowStyle CssClass="" />
                                <Columns>
                                    <asp:TemplateField HeaderText="PermissionId" SortExpression="PermissionId" Visible="False">
                                        <ItemTemplate>
                                            <asp:Label ID="PermissionIDLabel" runat="server" Text='<%# Bind("PermissionId") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="UserId" SortExpression="UserId" Visible="False">
                                        <ItemTemplate>
                                            <asp:Label ID="UserIDLabel" runat="server" Text='<%# Bind("UserId") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="" ItemStyle-Width="120px">
                                        <EditItemTemplate>
                                            <asp:CheckBox ID="CheckBox1" runat="server" Checked='<%# Bind("UserHasPermission") %>' />
                                        </EditItemTemplate>
                                        <HeaderTemplate>
                                            <asp:LinkButton ID="SelectAllLinkButton" runat="server" OnClick="SelectAllLinkButton_Click"
                                                CssClass="text-info" Text="<%$ Resources:SecurityData, SelectAllButton %>">
                                            </asp:LinkButton>
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:CheckBox ID="CheckBox1" runat="server" Checked='<%# Bind("UserHasPermission") %>' />
                                        </ItemTemplate>
                                        <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="Description" HeaderText="<%$ Resources:SecurityData, DescriptionColumn %>" 
                                        ItemStyle-Width="300px" ItemStyle-HorizontalAlign="Center" />
                                </Columns>
                            </asp:GridView>
                        </div>
                        <div class="text-center" style="margin-top: 15px;">
                            <asp:LinkButton ID="SavePermissionsButton" runat="server" OnClick="SavePermissionsButton_Click"
                                CssClass="btn btn-primary" Text="<%$ Resources:SecurityData, SavePermissionsButton %>">
                            </asp:LinkButton>
                            <asp:LinkButton ID="ResetButton" runat="server" OnClick="ResetButton_Click" 
                                CssClass="btn btn-info" Text="<%$ Resources:SecurityData, ResetPermissionsButton %>">
                            </asp:LinkButton>
                        </div>
                    </asp:Panel>
                    <div class="clear"></div>
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

    <asp:HiddenField ID="FullnameHiddenField" runat="server" />
    <asp:HiddenField ID="UserNameHiddenField" runat="server" />
    <asp:HiddenField ID="SelectedUserIdHiddenField" runat="server" />

    <asp:ObjectDataSource ID="UserObjectDataSource" runat="server" OnSelected="UserObjectDataSource_Selected"
        SelectMethod="GetUsersBySearchParameters" TypeName="Artexacta.App.User.BLL.UserBLL"
        OldValuesParameterFormatString="original_{0}">
        <SelectParameters>
            <asp:ControlParameter ControlID="UserNameHiddenField" Name="Username" PropertyName="Value" Type="String" />
            <asp:ControlParameter ControlID="FullnameHiddenField" Name="Fullname" PropertyName="Value" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
                
    <asp:ObjectDataSource ID="UserPermissionsObjectDataSource" runat="server" OldValuesParameterFormatString="original_{0}"
        OnSelected="UserPermissionsObjectDataSource_Selected" SelectMethod="GetPermissionsForUser"
        TypeName="Artexacta.App.Permissions.User.BLL.PermissionUserBLL">
        <SelectParameters>
            <asp:ControlParameter ControlID="SelectedUserIdHiddenField" Name="UserId" PropertyName="Value" Type="Int32" />
        </SelectParameters>
    </asp:ObjectDataSource>

</asp:Content>


<%@ Page Title="<%$ Resources:SecurityData, PageTitleUserRoles %>" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="AssignRolesByUser.aspx.cs" Inherits="Security_AssignRolesByUser" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="Server">
    <div class="ibox float-e-margins">
        <div class="ibox-title">
            <h5><asp:Literal ID="TitleLabel" runat="server" Text="<%$ Resources:SecurityData, PageTitleUserRoles %>"></asp:Literal></h5>
            <div class="ibox-tools">
                <a class="collapse-link">
                    <i class="fa fa-chevron-up"></i>
                </a>
            </div>
        </div>
        <div class="ibox-content">
            <div class="row">
                <div class="col-md-4">
                    <asp:TextBox ID="UserNameTextBox" runat="server" CssClass="form-control" placeholder="<%$ Resources:UserData, UserNameColumn %>" MaxLength="50"></asp:TextBox>
                    <div class="has-error m-b-10">
                        <asp:RegularExpressionValidator ID="NameFormatRegularExpressionValidator" runat="server" Display="Dynamic" 
                            ControlToValidate="UserNameTextBox" ErrorMessage="<%$ Resources:UserData, UserNameRegularExpressionValidator %>" 
                            ValidationExpression="<%$ Resources:Validations, UserNameFormat %>" ValidationGroup="SearchUser" />
                    </div>
                </div>
                <div class="col-md-4">
                    <asp:LinkButton ID="SearchButton" runat="server" CssClass="btn btn-primary " ValidationGroup="SearchUser" 
                        OnClick="SearchButton_Click" Text="<%$ Resources:SecurityData, SearchUserButton %>">
                    </asp:LinkButton>
                </div>
            </div>
            <div class="row">
                <div class="col-md-12 m-t-10 m-b-10">
                    <asp:Panel ID="UserPanel" runat="server" CssClass="table-responsive">
                        <asp:GridView ID="UserGridView" runat="server" AutoGenerateColumns="False" DataSourceID="UsersObjectDataSource" 
                            DataKeyNames="UserName" OnSelectedIndexChanged="UserGridView_SelectedIndexChanged" 
                            CssClass="table table-striped table-bordered table-hover" GridLines="None">
                            <HeaderStyle CssClass="rgHeader head" />
                            <FooterStyle CssClass="foot" />
                            <AlternatingRowStyle CssClass="altRow" />
                            <EmptyDataRowStyle CssClass="gridNoData" />
                            <Columns>
                                <asp:TemplateField HeaderText="<%$ Resources:SecurityData, SelectColumn %>" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="80px">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="SelectImageButton" runat="server" CommandName="Select" CssClass="text-success" Text="<i class='fa fa-pencil'></i>"
                                            CausesValidation="false" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="<%$ Resources:UserData, UserNameColumn %>" HeaderStyle-Width="200px" ItemStyle-Width="200px">
                                    <EditItemTemplate>
                                        <asp:Label ID="Label1" runat="server" Text='<%# Eval("UserName") %>'></asp:Label>
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="Label1" runat="server" Text='<%# Bind("UserName") %>' Width="200px"></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Email" HeaderText="<%$ Resources:UserData, EmailColumn %>" SortExpression="Email" ItemStyle-Width="200px" />
                            </Columns>
                            <EmptyDataTemplate>
                                <asp:Label ID="EmptyRowUser" runat="server" Text="<%$ Resources:UserData, EmptyRowUser %>"></asp:Label>
                            </EmptyDataTemplate>
                        </asp:GridView>
                    </asp:Panel>
                </div>
            </div>
            <div class="row">
                <div class="col-md-12">
                    <asp:Panel ID="EmployeeRolePanel" runat="server" CssClass="frame" Visible="false">
                        <h6>
                            <asp:Label ID="TitleUserLabel" runat="server" Text="<%$ Resources:SecurityData, TitleUserLabel %>" Font-Size="Small" Font-Bold="true"></asp:Label>
                        </h6>
                        <p>
                            <asp:Label ID="User1Label" runat="server" Text="<%$ Resources:UserData, UserNameLabel %>"></asp:Label>
                            <asp:Label ID="UserLabel" runat="server"></asp:Label>
                        </p>
                        <p>
                            <asp:Label ID="UserEmail1Label" runat="server" Text="<%$ Resources:UserData, EmailLabel %>"></asp:Label>
                            <asp:Label ID="UserEmailLabel" runat="server"></asp:Label>
                        </p>
                        <p>
                            <asp:Label ID="RolesLabel" runat="server" Text="<%$ Resources:SecurityData, RolesLabel %>"></asp:Label>
                        </p>
                        <div style="margin: 15px 0;">
                            <asp:CheckBoxList ID="UserRoleCheckBoxList" runat="server" BackColor="Transparent">
                            </asp:CheckBoxList>
                        </div>
                        <div class="text-center" style="margin-top:15px;">
                            <asp:LinkButton ID="SaveRolesButton" runat="server" OnClick="SaveRolesButton_Click" 
                                CssClass="btn btn-primary" Text="<%$ Resources:SecurityData, SaveRolesButton %>">
							</asp:LinkButton>
                            <asp:LinkButton ID="ResetRolesButton" runat="server" OnClick="ResetRolesButton_Click" 
                                CssClass="btn btn-info" Text="<%$ Resources:SecurityData, ResetRolesButton %>">
                            </asp:LinkButton>
                        </div>
                    </asp:Panel>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        $(document).ready(function () {
            $('input:checkbox').each(function () {
                var attr = $(this).attr('checked');
                if (typeof attr == typeof undefined || attr != 'checked') {
                    $(this).removeClass("icheckbox_square-green");
                    $(this).removeClass("iradio_square-green");
                } else {
                    $(this).addClass("icheckbox_square-green");
                    $(this).addClass("iradio_square-green");
                }
            });

            $('.icheckbox_square-green').css("margin-right", "10px");
        });
    </script>
    
    <asp:HiddenField ID="UserNameHiddenField" runat="server" />

    <asp:ObjectDataSource ID="UsersObjectDataSource" runat="server" OldValuesParameterFormatString="original_{0}"
        SelectMethod="LookUpUsers" TypeName="Artexacta.App.Security.BLL.SecurityBLL" OnSelected="UsersObjectDataSource_Selected">
        <SelectParameters>
            <asp:ControlParameter ControlID="UserNameHiddenField" Name="UserName" PropertyName="Value" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>

</asp:Content>


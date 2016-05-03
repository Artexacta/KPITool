<%@ Page Title="Asignar Roles por Usuario" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="AssignRolesByUser.aspx.cs" Inherits="Security_AssignRolesByUser" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="Server">
    <div class="ibox float-e-margins">
        <div class="ibox-title">
            <h5>
                <asp:Label ID="TitleLabel1" runat="server" Text="Asignar Roles por Usuario" CssClass="title"></asp:Label></h5>
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
                        <div class="col-md-6">
                            <div class="row">
                                <div class="col-md-8">
                                    <asp:TextBox ID="UserNameTextBox" runat="server" CssClass="form-control" placeholder="Nombre de Usuario"></asp:TextBox>
                                </div>
                                <div class="col-md-4">
                                    <asp:RegularExpressionValidator ID="NameFormatRegularExpressionValidator" runat="server"
                                        ControlToValidate="UserNameTextBox" Display="Dynamic" ErrorMessage="Caracteres inválidos en el nombre del usuario."
                                        ValidationExpression="^[A-Za-z\-_\s\.]+$">*</asp:RegularExpressionValidator>
                                    <asp:RegularExpressionValidator ID="NameLengthRegularExpressionValidator" runat="server"
                                        ControlToValidate="UserNameTextBox" Display="Dynamic" ErrorMessage="El nombre de usuario no puede exceder los 50 caracteres."
                                        ValidationExpression="[\w\W]{0,50}">*</asp:RegularExpressionValidator>
                                    <asp:LinkButton ID="SearchButton" runat="server" CssClass="btn btn-primary " OnClick="SearchButton_Click"><i class="fa fa-search"></i> Buscar Usuarios
                                    </asp:LinkButton>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-12">
                    <div style="clear: both; margin-bottom: 10px; "></div>
                    <asp:Panel ID="UserPanel" runat="server" CssClass="table-responsive">
                        <asp:GridView ID="UserGridView" runat="server" AutoGenerateColumns="False" DataSourceID="UsersObjectDataSource"
                            DataKeyNames="UserName" OnSelectedIndexChanged="UserGridView_SelectedIndexChanged"
                            CssClass="table table-striped table-bordered table-hover" GridLines="None">
                            <HeaderStyle CssClass="rgHeader head" />
                            <FooterStyle CssClass="foot" />
                            <AlternatingRowStyle CssClass="altRow" />
                            <EmptyDataRowStyle CssClass="gridNoData" />
                            <RowStyle CssClass="" />
                            <Columns>
                                <asp:TemplateField HeaderText="Seleccionar" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="80px">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="SelectImageButton" runat="server" CommandName="Select" CssClass="text-success" Text="<i class='fa fa-pencil'></i>"
                                            CausesValidation="false" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Nombre de Usuario" SortExpression="UserName">
                                    <EditItemTemplate>
                                        <asp:Label ID="Label1" runat="server" Text='<%# Eval("UserName") %>'></asp:Label>
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="Label1" runat="server" Text='<%# Bind("UserName") %>' Width="200px"></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle Width="200px" />
                                    <ItemStyle Width="200px" />
                                </asp:TemplateField>
                                <asp:BoundField DataField="Email" HeaderText="Correo Electrónico" SortExpression="Email"
                                    ItemStyle-Width="200px" />
                            </Columns>
                        </asp:GridView>
                    </asp:Panel>
                    <div style="clear: both; margin-bottom: 20px; "></div>
                </div>
                <div class="col-md-12">
                    <asp:Panel ID="EmployeeRolePanel" runat="server" CssClass="frame" Visible="false">
                        <div>
                            <p>
                                <asp:Label ID="TitleLabel" runat="server" Text="Información del Usuario Seleccionado"
                                    Font-Size="Small" Font-Bold="true"></asp:Label>
                            </p>
                        </div>
                        <div>
                            <p>
                                <asp:Label ID="User1Label" runat="server" Text="Nombre de Usuario"></asp:Label>
                                <asp:Label ID="UserLabel" runat="server" Font-Bold="True"></asp:Label>
                            </p>
                            <p>
                                <asp:Label ID="Label2" runat="server" Text="Correo Electrónico"></asp:Label>
                                <asp:Label ID="UserEmailLabel" runat="server" Text="Correo Electrónico"></asp:Label>
                            </p>
                        </div>
                        <div>
                            <p>
                                <asp:Label ID="RolesLabel" runat="server" Text="Roles para el Usuario"></asp:Label>
                            </p>
                            <asp:CheckBoxList ID="UserRoleCheckBoxList" runat="server" BackColor="Transparent">
                            </asp:CheckBoxList>
                        </div>
                        <div class="text-center" style="margin-top:15px;">
                            <asp:LinkButton ID="SaveRolesButton" runat="server" CssClass="btn btn-primary" OnClick="SaveRolesButton_Click">
								<i class="fa fa-floppy-o"></i> Grabar los Roles del Usuario
                            </asp:LinkButton>
                            <asp:LinkButton ID="ResetRolesButton" runat="server" CssClass="btn btn-info" OnClick="ResetRolesButton_Click">
								<i class="fa fa-refresh"></i> Resetar los Roles del usuario
                            </asp:LinkButton>
                        </div>
                    </asp:Panel>
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
    </div>
    <asp:ObjectDataSource ID="UsersObjectDataSource" runat="server" OldValuesParameterFormatString="original_{0}"
        SelectMethod="LookUpUsers" TypeName="Artexacta.App.Security.BLL.SecurityBLL"
        OnSelected="UsersObjectDataSource_Selected">
        <SelectParameters>
            <asp:ControlParameter ControlID="UserNameHiddenField" Name="UserName" PropertyName="Value"
                Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:HiddenField ID="UserNameHiddenField" runat="server" />
</asp:Content>


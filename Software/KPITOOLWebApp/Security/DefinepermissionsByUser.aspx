<%@ Page Title="Definir permisos a Usuarios" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="DefinepermissionsByUser.aspx.cs" Inherits="Security_DefinepermissionsByUser" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="Server">
    <div class="ibox float-e-margins">
        <div class="ibox-title">
            <h5>
                <asp:Label ID="TitleLabel" runat="server" Text="Definir permisos a Usuarios" CssClass="title"></asp:Label></h5>
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
                            <div class="form-group">
                                <asp:Label ID="NameLabel" runat="server" Text="<label>Nombre de Usuario:</label>"></asp:Label>
                                <asp:TextBox ID="UserNameTextBox" runat="server" CssClass="form-control"></asp:TextBox>
                                <div class="validation">
                                    <asp:RegularExpressionValidator ID="UserNameFormatRegularExpressionValidator" runat="server"
                                        ControlToValidate="UserNameTextBox" Display="Dynamic" ErrorMessage="Caracteres inválidos en el nombre del usuario."
                                        ValidationExpression="<%$ Resources : Validations , ShortDescriptionFormat %>">*</asp:RegularExpressionValidator>
                                    <asp:RegularExpressionValidator ID="UserNameLengthRegularExpressionValidator" runat="server"
                                        ControlToValidate="UserNameTextBox" Display="Dynamic" ErrorMessage="El nombre de usuario no puede exceder los 50 caracteres."
                                        ValidationExpression="<%$ Resources : Validations , GenericLength50 %>">*</asp:RegularExpressionValidator>
                                </div>
                            </div>
                            <div class="form-group">
                                <asp:Label ID="Label1" runat="server" Text="<label>Nombre Completo:</label>"></asp:Label>
                                <asp:TextBox ID="FullnameTextBox" runat="server" CssClass="form-control"></asp:TextBox>
                                <div class="validation">
                                    <asp:RegularExpressionValidator ID="FullNameFormatRegularExpressionValidator" runat="server"
                                        ControlToValidate="FullnameTextBox" Display="Dynamic" ValidationExpression="<%$ Resources : Validations , ShortDescriptionFormat %>"
                                        ErrorMessage="Caracteres inválidos en el nombre completo del usuario">*</asp:RegularExpressionValidator>
                                    <asp:RegularExpressionValidator ID="FullNameLengthRegularExpressionValidator" runat="server"
                                        ControlToValidate="FullnameTextBox" Display="Dynamic" ValidationExpression="<%$ Resources : Validations , GenericLength250 %>"
                                        ErrorMessage="El Nombre Completo no puede exceder de 250 caracteres.">*</asp:RegularExpressionValidator>
                                </div>
                            </div>
                            <div class="buttonsPanel text-center">
                                <asp:LinkButton ID="SubmitButton" runat="server" CssClass="btn btn-primary" OnClick="SubmitButton_Click">
									<i class="fa fa-search"></i> Buscar Usuarios
                                </asp:LinkButton>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="validation">
                                <asp:ValidationSummary ID="ValidationSummary1" runat="server" HeaderText="Corrija los siguientes errores para continuar:"
                                    Width="100%" />
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="table-responsive">
                                <asp:GridView ID="EmployeeGridView" runat="server" AllowPaging="True" AutoGenerateColumns="False"
                                    DataKeyNames="UserId,FullName" DataSourceID="UserObjectDataSource" OnDataBound="EmployeeGridView_DataBound"
                                    OnRowDataBound="EmployeeGridView_RowDataBound" OnSelectedIndexChanged="EmployeeGridView_SelectedIndexChanged"
                                    PageSize="5" Visible="False" CssClass="table table-striped table-bordered table-hover" GridLines="None">
                                    <HeaderStyle CssClass="rgHeader head" />
                                    <FooterStyle CssClass="foot" />
                                    <AlternatingRowStyle CssClass="altRow" />
                                    <EmptyDataRowStyle CssClass="gridNoData" />
                                    <RowStyle CssClass="" />
                                    <Columns>
                                        <asp:TemplateField HeaderText="Seleccionar" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="80px">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="SelectImageButton" runat="server" CommandName="Select" CssClass="text-success" Text="<i class='fa fa-pencil'></i>" />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="Username" HeaderText="Nombre de Usuario" SortExpression="Username"
                                            ItemStyle-Width="140px" />
                                        <asp:BoundField DataField="FullName" HeaderText="Nombre Completo" SortExpression="FullName"
                                            ItemStyle-Width="180px" ItemStyle-HorizontalAlign="Center" />
                                    </Columns>
                                    <EmptyDataTemplate>
                                        <asp:Label ID="EmptyLabel" runat="server" Text="No se encontró el usuario indicado."></asp:Label>
                                    </EmptyDataTemplate>
                                </asp:GridView>
                            </div>
                            <div style="clear: both;">
                                &nbsp;
                            </div>
                            <asp:Panel ID="PermissionPanel" runat="server" Visible="False" DefaultButton="SavePermissionsButton"
                                CssClass="frame">
                                <asp:Label ID="SelectLabel" runat="server" Text="Debe seleccionar un Usuario." Visible="False"></asp:Label>
                                <asp:Label ID="ChangingLabel" runat="server" Text="Cambiar permisos para el Usuario:"
                                    Visible="False"></asp:Label>
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
                                            <asp:TemplateField HeaderText="" SortExpression="UserHasPermission" ItemStyle-Width="120px">
                                                <EditItemTemplate>
                                                    <asp:CheckBox ID="CheckBox1" runat="server" Checked='<%# Bind("UserHasPermission") %>' />
                                                </EditItemTemplate>
                                                <HeaderTemplate>
                                                    <asp:LinkButton ID="SelectAllLinkButton" runat="server" OnClick="SelectAllLinkButton_Click"
                                                        CssClass="text-info">
										    <i class="fa fa-caret-down"></i> Seleccionar Todo	
                                                    </asp:LinkButton>
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <asp:CheckBox ID="CheckBox1" runat="server" Checked='<%# Bind("UserHasPermission") %>' />
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                                            </asp:TemplateField>
                                            <asp:BoundField DataField="Description" HeaderText="Descripción" SortExpression="Description"
                                                ItemStyle-Width="300px" ItemStyle-HorizontalAlign="Center" />
                                        </Columns>
                                    </asp:GridView>
                                </div>
                                <div style="clear: both;">
                                </div>
                                <div class="text-center" style="margin-top: 15px;">
                                    <asp:LinkButton ID="SavePermissionsButton" runat="server" OnClick="SavePermissionsButton_Click"
                                        CssClass="btn btn-primary">
							<i class="fa fa-floppy-o"></i> Grabar permisos	
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="ResetButton" runat="server" OnClick="ResetButton_Click" CssClass="btn btn-info">
							<i class="fa fa-refresh"></i> Resetear permisos
                                    </asp:LinkButton>
                                </div>
                            </asp:Panel>
                            <div class="clear"></div>
                        </div>
                    </div>
                    <script type="text/javascript">
                        $(document).ready(function () {
                            $(':checkbox').iCheck({
                                checkboxClass: 'icheckbox_square-green',
                                radioClass: 'iradio_square-green',
                            });
                        });
                    </script>
                </div>

                <asp:ObjectDataSource ID="UserObjectDataSource" runat="server" OnSelected="UserObjectDataSource_Selected"
                    SelectMethod="GetUsersBySearchParameters" TypeName="Artexacta.App.User.BLL.UserBLL"
                    OldValuesParameterFormatString="original_{0}">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="UserNameHiddenField" Name="Username" PropertyName="Value"
                            Type="String" />
                        <asp:ControlParameter ControlID="FullnameHiddenField" Name="Fullname" PropertyName="Value"
                            Type="String" />
                    </SelectParameters>
                </asp:ObjectDataSource>
                <asp:HiddenField ID="FullnameHiddenField" runat="server" />
                <asp:HiddenField ID="UserNameHiddenField" runat="server" />
                <asp:HiddenField ID="SelectedUserIdHiddenField" runat="server" />
                <asp:ObjectDataSource ID="UserPermissionsObjectDataSource" runat="server" OldValuesParameterFormatString="original_{0}"
                    OnSelected="UserPermissionsObjectDataSource_Selected" SelectMethod="GetPermissionsForUser"
                    TypeName="Artexacta.App.Permissions.User.BLL.PermissionUserBLL">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="SelectedUserIdHiddenField" Name="UserId" PropertyName="Value"
                            Type="Int32" />
                    </SelectParameters>
                </asp:ObjectDataSource>
            </div>
        </div>
    </div>
</asp:Content>


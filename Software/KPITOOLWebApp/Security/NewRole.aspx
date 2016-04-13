<%@ Page Title="Nuevo Rol" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="NewRole.aspx.cs" Inherits="Security_NewRole" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="Server">
    <div class="ibox float-e-margins">
        <div class="ibox-title">
            <h5>Nuevo Rol</h5>
            <div class="ibox-tools">
                <a class="collapse-link">
                    <i class="fa fa-chevron-up"></i>
                </a>
            </div>
        </div>
        <div class="ibox-content">
            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <asp:Label ID="RoleLabel" runat="server" Text="Rol:" AssociatedControlID="RoleNameTextBox"></asp:Label>
                        <asp:TextBox ID="RoleNameTextBox" runat="server" CssClass="form-control"></asp:TextBox>
                        <div class="validators">
                            <asp:RequiredFieldValidator ID="RoleNameRequiredFieldValidator" runat="server" ControlToValidate="RoleNameTextBox"
                                Display="Dynamic" ErrorMessage="La descripción del rol es requerido.">*</asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="FormatRoleNameRegularExpressionValidator" runat="server"
                                ControlToValidate="RoleNameTextBox" Display="Dynamic" ValidationExpression="<%$ Resources: Validations, NameFormat %>"
                                ErrorMessage="Caracteres inválidos en la descripción del rol.">*</asp:RegularExpressionValidator>
                            <asp:RegularExpressionValidator ID="LengthRegularExpressionValidator1" runat="server"
                                ControlToValidate="RoleNameTextBox" Display="Dynamic" ValidationExpression="<%$ Resources: Validations, GenericLength50 %>"
                                ErrorMessage="La descripción del rol no puede exceder 50 caracteres.">*</asp:RegularExpressionValidator>
                        </div>
                        <div class="validation">
                            <asp:ValidationSummary ID="ValidationSummary1" runat="server" HeaderText="Corrija los siguientes errores para continuar:" />
                        </div>
                    </div>
                    <div class="text-center" style="margin:15px 0;">
                        <asp:LinkButton ID="InsertButton" runat="server" OnClick="InsertButton_Click"
                            CssClass="btn btn-primary"><i class="fa fa-plus"></i> Crear Rol</asp:LinkButton>
                        <asp:LinkButton ID="CancelButton" runat="server" CausesValidation="False" OnClick="CancelButton_Click"
                            CssClass="btn btn-danger"><i class="fa fa-times"></i> Cancelar</asp:LinkButton>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <asp:HiddenField ID="PostBackPageHiddenField" runat="server" />
</asp:Content>


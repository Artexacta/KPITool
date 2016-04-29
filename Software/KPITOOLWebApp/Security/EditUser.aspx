<%@ Page Title="Editar Usuario" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="EditUser.aspx.cs" Inherits="Security_EditUser" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="Server">
    <div class="ibox float-e-margins">
        <div class="ibox-title">
            <h5>
                <asp:Label ID="EditLabel" runat="server" Text="Editar Usuario" CssClass="title"></asp:Label></h5>
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
                                <asp:Label ID="UsernameTitLabel" runat="server" AssociatedControlID="UsernameLabel" Text="Nombre de Usuario:"></asp:Label>
                                <asp:TextBox ID="UsernameLabel" runat="server" Font-Bold="True"
                                    CssClass="form-control"></asp:TextBox>
                            </div>
                            <div class="form-group">
                                <asp:Label ID="NameLabel0" runat="server" Text="Nombre Completo:" AssociatedControlID="NameTextBox"></asp:Label>
                                <asp:TextBox ID="NameTextBox" runat="server" CssClass="form-control"></asp:TextBox>
                                <div class="validation">
                                    <asp:RegularExpressionValidator ID="NameLenRegularExpressionValidator" runat="server"
                                        Display="Dynamic" ControlToValidate="NameTextBox" ErrorMessage="El nombre completo no puede exceder 250 caracteres."
                                        ValidationExpression="[\w\W]{0,250}">*</asp:RegularExpressionValidator>
                                    <asp:RegularExpressionValidator ID="NameFormRegularExpressionValidator" runat="server"
                                        Display="Dynamic" ControlToValidate="NameTextBox" ErrorMessage="Caracteres inválidos en el nombre completo."
                                        ValidationExpression="^[A-Za-z0-9áéíóúñÁÉÍÓÚñÑàèìòùÀÈÌÒÙâêîôûÂÊÎÔÛäëïöüÿÄËÏÖÜÇçÆæ_\s€¥®©£¡!@$%&amp;\^\*\(\)\+=\|&quot;:;&lt;&gt;\¿\?\.,\-\/]+$">*</asp:RegularExpressionValidator>
                                    <asp:RequiredFieldValidator ID="NameRequiredFieldValidator" runat="server" ControlToValidate="NameTextBox"
                                        Display="Dynamic" ErrorMessage="El nombre completo es requerido.">*</asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="form-group">
                                <asp:Label ID="EmailLabel" runat="server" Text="Correo Electrónico:" AssociatedControlID="EmailTextBox"></asp:Label>
                                <asp:TextBox ID="EmailTextBox" runat="server" CssClass="form-control"></asp:TextBox>
                                <div class="validation">
                                    <asp:RequiredFieldValidator ID="EmailRequiredFieldValidator" runat="server" ControlToValidate="EmailTextBox"
                                        Display="Dynamic" ErrorMessage="El correo electrónico es requerido.">*</asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator ID="EmailRegularExpressionValidator" runat="server"
                                        ControlToValidate="EmailTextBox" ErrorMessage="Correo electrónico inválido."
                                        Display="Dynamic" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*">*</asp:RegularExpressionValidator>
                                </div>
                            </div>
                            <div class="form-group">
                                <asp:Label ID="AddressLabel" runat="server" Text="Dirección:" AssociatedControlID="AddressTextBox"></asp:Label>
                                <asp:TextBox ID="AddressTextBox" runat="server" CssClass="form-control" MaxLength="250"></asp:TextBox>
                                <div class="validation">
                                    <asp:RegularExpressionValidator ID="DireccionFormatRegularExpressionValidator" runat="server"
                                        Display="Dynamic" ErrorMessage="Caracteres inválidos en la dirección." Text="*"
                                        ControlToValidate="AddressTextBox" ValidationExpression="<%$ Resources: Validations, DescriptionFormat %>"></asp:RegularExpressionValidator>
                                </div>
                            </div>
                            <div class="form-group">
                                <asp:Label ID="CellLabel" runat="server" Text="Teléfono Movil:" AssociatedControlID="CellPhoneTextBox"></asp:Label>
                                <asp:TextBox ID="CellPhoneTextBox" runat="server" CssClass="form-control" MaxLength="50"></asp:TextBox>
                                <div class="validation">
                                    <asp:RegularExpressionValidator ID="PhoneFormatRegularExpressionValidator" runat="server"
                                        ControlToValidate="CellPhoneTextBox" ErrorMessage="Caracteres inválidos en el telefóno móvil."
                                        Display="Dynamic" ValidationExpression="<%$ Resources: Validations, PhoneNumberFormat %>">*</asp:RegularExpressionValidator>
                                </div>
                            </div>
                            <div class="form-group">
                                <asp:Label ID="PhoneLabel" runat="server" Text="Teléfono:" AssociatedControlID="PaisAreaTextBox"></asp:Label>
                                <div class="row">
                                    <div class="col-md-3 col-sm-3 col-xs-3">
                                        <asp:TextBox ID="PaisAreaTextBox" runat="server" CssClass="form-control min-letter" MaxLength="5" placeholder="Cod.País"></asp:TextBox>
                                    </div>
                                    <div class="col-md-3 col-sm-3 col-xs-3">
                                        <asp:TextBox ID="CiudadAreaTextBox" runat="server" CssClass="form-control min-letter" MaxLength="5" placeholder="Cod.Área"></asp:TextBox>
                                        <asp:RegularExpressionValidator ID="AreaFormatRegularExpressionValidator" runat="server"
                                            Display="Dynamic" ControlToValidate="CiudadAreaTextBox" ErrorMessage="Caracteres inválidos en el código de área."
                                            ValidationExpression="<%$ Resources: Validations, PhoneNumberFormat %>">*</asp:RegularExpressionValidator>
                                    </div>
                                    <div class="col-md-6 col-sm-6 col-xs-6">
                                        <asp:TextBox ID="NumeroTextBox" runat="server" CssClass="form-control min-letter" MaxLength="12" placeholder="Número"></asp:TextBox>
                                        <asp:RegularExpressionValidator ID="NumeroFormatRegularExpressionValidator" runat="server"
                                            Display="Dynamic" ControlToValidate="NumeroTextBox" ErrorMessage="Caracteres inválidos en el número de teléfono."
                                            ValidationExpression="<%$ Resources: Validations, PhoneNumberFormat %>">*</asp:RegularExpressionValidator>
                                    </div>
                                </div>
                                <div class="validation">
                                    <asp:RegularExpressionValidator ID="PaisFormatRegularExpressionValidator" runat="server"
                                        Display="Dynamic" ControlToValidate="PaisAreaTextBox" ErrorMessage="Caracteres inválidos en el código de país."
                                        ValidationExpression="<%$ Resources: Validations, PhoneNumberFormat %>">*</asp:RegularExpressionValidator>
                                </div>
                                <div class="validation">
                                    <asp:ValidationSummary ID="ValidationSummary" runat="server" HeaderText="Corrija los siguientes errores para continuar:" />
                                </div>
                            </div>
                            <div class="text-center" style="margin: 15px 0;">
                                <asp:LinkButton ID="SaveButton" runat="server" OnClick="SaveButton_Click" CssClass="btn btn-primary">
                                    <i class="fa fa-plus"></i> Guardar
                                </asp:LinkButton>
                                <asp:LinkButton ID="CancelButton" runat="server" CausesValidation="False" Text="Cancelar"
                                    CssClass="btn btn-danger" OnClick="CancelButton_Click">
                                    <i class="fa fa-times"></i> Cancelar	
                                </asp:LinkButton>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <asp:HiddenField ID="UsernameHiddenField" runat="server" />
    <asp:HiddenField ID="UserIdHiddenField" runat="server" />
    <asp:HiddenField ID="EmailHiddenField" runat="server" />
    <asp:HiddenField ID="MyAccountHiddenField" runat="server" Value="false" />

</asp:Content>


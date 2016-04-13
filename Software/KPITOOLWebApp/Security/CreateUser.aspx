<%@ Page Title="Crear Usuario" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="CreateUser.aspx.cs" Inherits="Security_CreateUser" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="Server">
    <div class="ibox float-e-margins">
        <div class="ibox-title">
            <h5>
                <asp:Label ID="TitleLabel" runat="server" Text="Crear Usuario" CssClass="title"></asp:Label></h5>
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
                            <asp:CreateUserWizard ID="CreateUserWizard1" runat="server" OnCreatedUser="CreateUserWizard1_CreatedUser"
                                OnCreatingUser="CreateUserWizard1_CreatingUser" CreateUserButtonText="Crear Usuario"
                                CreateUserButtonStyle-CssClass="button" CancelButtonStyle-CssClass="button" CancelButtonText="Cancelar"
                                DisplayCancelButton="True" OnSendingMail="CreateUserWizard1_SendingMail" OnCancelButtonClick="CreateUserWizard1_CancelUser"
                                CancelDestinationPageUrl="~/Security/UserList.aspx">
                                <CreateUserButtonStyle CssClass="button"></CreateUserButtonStyle>
                                <MailDefinition BodyFileName="<%$ Resources: Files, CreateUserEmail %>">
                                </MailDefinition>
                                <WizardSteps>
                                    <asp:CreateUserWizardStep ID="CreateUserWizardStep1" runat="server">
                                        <ContentTemplate>
                                            <div class="form-group">
                                                <asp:Label ID="UserNameLabel" runat="server" AssociatedControlID="UserName"
                                                    Text="Nombre de Usuario"></asp:Label>
                                                <asp:TextBox ID="UserName" runat="server" CssClass="form-control"></asp:TextBox>
                                                <div class="validation">
                                                    <asp:RequiredFieldValidator ID="UserNameRequired" runat="server" ControlToValidate="UserName"
                                                        Display="Dynamic" ErrorMessage="El nombre de usuario es requerido." ToolTip="El nombre de usuario es requerido"
                                                        ValidationGroup="CreateUserWizard1" Text="*"></asp:RequiredFieldValidator>
                                                    <asp:RegularExpressionValidator ID="UserNameRegularExpressionValidator" runat="server"
                                                        Display="Dynamic" ControlToValidate="UserName" ErrorMessage="Caracteres inválidos en el nombre de usuario."
                                                        ValidationExpression="^[A-Za-z0-9_.]+$" ValidationGroup="CreateUserWizard1" Text="*"></asp:RegularExpressionValidator>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <asp:Label ID="PasswordLabel" runat="server" AssociatedControlID="Password" Text="Contraseña">
                                                </asp:Label>
                                                <asp:TextBox ID="Password" runat="server" TextMode="Password" CssClass="form-control"></asp:TextBox>
                                                <div class="validation">
                                                    <asp:RequiredFieldValidator ID="PasswordRequired" runat="server" ControlToValidate="Password"
                                                        Display="Dynamic" ErrorMessage="La contraseña es requerida." ToolTip="La contraseña es requerida."
                                                        ValidationGroup="CreateUserWizard1" Text="*">
                                                    </asp:RequiredFieldValidator>
                                                    <asp:RegularExpressionValidator ID="PasswordRegularExpressionValidator" ControlToValidate="Password"
                                                        Display="Dynamic" ErrorMessage="Error en la constraseña. Debe contener por lo menos 7 caracteres, entre números, letras alfanumericas y no alfanumericos."
                                                        ValidationExpression="<%$ Resources: Validations, PasswordFormat %>" ValidationGroup="CreateUserWizard1"
                                                        runat="server" Text="*"></asp:RegularExpressionValidator>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <asp:Label ID="ConfirmPasswordLabel" runat="server" AssociatedControlID="ConfirmPassword" Text="Confirmación de Contraseña"></asp:Label>
                                                <asp:TextBox ID="ConfirmPassword" runat="server" TextMode="Password" CssClass="form-control"></asp:TextBox>
                                                <div class="validation">
                                                    <asp:RequiredFieldValidator ID="ConfirmPasswordRequired" runat="server" ControlToValidate="ConfirmPassword"
                                                        Display="Dynamic" ErrorMessage="La confirmación de contraseña es requerida."
                                                        ToolTip="La confirmación de contraseña es requerida." ValidationGroup="CreateUserWizard1"
                                                        Text="*"></asp:RequiredFieldValidator>
                                                    <asp:CompareValidator ID="PasswordCompare" runat="server" ControlToCompare="Password"
                                                        ControlToValidate="ConfirmPassword" Display="Dynamic" ErrorMessage="La contraseña y confirmación de contraseña deben ser iguales."
                                                        ValidationGroup="CreateUserWizard1" Text="*"></asp:CompareValidator>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <asp:Label ID="NameLabel" runat="server" AssociatedControlID="FullNameTextBox" Text="Nombre Completo:"></asp:Label>
                                                <asp:TextBox ID="FullNameTextBox" runat="server" CssClass="form-control"></asp:TextBox>
                                                <div>
                                                    <asp:RequiredFieldValidator ID="FullNameRequired" runat="server" ControlToValidate="FullNameTextBox"
                                                        Display="Dynamic" ErrorMessage="El nombre completo es requerido." ToolTip="El nombre completo es requerido."
                                                        ValidationGroup="CreateUserWizard1" Text="*"></asp:RequiredFieldValidator>
                                                    <asp:RegularExpressionValidator ID="FormatNombreRegularExpressionValidator" runat="server"
                                                        Display="Dynamic" ErrorMessage="Caracteres inválidos en el nombre completo."
                                                        Text="*" ControlToValidate="FullNameTextBox" ValidationExpression="<%$ Resources: Validations, DescriptionFormat %>"
                                                        ValidationGroup="CreateUserWizard1"></asp:RegularExpressionValidator>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <asp:Label ID="EmailLabel" runat="server" AssociatedControlID="Email" Text="Correo Electrónico:"></asp:Label>
                                                <asp:TextBox ID="Email" runat="server" CssClass="form-control"></asp:TextBox>
                                                <div class="validation">
                                                    <asp:RequiredFieldValidator ID="EmailRequired" runat="server" ControlToValidate="Email"
                                                        Display="Dynamic" ErrorMessage="El correo electrónico es requerido." ToolTip="El correo electrónico es requerido."
                                                        ValidationGroup="CreateUserWizard1" Text="*"></asp:RequiredFieldValidator>
                                                    <asp:RegularExpressionValidator ID="FormatEmailRegularExpressionValidator" runat="server"
                                                        Display="Dynamic" ControlToValidate="Email" ErrorMessage="Formato incorrecto del correo electrónico."
                                                        ToolTip="Formato incorrecto del correo electrónico." ValidationGroup="CreateUserWizard1"
                                                        Text="*" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
                                                    <asp:CustomValidator ID="ExistsEmailCustomValidator" runat="server" ErrorMessage="El correo electrónico se encuentra registrado."
                                                        Display="Dynamic" Text="*" ToolTip="El correo electrónico se encuentra registrado."
                                                        ValidationGroup="CreateUserWizard1" OnServerValidate="ExistsEmailCustomValidator_ServerValidate"></asp:CustomValidator>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <asp:Label ID="AddressLabel" runat="server" Text="Dirección:" AssociatedControlID="AddressTextBox"></asp:Label>
                                                <asp:TextBox ID="AddressTextBox" runat="server" CssClass="form-control"></asp:TextBox>
                                                <div class="validation">
                                                    <asp:RegularExpressionValidator ID="DireccionFormatRegularExpressionValidator" runat="server"
                                                        Display="Dynamic" ErrorMessage="Caracteres inválidos en la dirección." Text="*"
                                                        ControlToValidate="AddressTextBox" ValidationExpression="<%$ Resources: Validations, DescriptionFormat %>"
                                                        ValidationGroup="CreateUserWizard1"></asp:RegularExpressionValidator>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <asp:Label ID="CellPhoneLabel" runat="server" Text="Teléfono Móvil:" AssociatedControlID="CellPhoneTextBox"></asp:Label>
                                                <asp:TextBox ID="CellPhoneTextBox" runat="server" CssClass="form-control"></asp:TextBox>
                                                <div class="validation">
                                                    <asp:RegularExpressionValidator ID="PhoneFormatRegularExpressionValidator" runat="server"
                                                        Display="Dynamic" ControlToValidate="CellPhoneTextBox" ErrorMessage="Caracteres inválidos en el telefóno móvil."
                                                        ValidationExpression="<%$ Resources: Validations, PhoneNumberFormat %>" ValidationGroup="CreateUserWizard1">*</asp:RegularExpressionValidator>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <asp:Label ID="PhoneLabel" runat="server" AssociatedControlID="NumeroTextBox" Text="Teléfono:"></asp:Label>
                                                <div class="row">
                                                    <div class="col-md-3 col-sm-3 col-xs-3">
                                                        <asp:TextBox ID="PaisAreaTextBox" runat="server" CssClass="form-control min-letter" MaxLength="5" placeholder="Cod.País"></asp:TextBox>
                                                        <asp:RegularExpressionValidator ID="PaisFormatRegularExpressionValidator" runat="server"
                                                            ControlToValidate="PaisAreaTextBox" ErrorMessage="Caracteres inválidos en el código de país."
                                                            ValidationExpression="<%$ Resources: Validations, PhoneNumberFormat %>" ValidationGroup="CreateUserWizard1">*</asp:RegularExpressionValidator>
                                                    </div>
                                                    <div class="col-md-3 col-sm-3 col-xs-3">
                                                        <asp:TextBox ID="CiudadAreaTextBox" runat="server" CssClass="form-control min-letter" MaxLength="5" placeholder="Cod.Área"></asp:TextBox>
                                                        <asp:RegularExpressionValidator ID="AreaFormatRegularExpressionValidator" runat="server"
                                                            ControlToValidate="CiudadAreaTextBox" ErrorMessage="Caracteres inválidos en el código de área."
                                                            ValidationExpression="<%$ Resources: Validations, PhoneNumberFormat %>" ValidationGroup="CreateUserWizard1">*</asp:RegularExpressionValidator>
                                                    </div>
                                                    <div class="col-md-6 col-sm-6 col-xs-6">
                                                        <asp:TextBox ID="NumeroTextBox" runat="server" CssClass="form-control min-letter" MaxLength="12" placeholder="Número"></asp:TextBox>
                                                        <asp:RegularExpressionValidator ID="NumeroFormatRegularExpressionValidator" runat="server"
                                                            ControlToValidate="NumeroTextBox" ErrorMessage="Caracteres inválidos en el número de teléfono."
                                                            ValidationExpression="<%$ Resources: Validations, PhoneNumberFormat %>" ValidationGroup="CreateUserWizard1">*</asp:RegularExpressionValidator>
                                                    </div>
                                                </div>
                                            </div>
                                            <div>
                                                <div class="validation">
                                                    <asp:ValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="CreateUserWizard1"
                                                        HeaderText="Corrija los siguientes errores para continuar:" Width="600px" />
                                                </div>
                                                <asp:Label ID="MessageLabel" runat="server" CssClass="label"></asp:Label>
                                            </div>

                                        </ContentTemplate>
                                        <CustomNavigationTemplate>
                                            <div class="text-center" style="margin-top: 15px;">
                                                <asp:LinkButton ID="StepNextButton" runat="server" CommandName="MoveNext" CssClass="btn btn-primary"
                                                    ValidationGroup="CreateUserWizard1">
										<i class="fa fa-plus"></i> Crear Usuario
                                                </asp:LinkButton>
                                                <asp:LinkButton ID="CancelButton" runat="server" CausesValidation="False" CommandName="Cancel"
                                                    CssClass="btn btn-danger" ValidationGroup="CreateUserWizard1">
										<i class="fa fa-times"></i> Cancelar	
                                                </asp:LinkButton>
                                            </div>
                                        </CustomNavigationTemplate>
                                    </asp:CreateUserWizardStep>
                                    <asp:CompleteWizardStep ID="CompleteWizardStep1" runat="server">
                                        <ContentTemplate>
                                            <asp:Label ID="MensajeCrearLabel" runat="server" Text="El usuario fue creado satisfactoriamente. Para volver al listado de usuario presione el siguiente enlace:"></asp:Label>
                                            <asp:HyperLink ID="ListaHyperLink" runat="server" NavigateUrl="~/Security/UserList.aspx"
                                                CssClass="linkButton">Lista de Usuarios</asp:HyperLink>
                                        </ContentTemplate>
                                    </asp:CompleteWizardStep>
                                </WizardSteps>
                                <CancelButtonStyle CssClass="btn btn-danger"></CancelButtonStyle>
                                <StartNavigationTemplate>
                                    <asp:Button ID="StartNextButton" runat="server" CommandName="MoveNext" Text="Next" CssClass="btn btn-primary" />
                                </StartNavigationTemplate>
                            </asp:CreateUserWizard>
                            <asp:HiddenField ID="FullNameHiddenField" runat="server" />
                        </div>
                    </div>
                </div>
                <script type="text/javascript">
                    $(document).ready(function () {
                        $('table').replaceWith($('table').html()
                           .replace(/<tbody/gi, "<div id='table'")
                           .replace(/<tr/gi, "<div")
                           .replace(/<\/tr>/gi, "</div>")
                           .replace(/<td/gi, "<span")
                           .replace(/<\/td>/gi, "</span>")
                           .replace(/<\/tbody/gi, "<\/div")
                        );
                    });
                </script>
            </div>
        </div>
    </div>
</asp:Content>


<%@ Page Title="Registro de Personas" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="RegistroPersonas.aspx.cs" Inherits="Personas_RegistroPersonas" %>

<%@ Register Src="~/UserControls/Personas/Departamentos.ascx" TagPrefix="control" TagName="PersonaDepartamento" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="Server">
    <div class="ibox float-e-margins">
        <div class="ibox-title">
            <h5>
                <asp:Label ID="TitleLabel" runat="server" Text="Registro nueva Persona" CssClass="title"></asp:Label></h5>
            <div class="ibox-tools">
                <a class="collapse-link">
                    <i class="fa fa-chevron-up"></i>
                </a>
            </div>
        </div>
        <div class="ibox-content">
            <div class="row">
                <div class="col-md-12">
                    <asp:HyperLink ID="ReturnLinkButton" runat="server" CssClass="btn btn-warning min-letter" Text="<i class='fa fa-arrow-left'></i> Ir a la lista de Personas"
                        NavigateUrl="~/Personas/ListaPersonas.aspx" />
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <asp:Label ID="NombreLabel" runat="server" AssociatedControlID="NombreTextBox" Text="Nombre"></asp:Label>
                        <asp:TextBox ID="NombreTextBox" runat="server" CssClass="form-control" MaxLength="250" />
                        <div class="validators">
                            <asp:RequiredFieldValidator ID="NombreRequiredFieldValidator" runat="server" ControlToValidate="NombreTextBox"
                                ValidationGroup="RegistroPersona" ErrorMessage="El nombre es requerido." Display="Dynamic" />
                            <asp:RegularExpressionValidator ID="NombreRegularExpressionValidator" runat="server"
                                ControlToValidate="NombreTextBox" ValidationGroup="RegistroPersona" ErrorMessage="Caracteres inválidos en el nombre."
                                ValidationExpression="<%$ Resources:Validations, NameFormat %>" Display="Dynamic" />
                            <asp:RegularExpressionValidator ID="NombreLengRegularExpressionValidator" runat="server"
                                ControlToValidate="NombreTextBox" ValidationGroup="RegistroPersona" ErrorMessage="El nombre no puede exceder 250 caracteres."
                                ValidationExpression="<%$ Resources:Validations, GenericLength250 %>" Display="Dynamic" />
                        </div>
                    </div>
                    <div class="form-group">
                        <asp:Label ID="EmailLabel" runat="server" AssociatedControlID="EmailTextBox" Text="Correo electrónico" />
                        <asp:TextBox ID="EmailTextBox" runat="server" CssClass="form-control" />
                        <div class="validators">
                            <asp:RequiredFieldValidator ID="EmailRequiredFieldValidator" runat="server" ControlToValidate="EmailTextBox"
                                ValidationGroup="RegistroPersona" ErrorMessage="El correo electrónico es requerido." Display="Dynamic" />
                            <asp:RegularExpressionValidator ID="EmailFormatRegularExpressionValidator" runat="server" ControlToValidate="EmailTextbox"
                                ValidationGroup="RegistroPersona" ErrorMessage="El Correo Electrónico tiene formato incorrecto"
                                ValidationExpression="<%$ Resources:Validations, EmailFormat %>" Display="Dynamic" />
                            <asp:RegularExpressionValidator ID="EmailLengthRegularExpressionValidator" runat="server" ControlToValidate="EmailTextbox"
                                ValidationGroup="RegistroPersona" ErrorMessage="El correo electrónico no puede exceder 150 caracteres."
                                ValidationExpression="<%$ Resources:Validations, GenericLength150 %>" Display="Dynamic" />
                            <asp:CustomValidator ID="ExisteEmailCustomValidator" runat="server" ControlToValidate="EmailTextBox"
                                Display="Dynamic" ValidationGroup="RegistroPersona" ErrorMessage="El correo electrónico se encuentra registrado."
                                ClientValidationFunction="ExisteEmailCustomValidator_Validate" />
                        </div>
                    </div>
                    <div class="form-group">
                        <asp:Label ID="FechaNaciminentoLabel" AssociatedControlID="FechaRadDatePicker" runat="server" Text="Fecha de Nacimiento" />
                        <telerik:RadDatePicker ID="FechaRadDatePicker" runat="server" ZIndex="8200"
                            DateInput-DateFormat="dd/MM/yyyy" DateInput-DisplayDateFormat="dd/MM/yyyy" Skin="aetemplate" EnableEmbeddedSkins="false">
                        </telerik:RadDatePicker>
                        <div class="validators">
                            <asp:RequiredFieldValidator ID="FechaRequiredFieldValidator" runat="server" Display="Dynamic"
                                ControlToValidate="FechaRadDatePicker" ValidationGroup="RegistroPersona"
                                ErrorMessage="La fecha de nacimiento es requerida. Ej. 01/01/2013." />
                        </div>
                    </div>
                    <div class="form-group">
                        <asp:Label ID="PaisLabel" runat="server" Text="País" AssociatedControlID="PaisRadComboBox" />
                        <telerik:RadComboBox ID="PaisRadComboBox" runat="server" ZIndex="8101"
                            Filter="Contains" EnableLoadOnDemand="true" ShowMoreResultsBox="true"
                            EnableVirtualScrolling="true" EmptyMessage="- seleccione un país -" Skin="aetemplate" EnableEmbeddedSkins="false">
                            <WebServiceSettings Method="GetCountry" Path="../AutoCompleteWS/ComboBoxWebServices.asmx" />
                        </telerik:RadComboBox>
                        <div class="validators">
                            <asp:RequiredFieldValidator ID="PaisRequiredFieldValidator" runat="server" ErrorMessage="El país es requerido."
                                ControlToValidate="PaisRadComboBox" ValidationGroup="RegistroPersona" Display="Dynamic" />
                        </div>
                    </div>
                    <div class="form-group">
                        <asp:Label ID="EstadoCivilLabel" runat="server" Text="Estado Civil" AssociatedControlID="EstadoCivilComboBox" />
                        <telerik:RadComboBox ID="EstadoCivilComboBox" runat="server" EmptyMessage="- seleccione un estado -" Skin="aetemplate" EnableEmbeddedSkins="false">
                            <Items>
                                <telerik:RadComboBoxItem Text="Soltero" Value="Soltero" />
                                <telerik:RadComboBoxItem Text="Casado" Value="Casado" />
                                <telerik:RadComboBoxItem Text="Divorciado" Value="Divorciado" />
                                <telerik:RadComboBoxItem Text="Viudo" Value="Viudo" />
                            </Items>
                        </telerik:RadComboBox>
                        <div class="validators">
                            <asp:RequiredFieldValidator ID="EstadoCivilRequiredFieldValidator" runat="server" Display="Dynamic"
                                ControlToValidate="EstadoCivilComboBox" ValidationGroup="RegistroPersona" ErrorMessage="El estado civil es requerido." />
                        </div>
                    </div>
                    <div class="form-group">
                        <asp:Label ID="GeneroLabel" runat="server" Text="Género" AssociatedControlID="GeneroRadioButtonList" />
                        <asp:RadioButtonList ID="GeneroRadioButtonList" runat="server" RepeatDirection="Horizontal" CellSpacing="5">
                            <asp:ListItem Text="Masculino" Value="Masculino" />
                            <asp:ListItem Text="Femenino" Value="Femenino" />
                        </asp:RadioButtonList>
                        <div class="validators">
                            <asp:RequiredFieldValidator ID="GeneroRadioButtonCustomValidator" runat="server" Display="Dynamic"
                                ControlToValidate="GeneroRadioButtonList" ValidationGroup="RegistroPersona" ErrorMessage="El género es requerido." />
                        </div>
                    </div>
                    <div class="form-group">
                        <asp:Label ID="SalarioLabel" runat="server" Text="Salario" AssociatedControlID="SalarioTextBox" />
                        <telerik:RadNumericTextBox ID="SalarioTextBox" runat="server" Value="0" EmptyMessage="0"
                            MinValue="0" NumberFormat-DecimalDigits="2" MaxValue="9999999.99" Skin="aetemplate" EnableEmbeddedSkins="false" />
                        <div class="validators">
                            <asp:CustomValidator ID="SalarioCustomValidator" runat="server" Display="Dynamic" ErrorMessage="El salario es requerido."
                                ValidationGroup="RegistroPersona" ClientValidationFunction="SalarioCustomValidator_Validate" />
                        </div>
                    </div>
                    <div class="text-center" style="margin: 15px 0;">
                        <asp:LinkButton ID="SaveLinkButton" runat="server" CssClass="btn btn-primary" ValidationGroup="RegistroPersona"
                            OnClick="SaveLinkButton_Click">
                            <asp:Label ID="SaveLinkButtonLabel" runat="server" />
                            <i class="fa fa-floppy-o"></i>Guardar
                        </asp:LinkButton>
                        <asp:LinkButton ID="CancelLinkButton" runat="server" CausesValidation="false" CssClass="btn btn-danger"
                            OnClick="CancelLinkButton_Click">
                            <i class="fa fa-times"></i> Cancelar
                        </asp:LinkButton>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <control:PersonaDepartamento ID="PersonaDepartamentoControl" runat="server" Visible="false" />

    <script type="text/javascript">
        $(document).ready(function () {
            $(':radio').iCheck({
                checkboxClass: 'icheckbox_square-green',
                radioClass: 'iradio_square-green',
            });
            $('.iradio_square-green').css("margin", "0 10px");
            $(".rcCalPopup").html('<i class="fa fa-calendar"></i>');
        });
        function SalarioCustomValidator_Validate(sender, args) {
            args.IsValid = true;

            var salarioTexto = $find('<%= SalarioTextBox.ClientID %>').get_value();
            if (salarioTexto <= 0) {
                args.IsValid = false;
            }
        }

        function ExisteEmailCustomValidator_Validate(sender, args) {
            var message;
            var emailTexto = $('#<%=EmailTextBox.ClientID%>').val();
            var id = $('#<%=PersonaIdHiddenField.ClientID%>').val();
            if (id == '') id = 0;

            var param = JSON.stringify({ 'email': emailTexto, 'personaId': id });

            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "RegistroPersonas.aspx/verificarExisteEmail",
                data: param,
                dataType: "json",
                async: false,
                success: function (msg) {
                    message = msg.d;
                }
            });

            if (message) {
                args.IsValid = true;
            } else {
                args.IsValid = false;
            }
        }
    </script>

    <asp:HiddenField ID="PersonaIdHiddenField" runat="server" />

</asp:Content>


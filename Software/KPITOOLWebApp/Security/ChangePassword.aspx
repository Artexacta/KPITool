<%@ Page Title="Cambiar Contraseña" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="ChangePassword.aspx.cs" Inherits="Security_ChangePassword" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="Server">
    <div class="tile icons-demo">
        <div class="t-header">
            <div class="th-title">
                <asp:Label ID="ChangePassword" runat="server" Text="Cambiar Contraseña" CssClass="title"></asp:Label>
            </div>
        </div>

        <div class="t-body tb-padding">
            <div class="row">
                <div class="col-md-12">
                    <div class="row">
                        <div class="col-md-6">
                            <asp:ChangePassword ID="ChangePassword1" runat="server" ContinueDestinationPageUrl="~/MainPage.aspx"
                                OnCancelButtonClick="ChangePassword1_CancelButtonClick"
                                ChangePasswordFailureText="Contraseña incorrecta o nueva contraseña inválida. El largo de la nueva contraseña debe ser de 7 caracteres como mínimo. Los caracteres deben ser alfanuméricos.">
                                <CancelButtonStyle />
                                <InstructionTextStyle />
                                <PasswordHintStyle />
                                <ChangePasswordButtonStyle />
                                <ContinueButtonStyle />
                                <TitleTextStyle />
                                <ChangePasswordTemplate>
                                    <div class="form-group">
                                        <asp:Label ID="CurrentPasswordLabel" runat="server" AssociatedControlID="CurrentPassword"
                                            Text="<label>Contraseña</label>"></asp:Label>
                                        <asp:TextBox ID="CurrentPassword" runat="server" TextMode="Password" CssClass="form-control"></asp:TextBox>
                                        <div class="validation">
                                            <asp:RequiredFieldValidator ID="CurrentRequiredFieldValidator" runat="server" ErrorMessage="La contraseña es requerida." Display="Dynamic"
                                                ToolTip="La contraseña es requerida." Text="*" ControlToValidate="CurrentPassword"></asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <asp:Label ID="NewPasswordLabel" runat="server" AssociatedControlID="NewPassword"
                                            Text="<label>Nueva Contraseña:</label>"></asp:Label>
                                        <asp:TextBox ID="NewPassword" runat="server" TextMode="Password" CssClass="form-control"></asp:TextBox>
                                        <div class="validation">
                                            <asp:RequiredFieldValidator ID="NewPasswordRequiredFieldValidator" runat="server" Display="Dynamic"
                                                ErrorMessage="La nueva contraseña es requerida." ControlToValidate="NewPassword"
                                                ToolTip="La nueva contraseña es requerida." Text="*"></asp:RequiredFieldValidator>
                                            <asp:RegularExpressionValidator ID="PasswordRegularExpressionValidator" ControlToValidate="NewPassword" Display="Dynamic"
                                                ErrorMessage="Error en la constraseña. Debe contener por lo menos 7 caracteres, entre números, letras alfanumericas y no alfanumericos."
                                                ValidationExpression="<%$ Resources: Validations, PasswordFormat %>" runat="server"
                                                Text="*"></asp:RegularExpressionValidator>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <asp:Label ID="ConfirmNewPasswordLabel" runat="server" Text="<label>Confirmar Contraseña:</label>"></asp:Label>

                                        <asp:TextBox ID="ConfirmNewPassword" runat="server" TextMode="Password" CssClass="form-control"></asp:TextBox>
                                        <div class="validation">
                                            <asp:RequiredFieldValidator ID="ConfirmNewPasswordRequired" runat="server" ControlToValidate="ConfirmNewPassword" Display="Dynamic"
                                                ErrorMessage="Confirmación de contraseña requerida." ToolTip="Confirmación de contraseña requerida.">*</asp:RequiredFieldValidator>
                                            <asp:CompareValidator ID="NewPasswordCompare" runat="server" ControlToCompare="NewPassword" Display="Dynamic"
                                                ControlToValidate="ConfirmNewPassword" ErrorMessage="La contraseña y confirmación de contraseña deben ser iguales."
                                                Text="*"></asp:CompareValidator>
                                        </div>
                                    </div>
                                    <div class="validation">
                                        <asp:Literal ID="FailureText" runat="server" EnableViewState="False"></asp:Literal>
                                        <asp:ValidationSummary ID="PCValidationSummary" runat="server" HeaderText="Corrija los siguientes errores para continuar:" Display="Dynamic" />
                                    </div>
                                    <div class="text-center" style="margin-top: 15px;">
                                        <asp:LinkButton ID="ChangePasswordPushButton" runat="server" CommandName="ChangePassword"
                                            CausesValidation="true" CssClass="btn btn-primary">
							    <i class="fa fa-floppy-o"></i> Cambiar Contraseña
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="CancelPushButton" runat="server" CausesValidation="False" CommandName="Cancel"
                                            CssClass="btn btn-danger">
							    <i class="fa fa-times"></i> Cancelar
                                        </asp:LinkButton>
                                    </div>
                                </ChangePasswordTemplate>
                                <SuccessTemplate>
                                    <table border="0" cellpadding="4" cellspacing="0" style="border-collapse: collapse;">
                                        <tr>
                                            <td>
                                                <asp:Label ID="Label" runat="server" Text="Su contraseña fue modificado existosamente."></asp:Label>
                                                <br />
                                                <br />
                                                <asp:LinkButton ID="ContinuePushButton" runat="server" CausesValidation="False" CommandName="Continue"
                                                    CssClass="button">
										<span>Continuar</span>
                                                </asp:LinkButton>
                                            </td>
                                        </tr>
                                    </table>
                                </SuccessTemplate>
                                <TextBoxStyle />
                            </asp:ChangePassword>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>


<%--
    <div class="ibox float-e-margins">
        <div class="ibox-title">
            <h5>
                <asp:Label ID="ChangePassword" runat="server" Text="Cambiar Contraseña" CssClass="title"></asp:Label></h5>
            <div class="ibox-tools">
                <a class="collapse-link">
                    <i class="fa fa-chevron-up"></i>
                </a>
            </div>
        </div>
        <div class="ibox-content">
            
        </div>
    </div>--%>
</asp:Content>


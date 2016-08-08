<%@ Page Title="<% $ Resources : LoginGlossary, RecoverPasswordTitle %>" Language="C#" MasterPageFile="~/EmptyMasterPage.master" 
    AutoEventWireup="true" CodeFile="RecoverPassword.aspx.cs" Inherits="Authentication_RecoverPassword" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cp" Runat="Server">
    <div class="pageContent">
        <div class="frame">
			<div class="columnHead">
                <asp:Label ID="ChangePassword" runat="server" Text="¿Olvidaste tu Contraseña?" CssClass="title"></asp:Label>
            </div>
            <div class="columnContent">
                <asp:PasswordRecovery ID="PasswordRecovery1" runat="server" 
				    OnSendingMail="PasswordRecovery1_SendingMail" OnSendMailError="PasswordRecovery1_SendMailError"
                    OnVerifyingUser="PasswordRecovery1_VerifyingUser">
                    <MailDefinition BodyFileName="<%$ Resources:Files, NewPasswordFileLocation %>" From="xxx@yyy.com"
                        IsBodyHtml="True" Subject="XXX">
                    </MailDefinition>
            	    <UserNameTemplate>
					    <h2 style=" float:left; margin-bottom:5px;">Ingrese su nombre de Usuario para obtener su contraseña.</h2>
						    <asp:Label ID="UserNameLabel" runat="server" AssociatedControlID="UserName" CssClass="label" Text="User Name:"></asp:Label>
						    <asp:TextBox ID="UserName" runat="server"></asp:TextBox>
						    <div class="validation">
							    <asp:RequiredFieldValidator ID="UserNameRequired" runat="server" Display="Dynamic"
								    ControlToValidate="UserName" ErrorMessage="Nombre de Usuario es requerido." 
								    ToolTip="User Name is required." ValidationGroup="PasswordRecovery1">*</asp:RequiredFieldValidator>
						    </div>
						    <div class="validation">
							    <asp:Literal ID="FailureText" runat="server" EnableViewState="False"></asp:Literal>
						    </div>
						    <div class="buttonsPnl">
							    <asp:LinkButton ID="SubmitButton" runat="server" CssClass="button"
								    ValidationGroup="PasswordRecovery1" CommandName="Submit">
								    <asp:label ID="Label1" text="Submit" runat="server" />		
							    </asp:LinkButton>
							     <asp:LinkButton ID="GotoMainLinkButton" CssClass="secondaryButton" runat="server" CausesValidation="False" PostBackUrl="~/Organization/ListOrganizations.aspx"
								    Text="Ir a la Página Principal"></asp:LinkButton>
						    </div>
				    </UserNameTemplate>
                </asp:PasswordRecovery>
                <div class="clear">
                </div>
            </div>
        </div>
    </div>
</asp:Content>


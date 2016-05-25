<%@ Page Title="<%$ Resources: LoginGlossary, LoginTitle %>" Language="C#" MasterPageFile="~/EmptyMasterPage.master"
    AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Authentication_Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="Server">
    <!-- Login -->
        <div class="lc-block toggled" id="l-login">
            <div class="lcb-float"><i class="zmdi zmdi-pin-account"></i></div>
            <div id="loginContainer">
                <div class="login-form" style="margin-bottom: 15px; margin-top: 15px;">
                    

                    <div id="loginLogoContainer">
                        <asp:Image ID="LogoImage" runat="server" ImageUrl="~/Images/logo.png" Width="150" />
                        <div class="login-form">
                            <app:LanguageSelector ID="LanguageSelector1" runat="server" />
                        </div>
                        <h3>
                            <asp:Literal ID="Literal1" Text="<%$ Resources: LoginGlossary, LoginTitle %>" runat="server" /></h3>
                        
                        
                    </div>
                    <div id="loginFormContainer">
                        <asp:Login ID="Login1" runat="server" OnLoggingIn="Login1_LoggingIn" OnLoggedIn="Login1_LoggedIn"
                            OnLoginError="Login1_LoginError" FailureText="Your login was not successful. Please try again." RenderOuterTable="false">
                            <LayoutTemplate>
                                <asp:Panel ID="pnlLoginControl" runat="server" DefaultButton="LoginButton">
                                    <div class="form-group">
                                        <asp:TextBox ID="UserName" runat="server" CssClass="form-control" placeholder="<%$ Resources: LoginGlossary, UserNameLabel %>" />
                                    </div>
                                    <asp:RequiredFieldValidator ID="UserNameRequired" runat="server" Display="Dynamic"
                                        ControlToValidate="UserName" ErrorMessage="<%$ Resources: LoginGlossary, UserNameRequiredErrorMessage %>"
                                        Text="<%$ Resources: LoginGlossary, UserNameRequiredErrorMessage %>" CssClass="validation"
                                        ToolTip="<%$ Resources: LoginGlossary, UserNameRequiredErrorMessage %>" ValidationGroup="Login1">
                                    </asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator runat="server" ID="UserNameLengthValidator" ControlToValidate="UserName"
                                        ValidationExpression="<% $ Resources:Validations, GenericLength50 %>" CssClass="validation"
                                        Display="Dynamic" ValidationGroup="Login1" ErrorMessage="<%$ Resources: LoginGlossary, UserNameLengthErrorMessage %>">
                                    </asp:RegularExpressionValidator>

                                    <div class="form-group">
                                        <asp:TextBox ID="Password" runat="server" TextMode="Password" CssClass="form-control" placeholder="<%$ Resources: LoginGlossary, PasswordLabel %>" />
                                    </div>
                                    <asp:RequiredFieldValidator ID="PasswordRequired" runat="server" Display="Dynamic"
                                        ControlToValidate="Password" Text="<%$ Resources: LoginGlossary, PasswordRequiredErrorMessage %>"
                                        CssClass="validation" ErrorMessage="<%$ Resources: LoginGlossary, PasswordRequiredErrorMessage %>"
                                        ToolTip="<%$ Resources: LoginGlossary, PasswordRequiredErrorMessage %>" ValidationGroup="Login1">
                                    </asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator runat="server" ID="PasswordLengthValidator" ControlToValidate="Password"
                                        ValidationExpression="<% $ Resources:Validations, GenericLength50 %>" CssClass="validation"
                                        Display="Dynamic" ValidationGroup="Login1" ErrorMessage="<%$ Resources: LoginGlossary, PasswordLengthErrorMessage %>">
                                    </asp:RegularExpressionValidator>
                                    <asp:Label ID="FailureText" runat="server" CssClass="error" EnableViewState="False" />

                                    <div class="buttonsPanel">
                                        <asp:LinkButton ID="LoginButton" runat="server" CssClass="btn btn-block btn-primary btn-float m-t-25" CommandName="Login" ValidationGroup="Login1">
                                            <asp:Label ID="lblLoginButton" runat="server" Text="<%$ Resources: LoginGlossary, LoginButton %>" />
                                        </asp:LinkButton>
                                        <!--<a id="loginHelp" href="#" style="/*display: block; padding-top: 0;*/" class="help middle-box"></a>-->
                                    </div>

                                </asp:Panel>
                            </LayoutTemplate>
                        </asp:Login>
                    </div>
                    <div class="clear">
                    </div>

                </div>

                <div id="loginOptionsContainer">
                    <p>
                        <small>
                            <asp:Literal ID="lblRecover" runat="server" Text="<%$Resources: LoginGlossary, CantRememberPasswordLabel %>" />
                    </p>
                    <p>
                        <small>
                            <asp:LinkButton ID="RecoverLinkButton" runat="server" Text="<% $ Resources : LoginGlossary, RecoverPasswordLink %>"
                                OnClick="RecoverLinkButton_Click" /></small>
                    </p>
                </div>

            </div>
        </div>

    <script type="text/javascript">
        // HACK: default button + linkbutton no funciona en firefox por que <a> no tiene evento click definido
        // definimos click para LoginButton
        var b = document.getElementById('<%= Login1.FindControl("LoginButton").ClientID %>');
        if (b && typeof (b.click) == 'undefined') {
            b.click = function () {
                var result = true;
                if (b.onclick)
                    result = b.onclick();
                if (typeof (result) == 'undefined' || result) {
                    eval(b.getAttribute('href'));
                }
            }
        }
    </script>

</asp:Content>


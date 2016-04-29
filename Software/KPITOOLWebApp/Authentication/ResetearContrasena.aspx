<%@ Page Title="<%$ Resources: LoginGlossary, TituloResetarContraseña %>" Language="C#" MasterPageFile="~/EmptyMasterPage.master"
    AutoEventWireup="true" CodeFile="ResetearContrasena.aspx.cs" Inherits="Authentication_ResetearContrasena" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
   <!-- <style type="text/css">
        #headerMnu
        {
            float: right;
            margin: 27px 10px 5px 10px;
        }
        #header
        {
            background: #EEE none repeat scroll 0 0;
            color: #333333;
            margin: 0;
            min-height: 52px;
            overflow: hidden;
        }
        .appPage
        {
            width: 1200px;
            margin: 0 auto;
            margin-top: 10px;
            -moz-border-radius: 5px;
            border-radius: 5px;
            -moz-box-shadow: 0px 0px 10px #AAA;
            -webkit-box-shadow: 0px 0px 10px #AAA;
            box-shadow: 0px 0px 10px #AAA;
        }
        #bodyIn
        {
            font-family: Verdana, Geneva, sans-serif;
            font-size: 12px;
            color: #000000;
            background-color: #EEE;
        }
        .pageTitle
        {
            display: block;
            font-weight: bold;
            margin-top: 5px;
            margin-right: 5px;
            font-size: large;
        }
    </style> -->
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" Runat="Server">


    <div class="lc-block toggled" id="l-login">
        <div class="lcb-float"><i class="zmdi zmdi-key"></i></div>
        <div id="loginContainer">
            <div style="margin-bottom: 15px; margin-top: 15px;">
                <div id="loginLogoContainer">
                    <asp:Image ID="LogoImage" runat="server" ImageUrl="~/Images/logo.png" Width="150" />
                    <h3>
                        <asp:Literal ID="Literal1" Text="<%$ Resources: LoginGlossary, TituloResetarContraseña %>" runat="server" />
                    </h3>
                    <br />  
                    <div class="form-group">
                            
                        <asp:TextBox ID="EmailTextBox" runat="server" CssClass="form-control"
                            placeholder="<%$ Resources: LoginGlossary, EmailHint %>"></asp:TextBox>
                        <asp:RegularExpressionValidator ID="FormatRegularExpressionValidator" runat="server"
                            Display="Dynamic"
                            ControlToValidate="EmailTextBox" ErrorMessage="<%$ Resources: LoginGlossary, MensajeEmailInvalido %>"
                            ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*">
                        </asp:RegularExpressionValidator>
                        <asp:RequiredFieldValidator ID="EmailRequiredFieldValidator" runat="server"
                            ControlToValidate="EmailTextBox"
                            Display="Dynamic"
                            ErrorMessage="<%$ Resources: LoginGlossary, MensajeEmailRequerido %>">
                        </asp:RequiredFieldValidator>
                        <asp:CustomValidator ID="CustomValidator1" runat="server"
                            Display="Dynamic"
                            ErrorMessage="<%$ Resources: LoginGlossary, MensajeEmailInexistente %>"
                            OnServerValidate="CustomValidator1_ServerValidate">
                        </asp:CustomValidator>
                    </div>

                    <asp:Label ID="ErrorLabel" runat="server" />

                    <asp:Button ID="ResetButton" runat="server" OnClick="ResetButton_Click"
                        Text="<%$ Resources: LoginGlossary, BotonResetear %>"
                        CssClass="btn btn-block btn-primary" />
                    <asp:HyperLink runat="server" CssClass="text-center block"
                        NavigateUrl="~/Authentication/Login.aspx"
                        Text="<%$ Resources: LoginGlossary, LoginLink %>"></asp:HyperLink>
                </div>
            </div>
        </div>
    </div>
        <%--<div id="header">
            <div id="logoContent" style="vertical-align: middle;">
                <asp:Image ID="imgHeaderLogo" runat="server" ImageUrl="~/Images/logo.png" AlternateText="logo"
                    Height="53" Style="float: left;" />
                <asp:Label ID="Label1" Style="float: left; font-family: Verdana, Geneva, sans-serif;
                    font-size: 21px; margin-left: 10px; margin-top: 15px; text-shadow: 1px 1px #fff;"
                    Text="<%$ Resources: Glossary, ProjectName %>" runat="server" />
            </div>
        </div>--%>
     
</asp:Content>


<%@ Page Title="<%$ Resources: LoginGlossary, TituloResetarContraseña %>" Language="C#" MasterPageFile="~/EmptyMasterPage.master" 
    AutoEventWireup="true" CodeFile="ResetearContrasena.aspx.cs" Inherits="Authentication_ResetearContrasena" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
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
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" Runat="Server">
    <div class="appPage">
        <div id="header">
            <div id="logoContent" style="vertical-align: middle;">
                <asp:Image ID="imgHeaderLogo" runat="server" ImageUrl="~/Images/logo.png" AlternateText="logo"
                    Height="53" Style="float: left;" />
                <asp:Label ID="Label1" Style="float: left; font-family: Verdana, Geneva, sans-serif;
                    font-size: 21px; margin-left: 10px; margin-top: 15px; text-shadow: 1px 1px #fff;"
                    Text="<%$ Resources: Glossary, ProjectName %>" runat="server" />
            </div>
        </div>
        <div id="bodyIn">
            <span class="pageTitle">
                <asp:Literal ID="MessageLiteral" runat="server" Text="<% $  Resources : LoginGlossary, TituloResetarContraseña %>">
                </asp:Literal>
            </span>

            <asp:Panel ID="Panel1" runat="server">
                <table style="width: 600px">
                    <tr>
                        <td colspan="2" style="padding-top: 5px; padding-bottom: 10px">
                            <asp:Label ID="MensajeLabel" runat="server" Text="<%$ Resources: LoginGlossary, MensajeIngreseMail %>"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label ID="EmailLabel" runat="server" Text="<%$ Resources: LoginGlossary, TituloEmail %>"></asp:Label>
                        </td>
                        <td>
                            <asp:TextBox ID="EmailTextBox" runat="server" Height="22px" Width="270px"></asp:TextBox>
                            <asp:RegularExpressionValidator ID="FormatRegularExpressionValidator" runat="server"
                                ControlToValidate="EmailTextBox" ErrorMessage="<%$ Resources: LoginGlossary, MensajeEmailInvalido %>"
                                ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*">*</asp:RegularExpressionValidator>
                            <asp:RequiredFieldValidator ID="EmailRequiredFieldValidator" runat="server" ControlToValidate="EmailTextBox"
                                ErrorMessage="<%$ Resources: LoginGlossary, MensajeEmailRequerido %>">*</asp:RequiredFieldValidator>
                            <asp:CustomValidator ID="CustomValidator1" runat="server" ErrorMessage="<%$ Resources: LoginGlossary, MensajeEmailInexistente %>"
                                OnServerValidate="CustomValidator1_ServerValidate">*</asp:CustomValidator>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <asp:ValidationSummary ID="ValidationSummary1" runat="server" HeaderText="<%$ Resources: LoginGlossary, MensajeErrores %>" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="padding-top: 10px">
                            <asp:Button ID="ResetButton" runat="server" OnClick="ResetButton_Click" Text="<%$ Resources: LoginGlossary, BotonResetear %>"
                                CssClass="button" />
                        </td>
                    </tr>
                </table>
            </asp:Panel>

            <br />
            <asp:Label ID="ErrorLabel" runat="server" />
            <br />
        </div>
    </div>
</asp:Content>


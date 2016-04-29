<%@ Page Title="<%$ Resources: LoginGlossary, TituloResetarContraseña %>" Language="C#" MasterPageFile="~/EmptyMasterPage.master" 
    AutoEventWireup="true" CodeFile="ConfirmarReseteo.aspx.cs" Inherits="Authentication_ConfirmarReseteo" %>

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
    <div class="lc-block toggled" id="l-login">
        <div class="lcb-float"><i class="zmdi zmdi-notifications"></i></div>
        <div id="loginContainer">
            <div style="margin-bottom: 15px; margin-top: 15px;">
                <div id="loginLogoContainer">
                    <asp:Image ID="LogoImage" runat="server" ImageUrl="~/Images/logo.png" Width="150" />
                    <h3>
                        <asp:Literal ID="Literal1" Text="<%$  Resources : LoginGlossary, TituloResetarContraseña %>" runat="server" />
                    </h3>
                    <br />  
                    <asp:Label ID="Label2" runat="server" Text="<%$ Resources: LoginGlossary, RecoverPasswordSuccessMessage %>"></asp:Label>
                    <br />
                    <asp:LinkButton ID="LoginLinkButton" runat="server" Text="<%$ Resources: LoginGlossary, LoginLink %>"
                    OnClick="LoginLinkButton_Click"></asp:LinkButton>
                </div>
            </div>
        </div>
    </div>
</asp:Content>


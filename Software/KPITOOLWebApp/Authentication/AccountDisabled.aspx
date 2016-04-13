<%@ Page Title="<% $ Resources : LoginGlossary, AccountDisabledTitle %>" Language="C#" MasterPageFile="~/SimpleMasterPage.master" 
    AutoEventWireup="true" CodeFile="AccountDisabled.aspx.cs" Inherits="Authentication_AccountDisabled" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cp" Runat="Server">
 <asp:Literal ID="MessageLiteral" runat="server" Text="<%$ Resources:LoginGlossary, AccountDisabledMessage %>"></asp:Literal>
    <br />
    <br />
    <asp:LinkButton ID="LinkButton1" runat="server" Text="<%$ Resources:LoginGlossary, AccountDisabledReturnLinkText %>" 
        PostBackUrl="~/Authentication/Login.aspx"></asp:LinkButton>
</asp:Content>


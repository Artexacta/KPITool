<%@ Page Title="<% $  Resources : LoginGlossary, UserIsUnlockedTitle %>" Language="C#" MasterPageFile="~/SimpleMasterPage.master" 
    AutoEventWireup="true" CodeFile="UserIsUnlocked.aspx.cs" Inherits="Authentication_UserIsUnlocked" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cp" runat="Server">
    <span class="pageTitle">
        <asp:Literal ID="MessageLiteral" runat="server" Text="<% $  Resources : LoginGlossary, UserIsUnlockedTitle %>"></asp:Literal>
    </span>
    <br />
    <asp:Literal ID="Literal1" runat="server" Text="<% $  Resources : LoginGlossary, UserIsUnlockedMessage %>" />
    <br />
    <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="~/Authentication/Login.aspx" 
        Text="<% $  Resources : LoginGlossary, GoToLoginPage %>">
    </asp:HyperLink>
</asp:Content>


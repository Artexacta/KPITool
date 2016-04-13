<%@ Page Title="<% $  Resources : LoginGlossary, UserIsLockedTitle %>" Language="C#" MasterPageFile="~/SimpleMasterPage.master" 
    AutoEventWireup="true" CodeFile="UserIsLocked.aspx.cs" Inherits="Authentication_UserIsLocked" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cp" runat="Server">
    <span class="pageTitle">
        <asp:Literal ID="MessageLiteral" runat="server" Text="<% $  Resources : LoginGlossary, UserIsLockedTitle %>">
        </asp:Literal>
    </span>
    <br />
    <asp:Literal ID="Literal1" runat="server" Text="<% $  Resources : LoginGlossary, UserIsLockedMessage %>" />
    <br />
    <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="~/Authentication/Login.aspx"
        Text="<% $  Resources : LoginGlossary, GoToLoginPage %>"></asp:HyperLink>
</asp:Content>


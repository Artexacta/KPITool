<%@ Page Title="<% $  Resources : LoginGlossary, UserIsLockedTitle %>" Language="C#" MasterPageFile="~/SimpleMasterPage.master" 
    AutoEventWireup="true" CodeFile="UserIsLocked.aspx.cs" Inherits="Authentication_UserIsLocked" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cp" runat="Server">
    <div class="middle-box text-center animated fadeInDown">
        <h3 class="font-bold">
            <asp:Label ID="MessageLiteral" runat="server" Text="<% $  Resources : LoginGlossary, UserIsLockedTitle %>" />
        </h3>
        <div class="error-desc">
            <p>
                <asp:Literal ID="Literal1" runat="server" Text="<% $  Resources : LoginGlossary, UserIsLockedMessage %>" />
            </p>
            <p>
                <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="~/Authentication/Login.aspx" Text="<% $  Resources : LoginGlossary, GoToLoginPage %>" />
            </p>
        </div>
    </div>
</asp:Content>


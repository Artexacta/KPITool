<%@ Page Title="<% $  Resources : LoginGlossary, UserIsUnlockedTitle %>" Language="C#" MasterPageFile="~/SimpleMasterPage.master" 
    AutoEventWireup="true" CodeFile="UserIsUnlocked.aspx.cs" Inherits="Authentication_UserIsUnlocked" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cp" runat="Server">
    <div class="middle-box text-center animated fadeInDown">
        <h3 class="font-bold">
            <asp:Literal ID="MessageLiteral" runat="server" Text="<% $  Resources : LoginGlossary, UserIsUnlockedTitle %>"></asp:Literal>
        </h3>
        <div class="error-desc">
            <p>
                <asp:Literal ID="Literal1" runat="server" Text="<% $  Resources : LoginGlossary, UserIsUnlockedMessage %>" />
            </p>
            <p>
                <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="~/Authentication/Login.aspx" Text="<% $  Resources : LoginGlossary, GoToLoginPage %>" />
            </p>
        </div>
    </div>
</asp:Content>


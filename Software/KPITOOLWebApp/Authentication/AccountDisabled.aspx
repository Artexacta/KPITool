<%@ Page Title="<% $ Resources : LoginGlossary, AccountDisabledTitle %>" Language="C#" MasterPageFile="~/SimpleMasterPage.master" 
    AutoEventWireup="true" CodeFile="AccountDisabled.aspx.cs" Inherits="Authentication_AccountDisabled" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cp" Runat="Server">
    <div class="middle-box text-center animated fadeInDown">
        <div class="error-desc">
            <p>
                <asp:Literal ID="MessageLiteral" runat="server" Text="<%$ Resources:LoginGlossary, AccountDisabledMessage %>"></asp:Literal>
            </p>
            <p>
                <asp:LinkButton ID="LinkButton1" runat="server" Text="<%$ Resources:LoginGlossary, AccountDisabledReturnLinkText %>" 
                    PostBackUrl="~/Authentication/Login.aspx"></asp:LinkButton>
            </p>
        </div>
    </div>
</asp:Content>


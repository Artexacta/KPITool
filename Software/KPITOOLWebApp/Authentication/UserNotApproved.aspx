<%@ Page Title="<% $  Resources : LoginGlossary, UserNotApprovedTitle %>" Language="C#" MasterPageFile="~/SimpleMasterPage.master" 
    AutoEventWireup="true" CodeFile="UserNotApproved.aspx.cs" Inherits="Authentication_UserNotApproved" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cp" runat="Server">
    <div class="middle-box text-center animated fadeInDown">
        <h3 class="font-bold">
            <asp:Label ID="MessageLiteral" runat="server" Text="<% $  Resources : LoginGlossary, UserNotApprovedTitle %>" 
                CssClass="title"></asp:Label>
        </h3>
        <div class="error-desc">
            <p>
                <asp:Literal ID="Literal1" runat="server" Text="<% $  Resources : LoginGlossary, UserNotApprovedMessage %>"></asp:Literal>
            </p>
            <p>
                <asp:LinkButton ID="ReturnLinkButton" runat="server" CssClass="button" OnClick="ReturnLinkButton_Click">
                    <asp:Label ID="ReturnLabel" runat="server" Text="<% $  Resources : LoginGlossary, MessageGoToMainPage %>" />
                </asp:LinkButton>
            </p>
        </div>
    </div>
</asp:Content>


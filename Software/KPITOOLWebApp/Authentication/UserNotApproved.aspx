<%@ Page Title="<% $  Resources : LoginGlossary, UserNotApprovedTitle %>" Language="C#" MasterPageFile="~/SimpleMasterPage.master" 
    AutoEventWireup="true" CodeFile="UserNotApproved.aspx.cs" Inherits="Authentication_UserNotApproved" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cp" runat="Server">
    <div class="oneColumn">
        <div class="columnHead">
            <asp:Label ID="MessageLiteral" runat="server" Text="<% $  Resources : LoginGlossary, UserNotApprovedTitle %>"
                CssClass="title"></asp:Label>
        </div>
        <div class="columnContent">
            <p>
                <asp:Literal ID="Literal1" runat="server" Text="<% $  Resources : LoginGlossary, UserNotApprovedMessage %>"></asp:Literal>
            </p>
            <div class="clear">
            </div>
        </div>
        <div class="buttonsPanel">
            <asp:LinkButton ID="ReturnLinkButton" runat="server" CssClass="button" OnClick="ReturnLinkButton_Click">
                <asp:Label ID="ReturnLabel" runat="server" Text="<% $  Resources : LoginGlossary, MessageGoToMainPage %>" />
            </asp:LinkButton>
        </div>
    </div>
</asp:Content>


<%@ Control Language="C#" AutoEventWireup="true" CodeFile="PagerControl.ascx.cs" Inherits="UserControls_PagerControl" %>

<asp:Panel ID="PagePanel" runat="server" CssClass="paginationPanel">
    <asp:Button ID="FistPageLinkButton" runat="server"
        OnClick="FistPageLinkButton_Click" CssClass="btnPageFirst"
        ToolTip="<%$ Resources: Pager , FirstButtonLabel %>">
    </asp:Button>
    <asp:Button ID="PreviousPageLinkButton" runat="server"
        OnClick="PreviousPageLinkButton_Click" CssClass="btnPagePrev"
        ToolTip="<%$ Resources: Pager , PreviousButtonLabel %>">
    </asp:Button>

    <div class="InfoPage">
        <asp:Label ID="InfoPageLabel" runat="server"></asp:Label>
    </div>
    
    <asp:Button ID="NextPageLinkButton" runat="server"
        OnClick="NextPageLinkButton_Click" CssClass="btnPageNext" 
        ToolTip="<%$ Resources: Pager , NextButtonLabel %>">
    </asp:Button>
    <asp:Button ID="LastPageLinkButton" runat="server"
        OnClick="LastPageLinkButton_Click" CssClass="btnPageLast"
        ToolTip="<%$ Resources: Pager , LastButtonLabel %>">
    </asp:Button>
</asp:Panel>
<asp:Label ID="CurrentRowHiddenField" runat="server" Text="0" Visible="false" />
<asp:Label ID="TotalRowsHiddenField" runat="server" Text="0" Visible="false" />
<asp:Label ID="PageSizeHiddenField" runat="server" Text="10" Visible="false" />
<asp:Label ID="InvisibilityMethodHiddenField" runat="server" Text="PropertyControl" Visible="false" />
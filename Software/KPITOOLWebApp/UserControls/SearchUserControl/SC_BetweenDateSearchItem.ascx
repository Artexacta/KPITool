<%@ Control Language="C#" AutoEventWireup="true" CodeFile="SC_BetweenDateSearchItem.ascx.cs"
    Inherits="UserControls_SearchUserControl_SC_BetweenDateSearchItem" %>
<style type="text/css">
    .RadCalendarPopup
    {
        z-index: 8101 !important;
    }
    
    .RadCalendarFastNavPopup
    {
        z-index: 8300 !important;
    }
</style>
<div id="CSearch_Item_Container">
    <div id="CSearch_Item_Operation">
        <asp:RadioButtonList ID="rbtnOperation" runat="server" RepeatDirection="Horizontal"
            CssClass="CSearch_Item_Operation_List" CellPadding="0" CellSpacing="0" BorderWidth="0"
            BorderStyle="None">
            <asp:ListItem Text="AND" Value="AND" Selected="True"></asp:ListItem>
            <asp:ListItem Text="OR" Value="OR"></asp:ListItem>
        </asp:RadioButtonList>
        <asp:Literal ID="lblSpace" runat="server" Visible="false" Text="&nbsp;"></asp:Literal>
    </div>
    <div id="CSearch_Item_Panel">
        <asp:Label ID="lblTitle" runat="server" CssClass="CSearch_Item_Label"></asp:Label>
        <div id="CSearch_Item_Control">
            <table>
                <tr>
                    <td>
                        Desde:
                    </td>
                    <td>
                        <telerik:RadDatePicker ID="CSearch_ItemDesde_AspnetControl" runat="server" DisplayDateFormat="dd-MMM-yyyy"
                            ButtonsPosition="Right" DateFormat="dd/MM/yyyy" CssClass="CSearch_Item_Control"
                            EnableTyping="true">
                        </telerik:RadDatePicker>
                    </td>
                    <td>
                        Hasta:
                    </td>
                    <td>
                        <telerik:RadDatePicker ID="CSearch_ItemHasta_AspnetControl" runat="server" DisplayDateFormat="dd-MMM-yyyy"
                            ButtonsPosition="Right" DateFormat="dd/MM/yyyy" CssClass="CSearch_Item_Control"
                            EnableTyping="true">
                        </telerik:RadDatePicker>
                    </td>
                </tr>
            </table>
        </div>
    </div>
</div>

<%@ Control Language="C#" AutoEventWireup="true" CodeFile="SC_UsersSearchItem.ascx.cs" Inherits="UserControls_SearchUserControl_SC_UsersSearchItem" %>

<div id="CSearch_Item_Container">
     <div id="CSearch_Item_Operation">
        <asp:RadioButtonList ID="rbtnOperation" runat="server" 
            RepeatDirection="Horizontal"
            CssClass="CSearch_Item_Operation_List" CellPadding="0" CellSpacing="0" 
            BorderWidth="0" BorderStyle="None">
            <asp:ListItem Text="AND" Value="AND" Selected="True"></asp:ListItem>
            <asp:ListItem Text="OR" Value="OR"></asp:ListItem>
        </asp:RadioButtonList>
        <asp:Literal ID="lblSpace" runat="server" Visible="false" Text="&nbsp;"></asp:Literal>
    </div>

    <div id="CSearch_Item_Panel">
        <asp:Label ID="lblTitle" runat="server" 
                CssClass="CSearch_Item_Label"></asp:Label>
        <div id="CSearch_Item_Control">
            <telerik:RadComboBox ZIndex="8101" Width="200"
				ID="UsersRadComboBox" runat="server" 
                Filter="Contains"
				EnableLoadOnDemand="true"
				ShowMoreResultsBox="true" 
				EnableVirtualScrolling="true"
				EmptyMessage="- Seleccione un Usuario -">
				<WebServiceSettings Method="GetUsuarios" Path="~/AutoCompleteWS/ComboBoxWebServices.asmx" />
			</telerik:RadComboBox>
        </div>
    </div>
</div>

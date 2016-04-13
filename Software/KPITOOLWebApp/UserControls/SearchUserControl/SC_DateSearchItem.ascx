<%@ Control Language="C#" AutoEventWireup="true" CodeFile="SC_DateSearchItem.ascx.cs" Inherits="UserControls_SearchUserControl_SC_DateSearchItem" %>
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
						<telerik:RadComboBox ID="ddlOperator" runat="server" CssClass="CSearch_Item_Control_Operator" Width="50" ZIndex="8101">
							<Items>
								<telerik:RadComboBoxItem Text="=" Value=" " Selected="True"></telerik:RadComboBoxItem>
								<telerik:RadComboBoxItem Text="&gt;" Value=">"></telerik:RadComboBoxItem>
								<telerik:RadComboBoxItem Text="&lt;" Value="<"></telerik:RadComboBoxItem>
							</Items>
						</telerik:RadComboBox>
					</td>
					<td>
						<telerik:RadDatePicker ID="CSearch_Item_AspnetControl" runat="server" DisplayDateFormat="dd-MMM-yyyy"
							ButtonsPosition="Right" DateFormat="dd/MM/yyyy" CssClass="CSearch_Item_Control"
							EnableTyping="true">
						</telerik:RadDatePicker>
					</td>
				</tr>
			</table>
		</div>
	</div>
</div>

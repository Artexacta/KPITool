<%@ Control Language="C#" AutoEventWireup="true" CodeFile="SC_OrganizationSearchItem.ascx.cs"
    Inherits="UserControls_SearchUserControl_SC_OrganizationSearchItem" %>
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
            <telerik:RadComboBox ID="OrganizationComboBox" runat="server" CssClass="CSearch_Item_Control_Operator" ZIndex="8101" Width="50"
                DataSourceID="OrganizationObjectDataSource" DataValueField="OrganizationID" DataTextField="Name" >
            </telerik:RadComboBox>
            <asp:ObjectDataSource ID="OrganizationObjectDataSource" runat="server" OldValuesParameterFormatString="original_{0}" 
                SelectMethod="GetOrganizationsByUser" TypeName="Artexacta.App.Organization.BLL.OrganizationBLL">
                <SelectParameters>
                    <asp:Parameter DefaultValue="1=1" Name="whereClause" Type="String" />
                </SelectParameters>
            </asp:ObjectDataSource>
        </div>
    </div>
</div>

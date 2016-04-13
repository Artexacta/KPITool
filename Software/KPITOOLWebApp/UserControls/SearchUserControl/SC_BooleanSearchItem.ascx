<%@ Control Language="C#" AutoEventWireup="true" CodeFile="SC_BooleanSearchItem.ascx.cs" Inherits="UserControls_SearchUserControl_SC_BooleanSearchItem" %>
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
            <asp:RadioButtonList ID="rbtValues" runat="server"
                CssClass="CSearch_Item_Operation_List" 
                CellPadding="0" 
                CellSpacing="0" 
                RepeatDirection="Horizontal">
                 <asp:ListItem Value="none" 
                    Text="<%$ Resources: BooleanSearchItem, NoValue %>" Selected="True">
                 </asp:ListItem>
                 <asp:ListItem Value="true" 
                    Text="<%$ Resources: BooleanSearchItem, TrueValue %>">
                 </asp:ListItem>
                 <asp:ListItem Value="false" 
                    Text="<%$ Resources: BooleanSearchItem, FalseValue %>">
                 </asp:ListItem>
            </asp:RadioButtonList>
        </div>
    </div>
</div>
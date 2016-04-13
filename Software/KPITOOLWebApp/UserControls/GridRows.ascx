<%@ Control Language="C#" AutoEventWireup="true" CodeFile="GridRows.ascx.cs" Inherits="UserControls_GridRows" %>
<table border="0" cellpadding="0" cellspacing="0" class="gridRowsNumberSelector">
    <tr>
        <td>
            <asp:ImageButton ID="Rows3ImageButton" runat="server" ImageUrl="~/Images/neutral/3rows.gif"
                OnClick="Rows3ImageButton_Click" ToolTip="<%$ Resources : GridRowsLabels , Show3 %>"
                Height="13px" Width="13px" />
        </td>
    </tr>
    <tr>
        <td>
            <asp:ImageButton ID="Rows5ImageButton" runat="server" ImageUrl="~/Images/neutral/5rows.gif"
                OnClick="Rows5ImageButton_Click" ToolTip="<%$ Resources : GridRowsLabels , Show5 %>"
                Height="13px" Width="13px" />
        </td>
    </tr>
    <tr>
        <td>
            <asp:ImageButton ID="Rows10ImageButton" runat="server" ImageUrl="~/Images/neutral/10rows.gif"
                OnClick="Rows10ImageButton_Click" ToolTip="<%$ Resources : GridRowsLabels , Show10 %>"
                Height="13px" Width="13px" />
        </td>
    </tr>
    <tr>
        <td>
            <asp:ImageButton ID="Rows20ImageButton" runat="server" ImageUrl="~/Images/neutral/20rows.gif"
                OnClick="Rows20ImageButton_Click" ToolTip="<%$ Resources : GridRowsLabels , Show20 %>"
                Height="13px" Width="13px" />
        </td>
    </tr>
    <tr>
        <td>
            <asp:ImageButton ID="Rows30ImageButton" runat="server" ImageUrl="~/Images/neutral/30rows.gif"
                OnClick="Rows30ImageButton_Click" ToolTip="<%$ Resources : GridRowsLabels , Show30 %>"
                Height="13px" Width="13px" />
        </td>
    </tr>
    <tr>
        <td>
            <asp:ImageButton ID="Rows50ImageButton" runat="server" ImageUrl="~/Images/neutral/50rows.gif"
                OnClick="Rows50ImageButton_Click" ToolTip="<%$ Resources : GridRowsLabels , Show50 %>"
                Height="13px" Width="13px" />
        </td>
    </tr>
</table>
<asp:HiddenField ID="AssociatedGridHF" runat="server" Value="" />
<asp:HiddenField ID="Rows3HF" runat="server" Value="False" />
<asp:HiddenField ID="Rows5HF" runat="server" Value="False" />
<asp:HiddenField ID="Rows10HF" runat="server" Value="False" />
<asp:HiddenField ID="Rows20HF" runat="server" Value="False" />
<asp:HiddenField ID="Rows30HF" runat="server" Value="False" />
<asp:HiddenField ID="Rows50HF" runat="server" Value="False" />

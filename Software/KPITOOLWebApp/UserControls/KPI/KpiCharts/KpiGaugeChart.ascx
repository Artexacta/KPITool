<%@ Control Language="C#" AutoEventWireup="true" CodeFile="KpiGaugeChart.ascx.cs" Inherits="UserControls_KPI_KpiCharts_KpiGaugeChart" %>
<asp:Literal ID="ChartLiteral" runat="server"></asp:Literal>
<asp:Panel ID="CurrentValuePanel" runat="server" Visible="false" CssClass="text-center">
    <span style="font-weight:bold;font-size: 72px;margin-top: 100px;display: inline-block;">
        <asp:Literal ID="CurrentValueLiteral" runat="server"></asp:Literal>
    </span>
</asp:Panel>
<asp:HiddenField ID="KpiIdHiddenField" runat="server" Value="0" />
<asp:HiddenField ID="CategoryIdHiddenField" runat="server" Value="" />
<asp:HiddenField ID="CategoryItemIdHiddenField" runat="server" Value="" />

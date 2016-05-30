<%@ Control Language="C#" AutoEventWireup="true" CodeFile="KpiLineChart.ascx.cs" Inherits="UserControls_KPI_KpiCharts_KpiLineChart" %>
<asp:Panel ID="SumChartPanel" runat="server" CssClass="m-b-10" Visible="false">
    <asp:Literal ID="SumChartLiteral" runat="server"></asp:Literal>
</asp:Panel>
<asp:Literal ID="ChartLiteral" runat="server"></asp:Literal>
<asp:HiddenField ID="KpiIdHiddenField" runat="server" Value="0" />
<asp:HiddenField ID="CategoryIdHiddenField" runat="server" Value="" />
<asp:HiddenField ID="CategoryItemIdHiddenField" runat="server" Value="" />
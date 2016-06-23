<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ExcelExportKpiChart.ascx.cs" Inherits="UserControls_KPI_KpiCharts_ExcelExportKpiChart" %>
<asp:LinkButton ID="ExportButton" runat="server" OnClick="ExportButton_Click"
    ToolTip="<%$ Resources: KpiDashboard, ExportKpi %>">
    <i class="fa fa-file-excel-o fa-2x text-success"></i>
</asp:LinkButton>
<asp:HiddenField ID="KpiIdHiddenField" runat="server" Value="0" />
<asp:HiddenField ID="CategoryIdHiddenField" runat="server" Value="" />
<asp:HiddenField ID="CategoryItemIdHiddenField" runat="server" Value="" />

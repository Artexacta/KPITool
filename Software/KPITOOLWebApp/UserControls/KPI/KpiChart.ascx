<%@ Control Language="C#" AutoEventWireup="true" CodeFile="KpiChart.ascx.cs" Inherits="UserControls_KPI_KpiChart" %>
<%@ Register Src="~/UserControls/KPI/KpiCharts/KpiGaugeChart.ascx" TagName="KpiGaugeChart" TagPrefix="app" %>
<%@ Register Src="~/UserControls/KPI/KpiCharts/KpiLineChart.ascx" TagName="KpiLineChart" TagPrefix="app" %>
<div class="row">
    <div class="col-md-4">
        <app:KpiGaugeChart ID="GaugeControl" runat="server" />
    </div>
    <div class="col-md-8">
        <app:KpiLineChart ID="LineChartControl" runat="server" />
    </div>
</div>
<asp:HiddenField ID="KpiIdHiddenField" runat="server" Value="0" />
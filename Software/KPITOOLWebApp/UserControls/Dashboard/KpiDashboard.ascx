<%@ Control Language="C#" AutoEventWireup="true" CodeFile="KpiDashboard.ascx.cs" Inherits="UserControls_Dashboard_KpiDashboard" %>
<%@ Register Src="~/UserControls/KPI/KpiChart.ascx" TagName="KpiChart" TagPrefix="app" %>
<%@ Register Src="~/UserControls/KPI/KpiCharts/ExcelExportKpiChart.ascx" TagName="ExcelExportKpiChart" TagPrefix="app" %>

<asp:Repeater ID="KpisRepeater" runat="server"
    OnItemCommand="KpisRepeater_ItemCommand"
    OnItemDataBound="KpisRepeater_ItemDataBound">
    <ItemTemplate>
        <div class="row">
            <div class="col-md-12">
                <h2>
                    <asp:Literal ID="NameLiteral" runat="server" Text='<%# Eval("KpiName") %>'></asp:Literal>
                </h2>
            </div>
            <div class="col-md-6">

            </div>
            <div    class="col-md-6 text-right">
                <asp:LinkButton ID="ViewButton" runat="server" CommandArgument='<%# Eval("KpiId") %>' CommandName="ViewKPI"
                    ToolTip="<%$ Resources: KpiDashboard, ViewKpi %>">
                    <i class="fa fa-eye fa-2x"></i>
                </asp:LinkButton>
                &nbsp;
                <app:ExcelExportKpiChart ID="ExcelExportControl" runat="server" KpiId='<%# Eval("KpiId") %>' />
                &nbsp;
                <asp:LinkButton ID="DeleteButton" runat="server" CommandArgument='<%# Eval("KpiId") %>' CommandName="DeleteKPI"
                    ToolTip="<%$ Resources: KpiDashboard, RemoveKpiFromDashboard %>">
                    <i class="fa fa-trash fa-2x text-danger"></i>
                </asp:LinkButton>
            </div>
            <div class="col-md-12">
                <app:KpiChart ID="KpiChartControl" runat="server" KpiId='<%# Eval("KpiId") %>' />
            </div>
        </div>
    </ItemTemplate>
    <FooterTemplate>
        <asp:Panel ID="EmptyMessageContaienr" runat="server" CssClass="row" Visible='<%# KpisRepeater.Items.Count == 0 %>'>
            <br />
            <h3 class="col-md-12 text-center">
                You have not added any KPIs to this Dashboard.<br />
                Please go to the view page of any KPI and add it to this dashboard.
            </h3>
        </asp:Panel>
    </FooterTemplate>
</asp:Repeater>
<asp:HiddenField ID="DashboardIdHiddenField" runat="server" Value="0" />
<asp:HiddenField ID="UserIdHiddenField" runat="server" Value="0" />
<asp:HiddenField ID="TabIdHiddenField" runat="server" Value="t" />
<%--<asp:ObjectDataSource ID="KpiDataSource" runat="server"
    TypeName="Artexacta.App.Dashboard.BLL.KpiDashboardBLL"
    SelectMethod="GetKpiDashboard"
    OnSelected="KpiDataSource_Selected">
    <SelectParameters>
        <asp:ControlParameter ControlID="DashboardIdHiddenField" Type="Int32" Name="dashboardId" PropertyName="Value" />
        <asp:ControlParameter ControlID="UserIdHiddenField" Type="Int32" Name="userId" PropertyName="Value"/>
    </SelectParameters>
</asp:ObjectDataSource>--%>
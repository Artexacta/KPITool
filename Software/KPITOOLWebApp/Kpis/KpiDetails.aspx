<%@ Page Title="KPI" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="KpiDetails.aspx.cs" Inherits="Kpis_KpiDetails" %>

<%@ Register Src="~/UserControls/KPI/KpiChart.ascx" TagName="KpiChart" TagPrefix="app" %>
<%@ Register Src="~/UserControls/KPI/KpiSummary/KpiMeasurements.ascx" TagName="KpiMeasurements" TagPrefix="app" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cp" runat="Server">
    <div class="row">
        <div class="col-md-1">
            <div class="page-header">
                <div class="dropdown">
                    <app:AddButton ID="TheAddButton" runat="server" />
                </div>
            </div>
        </div>
        <div class="col-md-11">
            <h1 class="text-center">
                <asp:Literal ID="KpiNameLiteral" runat="server"></asp:Literal>
            </h1>
        </div>
    </div>

    <div class="container">

        <div class="tile">
            <div class="t-body tb-padding">
                <div class="row">
                    <div class="col-sm-6">
                        <div class="row">
                            <asp:Literal ID="KpiType" runat="server"></asp:Literal>
                            <asp:Literal ID="WebServiceId" runat="server"></asp:Literal>
                            <asp:Literal ID="ReportingUnit" runat="server"></asp:Literal>
                            <asp:Literal ID="KpiTarget" runat="server"></asp:Literal>
                            <asp:Literal ID="StartingDate" runat="server"></asp:Literal>

                        </div>
                    </div>
                </div>
                <div class="row">
                    <%--<asp:Panel ID="MeanTimeGraphic" runat="server">
                        <div class="col-md-4">
                            <div class="gauger" style="height: 300px;"></div>
                        </div>
                        <div class="col-md-8">
                            <asp:Image ID="gr1" runat="server" ImageUrl="~/Images/graphic01.jpg" CssClass="img-responsive" />
                        </div>
                    </asp:Panel>--%>
                    <asp:Panel ID="RevenueCollectionGraphic" runat="server" Visible="false">
                        <app:KpiChart ID="ChartControl" runat="server" />
                    </asp:Panel>
                </div>
                <div class="row">
                    <div class="col-md-5">
                        <p>90% progress towards the goal of 2 months between failures</p>
                        <p><span style="font-size: 18px;" class="text-danger"><i class="zmdi zmdi-long-arrow-down zmdi-hc-fw"></i></span>Down 5% from last month</p>
                        <p>Lowest value: 2 days</p>
                        <p>Highest value: 1.6 months</p>
                        <p>Current value: 1.0 months</p>
                        <p>To date average: 0.7 months</p>
                    </div>
                    <div class="col-md-7">
                        <div class="table-responsive" style="max-height: 200px;">
                            <app:KpiMeasurements ID="MeasurementsControl" runat="server" />
                        </div>
                    </div>
                </div>
                
                <asp:Panel ID="CategoriesPanel" runat="server" CssClass="row" Visible="false">
                    <asp:Repeater ID="CategoriesRepeater" runat="server"
                        OnItemDataBound="CategoriesRepeater_ItemDataBound">
                        <HeaderTemplate>
                            <div class="row m-t-20">
                        </HeaderTemplate>
                        <ItemTemplate>
                            <div class="col-md-12">
                                <button id="buttonCollapse" runat="server" class="btn btn-default btn-block m-b-20 btn-category" type="button"
                                    data-target='<%# "#" + Eval("HtmlId") %>' aria-expanded="false" aria-controls="collapseExample">
                                    <asp:Literal ID="CategoryForDisplay" runat="server" Text='<%# Eval("ObjectForDisplay") %>'></asp:Literal>
                                </button>
                                <asp:Literal ID="CollapseLiteral" runat="server">
                                </asp:Literal>
                                    <app:KpiChart ID="KpiChartCategory" runat="server" KpiId='<%# Eval("KpiId") %>'
                                        CategoryId='<%# Eval("CategoryId") %>' CategoryItemId='<%# Eval("CategoryItemId") %>' />
                                    <div class="row">
                                        <div class="col-md-5">
                                            <p>90% progress towards the goal of 2 months between failures</p>
                                            <p><span style="font-size: 18px;" class="text-danger"><i class="zmdi zmdi-long-arrow-down zmdi-hc-fw"></i></span>Down 5% from last month</p>
                                            <p>Lowest value: 2 days</p>
                                            <p>Highest value: 1.6 months</p>
                                            <p>Current value: 1.0 months</p>
                                            <p>To date average: 0.7 months</p>
                                        </div>
                                        <div class="col-md-7">
                                            <div class="table-responsive" style="max-height: 200px;">
                                                <app:KpiMeasurements ID="MeasurementsControl" runat="server" KpiId='<%# Eval("KpiId") %>'
                                                    CategoryId='<%# Eval("CategoryId") %>' CategoryItemId='<%# Eval("CategoryItemId") %>'  />
                                            </div>
                                        </div>
                                    </div>
                                <asp:Literal ID="CloseCollapseLiteral" runat="server" Text="</div>"></asp:Literal>
                            </div>
                            
                        </ItemTemplate>
                        <FooterTemplate>
                            </div>
                        </FooterTemplate>
                    </asp:Repeater>
                </asp:Panel>
                
                <div class="row">
                    <div class="col-md-5">
                        <a href="#" data-toggle="modal" data-target="#myModal" class="btn btn-default">
                            <i class="fa fa-plus-square"></i>Add this KPI to a Dashboard
                        </a>
                        <br />
                        <asp:PlaceHolder ID="HeaderTemplate" runat="server">
                            <p class="m-t-10">This KPI is in the following Dashboards:</p>
                        </asp:PlaceHolder>
                        <asp:Repeater ID="DashboardRepeater" runat="server"
                            DataSourceID="UserDashboardDataSource"
                            OnPreRender="DashboardRepeater_PreRender"
                            OnItemCommand="DashboardRepeater_ItemCommand"
                            OnItemDataBound="DashboardRepeater_ItemDataBound">
                            <ItemTemplate>
                                <div style="padding-left: 10px;" class="m-t-10 p-l-10">
                                    <asp:LinkButton ID="DeleteButton" runat="server" CommandArgument='<%# Eval("DashboardId") %>'
                                        OnClientClick="return confirm('Are you sure you want to remove this KPI from selected Dashboard?')"
                                        CommandName="DeleteDashboard">
                                        <i class="fa fa-trash"></i>
                                    </asp:LinkButton>
                                    <asp:Literal ID="DashboardLiteral" runat="server"
                                        Text='<%# Eval("Name") %>'>
                                    </asp:Literal>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                        <asp:PlaceHolder ID="EmptyTemplate" runat="server">
                            <p class="m-t-10">This KPI is not added to any Dashboard</p>
                        </asp:PlaceHolder>

                        <asp:ObjectDataSource ID="UserDashboardDataSource" runat="server"
                            TypeName="Artexacta.App.Dashboard.BLL.UserDashboardBLL"
                            SelectMethod="GetUserDashboardsByKpiId"
                            OnSelected="UserDashboardDataSource_Selected">
                            <SelectParameters>
                                <asp:ControlParameter ControlID="KpiIdHiddenField" Type="Int32" Name="kpiId" PropertyName="Value" />
                                <asp:ControlParameter ControlID="UserIdHiddenField" Type="Int32" Name="userId" PropertyName="Value" />
                            </SelectParameters>
                        </asp:ObjectDataSource>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="myModalLabel">Add to Dashboard</h4>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label>Dashboard Name</label>
                        <asp:DropDownList ID="DashboardsComboBox" runat="server"
                            DataSourceID="UserDashboardDataSource2"
                            OnDataBound="DashboardsComboBox_DataBound"
                            DataTextField="Name"
                            DataValueField="DashboardId">
                        </asp:DropDownList>
                    </div>
                    <asp:RequiredFieldValidator runat="server" Display="Dynamic"
                        ErrorMessage="You must select a Dashboard"
                        ControlToValidate="DashboardsComboBox"
                        ValidationGroup="Dashboard">
                    </asp:RequiredFieldValidator>
                    <asp:ObjectDataSource ID="UserDashboardDataSource2" runat="server"
                        TypeName="Artexacta.App.Dashboard.BLL.UserDashboardBLL"
                        SelectMethod="GetUserDashboardWhenKpiIdIsNotIn"
                        OnSelected="UserDashboardDataSource_Selected">
                        <SelectParameters>
                            <asp:ControlParameter ControlID="KpiIdHiddenField" Type="Int32" Name="kpiId" PropertyName="Value" />
                            <asp:ControlParameter ControlID="UserIdHiddenField" Type="Int32" Name="userId" PropertyName="Value" />
                        </SelectParameters>
                    </asp:ObjectDataSource>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <asp:LinkButton ID="SaveButton" runat="server" CssClass="btn btn-primary" OnClick="SaveButton_Click"
                        ValidationGroup="Dashboard">Save</asp:LinkButton>
                </div>
            </div>
        </div>
    </div>
    <asp:HiddenField ID="IsAddedInMainDashboard" Value="false" runat="server" />
    <script type="text/javascript">
        $(document).ready(function () {
            $(".btn-category").click(function () {
                var id = $(this).data("target");
                var fn = function () { $(window).resize(); };
                if ($(id).is(":visible"))
                    $(id).slideUp(500, fn);
                else
                    $(id).slideDown(500, fn);
            });
        });
    </script>
    <%--<script type="text/javascript">
        $(function () {
            $('.gauger').attr("data-value", $("#" + '<%= Progress.ClientID %>').val())
            $('.gauger').each(function () {
                var progress = $(this).data("value");
                $(this).highcharts({

                    chart: {
                        type: 'gauge',
                        plotBackgroundColor: null,
                        plotBackgroundImage: null,
                        plotBorderWidth: 0,
                        plotShadow: false
                    },
                    title: {
                        text: ''
                    },
                    pane: {
                        startAngle: -150,
                        endAngle: 150,
                        background: [{
                            backgroundColor: {
                                linearGradient: { x1: 0, y1: 0, x2: 0, y2: 1 },
                                stops: [
                                    [0, '#FFF'],
                                    [1, '#333']
                                ]
                            },
                            borderWidth: 0,
                            outerRadius: '109%'
                        }, {
                            backgroundColor: {
                                linearGradient: { x1: 0, y1: 0, x2: 0, y2: 1 },
                                stops: [
                                    [0, '#333'],
                                    [1, '#FFF']
                                ]
                            },
                            borderWidth: 1,
                            outerRadius: '107%'
                        }, {
                            // default background
                        }, {
                            backgroundColor: '#DDD',
                            borderWidth: 0,
                            outerRadius: '105%',
                            innerRadius: '103%'
                        }]
                    },

                    // the value axis
                    yAxis: {
                        min: 0,
                        max: 100,

                        minorTickInterval: 'auto',
                        minorTickWidth: 1,
                        minorTickLength: 10,
                        minorTickPosition: 'inside',
                        minorTickColor: '#666',

                        tickPixelInterval: 30,
                        tickWidth: 2,
                        tickPosition: 'inside',
                        tickLength: 10,
                        tickColor: '#666',
                        labels: {
                            step: 2,
                            rotation: 'auto'
                        },
                        title: {
                            text: '%'
                        },
                        plotBands: [{
                            from: 0,
                            to: 33,
                            color: '#DF5353' // red
                        }, {
                            from: 33,
                            to: 66,
                            color: '#DDDF0D' // yellow
                        }, {
                            from: 66,
                            to: 100,
                            color: '#55BF3B' // green
                        }]
                    },

                    series: [{
                        name: 'Complete',
                        data: [progress],
                        tooltip: {
                            valueSuffix: ' %'
                        }
                    }]

                });
            });
        });
    </script>--%>
    <asp:HiddenField ID="Progress" runat="server" />
    <asp:HiddenField ID="KpiIdHiddenField" runat="server" Value="0" />
    <asp:HiddenField ID="UserIdHiddenField" runat="server" Value="0" />
</asp:Content>


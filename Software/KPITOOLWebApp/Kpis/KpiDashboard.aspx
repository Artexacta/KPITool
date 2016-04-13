<%@ Page Title="KPI Dashboard" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="KpiDashboard.aspx.cs" Inherits="Kpis_KpiDashboard" %>

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
            <h1 class="text-center">KPI Dashboard
            </h1>
        </div>
    </div>

    <div class="container">

        <div class="tile">
            <div class="t-body tb-padding">
                <div class="row">
                    <asp:Repeater ID="KpisRepeater" runat="server" OnItemDataBound="KpisRepeater_ItemDataBound" OnItemCommand="KpisRepeater_ItemCommand">
                        <ItemTemplate>
                            <div class="col-md-12 m-b-20">
                                <div class="row">
                                    <div class="col-md-8">
                                        <%#Eval("Name") %><span style="font-size: 18px;" class="text-danger"><i class="zmdi zmdi-long-arrow-down zmdi-hc-fw"></i></span>Down 5% from last day
                                    </div>
                                    <div class="col-md-4">
                                        <asp:LinkButton ID="ViewKpi" CommandArgument='<%# Eval("ObjectId") %>' CommandName="ViewKpi"  runat="server" CssClass="viewBtn detailsBtn"><i class="zmdi zmdi-eye zmdi-hc-fw"></i></asp:LinkButton>
                                        <asp:LinkButton ID="DeleteKpi" CommandArgument='<%# Eval("ObjectId") %>' CommandName="DeleteKpi" runat="server" CssClass="viewBtn deleteBtn" 
                                            OnClientClick="return confirm('Are you sure you want to delete the selected KPI?')"><i class="zmdi zmdi-minus-circle-outline zmdi-hc-fw"></i></asp:LinkButton>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="gauger" data-value='<%#Eval("Progress") %>' style="height: 250px;"></div>
                            </div>
                            <div class="col-md-6">
                                <asp:Image ID="Graphic" runat="server" ImageUrl="~/Images/graphic01.jpg" CssClass="img-responsive" />
                            </div>
                            <div class="col-md-3">
                                <asp:Literal ID="KpiExtraData" runat="server"></asp:Literal>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        $(function () {
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
    </script>
</asp:Content>


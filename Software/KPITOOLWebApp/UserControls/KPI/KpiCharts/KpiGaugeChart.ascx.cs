using DotNet.Highcharts.Enums;
using DotNet.Highcharts.Options;
using log4net;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class UserControls_KPI_KpiCharts_KpiGaugeChart : System.Web.UI.UserControl
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

    public int KpiId
    {
        set { KpiIdHiddenField.Value = value.ToString(); }
        get
        {
            int kpiId = 0;
            try
            {
                kpiId = Convert.ToInt32(KpiIdHiddenField.Value);
            }
            catch (Exception ex)
            {
                log.Error("Error getting ", ex);
            }
            return kpiId;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        BuildChart();
    }

    public void BuildChart()
    {
        DotNet.Highcharts.Highcharts chart = new DotNet.Highcharts.Highcharts(ClientID)
            .InitChart(new Chart()
            {
                Type = ChartTypes.Gauge,
                PlotBackgroundColor = null,
                PlotBackgroundImage = null,
                PlotBorderWidth = 0,
                PlotShadow = false
            })
            .SetTitle(new Title(){
                Text = ""
            })
            .SetPane(new Pane()
            {
                StartAngle = -150,
                EndAngle = 150,
                Background = new DotNet.Highcharts.Helpers.BackgroundObject[]
                {
                    new DotNet.Highcharts.Helpers.BackgroundObject(){
                        BackgroundColor = new DotNet.Highcharts.Helpers.BackColorOrGradient(new DotNet.Highcharts.Helpers.Gradient(){
                           LinearGradient =  new int[] { 0,0,0,1},
                            Stops = new object[,] 
                                {
                                    {0, "#FFF"},
                                    {1, "#333"}
                                }
                        }),
                        BorderWidth = new DotNet.Highcharts.Helpers.PercentageOrPixel(1),
                        OuterRadius = new DotNet.Highcharts.Helpers.PercentageOrPixel(109, true)
                    },
                    new DotNet.Highcharts.Helpers.BackgroundObject(){
                        BackgroundColor = new DotNet.Highcharts.Helpers.BackColorOrGradient(new DotNet.Highcharts.Helpers.Gradient(){
                           LinearGradient =  new int[] { 0,0,0,1},
                            Stops = new object[,] 
                                {
                                    {0, "#FFF"},
                                    {1, "#333"}
                                }
                        }),
                        BorderWidth = new DotNet.Highcharts.Helpers.PercentageOrPixel(1),
                        OuterRadius = new DotNet.Highcharts.Helpers.PercentageOrPixel(107, true)
                    },
                    new DotNet.Highcharts.Helpers.BackgroundObject()
                    ,
                    new DotNet.Highcharts.Helpers.BackgroundObject(){
                        BackgroundColor = new DotNet.Highcharts.Helpers.BackColorOrGradient(ColorTranslator.FromHtml("#DDD")),
                        BorderWidth = new DotNet.Highcharts.Helpers.PercentageOrPixel(0),
                        OuterRadius = new DotNet.Highcharts.Helpers.PercentageOrPixel(105, true),
                        InnerRadius = new DotNet.Highcharts.Helpers.PercentageOrPixel(103, true)
                    }
                }
            }).SetYAxis(new YAxis()
            {
                Min = 0,
                Max = 100,

                MinorTickWidth = 1,
                MinorTickLength = 10,
                MinorTickPosition = TickPositions.Inside,
                MinorTickColor = ColorTranslator.FromHtml("#666"),

                TickPixelInterval = 30,
                TickWidth = 2,
                TickPosition = TickPositions.Inside,
                TickLength = 10,
                TickColor = ColorTranslator.FromHtml("#666"),

                Labels = new YAxisLabels()
                {
                    Step = 2
                },
                Title = new YAxisTitle() { Text = "%" },
                PlotBands = new YAxisPlotBands[] 
                {
                    new YAxisPlotBands()
                    {
                        From = 0,
                        To = 33,
                        Color = ColorTranslator.FromHtml("#DF5353")
                    },
                    new YAxisPlotBands()
                    {
                        From = 33,
                        To = 66,
                        Color = ColorTranslator.FromHtml("#DDDF0D")
                    },
                    new YAxisPlotBands()
                    {
                        From = 66,
                        To = 100,
                        Color = ColorTranslator.FromHtml("#55BF3B")
                    }
                }
            })
            .SetSeries(new Series()
            {
                Name = "Complete",
                Data = new DotNet.Highcharts.Helpers.Data(new object[] { 80 })
            });
        ChartLiteral.Text = chart.ToHtmlString();
    }
}
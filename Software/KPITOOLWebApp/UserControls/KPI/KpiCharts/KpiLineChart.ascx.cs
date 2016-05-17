using Artexacta.App.KPI;
using Artexacta.App.KPI.BLL;
using DotNet.Highcharts.Enums;
using DotNet.Highcharts.Helpers;
using DotNet.Highcharts.Options;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class UserControls_KPI_KpiCharts_KpiLineChart : System.Web.UI.UserControl
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

    public int KpiId
    {
        set {
            KpiIdHiddenField.Value = value.ToString();
        }
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
        try
        {
            BuildChart();
        }
        catch (Exception ex)
        {
            log.Error("Error building chart", ex);
        }
    }

    public void BuildChart()
    {
        int kpiId = KpiId;
        List<KPIMeasurement> measurements = KpiMeasurementBLL.GetKPIMeasurementForChart(kpiId);
        Dictionary<string, object> points = new Dictionary<string, object>();
        foreach (var item in measurements)
        {
            points.Add(item.Date.ToString("yyyy-MM-dd"), item.Measurement);
        }

        DotNet.Highcharts.Highcharts chart = new DotNet.Highcharts.Highcharts(ClientID)
            .InitChart(new Chart(){
                Type =  ChartTypes.Line
            })
            .SetTitle(new Title()
            {
                Text = ""
            })
            .SetXAxis(new XAxis
                        {
                            Categories = points.Keys.ToArray<string>()
                        })
            .SetSeries(new Series
                        {
                            Name = "Values",
                            Data = new Data(points.Values.ToArray<object>())
                        })
            .SetLegend(new Legend()
            {
                Layout = Layouts.Horizontal,
                Align = HorizontalAligns.Center,
                VerticalAlign = VerticalAligns.Bottom,
                BorderWidth = 0
            });

        ChartLiteral.Text = chart.ToHtmlString();
    }
}
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
                log.Error("Error getting kpiId", ex);
            }
            return kpiId;
        }
    }

    public int CategoryId
    {
        set
        {
            CategoryIdHiddenField.Value = value.ToString();
        }
        get
        {
            int id = 0;
            try
            {
                id = Convert.ToInt32(CategoryIdHiddenField.Value);
            }
            catch (Exception ex)
            {
                log.Error("Error getting CategoryId", ex);
            }
            return id;
        }
    }

    public int CategoryItemId
    {
        set
        {
            CategoryItemIdHiddenField.Value = value.ToString();
        }
        get
        {
            int id = 0;
            try
            {
                id = Convert.ToInt32(CategoryItemIdHiddenField.Value);
            }
            catch (Exception ex)
            {
                log.Error("Error getting CategoryId", ex);
            }
            return id;
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
        string strategyId = "";
        decimal target = 0;
        List<KpiChartData> measurements = KpiMeasurementBLL.GetKPIMeasurementForChart(kpiId, CategoryId, CategoryItemId, ref strategyId, ref target);
        Dictionary<string, object> standardSerie = new Dictionary<string, object>();
        Dictionary<string, object> targetStandardSerie = new Dictionary<string, object>();

        Dictionary<string, object> sumSerie = new Dictionary<string, object>();
        Dictionary<string, object> targetSumSerie = new Dictionary<string, object>();

        bool hasTarget = target != -1;
        bool isSum = strategyId == "SUM";

        decimal sumMeasurement = 0;
        decimal sumTarget = 0;
        foreach (var item in measurements)
        {
            standardSerie.Add(item.Period, item.Measurement);
            if (isSum)
            {
                sumMeasurement = sumMeasurement + item.Measurement;
                sumSerie.Add(item.Period, sumMeasurement);
                if (hasTarget)
                {
                    sumTarget = sumTarget + target;
                    targetSumSerie.Add(item.Period, sumTarget);
                    
                }
            }
            if (hasTarget)
            {
                targetStandardSerie.Add(item.Period, target);                
            }
                
        }
        List<Series> series = new List<Series>();
        series.Add(new Series
        {
            Name = "Values",
            Data = new Data(standardSerie.Values.ToArray<object>())
        });
        if(hasTarget)
        {
            series.Add(new Series
            {
                Name = "Target",
                Color = System.Drawing.Color.Red,
                Data = new Data(targetStandardSerie.Values.ToArray<object>())
            });
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
                            Categories = standardSerie.Keys.ToArray<string>()
                        })
            .SetSeries(series.ToArray())
            .SetLegend(new Legend()
            {
                Layout = Layouts.Horizontal,
                Align = HorizontalAligns.Center,
                VerticalAlign = VerticalAligns.Bottom,
                BorderWidth = 0
            });
        ChartLiteral.Text = chart.ToHtmlString();

        if (isSum)
        {
            series = new List<Series>();
            series.Add(new Series
            {
                Name = "Values",
                Data = new Data(sumSerie.Values.ToArray<object>())
            });
            if (hasTarget)
            {
                series.Add(new Series
                {
                    Name = "Target",
                    Color = System.Drawing.Color.Red,
                    Data = new Data(targetSumSerie.Values.ToArray<object>())
                });
            }
            chart = new DotNet.Highcharts.Highcharts(ClientID + "_sum")
            .InitChart(new Chart()
            {
                Type = ChartTypes.Line
            })
            .SetTitle(new Title()
            {
                Text = ""
            })
            .SetXAxis(new XAxis
            {
                Categories = standardSerie.Keys.ToArray<string>()
            })
            .SetSeries(series.ToArray())
            .SetLegend(new Legend()
            {
                Layout = Layouts.Horizontal,
                Align = HorizontalAligns.Center,
                VerticalAlign = VerticalAligns.Bottom,
                BorderWidth = 0
            });
            SumChartLiteral.Text = chart.ToHtmlString();
            SumChartPanel.Visible = true;
        }
    }
}
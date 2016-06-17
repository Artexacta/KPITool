<%@ WebHandler Language="C#" Class="KpiImageHandler" %>

using System;
using System.Web;
using System.Collections.Generic;
using Artexacta.App.KPI;
using Artexacta.App.KPI.BLL;

public class KpiImageHandler : IHttpHandler {

    public void ProcessRequest (HttpContext context) {
        int imageHeight = 400;
        int imageWidth = 800;

        int ownerId = Convert.ToInt32(context.Request["ownerId"]);
        string ownerType = context.Request["ownerType"];
        string userName = context.Request["userName"];
        double factor = 0.8;
        decimal max = 0;
        decimal min = 0;
        //Artexacta.App.FRTWB.Kpi objKpi = Artexacta.App.FRTWB.FrtwbSystem.Instance.Kpis[KpiId];
        List<KPIMeasurement> measurements = KpiMeasurementBLL.GetKpiMeasurementsByKpiOwner(ownerId, ownerType, userName, ref max, ref min);
        int count = measurements.Count;


        int divisions = Convert.ToInt32(Math.Floor(Math.Sqrt(Convert.ToDouble(count))) + 1);

        int width = Convert.ToInt32(Math.Floor(Convert.ToDecimal(imageWidth) / Convert.ToDecimal(divisions)));
        int height = Convert.ToInt32(Math.Floor(Convert.ToDecimal(imageHeight) / Convert.ToDecimal(divisions)));

        System.Drawing.Bitmap objBitmap;
        System.Drawing.Graphics objGraphics;

        objBitmap = new System.Drawing.Bitmap(imageWidth, imageHeight);
        objGraphics = System.Drawing.Graphics.FromImage(objBitmap);

        objGraphics.Clear(System.Drawing.Color.White);

        int itemNumber = 0;
        foreach (KPIMeasurement data in measurements)
        {
            int y = itemNumber / divisions;
            int x = itemNumber - (y * divisions);

            System.Drawing.Rectangle r = new System.Drawing.Rectangle(x * width, y * height, imageWidth, imageHeight);
            decimal value = Convert.ToDecimal(data.Measurement);
            objGraphics.FillRectangle(new System.Drawing.SolidBrush(GetRedYellowGreen(min, max, value)), r);

            itemNumber += 1;
        }

        System.Drawing.Bitmap resized = new System.Drawing.Bitmap(objBitmap, new System.Drawing.Size(Convert.ToInt32(Convert.ToDouble(imageWidth) / factor),
            Convert.ToInt32(Convert.ToDouble(imageHeight) / 1)));

        decimal quality = 100;
        System.Drawing.Imaging.ImageCodecInfo[] Info = System.Drawing.Imaging.ImageCodecInfo.GetImageEncoders();
        System.Drawing.Imaging.EncoderParameters Params = new System.Drawing.Imaging.EncoderParameters(1);
        Params.Param[0] = new System.Drawing.Imaging.EncoderParameter(System.Drawing.Imaging.Encoder.Quality, Convert.ToInt64(quality));

        int type = 1;

        context.Response.ContentType = Info[type].MimeType;
        //  context.Response.AddHeader("Content-Disposition", "attachment;Filename=\"KPI-" + ownerType + "-" + ownerId + "\"");
        using (System.IO.MemoryStream stream = new System.IO.MemoryStream())
        {
            resized.Save(stream, Info[type], Params);
            stream.WriteTo(context.Response.OutputStream);
        }
    }

    private System.Drawing.Color GetRedYellowGreen(decimal min, decimal max, decimal value)
    {
        decimal green_max = 220M;
        decimal red_max = 220M;
        decimal red = 0;
        decimal green = 0;
        decimal blue = 0;

        if (value < max / 2)
        {
            red = red_max;
            green = Math.Round((value / (max / 2)) * green_max);
        }
        else
        {
            green = green_max;
            red = Math.Round((1 - ((value - (max / 2)) / (max / 2))) * red_max);
        }

        return System.Drawing.Color.FromArgb(Convert.ToInt32(Math.Abs(red)), Convert.ToInt32(Math.Abs(green)), Convert.ToInt32(Math.Abs(blue)));
    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}
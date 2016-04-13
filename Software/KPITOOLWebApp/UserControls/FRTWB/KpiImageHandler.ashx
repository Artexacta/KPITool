<%@ WebHandler Language="C#" Class="KpiImageHandler" %>

using System;
using System.Web;

public class KpiImageHandler : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        const int imageHeight = 35;
        const int imageWidth = 100;

        int KpiId = Convert.ToInt32(context.Request["kpiId"]);

        Artexacta.App.FRTWB.Kpi objKpi = Artexacta.App.FRTWB.FrtwbSystem.Instance.Kpis[KpiId];
        int count = objKpi.KpiValues.Count;


        int divisions = Convert.ToInt32(Math.Floor(Math.Sqrt(Convert.ToDouble(count))) + 1);

        int width = Convert.ToInt32(Math.Floor(Convert.ToDecimal(imageWidth) / Convert.ToDecimal(divisions)));
        int height = Convert.ToInt32(Math.Floor(Convert.ToDecimal(imageHeight) / Convert.ToDecimal(divisions)));

        System.Drawing.Bitmap objBitmap;
        System.Drawing.Graphics objGraphics;

        objBitmap = new System.Drawing.Bitmap(imageWidth, imageHeight);
        objGraphics = System.Drawing.Graphics.FromImage(objBitmap);

        objGraphics.Clear(System.Drawing.Color.White);

        int itemNumber = 0;
        foreach (Artexacta.App.FRTWB.KpiData data in objKpi.KpiValues.Values)
        {
            int y = itemNumber / divisions;
            int x = itemNumber - (y * divisions);

            System.Drawing.Rectangle r = new System.Drawing.Rectangle(x * width, y * height, width, height);
            decimal value = Convert.ToDecimal(data.Value);
            objGraphics.FillRectangle(new System.Drawing.SolidBrush(GetRedYellowGreen(0, 100, value)), r);

            itemNumber += 1;
        }

        System.Drawing.Bitmap resized = new System.Drawing.Bitmap(objBitmap, new System.Drawing.Size(Convert.ToInt32(Convert.ToDouble(imageWidth)),
            Convert.ToInt32(Convert.ToDouble(imageHeight) / 1)));

        decimal quality = 100;
        System.Drawing.Imaging.ImageCodecInfo[] Info = System.Drawing.Imaging.ImageCodecInfo.GetImageEncoders();
        System.Drawing.Imaging.EncoderParameters Params = new System.Drawing.Imaging.EncoderParameters(1);
        Params.Param[0] = new System.Drawing.Imaging.EncoderParameter(System.Drawing.Imaging.Encoder.Quality, Convert.ToInt64(quality));

        int type = 1;

        context.Response.ContentType = Info[type].MimeType;
        context.Response.AddHeader("Content-Disposition", "attachment;Filename=\"kpi-" + KpiId + "\"");
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

        return System.Drawing.Color.FromArgb(Convert.ToInt32(red), Convert.ToInt32(green), Convert.ToInt32(blue));
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}
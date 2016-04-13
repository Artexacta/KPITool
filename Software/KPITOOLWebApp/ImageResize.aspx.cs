using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Drawing;
using System.Drawing.Imaging;
using log4net;
using System.Net;
using System.Drawing.Drawing2D;
using System.IO;
using Artexacta.App.Documents.BLL;
using Artexacta.App.Documents;
using Artexacta.App.Utilities;

public partial class ImageResize : System.Web.UI.Page
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

    protected void Page_Load(object sender, EventArgs e)
    {
        string ImageR = Request.QueryString["ID"];
        string widthR = Request.QueryString["W"];
        string heightR = Request.QueryString["H"];
        string imageName = "";
        int width = 0;
        int height = 0;
        int Image = 0;

        if (string.IsNullOrEmpty(ImageR) || string.IsNullOrEmpty(widthR) || string.IsNullOrEmpty(heightR))
            return;

        try
        {
            width = Convert.ToInt32(widthR);
            height = Convert.ToInt32(heightR);
            Image = Convert.ToInt32(ImageR);
        }
        catch (Exception exc)
        {
            log.Error("Ocurrió un error al obtener los datos enviados para el ResizeImage. " + exc);
        }

        if (width == 0 || height == 0)
            return;

        int widthWM = (int)(width / 3);
        int heightWM = (int)(height / 3);

        Bitmap bmp = null;

        if (string.IsNullOrEmpty(ImageR))
        {
            System.Drawing.Image imgDefault = System.Drawing.Image.FromFile(Server.MapPath("~/Images/Home.png"));
            imageName = "Magri_Turismo";
            bmp = new Bitmap(imgDefault);
        }
        else
        {
            DocumentFile theOfferImage = DocumentFileBLL.GetDocumentFile(Image);

            if (theOfferImage == null)
                return;

            string pathImage = theOfferImage.FileStoragePath;
            FileInfo fileImage = new FileInfo(pathImage);

            if (fileImage.Exists)
            {
                imageName = theOfferImage.Name + theOfferImage.Extension;
                System.Drawing.Image img = System.Drawing.Image.FromFile(pathImage);
                if (img != null)
                    bmp = ImageUtilities.CreateThumbnail(img, width, height);
            }
        }

        if (bmp == null)
            return;

        //Bitmap bmpImage = ImageUtilities.CreateThumbnail(bmp, width, height);

        //if (bmpImage == null)
        //    return;

        decimal quality = Math.Max(0, Math.Min(100, ImageUtilities.getQuality(width, height)));
        ImageCodecInfo[] Info = ImageCodecInfo.GetImageEncoders();
        EncoderParameters Params = new EncoderParameters(1);
        Params.Param[0] = new EncoderParameter(Encoder.Quality, Convert.ToInt64(quality));

        int type = 1;
        if (ImageR.Equals("1"))
            type = 4;

        Response.ContentType = Info[type].MimeType;
        Response.AddHeader("Content-Disposition", "attachment;Filename=\"" + imageName + "\"");
        using (MemoryStream stream = new MemoryStream())
        {
            bmp.Save(stream, Info[type], Params);
            stream.WriteTo(Response.OutputStream);
        }

    }

    //private Bitmap CreateWaterMark(Bitmap bmp, System.Drawing.Image imgWaterMark, int widthOrig, int heightOrig)
    //{
    //    Bitmap bmpWatermark = new Bitmap(bmp);
    //    bmpWatermark.SetResolution(bmp.HorizontalResolution, bmp.VerticalResolution);

    //    Graphics grWatermark = Graphics.FromImage(bmpWatermark);

    //    ImageAttributes imgAttributes = new ImageAttributes();
    //    ColorMap colorMap = new ColorMap();

    //    colorMap.OldColor = Color.FromArgb(255, 0, 255, 0);
    //    colorMap.NewColor = Color.FromArgb(0, 0, 0, 0);
    //    ColorMap[] remapTable = { colorMap };
    //    imgAttributes.SetRemapTable(remapTable, ColorAdjustType.Bitmap);

    //    string colorWaterMark = ConfigurationManager.AppSettings["colorWaterMark"];
    //    if (colorWaterMark == null) colorWaterMark = "0.3";
    //    System.Globalization.NumberStyles style = System.Globalization.NumberStyles.Number |
    //        System.Globalization.NumberStyles.AllowCurrencySymbol;
    //    System.Globalization.CultureInfo culture = System.Globalization.CultureInfo.CreateSpecificCulture("en-US");
    //    float val = 0.0F;
    //    float.TryParse(colorWaterMark, style, culture, out val);

    //    ColorMatrix wmColorMatrix = new ColorMatrix();
    //    wmColorMatrix.Matrix33 = val;
    //    imgAttributes.SetColorMatrix(wmColorMatrix, ColorMatrixFlag.Default, ColorAdjustType.Bitmap);

    //    int x = (bmp.Width - imgWaterMark.Width - 15);
    //    int y = (bmp.Height - imgWaterMark.Height);
    //    grWatermark.DrawImage(imgWaterMark,
    //        new Rectangle(x, y, imgWaterMark.Width, imgWaterMark.Height),
    //        0,
    //        0,
    //        imgWaterMark.Width,
    //        imgWaterMark.Height,
    //        GraphicsUnit.Pixel,
    //        imgAttributes);

    //    grWatermark.Dispose();

    //    return bmpWatermark;
    //}
}
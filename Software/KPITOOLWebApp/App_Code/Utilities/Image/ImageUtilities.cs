using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.Linq;
using System.Web;
using log4net;

namespace Artexacta.App.Utilities
{
    /// <summary>
    /// Summary description for ImageUtilities
    /// </summary>
    public class ImageUtilities
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        public ImageUtilities()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        public static Bitmap CreateThumbnail(System.Drawing.Image img, int lnWidth, int lnHeight)
        {
            Bitmap bmpOut = null;

            try
            {
                /// create a bitmap from the Image
                Bitmap loBMP = new Bitmap(img);

                decimal lnRatio;
                int lnNewWidth = 0;
                int lnNewHeight = 0;

                //*** If the image is smaller than a thumbnail just return it
                if (loBMP.Width < lnWidth && loBMP.Height < lnHeight)
                    return loBMP;

                if (loBMP.Width > loBMP.Height)
                {
                    lnRatio = (decimal)lnWidth / loBMP.Width;
                    lnNewWidth = lnWidth;
                    decimal lnTemp = loBMP.Height * lnRatio;
                    lnNewHeight = (int)lnTemp;
                }
                else
                {
                    lnRatio = (decimal)lnHeight / loBMP.Height;
                    lnNewHeight = lnHeight;
                    decimal lnTemp = loBMP.Width * lnRatio;
                    lnNewWidth = (int)lnTemp;
                }

                bmpOut = new Bitmap(lnNewWidth, lnNewHeight, PixelFormat.Format32bppArgb);
                bmpOut.SetResolution(loBMP.HorizontalResolution, loBMP.VerticalResolution);

                Graphics g = Graphics.FromImage(bmpOut);
                g.Clear(Color.Transparent);
                g.CompositingQuality = CompositingQuality.HighQuality;
                g.SmoothingMode = SmoothingMode.HighQuality;
                g.PixelOffsetMode = PixelOffsetMode.HighQuality;
                g.InterpolationMode = InterpolationMode.HighQualityBicubic;

                g.FillRectangle(Brushes.Transparent, 0, 0, lnNewWidth, lnNewHeight);
                g.DrawImage(loBMP, 0, 0, lnNewWidth, lnNewHeight);

                g.Dispose();
                loBMP.Dispose();
            }
            catch (Exception exc)
            {
                log.Error("Se produjo un error al obtener la informacion de ImagenOferta para el ResizeImage.", exc);
                return null;
            }

            return bmpOut;
        }

        public static decimal getQuality(int width, int height)
        {
            decimal resquality = 55;

            if (width <= 200 || height <= 200)
            {
                resquality = 95;
            }
            else if (width > 200 && width < 600)
            {
                resquality = 75;
            }

            return resquality;
        }
    }
}
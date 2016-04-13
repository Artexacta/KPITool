using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.IO;
using System.Drawing;

namespace Artexacta.App.Documents
{
    /// <summary>
    /// An image file that is generic
    /// </summary>
    public class ImageDocumentFile : DocumentFile
    {
        public ImageDocumentFile(int fileID, int documentID, int version, DateTime dateUploaded,
            long fileSize, string fileName, string fileExtension, string title, string storagePath)
            : base(fileID, documentID, version,
            dateUploaded, fileSize, fileName, fileExtension, title, storagePath)
        {
        }

        public override string[] ExtractCreationDateCandidatesFromFile()
        {
            return null;
        }

        public override string[] ExtractKeyWordCandidatesFromFile()
        {
            return null;
        }

        public override string[] ExtractAuthorCandidatesFromFile()
        {
            return null;
        }

        /// <summary>
        /// Get a thumbnail of the document, if possible
        /// </summary>
        /// <param name="sizeX">The maximum X size of the thumbnail</param>
        /// <param name="sizeY">The maximum y size of the thumbnail</param>
        /// <param name="forceFullSize">True if the thumbnail should be exatly XxY pixels and False if the thumbnail 
        /// should fit inside a XxY box but should maintain its aspect ratio</param>
        /// <returns>A PNG byte thumbnail or null if the thumbnail can´t be generated</returns>
        public override byte[] GetThumbnail(int sizeX, int sizeY, bool forceFullSize)
        {
            if (Bytes == null)
                return null;

            // create an image object, using the bytes from the image
            System.Drawing.Image image = System.Drawing.Image.FromStream(new MemoryStream(Bytes));

            System.Drawing.Image thumbnailImage = null;
            if (forceFullSize)
            {
                // create the actual thumbnail image
                thumbnailImage = image.GetThumbnailImage(sizeX, sizeY,
                    new System.Drawing.Image.GetThumbnailImageAbort(ThumbnailCallback), IntPtr.Zero);
            }
            else
            {
                Size newSize = ScaleSize(new Size(image.Width, image.Height), sizeX, sizeY);
                // create the actual thumbnail image
                thumbnailImage = image.GetThumbnailImage(newSize.Width, newSize.Height,
                    new System.Drawing.Image.GetThumbnailImageAbort(ThumbnailCallback), IntPtr.Zero);
            }

            // make a memory stream to work with the image bytes
            MemoryStream imageStream = new MemoryStream();

            // put the image into the memory stream
            thumbnailImage.Save(imageStream, System.Drawing.Imaging.ImageFormat.Png);

            // make byte array the same size as the image
            byte[] imageContent = new Byte[imageStream.Length];

            // rewind the memory stream
            imageStream.Position = 0;

            // load the byte array with the image
            imageStream.Read(imageContent, 0, (int)imageStream.Length);

            return imageContent;
        }

        /// <summary>
        /// Required, but not used
        /// </summary>
        /// <returns>true</returns>
        public bool ThumbnailCallback()
        {
            return true;
        }

        public string ImageUrl
        {
            get 
            {
                return "~/ImageViewer.aspx?imageId=" + this._fileID.ToString();
            }
        }
        private static Size ScaleSize(Size from, int maxWidth, int maxHeight)
        {

            double widthScale = 0.0;
            double heightScale = 0.0;

            widthScale = maxWidth / (double)from.Width;
            heightScale = maxHeight / (double)from.Height;

            double scale = Math.Min((double)(widthScale),(double)(heightScale));

            return new Size((int)Math.Floor(from.Width * scale), (int)Math.Ceiling(from.Height * scale));
        }
    }
}
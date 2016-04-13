using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using org.pdfbox.pdmodel;
using org.pdfbox.util;
using log4net;
using javax.imageio;

namespace Artexacta.App.Documents
{
    /// <summary>
    /// A PDF Document File
    /// </summary>
    public class PDFDocumentFile : DocumentFile
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        public PDFDocumentFile(int fileID, int documentID, int version, DateTime dateUploaded,
            long fileSize, string fileName, string fileExtension, string title, string storagePath)
            : base(fileID, documentID, version,
                dateUploaded, fileSize, fileName, fileExtension, title, storagePath)
        {
        }

        public override string[] ExtractCreationDateCandidatesFromFile()
        {
            string text = null;

            // If we have no bytes then we can't do anything.
            if (Bytes == null || Bytes.Length == 0)
            {
                // Log the problem.
                log.Error("Tried to extract creation date from empty bytes for file " + Name);
                return null;
            }

            try
            {
                java.io.ByteArrayInputStream byteStream = new java.io.ByteArrayInputStream(Bytes);
                PDDocument doc = PDDocument.load(byteStream);

                // TODO  Internationalize this conversion
                text = doc.getDocumentInformation().getCreationDate().getTime().toString();
            }
            catch (Exception e)
            {
                log.Warn("Failed to get the creation time from the PDF file " + Name, e);
            }

            string[] returnText = null;

            if (!string.IsNullOrEmpty(text))
            {
                returnText = new string[1];
                returnText[0] = text;
            }

            return returnText;
        }

        public override string[] ExtractKeyWordCandidatesFromFile()
        {
            string text = null;

            // If we have no bytes then we can't do anything.
            if (Bytes == null || Bytes.Length == 0)
            {
                // Log the problem.
                log.Error("Tried to extract creation date from empty bytes for file " + Name);
                return null;
            }

            try
            {
                java.io.ByteArrayInputStream byteStream = new java.io.ByteArrayInputStream(Bytes);
                PDDocument doc = PDDocument.load(byteStream);

                // TODO Internationalize this conversion
                text = doc.getDocumentInformation().getKeywords();
            }
            catch (Exception e)
            {
                log.Warn("Failed to get the keywords from the PDF file " + Name, e);
            }

            string[] returnText = null;

            if (!string.IsNullOrEmpty(text))
            {
                returnText = text.Split(new char[] { ',', ';' });
            }

            return returnText;
        }

        public override string[] ExtractAuthorCandidatesFromFile()
        {
            string text = null;

            // If we have no bytes then we can't do anything.
            if (Bytes == null || Bytes.Length == 0)
            {
                // Log the problem.
                log.Error("Tried to extract creation date from empty bytes for file " + Name);
                return null;
            }

            try
            {
                java.io.ByteArrayInputStream byteStream = new java.io.ByteArrayInputStream(Bytes);
                PDDocument doc = PDDocument.load(byteStream);

                // TODO Internationalize this conversion
                text = doc.getDocumentInformation().getAuthor();
            }
            catch (Exception e)
            {
                log.Warn("Failed to get the author from the PDF file " + Name, e);
            }

            string[] returnText = null;

            if (!string.IsNullOrEmpty(text))
            {
                returnText = new string[1];
                returnText[0] = text;
            }

            return returnText;
        }

        /// <summary>
        /// Get text from the binary using PDFBox
        /// </summary>
        /// <returns>The text of the binary or null if we could not process the text</returns>
        public override string GetTextFromDocumentBinary()
        {
            string text = null;

            // If we have no bytes then we can't do anything.
            if (Bytes == null || Bytes.Length == 0)
            {
                // Log the problem.
                log.Error("Tried to extract text from empty bytes for file " + Name);
                return null;
            }

            try
            {
                java.io.ByteArrayInputStream byteStream = new java.io.ByteArrayInputStream(Bytes);
                PDDocument doc = PDDocument.load(byteStream);
                PDFTextStripper stripper = new PDFTextStripper();
                text = stripper.getText(doc);
            }
            catch (Exception e)
            {
                log.Error("Failed to get the text from the PDF file " + Name, e);
            }

            return text;
        }

        /// <summary>
        /// Get a thumbnail of the document, if possible
        /// </summary>
        /// <param name="sizeX">The maximum X size of the thumbnail</param>
        /// <param name="sizeY">The maximum y size of the thumbnail</param>
        /// <param name="forceFullSize">True if the thumbnail should be exatly XxY pixels and False if the thumbnail 
        /// should fit inside a XxY box but should maintain its aspect ratio</param>
        /// <returns>A JPEG byte thumbnail or null if the thumbnail can´t be generated</returns>
        public override byte[] GetThumbnail(int sizeX, int sizeY, bool forceFullSize)
        {
            // If we have no bytes then we can't do anything.
            if (Bytes == null || Bytes.Length == 0)
            {
                return null;
            }

            try
            {
                 org.pdfbox.pdfviewer.PageDrawer pagedrawer = new
                    org.pdfbox.pdfviewer.PageDrawer();

                java.io.ByteArrayInputStream byteStream = new java.io.ByteArrayInputStream(Bytes);
                PDDocument doc = PDDocument.load(byteStream);
                int count = doc.getNumberOfPages();
                java.util.List pages = doc.getDocumentCatalog().getAllPages();
                if (pages.size() > 0)
                {
                    PDPage page = pagedrawer.getPage();
                    java.awt.image.BufferedImage image=page.convertToImage();
                    java.io.ByteArrayOutputStream os = new java.io.ByteArrayOutputStream();
                    ImageIO.write(image, "jpg", os);
                    byte[] data = os.toByteArray();
                    return data;
                }
            }
            catch (Exception e)
            {
                log.Error("Failed to get the thumbnail from the PDF file " + Name, e);
            }

            return null;
        }
    }
}
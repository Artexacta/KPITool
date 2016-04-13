using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

namespace Artexacta.App.Documents
{
    /// <summary>
    /// A generic file of which we know nothing about
    /// </summary>
    public class GenericDocumentFile : DocumentFile
    {
        public GenericDocumentFile(int fileID, int documentID, int version, DateTime dateUploaded,
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
        /// <returns>A JPEG byte thumbnail or null if the thumbnail can´t be generated</returns>
        public override byte[] GetThumbnail(int sizeX, int sizeY, bool forceFullSize)
        {
            return null;
        }
    }
}
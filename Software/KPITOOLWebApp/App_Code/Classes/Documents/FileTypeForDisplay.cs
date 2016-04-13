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
    /// A file type used for display
    /// </summary>
    public class FileTypeForDisplay
    {
        private string description;
        private string extension;

        public string Description
        {
            get { return description; }
            set { description = value; }
        }

        public string Extension
        {
            get { return extension; }
            set { extension = value; }
        }

        public FileTypeForDisplay(string description, string extension)
        {
            this.description = description;
            this.extension = extension;
        }
    }
}
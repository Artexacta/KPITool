using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;


namespace Artexacta.App
{
    /// <summary>
    /// This is where we add global constants for the application
    /// </summary>
    public class Constants
    {
        public const string PROVIDER_RAW = "RAW";
        public const string PROVIDER_IFILTER = "IFILTER";
        public const string PROVIDER_PDFBOX = "PDFBOX";
        public const string PROVIDER_HTML = "HTML";
        public const string PROVIDER_GENERICIMAGE = "INTERNALIMAGE";

        public const string THREAD_NAME = "AEAPPTHREAD";

        public Constants()
        {
        }
    }
}
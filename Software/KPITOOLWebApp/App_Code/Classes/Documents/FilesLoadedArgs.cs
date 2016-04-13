using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.Documents.FileUpload
{
    /// <summary>
    /// This is the class for the resulting arguments of a 
    /// FileLoaded event for the FileUpload user control
    /// </summary>
    public class FilesLoadedArgs : EventArgs
    {
        private List<FileLoaded> _theFilesLoaded;

        public List<FileLoaded> FilesLoaded
        {
            get { return _theFilesLoaded; }
            set { _theFilesLoaded = value; }
        }

        public Exception Exception { get; set; }

        public FilesLoadedArgs()
        {
        }

        /// <summary>
        /// Create a new files loaded argument
        /// </summary>
        public FilesLoadedArgs(List<FileLoaded> theFilesLoaded)
        {
            _theFilesLoaded = theFilesLoaded;
        }
    }
}
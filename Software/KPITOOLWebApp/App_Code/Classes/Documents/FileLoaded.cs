using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.Documents.FileUpload
{
    /// <summary>
    /// A file uploaded in the FileUpload User Control
    /// </summary>
    public class FileLoaded
    {
        private int _id;
        private string _name;
        private string _extension;
        private string _storagePath;

        public int ID
        {
            get { return _id; }
            set { _id = value; }
        }

        public string Name
        {
            get { return _name; }
            set { _name = value; }
        }

        public string Extension
        {
            get { return _extension; }
            set { _extension = value; }
        }

        public string StoragePath
        {
            get { return _storagePath; }
            set { _storagePath = value; }
        }
        public FileLoaded()
        {
        }

        public FileLoaded(int id, string name, string extension, string storagePath)
        {
            _id = id;
            _name = name;
            _extension = extension;
            _storagePath = storagePath;
        }
    }
}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.ContextHelp
{
    /// <summary>
    /// Represents a File Object for manipule the Help Files for the ContextHelp
    /// </summary>
    [Serializable]
    public class File
    {
        #region Enums
        public enum eType
        {
            File,
            Field,
            Undefined
        }
        #endregion
        #region Fields
        // Nombre de la página. (Solo cuando el tipo de archivo es Página) Ej. Profile
        private string fileName;
        // Nombre de la página. (Solo cuando el tipo de archivo es Campo) Ej. CompanyName
        private string fieldName;
        // Tipo de archivo. [File|Field]
        private eType type;
        // Idioma del archivo. Ej. es-ES, en-US
        private List<string> asociatedlanguages;
        // Lista general de idiomas
        private string[] listOflanguages;
        #endregion
        #region Properties
        public string FileName
        {
            get { return fileName; }
            set { fileName = value; }
        }
        public string FieldName
        {
            get { return fieldName; }
            set { fieldName = value; }
        }
        public eType Type
        {
            get { return type; }
            set { type = value; }
        }
        public List<string> Asociatedlanguages
        {
            get { return asociatedlanguages; }
            set { asociatedlanguages = value; }
        }
        public string[] ListOflanguages
        {
            get { return listOflanguages; }
            set { listOflanguages = value; }
        }
        #endregion
        #region Methods
        /// <summary>
        /// Constructor
        /// </summary>
        public File()
        {
            asociatedlanguages = new List<string>();
        }
        #endregion
    }
}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.Language
{
    /// <summary>
    /// Summary description for Language
    /// </summary>
    public class Language
    {
        //Variables
        private string _languageId;
        private string _languageName;

        public Language()
        {
        }

        public Language(string languageId, string language)
        {
            this._languageId = languageId;
            this._languageName = language;
        }

        public string LanguageId
        {
            get { return this._languageId; }
            set { this._languageId = value; }
        }

        public string LanguageName
        {
            get { return this._languageName; }
            set { this._languageName = value; }
        }
    }
}
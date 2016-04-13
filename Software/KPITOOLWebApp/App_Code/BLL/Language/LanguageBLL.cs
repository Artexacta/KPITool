using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.Language.BLL
{
    /// <summary>
    /// Summary description for LanguageBLL
    /// </summary>
    [System.ComponentModel.DataObject]
    public class LanguageBLL
    {
        LanguageDSTableAdapters.LanguageTableAdapter _theAdapter = null;
        
        public LanguageBLL()
        {
        }

        protected LanguageDSTableAdapters.LanguageTableAdapter theAdapter
        {
            get
            {
                if (_theAdapter == null)
                    _theAdapter = new LanguageDSTableAdapters.LanguageTableAdapter();

                return _theAdapter;
            }
        }

        private static Language FillRecord(LanguageDS.LanguageRow row)
        {
            Language theNewRecord = new Language(row.languageId, row.languageName);
            return theNewRecord;
        }

        public List<Language> GetLanguageList()
        {
            List<Language> theList = new List<Language>();
            Language theLanguage = null;

            try
            {
                LanguageDS.LanguageDataTable table = theAdapter.GetLanguageList();
                if (table != null && table.Rows.Count > 0)
                {
                    foreach (LanguageDS.LanguageRow row in table)
                    {
                        theLanguage = FillRecord(row);
                        theList.Add(theLanguage);
                    }
                }

            }
            catch (Exception q)
            {
                throw q;
            }

            return theList;
        }

		public string GetLanguageName(string languageId) {
            string languageName = null;

            try
            {
                string languageID = Artexacta.App.Utilities.LanguageUtilities.GetLanguageFromContext();

                languageName = theAdapter.GetLanguageNameById(languageId, languageID).ToString();
            }
            catch (Exception q)
            {
                throw q;
            }

            return languageName;
		}
    }
}
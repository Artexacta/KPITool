using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.WBT
{
    /// <summary>
    /// Summary description for ImportTestBLL
    /// </summary>
    public class ImportTestBLL
    {
        public ImportTestBLL()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        public static void ImportDataFromEndevSurveys(int generalSruveyId, int testsSurveyId, string testNumber)
        {
            string language = Artexacta.App.Utilities.LanguageUtilities.GetLanguageFromContext();

            ImportTestDSTableAdapters.WBTImportTableAdapter theAdapter = new ImportTestDSTableAdapters.WBTImportTableAdapter();
            theAdapter.ImportDataFromEndevSurveys(generalSruveyId, testsSurveyId, language, testNumber);
        }
    }
}
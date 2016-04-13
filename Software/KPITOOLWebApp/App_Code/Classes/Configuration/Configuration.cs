using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using log4net;
using System.Configuration;
using System.Collections;

namespace Artexacta.App.Configuration
{
    /// <summary>
    /// Summary description for Configuration
    /// </summary>
    public class Configuration
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        public Configuration()
        {
        }

        public static string GetDocumentStorageDirectory()
        {
            return ConfigurationManager.AppSettings.Get("DocumentStorageDirectory");
        }

        public static string GetTempDirectory()
        {
            return ConfigurationManager.AppSettings.Get("TempDirectory");
        }

        /// <summary>
        /// Get a list of file extensions that are forbidden for upload
        /// </summary>
        /// <returns>The list of extensions or null if there are none</returns>
        public static string[] GetListOfForbiddenFileExtensions()
        {
            return GetListOfExtensionsForParameter("FileLimitExtensionList");
        }

        /// <summary>
        /// Get a list of file extensions that are allowed for upload
        /// </summary>
        /// <returns>The list of extensions or null if there are none</returns>
        public static string[] GetListOfAllowedFileExtensions()
        {
            return GetListOfExtensionsForParameter("FileAllowExtensionList");
        }
        private static string[] GetListOfExtensionsForParameter(string parameter)
        {
            string extensionList = null;
            try
            {
                extensionList = ConfigurationManager.AppSettings.Get(parameter);
                if (extensionList == null || extensionList.Length == 0)
                {
                    return null;
                }

                string[] list = extensionList.Split(new char[] { ',' });
                List<string> cleanExtensionList = new List<string>();
                for (int i = 0; i < list.Length; i++)
                {
                    string extension = list[i].Trim();
                    if (!string.IsNullOrEmpty(extension) && extension.StartsWith("."))
                    {
                        cleanExtensionList.Add(extension);
                    }
                }

                if (cleanExtensionList.Count > 0)
                {
                    return cleanExtensionList.ToArray();
                }
                else
                {
                    return null;
                }

            }
            catch (Exception e)
            {
                log.Error("Cannot find a valid " + parameter + " configuration string in system configuration file", e);
                return null;
            }
        }

        public static string GetMaxDocumentsInKB()
        {
            return ConfigurationManager.AppSettings.Get("GetMaxDocumentsInKB");
        }

        /// <summary>
        /// Determines how long the system messages should be displayed to the users, in seconds.
        /// </summary>
        /// <returns>The number of seconds that a system message should be shown to the user</returns>
        public static int GetTimeToExpireSystemMessages()
        {
            int seconds = 360;  // Defaults to five minutes
            try
            {
                string configString = ConfigurationManager.AppSettings.Get("TimeToShowSystemMessages");
                if (configString == null || configString.Length == 0)
                {
                    throw new ConfigurationErrorsException(Resources.Configuration.MensajeErrorArchivoConfiguracion);
                }

                seconds = Convert.ToInt32(configString);
            }
            catch (Exception e)
            {
                log.Error(Resources.Configuration.MensajeErrorNumeroArchivoConfig, e);
            }

            return seconds;
        }

        public static string GetDBConnectionString()
        {

            // The system databse connection string should be in the system 
            // configuration file and should be called SilverTrackConnectionString

            string name = "";

            try
            {
                // Get the connectionStrings.
                ConnectionStringSettingsCollection connectionStrings =
                    ConfigurationManager.ConnectionStrings;

                // Get the collection enumerator.
                IEnumerator connectionStringsEnum = connectionStrings.GetEnumerator();

                // Loop through the collection and search for valid connectionString
                int i = 0;
                while (connectionStringsEnum.MoveNext())
                {
                    name = connectionStrings[i++].Name;
                    string value = connectionStrings[name].ToString();
                    if (name == "DBConnectionString")
                    {
                        return value;
                    }
                }
            }
            catch (Exception e)
            {
                log.Error("Failed to get the DBConnectionString connection string", e);
                throw e;
            }

            string mensaje = "";
            mensaje = "Error de conexion a:" + name;

            throw new ConfigurationErrorsException(mensaje);
        }

        public static string GetReturnEmailAddress()
        {
            string mailSetting = ConfigurationManager.AppSettings["ReturnEmailAddress"];
            if (!string.IsNullOrWhiteSpace(mailSetting))
            {
                return mailSetting;
            }
            log.Error("ReturnEmailAddress KEY is not correctly configured, check web.config");
            throw new ConfigurationErrorsException("Error getting Return Mail Address, no configuration defined");
        }

        public static string GetReturnEmailName()
        {
            return Resources.Configuration.ReturnEmailName;
        }

        public static string GetCreationEmailSubject()
        {
            return Resources.Configuration.CreationEmailSubject;
        }

        public static string GetConfirmationPasswordSubject()
        {
            return Resources.Configuration.ConfirmationPasswordSubject;
        }

        public static string GetHTMLParagraphs(string text)
        {
            if (String.IsNullOrEmpty(text))
                return text;

            text = HttpContext.Current.Server.HtmlEncode(text);

            System.Text.StringBuilder res = new System.Text.StringBuilder();
            string[] paragraphs = text.Split(new char[] { '\n' });

            for (int i = 0; i < paragraphs.Length; i++)
            {
                if (String.IsNullOrEmpty(paragraphs[i]))
                    continue;

                res.Append("<p class=\"displayParagraph\">" + paragraphs[i] + "</p>\n");
            }

            return res.ToString();
        }

        /// <summary>
        /// This timeout states in minutes the time the viewstate will remain active in the database
        /// before being automatically deleted or invalidated by the database.
        /// </summary>
        /// <returns></returns>
        public static int GetViewStateExpirationForDataBase()
        {
            return 180;
        }
        #region Task Manager
        public static string DummyPageUrl()
        {
            string configString = "Default.aspx";
            try
            {
                configString = ConfigurationManager.AppSettings.Get("DummyPageUrlForTaskManager");
                if (configString == null || configString.Length == 0)
                {
                    throw new ConfigurationErrorsException(Resources.Configuration.MensajeErrorArchivoConfiguracion);
                }
            }
            catch (Exception e)
            {
                log.Error(Resources.Configuration.MensajeErrorArchivoConfiguracion, e);
            }
            return configString;
        }
        #endregion
        #region Feedback

        public static string GetFeedbackUrl()
        {
            string feedbackBase = ConfigurationManager.AppSettings.Get("FeedbackBaseUrl");
            if (string.IsNullOrEmpty(feedbackBase))
            {
                log.Error("Feedback is not correctly configured, check web.config");
                feedbackBase = "";
            }
            return feedbackBase += "/Feedback/FeedbackEntry.aspx";
        }

        public static string GetApplicationName()
        {
            string feedbackName = ConfigurationManager.AppSettings.Get("FeedbackApplicationName");
            if (string.IsNullOrEmpty(feedbackName))
            {
                log.Error("Feedback NAME is not correctly configured, check web.config");
                feedbackName = "";
            }
            return feedbackName;
        }

        public static string GetApplicationKey()
        {
            string feedbackKey = ConfigurationManager.AppSettings.Get("FeedbackApplicationKey");
            if (string.IsNullOrEmpty(feedbackKey))
            {
                log.Error("Feedback KEY is not correctly configured, check web.config");
                feedbackKey = "";
            }
            return feedbackKey;
        }

        public static string GetAnonymousUser()
        {
            string feedbackUser = ConfigurationManager.AppSettings.Get("FeedbackAnonymousUser");
            if (string.IsNullOrEmpty(feedbackUser))
            {
                log.Error("Feedback Anonymous user is not correctly configured, check web.config");
                feedbackUser = "anonymous";
            }
            return feedbackUser;
        }

        public static string GetAnonymousEmail()
        {
            string feedbackEmail = ConfigurationManager.AppSettings.Get("FeedbackAnonymousEmail");
            if (string.IsNullOrEmpty(feedbackEmail))
            {
                log.Error("Feedback Anonymous email is not correctly configured, check web.config");
                feedbackEmail = "";
            }
            return feedbackEmail;
        }

        #endregion
        #region Bitacora
        public static int GetHusoHorario()
        {

            int hh = 0;
            try
            {
                string husoHorario = ConfigurationManager.AppSettings.Get("HusoHorario");
                hh = Convert.ToInt32(husoHorario);
                return hh;
            }
            catch (Exception q)
            {
                log.Warn("No se encuentra bien configurada la variable HusoHorario en el web.config", q);
                return 0;
            }
        }

        #endregion
    }
}
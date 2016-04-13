using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Threading;
using System.Globalization;
using log4net;
using System.Net;
using System.Configuration;

namespace Artexacta.App.Utilities
{
    /// <summary>
    /// Summary description for LanguageUtilities
    /// </summary>
    public class LanguageUtilities
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        public static string cookieName{
            get { return ConfigurationManager.AppSettings.Get("LanguageCookieName"); }
        }
        public static string defaultLanguage
        {
            get { return ConfigurationManager.AppSettings.Get("DefaultLanguage"); }
        }

        public LanguageUtilities() {}

        /// <summary>
        /// Determine the language needed from the HttpContext and set the language for the thread
        /// </summary>
        public static void SetLanguageFromContext()
        {
            string NewUICulture = "";
            string NewCulture = "";

            string languageParam = GetLanguageFromContext();

            switch (languageParam.ToUpper()) {
                case "EN":
                    NewUICulture = "en";
                    NewCulture = "en-US";
                    break;

                case "ES":
                    NewUICulture = "es";
                    NewCulture = "es-ES";
                    break;
            }

            Thread.CurrentThread.CurrentCulture = CultureInfo.CreateSpecificCulture(NewCulture);
            Thread.CurrentThread.CurrentUICulture = new CultureInfo(NewUICulture);

            log.Debug("SetLanguageFromContext ( NewCulture = " + NewCulture + ")");

            if (HttpContext.Current.Request.Cookies[cookieName] == null)
            {
                log.Debug("Creating cookie");
                // Creamos elemento HttpCookie con su nombre y su valor
                HttpCookie myCookie = new HttpCookie(cookieName, NewUICulture);
                myCookie.Expires = DateTime.Now.AddDays(360);

                // Y finalmente añadimos la cookie a nuestro usuario
                HttpContext.Current.Response.Cookies.Add(myCookie);
            }
        }

        public static string GetLanguageFromContext()
        {
            //Valor por defecto
            string language = "EN";

            // User has not specified a language explicitly.  
            // Try to see if we can REMEMBER the last language used
            if (HttpContext.Current.Request.Cookies[cookieName] != null)
            {
                HttpCookie myCookie = HttpContext.Current.Request.Cookies.Get(cookieName);
                language = myCookie.Value;
                log.Debug("Geting cookie with value = " + language);
            }
            //else if (HttpContext.Current.Request.UserLanguages != null)
            //{
            //    // Try to detect language from the Browser
            //    try
            //    {
            //        string lang = HttpContext.Current.Request.UserLanguages[0];
            //        if (lang.Substring(0, 2).ToUpper() == "ES")
            //            language = "es";
            //        else if (lang.Substring(0, 2).ToUpper() == "EN")
            //            language = "en";
            //    }
            //    catch (Exception e)
            //    {
            //        log.Error("Error getting language.", e);
            //    }
            //}

            return language;
        }

        public static void ChangeLanguageFromContext(string language)
        {
            try
            {
                if (HttpContext.Current.Request.Cookies[cookieName] == null)
                {
                    // Creamos elemento HttpCookie con su nombre y su valor
                    HttpCookie myCookie = new HttpCookie(cookieName, language);
                    myCookie.Expires = DateTime.Now.AddDays(360);

                    // Añadimos la cookie a nuestro usuario
                    HttpContext.Current.Response.Cookies.Add(myCookie);
                    log.Debug("Created cookie with value = " + language);
                }
                else
                {
                    // Para actualizar los datos de la cookie
                    HttpCookie myCookie = HttpContext.Current.Request.Cookies.Get(cookieName);
                    myCookie.Value = language;
                    myCookie.Expires = DateTime.Now.AddDays(360);
                    HttpContext.Current.Response.Cookies.Set(myCookie);
                    log.Debug("Updated cookie with value = " + language);
                }
            }
            catch (Exception e)
            {
                log.Error("Error Change Language From Context", e);
            }
        }
    }
}
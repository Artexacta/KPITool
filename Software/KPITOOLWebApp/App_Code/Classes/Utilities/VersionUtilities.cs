using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Artexacta.App.Utilities.VersionUtilities.BLL;
using log4net;

namespace Artexacta.App.Utilities.VersionUtilities
{
    /// <summary>
    /// Summary description for VersionUtilities
    /// </summary>
    public class VersionUtilities
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        public VersionUtilities()
        {
        }

        /// <summary>
        /// Verify that the application and database version numbers match.  If they don't,
        /// the user is redirected to an error page.
        /// </summary>
        public static void verifySystemVersionIntegrity()
        {
            bool pass = false;
            int appMajor = 0;
            int appMinor = 0;
            int appRelease = 0;
            int dbMajor = 0;
            int dbMinor = 0;
            int dbRelease = 0;

            string errorMessage = "";

            try
            {
                log.Debug("Getting application and database versions");

                appMajor = getApplicationMajorVersionNumber();
                appMinor = getApplicationMinorVersionNumber();
                appRelease = getApplicationReleaseNumber();

                if (log.IsDebugEnabled)
                {
                    log.Debug("Application major version = " + appMajor.ToString());
                    log.Debug("Application minor version = " + appMinor.ToString());
                    log.Debug("Application release verion = " + appRelease.ToString());
                }

                dbMajor = getDatabaseMajorVersionNumber();
                dbMinor = getDatabaseMinorVersionNumber();
                dbRelease = getDatabaseReleaseNumber();

                if (log.IsDebugEnabled)
                {
                    log.Debug("Databse major version = " + dbMajor.ToString());
                    log.Debug("Databse minor version = " + dbMinor.ToString());
                    log.Debug("Databse release verion = " + dbRelease.ToString());
                }
            }
            catch (Exception e)
            {
                // Something went wrong.  At least tell the administrators that they 
                // should fix things.
                log.Error("Failed to verify the version integrity of the application", e);
                errorMessage = e.Message;
            }

            // The system is OK if the major and minor versions are the same.  The release 
            // numbers can be different.
            if (appMajor == dbMajor && appMinor == dbMinor)
            {
                log.Debug("Application and database major and minor versions are the same");
                pass = true;
            }

            if (!pass)
            {
                if (errorMessage.Length > 0)
                {
                    log.Error("Cannot load Versioning data.  Probable database connectivity problems.");
                    HttpContext.Current.Session["ErrorMessage"] =
                        "No se pudo cargar información de versionamiento.  " +
                        "Posibles problemas de conectividad. Este error se registró y los administradores " +
                        "resolverán el tema lo antes posible.  Los detalles del error son: " +
                        HttpUtility.HtmlEncode(errorMessage);
                }
                else
                {
                    log.Error("Application and Database Versions do not match.");
                    HttpContext.Current.Session["ErrorMessage"] = "La versión de la aplicación y la base " +
                        " de datos no concuerdan. Este error se registró y los administradores resolverán " +
                        "el tema lo antes posible.";
                }
                HttpContext.Current.Response.Redirect("~/FatalError.aspx");
            }
        }

        /// <summary>
        /// Get a version number component from the ASP.NET configuration file
        /// </summary>
        /// <param name="type">The configuration name</param>
        /// <returns>The version number component</returns>
        /// <exception cref="ConfigurationErrorsException">If the version component cannot be found</exception>
        private static int getVersionNumber(string type)
        {
            VersionBLL x = new VersionBLL();
            return x.getApplicationVersionComponent(type);
        }

        /// <summary>
        /// Gets the application major version number.  This method propagates exceptions.
        /// </summary>
        /// <returns>The application major version number</returns>
        public static int getApplicationMajorVersionNumber()
        {
            return getVersionNumber("majorVersionNumber");
        }

        /// <summary>
        /// Gets the application minor version number.  This method propagates exceptions.
        /// </summary>
        /// <returns>The application minor version number</returns>
        public static int getApplicationMinorVersionNumber()
        {
            return getVersionNumber("minorVersionNumber");
        }

        /// <summary>
        /// Gets the application release version number.  This method propagates exceptions.
        /// </summary>
        /// <returns>The application release number</returns>
        public static int getApplicationReleaseNumber()
        {
            return getVersionNumber("releaseNumber");
        }

        /// <summary>
        /// Get the application version number in the format M.V.I.  
        /// This method is guaranteed not to throw an exception.
        /// </summary>
        /// <returns>The application version number in string format</returns>
        public static string getApplicationVersionstring()
        {
            try
            {
                return getApplicationMajorVersionNumber().ToString() + "." +
                    getApplicationMinorVersionNumber().ToString() + "." +
                    getApplicationReleaseNumber().ToString();
            }
            catch (Exception e)
            {
                // Log the exception
                log.Error("Failed to get application version string", e);
                return "";
            }
        }

        /// <summary>
        /// Get the database major version number.   This method propagates exceptions.
        /// </summary>
        /// <returns>Database major version number</returns>
        public static int getDatabaseMajorVersionNumber()
        {
            VersionBLL x = new VersionBLL();
            return x.getDatabaseMajorVersion();
        }

        /// <summary>
        /// Get the database minor version number.    This method propagates exceptions.
        /// </summary>
        /// <returns>Database minor version number</returns>
        public static int getDatabaseMinorVersionNumber()
        {
            VersionBLL x = new VersionBLL();
            return x.getDatabaseMinorVersion();
        }

        /// <summary>
        /// Get the database release version number.   This method propagates exceptions.
        /// </summary>
        /// <returns>Database release number</returns>
        public static int getDatabaseReleaseNumber()
        {
            VersionBLL x = new VersionBLL();
            return x.getDatabaseReleaseVersion();
        }

        /// <summary>
        /// Get the database version number in the format M.V.I.  This method is guaranteed not 
        /// to throw an exception.
        /// </summary>
        /// <returns>The database version string</returns>
        public static string getDatabaseVersionstring()
        {
            try
            {
                return getDatabaseMajorVersionNumber().ToString() + "." +
                    getDatabaseMinorVersionNumber().ToString() + "." +
                    getDatabaseReleaseNumber().ToString();
            }
            catch (Exception e)
            {
                // Log the exception
                log.Error("Failed to get database version string", e);
                return "";
            }
        }
    }
}
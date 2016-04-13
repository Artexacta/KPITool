using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.IO;
using System.Configuration;

namespace Artexacta.App.Utilities.LogUtilities
{
    /// <summary>
    /// Summary description for LogUtilities
    /// </summary>
    public class LogUtilities
    {
        public LogUtilities()
        {
        }

        public static void WriteToEventLog(string strEvent)
        {
            TextWriter tw = null;
            string logDirectory = ConfigurationManager.AppSettings.Get("LogDirectory");

            try
            {
                DirectoryInfo logDir = new DirectoryInfo(logDirectory);
                if (!logDir.Exists)
                    logDir.Create();

                tw = new StreamWriter(logDir.FullName + "\\WS_Service.log", true);
                tw.WriteLine(DateTime.Now.ToShortDateString() + " " + DateTime.Now.ToShortTimeString() + " : " + strEvent);
                tw.Close();
            }
            catch
            {
                if (tw != null)
                    tw.Close();
            }
        }
    }
}
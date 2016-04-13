using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Configuration;
using System.IO;
using log4net;

namespace Artexacta.App.DocumentUtilities
{
    /// <summary>
    /// Summary description for DocumentUtilities
    /// </summary>
    public class DocumentUtilities
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        public DocumentUtilities()
        {
        }

        public static string SelectFolderToVerify()
        {
            string mainFolder = ConfigurationManager.AppSettings.Get("DocumentStorageDirectory");
            if (string.IsNullOrWhiteSpace(mainFolder))
                return "";

            try
            {
                DirectoryInfo mainDir = new DirectoryInfo(mainFolder);
                Random theYearRandom = new Random();
                DirectoryInfo[] years = mainDir.GetDirectories();
                int yearCount = years.Length;
                string selectYear = years[theYearRandom.Next(yearCount)].ToString();

                DirectoryInfo yearDir = new DirectoryInfo(mainFolder + "\\" + selectYear);
                Random theMonthRandom = new Random();
                DirectoryInfo[] months = yearDir.GetDirectories();
                int monthCount = months.Length;
                string selectMonth = months[theMonthRandom.Next(monthCount)].ToString();

                DirectoryInfo monthDir = new DirectoryInfo(mainFolder + "\\" + selectYear + "\\" + selectMonth);
                Random theDayRandom = new Random();
                DirectoryInfo[] days = monthDir.GetDirectories();
                int dayCount = days.Length;
                string selectDay = days[theDayRandom.Next(dayCount)].ToString();

                DirectoryInfo dayDir = new DirectoryInfo(mainFolder + "\\" + selectYear + "\\" + selectMonth + "\\" + selectDay);
                Random theHourRandom = new Random();
                DirectoryInfo[] hours = dayDir.GetDirectories();
                int hourCount = hours.Length;
                string selectHour = hours[theHourRandom.Next(hourCount)].ToString();

                return mainFolder + "\\" + selectYear + "\\" + selectMonth + "\\" + selectDay + "\\" + selectHour + "\\";
            }
            catch (Exception q)
            {
                log.Error("Failed to select a folder for verification", q);
                return "";
            }
        }
    }
}
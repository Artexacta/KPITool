using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using log4net;
using UserConfigurationDSTableAdapters;
using System.Web.Configuration;
using System.Configuration;

namespace Artexacta.App.User.BLL
{
    /// <summary>
    /// Summary description for STUserConfigurationBLL
    /// </summary>
    public class UserConfigurationBLL
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");
        private static UserConfiguration theContextConfiguration = null;

        public UserConfigurationBLL()
        {
        }

        public static void SaveUserConfiguration(UserConfiguration theConfig)
        {
            UserConfigurationParametersTableAdapter ta = new UserConfigurationParametersTableAdapter();

            ta.SetUserConfigurationParameters(
               theConfig.UserId,
               theConfig.NumberSavedSearches,
               theConfig.TimesToShowToolTips);
        }

        public static UserConfiguration GetUserConfigurationData(int userId)
        {
            UserConfigurationParametersTableAdapter ta = new UserConfigurationParametersTableAdapter();

            UserConfigurationDS.UserConfigurationParametersDataTable table = ta.GetUserConfigurationData(userId);

            if (table.Count == 0)
            {
                // We failed to get configuration data from the database 
                log.Error("Failed to get user configuration data from database. Got 0 rows");
                return null;
            }

            UserConfigurationDS.UserConfigurationParametersRow row = table[0];

            UserConfiguration theConfiguration = new UserConfiguration(
                row.userId,
                row.numberSavedSearches,
                row.numberOfTimesToDisplayTooltips);

            return theConfiguration;
        }

        public static UserConfiguration GetUserConfigurationData(bool forceReload, int userId)
        {
            if (forceReload)
            {
                log.Debug("Method called with Force Reload");
            }

            if (theContextConfiguration == null || forceReload)
            {
                log.Debug("Forcing configuration reload");
                theContextConfiguration = GetUserConfigurationData(userId);
            }
            return theContextConfiguration;
        }

        public static UserConfiguration GetCurrentUserConfiguration(bool forceReload)
        {
            if (forceReload)
            {
                log.Debug("Method called with Force Reload");
            }

            if (theContextConfiguration == null || forceReload)
            {
                log.Debug("Forcing configuration reload");

                int userId = 0;

                try
                {
                    userId = UserBLL.GetUserIdByUsername(HttpContext.Current.User.Identity.Name);
                }
                catch { }

                if (userId <= 0)
                    return null;

                theContextConfiguration = GetUserConfigurationData(userId);
            }

            return theContextConfiguration;
        }
    }
}
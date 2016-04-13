using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.SavedSearch.BLL
{
    /// <summary>
    /// Summary description for SavedSearchBLL
    /// </summary>
    public class SavedSearchBLL
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        public SavedSearchBLL()
        {
        }

        private static SavedSearch FillRecord(SavedSearchDS.GetSavedSearchRow row)
        {
            SavedSearch obj = new SavedSearch(row.searchId, row.userId, row.name,
                row.searchExpression, row.dateCreated);
            return obj;
        }

        public static bool Delete(SavedSearch obj)
        {
            if (string.IsNullOrEmpty(obj.SearchId) ||
                obj.UserId <= 0 ||
                string.IsNullOrEmpty(obj.Name))
            {
                log.Error("One of the arguments was either null, empty or less than 0: " +
                    obj.SearchId + "," + obj.UserId.ToString() + "," + obj.Name);
                return false;
            }

            SavedSearchDSTableAdapters.GetSavedSearchTableAdapter adapter =
                new SavedSearchDSTableAdapters.GetSavedSearchTableAdapter();

            try
            {
                adapter.Delete(obj.SearchId, obj.UserId, obj.Name);
                return true;
            }
            catch (Exception x)
            {
                log.Error("An error was ocurred while deleting the saved search", x);
                return false;
            }
        }

        public static bool Insert(SavedSearch newSavedSearch)
        {
            if (newSavedSearch == null)
            {
                log.Error("New object cannot be null");
                return false;
            }
            if (string.IsNullOrEmpty(newSavedSearch.SearchId) ||
                newSavedSearch.UserId <= 0 ||
                string.IsNullOrEmpty(newSavedSearch.Name))
            {
                log.Error("New object's arguments were either null, empty or less than 0: " +
                    newSavedSearch.SearchId + "," + newSavedSearch.UserId.ToString() + "," + newSavedSearch.Name);
                return false;
            }

            SavedSearchDSTableAdapters.GetSavedSearchTableAdapter adapter =
                new SavedSearchDSTableAdapters.GetSavedSearchTableAdapter();

            try
            {
                adapter.Insert(newSavedSearch.SearchId,
                    newSavedSearch.UserId,
                    newSavedSearch.Name,
                    newSavedSearch.SearchExpression);
                return true;
            }
            catch (Exception x)
            {
                log.Error("An error was ocurred while inserting the saved search", x);
                return false;
            }
        }

        public static List<SavedSearch> GetSavedSearch(string searchId, int userId)
        {
            if (string.IsNullOrEmpty(searchId) ||
                userId <= 0)
            {
                log.Warn("This method must be used for a specific control and user");
                return null;
            }

            List<SavedSearch> theList = new List<SavedSearch>();

            SavedSearchDSTableAdapters.GetSavedSearchTableAdapter adapter =
                new SavedSearchDSTableAdapters.GetSavedSearchTableAdapter();

            try
            {
                SavedSearchDS.GetSavedSearchDataTable table = adapter.GetSavedSearch(searchId, userId);

                if (table != null && table.Rows.Count > 0)
                {
                    foreach (SavedSearchDS.GetSavedSearchRow row in table.Rows)
                    {
                        SavedSearch obj = FillRecord(row);
                        theList.Add(obj);
                    }
                }
            }
            catch (Exception x)
            {
                log.Error("An error was ocurred while getting the saved searches", x);
                return null;
            }
            return theList;
        }

        public static List<SavedSearch> GetSavedSearch(string searchId, int userId, string name)
        {
            List<SavedSearch> theList = new List<SavedSearch>();

            SavedSearchDSTableAdapters.GetSavedSearchTableAdapter adapter =
                new SavedSearchDSTableAdapters.GetSavedSearchTableAdapter();

            try
            {
                SavedSearchDS.GetSavedSearchDataTable table =
                    adapter.GetSavedSearchBySearchName(searchId, userId, name);

                if (table != null && table.Rows.Count == 1)
                {
                    SavedSearch obj = FillRecord(table[0]);
                    theList.Add(obj);
                }
                else
                {
                    log.Error("No record found with arguments: " +
                        searchId + "," + userId.ToString() + "," + name);
                }
            }
            catch (Exception x)
            {
                log.Error("An error was ocurred while getting the saved searches", x);
                return null;
            }
            return theList;
        }

    }
}
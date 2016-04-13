using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using log4net;
using Artexacta.App.ViewStateSql;
using Artexacta.App.Configuration;

namespace Artexacta.App.ViewStateSql.BLL
{
    /// <summary>
    /// Summary description for ViewStateSqlBLL
    /// </summary>
    public class ViewStateSqlBLL
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        public ViewStateSqlBLL()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        public static bool Insert(ViewStateSql newViewStateSql)
        {
            if (newViewStateSql == null)
            {
                log.Error("New object cannot be null");
                return false;
            }
            if (newViewStateSql.ViewStateId == null ||
                newViewStateSql.Value == null)
            {
                log.Error("New object's arguments were either null, empty or less than 0: ");
                return false;
            }

            ViewStateSqlDSTableAdapters.ViewStateSqlTableAdapter adapter =
                new ViewStateSqlDSTableAdapters.ViewStateSqlTableAdapter();

            try
            {
                adapter.Insert(newViewStateSql.ViewStateId, newViewStateSql.Value, newViewStateSql.Timeout);
                return true;
            }
            catch (Exception x)
            {
                log.Error("An error was ocurred while inserting the saved search", x);
                return false;
            }
        }

        public static ViewStateSql GetViewStateSql(Guid viewStateId)
        {
            if (viewStateId == null)
            {
                log.Error("This method must be used for a specific control and user");
                return null;
            }
            ViewStateSqlDSTableAdapters.ViewStateSqlTableAdapter adapter =
                new ViewStateSqlDSTableAdapters.ViewStateSqlTableAdapter();

            ViewStateSql obj = null;
            try
            {
                ViewStateSqlDS.ViewStateSqlDataTable table = adapter.GetViewStateByGuid(viewStateId);

                if (table != null && table.Rows.Count > 0)
                {
                    obj = FillRecord(viewStateId, table[0].Value);
                }
            }
            catch (Exception x)
            {
                log.Error("An error was ocurred while getting the saved searches", x);
                return null;
            }
            return obj;
        }

        private static ViewStateSql FillRecord(Guid theId, byte[] theValue)
        {
            ViewStateSql obj = new ViewStateSql(theId, theValue, Artexacta.App.Configuration.Configuration.GetViewStateExpirationForDataBase());
            return obj;
        }

        /// <summary>
        /// Calls the expire viewstate method, it does NOT handle errors so you should handle when calling this method
        /// </summary>
        public static void ExpireViewState()
        {
            ViewStateSqlDSTableAdapters.ViewStateSqlTableAdapter adapter =
                new ViewStateSqlDSTableAdapters.ViewStateSqlTableAdapter();

            adapter.ExpireViewState();
        }
    }
}
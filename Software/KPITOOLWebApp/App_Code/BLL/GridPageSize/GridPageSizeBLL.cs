using System;
using System.Collections.Generic;
using System.Web;
using log4net;
using GridPageSizeDSTableAdapters;

namespace Artexacta.App.GridPageSize.BLL
{
    /// <summary>
    /// Summary description for GridPageSizeBLL
    /// </summary>
    public class GridPageSizeBLL
    {

        private GPS_GetGridPageSizeTableAdapter _myAdapter = null;
        private static readonly ILog log = LogManager.GetLogger("Standard");

        private GPS_GetGridPageSizeTableAdapter GridPageSizeAdapter
        {
            get
            {
                if (_myAdapter == null)
                {
                    _myAdapter = new GPS_GetGridPageSizeTableAdapter();
                }
                return _myAdapter;
            }
        }

        public GridPageSizeBLL()
        {
        }

        /// <summary>
        /// Get the actual grid page size fro a given GridView and given employee
        /// </summary>
        /// <param name="GridID">The GridView name</param>
        /// <param name="UserID">The actual user name</param>
        /// <returns>The Grid page size</returns>
        public GridPageSize GetGridPageSizeState(string GridID, string UserID)
        {
            GridPageSizeDS.GPS_GetGridPageSizeDataTable table =
                GridPageSizeAdapter.GetGridPageSize(GridID, UserID);
            if (table.Rows.Count > 0)
            {
                GridPageSize theGridPageSize = new GridPageSize(table[0].gridId,
                    table[0].userId, table[0].pagesize);
                return theGridPageSize;
            }
            else
            {
                return null;
            }
        }

        /// <summary>
        /// Save the grid page size for a given GridView and User
        /// </summary>
        /// <param name="GridID">The grid view name</param>
        /// <param name="UserID">The user name</param>
        /// <param name="PageSize">The page size</param>
        public void SaveGridPageSizeState(string GridID, string UserID, int PageSize)
        {
            GridPageSizeAdapter.Insert(GridID, UserID, PageSize);
        }
    }
}

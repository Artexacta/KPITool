using System;
using System.Collections.Generic;
using System.Web;
using log4net;
using GridColumnDSTableAdapters;
using Artexacta.App.GridColumn;

namespace Artexacta.App.GridColumn.BLL
{
    /// <summary>
    /// Summary description for GridColumnBLL
    /// </summary>
    public class GridColumnBLL
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        private GRICOL_GetColumnsTableAdapter _Adapter = null;

        private GRICOL_GetColumnsTableAdapter Adapter
        {
            get
            {
                if (_Adapter == null)
                {
                    _Adapter = new GRICOL_GetColumnsTableAdapter();
                }
                return _Adapter;
            }
        }

        public GridColumnBLL()
        {
        }

        private SelectionGridColumn FillRecord(GridColumnDS.GRICOL_GetColumnsRow row)
        {
            SelectionGridColumn theNewRecord = new SelectionGridColumn(
                row.gridId,
                row.userId,
                row.column,
                row.visible);

            return theNewRecord;
        }

        public List<SelectionGridColumn> GetColumnsByGridByUser(string gridId, int userId)
        {
            if (string.IsNullOrEmpty(gridId))
                throw new ArgumentException("The grid Id cannot be null or empty.");

            if (userId <= 0)
                throw new ArgumentException("The user Id cannot be null or empty.");

            List<SelectionGridColumn> theList = new List<SelectionGridColumn>();

            try
            {
                GridColumnDS.GRICOL_GetColumnsDataTable table = Adapter.GetColumnsByGridByUser(userId, gridId);
                if (table != null && table.Rows.Count > 0)
                {
                    foreach (GridColumnDS.GRICOL_GetColumnsRow row in table.Rows)
                    {
                        SelectionGridColumn theColumn = FillRecord(row);
                        theList.Add(theColumn);
                    }
                }
            }
            catch (Exception q)
            {
                log.Error("An error ocurred getting columns by grid", q);
                throw q;
            }

            return theList;
        }

        public bool InsertColumns(List<SelectionGridColumn> thelist)
        {
            try
            {
                if (thelist != null && thelist.Count > 0)
                {
                    foreach (SelectionGridColumn theColumn in thelist)
                    {
                        InsertUpdateColumn(theColumn.GridId, theColumn.UserId,
                            theColumn.Column, theColumn.Visible);
                    }
                }
                return true;
            }
            catch (Exception q)
            {
                log.Error("An error was ocurred inserting column grid");
                throw q;
            }
        }

        public void InsertUpdateColumn(string gridID, int userID, string column, bool visible)
        {
            try
            {
                Adapter.Insert(gridID, userID, column, visible);
            }
            catch (Exception q)
            {
                log.Error("An error was ocurred updating column grid");
                throw q;
            }
        }
    }
}
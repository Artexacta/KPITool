using System;
using System.Collections.Generic;
using System.Web;

namespace Artexacta.App.GridColumn
{
    /// <summary>
    /// Summary description for GridColumn
    /// </summary>
    public class SelectionGridColumn
    {
        private string _gridId;
        private int _userId;
        private string _column;
        private bool _visible;

        public SelectionGridColumn()
        {
        }

        public SelectionGridColumn(string gridId, int userId, string column, bool visible)
        {
            this._gridId = gridId;
            this._userId = userId;
            this._column = column;
            this._visible = visible;
        }

        public string GridId
        {
            get { return this._gridId; }
            set { this._gridId = value; }
        }
        public int UserId
        {
            get { return this._userId; }
            set { this._userId = value; }
        }
        public string Column
        {
            get { return this._column; }
            set { this._column = value; }
        }
        public bool Visible
        {
            get { return this._visible; }
            set { this._visible = value; }
        }
    }
}
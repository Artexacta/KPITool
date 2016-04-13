using System;
using System.Collections.Generic;
using System.Web;

namespace Artexacta.App.GridPageSize
{
    /// <summary>
    /// Summary description for GridPageSize
    /// </summary>
    [Serializable]
    public class GridPageSize
    {
        private string _gridId;
        private string _userId;
        private int _pageSize;

        public GridPageSize()
        {
        }

        public GridPageSize(string gridId, string userId, int pageSize)
        {
            this._gridId = gridId;
            this._userId = userId;
            this._pageSize = pageSize;
        }

        public string GridId
        {
            get { return this._gridId; }
            set { this._gridId = value; }
        }

        public string UserId
        {
            get { return this._userId; }
            set { this._userId = value; }
        }

        public int PageSize
        {
            get { return this._pageSize; }
            set { this._pageSize = value; }
        }
    }
}
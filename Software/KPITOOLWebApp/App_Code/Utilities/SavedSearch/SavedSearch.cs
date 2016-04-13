using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.SavedSearch
{
    /// <summary>
    /// Summary description for SavedSearch
    /// </summary>
    public class SavedSearch
    {
        private string _searchId;
        private int _userId;
        private string _name;
        private string _searchExpression;
        private DateTime _dateCreated;

        public SavedSearch()
        {
            _dateCreated = DateTime.Now;
        }

        public SavedSearch(string searchId, int userId, string name, string searchExpression, DateTime dateCreated)
        {
            this._dateCreated = dateCreated;
            this._name = name;
            this._searchExpression = searchExpression;
            this._searchId = searchId;
            this._userId = userId;
        }

        public string SearchId
        {
            get { return this._searchId; }
            set { this._searchId = value; }
        }

        public int UserId
        {
            get { return this._userId; }
            set { this._userId = value; }
        }

        public string Name
        {
            get { return this._name; }
            set { this._name = value; }
        }

        public string SearchExpression
        {
            get { return this._searchExpression; }
            set { this._searchExpression = value; }
        }

        public DateTime DateCreated
        {
            get { return this._dateCreated; }
            set { this._dateCreated = value; }
        }

    }
}
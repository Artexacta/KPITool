using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.User
{
    /// <summary>
    /// Class that records all the configuration setings for 
    /// a user
    /// </summary>
    [Serializable]
    public class UserConfiguration
    {
        private int _userId;
        private int _numberSavedSearches;
        private int _timeToShowTooltips;

        public int UserId
        {
            get { return this._userId; }
            set { this._userId = value; }
        }

        public int NumberSavedSearches
        {
            get { return this._numberSavedSearches; }
            set { this._numberSavedSearches = value; }
        }

        public int TimesToShowToolTips
        {
            get { return this._timeToShowTooltips; }
            set { this._timeToShowTooltips = value; }
        }

        public UserConfiguration()
        {
        }

        public UserConfiguration(int userId, int numberSavedSearches, int numberOfTimesToShowTooltips)
        {
            _userId = userId;
            _numberSavedSearches = numberSavedSearches;
            _timeToShowTooltips = numberOfTimesToShowTooltips;
        }
    }
}
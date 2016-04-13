using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.ChangesLog
{
    [Serializable]
    public class ChangesLog
    {
        private string _version;
        private string _date;
        private string _description;

        public string Version
        {
            get { return _version; }
            set { _version = value; }
        }

        public string Date
        {
            get { return _date; }
            set { _date = value; }
        }

        public string Description
        {
            get { return _description; }
            set { _description = value; }
        }

        public ChangesLog()
        {
        }

        public ChangesLog(string version, string date, string description)
        {
            _version = version;
            _date = date;
            _description = description;
        }
    }
}
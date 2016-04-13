using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.ViewStateSql
{
    /// <summary>
    /// Summary description for ViewStateSql
    /// </summary>
    [Serializable]
    public class ViewStateSql
    {
        private Guid _viewStateId;
        private byte[] _value;
        private int _timeout;

        public Guid ViewStateId
        {
            get { return this._viewStateId; }
            set { this._viewStateId = value; }
        }

        public byte[] Value
        {
            set { this._value = value; }
            get { return this._value; }
        }

        public int Timeout
        {
            set { this._timeout = value; }
            get { return this._timeout; }
        }

        public ViewStateSql()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        public ViewStateSql(Guid viewstateid, byte[] theValue, int timeout)
        {
            this._viewStateId = viewstateid;
            this._value = theValue;
            this._timeout = timeout;
        }
    }
}
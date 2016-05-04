using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.PermissionObject
{
    /// <summary>
    /// Summary description for PermissionObject
    /// </summary>
    public class PermissionObject
    {
        private int _objectID;
        private string _objectTypeID;
        private string _objectAction;
        private string _userName;
        private string _fullName;

        public PermissionObject()
        {
        }

        public PermissionObject(int objectID, string objectTypeID, string objectAction, string userName, string fullName)
        {
            this._objectID = objectID;
            this._objectTypeID = objectTypeID;
            this._objectAction = objectAction;
            this._userName = userName;
            this._fullName = fullName;
        }

        public int ObjectID
        {
            get { return _objectID; }
            set { _objectID = value; }
        }

        public string ObjectTypeID
        {
            get { return _objectTypeID; }
            set { _objectTypeID = value; }
        }

        public string ObjectAction
        {
            get { return _objectAction; }
            set { _objectAction = value; }
        }

        public string UserName
        {
            get { return _userName; }
            set { _userName = value; }
        }

        public string FullName
        {
            get { return _fullName; }
            set { _fullName = value; }
        }

    }
}
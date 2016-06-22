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
        private string _userName;
        private string _fullName;
        private string _email;
        private List<ObjectAction.ObjectAction> _theActionList;

        public enum ObjectType
        {
            ORGANIZATION,
            PROJECT,
            ACTIVITY,
            PERSON,
            KPI
        }

        public PermissionObject()
        {
            this._theActionList = new List<ObjectAction.ObjectAction>();
        }

        public PermissionObject(int objectID, string objectTypeID, string userName, string fullName, string email)
        {
            this._objectID = objectID;
            this._objectTypeID = objectTypeID;
            this._userName = userName;
            this._fullName = fullName;
            this._email = email;
            this._theActionList = new List<ObjectAction.ObjectAction>();
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

        public string Email
        {
            get { return _email; }
            set { _email = value; }
        }

        public List<ObjectAction.ObjectAction> TheActionList
        {
            get { return _theActionList; }
            set { _theActionList = value; }
        }

        public string UserInfo
        {
            get
            {
                return string.IsNullOrEmpty(this._userName) ? Resources.ShareData.EveryoneCheckBox : (this._fullName + " (" + this._email + ")");
            }
        }

        public string PermissionsActionForDisplay
        {
            get
            {
                return string.Join(", ", this._theActionList.Select(i => i.ObjectActionName));
            }
        }

        public string PermissionsAction
        {
            get
            {
                return string.Join(";", this._theActionList.Select(i => i.ObjectActionName));
            }
        }

    }
}
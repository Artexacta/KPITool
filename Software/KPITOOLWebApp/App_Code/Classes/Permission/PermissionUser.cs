using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.Permissions.User
{
    /// <summary>
    /// Summary description for PermissionUser
    /// </summary>
    public class PermissionUser
    {
        private int _permissionid;
        private string _description;
        private int _userid;
        private bool _userhaspermission;

        public PermissionUser()
        {
        }

        public PermissionUser(int permissionid, string description,
            int userid, bool UserHasPermission)
        {
            this._permissionid = permissionid;
            this._description = description;
            this._userid = userid;
            this._userhaspermission = UserHasPermission;
        }

        public int PermissionId
        {
            get { return this._permissionid; }
            set { this._permissionid = value; }
        }

        public string Description
        {
            get { return this._description; }
            set { this._description = value; }
        }

        public int UserId
        {
            get { return this._userid; }
            set { this._userid = value; }
        }

        public bool UserHasPermission
        {
            get { return this._userhaspermission; }
            set { this._userhaspermission = value; }
        }
    }
}
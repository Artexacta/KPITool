using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.Permissions.Role
{
    /// <summary>
    /// Summary description for PermissionRole
    /// </summary>
    public class PermissionRole
    {
        private int _permissionId;
        private string _description;
        private string _role;
        private bool _rolehaspermission;

        public PermissionRole()
        {
        }

        public PermissionRole(int PermissionId, string Description,
            string Role, bool RoleHasPermission)
        {
            this._permissionId = PermissionId;
            this._description = Description;
            this._role = Role;
            this._rolehaspermission = RoleHasPermission;
        }

        public int PermissionId
        {
            get { return this._permissionId; }
            set { this._permissionId = value; }
        }

        public string Description
        {
            get { return this._description; }
            set { this._description = value; }
        }

        public string Role
        {
            get { return this._role; }
            set { this._role = value; }
        }

        public bool RoleHasPermission
        {
            get { return this._rolehaspermission; }
            set { this._rolehaspermission = value; }
        }
    }
}
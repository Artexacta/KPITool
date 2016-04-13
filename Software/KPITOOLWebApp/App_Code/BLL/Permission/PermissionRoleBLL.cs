using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using log4net;
using PermissionRoleDSTableAdapters;
using Artexacta.App.Permissions.Role;

namespace Artexacta.App.Permissions.Role.BLL
{
    /// <summary>
    /// Summary description for PermissionRoleBLL
    /// </summary>
    [System.ComponentModel.DataObject]
    public class PermissionRoleBLL
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        private PermissionRoleTableAdapter _PermissionAdapter = null;

        protected PermissionRoleTableAdapter PermissionAdapter
        {
            get
            {
                if (_PermissionAdapter == null)
                    _PermissionAdapter = new PermissionRoleTableAdapter();
                return _PermissionAdapter;
            }
        }

        public PermissionRoleBLL()
        {
        }

        private PermissionRole FillPermissionRecord(PermissionRoleDS.PermissionRoleRow row)
        {
            PermissionRole theNewRecord = new PermissionRole(
                row.permissionid,
                row.IsdescriptionNull() ? "" : row.description,
                row.IsroleNull() ? "" : row.role,
                row.IsroleNull() ? false : true);

            return theNewRecord;
        }

        private PermissionRole FillPermissionRecord(PermissionRoleDS.PermissionRoleRow row,
            string GivenRol)
        {
            PermissionRole theNewRecord = new PermissionRole(
               row.permissionid,
               row.IsdescriptionNull() ? "" : row.description,
               GivenRol,
               row.IsroleNull() ? false : true);

            return theNewRecord;
        }

        public List<PermissionRole> GetPermissionsForRole(string Role)
        {
            if (string.IsNullOrEmpty(Role))
                return null;

            List<PermissionRole> thePermissionList = new List<PermissionRole>();

            PermissionRoleDS.PermissionRoleDataTable table =
                PermissionAdapter.GetPermissionsForRole(Role);
            if (table != null && table.Rows.Count > 0)
            {
                foreach (PermissionRoleDS.PermissionRoleRow row in table.Rows)
                {
                    PermissionRole thePermission = FillPermissionRecord(row, Role);
                    thePermissionList.Add(thePermission);
                }
            }
            return thePermissionList;
        }

        public void UpdatePermissionForRole(PermissionRole thePermission)
        {
            if (thePermission.RoleHasPermission)
            {
                if (!PermissionIsAllowedForRole(thePermission.Role, thePermission.PermissionId))
                    PermissionAdapter.InsertOperationForRole(thePermission.PermissionId, thePermission.Role);
            }
            else
            {
                if (PermissionIsAllowedForRole(thePermission.Role, thePermission.PermissionId))
                    PermissionAdapter.DeleteOperationForRole(thePermission.PermissionId, thePermission.Role);
            }
        }

        public bool PermissionIsAllowedForRole(string Role, int PermissionID)
        {
            Object theCount = PermissionAdapter.IsPermissionAllowedForRole(PermissionID, Role);
            if (Convert.ToInt32(theCount) == 1)
                return true;
            else
                return false;
        }

        public void UpdatePermissionForRole(int PermissionId, bool Permission, string GivenRol)
        {
            if (Permission)
            {
                PermissionAdapter.InsertOperationForRole(PermissionId, GivenRol);
            }
            else
            {
                PermissionAdapter.DeleteOperationForRole(PermissionId, GivenRol);
            }
        }
    }
}
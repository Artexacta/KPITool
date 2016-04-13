using System;
using System.Collections.Generic;
using System.Web;
using log4net;
using Artexacta.App.Permissions.User;
using PermissionUserDSTableAdapters;

namespace Artexacta.App.Permissions.User.BLL
{
    /// <summary>
    /// Summary description for PermissionUserBLL
    /// </summary>
    [System.ComponentModel.DataObject]
    public class PermissionUserBLL
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        private PermissionUserTableAdapter _PermissionAdapter = null;

        protected PermissionUserTableAdapter PermissionAdapter
        {
            get
            {
                if (_PermissionAdapter == null)
                    _PermissionAdapter = new PermissionUserTableAdapter();
                return _PermissionAdapter;
            }
        }

        public PermissionUserBLL()
        {
        }

        private PermissionUser FillPermissionRecord(PermissionUserDS.PermissionUserRow row)
        {
            PermissionUser theNewRecord = new PermissionUser(
                row.permissionId,
                row.IsdescriptionNull() ? "" : row.description,
                row.IsuseridNull() ? 0 : row.userid,
                row.IsuseridNull() ? false : true);

            return theNewRecord;
        }

        private PermissionUser FillPermissionRecord(PermissionUserDS.PermissionUserRow row, int GivenUser)
        {
            PermissionUser theNewRecord = new PermissionUser(
                row.permissionId,
                row.IsdescriptionNull() ? "" : row.description,
                GivenUser,
                row.IsuseridNull() ? false : true);

            return theNewRecord;
        }

        public List<PermissionUser> GetPermissionsForUser(int UserId)
        {
            if (UserId <= 0)
                return null;

            List<PermissionUser> thePermissionList = new List<PermissionUser>();

            PermissionUserDS.PermissionUserDataTable table =
                PermissionAdapter.GetPermissionsForUser(UserId);
            if (table != null && table.Rows.Count > 0)
            {
                foreach (PermissionUserDS.PermissionUserRow row in table.Rows)
                {
                    PermissionUser thePermission = FillPermissionRecord(row, UserId);
                    thePermissionList.Add(thePermission);
                }
            }
            return thePermissionList;
        }

        public void UpdatePermissionForUser(PermissionUser thePermission)
        {
            if (thePermission.UserHasPermission)
            {
                if (!PermissionIsAllowedForUser(thePermission.UserId, thePermission.PermissionId))
                    PermissionAdapter.InsertOperationForUser(thePermission.PermissionId, thePermission.UserId);
            }
            else
            {
                if (PermissionIsAllowedForUser(thePermission.UserId, thePermission.PermissionId))
                    PermissionAdapter.DeleteOperationForUser(thePermission.PermissionId, thePermission.UserId);
            }
        }

        public bool PermissionIsAllowedForUser(int UserId, int PermissionID)
        {
            Object theCount = PermissionAdapter.IsPermissionAllowedForUser(PermissionID, UserId);
            if (Convert.ToInt32(theCount) == 1)
                return true;
            else
                return false;
        }

        public void UpdatePermissionForUser(int IdOperacion, bool ValorPermiso, int GivenUserId)
        {
            if (ValorPermiso)
            {
                PermissionAdapter.InsertOperationForUser(IdOperacion, GivenUserId);
            }
            else
            {
                PermissionAdapter.DeleteOperationForUser(IdOperacion, GivenUserId);
            }
        }
    }
}
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using PermissionObjectDSTableAdapters;
using Artexacta.App.User.BLL;

namespace Artexacta.App.PermissionObject.BLL
{
    /// <summary>
    /// Summary description for PermissionObjectBLL
    /// </summary>
    [System.ComponentModel.DataObject]
    public class PermissionObjectBLL
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        ObjectPermissionsTableAdapter _theAdapter = null;

        protected ObjectPermissionsTableAdapter theAdapter
        {
            get
            {
                if (_theAdapter == null)
                    _theAdapter = new ObjectPermissionsTableAdapter();
                return _theAdapter;
            }
        }

        public PermissionObjectBLL()
        {
        }

        private static PermissionObject FillRecord(PermissionObjectDS.ObjectPermissionsRow row)
        {
            PermissionObject theNewRecord = new PermissionObject(
                row.objectID,
                row.objectTypeID,
                row.IsusernameNull() ? "" : row.username,
                row.IsfullnameNull() ? "" : row.fullname,
                row.IsemailNull() ? "" : row.email);

            return theNewRecord;
        }

        public static List<PermissionObject> GetPermissionsByObject(string objectTypeId, int objectId)
        {
            if (string.IsNullOrEmpty(objectTypeId))
                throw new ArgumentException(Resources.ShareData.MessageNullObjectTypeId);

            if (objectId <= 0)
                throw new ArgumentException(Resources.ShareData.MessageZeroObjectId);

            List<PermissionObject> theList = new List<PermissionObject>();
            PermissionObject theData = null;
            try
            {
                ObjectPermissionsTableAdapter localAdapter = new ObjectPermissionsTableAdapter();
                PermissionObjectDS.ObjectPermissionsDataTable theTable = localAdapter.GetObjectPermissionsByObject(objectTypeId, objectId);

                if (theTable != null && theTable.Rows.Count > 0)
                {
                    foreach (PermissionObjectDS.ObjectPermissionsRow theRow in theTable)
                    {
                        if (!theList.Exists(i => i.UserName.Equals(theRow.username)))
                        {
                            theData = FillRecord(theRow);
                            theData.TheActionList.Add(new ObjectAction.ObjectAction(theRow.objectActionID));
                            theList.Add(theData);
                        }
                        else
                        {
                            theData = theList.Find(i => i.UserName.Equals(theRow.username));
                            theData.TheActionList.Add(new ObjectAction.ObjectAction(theRow.objectActionID));
                        }
                    }
                }
            }
            catch (Exception exc)
            {
                log.Error("Error en GetPermissionsByObject para objectTypeId: " + objectTypeId + " y objectId: " + objectId, exc);
                throw new ArgumentException(Resources.ShareData.MessageErrorPermissionsByObject);
            }

            return theList;
        }

        public static bool InsertObjectPermissions(string objectTypeId, int objectId, int userId, string objectActionList)
        {
            if (string.IsNullOrEmpty(objectTypeId))
                throw new ArgumentException(Resources.ShareData.MessageNullObjectTypeId);

            if (objectId <= 0)
                throw new ArgumentException(Resources.ShareData.MessageZeroObjectId);

            if (userId <= 0)
                throw new ArgumentException(Resources.ShareData.MessageZeroUserId);

            User.User theUser = null;
            try
            {
                theUser = UserBLL.GetUserById(userId);
            }
            catch
            {
                throw new ArgumentException(Resources.ShareData.MessageErrorUser);
            }

            if (theUser == null)
                throw new ArgumentException(Resources.ShareData.MessageErrorUser);

            if (string.IsNullOrEmpty(objectActionList))
                throw new ArgumentException(Resources.ShareData.MessageEmptyPermissionsList);

            try
            {
                ObjectPermissionsTableAdapter localAdapter = new ObjectPermissionsTableAdapter();
                localAdapter.InsertObjectPermissions(objectTypeId, objectId, theUser.Username, objectActionList);
                return true;
            }
            catch (Exception exc)
            {
                log.Error("Error en InsertObjectPermissions para los datos objectTypeId: " + objectTypeId + ", objectId: " + objectId
                    + ", userId: " + userId + " y objectActionList: " + objectActionList, exc);
                throw new ArgumentException(Resources.ShareData.MessageErrorInsertObjectPermissions);
            }
        }

        public static bool InsertObjectPublic(string objectTypeId, int objectId, string objectActionList)
        {
            if (string.IsNullOrEmpty(objectTypeId))
                throw new ArgumentException(Resources.ShareData.MessageNullObjectTypeId);

            if (objectId <= 0)
                throw new ArgumentException(Resources.ShareData.MessageZeroObjectId);

            if (string.IsNullOrEmpty(objectActionList))
                throw new ArgumentException(Resources.ShareData.MessageEmptyPermissionsList);

            try
            {
                ObjectPermissionsTableAdapter localAdapter = new ObjectPermissionsTableAdapter();
                localAdapter.InsertObjectPublic(objectTypeId, objectId, objectActionList);
                return true;
            }
            catch (Exception exc)
            {
                log.Error("Error en InsertObjectPublic para los datos objectTypeId: " + objectTypeId + ", objectId: " + objectId
                    + " y objectActionList: " + objectActionList, exc);
                throw new ArgumentException(Resources.ShareData.MessageErrorInsertObjectPublic);
            }
        }

        public static bool DeleteObjectPermissions(string objectTypeId, int objectId, string userName)
        {
            if (string.IsNullOrEmpty(objectTypeId))
                throw new ArgumentException(Resources.ShareData.MessageNullObjectTypeId);

            if (objectId <= 0)
                throw new ArgumentException(Resources.ShareData.MessageZeroObjectId);

            if (string.IsNullOrEmpty(userName))
                throw new ArgumentException(Resources.ShareData.MessageErrorUserName);

            try
            {
                ObjectPermissionsTableAdapter localAdapter = new ObjectPermissionsTableAdapter();
                localAdapter.DeleteObjectPermissions(objectTypeId, objectId, userName);
                return true;
            }
            catch (Exception exc)
            {
                log.Error("Error en DeleteObjectPermissions para los datos objectTypeId: " + objectTypeId + ", objectId: " + objectId + " y userName: " + userName, exc);
                throw new ArgumentException(Resources.ShareData.MessageErrorDeleteObjectPermissions);
            }
        }

        public static bool DeleteObjectPublic(string objectTypeId, int objectId)
        {
            if (string.IsNullOrEmpty(objectTypeId))
                throw new ArgumentException(Resources.ShareData.MessageNullObjectTypeId);

            if (objectId <= 0)
                throw new ArgumentException(Resources.ShareData.MessageZeroObjectId);

            try
            {
                ObjectPermissionsTableAdapter localAdapter = new ObjectPermissionsTableAdapter();
                localAdapter.DeleteObjectPublic(objectTypeId, objectId);
                return true;
            }
            catch (Exception exc)
            {
                log.Error("Error en DeleteObjectPublic para los datos objectTypeId: " + objectTypeId + " y objectId: " + objectId, exc);
                throw new ArgumentException(Resources.ShareData.MessageErrorDeleteObjectPublic);
            }
        }

        public static PermissionObject GetPermissionsByUser(string objectTypeId, int objectId, string userName)
        {
            if (string.IsNullOrEmpty(objectTypeId))
                throw new ArgumentException(Resources.ShareData.MessageNullObjectTypeId);

            if (objectId <= 0)
                throw new ArgumentException(Resources.ShareData.MessageZeroObjectId);

            if (string.IsNullOrEmpty(userName))
                throw new ArgumentException(Resources.ShareData.MessageErrorUserName);

            PermissionObject theData = null;
            try
            {
                ObjectPermissionsTableAdapter localAdapter = new ObjectPermissionsTableAdapter();
                PermissionObjectDS.ObjectPermissionsDataTable theTable = localAdapter.GetObjectPermissionsByUser(objectTypeId, objectId, userName);

                if (theTable != null && theTable.Rows.Count > 0)
                {
                    foreach (PermissionObjectDS.ObjectPermissionsRow theRow in theTable)
                    {
                        if (theData == null)
                        {
                            theData = FillRecord(theRow);
                            theData.TheActionList.Add(new ObjectAction.ObjectAction(theRow.objectActionID));
                        }
                        else
                        {
                            theData.TheActionList.Add(new ObjectAction.ObjectAction(theRow.objectActionID));
                        }
                    }
                }
            }
            catch (Exception exc)
            {
                log.Error("Error en GetPermissionsByUser para objectTypeId: " + objectTypeId + ", objectId: " + objectId + " y userName: " + userName, exc);
                throw new ArgumentException(Resources.ShareData.MessageErrorPermissionsByUser);
            }

            return theData;
        }

        public static PermissionObject GetPermissionsByUser(string objectTypeId, int objectId)
        {
            if (string.IsNullOrEmpty(objectTypeId))
                throw new ArgumentException(Resources.ShareData.MessageNullObjectTypeId);

            if (objectId <= 0)
                throw new ArgumentException(Resources.ShareData.MessageZeroObjectId);

            string userName = HttpContext.Current.User.Identity.Name;
            PermissionObject theData = null;
            try
            {
                ObjectPermissionsTableAdapter localAdapter = new ObjectPermissionsTableAdapter();
                PermissionObjectDS.ObjectPermissionsDataTable theTable = localAdapter.GetObjectPermissionsByUser(objectTypeId, objectId, userName);

                if (theTable != null && theTable.Rows.Count > 0)
                {
                    foreach (PermissionObjectDS.ObjectPermissionsRow theRow in theTable)
                    {
                        if (theData == null)
                        {
                            theData = FillRecord(theRow);
                            theData.TheActionList.Add(new ObjectAction.ObjectAction(theRow.objectActionID));
                        }
                        else
                        {
                            theData.TheActionList.Add(new ObjectAction.ObjectAction(theRow.objectActionID));
                        }
                    }
                }
            }
            catch (Exception exc)
            {
                log.Error("Error en GetPermissionsByUser para objectTypeId: " + objectTypeId + ", objectId: " + objectId + " y userName: " + userName, exc);
                throw new ArgumentException(Resources.ShareData.MessageErrorVerifyPermissionsByUser);
            }

            return theData;
        }

    }
}
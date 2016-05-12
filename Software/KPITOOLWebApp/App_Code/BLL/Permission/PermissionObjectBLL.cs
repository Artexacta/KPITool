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
                throw new ArgumentException("El tipo de dato no puede ser nulo o vacío.");

            if (objectId <= 0)
                throw new ArgumentException("El ID del dato no puede ser <= 0");

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
                throw new ArgumentException("Ocurrió un error al obtener el listado de usuarios con permisos registrados.");
            }

            return theList;
        }

        public static bool InsertObjectPermissions(string objectTypeId, int objectId, int userId, string objectActionList)
        {
            if (string.IsNullOrEmpty(objectTypeId))
                throw new ArgumentException("El tipo de dato no puede ser nulo o vacío.");

            if (objectId <= 0)
                throw new ArgumentException("El ID del dato no puede ser <= 0.");

            if (userId <= 0)
                throw new ArgumentException("El ID del usuario no puede ser <= 0");

            User.User theUser = null;
            try
            {
                theUser = UserBLL.GetUserById(userId);
            }
            catch
            {
                throw new ArgumentException("Error al obtener la información del usuario.");
            }

            if (theUser == null)
                throw new ArgumentException("Error al obtener la información del usuario.");

            if (string.IsNullOrEmpty(objectActionList))
                throw new ArgumentException("El listado de permisos para el usuario no puede ser vacío.");

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
                throw new ArgumentException("Ocurrió un error al registrar los permisos para el usuario.");
            }
        }

        public static bool InsertObjectPublic(string objectTypeId, int objectId, string objectActionList)
        {
            if (string.IsNullOrEmpty(objectTypeId))
                throw new ArgumentException("El tipo de dato no puede ser nulo o vacío.");

            if (objectId <= 0)
                throw new ArgumentException("El ID del dato no puede ser <= 0.");

            if (string.IsNullOrEmpty(objectActionList))
                throw new ArgumentException("El listado de permisos no puede ser vacío.");

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
                throw new ArgumentException("Ocurrió un error al registrar los permisos públicos para todos los usuarios.");
            }
        }

        public static bool DeleteObjectPermissions(string objectTypeId, int objectId, string userName)
        {
            if (string.IsNullOrEmpty(objectTypeId))
                throw new ArgumentException("El tipo de dato no puede ser nulo o vacío.");

            if (objectId <= 0)
                throw new ArgumentException("El ID del dato no puede ser <= 0.");

            if (string.IsNullOrEmpty(userName))
                throw new ArgumentException("El nombre del usuario no puede ser nulo o vacío.");

            try
            {
                ObjectPermissionsTableAdapter localAdapter = new ObjectPermissionsTableAdapter();
                localAdapter.DeleteObjectPermissions(objectTypeId, objectId, userName);
                return true;
            }
            catch (Exception exc)
            {
                log.Error("Error en DeleteObjectPermissions para los datos objectTypeId: " + objectTypeId + ", objectId: " + objectId + " y userName: " + userName, exc);
                throw new ArgumentException("Ocurrió un error al eliminar los permisos para el usuario.");
            }
        }

        public static bool DeleteObjectPublic(string objectTypeId, int objectId)
        {
            if (string.IsNullOrEmpty(objectTypeId))
                throw new ArgumentException("El tipo de dato no puede ser nulo o vacío.");

            if (objectId <= 0)
                throw new ArgumentException("El ID del dato no puede ser <= 0.");

            try
            {
                ObjectPermissionsTableAdapter localAdapter = new ObjectPermissionsTableAdapter();
                localAdapter.DeleteObjectPublic(objectTypeId, objectId);
                return true;
            }
            catch (Exception exc)
            {
                log.Error("Error en DeleteObjectPublic para los datos objectTypeId: " + objectTypeId + " y objectId: " + objectId, exc);
                throw new ArgumentException("Ocurrió un error al eliminar los permisos públicos para todos los usuarios.");
            }
        }

        public static PermissionObject GetPermissionsByUser(string objectTypeId, int objectId, string userName)
        {
            if (string.IsNullOrEmpty(objectTypeId))
                throw new ArgumentException("El tipo de dato no puede ser nulo o vacío.");

            if (objectId <= 0)
                throw new ArgumentException("El ID del dato no puede ser <= 0");

            if (string.IsNullOrEmpty(userName))
                throw new ArgumentException("El nombre del usuario no puede ser nulo o vacío.");

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
                throw new ArgumentException("Ocurrió un error al obtener los permisos registrados para el usuario.");
            }

            return theData;
        }

    }
}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using log4net;
using System.Configuration;
using SecurityDSTableAdapters;
using System.Data;
using System.Collections;
using UserDSTableAdapters;
using System.Security.Cryptography;
using System.Text;
using Artexacta.App.User;
using Artexacta.App.User.BLL;
using System.Threading;

namespace Artexacta.App.Security.BLL
{
    /// <summary>
    /// Summary description for SecurityBLL
    /// </summary>
    [System.ComponentModel.DataObject]
    public class SecurityBLL
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        public SecurityBLL()
        {
        }

        public static void IsUserAuthorizedPerformOperation(string permissionMnemonic)
        {
            if (!IsUserAuthorizedPermission(permissionMnemonic))
            {
                throw new ArgumentException("El usuario no tiene autorización.");
            }
        }

        public static bool IsUserAuthorizedPerformSingleOperation(string permissionMnemonic)
        {
            if (!IsUserAuthorizedPermission(permissionMnemonic))
            {
                return false;
            }
            else
            {
                return true;
            }
        }

        /// <summary>
        /// Test to see if the user is in a specified role.
        /// </summary>
        /// <returns>True if the user is in at least one of the roles defined. False otherwise</returns>
        public static bool IsUserInThisRole(string s)
        {
            bool isInDefinedRole = false;

            ArrayList roles = GetAllDefinedRoles();

            if (Roles.IsUserInRole((string)s))
            {
                isInDefinedRole = true;
            }

            return isInDefinedRole;
        }

        /// <summary>
        /// Get all the roled defined in the system.  We use this, rather than Users.GetAllRoles
        /// because different procedures are required for Forms and for Windows authentication.
        /// </summary>
        /// <returns>A list of strings with all the roles defined in the system</returns>
        public static ArrayList GetAllDefinedRoles()
        {
            ArrayList values = new ArrayList();

            string[] roles = Roles.GetAllRoles();
            foreach (string s in roles)
            {
                values.Add(s);
            }
            return values;
        }

        /// <summary>
        /// Test to see if user is authorized to perform a particular operation.
        /// </summary>
        /// <param name="operationMnemonic">The operation to check</param>
        /// <returns>True if the user is authorized and False otherwise</returns>
        private static bool IsUserAuthorizedPermission(string permissionMnemonic)
        {
            bool allowPermission = false;

            string[] rolesAllowed = null;

            try
            {
                rolesAllowed = GetRolesForPermission(permissionMnemonic);
                if (rolesAllowed != null)
                {
                    foreach (string s in rolesAllowed)
                    {
                        if (IsUserInThisRole(s))
                        {
                            // User is in some authorized role.  Allow him to continue.
                            return true;
                        }
                    }
                }
            }
            catch (Exception e)
            {
                log.Error("Cannot get roles allowed for a specific permission.", e);
                log.Debug("Cannot get roles allowed for a specific permission. IsUserAuthorizedOperation from SecurityBLL");
            }

            if (!allowPermission)
            {
                try
                {
                    if (IsCurrentUserAllowedToPerformPermission(permissionMnemonic))
                    {
                        return true;
                    }
                }
                catch (Exception q)
                {
                    log.Error("Cannot verify if the current user is allowed to perform the given permission.", q);
                    log.Debug("Cannot verify if the current user is allowed to perform the given permission. IsUserAuthorizedOperation from STSecurity");
                }
            }
            return allowPermission;
        }

        /// <summary>
        /// Get all roles and an aditional element [None]
        /// </summary>
        /// <returns>An string with roles</returns>
        public string[] GetAllRolesAndNone()
        {
            try
            {
                string[] Result;

                Result = Roles.GetAllRoles();
                string[] FinalResul = new string[Result.Length + 1];

                FinalResul[0] = Resources.SecurityData.NoneRoleItem;

                for (int i = 1; i < Result.Length + 1; i++)
                {
                    FinalResul[i] = Result[i - 1];
                }
                return FinalResul;
            }
            catch (Exception q)
            {
                throw q;
            }
        }

        /// <summary>
        /// Get all roles and an aditional element [All]
        /// </summary>
        /// <returns>An string with roles</returns>
        public string[] GetAllRolesAndAll()
        {
            string[] Result;

            Result = Roles.GetAllRoles();
            string[] FinalResul = new string[Result.Length + 1];

            FinalResul[0] = Resources.SecurityData.AllRolesItem;

            for (int i = 1; i < Result.Length + 1; i++)
            {
                FinalResul[i] = Result[i - 1];
            }
            return FinalResul;
        }

        /// <summary>
        /// Get an array with roles that contains the given RoleName
        /// </summary>
        /// <param name="RoleName">The rolename</param>
        /// <returns>Ab string with the roles</returns>
        public string[] GetRolesByWhereClause(string RoleName)
        {
            string[] Result;
            string[] FinalResult = null;
            Result = Roles.GetAllRoles();
            if (string.IsNullOrEmpty(RoleName))
            {
                return Result;
            }
            int j = 0;
            for (int i = 0; i < Result.Length; i++)
            {
                if (Result[i].Contains(RoleName))
                {
                    FinalResult[j] = Result[i];
                    j++;
                }
            }
            return FinalResult;
        }

        /// <summary>
        /// Get a list of accounts that have no roles associated
        /// </summary>
        /// <returns>A list of accounts</returns>
        public List<string> UsersInNoneRole()
        {
            try
            {
                MembershipUserCollection theCompleteUserList;
                theCompleteUserList = Membership.GetAllUsers();

                if (theCompleteUserList.Count <= 0)
                    return null;

                User.User theUser = null;

                List<string> theAllUserList = new List<string>();
                foreach (MembershipUser user in theCompleteUserList)
                {
                    theUser = UserBLL.GetUserByUsername(user.UserName);
                    if (theUser != null)
                        theAllUserList.Add(user.UserName);
                }

                List<string> theAllRolesList = new List<string>();
                theAllRolesList.AddRange(Roles.GetAllRoles());

                List<string> theUsersInSomeRoleList = new List<string>();
                foreach (string Role in theAllRolesList)
                {
                    List<string> TheRoleList = new List<string>();
                    TheRoleList.AddRange(Roles.GetUsersInRole(Role));
                    foreach (string User in TheRoleList)
                    {
                        if (!theUsersInSomeRoleList.Contains(User))
                            theUsersInSomeRoleList.Add(User);
                    }
                }

                List<string> theUsersWithoutList = new List<string>();
                theUsersWithoutList = theAllUserList;
                foreach (string user in theUsersInSomeRoleList)
                {
                    theUsersWithoutList.Remove(user);
                }
                return theUsersWithoutList;
            }
            catch (Exception q)
            {
                log.Error("An error was ocurred while creating an Account List", q);
                return null;
            }
        }

        /// <summary>
        /// Get a list of accounts that not exists in Role NONE
        /// </summary>
        /// <returns>A list of accounts</returns>
        public List<string> UsersNotInRoleNone()
        {
            try
            {
                MembershipUserCollection theCompleteUserList;
                theCompleteUserList = Membership.GetAllUsers();

                List<string> theAllUserList = new List<string>();
                foreach (MembershipUser user in theCompleteUserList)
                {
                    theAllUserList.Add(user.UserName);
                }

                List<string> theAllRolesList = new List<string>();
                theAllRolesList.AddRange(Roles.GetAllRoles());

                List<string> theUsersInSomeRoleList = new List<string>();
                foreach (string Role in theAllRolesList)
                {
                    List<string> TheRoleList = new List<string>();
                    TheRoleList.AddRange(Roles.GetUsersInRole(Role));
                    foreach (string User in TheRoleList)
                    {
                        if (!theUsersInSomeRoleList.Contains(User))
                            theUsersInSomeRoleList.Add(User);
                    }
                }

                return theUsersInSomeRoleList;
            }
            catch (Exception q)
            {
                log.Error("An error was ocurred while creating the Account List", q);
                return null;
            }
        }

        /// <summary>
        /// Get a loist of roles that contain a given string
        /// </summary>
        /// <param name="RolName">The role name</param>
        /// <returns>A list of roles</returns>
        public List<Role.Role> FindRolesByName(string RolName)
        {
            List<Role.Role> theResultList = new List<Role.Role>();
            string[] theRoles = Roles.GetAllRoles();

            if (RolName != null && RolName.Length > 0)
            {
                foreach (string oneRole in theRoles)
                {
                    if (oneRole.Contains(RolName))
                    {
                        theResultList.Add(new Role.Role(oneRole));
                    }
                }
            }
            else
            {
                foreach (string oneRole in theRoles)
                {
                    theResultList.Add(new Role.Role(oneRole));
                }
            }
            return theResultList;
        }

        /// <summary>
        /// Get a list of accounts not in e given role
        /// </summary>
        /// <param name="RolName">The role name</param>
        /// <returns>A list of accounts</returns>
        public string[] GetUsersNotInRol(string RolName)
        {
            if (string.IsNullOrEmpty(RolName))
                throw new ArgumentException("El nombre del rol no puede ser vacío.");

            MembershipUserCollection AllUsers;

            string[] FinalUsersNotInRole;
            string UserNotInRole = null;

            try
            {
                AllUsers = Membership.GetAllUsers();
                User.User theUser = null;

                foreach (MembershipUser MemUser in AllUsers)
                {
                    string UserString = MemUser.ToString();

                    //Verify if the user es internal                
                    theUser = UserBLL.GetUserByUsername(UserString);
                    if (theUser != null)
                    {
                        if (!UserInRole(UserString, RolName))
                        {
                            if (UserNotInRole == null || UserNotInRole.Length == 0)
                            {
                                UserNotInRole = UserString;
                            }
                            else
                            {
                                UserNotInRole = UserNotInRole + "," + UserString;
                            }
                        }
                    }

                }
            }
            catch
            {
                log.Error(" An error ocurred while loading roles for: " + RolName);
            }

            if (UserNotInRole == null)
                FinalUsersNotInRole = null;
            else
                FinalUsersNotInRole = UserNotInRole.Split(',');
            return FinalUsersNotInRole;
        }

        /// <summary>
        /// Verifies if a given account is in a given role
        /// </summary>
        /// <param name="UserName">The account name</param>
        /// <param name="RolName">The role name</param>
        /// <returns>True if the account is in the given role. False otherwise</returns>
        private static bool UserInRole(string UserName, string RolName)
        {
            if (string.IsNullOrEmpty(UserName))
                throw new ArgumentException("El nombre de usuario no puede ser vacío.");

            if (string.IsNullOrEmpty(RolName))
                throw new ArgumentException("El nombre del rol no puede ser vacío.");

            string[] UsersInRole;
            bool ReturnValue = false;
            try
            {
                UsersInRole = Roles.GetUsersInRole(RolName);
                if (UsersInRole != null && UsersInRole.Length > 0)
                {
                    foreach (String UserRol in UsersInRole)
                    {
                        if (UserRol == UserName)
                        {
                            ReturnValue = true;
                            return ReturnValue;
                        }
                        else
                        {
                            ReturnValue = false;
                        }

                    }
                }
            }
            catch (Exception q)
            {
                throw q;
            }
            return ReturnValue;
        }

        /// <summary>
        /// Verifies if the given account is in the given delete list
        /// </summary>
        /// <param name="List">The delete list</param>
        /// <param name="user">The account name</param>
        /// <returns>True if the account is in the delete list. False otherwise</returns>
        public static bool IsUserInListToDelete(string[] List, string user)
        {
            bool result = false;
            foreach (String User in List)
            {
                if (User == user)
                {
                    result = true;
                    return result;
                }
                else
                    result = false;
            }
            return result;
        }

        protected static bool IsConfigurationAdminRole(string givenRole)
        {
            //TODO: Hacer la funcion
            if (givenRole == "Administrador")
                return true;
            else
                return false;
        }

        /// <summary>
        /// Verifies if the given account can be deleted from the given role
        /// </summary>
        /// <param name="ListOfUserToDelete">List of accounts to delete</param>
        /// <param name="user">The account name</param>
        /// <param name="Role">The role name</param>
        /// <returns>Ture if the account can be deleted. False otherwise</returns>
        public static bool CanDeleteUserFromRole(string[] ListOfUserToDelete, string User, string Role, ref string UserType)
        {
            bool IsUserInList = false;
            bool FinalResult = true;
            bool RoleIsAdminRole = false;
            bool IsUserCurrentSystemAdministrator = false;
            string SystemAdmin = ConfigurationManager.AppSettings.Get("AdminUser");

            if (SystemAdmin != null && SystemAdmin.Length > 0)
            {
                IsUserCurrentSystemAdministrator = IsUserInListToDelete(ListOfUserToDelete, SystemAdmin);
            }

            IsUserInList = IsUserInListToDelete(ListOfUserToDelete, User);

            if (IsUserInList == true)
            {
                RoleIsAdminRole = IsConfigurationAdminRole(Role);
                if (RoleIsAdminRole)
                {
                    FinalResult = false;
                }
                else
                {

                    FinalResult = true;
                }
                UserType = "Normal";
            }
            else
            {
                if (IsUserCurrentSystemAdministrator)
                {
                    RoleIsAdminRole = IsConfigurationAdminRole(Role);
                    if (RoleIsAdminRole)
                    {
                        FinalResult = false;
                    }
                    UserType = "Admin";
                }
                else
                {
                    FinalResult = true;
                    UserType = "Normal";
                }
            }
            return FinalResult;
        }

        public static bool IsUserCurrentAdministrator(string User)
        {
            string theUser = "";
            theUser = ConfigurationManager.AppSettings.Get("AdminUser");
            if (theUser.Length > 0)
            {
                if (theUser == User)
                {
                    return true;
                }
            }
            return false;
        }

        public static bool CanDeleteUser(string User)
        {
            if (User == ConfigurationManager.AppSettings.Get("AdminUser").ToString())
                return false;
            else
                return true;
        }

        /// <summary>
        /// Gets all roles that are authorized for any permission
        /// </summary>
        /// <param name="operationMnemonic">The permission to check</param>
        /// <returns>List of roles authorized.  Null if no roles are authorized.</returns>
        public static string[] GetRolesForPermission(string permissionMnemonic)
        {
            string[] mnemonicList = null;

            SecurityTableAdapter RoleAdapter = new SecurityTableAdapter();
            SecurityDS.SecurityDataTable table =
                RoleAdapter.GetRolesAllowedForPermission(permissionMnemonic);

            if (table.Rows.Count > 0)
            {
                mnemonicList = new string[table.Rows.Count];
                int current = 0;
                foreach (DataRow row in table.Rows)
                {
                    mnemonicList[current++] = (String)row["role"];
                }
            }
            return mnemonicList;
        }

        /// <summary>
        /// Verifies if the current account is allowed to perform a given permission
        /// </summary>
        /// <param name="permissionMnemonic">The permission mnemonic</param>
        /// <returns>True if current account is allowed to perform operation. False otherwise</returns>
        public static bool IsCurrentUserAllowedToPerformPermission(string permissionMnemonic)
        {
            bool Result = false;
            int EmployeeID = 0;
            SecurityTableAdapter RoleAdapter = new SecurityTableAdapter();

            try
            {
                User.User theUser = UserBLL.GetUserByUsername(HttpContext.Current.User.Identity.Name);

                if (theUser != null && theUser.UserId > 0)
                    EmployeeID = theUser.UserId;
                else
                    return false;

                Object Count = RoleAdapter.IsUserAllowedToPerformPermission(permissionMnemonic, EmployeeID);

                if (Count != null && Count.ToString().Length > 0)
                {
                    if (Convert.ToInt32(Count) > 0)
                        Result = true;
                    else
                        Result = false;
                }
                return Result;
            }
            catch (Exception q)
            {
                throw q;
            }
        }

        /// <summary>
        /// Verifies if the given account is allowed to perform a given permission
        /// </summary>
        /// <param name="EmployeeID">The employee ID</param>
        /// <param name="permissionMnemonic">The permission mnemonic</param>
        /// <returns>True is the account is allowed to perform permission. False otherwise</returns>
        public static bool IsUserAllowedToPerformPermission(string UserName, string permissionMnemonic)
        {
            bool Result = false;

            SecurityTableAdapter RoleAdapter = new SecurityTableAdapter();

            User.User theUser = UserBLL.GetUserByUsername(UserName);
            if (theUser == null)
            {
                log.Error("No se pudo encontrar al usuario:" + UserName);
                throw new ArgumentException("No se pudo encontrar al usuario:" + UserName);
            }

            Object Count =  RoleAdapter.IsUserAllowedToPerformPermission(permissionMnemonic, theUser.UserId);

            if (Count != null && Count.ToString().Length > 0)
            {
                if (Convert.ToInt32(Count) > 0)
                    Result = true;
                else
                    Result = false;
            }
            return Result;
        }

        /// <summary>
        /// Get a list of internal users that contain the given criteria
        /// </summary>
        /// <param name="UserName">The account criteria name</param>
        /// <returns>An account collection</returns>
        public static MembershipUserCollection LookUpUsers(string UserName)
        {
            if (UserName != null && UserName.Length > 0)
            {
                UserName = "%" + UserName + "%";
            }
            else
            {
                UserName = "%";
            }

            MembershipUserCollection MemUser = Membership.FindUsersByName(UserName);

            MembershipUserCollection theFinalList = new MembershipUserCollection();

            if (MemUser.Count <= 0)
                return null;

            foreach (MembershipUser theUser in MemUser)
            {
                theFinalList.Add(theUser);
            }

            return theFinalList;
        }


        /// <summary>
        /// Delete an account manually
        /// </summary>
        /// <param name="UserName">The account name to delete</param>
        public void DeleteManualUser(string UserName)
        {
            try
            {
                if (UserName != null && UserName.Length > 0)
                {
                    Membership.DeleteUser(UserName);
                }
            }
            catch (Exception q)
            {
                log.Error("Function DeleteMenualUser on EmployeeBLL", q);
            }
        }

        public static void SetUpAccessControlPermisions()
        {
            try
            {
                string adminUserName = ConfigurationManager.AppSettings.Get("AdminUser");
                string adminPassword = ConfigurationManager.AppSettings.Get("AdminDefaultPassword");
                string adminEmailAddress = ConfigurationManager.AppSettings.Get("AdminEmailAddress");
                string adminQuestion = ConfigurationManager.AppSettings.Get("AdminQuestion");
                string adminAnswer = ConfigurationManager.AppSettings.Get("AdminAnswer");
                string adminGroup = ConfigurationManager.AppSettings.Get("AdminRole");
                string adminFullname = ConfigurationManager.AppSettings.Get("AdminFullName");

                // See if we need to create the ADMIN account

                log.Debug("We are using Forms authentication.  Checking to see if we need to create an ADMIN account");

                if (Membership.FindUsersByName(adminUserName).Count == 0)
                {
                    if (log.IsDebugEnabled)
                    {
                        log.Debug("ADMIN account does not exist. Need to create one");
                        log.Debug("Admin user name: " + adminUserName);
                        log.Debug("Admin initial password: " + adminPassword);
                        log.Debug("Admin email address: " + adminEmailAddress);
                        log.Debug("Admin security question: " + adminQuestion);
                        log.Debug("Admin security answer: " + adminAnswer);
                        log.Debug("Admin group: " + adminGroup);
                    }

                    MembershipCreateStatus theCreateStatus = new MembershipCreateStatus();
                    Membership.CreateUser(adminUserName, adminPassword, adminEmailAddress, adminQuestion,
                        adminAnswer, true, out  theCreateStatus);

                    if (theCreateStatus != MembershipCreateStatus.Success)
                    {
                        log.Error("Failed to create admin user");
                        throw new Exception("Error al crear el usuario admin en la base de Usuarios.");
                    }
                    else
                    {
                        if (UserBLL.InsertUserRecord(adminUserName, adminFullname, "", "", "", 0, 0, adminEmailAddress) < 0)
                        {
                            throw new Exception("Error al crear el usuario admin en la base de Producción.");
                        }
                    }
                }

                if (!Roles.RoleExists(adminGroup))
                {
                    log.Debug("Admin group does not exist. Creating it.");
                    Roles.CreateRole(adminGroup);

                    try
                    {
                        Permissions.Role.BLL.PermissionRoleBLL theBLL = new Artexacta.App.Permissions.Role.BLL.PermissionRoleBLL();
                        theBLL.UpdatePermissionForRole(1, true, adminGroup);
                    }
                    catch (Exception ex)
                    {
                        log.Error("Failed to Update Generic Permission For Role to Forms autentication administrator", ex);
                    }
                }

                if (!Roles.IsUserInRole(adminUserName, adminGroup))
                {
                    log.Debug("Admin is not in admin group.  Adding admin user to admin group");
                    Roles.AddUsersToRole(new string[] { adminUserName }, adminGroup);
                }

                log.Debug("Adding addmin default permissions");
                AddDefaultAdministratorAccess(ConfigurationManager.AppSettings.Get("AdminRole"));
            }
            catch (Exception q)
            {
                log.Error("Error initializing the access control system: " + q.Message, q);
                throw q;
            }
        }

        public static void AddDefaultAdministratorAccess(string Role)
        {
            UserTableAdapter theAdapter = new UserTableAdapter();
            try
            {
                theAdapter.AddDefaultAdministratorAccess(Role);
            }
            catch (Exception q)
            {
                log.Error("An error was ocurred while adding default permission by admin role", q);
            }
        }

        public static string ComputeEmailVerificationString(string userName)
        {
            UnicodeEncoding unicodeName = new UnicodeEncoding();

            MD5CryptoServiceProvider md5 = new MD5CryptoServiceProvider();
            RNGCryptoServiceProvider randGen = new RNGCryptoServiceProvider();

            byte[] randNumber = new byte[6];

            randGen.GetBytes(randNumber);

            byte[] userNameBytes = unicodeName.GetBytes(userName.ToCharArray());

            byte[] finalByteArray = new byte[randNumber.Length + userNameBytes.Length];

            for (int i = 0; i < randNumber.Length; i++)
            {
                finalByteArray[i] = randNumber[i];
            }

            for (int i = 0; i < userNameBytes.Length; i++)
            {
                finalByteArray[i + randNumber.Length] = (byte)userNameBytes[i];
            }

            byte[] md5hash = md5.ComputeHash(finalByteArray);

            return Convert.ToBase64String(md5hash);
        }

    }
}
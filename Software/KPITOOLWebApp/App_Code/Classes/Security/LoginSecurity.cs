using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using log4net;
using Artexacta.App.Security.BLL;
using System.Collections;
using System.Web.Security;

namespace Artexacta.App.LoginSecurity
{
    /// <summary>
    /// Summary description for LoginSecurity
    /// </summary>
    public class LoginSecurity
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        public LoginSecurity()
        {
        }

        public static bool IsUserAuthenticated()
        {
            return HttpContext.Current.User.Identity.IsAuthenticated;
        }

        public static void EnsureUserAuthentication()
        {
            if (!IsUserAuthenticated())
            {
                log.Debug("User is not authenticated");

                // Remember where we were coming from.  The login page will direct the user to that page
                // when the user has been authenticated.
                HttpContext.Current.Session.Add("RequestPage", HttpContext.Current.Request.RawUrl);
                // Send the user to the login page.
                HttpContext.Current.Response.Redirect("~/Authentication/Login.aspx");
            }
            else
            {
                log.Debug("User is Authenticated");
            }
        }

        public static bool IsUserAdministrator()
        {
            // If the user is not authenticated, then he/she is certainly not the administrator
            if (!IsUserAuthenticated())
                return false;

            // Get the name of the account associated to an administrator
            string adminAccountName = System.Configuration.ConfigurationManager.AppSettings.Get("AdminUser");

            // If we can't determine the name, then we don't have an administrator account
            if (String.IsNullOrEmpty(adminAccountName))
                return false;

            // Get the ID of the current user.
            string currentUser = HttpContext.Current.User.Identity.Name;

            // If we can't determine the name of the current user then he certainly is not the administrator
            if (String.IsNullOrEmpty(currentUser))
                return false;

            // The current user is the administrator if these two match. 
            if (currentUser.ToUpper().Equals(adminAccountName.ToUpper()))
                return true;
            else
                return false;

        }

        public static bool IsUserAuthorizedPermission(string userName, string permissionMnemonic)
        {
            bool allowPermission = false;

            string[] rolesAllowed = null;

            try
            {
                rolesAllowed = SecurityBLL.GetRolesForPermission(permissionMnemonic);
                if (rolesAllowed != null)
                {
                    foreach (string s in rolesAllowed)
                    {
                        if (IsUserInThisRole(userName, s))
                        {
                            // User is in some authorized role.  Allow him to continue.
                            return true;
                        }
                    }
                }
            }
            catch (Exception e)
            {
                log.Error("Cannot get roles allowed for a specific permission. IsUserAuthorizedOperation from LoginSecurity", e);
            }

            if (allowPermission == false)
            {
                try
                {
                    if (IsCurrentUserAllowedToPerformPermission(userName, permissionMnemonic))
                        return true;
                }
                catch (Exception q)
                {
                    log.Error("Cannot verify if the current user is allowed to perform the given permission. IsUserAuthorizedOperation from LoginSecurity", q);
                }
            }

            return (allowPermission);
        }

        public static bool IsUserAuthorizedPermission(string permissionMnemonic)
        {
            bool allowPermission = false;

            string[] rolesAllowed = null;

            try
            {
                rolesAllowed = SecurityBLL.GetRolesForPermission(permissionMnemonic);
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
                log.Debug("Cannot get roles allowed for a specific permission. IsUserAuthorizedOperation from LoginSecurity");
            }

            if (allowPermission == false)
            {
                try
                {
                    if (IsCurrentUserAllowedToPerformPermission(permissionMnemonic))
                        return true;
                }
                catch (Exception q)
                {
                    log.Error("Cannot verify if the current user is allowed to perform the given permission.", q);
                    log.Debug("Cannot verify if the current user is allowed to perform the given permission. IsUserAuthorizedOperation from LoginSecurity");
                }
            }

            return (allowPermission);
        }

        public static bool IsUserInThisRole(string userName, string s)
        {
            bool isInDefinedRole = false;

            ArrayList roles = GetAllDefinedRoles();
            if (Roles.IsUserInRole(userName, (string)s))
            {
                isInDefinedRole = true;
            }
            return isInDefinedRole;
        }

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

        public static bool IsCurrentUserAllowedToPerformPermission(string permissionMnemonic)
        {
            return SecurityBLL.IsCurrentUserAllowedToPerformPermission(permissionMnemonic);
        }

        public static bool IsCurrentUserAllowedToPerformPermission(string userName, string permissionMnemonic)
        {
            return SecurityBLL.IsUserAllowedToPerformPermission(userName, permissionMnemonic);
        }

    }
}
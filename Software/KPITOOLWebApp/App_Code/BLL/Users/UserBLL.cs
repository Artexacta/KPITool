using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using log4net;
using Artexacta.App.User;
using UserDSTableAdapters;
using System.Web.Security;
using System.Configuration;

namespace Artexacta.App.User.BLL
{
    /// <summary>
    /// Summary description for UserBLL
    /// </summary>
    [System.ComponentModel.DataObject]
    public class UserBLL
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        UserTableAdapter _theAdapter = null;

        protected UserTableAdapter theAdapter
        {
            get
            {
                if (_theAdapter == null)
                    _theAdapter = new UserTableAdapter();
                return _theAdapter;
            }
        }

        public UserBLL()
        {
        }

        private static User FillUserRecord(UserDS.UserRow row)
        {
            User theNewRecord = new User(
                row.userId,
                row.fullname,
                row.IscellphoneNull() ? "" : row.cellphone,
                row.IsaddressNull() ? "" : row.address,
                row.IsphonenumberNull() ? "" : row.phonenumber,
                row.IsphoneareaNull() ? 0 : row.phonearea,
                row.IsphonecodeNull() ? 0 : row.phonecode,
                row.username,
                row.IsemailNull() ? "" : row.email);

            return theNewRecord;
        }

        public static User GetUserById(int IdUser)
        {
            UserTableAdapter localAdapter = new UserTableAdapter();

            if (IdUser <= 0)
                return null;

            User theUser = null;

            try
            {
                UserDS.UserDataTable table = localAdapter.GetUserById(IdUser);

                if (table != null && table.Rows.Count > 0)
                {
                    UserDS.UserRow row = table[0];
                    theUser = FillUserRecord(row);
                }
            }
            catch (Exception q)
            {
                log.Error("An error was ocurred while geting user data", q);
                return null;
            }

            return theUser;
        }

        public static User GetUserByUsername(string Username)
        {
            UserTableAdapter localAdapter = new UserTableAdapter();

            if (string.IsNullOrEmpty(Username))
                return null;

            User theUser = null;
            try
            {
                UserDS.UserDataTable table = localAdapter.GetUserByUsername(Username);

                if (table != null && table.Rows.Count > 0)
                {
                    UserDS.UserRow row = table[0];
                    theUser = FillUserRecord(row);
                }
            }
            catch (Exception q)
            {
                log.Error("An error was ocurred while geting user data", q);
            }
            return theUser;
        }

        public List<User> GetUsersListForSearch(string whereSql)
        {
            if (string.IsNullOrEmpty(whereSql))
                whereSql = "1 = 1";

            List<User> theList = new List<User>();
            User theUser = null;
            try
            {
                UserDS.UserDataTable table = theAdapter.GetUsersForSearch(whereSql);
                if (table != null && table.Rows.Count > 0)
                {
                    foreach (UserDS.UserRow row in table.Rows)
                    {
                        theUser = FillUserRecord(row);
                        theList.Add(theUser);
                    }
                }
            }
            catch (Exception exc)
            {
                log.Error("Error en GetUsersListForSearch para whereSql: " + whereSql, exc);
                throw new ArgumentException(Resources.UserData.MessageErrorGetUsersList);
            }
            return theList;
        }

        public static int GetUserIdByUsername(string username)
        {
            if (string.IsNullOrEmpty(username))
                return 0;

            try
            {
                User theUser = GetUserByUsername(username);

                if (theUser != null && theUser.UserId > 0)
                    return theUser.UserId;
                else
                    return 0;
            }
            catch (Exception q)
            {
                log.Error("An error was ocurred while geting user data", q);
                return 0;
            }
        }

        public static int InsertUserRecord(string Username, string Fullname, string Cellphone, string Address, string Phone, 
            int PhoneArea, int PhoneCode, string Email)
        {
            int? newUserId = 0;

            if (string.IsNullOrEmpty(Username))
                throw new ArgumentException("Nombre de usuario no puede ser nulo.");

            try
            {
                UserTableAdapter localAdapter = new UserTableAdapter();

                object resutl = localAdapter.InsertUserRecord(
                    string.IsNullOrEmpty(Fullname) ? "" : Fullname,
                    string.IsNullOrEmpty(Cellphone) ? "" : Cellphone,
                    string.IsNullOrEmpty(Address) ? "" : Address,
                    string.IsNullOrEmpty(Phone) ? "" : Phone,
                    PhoneArea, PhoneCode,
                    Username,
                    string.IsNullOrEmpty(Email) ? "" : Email,
                    ref newUserId);

                log.Debug("Se insertó el usuario " + Username);

                if (newUserId == null || newUserId <= 0)
                {
                    throw new Exception("SQL insertó el registro exitosamente pero retornó un status null <= 0");
                }
                return (int)newUserId;
            }
            catch (Exception q)
            {
                log.Error("An error was ocurred while inserting user", q);
                throw q;
            }
        }

        public static bool UpdateUserRecord(int Userid, string Username, string Fullname,
            string Cellphone, string Address, string Phone,
            int PhoneArea, int PhoneCode, string Email)
        {
            if (Userid <= 0)
                throw new ArgumentException("Id de usuario no puede ser <= 0");

            if (string.IsNullOrEmpty(Username))
                throw new ArgumentException("Nombre de usuario no puede ser nulo.");

            try
            {
                UserTableAdapter localAdapter = new UserTableAdapter();

                localAdapter.UpdateUserRecord(
                    string.IsNullOrEmpty(Fullname) ? "" : Fullname,
                    string.IsNullOrEmpty(Cellphone) ? "" : Cellphone,
                    string.IsNullOrEmpty(Address) ? "" : Address,
                    string.IsNullOrEmpty(Phone) ? "" : Phone,
                    PhoneArea, PhoneCode, Username, Userid,
                    string.IsNullOrEmpty(Email) ? "" : Email
                    );

                log.Debug("Se modifico el usuario " + Username);
                return true;
            }
            catch (Exception q)
            {
                log.Error("An error was ocurred while updating user", q);
                return false;
            }
        }

        public static bool DeleteUserRecord(int UserId)
        {
            if (UserId <= 0)
                throw new ArgumentException(Resources.UserData.MessageZeroUserId);

            try
            {
                UserTableAdapter localAdapter = new UserTableAdapter();
                localAdapter.DeleteUserRecord(UserId);
            }
            catch (Exception exc)
            {
                log.Error("Error en DeleteUserRecord para userId: " + UserId, exc);
                throw new ArgumentException(Resources.UserData.MessageErrorDeleteUser);
            }

            return true;
        }        

        public static void InsertUserInRoles(string Username, string Rol)
        {
            if (string.IsNullOrEmpty(Username) || string.IsNullOrEmpty(Rol))
                throw new ArgumentException("Error en los parametros de usuarios y roles.");

            try
            {
                int UserId = 0;
                User theUserClass = null;
                theUserClass = GetUserByUsername(Username);
                UserId = theUserClass.UserId;

            }
            catch (Exception q)
            {
                log.Error("An error was ocurred while deleting user", q);
                throw q;
            }
        }

        public static void DeleteUserInRoles(string Username, string Rol)
        {
            if (string.IsNullOrEmpty(Username) || string.IsNullOrEmpty(Rol))
                throw new ArgumentException("Error en los parametros de usuarios y roles.");

            try
            {
                int UserId = 0;
                User theUserClass = null;
                theUserClass = GetUserByUsername(Username);

                if (theUserClass != null)
                    UserId = theUserClass.UserId;
            }
            catch (Exception q)
            {
                log.Error("An error was ocurred while deleting user", q);
                throw q;
            }
        }

        public static int GetUserIdByEmailAddress(string EmailAddress)
        {
            UserTableAdapter localAdapter = new UserTableAdapter();

            log.Debug("Getting the user Id from data base given an email address. Function GetUserIdByEmailAddress from UserBLL");

            try
            {
                Object table = localAdapter.GeUserIdByEmail(EmailAddress);
                if (table != null)
                {
                    return Convert.ToInt32(table.ToString());
                }
            }
            catch { }

            return 0;
        }

        public List<User> GetUsersBySearchParameters(string Username, string Fullname)
        {
            List<User> theList = new List<User>();
            User theUser = null;

            if (!string.IsNullOrEmpty(Username))
            {
                Username = "%" + Username + "%";
            }
            else
            {
                Username = "";
            }

            if (!string.IsNullOrEmpty(Fullname))
            {
                Fullname = "%" + Fullname + "%";
            }
            else
            {
                Fullname = "";
            }

            try
            {
                UserDS.UserDataTable table = theAdapter.GetUsersBySearchParameters(Username, Fullname);

                if (table != null && table.Rows.Count > 0)
                {
                    foreach (UserDS.UserRow row in table.Rows)
                    {
                        theUser = FillUserRecord(row);
                        theList.Add(theUser);
                    }
                }
            }
            catch (Exception q)
            {
                log.Error("An error was ocurred while getting list of TradeUsers from data base", q);
                throw q;
            }
            return theList;
        }

        public static List<User> GetUsersForAutoComplete(string filter)
        {
            List<User> theList = new List<User>();
            User theData = null;
            try
            {
                UserTableAdapter localAdapter = new UserTableAdapter();
                UserDS.UserDataTable theTable = localAdapter.GetUsersForAutocomplete(filter);

                if (theTable != null && theTable.Rows.Count > 0)
                {
                    foreach (UserDS.UserRow theRow in theTable.Rows)
                    {
                        theData = FillUserRecord(theRow);
                        theList.Add(theData);
                    }
                }
            }
            catch (Exception exc)
            {
                throw exc;
            }
            return theList;
        }

    }
}
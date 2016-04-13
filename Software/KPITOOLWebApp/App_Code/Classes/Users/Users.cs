using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;

namespace Artexacta.App.User
{
    /// <summary>
    /// Summary description for User
    /// </summary>
    public class User
    {
        private int _userId;
        private string _fullname;
        private string _cellphone;
        private string _address;
        private string _phoneNumber;
        private int _phoneArea;
        private int _phoneCode;
        private string _username;
        private string _email;

        public User()
        { 
        }

        public User(int userId, string fullname, string cellphone, string address, string phoneNumer,
            int phoneArea, int phoneCode, string username, string email)
        {
            _userId = userId;
            _fullname = fullname;
            _cellphone = cellphone;
            _address = address;
            _phoneNumber = phoneNumer;
            _phoneArea = phoneArea;
            _phoneCode = phoneCode;
            _username = username;
            _email = email;
        }

        public int UserId
        {
            get { return this._userId; }
            set { this._userId = value; }
        }
        public string FullName
        {
            get { return this._fullname; }
            set { this._fullname = value; }
        }
        public string CellPhone
        {
            get { return this._cellphone; }
            set { this._cellphone = value; }
        }
        public string Address
        {
            get { return this._address; }
            set { this._address = value; }
        }
        public string PhoneNumber
        {
            get { return this._phoneNumber; }
            set { this._phoneNumber = value; }
        }
        public int PhoneArea
        {
            get { return this._phoneArea; }
            set { this._phoneArea = value; }
        }
        public int PhoneCode
        {
            get { return this._phoneCode; }
            set { this._phoneCode = value; }
        }
        public string Username
        {
            get { return this._username; }
            set { this._username = value; }
        }
        public string Email
        {
            get { return this._email; }
            set { this._email = value; }
        }
        
        public bool IsAproved
        {
            get
            {
                MembershipUserCollection MemUser = Membership.FindUsersByName(_username);

                if (MemUser.Count <= 0)
                    return false;

                MembershipUser theUser = MemUser[_username];
                if (theUser != null)
                    return theUser.IsApproved;
                else
                    return false;
            }

        }
        public bool IsBlocked
        {
            get
            {
                MembershipUserCollection MemUser = Membership.FindUsersByName(_username);

                if (MemUser.Count <= 0)
                    return false;

                MembershipUser theUser = MemUser[_username];
                if (theUser != null)
                    return theUser.IsLockedOut;
                else
                    return false;
            }

        }
        public bool IsOnline
        {
            get
            {
                MembershipUserCollection MemUser = Membership.FindUsersByName(_username);

                if (MemUser.Count <= 0)
                    return false;

                MembershipUser theUser = MemUser[_username];
                if (theUser != null)
                    return theUser.IsOnline;
                else
                    return false;
            }

        }
    }
}
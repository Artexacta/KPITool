using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.Role
{
    /// <summary>
    /// Summary description for Role
    /// </summary>
    public class Role
    {
        private string _roleName;

        public Role()
        {
        }

        public Role(string roleName)
        {
            this._roleName = roleName;
        }

        public string RoleName
        {
            get { return this._roleName; }
        }
    }
}
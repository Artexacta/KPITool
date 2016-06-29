using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for Organization
/// </summary>
/// 
namespace Artexacta.App.Organization
{
    public class Organization
    {
        public int OrganizationID { get; set; }
        public string Name { get; set; }
        public bool IsOwner { get; set; }

        public Organization()
        {
        }

        public Organization(int organizationId, string name)
        {
            OrganizationID = organizationId;
            Name = name;
        }
    }
}
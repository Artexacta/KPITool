using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.People
{
    /// <summary>
    /// Summary description for People
    /// </summary>
    public class People
    {
        private int _personId;
        private string _id;
        private string _name;
        private int _organizationId;
        private int _areaId;

        public People()
        {
        }

        public People(int personId, string id, string name, int organizationId, int areaId)
        {
            this._personId = personId;
            this._id = id;
            this._name = name;
            this._organizationId = organizationId;
            this._areaId = areaId;
        }

        public int PersonId
        {
            get { return _personId; }
            set { _personId = value; }
        }

        public string Id
        {
            get { return _id; }
            set { _id = value; }
        }

        public string Name
        {
            get { return _name; }
            set { _name = value; }
        }

        public int OrganizationId
        {
            get { return _organizationId; }
            set { _organizationId = value; }
        }

        public int AreaId
        {
            get { return _areaId; }
            set { _areaId = value; }
        }
        
    }
}
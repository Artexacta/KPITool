using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for Trash
/// </summary>
/// 
namespace Artexacta.App.Trash
{
    public class Trash
    {
        public int ObjectId { get; set; }
        public string Name { get; set; }
        public DateTime DateDelete { get; set; }
        public string User { get; set; }

        public Trash()
        {
        }

        public Trash(int objectId, string name, DateTime dateDelete, string user)
        {
            ObjectId = objectId;
            Name = name;
            DateDelete = dateDelete;
            User = user;
        }
    }
}
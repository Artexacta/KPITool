using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

namespace Artexacta.App.GenericObjects
{
    /// <summary>
    /// Defines a generic Object that is security aware
    /// </summary>
    public abstract class GenericObject
    {
        /// <summary>
        /// Specifies the type of the object
        /// </summary>
        public enum ObjectType
        {
            Inmueble, Contribuyente
        };

        /// <summary>
        /// Defines the unique object Id for the object type
        /// </summary>
        private int objectId;
        private int ownerId;

        /// <summary>
        /// Uniquely identifies the object
        /// </summary>
        public int ObjectId
        {
            get { return objectId; }
            set { objectId = value; }
        }

        /// <summary>
        /// Identifies the owner of the object
        /// </summary>
        public int OwnerId
        {
            get { return ownerId; }
            set { ownerId = value; }
        }

        /// <summary>
        /// Gets the type of the object
        /// </summary>
        protected abstract ObjectType ThisObjectType
        {
            get;
        }

        /// <summary>
        /// Construct a generic object
        /// </summary>
        public GenericObject()
        {
        }

        /// <summary>
        /// Construct a generic object
        /// </summary>
        /// <param name="objectId">The Id of the object.  A value of 0 means that the object does not have an Id yet</param>
        /// <param name="ownerId">The owner Id (userId) for the object</param>
        public GenericObject(int objectId, int ownerId)
        {
            ObjectId = objectId;
            OwnerId = ownerId;
        }

        /// <summary>
        /// Given a string, it returns a object type for the string.
        /// </summary>
        /// <param name="theType">The type as a string</param>
        /// <returns>The corresponding object type</returns>
        /// <exception cref="ArgumentException">If the string does not correspond to a valid object type</exception>
        public static ObjectType GetObjectTypeFromString(string theType)
        {
            return (ObjectType)Enum.Parse(typeof(ObjectType), theType, true);
        }

        /// <summary>
        /// Gets the object type localized so it can be displayed
        /// </summary>
        /// <param name="theObjectType">The object type</param>
        /// <returns>The localized string that corresponds to the type</returns>
        public static string GetObjectTypeForDisplay(ObjectType theObjectType)
        {

            //TODO:  FIX THIS SO ALL THE TYPES ARE IMPLEMENTED

            string typeAsString = "";
            switch (theObjectType)
            {
                case ObjectType.Contribuyente:
                    typeAsString = "Contribuyente";
                    break;
                case ObjectType.Inmueble:
                    typeAsString = "Inmueble";
                    break;
            }
            return typeAsString;
        }

        /// <summary>
        /// Determines if the a string corresponds to a valid object type in the system
        /// </summary>
        /// <param name="theStringType">The string with the alleged type</param>
        /// <returns>True if the string is a valid type, false otherwise</returns>
        public static bool IsStringAValidObjectType(string theStringType)
        {
            try
            {
                ObjectType x = (ObjectType)Enum.Parse(typeof(ObjectType), theStringType, true);
                return true;
            }
            catch
            {
                return false;
            }
        }
    }
}
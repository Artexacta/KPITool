using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using log4net;
using DocumentDSTableAdapters;
using Artexacta.App.Document;
using Artexacta.App.GenericObjects;

namespace Artexacta.App.Document.BLL
{
    /// <summary>
    /// Summary description for DocumentBLL
    /// </summary>
    [System.ComponentModel.DataObject]
    public class DocumentBLL
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        DocumentTableAdapter _theAdapter = null;

        private DocumentTableAdapter theAdapter
        {
            get
            {
                if (_theAdapter == null)
                    _theAdapter = new DocumentTableAdapter();
                return _theAdapter;
            }
        }

        public DocumentBLL()
        {
        }

        /// <summary>
        /// Converts the DataTable data in object Document
        /// </summary>
        /// <param name="row">The DataTable row</param>
        /// <returns>A Document</returns>
        private static Document FillRecord(DocumentDS.DocumentRow row)
        {
            Document theNewRecord = new Document(
                row.documentID,
                row.fileStoragePath,
                row.objectTypeID,
                row.objectID,
                row.title);

            return theNewRecord;
        }

        ///// <summary>
        ///// Get a Image Object given the object type and object ID
        ///// </summary>
        ///// <param name="name">objectid, objecttype</param>
        ///// <returns>A Image Object</returns>
        //public static ImageObject GetImageDetails(int objectID, string objectTypeID)
        //{
        //    ImageObject theClass = null;

        //    ImageTableAdapter localAdapter = new ImageTableAdapter();

        //    try
        //    {
        //        ImageDS.ImageDataTable table =
        //            localAdapter.GetImagesByObject(objectID, objectTypeID);

        //        if (table != null && table.Rows.Count > 0)
        //        {
        //            theClass = FillRecord(table[0]);
        //        }
        //    }
        //    catch (Exception q)
        //    {
        //        log.Error("An error was ocurred while getting the Image Record", q);
        //        return null;
        //    }
        //    return theClass;
        //}

        ///// <summary>
        ///// Get a Image Object given the image ID
        ///// </summary>
        ///// <param name="name">imageid</param>
        ///// <returns>A Image Object</returns>
        //public static ImageObject GetImageDetails(int imageID)
        //{
        //    ImageObject theClass = null;

        //    ImageTableAdapter localAdapter = new ImageTableAdapter();

        //    try
        //    {
        //        ImageDS.ImageDataTable table =
        //            localAdapter.GetImageDetails(imageID);

        //        if (table != null && table.Rows.Count > 0)
        //        {
        //            theClass = FillRecord(table[0]);
        //        }
        //    }
        //    catch (Exception q)
        //    {
        //        log.Error("An error was ocurred while getting the Image Record", q);
        //        return null;
        //    }
        //    return theClass;
        //}

        /// <summary>
        /// Get a list of Document
        /// </summary>        
        /// <returns>A list of Document</returns>
        public List<Document> GetDocumentsByObject(int objectID, string objectTypeID)
        {
            List<Document> theList = new List<Document>();
            Document theClass = null;
            
            try
            {
                DocumentDS.DocumentDataTable table =
                    theAdapter.GetDocumentsByObject(objectID, objectTypeID);

                if (table != null && table.Rows.Count > 0)
                {
                    foreach (DocumentDS.DocumentRow row in table.Rows)
                    {
                        theClass = FillRecord(row);
                        theList.Add(theClass);
                    }
                }
            }
            catch (Exception q)
            {
                log.Error("An error was ocurred while getting list of Documents By Object from data base", q);
                return null;
            }
            return theList;
        }

        public static bool DeleteDocument(int documentID)
        {
            if (documentID <= 0)
            {
                throw new ArgumentException("The Document ID cannot be equal or less than 0");
            }

            try
            {
                DocumentTableAdapter localAdapter = new DocumentTableAdapter();

                localAdapter.DeleteDocument(documentID);

                log.Debug("The Document with ID " + documentID.ToString() + " was deleted.");
                return true;
            }
            catch (Exception q)
            {
                log.Error("An error ocurred trying to delete the  Document with ID " + documentID.ToString(), q);
                return false;
            }
        }

        public static bool InsertObjectDocument(int objectID, string objectTypeID, int fileID)
        {
            if (fileID <= 0)
            {
                throw new ArgumentException("The File ID cannot be equal or less than 0");
            }

            if (objectID <= 0)
            {
                throw new ArgumentException("The Object ID cannot be equal or less than 0");
            }

            if (objectTypeID.ToUpper() != GenericObject.ObjectType.Contribuyente.ToString().ToUpper() &&
                objectTypeID.ToUpper() != GenericObject.ObjectType.Inmueble.ToString().ToUpper())
            {
                throw new ArgumentException("The Object Type ID must be Product or Service.");
            }

            try
            {
                DocumentTableAdapter localAdapter = new DocumentTableAdapter();

                localAdapter.InsertObjectDocument(objectID, objectTypeID, fileID);

                log.Debug("The Document was inserted for the " + objectTypeID.ToUpper() + " with ID " + objectID.ToString());
                return true;
            }
            catch (Exception q)
            {
                log.Error("An error ocurred trying to insert the Docuemtn for the " + objectTypeID.ToUpper() + " with ID " + objectID.ToString(), q);
                return false;
            }
        }
    
    }
}
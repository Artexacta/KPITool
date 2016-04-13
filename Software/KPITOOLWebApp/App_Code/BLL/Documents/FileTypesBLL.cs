using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Collections.Generic;
using Artexacta.App.Documents;
using log4net;
using System.Collections;

namespace Artexacta.App.Documents.BLL
{
    /// <summary>
    /// BLL Methods for loading file types
    /// </summary>
    [System.ComponentModel.DataObject]
    public class FileTypesBLL
    {
        private static List<FileType> theFilesTypes = null;
        private static Hashtable theFilesTypesExtensionHash = null;

        private static readonly ILog log = LogManager.GetLogger("Standard");

        public FileTypesBLL()
        {
        }

        /// <summary>
        /// Get a list of file types for the system
        /// </summary>
        /// <param name="forceLoad">True if the list should be reloaded, even if we already have it</param>
        /// <returns>A list of the file types allowed.</returns>
        private static List<FileType> GetFileTypes(bool forceLoad)
        {
            if (theFilesTypes != null && !forceLoad)
            {
                // We don't load this twice.  This is loaded only once in the application. 
                return theFilesTypes;
            }

            // Load or re-load the list

            log.Debug("Cargando file types");

            theFilesTypes = new List<FileType>();

            try
            {
                string fileTypeFileName = Resources.Files.FileTypesFileLocation;

                if (log.IsDebugEnabled)
                {
                    log.Debug("Cargando file types desde " + fileTypeFileName);
                }

                DataSet theFileTypesDataSet = new DataSet();
                theFileTypesDataSet.ReadXml(HttpContext.Current.Server.MapPath(fileTypeFileName));
                if (theFileTypesDataSet.Tables != null &&
                    theFileTypesDataSet.Tables.Count == 1 && theFileTypesDataSet.Tables[0].Rows != null &&
                    theFileTypesDataSet.Tables[0].Rows.Count > 0)
                {
                    for (int i = 0; i < theFileTypesDataSet.Tables[0].Rows.Count; i++)
                    {
                        FileType newType = new FileType(
                            theFileTypesDataSet.Tables[0].Rows[i]["extension"].ToString(),
                            theFileTypesDataSet.Tables[0].Rows[i]["description"].ToString(),
                            theFileTypesDataSet.Tables[0].Rows[i]["icon"].ToString(),
                            theFileTypesDataSet.Tables[0].Rows[i]["medIcon"].ToString(),
                            theFileTypesDataSet.Tables[0].Rows[i]["largeIcon"].ToString(),
                            theFileTypesDataSet.Tables[0].Rows[i]["customIcon"].ToString(),
                            theFileTypesDataSet.Tables[0].Rows[i]["medCustomIcon"].ToString(),
                            theFileTypesDataSet.Tables[0].Rows[i]["largeCustomIcon"].ToString(),
                            theFileTypesDataSet.Tables[0].Rows[i]["provider"].ToString(),
                            Convert.ToBoolean(theFileTypesDataSet.Tables[0].Rows[i]["image"].ToString()));

                        if (log.IsDebugEnabled)
                        {
                            log.Debug("Cargado FileType " + newType.Extension + " - " + newType.Description);
                        }

                        theFilesTypes.Add(newType);
                    }
                }
            }
            catch (Exception e)
            {
                log.Error("Failed to read file types data set", e);
            }

            if (log.IsDebugEnabled)
            {
                log.Debug("Se cargaron " + theFilesTypes.Count.ToString() + " FileTypes");
            }

            return theFilesTypes;
        }

        /// <summary>
        /// Get a hash table indexed by extension of all file types allowed in the system
        /// </summary>
        /// <returns>A hash table with all the file types, indexed by exension</returns>
        public static Hashtable GetFileTypesExtensionHash()
        {
            if (theFilesTypesExtensionHash == null)
            {
                // Create the hashtable of all file types by extension
                theFilesTypesExtensionHash = new Hashtable();
                List<FileType> theFileTypes = GetFileTypes(true);
                for (int i = 0; i < theFilesTypes.Count; i++)
                {
                    theFilesTypesExtensionHash.Add(theFileTypes[i].Extension.ToUpper(), theFileTypes[i]);
                }
            }

            return theFilesTypesExtensionHash;
        }

        /// <summary>
        /// Get a list of image file types
        /// </summary>
        /// <returns></returns>
        public static List<FileType> GetImageFileTypes()
        {
            List<FileType> theList = new List<FileType>();
            List<FileType> theCompleteList = new List<FileType>();
            theCompleteList = GetFileTypes(false);
            foreach (FileType theFile in theCompleteList)
            {
                if (theFile.Image)
                {
                    theList.Add(theFile);
                }
            }
            return theList;
        }

        /// <summary>
        /// Get a list of file types for display in the form Type (extension)
        /// </summary>
        /// <param name="includeAllItem">True if we should include the [All] element at the head</param>
        public static List<FileTypeForDisplay> GetFileTypesForList(bool includeAllItem)
        {
            List<FileTypeForDisplay> theList = new List<FileTypeForDisplay>();
            if (includeAllItem)
            {
                theList.Add(new FileTypeForDisplay(Resources.Glossary.AllLabel, ""));
            }

            List<FileType> theTypes = GetFileTypes(false);
            for (int i = 0; i < theTypes.Count; i++)
            {
                theList.Add(new FileTypeForDisplay(theTypes[i].Description + " (" + theTypes[i].Extension + ")", theTypes[i].Extension));
            }

            return theList;
        }

    }
}

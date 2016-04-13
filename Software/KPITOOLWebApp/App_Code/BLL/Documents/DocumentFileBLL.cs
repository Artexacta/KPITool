using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using log4net;
using Artexacta.App.Documents;
using System.Collections.Generic;
using System.Collections;
using System.Text;
using System.IO;
using Artexacta.App.Utilities.Document;
using DocumentFileDSTableAdapters;
using Artexacta.App.Configuration;

namespace Artexacta.App.Documents.BLL
{
    /// <summary>
    /// Utility functions for the BLL layer of the DocumentFile classes
    /// </summary>
    [System.ComponentModel.DataObject]
    public class DocumentFileBLL
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        public DocumentFileBLL()
        {
        }

        public static void CleanupDirtyFiles()
        {
            List<string> filesToClean = new List<string>();

            try
            {
                DocumentFileDSTableAdapters.DirtyFilesTableAdapter ta =
                    new DirtyFilesTableAdapter();

                DocumentFileDS.DirtyFilesDataTable table = ta.CleanupDirtyFiles();
                foreach (DocumentFileDS.DirtyFilesRow row in table)
                    filesToClean.Add(row.fileStoragePath);
            }
            catch (Exception q)
            {
                log.Error("Failed to get from database a list of files to clean", q);
            }

            foreach (string fileName in filesToClean)
            {
                try
                {
                    FileInfo theFileInfo = new FileInfo(fileName);
                    theFileInfo.Delete();
                }
                catch (Exception q)
                {
                    log.Error("Failed to delete dirty file " + fileName + ".  Please delete this file by hand.", q);
                }
            }
        }

        public static void MarkDocumentFileNonDirty(int documentFileID)
        {
            DocumentFileDSTableAdapters.FileInfoTableAdapter ta =
                new FileInfoTableAdapter();

            ta.MarkFileNonDirty(documentFileID);
        }

        /// <summary>
        /// Create a new file
        /// </summary>
        /// <param name="theDocumentFile">The file data</param>
        /// <param name="fileStoragePath">Returns the path where the file was actually stored</param>
        /// <param name="isDirty">Specifies if the file should be marked as Dirty in the database</param>
        /// <returns>Returns the resulting ID for the file</returns>
        /// <exception cref="ArgumentException">If the arguments are invalid</exception>
        public static int CreateDocumentFile(DocumentFile theDocumentFile, ref string fileStoragePath, bool isDirty)
        {

            // We create the file in two steps:  Step one is to save the document to the databse and step two is 
            // to save the actual binary data to the disk.  
            // We do this because we avoid loading the database with gigabytes of data, that we can dumpt to disk.  This
            // is necessary because there are cases where hosting providers will charge much more for database space than
            // disk space and because there are free version of SQL Server that have limitations as to the amount of data
            // that can be stored.  Hence, we avoid dumping into the databse content that is not going to be used 
            // in actual queries.  here is a downside to this.  Because the database records are not in the same space
            // than the files themselves, it's possible that files may be deleted and create inconsistencies with the database.

            string destinationDirectory = Artexacta.App.Configuration.Configuration.GetDocumentStorageDirectory();
            if (String.IsNullOrEmpty(destinationDirectory))
            {
                log.Error("Undefined Document Storage Directory in WebConfig.");
                throw new Exception("Undefined Document Storage Directory in WebConfig.");
            }

            // Make sure that the storage directory exists and that we can operate there
            DirectoryInfo dirInfo = new DirectoryInfo(destinationDirectory);
            if (!dirInfo.Exists)
            {
                log.Error("Document Storage Directory defined does not exist: " + destinationDirectory);
                throw new Exception("Document Storage Directory defined does not exist.");
            }



            ///*********************************************************************
            //////*********************************************************************
            ///*********************************************************************
            //////*********************************************************************
            ///*********************************************************************
            ///
            //create subfolders system to storage files
            ///*********************************************************************
            //////*********************************************************************
            ///*********************************************************************
            //////*********************************************************************
            ///*********************************************************************

            //Files in the system are stored in only one folder. This should be changed to the following: 
            //every file should be stored in a folder named YYYY/MM/DD/HH 
            //(i.e. the date + the hour.  ST does not allow slashes, but this is a hierarchical system. 
            //There is a folder YYYY and a subfolder MM and a subfolder DD and a subfolder HH). 
            //The strategy is as follows: when a new file has to be stored, it will check if the corresponding folder exists, 
            //if it doesnt it creates the folder and stores the file there. This is to avoid having millions of files in ONE folder (which is painful in windows system files).



            // Make sure that the year storage directory exists and that we can operate there
            string year = DateTime.Now.Year.ToString();

            DirectoryInfo dirInfoYear = new DirectoryInfo(destinationDirectory + "//" + year);
            if (!dirInfoYear.Exists)
            {
                log.Debug("Document Storage Directory for year " + year + " does not exist. It will be created.");

                try
                {
                    dirInfoYear.Create();
                }
                catch (Exception q)
                {
                    log.Error("Couldn't create the directory for the year " + year + ". ", q);
                    throw new Exception("Couldn't create the directory for the year " + year + ". Error: " + q.Message);
                }
            }

            // Make sure that the month storage directory exists and that we can operate there
            string month = DateTime.Now.Month.ToString();

            DirectoryInfo dirInfoMonth = new DirectoryInfo(destinationDirectory + "//" + year + "//" + month);
            if (!dirInfoMonth.Exists)
            {
                log.Debug("Document Storage Directory for year " + year + " and month " + month + " does not exist. It will be created.");

                try
                {
                    dirInfoMonth.Create();
                }
                catch (Exception q)
                {
                    log.Error("Couldn't create the directory for the year " + year + " and month " + month + ". ", q);
                    throw new Exception("Couldn't create the directory for the year " + year + " and month " + month + ". Error: " + q.Message);
                }
            }

            // Make sure that the day storage directory exists and that we can operate there
            string day = DateTime.Now.Day.ToString();

            DirectoryInfo dirInfoDay = new DirectoryInfo(destinationDirectory + "//" + year + "//" + month + "//" + day);
            if (!dirInfoDay.Exists)
            {
                log.Debug("Document Storage Directory for year " + year + ", month " + month + " and day "+day+" does not exist. It will be created.");

                try
                {
                    dirInfoDay.Create();
                }
                catch (Exception q)
                {
                    log.Error("Couldn't create the directory for the year " + year + ", month " + month + " and day " + day + ". ", q);
                    throw new Exception("Couldn't create the directory for the year " + year + ", month " + month + " and day " + day + ". Error: " + q.Message);
                }
            }

            // Make sure that the hour storage directory exists and that we can operate there
            string hour = DateTime.Now.Hour.ToString();

            DirectoryInfo dirInfoHour = new DirectoryInfo(destinationDirectory + "//" + year + "//" + month + "//" + day + "//" + hour);
            if (!dirInfoHour.Exists)
            {
                log.Debug("Document Storage Directory for year " + year + ", month " + month + ", day " + day + " and hour " + hour + " does not exist. It will be created.");

                try
                {
                    dirInfoHour.Create();
                }
                catch (Exception q)
                {
                    log.Error("Couldn't create the directory for the year " + year + ", month " + month + ", day " + day + " and hour " + hour + ". ", q);
                    throw new Exception("Couldn't create the directory for the year " + year + ", month " + month + ", day " + day + " and hour " + hour + ". Error: " + q.Message);
                }
            }
            
            //Final directory
            dirInfo = dirInfoHour;

            // Try to get a random file name and save the file to disk. We will try three times.
            string fileName = "";
            bool success = false;
            for (int i = 0; i < 3; i++)
            {
                BinaryWriter writer = null;
                try
                {
                    fileName = dirInfo.FullName + "\\" + Path.GetRandomFileName();

                    FileInfo newFileInfo = new FileInfo(fileName);
                    if (newFileInfo.Exists)
                        continue;

                    writer = new BinaryWriter(new FileStream(fileName, FileMode.Create, FileAccess.Write));

                    writer.Write(theDocumentFile.Bytes);
                    writer.Close();
                    success = true;
                    break;
                }
                catch (Exception q)
                {
                    log.Error("Failed to save file to disk", q);
                    if (writer != null)
                        writer.Close();
                }
            }

            if (!success)
                throw new Exception("Error creating actual physical file. Tried three times and failed");

            int? fileID = 0;

            try
            {
                //int? documentID = null;
                //int? documentVersion = null;

                //if (theDocumentFile.DocumentID > 0 && theDocumentFile.Version > 0)
                //{
                //    documentID = theDocumentFile.DocumentID;
                //    documentVersion = theDocumentFile.Version;
                //}

                DocumentFileDSTableAdapters.FileInfoTableAdapter ta = new DocumentFileDSTableAdapters.FileInfoTableAdapter();
                if (isDirty)
                    ta.InsertDirtyFile(
                        theDocumentFile.Title,
                        theDocumentFile.DateUploaded,
                        theDocumentFile.Size,
                        theDocumentFile.Name,
                        theDocumentFile.Extension,
                        fileName,
                        string.IsNullOrEmpty(theDocumentFile.Text) ? "" : theDocumentFile.Text,
                        ref fileID
                        );
                else
                    ta.InsertNonDirtyFile(
                        theDocumentFile.Title,
                        theDocumentFile.DateUploaded,
                        theDocumentFile.Size,
                        theDocumentFile.Name,
                        theDocumentFile.Extension,
                        fileName,
                        string.IsNullOrEmpty(theDocumentFile.Text) ? "" : theDocumentFile.Text,
                        ref fileID
                        );
            }
            catch (Exception q)
            {
                log.Error("Failed to save a file to the database", q);

                // We failed to save to the the database. We should get rid of the file.
                try
                {
                    FileInfo newFileInfo = new FileInfo(fileName);
                    newFileInfo.Delete();
                }
                catch (Exception qr)
                {
                    // Tried to delete it but I can't.  Nothing we cn do.
                    log.Error("Failed to delete a file past a faield database insert.  Delete file by hand? : " + fileName, qr);
                }
            }

            fileStoragePath = fileName;
            return fileID.Value;
        }

        /// <summary>
        /// Delete a file
        /// </summary>
        /// <param name="theDocumentFile">The file to delete</param>
        public static void DeleteDocumentFile(DocumentFile theDocumentFile)
        {
            if (theDocumentFile == null)
            {
                throw new ArgumentException("Document File cannot be null");
            }
            if (theDocumentFile.FileID == 0)
            {
                throw new ArgumentException("Document file ID cannot be null");
            }

            DeleteDocumentFile(theDocumentFile.FileID);
        }

        /// <summary>
        /// Delete a file
        /// </summary>
        /// <param name="documentFileID">The file to delete</param>
        public static void DeleteDocumentFile(int documentFileID)
        {
            if (documentFileID <= 0)
            {
                throw new ArgumentException("Invalid file ID.  Should be > 0.  Got " + documentFileID);
            }

            DocumentFileDSTableAdapters.FileInfoTableAdapter ta = new DocumentFileDSTableAdapters.FileInfoTableAdapter();
            ta.DeleteFile(documentFileID);
        }

        /// <summary>
        /// Get the binary data for a document
        /// </summary>
        /// <param name="theDocumentFileID">The ID for the document</param>
        /// <returns>The binary data for the file</returns>
        public static byte[] GetFileBinaryData(int theDocumentFileID)
        {
            byte[] theBytes = null;

            DocumentFile theFile = GetDocumentFile(theDocumentFileID);
            if (theFile == null)
                throw new ArgumentException("Could not find specified File in the database");

            FileStream theStream = null;

            try
            {
                theStream = new FileStream(theFile.FileStoragePath, FileMode.Open, FileAccess.Read);
                theBytes = FileUtilities.ReadFully(theStream);
                theStream.Close();
            }
            catch (Exception q)
            {
                log.Error("Failed to read a file from disk", q);
                if (theStream != null)
                    theStream.Close();
                throw q;
            }

            return theBytes;
        }

        /// <summary>
        /// Get the textual representation for the file
        /// </summary>
        /// <param name="theDocumentFile">The ID of the file</param>
        /// <returns>The textual representation of the file</returns>
        public static string GetFileTextualData(int theDocumentFileID)
        {
            string theResults = null;

            if (theDocumentFileID <= 0)
            {
                throw new ArgumentException("Invalid document file ID. Must be > 0");
            }

            DocumentFileDSTableAdapters.FileTextTableAdapter theAdapter =
                new DocumentFileDSTableAdapters.FileTextTableAdapter();
            DocumentFileDS.FileTextDataTable theTable =
                theAdapter.GetFileText(theDocumentFileID);

            if (theTable.Count > 0)
            {
                theResults = theTable[0].documentText;
            }
            else
            {
                throw new Exception("SQL Query resulted in zero rows for binary data for file");
            }

            return theResults;
        }

        /// <summary>
        /// Get a specific document file form the database
        /// </summary>
        /// <param name="documentID">The ID of the document file</param>
        /// <returns>A data file object with the file data</returns>
        public static DocumentFile GetDocumentFile(int documentFileID)
        {
            if (documentFileID <= 0)
            {
                throw new ArgumentException("Invalid document file ID. Must be > 0");
            }

            DocumentFileDSTableAdapters.FileInfoTableAdapter theAdapter =
                new DocumentFileDSTableAdapters.FileInfoTableAdapter();

            DocumentFileDS.FileInfoDataTable theTable =
                theAdapter.GetBasicFileData(documentFileID);

            DocumentFile theResult = null;

            if (theTable.Count > 0)
            {
                theResult = DocumentFile.CreateNewTypedDocumentFileObject(
                    theTable[0].fileID,
                    theTable[0].uploadedOn,
                    theTable[0].fileSize,
                    theTable[0].fileName,
                    theTable[0].extension,
                    theTable[0].title,
                    theTable[0].fileStoragePath
                    );
            }
            else
            {
                log.Error("SQL Query resulted in zero rows for the file");
                return null;
            }

            return theResult;
        }

        /// <summary>
        /// Update the document text for a document file in the database
        /// </summary>
        /// <param name="documentFileID">The document file ID</param>
        /// <param name="newText">The new text</param>
        public static void UpdateDocumentFileText(int documentFileID, string title, string newText)
        {
            if (documentFileID <= 0)
            {
                throw new ArgumentException("Invalid document file ID. Must be > 0");
            }

            if (newText == null)
            {
                throw new ArgumentException("Invalid null text for document file " + documentFileID.ToString());
            }

            DocumentFileDSTableAdapters.FileInfoTableAdapter ta =
                new DocumentFileDSTableAdapters.FileInfoTableAdapter();

            ta.UpdateFile(documentFileID, title, newText);
        }

        public static bool UpdateDocumentFileTitle(int documentFileID, string title)
        {
            if (documentFileID <= 0)
            {
                throw new ArgumentException("Invalid document file ID. Must be > 0");
            }         

            DocumentFileDSTableAdapters.FileInfoTableAdapter ta =
                new DocumentFileDSTableAdapters.FileInfoTableAdapter();

            try
            {
                ta.UpdateFileTitle(documentFileID, title);
            }
            catch (Exception q)
            {
                log.Error("Failed to update file title", q);
                return false;
            }

            return true;
        }

        public List<DocumentFile> GetFilesByIdList(string fileIdList)
        {
            if (string.IsNullOrEmpty(fileIdList))
            {
                return null;
            }
            DocumentFileDSTableAdapters.FileInfoTableAdapter ta =
                new DocumentFileDSTableAdapters.FileInfoTableAdapter();

            DocumentFileDS.FileInfoDataTable table = ta.GetFilesByIdList(fileIdList);

            List<DocumentFile> fileList = new List<DocumentFile>();

            if (table.Count > 0)
            {
                foreach (DocumentFileDS.FileInfoRow row in table)
                {
                    fileList.Add(DocumentFile.CreateNewTypedDocumentFileObject(
                        row.fileID,
                        row.uploadedOn,
                        row.fileSize,
                        row.fileName,
                        row.extension,
                        row.title,
                        row.fileStoragePath));
                }
            }

            return fileList;
        }

        public List<DocumentFile> GetDocumentFilesByObject(int objectID, string objectTypeID)
        {
            if (objectID <= 0)
            {
                return null;
            }

            if (string.IsNullOrEmpty(objectTypeID))
            {
                return null;
            }
            DocumentFileDSTableAdapters.FileInfoTableAdapter ta =
                new DocumentFileDSTableAdapters.FileInfoTableAdapter();

            DocumentFileDS.FileInfoDataTable table = ta.GetDocumentFilesByObject(objectID, objectTypeID);

            List<DocumentFile> fileList = new List<DocumentFile>();

            if (table.Count > 0)
            {
                foreach (DocumentFileDS.FileInfoRow row in table)
                {
                    fileList.Add(DocumentFile.CreateNewTypedDocumentFileObject(
                        row.fileID,
                        row.uploadedOn,
                        row.fileSize,
                        row.fileName,
                        row.extension,
                        row.title,
                        row.fileStoragePath));
                }
            }

            return fileList;

        }

        public List<DocumentFile> GetFilesByPublicReplyRequest(int replyId, int requestId)
        {
            DocumentFileDSTableAdapters.FileInfoTableAdapter ta =
                new DocumentFileDSTableAdapters.FileInfoTableAdapter();

            DocumentFileDS.FileInfoDataTable table = ta.GetFilesByPublicReplyRequest(replyId, requestId);

            List<DocumentFile> fileList = new List<DocumentFile>();

            if (table.Count > 0)
            {
                foreach (DocumentFileDS.FileInfoRow row in table)
                {
                    fileList.Add(DocumentFile.CreateNewTypedDocumentFileObject(
                        row.fileID,
                        row.uploadedOn,
                        row.fileSize,
                        row.fileName,
                        row.extension,
                        row.title,
                        row.fileStoragePath));
                }
            }

            return fileList;
        }

        public List<DocumentFile> GetFilesByReplyRequest(int replyId, int requestId)
        {
            DocumentFileDSTableAdapters.FileInfoTableAdapter ta =
                new DocumentFileDSTableAdapters.FileInfoTableAdapter();

            DocumentFileDS.FileInfoDataTable table = ta.GetFilesByReplyRequest(replyId, requestId);

            List<DocumentFile> fileList = new List<DocumentFile>();

            if (table.Count > 0)
            {
                foreach (DocumentFileDS.FileInfoRow row in table)
                {
                    fileList.Add(DocumentFile.CreateNewTypedDocumentFileObject(
                        row.fileID,
                        row.uploadedOn,
                        row.fileSize,
                        row.fileName,
                        row.extension,
                        row.title,
                        row.fileStoragePath));
                }
            }

            return fileList;
        }

        public static string GetFileName(int fileId)
        {
            string fileName = "";
            try
            {
                DocumentFile theFile = null;
                theFile = GetDocumentFile(fileId);
                fileName = theFile.Name;
            }
            catch (Exception q)
            {
                log.Error("Unable to retrieve the file for the document. File Id: " + fileId.ToString(), q);
            }

            return fileName;
        }

        public List<DocumentFile> GetAllFiles()
        {            
            DocumentFileDSTableAdapters.FileInfoTableAdapter ta =
                new DocumentFileDSTableAdapters.FileInfoTableAdapter();

            DocumentFileDS.FileInfoDataTable table = ta.GetAllFiles();

            List<DocumentFile> fileList = new List<DocumentFile>();

            if (table.Count > 0)
            {
                foreach (DocumentFileDS.FileInfoRow row in table)
                {
                    fileList.Add(DocumentFile.CreateNewTypedDocumentFileObject(
                        row.fileID,
                        row.uploadedOn,
                        row.fileSize,
                        row.fileName,
                        row.extension,
                        row.title,
                        row.fileStoragePath));
                }
            }

            return fileList;

        }

        /// <summary>
        /// Update the storage path oh the file in the database
        /// </summary>
        /// <param name="documentFileID">The document file ID</param>
        /// <param name="newText">The new storage path</param>
        public static bool UpdateDocumentFileStoragePath(int documentFileID, string storagePath)
        {
            if (documentFileID <= 0)
            {
                throw new ArgumentException("Invalid document file ID. Must be > 0");
            }

            if (storagePath == null)
            {
                throw new ArgumentException("Invalid null storage path for document file " + documentFileID.ToString());
            }

            DocumentFileDSTableAdapters.FileInfoTableAdapter ta =
                new DocumentFileDSTableAdapters.FileInfoTableAdapter();

            ta.UpdatePathStorageFile(documentFileID, storagePath);

            return true;
        }

        public static List<DocumentFile> GetFilesByStorageFolder(string folderName)
        {
            if (string.IsNullOrEmpty(folderName))
            {
                return null;
            }

            folderName = folderName + "%";

            DocumentFileDSTableAdapters.FileInfoTableAdapter ta =
                new DocumentFileDSTableAdapters.FileInfoTableAdapter();

            DocumentFileDS.FileInfoDataTable table = ta.GetFilesByStoragePathName(folderName);

            List<DocumentFile> fileList = new List<DocumentFile>();

            if (table.Count > 0)
            {
                foreach (DocumentFileDS.FileInfoRow row in table)
                {
                    fileList.Add(DocumentFile.CreateNewTypedDocumentFileObject(
                        row.fileID,
                        row.uploadedOn,
                        row.fileSize,
                        row.fileName,
                        row.extension,
                        row.title,
                        row.fileStoragePath));
                }
            }

            return fileList;
        }

        public static List<DocumentFile> GetFilesForTutorial(int tutorialId)
        {            
            DocumentFileDSTableAdapters.FileInfoTableAdapter ta =
                new DocumentFileDSTableAdapters.FileInfoTableAdapter();

            DocumentFileDS.FileInfoDataTable table = ta.GetFilesByTutorial(tutorialId);

            List<DocumentFile> fileList = new List<DocumentFile>();

            if (table.Count > 0)
            {
                foreach (DocumentFileDS.FileInfoRow row in table)
                {
                    fileList.Add(DocumentFile.CreateNewTypedDocumentFileObject(
                        row.fileID,
                        row.uploadedOn,
                        row.fileSize,
                        row.fileName,
                        row.extension,
                        row.title,
                        row.fileStoragePath));
                }
            }

            return fileList;

        }       
    }
}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Artexacta.App.Documents;
using Artexacta.App.Documents.BLL;
using Artexacta.App.Documents.FileUpload;
using Artexacta.App.Utilities.Document;
using Artexacta.App.Utilities.SystemMessages;
using log4net;
using Telerik.Web.UI;
using Artexacta.App.Utilities;

public partial class UserControls_Documents_ImageUploader : System.Web.UI.UserControl
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

    public delegate void FilesLoadedHandler(object sender, FilesLoadedArgs e);

    public event FilesLoadedHandler FilesLoaded;

    public bool OnlyImages
    {
        set 
        {
            if (value)
            {
                ImageRadUpload.AllowedFileExtensions = new string[] { ".jpg", ".jpeg", ".gif", ".png", ".bmp", ".docx", ".pdf", ".doc" };
                UploadButton.Text = Resources.DocumentUploader.UploadImageButtonText;
            }
            else
            {
                ImageRadUpload.AllowedFileExtensions = new string[0];
            }
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        ImageRadUpload.MaxFileSize = GetMaxFileSizeInMb() * 1024 * 1024;
    }

    protected void ImageRadUpload_ValidatingFile(object sender, Telerik.Web.UI.Upload.ValidateFileEventArgs e)
    {
        UploadedFile theFile = e.UploadedFile;

        if (theFile.ContentLength > ImageRadUpload.MaxFileSize)
        {
            ImageErrorLabel.Text = ResourceReplacement.ReplaceResourceForValidation("DocumentUploader", "ErrorSize", "Size", GetMaxFileSizeInMb().ToString());
            ImageErrorLabel.Visible = true;
            ErrorHiddenField.Value = "1";
            e.IsValid = false;
            return;
        }

        if (!FileUtilities.IsFileExtensionAllowed(ImageRadUpload.AllowedFileExtensions, e.UploadedFile.GetExtension()))
        {
            ImageErrorLabel.Text = Resources.DocumentUploader.ErrorForbidden;
            ImageErrorLabel.Visible = true;
            ErrorHiddenField.Value = "1";
            e.IsValid = false;
            return;
        }

        ErrorHiddenField.Value = "0";
        ImageErrorLabel.Visible = false;
    }

    protected void UploadButton_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid)
            return;

        if (ErrorHiddenField.Value == "1")
        {
            if (this.FilesLoaded == null)
                return;
            
            // Now throw an event to the caller, telling him that we loaded a bunch of files
            FilesLoadedArgs theEventArgs = new FilesLoadedArgs();
            theEventArgs.Exception = new Exception("Validation File Error");
            theEventArgs.FilesLoaded = null;
            this.FilesLoaded(this, theEventArgs);            
            return;
        }
        List<FileLoaded> theFilesLoaded = new List<FileLoaded>();
        foreach (UploadedFile oInfo in ImageRadUpload.UploadedFiles)
        {
            try
            {
                if (string.IsNullOrEmpty(oInfo.FileName) || oInfo.ContentLength == 0)
                    continue;
                // Create the base object.  This was created without the actual file content
                DocumentFile theFile = DocumentFile.CreateNewTypedDocumentFileObject(
                        0, DateTime.Now, oInfo.ContentLength, oInfo.FileName,
                         oInfo.GetExtension(), oInfo.FileName, "");

                // Add the actual bytes read to the object
                theFile.Bytes = FileUtilities.ReadFully(oInfo.InputStream);
                theFile.Text = theFile.GetTextFromDocumentBinary();

                // And finally save the file to the database
                string fileStoragePath = "";
                int fileID = DocumentFileBLL.CreateDocumentFile(theFile, ref fileStoragePath, true);
                if (fileID > 0)
                {
                    theFilesLoaded.Add(new FileLoaded(fileID, theFile.Name, theFile.Extension, fileStoragePath));
                    SystemMessages.DisplaySystemMessage(Resources.DocumentUploader.UploadSucces);
                }
            }
            catch (Exception q)
            {
                log.Error("Could not load file for evaluation", q);
                SystemMessages.DisplaySystemErrorMessage(Resources.DocumentUploader.UploadFail);
            }
        }

        if (this.FilesLoaded != null)
        {
            // Now throw an event to the caller, telling him that we loaded a bunch of files
            FilesLoadedArgs theEventArgs = new FilesLoadedArgs();
            theEventArgs.FilesLoaded = theFilesLoaded;
            this.FilesLoaded(this, theEventArgs);
        }
    }


    protected string GetClientFileUploadedFunction()
    {
        return ClientID + "_imageUploaded";
    }

    protected int GetMaxFileSizeInMb()
    {
        int max = 5120;
        try
        {
            max = Convert.ToInt32(Artexacta.App.Configuration.Configuration.GetMaxDocumentsInKB());
        }
        catch (Exception ex)
        {
            log.Error("Cannot convert Artexacta.App.Configuration.BingalingConfiguration.GetMaxDocumentsInCompanyKB() to integer value", ex);
        }
        return max / 1024;
    }

}
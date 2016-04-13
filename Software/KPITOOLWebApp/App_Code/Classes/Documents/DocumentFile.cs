using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.IO;
using log4net;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;
using Artexacta.App.Documents.BLL;
using Artexacta.App.Utilities;
using Artexacta.App.Utilities.Document;
using Artexacta.App.Documents.IFilter;

namespace Artexacta.App.Documents
{
    /// <summary>
    /// The file that belongs to a Document
    /// </summary>
    [Serializable]
    public abstract class DocumentFile
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        protected int _fileID = 0;
        protected int _version = 0;
        protected int _documentID = 0;
        protected DateTime _dateUploaded = DateTime.MinValue;
        protected long _fileSize = 0;
        protected string _fileName = null;
        protected string _fileExtension = null;
        protected byte[] _fileBytes = null;
        protected string _fileText = null;
        protected string _title = null;
        protected string _fileStoragePath = null;
        protected List<Paragraph> _theParagraphs = null;

        protected string[] descriptionKeywords = {"abstract", "description",
                                                "introduction", "introducción",
                                                "objetivo", "descripción",
                                                "descripcion", "introduccion",
                                                "resumen"};

        /*
         * Properties for this class
         */

        /// <summary>
        /// Get or set the file ID that uniquely identifies this file
        /// </summary>
        public int FileID
        {
            get { return _fileID; }
            set { _fileID = value; }
        }

        /// <summary>
        /// Get or set the version of this file within the Document
        /// </summary>
        public int Version
        {
            get { return _version; }
            set { _version = value; }
        }

        /// <summary>
        /// Get or set the ID of the document that this file is associated to
        /// </summary>
        public int DocumentID
        {
            get { return _documentID; }
            set { _documentID = value; }
        }

        /// <summary>
        /// Get or set the date the file was uploaded to the system
        /// </summary>
        public DateTime DateUploaded
        {
            get { return _dateUploaded; }
            set { _dateUploaded = value; }
        }
        public string CompanyID
        {
            get;
            set;
        }
        /// <summary>
        /// Get the date file file was uploaded to the system in a format suitable for display to the end user
        /// </summary>
        public string DateUploadedForDisplay
        {
            get
            {
                if (DateUploaded.Equals(DateTime.MinValue))
                {
                    return "";
                }
                else
                {
                    return DateUploaded.ToString(Resources.Formats.ShortDateForDisplay);
                }
            }
        }

        /// <summary>
        /// Get or set the size of te file in bytes
        /// </summary>
        public long Size
        {
            get { return _fileSize; }
            set { _fileSize = value; }
        }

        /// <summary>
        /// Get the document size for display (as in 6.45 Mbytes)
        /// </summary>
        public string SizeForDisplay
        {
            get
            {
                return FileUtilities.GetFileSizeInWords(Size, "");
            }
        }

        /// <summary>
        /// Get or set the file name that corresponds to the file object
        /// </summary>
        public string Name
        {
            get { return _fileName; }
            set { _fileName = value; }
        }

        public string DownloadLabelForDisplay
        {
            get { return "["+ SizeForDisplay +", Descargar]"; }
        }        

        /// <summary>
        /// Get or set the extension for the file 
        /// </summary>
        public string Extension
        {
            get { return _fileExtension; }
            set { _fileExtension = value; }
        }

        /// <summary>
        /// Get or set the title for this file
        /// </summary>
        public string Title
        {
            get { return _title; }
            set { _title = value; }
        }

        /// <summary>
        /// Get ot set the actual file binary information
        /// </summary>
        public byte[] Bytes
        {
            get
            {
                // This property is lazy-loaded.  We only get the information from the database when we need it
                if (_fileBytes == null)
                {
                    try
                    {
                        _fileBytes = DocumentFileBLL.GetFileBinaryData(FileID);
                    }
                    catch (Exception e)
                    {
                        log.Error("Failed to get the file bytes for file " + FileID.ToString(), e);
                    }
                }

                return _fileBytes;
            }
            set { _fileBytes = value; }
        }

        /// <summary>
        /// Get or set the textual representation of the contents of the file binary
        /// </summary>
        public string Text
        {
            get
            {
                // This property is lazy-loaded.  We only get the information from the database when we need it
                if (_fileText == null)
                {
                    try
                    {
                        _fileText = DocumentFileBLL.GetFileTextualData(FileID);
                    }
                    catch (Exception e)
                    {
                        log.Error("Failed to get the file text for file " + FileID.ToString(), e);
                    }
                }

                return _fileText;
            }
            set { _fileText = value; }
        }

        /// <summary>
        /// Gets a list of keywords that typically precede a good description
        /// </summary>
        public string[] DescriptionKeywords
        {
            get { return descriptionKeywords; }
        }

        /// <summary>
        /// Get the text of the document as a set of paragraphs
        /// </summary>
        public List<Paragraph> TextParagraphs
        {
            get
            {
                if (_theParagraphs == null)
                {
                    GetTextParagraphs();
                }
                return _theParagraphs;
            }
        }

        /// <summary>
        /// Get the icon that should be used for this file
        /// </summary>
        public string SmallIcon
        {
            get { return FileUtilities.GetFileIconURL(Extension, IconSize.SmallIcon, IconType.StandardIcon); }
        }

        /// <summary>
        /// Get the location of this file's icon mapped to a server file
        /// </summary>
        public string SmallIconForDisplay
        {
            get { return HttpContext.Current.Server.UrlPathEncode(SmallIcon); }
        }

        /// <summary>
        /// Get the icon that should be used for this file
        /// </summary>
        public string MediumIcon
        {
            get { return FileUtilities.GetFileIconURL(Extension, IconSize.MediumIcon, IconType.StandardIcon); }
        }

        /// <summary>
        /// Get the location of this file's icon mapped to a server file
        /// </summary>
        public string MediumIconForDisplay
        {
            get { return HttpContext.Current.Server.UrlPathEncode(MediumIcon); }
        }

        /// <summary>
        /// Get the icon that should be used for this file
        /// </summary>
        public string LargeIcon
        {
            get { return FileUtilities.GetFileIconURL(Extension, IconSize.LargeIcon, IconType.StandardIcon); }
        }

        /// <summary>
        /// Get the location of this file's icon mapped to a server file
        /// </summary>
        public string LargeIconForDisplay
        {
            get { return HttpContext.Current.Server.UrlPathEncode(LargeIcon); }
        }

        /// <summary>
        /// Get the icon that should be used for this file
        /// </summary>
        public string SmallCustomIcon
        {
            get { return FileUtilities.GetFileIconURL(Extension, IconSize.SmallIcon, IconType.CustomIcon); }
        }

        /// <summary>
        /// Get the location of this file's icon mapped to a server file
        /// </summary>
        public string SmallCustomIconForDisplay
        {
            get { return HttpContext.Current.Server.UrlPathEncode(SmallCustomIcon); }
        }

        /// <summary>
        /// Get the icon that should be used for this file
        /// </summary>
        public string MediumCustomIcon
        {
            get { return FileUtilities.GetFileIconURL(Extension, IconSize.MediumIcon, IconType.CustomIcon); }
        }

        /// <summary>
        /// Get the location of this file's icon mapped to a server file
        /// </summary>
        public string MediumCustomIconForDisplay
        {
            get { return HttpContext.Current.Server.UrlPathEncode(MediumCustomIcon); }
        }

        /// <summary>
        /// Get the icon that should be used for this file
        /// </summary>
        public string LargeCustomIcon
        {
            get { return FileUtilities.GetFileIconURL(Extension, IconSize.LargeIcon, IconType.CustomIcon); }
        }

        /// <summary>
        /// Get the location of this file's icon mapped to a server file
        /// </summary>
        public string LargeCustomIconForDisplay
        {
            get { return HttpContext.Current.Server.UrlPathEncode(LargeCustomIcon); }
        }

        public string FileTypeInWords
        {
            get { return FileUtilities.GetFileTypeInWords(Extension); }
        }

        /// <summary>
        /// This is the actual location of the file binary data
        /// </summary>
        public string FileStoragePath
        {
            get { return _fileStoragePath; }
            set { _fileStoragePath = value; }
        }        

        /// <summary>
        /// Create a new document file object
        /// </summary>
        /// <param name="fileID">The ID of the file.  Use 0 to indicate that the file does not have an ID yet</param>
        /// <param name="documentID">The ID of the document that this file will be associated to</param>
        /// <param name="version">The version number for the file. Use 0 to indicate that the version is not know</param>
        /// <param name="dateUploaded">The date the document was uplodaded</param>
        /// <param name="fileSize">The size of the file in bytes</param>
        /// <param name="fileName">The file name, including the extension</param>
        /// <param name="fileExtension">The extension for the file</param>
        public DocumentFile(int fileID, int documentID, int version, DateTime dateUploaded,
                long fileSize, string fileName, string fileExtension, string title, string storagePath)
        {
            FileID = fileID;
            DocumentID = documentID;
            Version = version;
            DateUploaded = dateUploaded;
            Size = fileSize;
            Name = fileName;
            Extension = fileExtension;
            Title = title;
            FileStoragePath = storagePath;
        }

        public abstract string[] ExtractCreationDateCandidatesFromFile();

        public abstract string[] ExtractKeyWordCandidatesFromFile();

        public abstract string[] ExtractAuthorCandidatesFromFile();

        /// <summary>
        /// Get at most three most likely titles for the document
        /// </summary>
        /// <returns>Returns from 0 to 3 titles</returns>
        public string[] ExtractTitleCandidatesFromText()
        {
            if (TextParagraphs == null || TextParagraphs.Count == 0)
            {
                return null;
            }

            // Sort the document paragraphs by Title Weight
            TextParagraphs.Sort(Paragraph.CompareParagraphsByTitleWeight);

            // Return the last 3 potential titles.
            int elemCount = 3;
            if (TextParagraphs.Count < elemCount)
            {
                elemCount = TextParagraphs.Count;
            }

            string[] titles = new string[elemCount];
            for (int i = 0; i < elemCount; i++)
            {
                titles[i] = TextParagraphs[TextParagraphs.Count - i].Text;
            }

            return titles;
        }

        /// <summary>
        /// Get at most three most likely descriptions for the document
        /// </summary>
        /// <returns>Returns from 0 to 3 descriptions</returns>
        public string[] ExtractDescriptionCandidatesFromText()
        {
            if (TextParagraphs == null || TextParagraphs.Count == 0)
            {
                return null;
            }

            // Sort the document paragraphs by Description Weight
            TextParagraphs.Sort(Paragraph.CompareParagraphsByDescriptionWeight);

            // Return the last 3 potential titles.
            int elemCount = 3;
            if (TextParagraphs.Count < elemCount)
            {
                elemCount = TextParagraphs.Count;
            }

            string[] descriptions = new string[elemCount];
            for (int i = 0; i < elemCount; i++)
            {
                descriptions[i] = TextParagraphs[TextParagraphs.Count - i].Text;
            }

            return descriptions;
        }

        /// <summary>
        /// Parse a document text, clean it up and split it into paragraphs.
        /// </summary>
        /// <param name="text">The document text</param>
        /// <returns>The document text split into paragraphs </returns>
        public void GetTextParagraphs()
        {
            _theParagraphs = null;

            if (Text == null || Text.Length == 0)
            {
                return;
            }

            Hashtable symbols = new Hashtable();
            symbols.Add('!', '!');
            symbols.Add('@', '@');
            symbols.Add('#', '#');
            symbols.Add('$', '$');
            symbols.Add('%', '%');
            symbols.Add('^', '^');
            symbols.Add('&', '&');
            symbols.Add('*', '*');
            symbols.Add('(', '(');
            symbols.Add(')', ')');
            symbols.Add('[', '[');
            symbols.Add(']', ']');
            symbols.Add('{', '{');
            symbols.Add('}', '}');
            symbols.Add(':', ':');
            symbols.Add(';', ';');
            symbols.Add('<', '<');
            symbols.Add('>', '>');
            symbols.Add('/', '/');
            symbols.Add('\\', '\\');

            // VERIFY: Maybe we should limit the text to the first X character
            //if(text.Length > 1000) {
            //    text = text.Substring(0, 1000);
            //}

            // Separate the text into lines.  
            string[] textLines = Text.Split(new char[] { '\n', '\r' });

            List<Paragraph> textExtracted = new List<Paragraph>();

            StringBuilder currPar = new StringBuilder();

            bool foundEndOfParagraph = false;

            // Keep track of how likely the paragraph is to de a description or abstract.
            int currentDescriptionWeight = 0;
            int nextDescriptionWeight = 0;

            // Keep track of the quality of the paragraph, as a title.
            int currentTitleWeight = 0;

            for (int i = 0; i < textLines.Length; i++)
            {
                // The farther away from the beginning of the document, 
                // the less likely it is that this line of text is a valid title.
                currentTitleWeight = 0;

                // If we found and end of paragrah... save it.
                if (foundEndOfParagraph)
                {
                    if (currPar.Length > 0)
                    {
                        // The farther away from the beggining of the document, the less likely a line will 
                        // be a title.   
                        currentTitleWeight -= i;
                        currentTitleWeight += AdjustmentsForTitle(currPar.ToString());
                        nextDescriptionWeight +=
                                AdjustmentsForNextDescription(currPar.ToString());
                        currentDescriptionWeight +=
                                AdjustmentsForDescription(currPar.ToString());
                        Paragraph el = new Paragraph(currPar.ToString(),
                            currentDescriptionWeight, currentTitleWeight);
                        textExtracted.Add(el);
                        currPar.Length = 0;
                    }

                    foundEndOfParagraph = false;
                    currentDescriptionWeight = nextDescriptionWeight;
                    nextDescriptionWeight = 0;
                }

                String text = textLines[i].Trim();

                // If the string is empty, it signifies an end of paragraph.
                if (text.Length == 0)
                {
                    foundEndOfParagraph = true;
                    continue;
                }

                //Ignore lines that start with the following:
                //  http://
                //  @
                //  ---
                //  ___
                //  ===
                if (text.ToUpper().StartsWith("HTTP://") || text.StartsWith("@") ||
                    text.StartsWith("---") ||
                    text.StartsWith("___") || text.StartsWith("==="))
                {
                    foundEndOfParagraph = true;
                    continue;
                }

                // Ignore lines that contain repeated instances of ..... or --------- or ______ or -------
                // These are probably table of contents.
                if (Regex.Match(text, ".*\\.\\.\\.\\.\\.(\\.)*.*").Success)
                {
                    continue;
                }

                if (Regex.Match(text, ".*-----(-)*.*").Success)
                {
                    continue;
                }

                if (Regex.Match(text, ".*_____(_)*.*").Success)
                {
                    continue;
                }

                // Ignore lines that have too many symbols... these are not likely to be useful text.
                int count = 0;
                for (int j = 0; j < text.Length; j++)
                {
                    if (symbols.Contains(text[j]))
                    {
                        count += 1;
                    }
                }
                int limit = text.Length / 20; // 20% of the characters
                if (count > limit)
                {
                    continue;
                }

                // Add the current line to the paragraph.
                if (currPar.Length > 0)
                {
                    currPar.Append(" ");
                }
                currPar.Append(text);

                if (text.EndsWith(".") || text.EndsWith("!") || text.EndsWith("?") ||
                    text.EndsWith(":"))
                {
                    // This is the end of a paragraph.
                    foundEndOfParagraph = true;
                }
            }

            // Process the last entry.
            if (currPar.Length > 0)
            {
                currentTitleWeight -= textLines.Length;
                currentTitleWeight += AdjustmentsForTitle(currPar.ToString());
                nextDescriptionWeight +=
                        AdjustmentsForDescription(currPar.ToString());
                Paragraph el = new Paragraph(currPar.ToString(),
                    currentDescriptionWeight, currentTitleWeight);
                textExtracted.Add(el);
            }

            _theParagraphs = textExtracted;
        }

        private int AdjustmentsForNextDescription(string text)
        {
            int adj = 0;

            // If the paragraph starts with one of the description keywords and is long...
            // Ignore leading numbers, spaces, dashes and periods...  As in 1.- Abstract

            // Find the first letter in the string
            int start = -1;
            for (int k = 0; k < text.Length; k++)
            {
                if (Char.IsLetter(text[k]))
                {
                    start = k;
                    break;
                }
            }

            if (start >= 0)
            { // If start == -1, there are only digits, spaces and dashes and periods in the string.
                for (int j = 0; j < descriptionKeywords.Length; j++)
                {
                    string x = text.Substring(start);
                    if (x.ToLower().StartsWith(descriptionKeywords[j]))
                    {
                        adj += 5;
                        break;
                    }
                }
            }

            return adj;
        }

        private int AdjustmentsForDescription(string text)
        {
            int adj = 0;

            // If the paragraph begins with an upper case letter and ends with a punctuation mark, then this
            // is likely to be a well formed paragraph.
            // This is a good indication that the paragraph is well formed.
            if (
                (
                text.EndsWith(".") || text.EndsWith("!") || text.EndsWith("?") ||
                text.EndsWith(":")
                )
                && Char.IsUpper(text[0])
            )
            {
                adj += 2;
            }

            // If this paragraph is long, the odds of it being a description are increades.
            if (text.Length > 50)
            {
                adj += 2;
            }

            return adj;
        }

        private int AdjustmentsForTitle(String text)
        {
            int adj = 0;

            // If the paragraph found is ALL CAPS, this is likely to be a title.
            bool isAllCaps = true;
            for (int j = 0; j < text.Length; j++)
            {
                if (!Char.IsUpper(text[j]))
                {
                    isAllCaps = false;
                    break;
                }
            }

            if (isAllCaps)
            {
                adj += 5;
            }

            // If the current paragraph starts with an uppercase letter, and ends in a lowercase letter
            // this is likely to be a title.
            if (Char.IsLetter(text[0]) && Char.IsUpper(text[0]) &&
                Char.IsLetter(text[text.Length - 1]) && Char.IsLower(text[text.Length - 1]))
            {
                adj += 5;
            }

            // If a paragraph starts with NNNN[.NNNN.NNNN] X  where NNN is a number, and X is a letter, 
            // then this is likely to be and enumeration, and not a title.
            if (Regex.Match(text, "$\\d+(\\.\\d+)*\\s*\\w").Success)
            {
                adj -= 5;
            }

            // If the paragraph is short, this is like a title.
            if (text.Length <= 50)
            {
                adj += 5;
            }

            // if the paragraph is long, this is not likely to be a title
            if (text.Length > 100)
            {
                adj -= 5;
            }

            return adj;
        }

        /// <summary>
        /// Get the textual representation of the Binary Data of the document using IFILTER
        /// </summary>
        /// <returns>The text of the document or null if we could not parse the document into text</returns>
        public virtual string GetTextFromDocumentBinary()
        {

            /*
             * The default is to save the binary data to a temporary location and
             * use IFilter to extract the text.  This should be a good catch-all for 
             * all files that don't have a specific mechanism for extracting the 
             * text of the file.
             */

            // If we have no bytes then we can't do anything.
            if (Bytes == null || Bytes.Length == 0)
            {
                // Log the problem.
                log.Error("Tried to extract text from empty bytes for file " + Name);
                return null;
            }

            // Get the original file name without the extension
            string fileNameWithoutExtension = Path.GetFileNameWithoutExtension(Name);

            bool success = false;
            string newFileName = "";
            try
            {
                // Now try to generate a new temporary file name that we don't have in the temporary directory
                for (int i = 0; i < 50; i++)
                {
                    Random rand = new Random();
                    newFileName = "~/TemporaryFilesDirectory/" + fileNameWithoutExtension +
                        Convert.ToString(rand.Next(100000)) + Extension;
                    newFileName = HttpContext.Current.Server.MapPath(newFileName);

                    // Try to see if this file exists
                    if (!File.Exists(newFileName))
                    {
                        success = true;
                        break;
                    }
                }

                if (!success)
                {
                    // We failed.  Log the problem.
                    log.Error("Failed to create a unique file to extract data. Last file tried is " + newFileName);
                    return null;
                }
            }
            catch (Exception e)
            {
                // We failed.  Log the problem.
                log.Error("Failed to create a unique file to extract data for file " + Name, e);
                return null;
            }

            FileStream theFileStream = null;
            try
            {
                // Now try to write the bytes to the newly created file

                theFileStream = File.Create(newFileName);
                theFileStream.Write(Bytes, 0, Bytes.Length);
                theFileStream.Close();
            }
            catch (Exception e)
            {
                // We failed to write the file.  Log the problem
                log.Error("Failed to write bytes to new file " + newFileName, e);

                // Try to close the stream, in case it is still open and delete the file
                try
                {
                    if (theFileStream != null)
                    {
                        theFileStream.Close();
                    }

                    if (File.Exists(newFileName))
                    {
                        File.Delete(newFileName);
                    }
                }
                catch
                {
                    // We don't do anything.  This is a best effort close and delete
                }

                return null;
            }

            string text = null;
            FilterReader myFilterReader = null;
            // Now try to extract the text for the file
            try
            {
                myFilterReader = new FilterReader(newFileName);
                text = myFilterReader.ReadToEnd();
                myFilterReader.Close();
            }
            catch (Exception e)
            {
                log.Error("Failed to parse text for file " + Name + " using IFilter", e);

                // Try to close the IFilter, in case it is still open
                try
                {
                    if (myFilterReader != null)
                    {
                        myFilterReader.Close();
                    }
                }
                catch
                {
                    // We don't do anything.  This is a best effort close.
                }
            }

            try
            {
                // Try to delete the temporary file
                if (File.Exists(newFileName))
                {
                    File.Delete(newFileName);
                }
            }
            catch (Exception e)
            {
                log.Error("Failed to delete temporary file " + newFileName, e);
            }

            return text;
        }


        /// <summary>
        /// Create a new Typed Document File Object that is associated to a specific Document Version
        /// </summary>
        /// <param name="fileID">The Document File ID</param>
        /// <param name="documentID">The ID of the Document the object is associated to</param>
        /// <param name="version">The versin of the document the object is associated to</param>
        /// <param name="dateUploaded">The date the document file was uploaded</param>
        /// <param name="fileSize">The size of the file</param>
        /// <param name="fileName">The name of the file</param>
        /// <param name="fileExtension">The extension of the file name</param>
        /// <param name="storagePath">The path where the file is located</param>
        /// <returns>The DocumentFile object for the object created</returns>
        public static DocumentFile CreateNewTypedDocumentFileObject(int fileID, int documentID, int version,
            DateTime dateUploaded, long fileSize, string fileName, string fileExtension, string title,
            string storagePath)
        {
            DocumentFile theResult = null;

            string provider = FileUtilities.GetFileTextExtractionProvider(fileExtension);

            if (fileExtension == null)
            {
                theResult = new GenericDocumentFile(fileID, documentID, version, dateUploaded, fileSize,
                    fileName, fileExtension, title, storagePath);
            }
            else if (String.Compare(provider, Constants.PROVIDER_GENERICIMAGE, true) == 0)
            {
                theResult = new ImageDocumentFile(fileID, documentID, version, dateUploaded, fileSize,
                    fileName, fileExtension, title, storagePath);
            }
            else if (String.Compare(provider, Constants.PROVIDER_PDFBOX, true) == 0)
            {
                theResult = new PDFDocumentFile(fileID, documentID, version, dateUploaded, fileSize,
                    fileName, fileExtension, title, storagePath);
            }
            else if (String.Compare(provider, Constants.PROVIDER_HTML, true) == 0)
            {
                theResult = new HTMLDocumentFile(fileID, documentID, version, dateUploaded, fileSize,
                    fileName, fileExtension, title, storagePath);
            }
            else
            {
                theResult = new GenericDocumentFile(fileID, documentID, version, dateUploaded, fileSize,
                    fileName, fileExtension, title, storagePath);
            }

            return theResult;
        }

        /// <summary>
        ///  a new Typed Document File Object that is NOT associated to any document
        /// </summary>
        /// <param name="fileID">The Document File ID</param>
        /// <param name="dateUploaded">The date the document file was uploaded</param>
        /// <param name="fileSize">The size of the file</param>
        /// <param name="fileName">The name of the file</param>
        /// <param name="fileExtension">The extension of the file name</param>
        /// <param name="storagePath">The path where the file is located</param>
        /// <returns>The DocumentFile object for the object created</returns>
        public static DocumentFile CreateNewTypedDocumentFileObject(int fileID, DateTime dateUploaded,
            long fileSize, string fileName, string fileExtension, string title, string storagePath)
        {
            return CreateNewTypedDocumentFileObject(fileID, 0, 0, dateUploaded, fileSize,
                fileName, fileExtension, title, storagePath);
        }

        /// <summary>
        /// Get a thumbnail of the document, if possible
        /// </summary>
        /// <param name="sizeX">The maximum X size of the thumbnail</param>
        /// <param name="sizeY">The maximum y size of the thumbnail</param>
        /// <param name="forceFullSize">True if the thumbnail should be exatly XxY pixels and False if the thumbnail 
        /// should fit inside a XxY box but should maintain its aspect ratio</param>
        /// <returns>A JPEG byte thumbnail or null if the thumbnail can´t be generated</returns>
        public abstract byte[] GetThumbnail(int sizeX, int sizeY, bool forceFullSize);
    }
}
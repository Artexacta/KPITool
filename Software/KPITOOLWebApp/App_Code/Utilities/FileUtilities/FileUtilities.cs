using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Xml;
using System.Xml.XPath;
using log4net;
using Artexacta.App.Configuration;
using System.Collections.Generic;
using Artexacta.App.Utilities;
using Artexacta.App.Documents;
using Artexacta.App.Documents.BLL;
using System.Collections;
using System.IO;

namespace Artexacta.App.Utilities.Document
{
    public enum IconSize { SmallIcon, MediumIcon, LargeIcon };
    public enum IconType { StandardIcon, CustomIcon };

    /// <summary>
    /// General utilities regarding files and tile types
    /// </summary>
    public class FileUtilities
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");
        private static Hashtable theMimeTypeList = null;

        public FileUtilities()
        {
        }

        /// <summary>
        /// Get the file type in words.  For example, a .pdf file would be Acrobat Document
        /// </summary>
        /// <param name="extension">The file extension</param>
        /// <returns>The type of the file in words</returns>
        public static string GetFileTypeInWords(string extension)
        {
            if (log.IsDebugEnabled)
            {
                log.Debug("Requested file type in words for extension " + extension);
            }

            // We need to get this from the file types
            Hashtable theTypesHash = FileTypesBLL.GetFileTypesExtensionHash();
            if (!theTypesHash.Contains(extension.ToUpper()))
            {
                log.Error("Failed to find the extension " + extension + " in the file type list");
                return Resources.Files.UnknownFileType;
            }

            FileType theFileType = (FileType)theTypesHash[extension.ToUpper()];

            if (log.IsDebugEnabled)
            {
                log.Debug("Found description \"" + theFileType.Description +
                    "\" for extension " + extension);
            }

            return theFileType.Description;
        }

        /// <summary>
        /// Get the size of a file in words (for example, 3.45 MBytes)
        /// </summary>
        /// <param name="fileSize">The file size</param>
        /// <returns>the size of the file in words</returns>
        public static string GetFileSizeInWords(long fileSize, string companyFriendlyUrl)
        {
            string finalSize = "";

            //if (fileSize < 1024)
            //{
            //    finalSize = ResourceReplacement.ReplaceResourceWithParameters(
            //        "Formats", "ByteFileSize", "Size", fileSize.ToString(), companyFriendlyUrl);
            //}
            //else if (fileSize < (long)1020 * (long)1024)
            //{
            //    finalSize = ResourceReplacement.ReplaceResourceWithParameters(
            //        "Formats", "KByteFileSize", "Size", System.Math.Round(Convert.ToDouble(fileSize) / 1024.0).ToString(), companyFriendlyUrl);
            //}
            //else if (fileSize < (long)1024 * (long)1024 * (long)1024)
            //{
            //    finalSize = ResourceReplacement.ReplaceResourceWithParameters(
            //        "Formats", "MByteFileSize", "Size", System.Math.Round(Convert.ToDouble(fileSize) / 1024.0 / 1024.0).ToString(), companyFriendlyUrl);
            //}
            //else if (fileSize < (long)1024 * (long)1024 * (long)1024 * (long)1024)
            //{
            //    finalSize = ResourceReplacement.ReplaceResourceWithParameters(
            //        "Formats", "GByteFileSize", "Size", System.Math.Round(Convert.ToDouble(fileSize) / 1024.0 / 1024.0 / 1024.0).ToString(), companyFriendlyUrl);
            //}
            //else
            //{
            //    finalSize = Resources.Glossary.UnkownFileSize;
            //}

            return finalSize;
        }

        /// <summary>
        /// Get the location of the medium icon for this file type
        /// </summary>
        /// <param name="extension">The file extension</param>
        /// <param name="iconsize">The size of the required icon</param>
        /// <returns>The location of the icon that should  be used</returns>
        public static string GetFileIconURL(string extension, IconSize iconsize, IconType icontype)
        {
            if (log.IsDebugEnabled)
            {
                log.Debug("Requested " + iconsize.ToString() + "icon for extension " + extension);
            }

            // We need to get this from the file types
            Hashtable theTypesHash = FileTypesBLL.GetFileTypesExtensionHash();
            if (!theTypesHash.Contains(extension.ToUpper()))
            {
                log.Error("Failed to find the extension " + extension + " in the file type list");
                return Resources.Files.FileIconDirectory + "/" + Resources.Files.UnknownFileIcon;
            }

            FileType theFileType = (FileType)theTypesHash[extension.ToUpper()];
            string iconPath = "";

            if (icontype == IconType.StandardIcon)
            {
                if (iconsize == IconSize.SmallIcon)
                    iconPath = Resources.Files.FileIconDirectory + "/" + theFileType.SmallIcon;
                else if (iconsize == IconSize.MediumIcon)
                    iconPath = Resources.Files.FileIconDirectory + "/" + theFileType.MediumIcon;
                else if (iconsize == IconSize.LargeIcon)
                    iconPath = Resources.Files.FileIconDirectory + "/" + theFileType.LargeIcon;
                else
                    throw new ArgumentException("invalid icon size " + iconsize.ToString());
            }
            else
            {
                if (iconsize == IconSize.SmallIcon)
                    iconPath = Resources.Files.FileIconDirectory + "/" + theFileType.SmallCustomIcon;
                else if (iconsize == IconSize.MediumIcon)
                    iconPath = Resources.Files.FileIconDirectory + "/" + theFileType.MediumCustomIcon;
                else if (iconsize == IconSize.LargeIcon)
                    iconPath = Resources.Files.FileIconDirectory + "/" + theFileType.LargeCustomIcon;
                else
                    throw new ArgumentException("invalid icon size " + iconsize.ToString());
            }

            if (log.IsDebugEnabled)
            {
                log.Debug("Found icon \"" + iconPath + "\" for size " + iconsize.ToString() +
                    "for extension " + extension);
            }

            return iconPath;
        }

        /// <summary>
        /// Get the name of the provider that is in charge of extracting the text for the file type
        /// </summary>
        /// <param name="extension">The file extension</param>
        /// <returns>The name of the provider that should be used or null if one does not exist</returns>
        public static string GetFileTextExtractionProvider(string extension)
        {
            if (log.IsDebugEnabled)
            {
                log.Debug("Requested text extraction provider for extension " + extension);
            }

            // We need to get this from the file types
            Hashtable theTypesHash = FileTypesBLL.GetFileTypesExtensionHash();

            if (!theTypesHash.Contains(extension.ToUpper()))
            {
                log.Error("Failed to find the extension " + extension + " in the file type list");
                return null;
            }

            FileType theFileType = (FileType)theTypesHash[extension.ToUpper()];

            if (log.IsDebugEnabled)
            {
                log.Debug("Found text extraction provider \"" + theFileType.Provider +
                    "\" for extension " + extension);
            }

            return theFileType.Provider;
        }

        /// <summary>
        /// Determines if an image file should be allowed to be uploaded to the system
        /// </summary>
        /// <param name="fileName">The image file name to verify</param>
        /// <returns>True if the file should be allowed, false otherwise</returns>
        public static bool IsAnImageFile(string fileName)
        {
            if (string.IsNullOrEmpty(fileName))
            {
                log.Warn("Called IsAnImageFile with null or empty filename");
                return false;
            }

            if (log.IsDebugEnabled)
            {
                log.Debug("Trying to determine if file " + fileName + " is an Image valid file");
            }

            FileInfo theFileInfo = new FileInfo(fileName);
            string extension = theFileInfo.Extension;

            // We need to get this from the file types
            Hashtable theTypesHash = FileTypesBLL.GetFileTypesExtensionHash();

            if (!theTypesHash.Contains(extension.ToUpper()))
            {
                log.Error("Failed to find the extension " + extension + " in the file type list");
                return false;
            }

            FileType theFileType = (FileType)theTypesHash[extension.ToUpper()];

            if (theFileType.Image)
                return true;
            else
                return false;
        }

        /// <summary>
        /// Verifies if the given extension in the filename is allowed in the given list.
        /// The given lists is the Allowed extension list from the RadControl
        /// </summary>
        /// <param name="allowedExtensions"></param>
        /// <param name="fileName"></param>
        public static bool IsFileExtensionAllowed(string[] allowedExtensions, string fileExtension)
        {
            if (allowedExtensions == null || allowedExtensions.Length <= 0)
                return true;

            foreach (string extension in allowedExtensions)
            {
                if (extension.ToLower() == fileExtension.ToLower())
                    return true;
            }

            return false;
        }

        /// <summary>
        /// Determine is a file should be allowed to be uploaded to the system
        /// </summary>
        /// <param name="fileName">The file name to verify</param>
        /// <returns>True if the file should be allowed, false otherwise</returns>
        public static bool IsFileExtensionAllowed(string fileName)
        {
            if (string.IsNullOrEmpty(fileName))
            {
                log.Warn("Called IsFileExtensionAllowed with null or emply filename");
                return false;
            }

            if (log.IsDebugEnabled)
            {
                log.Debug("Trying to determine if file " + fileName + " should be allowed in the system");
            }

            string[] filesAllowed = Artexacta.App.Configuration.Configuration.GetListOfAllowedFileExtensions();
            string[] filesNotAllowed = Artexacta.App.Configuration.Configuration.GetListOfForbiddenFileExtensions();

            if (filesAllowed == null && filesNotAllowed == null)
            {
                log.Warn("Could not find a list of file extensions to allow or forbid. Is this what was intended?");
            }

            if (log.IsDebugEnabled)
            {
                if (filesAllowed != null)
                {
                    foreach (string extension in filesAllowed)
                    {
                        log.Debug("Extension \"" + extension + "\" should be allowed");
                    }
                }
                if (filesNotAllowed != null)
                {
                    foreach (string extension in filesNotAllowed)
                    {
                        log.Debug("Extension \"" + extension + "\" should be denied");
                    }
                }
            }

            if (filesAllowed != null && filesAllowed.Length > 0)
            {
                // Check to see if the file is in one of the allowed extensions
                bool valid = false;
                for (int i = 0; i < filesAllowed.Length; i++)
                {
                    if (fileName.ToLower().EndsWith(filesAllowed[i].ToLower()))
                    {
                        if (log.IsDebugEnabled)
                        {
                            log.Debug("File name " + fileName + " matches extension " +
                                filesAllowed[i] + " and should be allowed");
                        }

                        valid = true;
                        break;
                    }
                }

                return valid;
            }
            else if (filesNotAllowed != null && filesNotAllowed.Length > 0)
            {
                // Check to see if the file is in one the forbidden extensions.
                bool valid = true;
                for (int i = 0; i < filesNotAllowed.Length; i++)
                {
                    if (fileName.ToLower().EndsWith(filesNotAllowed[i].ToLower()))
                    {
                        if (log.IsDebugEnabled)
                        {
                            log.Debug("File name " + fileName + " matches extension " +
                                filesNotAllowed[i] + " and should be denied");
                        }

                        valid = false;
                        break;
                    }
                }

                return valid;
            }
            else
            {
                // No files specified. We allow everything
                log.Debug("We could not find a list of extensions to allow or not allow. Allowing file to be uploaded");
                return true;
            }
        }

        /// <summary>
        /// Get the MIME type for a file extension
        /// </summary>
        /// <param name="extension">The file extension</param>
        /// <returns>The MIME type or null if one is not known</returns>
        public static string GetFileMIMEType(string extension)
        {
            if (string.IsNullOrEmpty(extension))
            {
                log.Warn("Called GetFileMIMEType with null or empty extension");
                return null;
            }

            if (log.IsDebugEnabled)
            {
                log.Debug("Trying to determine the MIME type for extension " + extension);
            }

            if (theMimeTypeList == null || theMimeTypeList.Count == 0)
            {
                log.Debug("The mime list was not loaded before.  Loading it for the first time");

                theMimeTypeList = new Hashtable();
                try
                {
                    // Load the MIME file list to memmory
                    using (StreamReader sr = new StreamReader(HttpContext.Current.Server.MapPath(Resources.Files.MIMETypesFile)))
                    {
                        String line;
                        while ((line = sr.ReadLine()) != null)
                        {
                            if (log.IsDebugEnabled)
                            {
                                log.Debug("Read a line from the MIME file: " + line);
                            }

                            if (line == null)
                            {
                                log.Debug("Empty line.  Will ignore it");
                                continue;
                            }

                            line = line.Trim();

                            // Ignore blank lines
                            if (string.IsNullOrEmpty(line))
                            {
                                log.Debug("Blank line. Will ignore it.");
                                continue;
                            }

                            // Ignore comment lines
                            if (line.StartsWith("#"))
                            {
                                log.Debug("Comment line. Will ignore it");
                                continue;
                            }

                            string[] typeComponents = line.Split(new char[] { ',' });

                            // Ignore lines that dont have two components
                            if (typeComponents.Length != 2)
                            {
                                log.Debug("The line does not not have two components exactly.  Will ignore it");
                                continue;
                            }

                            string fileExtension = typeComponents[0].Trim();
                            string mimeType = typeComponents[1].Trim();

                            // Ignore extensions that don't start with a period
                            if (!extension.StartsWith("."))
                            {
                                log.Warn("The extension " + fileExtension +
                                    " in MIME file does not start with a period.  Will ignore it");
                                continue;
                            }

                            if (theMimeTypeList.ContainsKey(fileExtension.ToUpper()))
                            {
                                log.Warn("The extension " + fileExtension +
                                    " is defined mmore than once in the MIME file types file. Will use only first one");
                                continue;
                            }

                            // We seem to have a good line.  Add it to the list.
                            if (log.IsDebugEnabled)
                            {
                                log.Debug("Adding \"" + fileExtension + "\" extension with MIME type \"" + mimeType +
                                    "\" to our list of MIME types");
                            }

                            theMimeTypeList.Add(fileExtension.ToUpper(), mimeType);
                        }
                    }
                }
                catch (Exception e)
                {
                    log.Error("Failed to read the MIME type file", e);
                }

                log.Debug("Done loading MIME types from MIME types file");
            }

            // Now try to get the MIME type for the extension provided.
            if (!theMimeTypeList.ContainsKey(extension.ToUpper()))
            {
                log.Debug("We could not find the extension \"" + extension + "\" in our list");
                return null;
            }
            else
            {
                string mimeTypeFound = theMimeTypeList[extension.ToUpper()].ToString();

                if (log.IsDebugEnabled)
                {
                    log.Debug("Found mime type \"" + mimeTypeFound + "\" for extension \"" +
                        extension + "\" in the MIME Types list");
                }

                return mimeTypeFound;
            }
        }

        /// <summary>
        /// Reads data from a stream until the end is reached. The
        /// data is returned as a byte array. An IOException is
        /// thrown if any of the underlying IO calls fail.
        /// </summary>
        /// <param name="stream">The stream to read data from</param>
        public static byte[] ReadFully(Stream stream)
        {
            byte[] buffer = new byte[32768];
            stream.Seek(0, SeekOrigin.Begin);
            using (MemoryStream ms = new MemoryStream())
            {
                while (true)
                {
                    int read = stream.Read(buffer, 0, buffer.Length);
                    if (read <= 0)
                        return ms.ToArray();
                    ms.Write(buffer, 0, read);
                }
            }
        }
    }
}
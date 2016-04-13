using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.Utilities.SystemMessages
{
    /// <summary>
    /// Summary description for SystemMessages
    /// </summary>
    public class SystemMessages
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        public SystemMessages()
        {
        }

        #region Public methods for messages for ONE user

        /// <summary>
        /// Display an error message to the screen.  This error message is only displayed
        /// in the screen and not logged anywhere else.
        /// </summary>
        /// <param name="message">The error message to display</param>
        public static void DisplaySystemErrorMessage(string message)
        {
            AddSystemErrorMessage(HttpContext.Current.Server.HtmlDecode(message));
        }

        /// <summary>
        /// Display a warning message to the screen.  This warning message is only displayed
        /// in the screen and not logged anywhere else.
        /// </summary>
        /// <param name="message">The warning message to display</param>
        public static void DisplaySystemWarningMessage(string message)
        {
            AddSystemWarningMessage(HttpContext.Current.Server.HtmlDecode(message));
        }

        /// <summary>
        /// Display a message to the screen.  This message is only displayed
        /// in the screen and not logged anywhere else.
        /// </summary>
        /// <param name="message">The warning message to display</param>
        public static void DisplaySystemMessage(string message)
        {
            AddSystemMessage(HttpContext.Current.Server.HtmlDecode(message));
        }

        /// <summary>
        /// Add an error message to the list of pending messages that should be shown to the end user
        /// </summary>
        /// <param name="message">The error message to add</param>
        static private void AddSystemErrorMessage(string message)
        {
            AddGenericMessage(message, SystemMessage.SystemMessageType.Error);
        }

        /// <summary>
        /// Add a warning message to the list of pending messages that should be shown to the end user
        /// </summary>
        /// <param name="message">The warning message to add</param>
        static private void AddSystemWarningMessage(string message)
        {
            AddGenericMessage(message, SystemMessage.SystemMessageType.Warning);
        }

        /// <summary>
        /// Add a message to the list of pending messages that should be shown to the end user
        /// </summary>
        /// <param name="message">The message to add</param>
        static private void AddSystemMessage(string message)
        {
            AddGenericMessage(message, SystemMessage.SystemMessageType.Message);
        }

        /// <summary>
        /// Add a message to the list of pending messages that should be shown to the end user
        /// </summary>
        /// <param name="message">The message to add</param>
        /// <param name="type">The message type</param>
        static private void AddGenericMessage(string message, SystemMessage.SystemMessageType type)
        {
            try
            {
                // Get a list of existing messages...
                SystemMessageList theUsersList = GetMessageListForUser(false);

                List<SystemMessage> myList = theUsersList.GetList();
                if (myList == null)
                {
                    myList = new List<SystemMessage>();
                }

                // Create a new list with our message at the top
                List<SystemMessage> newList = new List<SystemMessage>();
                // added to the session for the user control to display the message only once
                HttpContext.Current.Session["SHOW_MESSAGE"] = true;
                newList.Add(new SystemMessage(message, type));

                // Add all the elements from the previous list to the end of the new list
                while (myList.Count > 0)
                {
                    SystemMessage theElement = myList[0];
                    myList.RemoveAt(0);
                    newList.Add(theElement);
                }

                // Save the list back to the user's profile
                theUsersList.SetList(newList);
                SaveMessageListForUser(theUsersList);
            }
            catch (Exception q)
            {
                log.Error("Failed to add message of type " + type.ToString(), q);
            }
        }

        #endregion

        #region Public methods for messages for ALL users

        /// <summary>
        /// Display an error message to the screen.  This error message is only displayed
        /// in the screen and not logged anywhere else.
        /// </summary>
        /// <param name="message">The error message to display</param>
        public static void DisplaySystemErrorMessageForAll(string message)
        {
            AddSystemErrorMessageForAll(message);
        }

        /// <summary>
        /// Display a warning message to the screen.  This warning message is only displayed
        /// in the screen and not logged anywhere else.
        /// </summary>
        /// <param name="message">The warning message to display</param>
        public static void DisplaySystemWarningMessageForAll(string message)
        {
            AddSystemWarningMessageForAll(message);
        }

        /// <summary>
        /// Display a message to the screen.  This message is only displayed
        /// in the screen and not logged anywhere else.
        /// </summary>
        /// <param name="message">The warning message to display</param>
        public static void DisplaySystemMessageForAll(string message)
        {
            AddSystemMessageForAll(message);
        }

        /// <summary>
        /// Add an error message to the list of pending messages that should be shown to the end user
        /// </summary>
        /// <param name="message">The error message to add</param>
        static private void AddSystemErrorMessageForAll(string message)
        {
            AddGenericMessageForAll(message, SystemMessage.SystemMessageType.Error);
        }

        /// <summary>
        /// Add a warning message to the list of pending messages that should be shown to the end user
        /// </summary>
        /// <param name="message">The warning message to add</param>
        static private void AddSystemWarningMessageForAll(string message)
        {
            AddGenericMessageForAll(message, SystemMessage.SystemMessageType.Warning);
        }

        /// <summary>
        /// Add a message to the list of pending messages that should be shown to the end user
        /// </summary>
        /// <param name="message">The message to add</param>
        static private void AddSystemMessageForAll(string message)
        {
            AddGenericMessageForAll(message, SystemMessage.SystemMessageType.Message);
        }

        /// <summary>
        /// Add a message to the list of pending messages that should be shown to the end user
        /// </summary>
        /// <param name="message">The message to add</param>
        /// <param name="type">The message type</param>
        static private void AddGenericMessageForAll(string message, SystemMessage.SystemMessageType type)
        {
            try
            {
                List<SystemMessage> allUsersMessages = new List<SystemMessage>();
                if (SystemMessageList.AllUsersMessageList != null)
                {
                    for (int i = 0; i < SystemMessageList.AllUsersMessageList.Length; i++)
                    {
                        allUsersMessages.Add(SystemMessageList.AllUsersMessageList[i]);
                    }
                }

                // Create a new list with our message at the top
                List<SystemMessage> newList = new List<SystemMessage>();
                // added to the session for the user control to display the message only once
                HttpContext.Current.Session["SHOW_MESSAGE"] = true;
                SystemMessage theNewMessageForAllUsers = new SystemMessage(message, type);
                theNewMessageForAllUsers.ForAllUsers = true;
                newList.Add(theNewMessageForAllUsers);

                // Add all the elements from the previous list to the end of the new list
                while (allUsersMessages.Count > 0)
                {
                    SystemMessage theElement = allUsersMessages[0];
                    allUsersMessages.RemoveAt(0);
                    newList.Add(theElement);
                }

                // Save the list back to the user's profile
                SystemMessageList.AllUsersSetList(newList);
            }
            catch (Exception q)
            {
                log.Error("Failed to add message of type " + type.ToString(), q);
            }
        }

        #endregion

        /// <summary>
        /// Get a list of pending system messages, presumably to show to the end user.
        /// </summary>
        /// <returns>A list of messages that should be shown to the user</returns>
        public static List<SystemMessage> GetPendingSystemMessages()
        {
            List<SystemMessage> myList = new List<SystemMessage>();

            SystemMessageList theUsersList = GetMessageListForUser(true);

            if (theUsersList != null)
            {
                myList = theUsersList.GetList();
                if (myList == null)
                {
                    myList = new List<SystemMessage>();
                }
            }

            return myList;
        }

        /// <summary>
        /// Clear the list of pending messages to show to the end user.
        /// </summary>
        static public void ClearSystemMessages()
        {
            SystemMessageList theUsersList = null;
            // Create a new emply list of mesages
            List<SystemMessage> myList = new List<SystemMessage>();
            // Set the user's list of messages to the empty list
            theUsersList = new SystemMessageList(myList);
            // Save the empty list to the user's profile
            SaveMessageListForUser(theUsersList);
        }

        /// <summary>
        /// Clear the messages that are older than the number of minutes defined in the
        /// system configuration file.  Save the rest.
        /// </summary>
        static public void ExpireOlderSystemMessages()
        {
            // Get a list of existing messages...
            SystemMessageList theUsersList = GetMessageListForUser(false);

            List<SystemMessage> myList = theUsersList.GetList();
            if (myList == null)
            {
                myList = new List<SystemMessage>();
            }

            // Get from the configuration the number of minutes that the messages should be 
            // kept
            int secondsToKeep = App.Configuration.Configuration.GetTimeToExpireSystemMessages();

            // Create a list with the new messages that are not too old.
            List<SystemMessage> newList = new List<SystemMessage>();

            // Copy all the messages that are not too old to the new list
            while (myList.Count > 0)
            {
                SystemMessage theElement = myList[0];
                myList.RemoveAt(0);
                if (theElement.Time.AddSeconds(secondsToKeep).CompareTo(DateTime.Now) >= 0)
                {
                    // Keep the element. The alloted time has not passed.
                    newList.Add(theElement);
                }
            }

            // Save the list back to the user's profile
            theUsersList.SetList(newList);
            SaveMessageListForUser(theUsersList);

            // ================ DO THE SAME FOR MESSAGES FOR ALL USERS ==============
            List<SystemMessage> allUsersMessages = new List<SystemMessage>();
            if (SystemMessageList.AllUsersMessageList != null)
            {
                for (int i = 0; i < SystemMessageList.AllUsersMessageList.Length; i++)
                {
                    allUsersMessages.Add(SystemMessageList.AllUsersMessageList[i]);
                }
            }

            // Create a list with the new messages that are not too old.
            newList = new List<SystemMessage>();
            if (allUsersMessages.Count > 0)
            {
                // Copy all the messages that are not too old to the new list
                while (allUsersMessages.Count > 0)
                {
                    SystemMessage theElement = allUsersMessages[0];
                    allUsersMessages.RemoveAt(0);
                    if (theElement.Time.AddSeconds(secondsToKeep).CompareTo(DateTime.Now) >= 0)
                    {
                        // Keep the element. The alloted time has not passed.
                        newList.Add(theElement);
                    }
                }
            }

            // Save the list back to the list for all users
            SystemMessageList.AllUsersSetList(newList);
        }

        private static SystemMessageList GetMessageListForUser(bool includeAllUsers)
        {
            SystemMessageList theUsersList = null;
            try
            {
                // Get a list of existing messages...
                theUsersList = (SystemMessageList)HttpContext.Current.Profile.GetPropertyValue("SystemMessages");
            }
            catch (Exception e)
            {
                string userName = HttpContext.Current.User.Identity.Name;
                if (userName == null || string.IsNullOrEmpty(userName))
                {
                    userName = "[UNKNOWN]";
                }
                log.Error("Failed to get a list of existing system messages for current user " +
                    userName, e);
            }

            if (theUsersList == null)
            {
                List<SystemMessage> tempList = new List<SystemMessage>();
                theUsersList = new SystemMessageList(tempList);
            }

            // Now grab the messages for all users
            if (includeAllUsers)
            {
                List<SystemMessage> allUsersMessages = new List<SystemMessage>();
                if (SystemMessageList.AllUsersMessageList != null)
                {
                    for (int i = 0; i < SystemMessageList.AllUsersMessageList.Length; i++)
                    {
                        allUsersMessages.Add(SystemMessageList.AllUsersMessageList[i]);
                    }
                }

                if (allUsersMessages.Count > 0)
                {
                    List<SystemMessage> userMessages = theUsersList.GetList();
                    foreach (SystemMessage msg in allUsersMessages)
                    {
                        userMessages.Add(msg);
                    }

                    theUsersList = new SystemMessageList(userMessages);
                }
            }

            return theUsersList;
        }

        private static void SaveMessageListForUser(SystemMessageList theList)
        {
            //TODO: Verificar porque no hay usuario
            string userName = HttpContext.Current.User.Identity.Name;
            if (userName == null || string.IsNullOrEmpty(userName))
            {
                return;
            }

            try
            {
                HttpContext.Current.Profile.SetPropertyValue("SystemMessages", theList);
            }
            catch (Exception e)
            {
                log.Error("Failed to save a list of existing system messages for current user " +
                    userName, e);
            }
        }

    }
}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.Utilities.SystemMessages
{
    /// <summary>
    /// Summary description for SystemMessageList
    /// </summary>
    [Serializable]
    public class SystemMessageList
    {
        /*
         * The serializing procedue works well with arrays, but not with 
         * typed lists.  Hence, to we store everything as an array, but 
         * convert to a List when needed.
         */
        private SystemMessage[] _messageList;
        private static SystemMessage[] _allUsersMessageList;

        public SystemMessageList()
        {
        }

        public static SystemMessage[] AllUsersMessageList
        {
            get { return _allUsersMessageList; }
        }

        /// <summary>
        /// Create a list of messages to show to the user
        /// </summary>
        /// <param name="myList">The list of messages to store</param>
        public SystemMessageList(List<SystemMessage> myList)
        {
            SetList(myList);
        }

        /// <summary>
        /// Get a list of pending messages to show to the end user
        /// </summary>
        /// <returns>The list of pending messages.</returns>
        public List<SystemMessage> GetList()
        {

            List<SystemMessage> returnList = new List<SystemMessage>();
            if (_messageList != null)
            {
                foreach (SystemMessage element in _messageList)
                {
                    returnList.Add(element);
                }
            }
            return returnList;
        }

        /// <summary>
        /// Replace whatever list of messages we had with a new once
        /// </summary>
        /// <param name="myList">The new list of messages</param>
        public void SetList(List<SystemMessage> myList)
        {
            if (myList.Count > 0)
            {
                _messageList = new SystemMessage[myList.Count];
                int count = 0;
                foreach (SystemMessage element in myList)
                {
                    _messageList[count++] = element;
                }
            }
            else
            {
                _messageList = null;
            }
        }

        #region for all users

        /// <summary>
        /// Get a list of pending messages to show to the end user
        /// </summary>
        /// <returns>The list of pending messages.</returns>
        public static List<SystemMessage> AllUsersGetList()
        {

            List<SystemMessage> returnList = new List<SystemMessage>();
            if (_allUsersMessageList != null)
            {
                foreach (SystemMessage element in _allUsersMessageList)
                {
                    returnList.Add(element);
                }
            }
            return returnList;
        }

        /// <summary>
        /// Replace whatever list of messages we had with a new once
        /// </summary>
        /// <param name="myList">The new list of messages</param>
        public static void AllUsersSetList(List<SystemMessage> myList)
        {
            if (myList.Count > 0)
            {
                _allUsersMessageList = new SystemMessage[myList.Count];
                int count = 0;
                foreach (SystemMessage element in myList)
                {
                    _allUsersMessageList[count++] = element;
                }
            }
            else
            {
                _allUsersMessageList = null;
            }
        }
        #endregion
    }
}
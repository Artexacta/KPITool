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
using System.Text;

namespace Artexacta.App.Utilities.SystemMessages
{
    /// <summary>
    /// Describes a system message that will be shown to the user
    /// </summary>
    [Serializable]
    public class SystemMessage
    {
        /// <summary>
        /// System message type
        /// </summary>
        [Serializable]
        public enum SystemMessageType
        {
            /// <summary>
            /// Regular message to show to the end user 
            /// </summary>
            Message = 0,
            /// <summary>
            /// Warning message to show to the end user
            /// </summary>
            Warning = 1,
            /// <summary>
            /// Error message to show to the end user
            /// </summary>
            Error = 2
        }

        private const int _shortStringSize = 100;
        string _message;
        DateTime _time;
        SystemMessageType _type;
        bool _forAllUsers = false;

        public SystemMessage()
        {
        }

        /// <summary>
        /// Create a new system message that will be show to the user sometime
        /// </summary>
        /// <param name="message">The message to create</param>
        /// <param name="type">The message type</param>
        public SystemMessage(string message, SystemMessageType type)
        {
            this._time = DateTime.Now;
            this._message = message;
            this._type = type;
        }

        // Properties

        /// <summary>
        /// The message text that should be show to the user
        /// </summary>
        public string Message
        {
            get { return this._message; }
            set { this._message = value; }
        }

        /// <summary>
        /// A short version of the message, formatted in HTML with dates, colors and that
        /// will show a maximim of 100 characters.
        /// </summary>
        public string ShortMessage
        {
            get
            {
                StringBuilder messageToDisplay = new StringBuilder();

                switch (this._type)
                {
                    case SystemMessageType.Error:
                        messageToDisplay.Append("<strong><span style=\"color: Firebrick\">" +
                            (ForAllUsers ? Resources.Glossary.ErrorForAllLabel : Resources.Glossary.ErrorLabel) +
                        ": </span></strong> (" + Time.ToShortTimeString() + ") ");
                        break;
                    case SystemMessageType.Warning:
                        messageToDisplay.Append("<strong><span style=\"color: DarkOrange\">" +
                            (ForAllUsers ? Resources.Glossary.WarningForAllLabel : Resources.Glossary.WarningLabel) +
                        ": </span></strong> (" + Time.ToShortTimeString() + ") ");
                        break;
                    case SystemMessageType.Message:
                        messageToDisplay.Append("<strong><span style=\"color: DarkGreen\">" +
                            (ForAllUsers ? Resources.Glossary.MessageForAllLabel : Resources.Glossary.MessageLabel) +
                        ": </span></strong> (" + Time.ToShortTimeString() + ") ");
                        break;
                }

                if (_message.Length > _shortStringSize)
                {
                    messageToDisplay.Append(HttpUtility.HtmlEncode(
                        this._message.Substring(0, _shortStringSize) + "...")
                    );
                }
                else
                {
                    messageToDisplay.Append(HttpUtility.HtmlEncode(this._message));
                }

                return messageToDisplay.ToString();
            }
            set { }
        }

        /// <summary>
        /// The time the message was created
        /// </summary>
        public DateTime Time
        {
            get { return this._time; }
            set { this._time = value; }
        }

        /// <summary>
        /// The message type
        /// </summary>
        public SystemMessageType MessageType
        {
            get { return this._type; }
            set { this._type = value; }
        }

        /// <summary>
        /// If the message is for all users
        /// </summary>
        public bool ForAllUsers
        {
            get { return _forAllUsers; }
            set { _forAllUsers = value; }
        }
    }
}
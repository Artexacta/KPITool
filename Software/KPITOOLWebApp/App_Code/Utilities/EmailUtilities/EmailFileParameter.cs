using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.Utilities.Email
{
    /// <summary>
    /// Summary description for EmailFileParameter
    /// </summary>
    public class EmailFileParameter
    {
        private string _paramName = "";
        private string _paramSubstitution = "";
        private bool _requiresEncoding = true;

        public EmailFileParameter()
        {
        }

        /// <summary>
        /// Create a new Email File Parameter
        /// </summary>
        /// <param name="parameterName">The parameter name</param>
        /// <param name="parameterSubstitution">The parameter substitution in Text.</param>
        public EmailFileParameter(string parameterName, string parameterSubstitution)
        {
            this._paramName = parameterName;
            this._paramSubstitution = parameterSubstitution;
            this._requiresEncoding = true;
        }

        /// <summary>
        /// If True, then the parameter will be HTML encoded.  Defaults to True.
        /// </summary>
        public bool RequiresHTMLEncoding
        {
            get { return _requiresEncoding; }
            set { _requiresEncoding = value; }
        }

        /// <summary>
        /// The parameter name
        /// </summary>
        public string ParameterName
        {
            get { return _paramName; }
            set { _paramName = value; }
        }

        /// <summary>
        /// The parameter substitution in Text.
        /// </summary>
        public string ParameterSubstitution
        {
            get { return _paramSubstitution; }
            set { _paramSubstitution = value; }
        }

        /// <summary>
        /// The parameter substitution in HTML.  HTML encoded.
        /// </summary>
        public string ParameterSubstitutionInHTML
        {
            get
            {
                if (RequiresHTMLEncoding)
                    return HttpUtility.HtmlEncode(ParameterSubstitution);
                else
                    return ParameterSubstitution;
            }

        }

    }
}
using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Resources;
using System.Collections.Generic;
using System.Collections;
using System.Text;

namespace Artexacta.App.Utilities
{
    /// <summary>
    /// Class that automates dealing with resources that need parameter replacements
    /// </summary>
    public class ResourceReplacement
    {
        protected string resourceName;  // The name of the resource in the resource file
        protected string resourceFile;  // The name of the global resource file
        protected string theOriginalString; // The resource strin without substitutions
        protected List<string> parameters = new List<string>(); // The list of parameters 
        protected Hashtable replacements = new Hashtable(); // The substitutions defined by the user

        /// <summary>
        /// A resource object that needs parameter replacements
        /// </summary>
        /// <param name="resourceFile">The name of the global resource file</param>
        /// <param name="resourceName">The name of the resource inside the resource file</param>
        public ResourceReplacement(string resourceFile, string resourceName)
        {
            this.resourceFile = resourceFile;
            this.resourceName = resourceName;

            // Get the resource string from the resource file
            this.theOriginalString = (string)HttpContext.GetGlobalResourceObject(resourceFile, resourceName);

            // Make sure that we have something valid
            if (string.IsNullOrEmpty(this.theOriginalString))
            {
                throw new Exception("Undefined resource " + resourceName + " in file " + resourceFile);
            }

            // Extract from the resource string a list of the parameters to substitute
            extractParameters();
        }

        /// <summary>
        /// Private function that extracts from the resource string a list of parameters to substitute
        /// </summary>
        private void extractParameters()
        {
            int start = -1;  // Start defines the starting position of a parameter 

            for (int i = 0; i < theOriginalString.Length; i++)
            {

                // If we see a { then remember where the parameter starts
                if (theOriginalString[i] == '{')
                {
                    start = i;
                    continue;
                }

                // If we see a } then we need to extract the parameter name
                if (theOriginalString[i] == '}')
                {
                    if (start >= 0)
                    {
                        parameters.Add(theOriginalString.Substring(start + 1, i - start - 1));
                    }
                    start = -1;
                }
            }

            // If we have no parameters, then we should not be called.  
            System.Diagnostics.Debug.Assert(parameters.Count > 0);
        }

        /// <summary>
        /// Determines if all the parameters in the resource string have substitutions
        /// </summary>
        /// <returns>True if all parameters have substitutions defined</returns>
        public bool parameterSubstitutionsComplete()
        {
            bool complete = true;
            for (int j = 0; j < parameters.Count; j++)
            {
                if (!replacements.ContainsKey(parameters[j]))
                {
                    complete = false;
                }
            }

            return complete;
        }

        /// <summary>
        /// Get a list of the parameters we need to substitute
        /// </summary>
        /// <returns>An array of the names of all parameters in the resource string</returns>
        public string[] parameterNameList()
        {
            return parameters.ToArray();
        }

        /// <summary>
        /// Get a hast table with all the substitutions defined
        /// </summary>
        /// <returns>The list of all substitutions.  The key is the parameter name, and the value is 
        /// the substitution</returns>
        public Hashtable parameterSubstitutionList()
        {
            return this.replacements;
        }

        /// <summary>
        /// Add a substitution for a specific parameter
        /// </summary>
        /// <param name="parameterName">The parameter name</param>
        /// <param name="parameterSubstitution">The substitution for the parameter. This
        /// parameter substitution will be HTML encoded for safety</param>
        public void addSubstitutionForParameter(string parameterName,
            string parameterSubstitution)
        {
            System.Diagnostics.Debug.Assert(!string.IsNullOrEmpty(parameterName));
            System.Diagnostics.Debug.Assert(!string.IsNullOrEmpty(parameterSubstitution));

            if (!parameters.Contains(parameterName))
            {
                throw new ArgumentException("Undefined parameter " + parameterName);
            }

            // Add the parameter replacement to the list, but HMTL encoded 
            this.replacements.Add(parameterName, HttpUtility.HtmlEncode(parameterSubstitution));
        }


        /// <summary>
        /// Delete a substitution parameter
        /// </summary>
        /// <param name="parameterName">The parameter name</param>
        public void deleteSubstitutionForParameter(string parameterName)
        {
            System.Diagnostics.Debug.Assert(!string.IsNullOrEmpty(parameterName));

            if (replacements.ContainsKey(parameterName))
            {
                replacements.Remove(parameterName);
            }
        }

        /// <summary>
        /// Get the final text for the resource with all substitutions performed.
        /// If there are some parameters that were not replaced, then they 
        /// remain in the original format {ParamName}
        /// </summary>
        /// <returns>The final text for the resource</returns>
        public string finalTextResourceWithReplacements()
        {
            // Substitute all parameters with their corresponding replacements.  
            // 
            StringBuilder resource = new StringBuilder(theOriginalString);
            for (int i = 0; i < parameters.Count; i++)
            {
                if (replacements.ContainsKey(parameters[i]))
                {
                    resource.Replace("{" + parameters[i] + "}",
                        (string)replacements[parameters[i]]);
                }
            }
            return resource.ToString();
        }

        /// <summary>
        /// Get the original parameter string without any substitutions
        /// </summary>
        /// <returns>The original parameter name</returns>
        public string originalResourceWithoutReplacements()
        {
            return theOriginalString;
        }

        /// <summary>
        /// Replace one parameter in a resource
        /// </summary>
        /// <param name="resourceFile">The name of the global resource file</param>
        /// <param name="resourceName">The name of the resource inside the resource file</param>
        /// <param name="parameterName">The name of the parameter to replace</param>
        /// <param name="parameterSubstitution">The substitution for the parameter. This
        /// parameter substitution will be HTML encoded for safety</param>
        /// <returns>The resource with the parameters replaced</returns>
        public static string ReplaceResourceWithParameters(string resourceFile, string resourceName, string parameterName, string parameterSubstitution)
        {
            ResourceReplacement resourceReplacement = new ResourceReplacement(resourceFile, resourceName);
            resourceReplacement.addSubstitutionForParameter(parameterName, parameterSubstitution);
            return resourceReplacement.finalTextResourceWithReplacements();
        }

        /// <summary>
        /// Replace two parameter in a resource
        /// </summary>
        /// <param name="resourceFile">The name of the global resource file</param>
        /// <param name="resourceName">The name of the resource inside the resource file</param>
        /// <param name="parameterName1">The name of the first parameter to replace</param>
        /// <param name="parameterSubstitution1">The substitution for the first parameter. This
        /// <param name="parameterName2">The name of the second parameter to replace</param>
        /// <param name="parameterSubstitution2">The substitution for the second parameter. This
        /// parameter substitution will be HTML encoded for safety</param>
        /// <returns>The resource with the parameters replaced</returns>
        public static string ReplaceResourceWithParameters(string resourceFile, string resourceName,
            string parameterName1, string parameterSubstitution1, string parameterName2, string parameterSubstitution2)
        {
            ResourceReplacement resourceReplacement = new ResourceReplacement(resourceFile, resourceName);
            resourceReplacement.addSubstitutionForParameter(parameterName1, parameterSubstitution1);
            resourceReplacement.addSubstitutionForParameter(parameterName2, parameterSubstitution2);
            return resourceReplacement.finalTextResourceWithReplacements();
        }

        /// <summary>
        /// Replace three parameters in a resource
        /// </summary>
        /// <param name="resourceFile">The name of the global resource file</param>
        /// <param name="resourceName">The name of the resource inside the resource file</param>
        /// <param name="parameterName1">The name of the first parameter to replace</param>
        /// <param name="parameterSubstitution1">The substitution for the first parameter. This
        /// <param name="parameterName2">The name of the second parameter to replace</param>
        /// <param name="parameterSubstitution2">The substitution for the second parameter. This
        /// <param name="parameterName3">The name of the third parameter to replace</param>
        /// <param name="parameterSubstitution3">The substitution for the third parameter. This
        /// parameter substitution will be HTML encoded for safety</param>
        /// <returns>The resource with the parameters replaced</returns>
        public static string ReplaceResourceWithParameters(string resourceFile, string resourceName,
            string parameterName1, string parameterSubstitution1, string parameterName2, string parameterSubstitution2,
            string parameterName3, string parameterSubstitution3)
        {
            ResourceReplacement resourceReplacement = new ResourceReplacement(resourceFile, resourceName);
            resourceReplacement.addSubstitutionForParameter(parameterName1, parameterSubstitution1);
            resourceReplacement.addSubstitutionForParameter(parameterName2, parameterSubstitution2);
            resourceReplacement.addSubstitutionForParameter(parameterName3, parameterSubstitution3);
            return resourceReplacement.finalTextResourceWithReplacements();
        }

        /// <summary>
        /// Replace one parameter in a resource for Validation
        /// </summary>
        /// <param name="resourceFile">The name of the global resource file</param>
        /// <param name="resourceName">The name of the resource inside the resource file</param>
        /// <param name="parameterName">The name of the parameter to replace</param>
        /// <param name="parameterSubstitution">The substitution for the parameter. This
        /// parameter substitution will be HTML encoded for safety</param>
        /// <returns>The resource with the parameters replaced</returns>
        public static string ReplaceResourceForValidation(string resourceFile, string resourceName, string parameterName, string parameterSubstitution)
        {
            return ReplaceResourceWithParameters(resourceFile, resourceName, parameterName, parameterSubstitution);
        }

        /// <summary>
        /// Replace two parameter in a resource for Validation
        /// </summary>
        /// <param name="resourceFile">The name of the global resource file</param>
        /// <param name="resourceName">The name of the resource inside the resource file</param>
        /// <param name="parameterName1">The name of the first parameter to replace</param>
        /// <param name="parameterSubstitution1">The substitution for the first parameter. This
        /// <param name="parameterName2">The name of the second parameter to replace</param>
        /// <param name="parameterSubstitution2">The substitution for the second parameter. This
        /// parameter substitution will be HTML encoded for safety</param>
        /// <returns>The resource with the parameters replaced</returns>
        public static string ReplaceResourceForValidation(string resourceFile, string resourceName,
            string parameterName1, string parameterSubstitution1, string parameterName2, string parameterSubstitution2)
        {
            return ReplaceResourceWithParameters(resourceFile, resourceName,
                parameterName1, parameterSubstitution1, parameterName2, parameterSubstitution2);
        }
    }
}
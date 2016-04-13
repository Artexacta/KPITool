using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

namespace Artexacta.App.Documents
{
    /// <summary>
    /// A document paragraph
    /// </summary>
    public class Paragraph
    {
        protected string text;
        protected int descriptionWeight;
        protected int titleWeight;

        /// <summary>
        /// Get or set the paragraph text
        /// </summary>
        public string Text
        {
            get { return text; }
            set { text = value; }
        }

        /// <summary>
        /// Returns an indication of how likely it is that this is a good description. Ranges from 0 to 100.
        /// </summary>
        public int DescriptionWeight
        {
            get { return descriptionWeight; }
            set { descriptionWeight = value; }
        }

        /// <summary>
        /// Returns an indication of how likely it is that this is a good document title. Ranges from 0 to 100.
        /// </summary>
        public int TitleWeight
        {
            get { return titleWeight; }
            set { titleWeight = value; }
        }

        /// <summary>
        /// Construct a paragraph
        /// </summary>
        /// <param name="text">The paragraph text</param>
        /// <param name="descriptionWeight">An indication of how likey it is that this is a good description.  0 to 100.</param>
        /// <param name="titleWeight">An indication of how likey it is that this is a good title. 0 to 100.</param>
        public Paragraph(string text, int descriptionWeight, int titleWeight)
        {
            Text = text;
            DescriptionWeight = descriptionWeight;
            TitleWeight = titleWeight;
        }

        /// <summary>
        /// Comparison utility function that can be used to sort a paragraph array by description weight
        /// </summary>
        /// <param name="x">Paragraph to compare</param>
        /// <param name="y">Paragraph to compare</param>
        /// <returns>-1 if x < y, 0 if x = y and 1 if x > y</returns>
        public static int CompareParagraphsByDescriptionWeight(Paragraph x, Paragraph y)
        {
            if (x == null)
            {
                if (y == null)
                {
                    // If x is null and y is null, they're
                    // equal. 
                    return 0;
                }
                else
                {
                    // If x is null and y is not null, y
                    // is greater. 
                    return -1;
                }
            }
            else
            {
                // If x is not null...
                //
                if (y == null)
                // ...and y is null, x is greater.
                {
                    return 1;
                }
                else
                {
                    // ...and y is not null, compare the description weights
                    //
                    return x.DescriptionWeight.CompareTo(y.DescriptionWeight);
                }
            }
        }

        /// <summary>
        /// Comparison utility function that can be used to sort a paragraph array by title weight
        /// </summary>
        /// <param name="x">Paragraph to compare</param>
        /// <param name="y">Paragraph to compare</param>
        /// <returns>-1 if x < y, 0 if x = y and 1 if x > y</returns>
        public static int CompareParagraphsByTitleWeight(Paragraph x, Paragraph y)
        {
            if (x == null)
            {
                if (y == null)
                {
                    // If x is null and y is null, they're
                    // equal. 
                    return 0;
                }
                else
                {
                    // If x is null and y is not null, y
                    // is greater. 
                    return -1;
                }
            }
            else
            {
                // If x is not null...
                //
                if (y == null)
                // ...and y is null, x is greater.
                {
                    return 1;
                }
                else
                {
                    // ...and y is not null, compare the description weights
                    //
                    return x.TitleWeight.CompareTo(y.TitleWeight);
                }
            }
        }
    }
}
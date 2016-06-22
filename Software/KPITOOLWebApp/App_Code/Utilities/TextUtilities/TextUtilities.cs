using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading;
using System.Web;

namespace Artexacta.App.Utilities.Text
{
    /// <summary>
    /// Summary description for TextUtilities
    /// </summary>
    public class TextUtilities
    {
        /// <summary>
        /// Centers a string padding with with spaces and to a specific length
        /// </summary>
        /// <param name="stringToCenter">The string to center</param>
        /// <param name="totalLength">The total length of the resulting string</param>
        /// <returns>The centered string</returns>
        public static string CenterString(string stringToCenter, int totalLength)
        {
            return CenterString(stringToCenter, totalLength, ' ');
        }

        /// <summary>
        /// Centers a string with a specific padding character and to a specific length
        /// </summary>
        /// <param name="stringToCenter">The string to center</param>
        /// <param name="totalLength">The total length of the resulting string</param>
        /// <param name="paddingCharacter">The character th use for the padding</param>
        /// <returns>The centered string</returns>
        public static string CenterString(string stringToCenter, int totalLength, char paddingCharacter)
        {
            int paddingNeeded = totalLength - stringToCenter.Length;

            if (paddingNeeded <= 0)
                return stringToCenter;

            int padLeft = paddingNeeded / 2;
            int padRight = totalLength - stringToCenter.Length - padLeft;

            StringBuilder result = new StringBuilder();
            for (int i = 0; i < padLeft; i++)
            {
                result.Append(paddingCharacter);
            }
            result.Append(stringToCenter);
            for (int i = 0; i < padRight; i++)
            {
                result.Append(paddingCharacter);
            }
            return result.ToString();
        }

        private readonly static string[] _numbersInWordsES = {
            "uno", "dos", "tres", "cuatro", "cinco", "seis", "siete", "ocho", "nueve",
            "diez", "once", "doce", "trece", "catorce", "quince", "dieciseis", "diecisiete", 
            "dieciocho", "diecinueve", "veinte", "veintiuno", "veintidos", "veintitres", 
            "veinticuatro", "veinticinco", "veintiseis", "veintisiete", "veintiocho", 
            "veintinueve", "treinta", "cuarenta", "cincuenta", "sesenta", "setenta", 
            "ochenta", "noventa","ciento", "doscientos", "trescientos", "cuatrocientos", 
            "quinientos", "seiscientos", "setecientos", "ochocientos", "novecientos"
            };

        private readonly static string[] _numbersInWordsEN = { 
            "one", "two", "three", "for", "five", "six", "seven", "eight", "nine",
            "ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", 
            "eighteen", "nineteen", "twenty", "twenty one", "twenty two", "twenty three", 
            "twenty four", "twenty five", "twenty six", "twenty seven", "twenty eight", 
            "twenty nine", "thirty", "fourty", "fifty", "sixty", "seventy", 
            "eighty", "ninety","one hundred", "two hundred", "three hundred", "four hundred", 
            "five hundred", "six hundred", "seven hundred", "eight hundred", "nine hundred"
            };

        private const string _centWordES = "centavo(s)";
        private const string _oneMillionWordES = "un millon";
        private const string _millionsWordES = "millones";
        private const string _oneThousandWordES = "un mil";
        private const string _thousandWordES = "mil";
        private const string _hundredWordES = "cien";
        private const string _oneHundredWordES = "ciento Un";
        private const string _zeroWithWordES = "cero con";
        private const string _withWordES = "con";
        private const string _andWordES = "y";

        private const string _centWordEN = "cent(s)";
        private const string _oneMillionWordEN = "one million";
        private const string _millionsWordEN = "millions";
        private const string _oneThousandWordEN = "one thousand";
        private const string _thousandWordEN = "thousand";
        private const string _hundredWordEN = "hundred";
        private const string _oneHundredWordEN = "hundred one";
        private const string _zeroWithWordEN = "zero with";
        private const string _withWordEN = "with";
        private const string _andWordEN = "-";

        /// <summary>
        /// Convierte un número decimal a palabras
        /// </summary>
        /// <param name="number">El número a convertir</param>
        /// <returns>El numero en palabras</returns>
        public static string ConvertirNumeroAPalabras(decimal number)
        {
            if (number > 999999999)
            {
                throw new ArgumentException("Numero demasiado grande");
            }

            StringBuilder Words;
            string FormattedNumberString;
            int decimalSeparatorLocation;
            int millionsPart;
            int thousandsPart;
            int hundredsPart;
            int decimalsPart;
            int hundreds;
            int tens;
            int units;
            int ActualNumber = 0;

            Words = new StringBuilder();

            FormattedNumberString = number.ToString("000000000.00");
            char DecimalSeparator = Convert.ToChar((Convert.ToString(1.1)).Trim().Substring(1, 1));
            decimalSeparatorLocation = FormattedNumberString.IndexOf(DecimalSeparator);

            millionsPart = Convert.ToInt32(FormattedNumberString.Substring(0, 3));
            thousandsPart = Convert.ToInt32(FormattedNumberString.Substring(3, 3));
            hundredsPart = Convert.ToInt32(FormattedNumberString.Substring(6, 3));

            decimalsPart = Convert.ToInt32(FormattedNumberString.Substring(decimalSeparatorLocation + 1, 2));

            for (int NumberPart = 1; NumberPart <= 3; NumberPart++)
            {

                switch (NumberPart)
                {
                    case 1:
                        {
                            ActualNumber = millionsPart;
                            if (millionsPart == 1)
                            {
                                Words.Append(_oneMillionWordES);
                                Words.Append(' ');
                                continue;
                            }
                            break;
                        }

                    case 2:
                        {
                            ActualNumber = thousandsPart;
                            if (millionsPart != 1 && millionsPart != 0)
                            {
                                Words.Append(_millionsWordES);
                                Words.Append(' ');
                            }

                            if (thousandsPart == 1)
                            {
                                Words.Append(_oneThousandWordES);
                                Words.Append(' ');
                                continue;
                            }
                            break;
                        }

                    case 3:
                        {
                            ActualNumber = hundredsPart;
                            if (thousandsPart != 1 && thousandsPart != 0)
                            {
                                Words.Append(_thousandWordES);
                                Words.Append(' ');
                            }
                            break;
                        }

                    case 4:
                        {

                            ActualNumber = decimalsPart;

                            if (decimalsPart != 0)
                            {
                                if (millionsPart == 0 && thousandsPart == 0 && hundredsPart == 0)
                                {
                                    Words.Append(_zeroWithWordES);
                                    Words.Append(' ');
                                }

                                else
                                {
                                    Words.Append(_withWordES);
                                    Words.Append(' ');
                                }

                            }

                            break;

                        }

                }

                hundreds = (int)(ActualNumber / 100);
                tens = (int)(ActualNumber - hundreds * 100) / 10;
                units = (int)(ActualNumber - (hundreds * 100 + tens * 10));
                if (ActualNumber == 0) continue;

                if (ActualNumber == 100)
                {
                    Words.Append(_hundredWordES);
                    Words.Append(' ');
                    continue;
                }

                else
                {
                    if (ActualNumber == 101 && NumberPart != 3)
                    {
                        Words.Append(_oneHundredWordES);
                        Words.Append(' ');
                        continue;
                    }

                    else
                    {
                        if (ActualNumber > 100)
                        {
                            Words.Append(_numbersInWordsES[hundreds + 35]);
                            Words.Append(' ');
                        }
                    }

                }

                if (tens < 3 && tens != 0)
                {
                    Words.Append(_numbersInWordsES[tens * 10 + units - 1]);
                    Words.Append(' ');
                }

                else
                {
                    if (tens > 2)
                    {
                        Words.Append(_numbersInWordsES[tens + 26]);
                        Words.Append(' ');

                        if (units == 0)
                        {
                            continue;
                        }

                        Words.Append(_andWordES);
                        Words.Append(' ');
                        Words.Append(_numbersInWordsES[units - 1]);
                        Words.Append(' ');

                    }
                    else
                    {
                        if (tens == 0 && units != 0)
                        {
                            Words.Append(_numbersInWordsES[units - 1]);
                            Words.Append(' ');
                        }
                    }
                }

            } // end for


            //if (decimalsPart != 0)
            //{
            //    Words.Append(_centWord);
            //}
            Words.Append(decimalsPart.ToString("00") + "/100");
            //Words.Append(" Bolivianos");

            // Resolve particular problems here.

            Words.Replace("uno mil", "un mil");

            string total = Words.ToString().Trim();

            return total.Substring(0, 1).ToUpper() + total.Substring(1, total.Length - 1);
        }

        public static string ConvertirNumeroAPalabrasEN(decimal number)
        {
            if (number > 999999999)
            {
                throw new ArgumentException("Numero demasiado grande");
            }

            StringBuilder Words;
            string FormattedNumberString;
            int decimalSeparatorLocation;
            int millionsPart;
            int thousandsPart;
            int hundredsPart;
            int decimalsPart;
            int hundreds;
            int tens;
            int units;
            int ActualNumber = 0;

            Words = new StringBuilder();

            FormattedNumberString = number.ToString("000000000.00");
            char DecimalSeparator = Convert.ToChar((Convert.ToString(1.1)).Trim().Substring(1, 1));
            decimalSeparatorLocation = FormattedNumberString.IndexOf(DecimalSeparator);

            millionsPart = Convert.ToInt32(FormattedNumberString.Substring(0, 3));
            thousandsPart = Convert.ToInt32(FormattedNumberString.Substring(3, 3));
            hundredsPart = Convert.ToInt32(FormattedNumberString.Substring(6, 3));

            decimalsPart = Convert.ToInt32(FormattedNumberString.Substring(decimalSeparatorLocation + 1, 2));

            for (int NumberPart = 1; NumberPart <= 3; NumberPart++)
            {

                switch (NumberPart)
                {
                    case 1:
                        {
                            ActualNumber = millionsPart;
                            if (millionsPart == 1)
                            {
                                Words.Append(_oneMillionWordEN);
                                Words.Append(' ');
                                continue;
                            }
                            break;
                        }

                    case 2:
                        {
                            ActualNumber = thousandsPart;
                            if (millionsPart != 1 && millionsPart != 0)
                            {
                                Words.Append(_millionsWordEN);
                                Words.Append(' ');
                            }

                            if (thousandsPart == 1)
                            {
                                Words.Append(_oneThousandWordEN);
                                Words.Append(' ');
                                continue;
                            }
                            break;
                        }

                    case 3:
                        {
                            ActualNumber = hundredsPart;
                            if (thousandsPart != 1 && thousandsPart != 0)
                            {
                                Words.Append(_thousandWordEN);
                                Words.Append(' ');
                            }
                            break;
                        }

                    case 4:
                        {

                            ActualNumber = decimalsPart;

                            if (decimalsPart != 0)
                            {
                                if (millionsPart == 0 && thousandsPart == 0 && hundredsPart == 0)
                                {
                                    Words.Append(_zeroWithWordEN);
                                    Words.Append(' ');
                                }

                                else
                                {
                                    Words.Append(_withWordEN);
                                    Words.Append(' ');
                                }

                            }

                            break;

                        }

                }

                hundreds = (int)(ActualNumber / 100);
                tens = (int)(ActualNumber - hundreds * 100) / 10;
                units = (int)(ActualNumber - (hundreds * 100 + tens * 10));
                if (ActualNumber == 0) continue;

                if (ActualNumber == 100)
                {
                    Words.Append(_hundredWordEN);
                    Words.Append(' ');
                    continue;
                }

                else
                {
                    if (ActualNumber == 101 && NumberPart != 3)
                    {
                        Words.Append(_oneHundredWordEN);
                        Words.Append(' ');
                        continue;
                    }

                    else
                    {
                        if (ActualNumber > 100)
                        {
                            Words.Append(_numbersInWordsEN[hundreds + 35]);
                            Words.Append(' ');
                        }
                    }

                }

                if (tens < 3 && tens != 0)
                {
                    Words.Append(_numbersInWordsEN[tens * 10 + units - 1]);
                    Words.Append(' ');
                }

                else
                {
                    if (tens > 2)
                    {
                        Words.Append(_numbersInWordsEN[tens + 26]);
                        Words.Append(' ');

                        if (units == 0)
                        {
                            continue;
                        }

                        Words.Append(_andWordEN);
                        Words.Append(' ');
                        Words.Append(_numbersInWordsEN[units - 1]);
                        Words.Append(' ');

                    }
                    else
                    {
                        if (tens == 0 && units != 0)
                        {
                            Words.Append(_numbersInWordsEN[units - 1]);
                            Words.Append(' ');
                        }
                    }
                }

            } // end for

            Words.Append(decimalsPart.ToString("00") + "/100");

            string total = Words.ToString().Trim();

            return total.Substring(0, 1).ToUpper() + total.Substring(1, total.Length - 1);
        }

        /// <summary>
        /// Convierte un número decimal a palabras
        /// </summary>
        /// <param name="number">El número a convertir</param>
        /// <returns>El numero en palabras</returns>
        public static string ConvertirNumeroAPalabrasSus(decimal number)
        {
            if (number > 999999999)
            {
                throw new ArgumentException("Numero demasiado grande");
            }

            StringBuilder Words;
            string FormattedNumberString;
            int decimalSeparatorLocation;
            int millionsPart;
            int thousandsPart;
            int hundredsPart;
            int decimalsPart;
            int hundreds;
            int tens;
            int units;
            int ActualNumber = 0;

            Words = new StringBuilder();

            FormattedNumberString = number.ToString("000000000.00");
            char DecimalSeparator = Convert.ToChar((Convert.ToString(1.1)).Trim().Substring(1, 1));
            decimalSeparatorLocation = FormattedNumberString.IndexOf(DecimalSeparator);

            millionsPart = Convert.ToInt32(FormattedNumberString.Substring(0, 3));
            thousandsPart = Convert.ToInt32(FormattedNumberString.Substring(3, 3));
            hundredsPart = Convert.ToInt32(FormattedNumberString.Substring(6, 3));

            decimalsPart = Convert.ToInt32(FormattedNumberString.Substring(decimalSeparatorLocation + 1, 2));

            for (int NumberPart = 1; NumberPart <= 3; NumberPart++)
            {

                switch (NumberPart)
                {
                    case 1:
                        {
                            ActualNumber = millionsPart;
                            if (millionsPart == 1)
                            {
                                Words.Append(_oneMillionWordES);
                                Words.Append(' ');
                                continue;
                            }
                            break;
                        }

                    case 2:
                        {
                            ActualNumber = thousandsPart;
                            if (millionsPart != 1 && millionsPart != 0)
                            {
                                Words.Append(_millionsWordES);
                                Words.Append(' ');
                            }

                            if (thousandsPart == 1)
                            {
                                Words.Append(_oneThousandWordES);
                                Words.Append(' ');
                                continue;
                            }
                            break;
                        }

                    case 3:
                        {
                            ActualNumber = hundredsPart;
                            if (thousandsPart != 1 && thousandsPart != 0)
                            {
                                Words.Append(_thousandWordES);
                                Words.Append(' ');
                            }
                            break;
                        }

                    case 4:
                        {

                            ActualNumber = decimalsPart;

                            if (decimalsPart != 0)
                            {
                                if (millionsPart == 0 && thousandsPart == 0 && hundredsPart == 0)
                                {
                                    Words.Append(_zeroWithWordES);
                                    Words.Append(' ');
                                }

                                else
                                {
                                    Words.Append(_withWordES);
                                    Words.Append(' ');
                                }

                            }

                            break;

                        }

                }

                hundreds = (int)(ActualNumber / 100);
                tens = (int)(ActualNumber - hundreds * 100) / 10;
                units = (int)(ActualNumber - (hundreds * 100 + tens * 10));
                if (ActualNumber == 0) continue;

                if (ActualNumber == 100)
                {
                    Words.Append(_hundredWordES);
                    Words.Append(' ');
                    continue;
                }

                else
                {
                    if (ActualNumber == 101 && NumberPart != 3)
                    {
                        Words.Append(_oneHundredWordES);
                        Words.Append(' ');
                        continue;
                    }

                    else
                    {
                        if (ActualNumber > 100)
                        {
                            Words.Append(_numbersInWordsES[hundreds + 35]);
                            Words.Append(' ');
                        }
                    }

                }

                if (tens < 3 && tens != 0)
                {
                    Words.Append(_numbersInWordsES[tens * 10 + units - 1]);
                    Words.Append(' ');
                }

                else
                {
                    if (tens > 2)
                    {
                        Words.Append(_numbersInWordsES[tens + 26]);
                        Words.Append(' ');

                        if (units == 0)
                        {
                            continue;
                        }

                        Words.Append(_andWordES);
                        Words.Append(' ');
                        Words.Append(_numbersInWordsES[units - 1]);
                        Words.Append(' ');

                    }
                    else
                    {
                        if (tens == 0 && units != 0)
                        {
                            Words.Append(_numbersInWordsES[units - 1]);
                            Words.Append(' ');
                        }
                    }
                }

            } // end for


            //if (decimalsPart != 0)
            //{
            //    Words.Append(_centWord);
            //}
            Words.Append(decimalsPart.ToString("00") + "/100");
            Words.Append(" $us");

            // Resolve particular problems here.

            Words.Replace("uno mil", "un mil");

            string total = Words.ToString().Trim();

            return total.Substring(0, 1).ToUpper() + total.Substring(1, total.Length - 1);
        }

        public static string[] SplitStringAtSpaces(string stringToSplit, int maxWidth)
        {
            // The idea is to split a long phrase into lines, each no longer than
            // masWidth and to break the lines at spaces.  For example, the text
            // "This long line would be split into componentes at spaces" with the parameter 15
            // would result in the array:
            //
            // This long line
            // would be split
            // into
            // componentes at
            // spaces
            //

            List<String> splitString = new List<string>();

            if (String.IsNullOrEmpty(stringToSplit))
                return null;

            if (maxWidth < 3)
                throw new ArgumentException("maxWidth parameter must be greater than 3");

            string[] parts = stringToSplit.Split(new char[] { ' ' });

            StringBuilder currentLine = new StringBuilder();

            foreach (string part in parts)
            {

                if (currentLine.Length == 0)
                {
                    // We are starting a line.  Add the current word no mater what
                    currentLine.Append(part);
                }
                else if (currentLine.Length + part.Length + 1 >= maxWidth)
                {
                    // The next word does not fit inside this line, so add a new line and put the new word there
                    splitString.Add(currentLine.ToString());
                    currentLine = new StringBuilder();
                    currentLine.Append(part);
                }
                else
                {
                    // The new word fits in this line, so add it there.
                    currentLine.Append(" ");
                    currentLine.Append(part);
                }
            }

            splitString.Add(currentLine.ToString());

            return splitString.ToArray();
        }

        public static decimal GetDecimalFromString(string theString)
        {
            // Return if string is empty
            if (String.IsNullOrEmpty(theString))
                throw new ArgumentNullException("The input string is invalid.");

            CultureInfo culture = null;
            decimal number;
            culture = null;

            // Try to see if we can find the character that is used to mark a decimal
            int position = theString.LastIndexOfAny(new char[] { '.', ',' });

            string tryCulture = null;
            if (position > 0 && theString[position] == '.')
                tryCulture = "en-US";
            else if (position > 0 && theString[position] == ',')
                tryCulture = "es-ES";

            if (tryCulture != null)
            {

                // Now try our first choice of culture.
                culture = CultureInfo.GetCultureInfo(tryCulture);
                try
                {
                    number = decimal.Parse(theString, culture);
                    return number;
                }
                catch { }
            }

            // We failed.  Try to get the decimal with the Curent culture. If we fail, then
            // try the Invariant culture.

            // Determine if value can be parsed using current culture.
            try
            {
                culture = CultureInfo.CurrentCulture;
                number = decimal.Parse(theString, culture);
                return number;
            }
            catch { }

            // If Parse operation fails, see if there's a neutral culture.
            try
            {
                culture = culture.Parent;
                number = decimal.Parse(theString, culture);
                return number;
            }
            catch { }

            // If there is no neutral culture or if parse operation fails, use
            // the invariant culture.
            culture = CultureInfo.InvariantCulture;
            try
            {
                number = decimal.Parse(theString, culture);
                return number;
            }
            catch { }

            // All attempts to parse the string have failed; rethrow the exception.
            throw new FormatException(String.Format("Unable to parse '{0}'.", theString));
        }

        public static string ConvertSearchStringToContainsTSQLTerm(string searchString, bool useNear)
        {
            // We need to split the search string into components.  For example, the search string:
            //          This is "some test*" of the system
            // would result in the T-SQL Contains search term:
            //          This AND is and "some test*" AND of AND the AND system

            if (string.IsNullOrEmpty(searchString) || string.IsNullOrEmpty(searchString.Trim()))
            {
                return "";
            }

            string useString = searchString.Trim();

            List<string> theTokenList = new List<string>();

            bool sawQuote = false;
            char lastChar = ' ';
            int lastCharPos = -1;

            for (int i = 0; i < useString.Length; i++)
            {
                char currChar = useString[i];

                if (lastChar == '"' && (currChar != ' ' && currChar != '\t') && !sawQuote)
                {
                    // Last character was a closing quote.  This character should have been a space.
                    throw new ArgumentException("Invalid use of quote.  Character after quote is not a space");
                }

                if ((currChar == ' ' || currChar == '\t') && !sawQuote)
                {
                    // We have a space that is not inside a quoted string.  This means that the previous 
                    // word is a token.  Extract it.
                    lastCharPos += 1;
                    string newPart = useString.Substring(lastCharPos, i - lastCharPos);

                    if (!string.IsNullOrEmpty(newPart))
                    {
                        // The part is non empty.  

                        // If this is a quoted string, trim it and discard empty quoted strings
                        if (newPart[0] == '"')
                        {
                            newPart = "\"" + newPart.Substring(1, newPart.Length - 2).Trim() + "\"";
                        }

                        if (newPart[0] == '"')
                        {
                            // The part is quoted. Only add if not empty.
                            if (newPart.Length > 2)
                            {
                                theTokenList.Add(newPart);
                            }
                        }
                        else
                        {
                            theTokenList.Add(newPart);
                        }
                    }

                    lastCharPos = i;
                }

                if (currChar == '"' && !sawQuote && lastChar != ' ' && lastChar != '\t')
                {
                    // We are opening a quote, but the last character was not a space.  This
                    // means a strng of the form aaaaaa"dddd  and this is not legal.  Quotes 
                    // close and after have a space and open at the beginning or after a space.
                    throw new ArgumentException("Invalid use of double quotes. Used after non space");
                }

                // we are openning or closing a quote.
                if (currChar == '"')
                {
                    sawQuote = !sawQuote;
                }

                lastChar = currChar;
            }

            if (sawQuote && lastChar != '"')
            {
                // If we saw a quote and this is not the end quote... then we have an unclosed quote
                throw new ArgumentException("Unclosed quote");
            }

            // Extract the last token, if any. 

            lastCharPos += 1;
            string lastPart = useString.Substring(lastCharPos, useString.Length - lastCharPos);

            // If this is a quoted string, trim it and discard empty quoted strings
            if (lastPart[0] == '"')
            {
                lastPart = "\"" + lastPart.Substring(1, lastPart.Length - 2).Trim() + "\"";
            }

            if (!string.IsNullOrEmpty(lastPart))
            {
                // The part is non empty.  

                if (lastPart[0] == '"')
                {
                    // The part is quoted. Only add if not empty.
                    if (lastPart.Length > 2)
                    {
                        theTokenList.Add(lastPart);
                    }
                }
                else
                {
                    theTokenList.Add(lastPart);
                }
            }

            if (theTokenList.Count == 0)
            {
                return "";
            }

            // Now concatenate the tokens with AND or NEAR
            StringBuilder finalString = new StringBuilder();
            foreach (string part in theTokenList)
            {
                if (finalString.Length == 0)
                {
                    finalString.Append(part);
                }
                else
                {
                    finalString.Append(useNear ? " Near " : " AND ");
                    finalString.Append(part);
                }
            }

            return finalString.ToString();
        }

        /// <summary>
        /// Removes leading spaces and trailing spaces from a string
        /// </summary>
        /// <param name="theString">The string to cleanup</param>
        /// <returns>The clean string</returns>
        public static string RemoveLeadingAndTrailingSpaces(string theString)
        {
            if (String.IsNullOrEmpty(theString))
            {
                return theString;
            }
            return theString.Trim();
        }

        /// <summary>
        /// Adds an error message to an HTML error list
        /// </summary>
        /// <param name="errorList">The HTML error list</param>
        /// <param name="errorMessage">The error message to add</param>
        public static void AddErrorMessageToErrorList(StringBuilder errorList, string errorMessage)
        {
            // The list is assumed to be of the form <ul><li>TXT</li><li>TXT</li></ul>
            // without spaces inside the HTML elements.

            if (string.IsNullOrEmpty(errorMessage))
            {
                throw new ArgumentException("Error message must not be null");
            }
            if (errorList == null)
            {
                throw new ArgumentException("Error list must not be null");
            }

            if (errorList.Length == 0)
            {
                errorList.Append("<ul><li>");
                errorList.Append(errorMessage);
                errorList.Append("</li></ul>");
            }
            else
            {
                if (errorList.Length < 18)
                {
                    throw new ArgumentException("Invalid error list format");
                }
                errorList.Insert(errorList.Length - 10, "<li>" + errorMessage + "</li>");
            }
        }

        public static string StripHTML(string source)
        {
            try
            {
                string result;

                // Remove HTML Development formatting
                // Replace line breaks with space
                // because browsers inserts space
                result = source.Replace("\r", " ");
                // Replace line breaks with space
                // because browsers inserts space
                result = result.Replace("\n", " ");
                // Remove step-formatting
                result = result.Replace("\t", string.Empty);
                // Remove repeating speces becuase browsers ignore them
                result = System.Text.RegularExpressions.Regex.Replace(result,
                                                                      @"( )+", " ");

                // Remove the header (prepare first by clearing attributes)
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"<( )*head([^>])*>", "<head>",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"(<( )*(/)( )*head( )*>)", "</head>",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         "(<head>).*(</head>)", string.Empty,
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);

                // remove all scripts (prepare first by clearing attributes)
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"<( )*script([^>])*>", "<script>",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"(<( )*(/)( )*script( )*>)", "</script>",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                //result = System.Text.RegularExpressions.Regex.Replace(result, 
                //         @"(<script>)([^(<script>\.</script>)])*(</script>)",
                //         string.Empty, 
                //         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"(<script>).*(</script>)", string.Empty,
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);

                // remove all styles (prepare first by clearing attributes)
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"<( )*style([^>])*>", "<style>",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"(<( )*(/)( )*style( )*>)", "</style>",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         "(<style>).*(</style>)", string.Empty,
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);

                // insert tabs in spaces of <td> tags
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"<( )*td([^>])*>", "\t",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);

                // insert line breaks in places of <BR> and <LI> tags
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"<( )*br( )*/?( )*>", "\n",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"<( )*li( )*>", "\n",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);

                // insert line paragraphs (double line breaks) in place
                // if <P>, <DIV> and <TR> tags
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"<( )*div([^>])*>", "\n\n",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"<( )*tr([^>])*>", "\n\n",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"<( )*p([^>])*>", "\n\n",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);

                // Remove remaining tags like <a>, links, images,
                // comments etc - anything thats enclosed inside < >
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"<[^>]*>", string.Empty,
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);

                // replace special characters:
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"&nbsp;", " ",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"&bull;", " * ",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"&lsaquo;", "<",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"&rsaquo;", ">",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"&trade;", "(tm)",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"&frasl;", "/",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"<", "<",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @">", ">",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"&copy;", "(c)",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"&reg;", "(r)",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"&quot;", "\"",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);

                // Replace accented characters
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"&aacute;", "á",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"&eacute;", "é",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"&iacute;", "í",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"&oacute;", "ó",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"&uacute;", "ú",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"&ntilde;", "ñ",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"&auml;", "ä",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"&euml;", "ë",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"&iuml;", "ï",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"&ouml;", "ö",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"&uuml;", "ü",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"&acirc;", "â",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"&acirc;", "ê",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"&acirc;", "î",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"&acirc;", "ô",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"&acirc;", "û",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);

                // Remove all others. More can be added, see
                // http://hotwired.lycos.com/webmonkey/reference/special_characters/
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         @"&(.{2,6});", string.Empty,
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);

                // for testng
                //System.Text.RegularExpressions.Regex.Replace(result, 
                //       this.txtRegex.Text,string.Empty, 
                //       System.Text.RegularExpressions.RegexOptions.IgnoreCase);

                // Remove extra line breaks and tabs:
                // replace over 2 breaks with 2 and over 4 tabs with 4. 
                // Prepare first to remove any whitespaces inbetween
                // the escaped characters and remove redundant tabs inbetween linebreaks
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         "(\n)( )+(\n)", "\n\n",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         "(\t)( )+(\t)", "\t\t",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         "(\t)( )+(\n)", "\t\r",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         "(\n)( )+(\t)", "\n\t",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);

                // Remove redundant tabs
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         "(\n)(\t)+(\n)", "\n\n",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);

                // Remove multible tabs following a linebreak with just one tab
                result = System.Text.RegularExpressions.Regex.Replace(result,
                         "(\n)(\t)+", "\n\t",
                         System.Text.RegularExpressions.RegexOptions.IgnoreCase);

                // make line breaking consistent
                //result = result.Replace("\n", "\n\r");

                // Thats it.
                return result;

            }
            catch (Exception e)
            {
                throw e;
            }
        }

        public static string GetDateTimeToString(DateTime date)
        {
            string lang = LanguageUtilities.GetLanguageFromContext();
            string langCulture = "";
            switch (lang)
            {
                case "es":
                    langCulture = "es-ES";
                    break;
                case "en":
                    langCulture = "en-US";
                    break;
            }
            CultureInfo culture = new CultureInfo(langCulture);
            return date.ToString("dd-MMM-yyyy", culture);
        }

    }
}
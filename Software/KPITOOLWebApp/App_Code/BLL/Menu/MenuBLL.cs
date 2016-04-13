using System;
using System.Collections.Generic;
using System.Web;
using System.IO;
using System.Text;
using System.Xml;
using System.Xml.XPath;

namespace Artexacta.App.Menu.MenuBLL
{
    /// <summary>
    /// Process menu items
    /// </summary>
    public class MenuBLL
    {
        public MenuBLL()
        {
        }

        public static List<Menu> ReadMenuFromXMLConfiguration()
        {
            string xmlMenu = "";
            using (TextReader tr = new StreamReader(HttpContext.Current.Request.MapPath("~/DataFiles/Menu.xml")))
            {
                xmlMenu = tr.ReadToEnd();
            }

            TextReader x = new StringReader(xmlMenu);
            XPathDocument document = new XPathDocument(x);
            XPathNavigator navigator = document.CreateNavigator().SelectSingleNode("/Home");

            return RecursiveMenuRead(navigator, "1");
        }

        public static List<Menu> RecursiveMenuRead(XPathNavigator navigator, string level)
        {
            List<Menu> theList = new List<Menu>();

            XPathNodeIterator listaItems = navigator.Select("Menu");

            int i = 0;
            while (listaItems.MoveNext())
            {
                i += 1;
                string currentLevel = level + "." + i.ToString();

                string resourceFile = listaItems.Current.GetAttribute("resourceFile", "");
                string resourceItem = listaItems.Current.GetAttribute("resourceItem", "");
                string url = listaItems.Current.GetAttribute("url", "");
                string isPublicString = listaItems.Current.GetAttribute("public", "");
                string menuClass = listaItems.Current.GetAttribute("class", "");
                string menuIcon = listaItems.Current.GetAttribute("icon", "");

                if (String.IsNullOrEmpty(resourceFile))
                    throw new Exception(Resources.InitMasterPage.MensajeArchivoVacio + " " + currentLevel);
                if (String.IsNullOrEmpty(resourceItem))
                    throw new Exception(Resources.InitMasterPage.MensajeArchivoVacio + " " + currentLevel);
                if (url == null)
                    url = "";
                if (String.IsNullOrEmpty(isPublicString))
                    throw new Exception(Resources.InitMasterPage.MensajeItemPublicoVacio + " " + currentLevel);
                if (isPublicString.Trim().ToUpper() != "TRUE" && isPublicString.Trim().ToUpper() != "FALSE")
                    throw new Exception(Resources.InitMasterPage.MensajeValorInvalidoItem + " " + currentLevel);

                bool isPublic = Convert.ToBoolean(isPublicString);

                if (menuClass == null)
                    menuClass = "";

                string menuText = (string)HttpContext.GetGlobalResourceObject(resourceFile, resourceItem);

                if (string.IsNullOrEmpty(menuText))
                {
                    string mensaje = "";

                    mensaje = Artexacta.App.Utilities.ResourceReplacement.ReplaceResourceWithParameters("Configuration", "MensajeRecursoNoDefinido",
                        "resourceItem", resourceItem, "resourceFile", resourceFile, "item", currentLevel);

                    throw new Exception(mensaje);
                }

                if (!isPublic && String.IsNullOrEmpty(menuClass))
                    throw new Exception(Resources.InitMasterPage.MensajeMenuNoPublico + " " + currentLevel);

                if (menuIcon == null)
                    menuIcon = "";


                Menu newMenu = new Menu(menuText, url, menuClass, isPublic, menuIcon);

                newMenu.SubMenus = RecursiveMenuRead(listaItems.Current, currentLevel);

                theList.Add(newMenu);
            }

            return theList;
        }

        /// <summary>
        /// Construct a new Menu list recursively but with only the accessible items to the current user
        /// </summary>
        public static List<Menu> RecursiveConstructionOfVisibleMenus(List<Menu> theOriginalMenus, List<string> userClasses)
        {
            if (theOriginalMenus == null)
                return null;

            List<Menu> theCurrentList = new List<Menu>();

            foreach (Menu menuItem in theOriginalMenus)
            {

                List<Menu> subMenu = RecursiveConstructionOfVisibleMenus(menuItem.SubMenus, userClasses);

                bool addCurrent = false;

                // If we are a leaf, then we add this node if it is accessible to the user AND the node has a URL!
                if (
                    (subMenu == null || subMenu.Count == 0) &&
                    (menuItem.IsPublic || userClasses.Contains(menuItem.Class.ToUpper())) &&
                    (!String.IsNullOrEmpty(menuItem.URL))
                  )
                    addCurrent = true;

                // If we are are not a leaf, then we add this node ONLY if it is accessible to the user
                if (
                    (subMenu != null && subMenu.Count > 0) &&
                    (menuItem.IsPublic || userClasses.Contains(menuItem.Class))
                  )
                    addCurrent = true;
                if (addCurrent)
                {
                    Menu newMenu = new Menu(menuItem.Text, menuItem.URL, menuItem.Class, menuItem.IsPublic, menuItem.GetIcon);
                    newMenu.SubMenus = subMenu;
                    theCurrentList.Add(newMenu);
                }
            }

            return theCurrentList;
        }

        public static string GetMenuXML(List<Menu> theMenus)
        {
            return "<?xml version=\"1.0\" encoding=\"utf-8\" ?>\n" +
               "<Root text=\"start\">\n" +
               RecursiveConstructionOfMenuXML(theMenus, 1) + "\n" +
               "</Root>";
        }
        public static string GetMenuXML(List<Menu> theMenus, int menuLevel)
        {
            string[] menuClassLevel = { "side-menu", "", "", "", "" };
            string classOrId = (menuLevel == 0 ? "id=\"side-menu\"" : "");
            StringBuilder menuHtml =

                new StringBuilder("<ul " + classOrId + "class=\"" + menuClassLevel[menuLevel > 2 ? 2 : menuLevel] + "\">\n");


            foreach (Artexacta.App.Menu.Menu objMenu in theMenus)
            {
                if (objMenu.SubMenus.Count > 0)
                    menuHtml.Append("<li class=\"sm-sub\">");
                else
                    menuHtml.Append("<li>");

                string navigateUrl = objMenu.URL;
                if (objMenu.URL.StartsWith("~"))
                {
                    string appPath = HttpContext.Current.Request.ApplicationPath;

                    if (appPath == "/")
                        appPath = "";

                    navigateUrl = appPath + objMenu.URL.Substring(1);
                }

                menuHtml.Append("<a");
                if (!string.IsNullOrEmpty(navigateUrl))
                    menuHtml.Append(" href=\"" + navigateUrl + "\"");
                else
                    menuHtml.Append(" href=\"javascript:void(0)\"");
                string hasIcon = (objMenu.GetIcon != "" ? "<i class=\"" + objMenu.GetIcon + "\"></i>" : "");
                string isFirstLevel = (menuLevel == 0 ? "<span>" + objMenu.Text + "</span>" : objMenu.Text);
                string hasChilds = (objMenu.SubMenus.Count > 0 ? "<span class=\"fa fa-arrow\"></span>" : "");
                menuHtml.Append(">" + hasIcon + isFirstLevel + hasChilds + "</a>");

                // Recursive call for the submenus
                if (objMenu.SubMenus.Count > 0)
                {
                    menuHtml.Append(GetMenuXML(objMenu.SubMenus, menuLevel + 1));
                }
                menuHtml.Append("</li>\n");
            }
            menuHtml.Append("</ul>\n");
            return menuHtml.ToString();
        }

        /*public static string GetMenuXML(List<Menu> theMenus, int menuLevel)
        {
            StringBuilder menuHtml = new StringBuilder();

            if (menuLevel == 0)
            {
                menuHtml.Append("<Menu>");
            }

            menuHtml.Append("<Group>");

            foreach (Artexacta.App.Menu.Menu objMenu in theMenus)
            {
                string navigateUrl = objMenu.URL;
                if (objMenu.URL.StartsWith("~"))
                {
                    string appPath = HttpContext.Current.Request.ApplicationPath;

                    if (appPath == "/")
                        appPath = "";

                    navigateUrl = appPath + objMenu.URL.Substring(1);

                }
                menuHtml.Append("<Item Text=\"" + objMenu.Text + "\"");

                if (!string.IsNullOrEmpty(navigateUrl))
                    menuHtml.Append(" Href=\"" + navigateUrl + "\"");

                menuHtml.Append(" >");

                // Recursive call for the submenus
                if (objMenu.SubMenus.Count > 0)
                {
                    menuHtml.Append(GetMenuXML(objMenu.SubMenus, menuLevel + 1));
                }
                menuHtml.Append("</Item>");
            }

            menuHtml.Append("</Group>");

            if (menuLevel == 0)
                menuHtml.Append("</Menu>");

            return menuHtml.ToString();
        }*/

        public static string RecursiveConstructionOfMenuXML(List<Menu> theMenus, int level)
        {
            if (theMenus == null || theMenus.Count == 0)
                return "";

            StringBuilder theIndent = new StringBuilder();
            for (int i = 0; i < level; i++)
                theIndent.Append("  ");

            StringBuilder theXML = new StringBuilder();

            foreach (Menu item in theMenus)
            {
                theXML.Append(theIndent.ToString());
                if (level == 1)
                    theXML.Append("<Menu ");
                else
                    theXML.Append("<Menu ");
                theXML.Append("text=\"" + item.Text + "\" ");
                if (!String.IsNullOrEmpty(item.URL))
                    theXML.Append(" url=\"" + item.URL + "\" ");
                else
                    theXML.Append(" url=\"javascript:void(0)\" ");
                theXML.Append(">\n");
                theXML.Append(RecursiveConstructionOfMenuXML(item.SubMenus, level + 1));
                theXML.Append(theIndent.ToString());
                if (level == 1)
                    theXML.Append("</Menu>\n");
                else
                    theXML.Append("</Menu>\n");
            }

            return theXML.ToString();
        }
    }
}
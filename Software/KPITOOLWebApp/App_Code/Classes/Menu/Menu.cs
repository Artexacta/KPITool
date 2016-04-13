using System;
using System.Collections.Generic;
using System.Web;

namespace Artexacta.App.Menu
{
    /// <summary>
    /// Represents a menu option for the main system menu
    /// </summary>
    public class Menu
    {
        string _text = "";
        string _url = "";
        string _class = "";
        bool _public = false;
        string _icon = "";

        List<Menu> _subMenus = null;

        public string Text
        {
            get { return _text; }
            set { _text = value; }
        }

        public string URL
        {
            get { return _url; }
            set { _url = value; }
        }

        public string Class
        {
            get { return _class; }
            set { _class = value; }
        }

        public bool IsPublic
        {
            get { return _public; }
            set { _public = value; }
        }

        public List<Menu> SubMenus
        {
            get { return _subMenus; }
            set { _subMenus = value; }
        }

        public string GetIcon
        {
            get { return _icon; }
            set { _icon = value; }
        }

        public Menu()
        {
        }

        public Menu(string text, string url, string menuClass, bool isPublic, string icon)
        {
            _text = text;
            _url = url;
            _class = menuClass;
            _public = isPublic;
            _icon = icon;
            _subMenus = new List<Menu>();
        }
    }
}
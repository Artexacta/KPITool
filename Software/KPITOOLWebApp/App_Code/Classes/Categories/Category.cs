using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.Categories
{
    /// <summary>
    /// A KPI Category
    /// </summary>
    public class Category
    {

        private string _categoryID;
        private string _categoryName;
        private List<CategoryItem> _categoryItems;

        public List<CategoryItem> Items
        {
            get { return _categoryItems; }
            set { _categoryItems = value; }
        }

        public string Name
        {
            get { return _categoryName; }
            set { _categoryName = value; }
        }

        public string ID
        {
            get { return _categoryID; }
            set { _categoryID = value; }
        }

        public Category()
        {
        }

        public Category(string id, string name, List<CategoryItem> items)
        {
            _categoryID = id;
            _categoryName = name;
            _categoryItems = items;
        }
    }
}
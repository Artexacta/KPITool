using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Artexacta.App.Categories
{
    /// <summary>
    /// A KPI Category Item
    /// </summary>
    public class CategoryItem
    {
        private string _categoryItemID;
        private string _categoryItemName;
        private string _categoryID;
        private decimal? _target;

        public decimal? Target
        {
            get { return _target; }
            set { _target = value; }
        }

        public string ItemID
        {
            get { return _categoryItemID; }
            set { _categoryItemID = value; }
        }

        public string ItemName
        {
            get { return _categoryItemName; }
            set { _categoryItemName = value; }
        }

        public string CategoryID
        {
            get { return _categoryID; }
            set { _categoryID = value; }
        }

        public CategoryItem()
        {
        }

        public CategoryItem(string id, string name, decimal? target)
        {
            _categoryItemID = id;
            _categoryItemName = name;
            _target = target;
        }

        public CategoryItem(string categoryItemID, string name, string categoryID)
        {
            _categoryItemID = categoryItemID;
            _categoryItemName = name;
            _categoryID = categoryID;
        }

    }
}
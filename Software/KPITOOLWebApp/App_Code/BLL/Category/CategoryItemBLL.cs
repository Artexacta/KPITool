using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using CategoryDSTableAdapters;

namespace Artexacta.App.Categories
{
    /// <summary>
    /// Summary description for CategoryItemBLL
    /// </summary>
    [System.ComponentModel.DataObject]
    public class CategoryItemBLL
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        CategoryItemsTableAdapter _theAdapter = null;

        protected CategoryItemsTableAdapter theAdapter
        {
            get
            {
                if (_theAdapter == null)
                    _theAdapter = new CategoryItemsTableAdapter();
                return _theAdapter;
            }
        }

        public CategoryItemBLL()
        {
        }

        private static CategoryItem FillRecord(CategoryDS.CategoryItemsRow row)
        {
            CategoryItem theNewRecord = new CategoryItem(
                row.categoryItemID,
                row.name,
                row.categoryID);

            return theNewRecord;
        }

        public static List<CategoryItem> GetCategoriesItemByCategoryId(string categoryId)
        {
            if(string.IsNullOrEmpty(categoryId))
                throw new ArgumentException(Resources.Categories.MessageEmptyCategoryId);

            List<CategoryItem> theList = new List<CategoryItem>();
            CategoryItem theData = null;
            try
            {
                CategoryItemsTableAdapter localAdapter = new CategoryItemsTableAdapter();
                CategoryDS.CategoryItemsDataTable theTable = localAdapter.GetCategoryItemsByCategoryId(categoryId);

                if (theTable != null && theTable.Rows.Count > 0)
                {
                    foreach (CategoryDS.CategoryItemsRow theRow in theTable)
                    {
                        theData = FillRecord(theRow);
                        theList.Add(theData);
                    }
                }
            }
            catch (Exception exc)
            {
                log.Error("Error en GetCategoriesItemByCategoryId para categoryId: " + categoryId, exc);
                throw new ArgumentException(Resources.Categories.MessageErrorGetItemsByCategory);
            }

            return theList;
        }

        public static CategoryItem GetCategoryItemById(string categoryItemId, string categoryId)
        {
            if (string.IsNullOrEmpty(categoryItemId))
                throw new ArgumentException(Resources.Categories.MessageEmptyItemId);

            if (string.IsNullOrEmpty(categoryId))
                throw new ArgumentException(Resources.Categories.MessageEmptyCategoryId);

            CategoryItem theData = null;
            try
            {
                CategoryItemsTableAdapter localAdapter = new CategoryItemsTableAdapter();
                CategoryDS.CategoryItemsDataTable theTable = localAdapter.GetCategoryItemById(categoryItemId, categoryId);
                if (theTable != null && theTable.Rows.Count > 0)
                {
                    CategoryDS.CategoryItemsRow theRow = theTable[0];
                    theData = FillRecord(theRow);
                }
            }
            catch (Exception exc)
            {
                log.Error("Error en GetCategoryItemById para categoryItemId: " + categoryItemId + " y categoryId: " + categoryId, exc);
                throw new ArgumentException(Resources.Categories.MessageErrorGetItem);
            }

            return theData;
        }

        public static void InsertCategoryItem(string categoryItemId, string categoryId, string name)
        {
            if (string.IsNullOrEmpty(categoryItemId))
                throw new ArgumentException(Resources.Categories.MessageEmptyItemId);

            if (string.IsNullOrEmpty(categoryId))
                throw new ArgumentException(Resources.Categories.MessageEmptyCategoryId);

            if (string.IsNullOrEmpty(name))
                throw new ArgumentException(Resources.Categories.MessageEmptyNameItem);

            try
            {
                CategoryItemsTableAdapter localAdapter = new CategoryItemsTableAdapter();
                localAdapter.InsertCategoryItem(categoryId, categoryItemId, name);
            }
            catch (Exception exc)
            {
                log.Error("Error en InsertCategoryItem para categoryItemId: " + categoryItemId + ", categoryId: " + categoryId + " y name: " + name, exc);
                throw new ArgumentException(Resources.Categories.MessageErrorCreateItem);
            }
        }

        public static void UpdateCategoryItem(string categoryItemId, string categoryId, string name)
        {
            if (string.IsNullOrEmpty(categoryItemId))
                throw new ArgumentException(Resources.Categories.MessageEmptyItemId);

            if (string.IsNullOrEmpty(categoryId))
                throw new ArgumentException(Resources.Categories.MessageEmptyCategoryId);

            if (string.IsNullOrEmpty(name))
                throw new ArgumentException(Resources.Categories.MessageEmptyNameItem);

            try
            {
                CategoryItemsTableAdapter localAdapter = new CategoryItemsTableAdapter();
                localAdapter.UpdateCategoryItem(categoryItemId, categoryId, name);
            }
            catch (Exception exc)
            {
                log.Error("Error en UpdateCategoryItem para categoryItemId: " + categoryItemId + ", categoryId: " + categoryId + " y name: " + name, exc);
                throw new ArgumentException(Resources.Categories.MessageErrorUpdateItem);
            }
        }

        public static void DeleteCategoryItem(string categoryItemId, string categoryId)
        {
            if (string.IsNullOrEmpty(categoryItemId))
                throw new ArgumentException(Resources.Categories.MessageEmptyItemId);

            if (string.IsNullOrEmpty(categoryId))
                throw new ArgumentException(Resources.Categories.MessageEmptyCategoryId);

            try
            {
                CategoryItemsTableAdapter localAdapter = new CategoryItemsTableAdapter();
                localAdapter.DeleteCategoryItem(categoryItemId, categoryId);
            }
            catch (Exception exc)
            {
                log.Error("Error en DeleteCategoryItem para categoryItemId: " + categoryItemId + " y categoryId: " + categoryId, exc);
                throw new Exception(Resources.Categories.MessageErrorDeleteItem);
            }
        }

    }
}
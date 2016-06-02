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
                throw new ArgumentException(Resources.Organization.MessageZeroAreaId);

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
                log.Error("Ocurrió un error mientras se obtenía el listado de items de la categoria: " + categoryId, exc);
                throw exc;
            }

            return theList;
        }

        public static CategoryItem GetCategoryItemById(string categoryItemId, string categoryId)
        {
            if (string.IsNullOrEmpty(categoryItemId))
                throw new ArgumentException(Resources.Organization.MessageZeroAreaId);

            if (string.IsNullOrEmpty(categoryId))
                throw new ArgumentException(Resources.Organization.MessageZeroAreaId);

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
                log.Error("Ocurrió un error mientras se obtenía el item de categoryItemId: " + categoryItemId + " y categoryId: " + categoryId, exc);
                throw exc;
            }

            return theData;
        }

        public static void InsertCategoryItem(string categoryItemId, string categoryId, string name)
        {
            if (string.IsNullOrEmpty(categoryItemId))
                throw new ArgumentException(Resources.Organization.MessageZeroAreaId);

            if (string.IsNullOrEmpty(categoryId))
                throw new ArgumentException(Resources.Organization.MessageZeroAreaId);

            if (string.IsNullOrEmpty(name))
                throw new ArgumentException(Resources.Organization.MessageEmptyNameProject);

            try
            {
                CategoryItemsTableAdapter localAdapter = new CategoryItemsTableAdapter();
                localAdapter.InsertCategoryItem(categoryId, categoryItemId, name);
            }
            catch (Exception exc)
            {
                log.Error(Resources.Organization.MessageErrorCreateProject, exc);
                throw exc;
            }
        }

        public static void UpdateCategoryItem(string categoryItemId, string categoryId, string name)
        {
            if (string.IsNullOrEmpty(categoryItemId))
                throw new ArgumentException(Resources.Organization.MessageZeroAreaId);

            if (string.IsNullOrEmpty(categoryId))
                throw new ArgumentException(Resources.Organization.MessageZeroAreaId);

            if (string.IsNullOrEmpty(name))
                throw new ArgumentException(Resources.Organization.MessageEmptyNameProject);

            try
            {
                CategoryItemsTableAdapter localAdapter = new CategoryItemsTableAdapter();
                localAdapter.UpdateCategoryItem(categoryItemId, categoryId, name);
            }
            catch (Exception exc)
            {
                log.Error(Resources.Organization.MessageErrorUpdateProject, exc);
                throw exc;
            }
        }

        public static void DeleteCategory(string categoryItemId, string categoryId)
        {
            if (string.IsNullOrEmpty(categoryItemId))
                throw new ArgumentException(Resources.Organization.MessageZeroAreaId);

            if (string.IsNullOrEmpty(categoryId))
                throw new ArgumentException(Resources.Organization.MessageZeroAreaId);

            try
            {
                CategoryItemsTableAdapter localAdapter = new CategoryItemsTableAdapter();
                localAdapter.DeleteCategoryItem(categoryItemId, categoryId);
            }
            catch (Exception exc)
            {
                log.Error(Resources.Organization.MessageErrorDeleteProject, exc);
                throw new Exception(Resources.Organization.MessageErrorDeleteProject);
            }
        }

    }
}
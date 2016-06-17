using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using CategoryDSTableAdapters;

namespace Artexacta.App.Categories.BLL
{
    /// <summary>
    /// Summary description for CategoryBLL
    /// </summary>
    [System.ComponentModel.DataObject]
    public class CategoryBLL
    {
        private static readonly ILog log = LogManager.GetLogger("Standard");

        CategoriesTableAdapter _theAdapter = null;

        protected CategoriesTableAdapter theAdapter
        {
            get
            {
                if (_theAdapter == null)
                    _theAdapter = new CategoriesTableAdapter();
                return _theAdapter;
            }
        }

        public CategoryBLL()
        {
        }

        private static Category FillRecord(CategoryDS.CategoriesRow row)
        {
            Category theNewRecord = new Category(
                row.categoryID,
                row.name);

            return theNewRecord;
        }

        public List<Category> GetCategories()
        {
            List<Category> theList = new List<Category>();
            Category theData = null;
            try
            {
                CategoryDS.CategoriesDataTable theTable = theAdapter.GetCategories();

                if (theTable != null && theTable.Rows.Count > 0)
                {
                    foreach (CategoryDS.CategoriesRow theRow in theTable)
                    {
                        theData = FillRecord(theRow);
                        theList.Add(theData);
                    }
                }
            }
            catch (Exception exc)
            {
                log.Error("Error en GetCategories", exc);
                throw new ArgumentException(Resources.Categories.MessageErrorGetCategories);
            }

            return theList;
        }

        public static Category GetCategoryById(string categoryId)
        {
            if (string.IsNullOrEmpty(categoryId))
                throw new ArgumentException(Resources.Categories.MessageEmptyCategoryId);

            Category theData = null;
            try
            {
                CategoriesTableAdapter localAdapter = new CategoriesTableAdapter();
                CategoryDS.CategoriesDataTable theTable = localAdapter.GetCategoryById(categoryId);
                if (theTable != null && theTable.Rows.Count > 0)
                {
                    CategoryDS.CategoriesRow theRow = theTable[0];
                    theData = FillRecord(theRow);
                }
            }
            catch (Exception exc)
            {
                log.Error("Error en GetCategoryById para categoryId: " + categoryId, exc);
                throw new ArgumentException(Resources.Categories.MessageErrorGetCategory);
            }

            return theData;
        }

        public static void InsertCategory(string categoryId, string name)
        {
            if (string.IsNullOrEmpty(categoryId))
                throw new ArgumentException(Resources.Categories.MessageEmptyCategoryId);

            if (string.IsNullOrEmpty(name))
                throw new ArgumentException(Resources.Categories.MessageEmptyNameCategory);

            try
            {
                CategoriesTableAdapter localAdapter = new CategoriesTableAdapter();
                localAdapter.InsertCategory(name, categoryId);
            }
            catch (Exception exc)
            {
                log.Error("Error en InsertCategory para los datos categoryId: " + categoryId + " y name: " + name, exc);
                throw new ArgumentException(Resources.Categories.MessageErrorCreateCategory);
            }
        }

        public static void UpdateCategory(string categoryId, string name)
        {
            if (string.IsNullOrEmpty(categoryId))
                throw new ArgumentException(Resources.Categories.MessageEmptyCategoryId);

            if (string.IsNullOrEmpty(name))
                throw new ArgumentException(Resources.Categories.MessageEmptyNameCategory);

            try
            {
                CategoriesTableAdapter localAdapter = new CategoriesTableAdapter();
                localAdapter.UpdateCategory(name, categoryId);
            }
            catch (Exception exc)
            {
                log.Error("Error en UpdateCategory para los datos categoryId: " + categoryId + " y name: " + name, exc);
                throw new ArgumentException(Resources.Categories.MessageErrorUpdateCategory);
            }
        }

        public static void DeleteCategory(string categoryId)
        {
            if (string.IsNullOrEmpty(categoryId))
                throw new ArgumentException(Resources.Categories.MessageEmptyCategoryId);

            try
            {
                CategoriesTableAdapter localAdapter = new CategoriesTableAdapter();
                localAdapter.DeleteCategory(categoryId);
            }
            catch (Exception exc)
            {
                log.Error("Error en DeleteCategory para categoryId: " + categoryId, exc);
                throw new Exception(Resources.Categories.MessageErrorDeleteCategory);
            }
        }

        public static List<Category> GetCategoriesByKpiId(int kpiId)
        {
            List<Category> theList = new List<Category>();
            Category theData = null;
            try
            {
                CategoriesTableAdapter localAdapter = new CategoriesTableAdapter();
                CategoryDS.CategoriesDataTable theTable = localAdapter.GetCategoriesByKpiId(kpiId);

                if (theTable != null && theTable.Rows.Count > 0)
                {
                    foreach (CategoryDS.CategoriesRow theRow in theTable)
                    {
                        theData = FillRecord(theRow);
                        theData.ItemsList = theRow.IsitemsNull() ? "" : theRow.items;
                        theList.Add(theData);
                    }
                }
            }
            catch (Exception exc)
            {
                log.Error("Error en GetCategoriesByKpiId para kpiId: " + kpiId, exc);
                throw new ArgumentException(Resources.Categories.MessageErrorGetCategoriesByKpi);
            }

            return theList;
        }

    }
}
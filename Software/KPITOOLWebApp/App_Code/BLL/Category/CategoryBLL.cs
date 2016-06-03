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
                log.Error("Ocurrió un error mientras se obtenía el listado de categorías.", exc);
                throw exc;
            }

            return theList;
        }

        public List<Category> GetCategoriesByKpi(int kpiId)
        {
            if (kpiId <= 0)
                throw new ArgumentException("The KPI ID cannot be zero.");

            List<Category> theList = new List<Category>();
            Category theData = null;
            try
            {
                CategoryDS.CategoriesDataTable theTable = theAdapter.GetCategoriesByKPI(kpiId);

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
                log.Error("Ocurrió un error mientras se obtenía el listado de categorías by KPI.", exc);
                throw exc;
            }

            return theList;
        }

        public static Category GetCategoryById(string categoryId)
        {
            if (string.IsNullOrEmpty(categoryId))
                throw new ArgumentException(Resources.Organization.MessageZeroAreaId);

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
                log.Error("Ocurrió un error mientras se obtenía la categoría de id: " + categoryId, exc);
                throw exc;
            }

            return theData;
        }

        public static void InsertCategory(string categoryId, string name)
        {
            if (string.IsNullOrEmpty(categoryId))
                throw new ArgumentException(Resources.Organization.MessageZeroAreaId);

            if (string.IsNullOrEmpty(name))
                throw new ArgumentException(Resources.Organization.MessageEmptyNameProject);

            try
            {
                CategoriesTableAdapter localAdapter = new CategoriesTableAdapter();
                localAdapter.InsertCategory(name, categoryId);
            }
            catch (Exception exc)
            {
                log.Error(Resources.Organization.MessageErrorCreateProject, exc);
                throw exc;
            }
        }

        public static void UpdateCategory(string categoryId, string name)
        {
            if (string.IsNullOrEmpty(categoryId))
                throw new ArgumentException(Resources.Organization.MessageZeroAreaId);

            if (string.IsNullOrEmpty(name))
                throw new ArgumentException(Resources.Organization.MessageEmptyNameProject);

            try
            {
                CategoriesTableAdapter localAdapter = new CategoriesTableAdapter();
                localAdapter.UpdateCategory(name, categoryId);
            }
            catch (Exception exc)
            {
                log.Error(Resources.Organization.MessageErrorUpdateProject, exc);
                throw exc;
            }
        }

        public static void DeleteCategory(string categoryId)
        {
            if (string.IsNullOrEmpty(categoryId))
                throw new ArgumentException(Resources.Organization.MessageZeroAreaId);

            try
            {
                CategoriesTableAdapter localAdapter = new CategoriesTableAdapter();
                localAdapter.DeleteCategory(categoryId);
            }
            catch (Exception exc)
            {
                log.Error(Resources.Organization.MessageErrorDeleteProject, exc);
                throw new Exception(Resources.Organization.MessageErrorDeleteProject);
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
                throw new ArgumentException("Ocurrió un error al obtener el listado de categorías del KPI.");
            }

            return theList;
        }

    }
}
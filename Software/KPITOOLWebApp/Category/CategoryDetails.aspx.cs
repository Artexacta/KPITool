using Artexacta.App.Categories;
using Artexacta.App.Categories.BLL;
using Artexacta.App.Utilities.SystemMessages;
using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Category_CategoryDetails : System.Web.UI.Page
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ProcessSessionParameteres();
            if (!string.IsNullOrEmpty(CategoryIdHiddenField.Value))
                LoadData();
            else
                Response.Redirect("~/Category/CategoriesList.aspx");
        }
    }

    private void ProcessSessionParameteres()
    {
        if (Session["CATEGORYID"] != null && !string.IsNullOrEmpty(Session["CATEGORYID"].ToString()))
        {
            CategoryIdHiddenField.Value = Session["CATEGORYID"].ToString();
        }
        Session["CATEGORYID"] = null;
    }

    private void LoadData()
    {
        Category theData = null;
        try
        {
            theData = CategoryBLL.GetCategoryById(CategoryIdHiddenField.Value);
        }
        catch (Exception exc)
        {
            SystemMessages.DisplaySystemErrorMessage(exc.Message);
        }

        if (theData != null)
            TitleLabel.Text = "Lista de Items para la categoría " + theData.Name + " - " + theData.ID;
        else
            Response.Redirect("~/Category/CategoriesList.aspx");
    }

    protected void NewButton_Click(object sender, EventArgs e)
    {
        CategoryItemIdHiddenField.Value = "";
        IDTextBox.Text = "";
        NameTextBox.Text = "";
        pnlEditData.Visible = true;
    }

    protected void CategoryItemGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        string categoryItemId = e.CommandArgument.ToString();
        if (e.CommandName.Equals("DeleteData"))
        {
            try
            {
                CategoryItemBLL.DeleteCategory(categoryItemId, CategoryIdHiddenField.Value);
                SystemMessages.DisplaySystemMessage("Se eliminó correctamente el item.");
                CategoryItemGridView.DataBind();
            }
            catch (Exception exc)
            {
                SystemMessages.DisplaySystemErrorMessage(exc.Message);
            }
        }
        else if (e.CommandName.Equals("EditData"))
        {
            CategoryItem theData = null;
            try
            {
                theData = CategoryItemBLL.GetCategoryItemById(categoryItemId, CategoryIdHiddenField.Value);
            }
            catch (Exception exc)
            {
                SystemMessages.DisplaySystemErrorMessage(exc.Message);
            }

            if (theData != null)
            {
                IDTextBox.Text = theData.ItemID;
                IDTextBox.ReadOnly = true;
                NameTextBox.Text = theData.ItemName;
                pnlEditData.Visible = true;
                CategoryItemIdHiddenField.Value = theData.ItemID;
            }
        }
    }

    protected void SaveButton_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid)
            return;

        if (string.IsNullOrEmpty(CategoryItemIdHiddenField.Value))
        {
            try
            {
                CategoryItemBLL.InsertCategoryItem(IDTextBox.Text.Trim(), CategoryIdHiddenField.Value, NameTextBox.Text.Trim());
                SystemMessages.DisplaySystemMessage("Se registró correctamente el item.");
            }
            catch (Exception exc)
            {
                SystemMessages.DisplaySystemErrorMessage(exc.Message);
                return;
            }
        }
        else
        {
            try
            {
                CategoryItemBLL.UpdateCategoryItem(IDTextBox.Text.Trim(), CategoryIdHiddenField.Value, NameTextBox.Text.Trim());
                SystemMessages.DisplaySystemMessage("Se actualizó correctamente el item.");
            }
            catch (Exception exc)
            {
                SystemMessages.DisplaySystemErrorMessage(exc.Message);
                return;
            }
        }

        CategoryItemIdHiddenField.Value = "";
        pnlEditData.Visible = false;
        CategoryItemGridView.DataBind();
    }

    protected void CancelButton_Click(object sender, EventArgs e)
    {
        CategoryItemIdHiddenField.Value = "";
        pnlEditData.Visible = false;
    }

    protected void ReturnButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/Category/CategoriesList.aspx");
    }

    protected void CategoryItemObjectDataSource_Selected(object sender, ObjectDataSourceStatusEventArgs e)
    {
        if (e.Exception != null)
        {
            SystemMessages.DisplaySystemErrorMessage(e.Exception.Message);
            e.ExceptionHandled = true;
        }
    }

    protected void ExistsIDCustomValidator_ServerValidate(object source, ServerValidateEventArgs args)
    {
        args.IsValid = false;

        if (string.IsNullOrEmpty(CategoryItemIdHiddenField.Value))
        {
            CategoryItem theData = CategoryItemBLL.GetCategoryItemById(IDTextBox.Text, CategoryIdHiddenField.Value);
            if (theData == null)
            {
                args.IsValid = true;
            }
        }
        else
        {
            args.IsValid = true;
        }
    }

}
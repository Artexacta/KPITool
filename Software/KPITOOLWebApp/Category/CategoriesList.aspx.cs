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

public partial class Category_CategoriesList : System.Web.UI.Page
{
    private static readonly ILog log = LogManager.GetLogger("Standard");

    protected override void InitializeCulture()
    {
        Artexacta.App.Utilities.LanguageUtilities.SetLanguageFromContext();
        base.InitializeCulture();
    }

    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void NewButton_Click(object sender, EventArgs e)
    {
        CategoryIdHiddenField.Value = "";
        IDTextBox.Text = "";
        NameTextBox.Text = "";
        pnlEditData.Visible = true;
    }

    protected void CategoryGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        string categoryId = e.CommandArgument.ToString();
        if (e.CommandName.Equals("DeleteData"))
        {
            try
            {
                CategoryBLL.DeleteCategory(categoryId);
                SystemMessages.DisplaySystemMessage(Resources.Categories.MessageDeletedCategory);
                CategoryGridView.DataBind();
            }
            catch (Exception exc)
            {
                SystemMessages.DisplaySystemErrorMessage(exc.Message);
            }
        }
        else if (e.CommandName.Equals("EditData"))
        {
            Category theData = null;
            try
            {
                theData = CategoryBLL.GetCategoryById(categoryId);
            }
            catch (Exception exc)
            {
                SystemMessages.DisplaySystemErrorMessage(exc.Message);
            }

            if (theData != null)
            {
                IDTextBox.Text = theData.ID;
                IDTextBox.ReadOnly = true;
                NameTextBox.Text = theData.Name;
                pnlEditData.Visible = true;
                CategoryIdHiddenField.Value = theData.ID;
            }
        }
        else if (e.CommandName.Equals("ViewItems"))
        {
            Session["CATEGORYID"] = categoryId;
            Response.Redirect("~/Category/CategoryDetails.aspx");
        }
    }

    protected void SaveButton_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid)
            return;

        if (string.IsNullOrEmpty(CategoryIdHiddenField.Value))
        {
            try
            {
                CategoryBLL.InsertCategory(IDTextBox.Text.Trim(), NameTextBox.Text.Trim());
                SystemMessages.DisplaySystemMessage(Resources.Categories.MessageCreatedCategory);
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
                CategoryBLL.UpdateCategory(IDTextBox.Text.Trim(), NameTextBox.Text.Trim());
                SystemMessages.DisplaySystemMessage(Resources.Categories.MessageUpdatedCategory);
            }
            catch (Exception exc)
            {
                SystemMessages.DisplaySystemErrorMessage(exc.Message);
                return;
            }
        }

        CategoryIdHiddenField.Value = "";
        pnlEditData.Visible = false;
        CategoryGridView.DataBind();
    }

    protected void CancelButton_Click(object sender, EventArgs e)
    {
        CategoryIdHiddenField.Value = "";
        pnlEditData.Visible = false;
    }

    protected void CategoryObjectDataSource_Selected(object sender, ObjectDataSourceStatusEventArgs e)
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

        if (string.IsNullOrEmpty(CategoryIdHiddenField.Value))
        {
            Category theData = CategoryBLL.GetCategoryById(IDTextBox.Text);
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
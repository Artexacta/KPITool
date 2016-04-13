using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class UserControls_SearchUserControl_SC_UsersSearchItem : AbstractSearchItem
{
    protected void Page_Load(object sender, EventArgs e)
    {
        rbtnOperation.Visible = ShowAndOrButtons;
        lblSpace.Visible = !ShowAndOrButtons;
        lblTitle.Text = this._title;
    }

    public override string GetValue()
    {
        if (string.IsNullOrEmpty(UsersRadComboBox.SelectedValue))
            return "";
        return "@" + this.SearchColumnKey + " " + UsersRadComboBox.SelectedValue;
    }

    public override string GetOperation()
    {
        return rbtnOperation.SelectedValue;
    }

}
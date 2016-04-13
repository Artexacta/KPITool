using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class UserControls_SearchUserControl_SC_BooleanSearchItem : AbstractSearchItem
{
    protected void Page_Load(object sender, EventArgs e)
    {
        rbtnOperation.Visible = ShowAndOrButtons;
        lblSpace.Visible = !ShowAndOrButtons;
        lblTitle.Text = this._title;
    }

    public override string GetValue()
    {
        if (rbtValues.SelectedValue.Equals("none"))
            return "";
        return "@" + this.SearchColumnKey + " " + rbtValues.SelectedValue;
    }

    public override string GetOperation()
    {
        return rbtnOperation.SelectedValue;
    }

}
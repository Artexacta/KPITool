using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class UserControls_SearchUserControl_SC_DateSearchItem : AbstractSearchItem
{
    protected void Page_Load(object sender, EventArgs e)
    {
        rbtnOperation.Visible = ShowAndOrButtons;
        lblSpace.Visible = !ShowAndOrButtons;
        lblTitle.Text = this._title;
    }

    public override string GetValue()
    {
        if (CSearch_Item_AspnetControl.SelectedDate != null)
        {
            DateTime dateformat = Convert.ToDateTime(CSearch_Item_AspnetControl.SelectedDate);

            if (CSearch_Item_AspnetControl.SelectedDate.Equals(DateTime.MinValue))
                return "";
            return "@" + this.SearchColumnKey + " " +
                ddlOperator.SelectedValue +
                dateformat.ToString("yyyy-MM-dd");
        }
        else
            return null;
    }

    public override string GetOperation()
    {
        return rbtnOperation.SelectedValue;
    }

}
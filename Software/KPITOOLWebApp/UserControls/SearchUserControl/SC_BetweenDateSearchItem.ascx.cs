using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class UserControls_SearchUserControl_SC_BetweenDateSearchItem : AbstractSearchItem
{
    protected void Page_Load(object sender, EventArgs e)
    {
        rbtnOperation.Visible = ShowAndOrButtons;
        lblSpace.Visible = !ShowAndOrButtons;
        lblTitle.Text = this._title;
    }

    public override string GetValue()
    {
        if (CSearch_ItemDesde_AspnetControl.SelectedDate != null && CSearch_ItemHasta_AspnetControl.SelectedDate != null)
        {
            DateTime dateformatDesde = Convert.ToDateTime(CSearch_ItemDesde_AspnetControl.SelectedDate).AddDays(-1);
            DateTime dateformatHasta = Convert.ToDateTime(CSearch_ItemHasta_AspnetControl.SelectedDate).AddDays(1);

            if (CSearch_ItemDesde_AspnetControl.SelectedDate.Equals(DateTime.MinValue) || CSearch_ItemHasta_AspnetControl.SelectedDate.Equals(DateTime.MinValue))
                return "";
            return "@" + this.SearchColumnKey + " " +
                " < " +
                dateformatHasta.ToString("yyyy-MM-dd") + " AND @" + this.SearchColumnKey + " > " + dateformatDesde.ToString("yyyy-MM-dd");
        }
        else
            return null;
    }

    public override string GetOperation()
    {
        return rbtnOperation.SelectedValue;
    }

}
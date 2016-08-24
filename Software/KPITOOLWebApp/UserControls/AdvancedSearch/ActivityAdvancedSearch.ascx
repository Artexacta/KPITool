<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ActivityAdvancedSearch.ascx.cs" Inherits="UserControls_AdvancedSearch_ActivityAdvancedSearch" %>
<%@ Register Src="~/UserControls/SearchUserControl/SC_DataSearchItem.ascx" TagPrefix="app" TagName="SC_DataSearchItem" %>



<%@ Register Src="../SearchUserControl/SC_TextSearchItem.ascx" TagName="SC_TextSearchItem" TagPrefix="uc1" %>



<%@ Register src="../SearchUserControl/SC_ActivitySearchItem.ascx" tagname="SC_ActivitySearchItem" tagprefix="uc2" %>



<div style="width: 400px">
    <div>
        
        <uc2:SC_ActivitySearchItem ID="SC_ActivitySearchItem1" runat="server" />
        
    </div>
    <div style="clear:both">

        <uc1:SC_TextSearchItem ID="SC_TextSearchItem1"
            runat="server"
            Title="<% $Resources: Activity, LabelName %>"
            SearchColumnKey="name"
            ShowAndOrButtons="true" />

    </div>
</div>

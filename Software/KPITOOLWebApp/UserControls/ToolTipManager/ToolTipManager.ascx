<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ToolTipManager.ascx.cs" Inherits="UserControls_ToolTipManager_ToolTipManager" %>
<%--
    Requied:
    - jquery.tipTip.minified.js
    - tipTip.css
--%>
<script type="text/javascript">
    $(function () {
        initializeTooltipManager("<%= GetCurrentPage() %>", "<%= NoApplyToSelector %>", "<%= UserIdHiddenLabel.Text %>", "<%= GetShouldDisplayToolTipWS() %>");
    });
</script>
<asp:Label runat="server" ID="ShouldDisplayToolTipWSHiddenLabel" Visible="false"></asp:Label>
<asp:Label runat="server" ID="ExcludeSelectorLabel" Visible="false"></asp:Label>
<asp:Label runat="server" ID="UserIdHiddenLabel" Visible="false" Text="0"></asp:Label>
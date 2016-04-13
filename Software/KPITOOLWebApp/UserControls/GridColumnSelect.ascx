<%@ Control Language="C#" AutoEventWireup="true" CodeFile="GridColumnSelect.ascx.cs"
    Inherits="UserControls_GridColumnSelect" %>
<!-- Do not remove div#mask, because you'll need it to fill the whole screen -->
<div id="GCS_Columns_Mask" class="ColumnsSelector_Mask">
</div>
<asp:ImageButton ID="VisCSImageButton" runat="server" 
    ImageUrl="~/Images/neutral/next-item.png"
    Width="20px" />
<asp:Panel ID="GCSColPanel" runat="server" CssClass="ColumnsSelector_Panel">
    <div class="columnHead">
        <asp:Label ID="Label1" runat="server" Text="Select Columns" CssClass="title" />
    </div>
    <div class="columnContent">
        <asp:CheckBoxList ID="ColumnCheckBoxList" runat="server">
        </asp:CheckBoxList>
        <div class="buttonsPanel">
            <asp:LinkButton ID="SaveCSButton" runat="server" CssClass="button" OnClick="SaveVisibleButton_Click">
                <asp:Label runat="server" ID="SaveVisibleButtonLabel" Text="<%$ Resources: Glossary, GenericSaveLabel %>" />
            </asp:LinkButton>
            <a href="#" id="CancelSelectionButton" runat="server" cssclass="secondaryButton"><span>
                Cancelar</span> </a>
        </div>
        <div class="clear"></div>
    </div>
</asp:Panel>
<asp:HiddenField ID="AssociatedGridHF" runat="server" Value="" />
<asp:HiddenField ID="IgnoreColumnsHF" runat="server" Value="" />
<asp:HiddenField ID="GridTypeHF" runat="server" Value="" />
<asp:HiddenField ID="UserIDHF" runat="server" Value="" />

<script type="text/javascript">
    $(document).ready(function () {
        $("#<%=GCSColPanel.ClientID %>").hide();

        // Handler to show the columns selector
        $("#<%=VisCSImageButton.ClientID %>").click(function (e) {
            e.preventDefault();

            var maskWinH = $(document).height();
            var maskWinW = $(window).width();
            $("#GCS_Columns_Mask").css({ 'width': maskWinW, 'height': maskWinH });
            $("#GCS_Columns_Mask").css('top', 0);
            $("#GCS_Columns_Mask").css('left', 0);
            $("#GCS_Columns_Mask").fadeIn(500);

            var winH = $(window).height();
            var winW = $(window).width();
            $("#<%=GCSColPanel.ClientID %>").css('top', winH / 2 - $("#<%=GCSColPanel.ClientID %>").height() / 2);
            $("#<%=GCSColPanel.ClientID %>").css('left', winW / 2 - $("#<%=GCSColPanel.ClientID %>").width() / 2);
            $("#<%=GCSColPanel.ClientID %>").fadeIn(0);
        });

        $("#<%=SaveCSButton.ClientID %>").click(function (e) {
            $("#<%=SaveCSButton.ClientID %>, #GCS_Columns_Mask").fadeOut(500);
        });

        $("#<%=CancelSelectionButton.ClientID %>").click(function (e) {
            e.preventDefault();
            $("#<%=GCSColPanel.ClientID %>, #GCS_Columns_Mask").fadeOut(500);
        });
    });
</script>
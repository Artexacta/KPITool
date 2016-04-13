<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Messages.ascx.cs" Inherits="UserControls_Messages" %>
<%-- This is the panel that contains the text that should be shown when the Messages are Shown --%>
<asp:HiddenField ID="MessageHiddenField" runat="server" />
<asp:HiddenField ID="ShowMessageHiddenField" runat="server" Value="false" />
<asp:Literal ID="ltScript" runat="server" />
<script type="text/javascript">
    var opened = true;
    function loadMessages(onLoad) {
        var messageStr = $('#<%=MessageHiddenField.ClientID %>').val();
        if (messageStr == '' && onLoad == false) {
            toastr.clear();
            return;
        } else {
            if (messageStr == '') {
                return;
            } else {
                var messagesList = JSON.parse(messageStr);//messageStr.split("!");
                for (var i = 0; i < messagesList.length; i++) {
                    var msg = messagesList[i];
                    toastr.options.positionClass = "toast-bottom-right";
                    toastr.options.progressBar = true;
                    toastr.options.closeButton = true;
                    if (msg.MessageType == 1) {
                        toastr.warning(decodeURIComponent(msg.ShortMessage));
                    } else if (msg.MessageType == 2) {
                        toastr.error(decodeURIComponent(msg.ShortMessage));
                    } else {
                        toastr.success(decodeURIComponent(msg.ShortMessage));
                    }
                    //$('#systemMessagesContent').jGrowl(decodeURIComponent(messagesList[i]), { sticky: true });
                }
            }
        }
    }
    $(document).ready(function () {
        loadMessages(true);
        $('#systemMessagesLink').click(function () {
            if (opened) {
                toastr.clear();
                opened = false;
            } else {
                opened = true;
                loadMessages(false);
            }
            return false;
        });
        if ($(".count-info .label-primary").html() == "") {
            $(".count-info .label-primary").css("display", "none");
        } else {
            $(".count-info .label-primary").css("display", "block");
        }
    });
</script>
<div id="systemMessagesContent" class="jGrowl bottom-right">
</div>
<div class="notificationButton">
    <asp:HyperLink NavigateUrl="#" runat="server" ID="systemMessagesLink" ClientIDMode="Static"
        ToolTip='<%$ Resources: Messages, ViewMessages %>' CssClass="count-info">
        <span class="label label-primary"><asp:Literal ID="MessagesNumberLiteral" runat="server" /></span>
        <i class="zmdi zmdi-notifications"></i>
    </asp:HyperLink>
</div>

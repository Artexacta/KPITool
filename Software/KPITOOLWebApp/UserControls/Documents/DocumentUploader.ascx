<%@ Control Language="C#" AutoEventWireup="true" CodeFile="DocumentUploader.ascx.cs" Inherits="UserControls_Documents_ImageUploader" %>

<div style="float:left">
    <telerik:RadProgressManager ID="ImageRadProgressManager" Runat="server" Skin="Default" />
    <telerik:RadUpload ID="ImageRadUpload" runat="server" 
        OnValidatingFile="ImageRadUpload_ValidatingFile" Localization-Select="<%$Resources: DocumentUploader, SelectButton %>"  
        Localization-Add="add" ControlObjectsVisibility="AddButton" 
        Skin="Default" OnClientFileUploaded="<%# GetClientFileUploadedFunction() %>">
    </telerik:RadUpload>
    <telerik:RadProgressArea ID="ImageProgressArea" Runat="server" Skin="Default" DisplayCancelButton="True" 
        ProgressIndicators="TotalProgressBar, TotalProgress, RequestSize, FilesCountBar, FilesCount, SelectedFilesCount, CurrentFileName, TimeElapsed, TimeEstimated, TransferSpeed">
        <Localization Uploaded="Uploaded"></Localization>
    </telerik:RadProgressArea>
</div>
<div style="clear:both"></div>
<span id="uploadButtonContainer" runat="server">
    <asp:Button ID="UploadButton" runat="server"
        OnClick="UploadButton_Click" CssClass="ruButton ruUpload"
        Text="<%$Resources: DocumentUploader, UploadButtonText %>" />
</span>
<div class="validators">
    <asp:Label ID="ImageErrorLabel" runat="server" />
</div>
<asp:HiddenField ID="OnClientUploadedHiddenField" runat="server" />
<asp:HiddenField ID="ErrorHiddenField" runat="server" />
<asp:HiddenField ID="ObjectTypeHiddenField" runat="server" Value="NONE" />
<asp:HiddenField ID="ObjectIdHiddenField" runat="server" Value="0" />
<script type="text/javascript">

    //<![CDATA[
    function <%= GetClientFileUploadedFunction() %>(sender, args) {
        var fn = $("#<%= OnClientUploadedHiddenField.ClientID %>").val();
            if (fn && fn != "")
                eval(fn);
    }

    $(document).ready(function () {
        $("#<%= ImageRadUpload.ClientID %> > ul > .ruActions").html($("#<%= uploadButtonContainer.ClientID %>").html());
        $("#<%= uploadButtonContainer.ClientID %>").html("");
        $("#<%= uploadButtonContainer.ClientID %>").hide();

        $("#<%= UploadButton.ClientID %>").on("click", function () {
            var upload = $find("<%= ImageRadUpload.ClientID %>");
            var fileInputs = upload.getFileInputs();
            var count = 0;
            for (var i = 0; i < fileInputs.length; i++) {
                if (fileInputs[i].value != "")
                    count++;
            }
            return count > 0;
        });

    });
</script>
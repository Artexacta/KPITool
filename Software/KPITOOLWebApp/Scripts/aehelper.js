function openPopup(maskId, selectorPanel, hiddenfieldId) {
    var maskWinH = $(document).height();
    var maskWinW = $(window).width();
    var mask = maskId;
    $(mask).css({ 'width': maskWinW, 'height': maskWinH });
    $(mask).css('top', 0);
    $(mask).css('left', 0);
    $(mask).fadeIn(300);
    var winH = $(window).height();
    var winW = $(window).width();
    var container = selectorPanel;
    $(container).css('top', window.pageYOffset + (winH / 2 - $(container).height() / 2));
    $(container).css('left', winW / 2 - $(container).width() / 2);
    $(container).fadeIn(0);
    $(hiddenfieldId).val("true");
}
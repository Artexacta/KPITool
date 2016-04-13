// -----MAIN MENU-----
// Script to control main menu's behavior
// Uses:  CommonStyles.css
// Attach to:  MasterPage.Master
// Created by:  Hugo Giusti


$(document).ready(function () {
    var timeOutID = 0;

    // Al hacer click en algun item del menu
    $('#mainMenu > li > a').each(function () {
        $(this).click(function () {
            // primero ver si hay algun subsubmenu desplegado y ocultarlo
            $('.subSubMenu').each(function () {
                if ($(this).css('display') != 'none') {
                    $(this).slideToggle('fast');
                }
            });
            // despues buscar si algun submenu esta desplegado y ocultarlo
            $('.subMenu').each(function () {
                if ($(this).css('display') != 'none') {
                    $(this).slideToggle('fast');
                }
            });
            // desplegar el subMenu correcto
            if ($(this).next('.subMenu').length > 0) {
                $(this).next('.subMenu').slideToggle('fast');
                return false;
            }
            return true;
        });
    });

    // Al hacer click en algun item del subMenu
    $('.subMenu > li > a').each(function () {
        $(this).click(function () {
            // primero ver si algun subSubMenu esta desplegado y ocultarlo
            $(this).closest('.subMenu').find('.subSubMenu').each(function () {
                if ($(this).css('display') != 'none') {
                    $(this).slideToggle('fast');
                }
            });
            //desplegar el subSubMenu correcto
            if ($(this).next('.subSubMenu').length > 0) {
                $(this).next('.subSubMenu').slideToggle('fast');
                return false;
            }
            return true;
        });
    });

    // Cuando el mouse deja el menu, cerrar menus
    $('#mainMenu').mouseleave(function () {
        //esperar 1 segundo antes de cerrar el menu
        timeOutID = setTimeout(function () {
            //ver si hay que cerrar algun subsubmenu
            $('.subSubMenu').each(function () {
                if ($(this).css('display') != 'none') {
                    $(this).slideToggle('fast');
                }
            });
            //cerrar submenu
            $('.subMenu').each(function () {
                if ($(this).css('display') != 'none') {
                    $(this).slideToggle('fast');
                }
            });
            timeOutID = 0;
        }, 1000);
    });

    //cuando el mouse esta encima del menu hay que cancelar el timer para cerrar el menu
    $('#mainMenu').mouseover(function () {
        if (timeOutID != 0) {
            clearTimeout(timeOutID);
        }
    });
});
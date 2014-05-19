;( function( $ ) {

var el = null,
    template = {
        box: '<div class="lightbox"><div class="lightbox-content"></div></div>',
        button: '<button class="btn-blue lightbox-button unselectable" unselectable="on">#{text}</button>',
        link: '<a class="ightbox-link" href="#">#{text}</a>',
        cancel: '<a class="cancel lightbox-link" href="#">#{text}</a>'
    };

$.widget( "ccw.lightbox", {

    options: {
        width: "500",
        height: "auto",
        autoShow: true,
        buttons: [],
        closeBtn: true,
        shortcuts: true
    },

    _create: function() {
        var opts = this.options;
        this.box = $( template.box )
            .width( opts.width )
            .height( opts.height )
            .appendTo( "body" )
            .hide();
        this.box.find( ".lightbox-content" )
            .append( this.element.show());

        if ( opts.title ) {
            $( "<h5/>", {
                text: opts.title,
                "class": "lightbox-title"
            }).prependTo( this.box.find( ".lightbox-content" ) );
        }

        if ( opts.buttons && opts.buttons.length ) {
            var buttonBar = $( '<div class="lightbox-buttons clearfix"></div>' );
            $.each( opts.buttons, function( i, b ) {
                b.type = b.type || "button";
                $( template[b.type].replace( /#\{text\}/g, b.text ))
                    .addClass( b.align )
                    .appendTo( buttonBar )
                    .click( function( e ) {
                        e.preventDefault();
                        if ( $.isFunction( b.handler )) {
                            b.handler.call( this, e );
                        }
                    });
            });

            this.box.append( buttonBar );
        }

        if ( opts.closeBtn ) {
            $( '<a class="lightbox-close" href="#">关闭</a>' )
                .click( $.proxy(
                    function( e ) {
                        e.preventDefault();
                        this.hide();
                    }, this )
                )
                .appendTo( this.box );
        }
    },

    _init: function() {
        if ( this.options.autoShow ) {
            this.show();
        }
    },

    isOpen: function() {
        return this._isOpen;
    },

    show: function() {
        this._isOpen = true;

        if ( this._trigger( "beforeShow" ) === false ) {
            return;
        }

        $( ":ccw-lightbox" ).not( this.element ).each( function() {
            var $this = $( this );
            if ( $this.lightbox( "isOpen" ) ) {
                $this.lightbox( "hide" );
            }
        });

        if ( this.options.shortcuts ) {
            $.Shortcuts.add({
                type: "down",
                mask: "ESC",
                enableInInput: true,
                list: "lightbox",
                handler: $.proxy(
                    function() {
                        this.hide();
                    }, this
                )
            });

            $.Shortcuts.start( "lightbox" );
        }

        this.reposition();

        this._trigger( "onShow" );

        return this;
    },

    hide: function() {
        this._isOpen = false;

        this.box.hide();

        if ( this.options.shortcuts ) {
            $.Shortcuts.remove({
                type: "down",
                mask: "ESC",
                list: "lightbox"
            }).start();
        }

        this._trigger( "onHide" );

        return this;
    },

    reposition: function() {
        var opts = this.options,
            boxW = this.box.innerWidth(),
            boxH = this.box.innerHeight();

        this.box.show()
            .css({
                marginTop: -boxH/2,
                marginLeft: -boxW/2
            });
    },

    destroy: function() {
        $.Widget.prototype.destroy.call( this );
        /*TODO
         * 在$.lightbox使用js拼装lb内容时会有问题，暂时先放一下
        this.box.find( ".lightbox-content" ).children().appendTo( "body" );
        this.box.remove();
        */
    }

});

$.lightbox = function( opts ) {
    if ( typeof opts == "object" ) {
        if ( el ) {
            el.parents( ".lightbox" ).remove();
        }

        el = $( opts.content );
        if ( !el.length ) {
            el = $( "<p/>" ).html( opts.content );
        }
        el.lightbox( opts );
    } else if ( typeof opts == "string" && opts == "show" ) {
        el && el.lightbox( "show" );
    } else if ( typeof opts == "string" && opts == "hide" ) {
        el && el.lightbox( "hide" );
    } else if ( typeof opts == "string" && opts == "reposition" ) {
        el && el.lightbox( "reposition" );
    }

}

$.message = function( opts ) {
    $.lightbox({
        width: opts.width || 300,
        content: opts.content,
        buttons: [{
            text: "我知道了",
            handler: function() {
                $.lightbox( "hide" );
            }
        }]
    });

    $( ".lightbox .lightbox-button" ).focus();
};


$.confirm = function( opts ) {
    $.lightbox({
        title: opts.title,
        width: opts.width || 300,
        content: opts.content,
        buttons: [{
            text: opts.btnText || "确定",
            handler: function() {
                $.lightbox( "hide" );
                if ( opts.callback ) {
                    opts.callback.call( this, true );
                }
            }
        },{
            text: "取消",
            type: "link",
            handler: function() {
                $.lightbox( "hide" );
                if ( opts.callback ) {
                    opts.callback.call( this, false );
                }
            }
        }]
    });

    $( ".lightbox .lightbox-button" ).focus();
}

}( jQuery ));

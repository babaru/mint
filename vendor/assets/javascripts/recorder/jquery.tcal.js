( function( $ ) {

    var template = {
        "time": '<span class="tcal-time-slot">#{time}<em>#{period}</em></span>',
        "headerSlot": '<div class="tcal-header-slot tal-header-slot-#{index} unselectable" unselectable="on"><span class="date" unselectable="on">#{date}</span><span class="weekday" unselectable="on">#{weekday}</span></div>',
        "event": '<div class="tcal-event unselectable" title="#{text}" unselectable="on"><div class="tcal-event-title" unselectable="on"><span class="start" unselectable="on">#{start}</span> - <span class="end" unselectable="on">#{end}</span></div><p unselectable="on">#{text}</p><div class="tcal-event-resize-handle"></div></div>',
        "addEvent": '<div class="tcal-add-event clearfix"><textarea class="txt-event-content"></textarea><div class="choose-team clearfix"><label>团队：</label><div class="btn-group teams"></div></div><div class="choose-labels clearfix"><label>分类：</label><select class="select-label"></select><p class="info">已被归档</p></div><div class="buttons clearfix"><a class="btn-blue btn-add-event" href="#">Cola!</a><a class="link-cancel" href="#">取消</a><a class="link-delete" href="#">删除</a></div><div class="archive-buttons clearfix"><a class="btn-blue btn-close" href="#">关闭</a></div></div>',
        "monthCell": '<div class="tcal-month-cell"><span>#{date}</span></div>',
        "monthPop": '<div class="tcal-month-popover"><div class="title"><span class="date">#{date}</span><span class="weekday">#{weekday}</span><span class="total-hour">#{hour}</span></div><ul class="cell-worklogs"></ul></div>',
        "worklog": '<li class="cell-worklog"><span class="hour">#{hour}</span><span class="worklog-content" title="#{content}">#{content}</span></li>'
    };

    $.widget("ui.tcal", {
        options: {
            width: false,
            height: false,
            view: "day",
            data: {},
            scrollbarWidth: 18,
            startDate: false,
            editable: true
        },
        _create: function() {
            var opts = this.options;

            if ( $.inArray( opts.view, ["day", "week", "month"]) < 0 ) {
                return;
            }

            this.element.addClass( "tcal tcal-" + opts.view )
            .attr( "unselectable", "on" );

            if ( !opts.editable ) {
                this.element.addClass( "tcal-no-editable" );
            }

            opts.width = opts.width || this.element.width();
            opts.height = opts.height || this.element.parent().height();
            this.element.width( opts.width );

            this._header = $( '<div class="tcal-header clearfix"></div>' )
            .appendTo( this.element );
            this._body = $( '<div class="tcal-body" unselectable="on"></div>' )
            .appendTo( this.element );
            this._bodyScroller = $( '<div class="tcal-body-scroller clearfix" unselectable="on"></div>' )
            .appendTo( this._body );
            this._bodyInner = $( '<div class="tcal-body-inner clearfix" unselectable="on"></div>')
            .width( this._body.width())
            .appendTo( this._bodyScroller );
            this._footer = $( '<div class="tcal-footer"></div>' )
            .appendTo( this.element );

            if ( opts.view == "month" ) {
                var weekdays = ["一", "二", "三", "四", "五", "六", "日"],
                slotWidth = Math.floor(( opts.width - 1 ) / 7 );

                for ( var i = 0; i < 7; i ++ ) {
                    $( template.headerSlot
                    .replace( /\#\{index\}/g, i )
                    .replace( /\#\{date\}/g, "" )
                    .replace( /\#\{weekday\}/g, "星期" + weekdays[i] ))
                    .width( slotWidth )
                    .appendTo( this._header );
                }

                this._slotWidth = slotWidth;

                $( document ).click( $.proxy( function( e ) {
                    this._body.find( ".tcal-month-cell.active" )
                    .removeClass( "active" )
                    .popbox( "destroy" );
                }, this ));
            } else {
                this.element.height( opts.height );
                this._bodyH = opts.height - this._header.outerHeight() - this._footer.outerHeight();
                this._body.height( this._bodyH );

                this._timeCol = $( '<div class="tcal-time"></div>' )
                .appendTo( this._bodyInner );

                var days = opts.view == "day" ? 1 : 7,
                weekdays = ["一", "二", "三", "四", "五", "六", "日"],
                totalWidth = opts.width - this._timeCol.outerWidth() - opts.scrollbarWidth,
                slotWidth = Math.round( totalWidth / days );

                this._cols = [];
                for ( var i = 0; i < days; i ++ ) {
                    var col = $( '<div class="tcal-col tcal-col-' + i + '"></div>' )
                    .appendTo( this._bodyInner );

                    if ( i == days - 1 ) {
                        col.addClass( "last" );
                    }

                    this._cols.push( col[0] );

                    if ( opts.view == "week" ) {
                        $( template.headerSlot
                        .replace( /\#\{index\}/g, i )
                        .replace( /\#\{date\}/g, "" )
                        .replace( /\#\{weekday\}/g, "（" + weekdays[i] + "）" ))
                        .width( slotWidth )
                        .appendTo( this._header );

                    }
                }

                for ( var i = 0; i < 48; i ++ ) {
                    var hour = i / 2,
                    minite = ( i % 2 ) * 30;

                    var timeString = hour > 12 ? hour - 12 : hour,
                    periodString = hour >= 12 ? "pm" : "am",
                    timeSlot = $( template.time
                    .replace( /\#\{time\}/g, timeString )
                    .replace( /\#\{period\}/g, periodString ))
                    .appendTo( this._timeCol );

                    if ( i % 2 == 1 ) {
                        timeSlot.addClass( "odd" );
                    }

                    if ( i == 47 ) {
                        timeSlot.addClass( "last" );
                    }

                    $.each( this._cols, $.proxy( function( index, col) {
                        var slot = $( '<div class="slot"></div>' )
                        .width( slotWidth - 1 )
                        .bind( false ? "press" : "mousedown", $.proxy( this._selectStart, this ))
                        .appendTo( col );

                        if ( false ) {
                            slot.bind( "tap", $.proxy( this._selectStart, this ));
                        }

                        if ( i % 2 == 1 ) {
                            slot.addClass( "odd" );
                        }

                        if ( i == 47 ) {
                            slot.addClass( "last" );
                        }
                    }, this ));
                }

                this._events = $( '<div class="tcal-events" unselectable="on"></div>' )
                .appendTo( this._bodyInner );

                this._slotHeight = this._timeCol.find( ".tcal-time-slot:first" ).outerHeight();
                this._slotWidth = slotWidth;
                this._occupiedTime = {};
                this._scroll();

                this._bodyInner.css({
                    height: this._slotHeight * 48,
                    overflow: "hidden",
                    position: "relative"
                });

                $( window ).bind( "resize.tcal orientationchange.tcal", {}, $.proxy( this._resize, this ))
                .trigger( "resize" );

                if ( false ) {
                    this._iscroll = new iScroll( this._body[0], {
                        useTransition: true,
                        bounce: false,
                        hScroll: false,
                        onScroll: $.proxy( function( pos ) {
                            if ( pos.y < 0 ) {
                                this._header.addClass( "shadow" );
                            } else {
                                this._header.removeClass( "shadow" );
                            }

                            if ( pos.y <= this._iscroll.maxScrollY ) {
                                this._footer.removeClass( "shadow" );
                            } else {
                                this._footer.addClass( "shadow" );
                            }
                        }, this )
                    });
                } else {
                    this._body.scroll( $.proxy( this._scroll, this ));
                }

            }
        },
        _resize: function() {
            var h = $( window ).height() - this.element.offset().top - 37;
            this.element.height( h );
            this._bodyH = h - this._header.outerHeight() - this._footer.outerHeight();
            this._body.height( this._bodyH );
        },
        _scroll: function() {
            var opts = this.options;

            if ( this._body.scrollTop() > 0 ) {
                this._header.addClass( "shadow" );
            } else {
                this._header.removeClass( "shadow" );
            }

            if ( this._body.scrollTop() >= this._body[0].scrollHeight - this._bodyH ) {
                this._footer.removeClass( "shadow" );
            } else {
                this._footer.addClass( "shadow" );
            }
        },
        _selectStart: function( e, param ) {
            e.preventDefault();
            var opts = this.options,
            slot = $( e.currentTarget ),
            col = slot.parent( ".tcal-col" ),
            start = col.find( ".slot" ).index( slot );

            if ( !opts.editable ) {
                return;
            }

            if ( !this._checkEventTime( col.attr( "date" ), start, start + 1 )) {
                return;
            }

            if ( this._editingEvent ) {
                this._dismissAddEvent( true );
            }

            var recentLabel = $.evalJSON( $.cookie( "recentLabel" ) || null );
            this._editingEvent = this._createEventEl({
                content: "",
                start: start,
                end: start + 1,
                col: this._cols.indexOf( col[0] ),
                placeholder: true,
                color: recentLabel ? recentLabel.color : null
            });

            this._editingEvent.data({
                originStart: start,
                originEnd: start + 1
            });

            if ( false && e.type == "tap" ) {
                this._selectStop( $.Event( "tap" ));
            } else if ( false ) {
                this._bodyInner.one( "touchend.tcal", {
                    edit: false
                }, $.proxy( this._selectStop, this ));
                this._bodyInner.bind( "touchmove.tcal", {
                    originY: param.originalEvent.touches[0].pageY
                }, $.proxy( this._selectMove, this ));
            } else {
                $( document ).one( "mouseup.tcal", {
                    edit: false
                }, $.proxy( this._selectStop, this ));
                $( document ).bind( "mousemove.tcal", {
                    originY: e.pageY
                }, $.proxy( this._selectMove, this ));
            }

            this.element.addClass( "tcal-dragging" );
        },
        _selectMove: function( e ) {
            e.stopPropagation();
            var opts = this.options;

            if ( !this._editingEvent ) {
                return;
            }

            var pageY = false ? e.originalEvent.touches[0].pageY : e.pageY,
            offsetY = pageY - e.data.originY,
            offsetSlot = Math.round( Math.abs( offsetY ) / this._slotHeight ),
            originStart = this._editingEvent.data( "originStart" ),
            originEnd = this._editingEvent.data( "originEnd" ),
            colDate = $( this._cols[this._editingEvent.data( "col" )] ).attr( "date" ) * 1;

            if ( offsetY < 0 ) {
                if ( originStart < offsetSlot ) {
                    return;
                }

                if ( !this._checkEventTime( colDate, originStart - offsetSlot, originEnd )) {
                    return;
                }

                this._editingEvent.css({
                    top: ( originStart - offsetSlot ) * this._slotHeight,
                    height: ( originEnd - originStart + offsetSlot ) * this._slotHeight - 2
                }).data({
                    start: originStart - offsetSlot
                });
            } else {
                if ( originEnd - originStart + offsetSlot > 48 - originStart ) {
                    return;
                }

                if ( !this._checkEventTime( colDate, originStart, originEnd + offsetSlot )) {
                    return;
                }

                this._editingEvent.css({
                    height: ( originEnd - originStart + offsetSlot ) * this._slotHeight - 2
                }).data({
                    end: originEnd + offsetSlot
                });
            }

            this._refreshEventTime();
        },
        _selectStop: function( e ) {
            var opts = this.options;

            if ( false ) {
                this._bodyInner.unbind( "touchmove.tcal" );
            } else {
                $( document ).unbind( "mousemove.tcal" );
            }

            if ( !this._editingEvent ) {
                return;
            }

            this._editingEvent.removeData( "originStart" )
            .removeData( "originEnd" );

            this._initAddEvent();

            if ( opts.view == "day" ) {
                var pos = this._editingEvent.position()
                scrollT = this._body.scrollTop(),
                scrollH = this._body[0].scrollHeight,
                eventH = this._editingEvent.height(),
                eventW = this._editingEvent.width(),
                animate = $.support.cssTransition ? "animateWithCss" : "animate";

                this._addEventHandle.css({
                    opacity: 0,
                    height: eventH,
                    top: pos.top,
                    left: pos.left,
                    clip: "rect(-18px,10px," + ( eventH + 18 ) + "px, -18px)"
                }).show();

                this._addEventWrapper.css({
                    opacity: 0,
                    width: eventW - 10,
                    height: eventH,
                    top: pos.top,
                    left: pos.left + 10
                }).show();

                this._addEvent.css({
                    opacity: 0
                }).show();

                var addEventH = this._addEvent.outerHeight(),
                maxH = Math.max( addEventH, eventH );

                this._autoScroll( this._editingEvent, maxH );

                this._addEventHandle[animate]({
                    opacity: 1
                }, 200 );
                this._addEventWrapper[animate]({
                    opacity: 1,
                }, 200, $.proxy( function() {
                    if ( addEventH <= eventH ) {
                        fadeIn.call( this );
                        return;
                    }

                    var top = pos.top;
                    if ( top + maxH > scrollH ) {
                        top = Math.max( scrollH - maxH - 18, pos.top + eventH - addEventH );
                    }

                    this._addEventWrapper[animate]({
                        top: top,
                        height: addEventH
                    }, 200, $.proxy( fadeIn, this ));

                    function fadeIn() {
                        this._refreshAddEvent();
                        this._addEvent[animate]({
                            opacity: 1
                        }, 200, $.proxy( function() {
                            var txtEl = this._addEvent.find( ".txt-event-content" );
                            txtEl.selectRange( txtEl.val().length );
                        }, this ));
                    }
                }, this ));
            } else if ( opts.view == "week" ) {
                this._editingEvent.popbox({
                    width: 340,
                    content: this._addEvent
                });

                var txtEl = this._addEvent.find( ".txt-event-content" );
                // txtEl.selectRange( txtEl.val().length );
            }

            this.element.removeClass( "tcal-dragging" );
        },
        _eventSelect: function( e, param ) {
            e.preventDefault();
            var opts = this.options,
            target = $( e.currentTarget ),
            resize = $( e.target ).is( ".tcal-event-resize-handle" );

            if ( !opts.editable || target.hasClass( "editing" )) {
                return;
            }

            if ( false && resize ) {
                return;
            }

            if ( this._editingEvent ) {
                this._dismissAddEvent( true );
            }

            this._editingEvent = $( e.currentTarget )
            .addClass( "editing" );

            this._editingEvent.data({
                originStart: this._editingEvent.data( "start" ),
                originEnd: this._editingEvent.data( "end" ),
                originCol: this._editingEvent.data( "col" )
            });

            var mirrorEvent = this._editingEvent.data( "mirrorEvent" );
            if ( mirrorEvent ) {
                mirrorEvent.data({
                    originStart: mirrorEvent.data( "start" ),
                    originEnd: mirrorEvent.data( "end" ),
                    originCol: mirrorEvent.data( "col" )
                });
            }

            if ( false ) {
                this._bodyInner.one( "touchend.tcal", $.proxy( this._selectStop, this ));
            } else {
                $( document ).one( "mouseup.tcal", $.proxy( this._selectStop, this ));
            }

            if ( false ) {
                this._bodyInner.bind( "touchmove.tcal", {
                    originY: param.originalEvent.touches[0].pageY,
                    originX: param.originalEvent.touches[0].pageX,
                    resize: resize
                }, $.proxy( this._eventMoveStart , this ));
            } else {
                $( document ).bind( "mousemove.tcal", {
                    originY: e.pageY,
                    originX: e.pageX,
                    resize: resize
                }, $.proxy( this._eventMoveStart , this ));
            }
        },
        _eventMoveStart: function( e ) {
            e.stopPropagation();
            var pageX = false ? e.originalEvent.touches[0].pageX : e.pageX,
            pageY = false ? e.originalEvent.touches[0].pageY : e.pageY;
            if ( Math.abs( pageX - e.data.originX ) < 5 && Math.abs( pageY - e.data.originY ) < 5 ) {
                return;
            }

            if ( false ) {
                this._bodyInner.unbind( "touchend.tcal" )
                .unbind( "touchmove.tcal" )
                .bind( "touchmove.tcal", e.data, $.proxy( this._eventMove, this ));
                this._bodyInner.one( "touchend.tcal", $.proxy( eventMoved, this ));
            } else {
                $( document ).unbind( "mouseup.tcal" )
                .unbind( "mousemove.tcal" )
                .bind( "mousemove.tcal", e.data, $.proxy( this._eventMove, this ));
                $( document ).one( "mouseup.tcal", $.proxy( eventMoved, this ));
            }

            this.element.addClass( e.data.resize ? "tcal-resizing" : "tcal-dragging" );

            function eventMoved() {
                if ( false ) {
                    this._bodyInner.unbind( "touchmove.tcal" );
                } else {
                    $( document ).unbind( "mousemove.tcal" );
                }
                this.element.removeClass( "tcal-resizing tcal-dragging" );

                var log = this._editingEvent.data( "log" ),
                colDate = $( this._cols[this._editingEvent.data( "col" )] ).attr( "date" ) * 1,
                start = colDate + this._editingEvent.data( "start" ) * 1800000,
                end = colDate + this._editingEvent.data( "end" ) * 1800000;
                $.ajax({
                    url: teamcola.api.updateWorklog,
                    data: {
                        data: $.toJSON({
                            guid: log.guid,
                            content: log.content,
                            team: log.team_id,
                            labels: $.map( log.labels, function( label, i ) {
                                return label.guid;
                            }),
                            start: start,
                            end: end
                        })
                    },
                    success: $.proxy( function( result ) {
                        if ( this._editingEvent ) {
                            $.extend( log, result.worklog );
                            this._sortData( colDate );

                            this._removeEventTime(
                            $( this._cols[this._editingEvent.data( "originCol" )] ).attr( "date" ),
                            this._editingEvent.data( "originStart" ),
                            this._editingEvent.data( "originEnd" )
                            );

                            this._addEventTime(
                            colDate,
                            this._editingEvent.data( "start" ),
                            this._editingEvent.data( "end" )
                            );

                            this._editingEvent.removeClass( "editing" )
                            .removeData( "originStart" )
                            .removeData( "originEnd" )
                            .removeData( "originCol" );

                            var mirrorEvent = this._editingEvent.data( "mirrorEvent" );
                            if ( mirrorEvent ) {
                                this._removeEventTime(
                                $( this._cols[mirrorEvent.data( "originCol" )] ).attr( "date" ),
                                mirrorEvent.data( "originStart" ),
                                mirrorEvent.data( "originEnd" )
                                );

                                this._addEventTime(
                                $( this._cols[mirrorEvent.data( "col" )] ).attr( "date" ),
                                mirrorEvent.data( "start" ),
                                mirrorEvent.data( "end" )
                                );

                                mirrorEvent.removeClass( "editing" )
                                .removeData( "originStart" )
                                .removeData( "originEnd" )
                                .removeData( "originCol" );
                            }

                            this._editingEvent = null;
                        }
                    }, this )
                });
            }
        },
        _eventMove: function( e ) {
            e.stopPropagation();
            var opts = this.options;

            if ( !this._editingEvent ) {
                return;
            }

            var pageX = false ? e.originalEvent.touches[0].pageX : e.pageX,
            pageY = false ? e.originalEvent.touches[0].pageY : e.pageY,
            offsetX = pageX - e.data.originX,
            offsetY = pageY - e.data.originY,
            offsetXSlot = Math.round( offsetX / this._slotWidth ),
            offsetYSlot = Math.round( offsetY / this._slotHeight ),
            originStart = this._editingEvent.data( "originStart" ),
            originEnd = this._editingEvent.data( "originEnd" ),
            originCol = this._editingEvent.data( "originCol" ),
            colDate = $( this._cols[originCol + offsetXSlot] ).attr( "date" ) * 1,
            log = this._editingEvent.data( "log" );

            if ( e.data.resize ) {
                if ( originEnd + offsetYSlot <= Math.max( originStart, 0 )) {
                    return;
                }

                if ( !this._checkEventTime( colDate, originStart, originEnd + offsetYSlot, originStart, originEnd )) {
                    return;
                }

                if ( originStart < 0 ) {
                    var mirrorEvent = this._editingEvent.data( "mirrorEvent" ),
                    mirrorEnd = 48 + originEnd;
                    mirrorEvent.css({
                        height: ( originEnd - originStart + offsetYSlot ) * this._slotHeight - 2
                    }).data({
                        end: mirrorEnd + offsetYSlot
                    });
                }

                this._editingEvent.css({
                    height: ( originEnd - originStart + offsetYSlot ) * this._slotHeight - 2
                }).data({
                    end: originEnd + offsetYSlot
                });

            } else {
                if ( originEnd + offsetYSlot < 1 || originStart + offsetYSlot > 47
                || originCol + offsetXSlot < 0 || originCol + offsetXSlot >= this._cols.length ) {
                    return;
                }

                var excludeStart, excludeEnd;
                if ( offsetXSlot == 0 ) {
                    excludeStart = originStart;
                    excludeEnd = originEnd;
                }

                if ( !this._checkEventTime( colDate, originStart + offsetYSlot, originEnd + offsetYSlot, excludeStart, excludeEnd )) {
                    return;
                }

                var mirrorEvent = this._editingEvent.data( "mirrorEvent" ),
                mirrorExcludeStart,
                mirrorExcludeEnd;
                if ( originStart + offsetYSlot < 0 || originEnd + offsetYSlot > 48 ) {
                    var flag = originStart + offsetYSlot < 0 ? 1 : -1,
                    mirrorExcludeStart = mirrorEvent ? mirrorEvent.data( "originStart" ) : null,
                    mirrorExcludeEnd = mirrorEvent ? mirrorEvent.data( "originEnd" ) : null,
                    mirrorStart = flag * 48 + originStart + offsetYSlot,
                    mirrorEnd = flag * 48 + originEnd + offsetYSlot,
                    mirrorCol = originCol + offsetXSlot - flag * 1;

                    if ( !this._checkEventTime( colDate - flag * 86400000, mirrorStart, mirrorEnd , mirrorExcludeStart, mirrorExcludeEnd )) {
                        return;
                    }

                    if ( !mirrorEvent ) {
                        mirrorEvent = this._createEventEl({
                            content: log.content,
                            col: mirrorCol,
                            start: mirrorStart,
                            end: mirrorEnd,
                            color: log.labels[0].color
                        }).data({
                            "log": log,
                            "mirrorEvent": this._editingEvent
                        });
                        this._editingEvent.data( "mirrorEvent", mirrorEvent );
                    } else {
                        var mirrorLeft = -2 * this._slotWidth;
                        if ( mirrorCol >= 0 && mirrorCol < this._cols.length ) {
                            mirrorLeft = mirrorCol * this._slotWidth + ( opts.view == "day" ? 8 : 3 );
                        }

                        mirrorEvent.css({
                            top: mirrorStart * this._slotHeight,
                            left: mirrorLeft
                        }).data({
                            start: mirrorStart,
                            end: mirrorEnd,
                            col: mirrorCol
                        });
                    }

                    mirrorEvent.find( ".tcal-event-title" ).css({
                        marginTop: Math.max( - mirrorStart * this._slotHeight, 0 )
                    });
                } else {
                    if ( mirrorEvent ) {
                        this._removeEventTime(
                        $( this._cols[mirrorEvent.data( "originCol" )] ).attr( "date" ),
                        mirrorEvent.data( "originStart" ),
                        mirrorEvent.data( "originEnd" )
                        );
                        mirrorEvent.remove();
                    }
                    this._editingEvent.removeData( "mirrorEvent" );
                }

                this._editingEvent.find( ".tcal-event-title" ).css({
                    marginTop: Math.max( - ( originStart + offsetYSlot ) * this._slotHeight, 0 )
                });

                this._editingEvent.css({
                    top: ( originStart + offsetYSlot ) * this._slotHeight,
                    left: ( originCol + offsetXSlot ) * this._slotWidth + ( opts.view == "day" ? 8 : 3 )
                }).data({
                    start: originStart + offsetYSlot,
                    end: originEnd + offsetYSlot,
                    col: originCol + offsetXSlot
                });
            }

            this._refreshEventTime();
        },
        _refreshEventTime: function() {
            var startDate = Date.today().addMilliseconds( this._editingEvent.data( "start" ) * 1800000 ),
            endDate = Date.today().addMilliseconds( this._editingEvent.data( "end" ) * 1800000 ),
            mirrorEvent = this._editingEvent.data( "mirrorEvent" );
            this._editingEvent.find( ".start" ).text( startDate.toString( "HH:mm" ));
            this._editingEvent.find( ".end" ).text( endDate.toString( "HH:mm" ));
            mirrorEvent && mirrorEvent.find( ".start" ).text( startDate.toString( "HH:mm" ));
            mirrorEvent && mirrorEvent.find( ".end" ).text( endDate.toString( "HH:mm" ));
        },
        _autoScroll: function( el, elH ) {
            elH = elH || el.outerHeight();

            var pos = el.position(),
            scrollT = this._body.scrollTop(),
            scrollH = this._body[0].scrollHeight,
            eventH = this._editingEvent.height(),
            eventW = this._editingEvent.width();

            if ( pos.top - scrollT < 0 ) {
                this._body.animate({
                    scrollTop: pos.top - 18
                }, 200 );
            } else if ( pos.top + elH > this._bodyH + scrollT ) {
                this._body.animate({
                    scrollTop: Math.min( pos.top + elH - this._bodyH + 18, scrollH - this._bodyH )
                }, 200 );
            }
        },
        _refreshTime: function() {
            var opts = this.options;
            if ( !this._timeIndicator ) {
                this._timeIndicator = $( '<div class="tcal-now"></div>' )
                .appendTo( this._bodyInner );
            }

            var now = new Date(),
            todayCol = this._body.find( ".tcal-col.today" );
            if ( !todayCol.length ) {
                this._timeIndicator.hide();
            } else {
                this._timeIndicator.css({
                    width: todayCol.width() - 1,
                    top: Math.round(( now.getTime() - Date.today().getTime()) / 1800000 * this._slotHeight ),
                    left: 60 + this._slotWidth * this._cols.indexOf( todayCol[0] )
                }).show();
            }
        },
        _refreshAddEvent: function() {
            if ( this._addEventWrapper ) {
                var addEventH = Math.max( this._editingEvent.outerHeight(), this._addEvent.outerHeight());
                this._addEventWrapper.css({
                    height: addEventH
                });
            } else {
                this._editingEvent.popbox( "refresh" );
            }

            this._addEvent.find( ".txt-event-content" ).height( Math.max( addEventH - 84, 74 ));
        },
        _initAddEvent: function() {
            var opts = this.options,
            edit = this._editingEvent.hasClass( "editing" );

            this._addEvent = $( template.addEvent );

            if ( opts.view == "day" ) {
                this._addEventWrapper = $( '<div class="tcal-add-event-wrapper"></div>' )
                .append( this._addEvent )
                .appendTo( this._events );
                this._addEventHandle = $( '<div class="tcal-add-event-handle"></div>' )
                .appendTo( this._events );
            }

            var teamButtons = this._addEvent.find( ".teams" ).empty(),
            selectLabel = this._addEvent.find( ".select-label" );
            $.each( teamcola.teams, $.proxy( function( index, team ) {
                var teamButton = $( '<a href="#" class="btn team unselectable" unselectable="on"></a>' )
                .text( team.name )
                .attr( "guid", team.guid )
                .mousedown( $.proxy( function( e ) {
                    e.preventDefault();
                    var btn = $( e.currentTarget );

                    if ( btn.hasClass( "active" )) {
                        return;
                    }

                    $( e.currentTarget ).addClass( "active" )
                    .siblings( ".btn" )
                    .removeClass( "active" );

                    selectLabel.empty();

                    var labels = btn.data( "labels" );
                    $.each( labels, $.proxy( function( index, label ) {
                        $( "<option />", {
                            val: label.guid,
                            text: label.name
                        }).appendTo( selectLabel )
                        .data( "label", label );
                    }, this ));

                    this._refreshAddEvent();
                }, this ))
                .data( "labels", team.labels );

                if ( index == 0 ) {
                    teamButton.addClass( "first" );
                } else if ( index == teamcola.teams.length - 1 ) {
                    teamButton.addClass( "last" );
                }

                teamButton.appendTo( teamButtons );
            }, this ));

            if ( teamcola.teams.length == 1 ) {
                this._addEvent.find( ".choose-team" ).hide();
            }

            selectLabel.change( $.proxy( function( e ) {
                var label = selectLabel.find( "option:selected" ).data( "label" );
                if ( this._editingEvent && label ) {
                    this._editingEvent.css({
                        background: label.color
                    });
                }
            }, this ));

            this._addEvent.find( ".link-cancel" ).click( $.proxy( function( e ) {
                e.preventDefault();
                var log = this._editingEvent.data( "log" );
                if ( log ) {
                    this._editingEvent.css({
                        background: log.labels[0].color
                    });
                }

                this._dismissAddEvent( !edit );
            }, this ));

            this._addEvent.find( ".txt-event-content" ).keydown( $.proxy( function( e ) {
                if ( e.metaKey && e.which == 13 ) {
                    this._addEvent.find( ".btn-add-event" ).click();
                }
            }, this )).change( $.proxy( function( e ) {
                if ( !edit ) {
                    $.cookie( "recentContent", $( e.currentTarget ).val(), {
                        expires: new Date( 3010, 0, 1 ),
                        path: "/"
                    });
                }
            }));

            this._addEvent.find( ".btn-add-event" ).click( $.proxy( function( e ) {
                e.preventDefault();
                var btn = $( e.currentTarget ),
                eventContent = this._addEvent.find( ".txt-event-content" ).val(),
                team = this._addEvent.find( ".team.active" ).attr( "guid" ),
                label = this._addEvent.find( ".select-label" ).val();

                eventContent = $( "<div/>" ).text(eventContent).html();

                if ( !eventContent || !team ) {
                    return;
                }

                tinyLoading.show( btn );
                btn.siblings( ".link-cancel" ).hide();

                var params = null;
                if ( edit ) {
                    var log = this._editingEvent.data( "log" );
                    params = {
                        guid: log.guid,
                        content: eventContent,
                        team: team,
                        labels: [label],
                        start: log.start_time,
                        end: log.end_time
                    };
                } else {
                    var colDate = $( this._cols[this._editingEvent.data( "col" )] ).attr( "date" ) * 1,
                    start = colDate + this._editingEvent.data( "start" ) * 1800000,
                    end = colDate + this._editingEvent.data( "end" ) * 1800000;
                    params = {
                        content: eventContent,
                        team: team,
                        labels: [label],
                        start: start,
                        end: end
                    };
                }

                $.ajax({
                    url: edit ? teamcola.api.updateWorklog : teamcola.api.addWorklog,
                    data: {
                        data: $.toJSON( params )
                    },
                    success: $.proxy( function( result ) {
                        if ( this._editingEvent ) {
                            if ( edit ) {
                                $.extend( log, result.worklog );
                            } else {
                                opts.data[colDate].push( result.worklog );
                                this._sortData( colDate );
                                this._editingEvent.data( "log", result.worklog );
                                this._addEventTime(
                                colDate,
                                this._editingEvent.data( "start" ),
                                this._editingEvent.data( "end" )
                                );
                                $.cookie( "recentContent", null, {
                                    path: "/"
                                });
                            }

                            var mirrorEvent = this._editingEvent.data( "mirrorEvent" );
                            this._editingEvent.removeClass( "placeholder editing" )
                            .find( "p" ).html( eventContent );
                            if ( mirrorEvent ) {
                                mirrorEvent.find( "p" ).html( eventContent );
                            }

                            if ( !result.worklog.labels || !result.worklog.labels.length ) {
                                this._editingEvent.css({
                                    background: ""
                                });
                                if ( mirrorEvent ) {
                                    mirrorEvent.css({
                                        background: ""
                                    });
                                }
                            } else {
                                this._editingEvent.css({
                                    background: result.worklog.labels[0].color
                                });
                                if ( mirrorEvent ) {
                                    mirrorEvent.css({
                                        background: result.worklog.labels[0].color
                                    });
                                }
                            }
                            this._dismissAddEvent();
                        }

                        $.cookie( "recentLabel", $.toJSON( result.worklog.labels[0] ), {
                            expires: new Date( 3010, 0, 1 ),
                            path: "/"
                        });

                        // $.cookie( "recentTeam", team, {
                        //     expires: new Date( 3010, 0, 1 ),
                        //     path: "/"
                        // });
                    }, this ),
                    error: function() {
                        tinyLoading.hide( btn );
                        btn.siblings( ".link-cancel" ).show();
                    }
                });
            }, this ));

            this._addEvent.find( ".link-delete" ).click( $.proxy( function( e ) {
                e.preventDefault();
                var link = $( e.currentTarget );

                $.confirm({
                    content: "<p>确定要删除这条日志吗？</p>",
                    callback: $.proxy( function( yes ) {
                        if ( !yes ) {
                            return;
                        }

                        tinyLoading.show( link );

                        var log = this._editingEvent.data( "log" );
                        $.ajax({
                            url: teamcola.api.deleteWorklog,
                            data: {
                                data: $.toJSON({
                                    guid: log.guid
                                })
                            },
                            success: $.proxy( function( result ) {
                                if ( this._editingEvent ) {
                                    var colDate = $( this._cols[this._editingEvent.data( "col" )]).attr( "date" );
                                    opts.data[colDate].splice( opts.data[colDate].indexOf( log ), 1 );

                                    this._removeEventTime(
                                    ( new Date( log.start_time )).clearTime().getTime(),
                                    this._editingEvent.data( "start" ),
                                    this._editingEvent.data( "end" )
                                    );

                                    var mirrorEvent = this._editingEvent.data( "mirrorEvent" );
                                    if ( mirrorEvent ) {
                                        this._removeEventTime(
                                        $( this._cols[mirrorEvent.data( "originCol" )] ).attr( "date" ),
                                        mirrorEvent.data( "originStart" ),
                                        mirrorEvent.data( "originEnd" )
                                        );
                                        mirrorEvent.remove();
                                    }

                                    this._editingEvent.addClass( "placeholder" );
                                    this._dismissAddEvent();
                                }
                            }, this ),
                            error: function() {
                                tinyLoading.hide( link );
                            }
                        });
                    }, this )
                });

            }, this ));

            this._addEvent.find( ".btn-close" ).click( $.proxy( function( e ) {
                e.preventDefault();
                this._dismissAddEvent();
            }, this ));

            if ( edit ) {
                var log = this._editingEvent.data( "log" ),
                decodedContent = $( "<div/>" ).html( log.content ).text();

                this._addEvent.find( ".txt-event-content" ).val( decodedContent );
                this._addEvent.find( ".link-delete" ).show();
                this._addEvent.find( ".team[guid=" + log.team_id + "]" ).mousedown();
                if ( log.labels && log.labels.length ) {
                    var label = log.labels[0],
                    selectLabel = this._addEvent.find( ".select-label" );
                    if ( label.status == 2 ) {
                        $( "<option />", {
                            val: label.guid,
                            text: label.name
                        }).appendTo( selectLabel )
                        .data( "label", label );
                        selectLabel.attr( "disabled", "disabled" );

                        this._addEvent.find( ".txt-event-content" )
                        .attr( "disabled", "disabled" );
                        this._addEvent.find( ".buttons" ).css( "display", "none");
                        this._addEvent.find( ".archive-buttons" ).css( "display", "block" );
                        this._addEvent.find( ".choose-labels .info" )
                        .text( "已被" + label.archiver_name + "归档" )
                        .css( "display", "block" );
                    }

                    selectLabel.val( log.labels[0].guid );
                }
            } else {
                // var recentTeam = $.cookie( "recentTeam" ) || teamcola.currentTeam;
                teamButtons.find( ".team[guid=" + teamcola.currentTeam + "]" )
                .mousedown();

                var recentLabel = $.evalJSON( $.cookie( "recentLabel" ) || null );
                if ( recentLabel ) {
                    this._addEvent.find( ".select-label" ).val( recentLabel.guid );
                }

                this._addEvent.find( ".link-delete" ).hide();
                this._addEvent.find( ".txt-event-content" ).val( $.cookie( "recentContent" ));
            }

        },
        _dismissAddEvent: function( fast ) {
            var opts = this.options,
            animate = $.support.cssTransition ? "animateWithCss" : "animate";

            if ( opts.view == "day" ) {
                if ( fast ) {
                    this._addEventWrapper.remove();
                    this._addEventHandle.remove();
                } else {
                    this._addEvent[animate]({
                        opacity: 0
                    }, 200, $.proxy( function() {
                        this._addEvent.remove();

                        this._addEventWrapper[animate]({
                            top: this._addEventHandle.position().top,
                            height: this._addEventHandle.height()
                        }, 200 , $.proxy( function() {
                            this._addEventHandle[animate]({
                                opacity: 0
                            }, 200, function() {
                                $( this ).remove();
                            });

                            this._addEventWrapper[animate]({
                                opacity: 0
                            }, 200, function() {
                                $( this ).remove();
                            });
                        }, this ));
                    }, this ));

                }
            } else if ( opts.view == "week" ) {
                this._editingEvent.popbox( "destroy" );
            }

            if ( this._editingEvent.hasClass( "placeholder" )) {
                this._editingEvent.remove();
            } else if ( this._editingEvent.hasClass( "editing" )) {
                this._editingEvent.removeClass( "editing" );
            }
            this._editingEvent = null;
        },
        _createEventEl: function( event ) {
            var opts = this.options,
            startDate = Date.today().addMilliseconds( event.start * 1800000 ),
            endDate = Date.today().addMilliseconds( event.end * 1800000 ),
            left = event.col * this._slotWidth + ( opts.view == "day" ? 8 : 3 );

            if ( event.col < 0 || event.col >= this._cols.length ) {
                left = -2 * this._slotWidth;
            }

            var eventEl = $( template.event
            .replace( /\#\{start\}/g, startDate.toString( "HH:mm" ))
            .replace( /\#\{end\}/g, endDate.toString( "HH:mm" ) )
            .replace( /\#\{text\}/g, event.content )).css({
                top: event.start * this._slotHeight,
                left: left,
                width: this._slotWidth - ( opts.view == "day" ? 20 : 4 ),
                height: ( event.end - event.start ) * this._slotHeight - 2
            }).data({
                start: event.start,
                end: event.end,
                col: event.col
            }).bind( false ? "press.tcal" : "mousedown.tcal", $.proxy( this._eventSelect, this ))
            .appendTo( this._events );

            if ( event.start < 0 ) {
                eventEl.find( ".tcal-event-title" ).css({
                    marginTop: - event.start * this._slotHeight
                });
            }

            if ( event.editing ) {
                eventEl.addClass( "editing" );
            }

            if ( event.placeholder ) {
                eventEl.addClass( "placeholder" );
            }

            if ( event.color ) {
                eventEl.css({
                    background: event.color
                });
            }

            if ( false ) {
                eventEl.bind( "tap.tcal", $.proxy( function( e, params ) {
                    if ( this._editingEvent ) {
                        this._dismissAddEvent( true );
                    }

                    this._editingEvent = $( e.currentTarget )
                    .addClass( "editing" );
                    this._selectStop( $.Event( "tap" ));
                }, this )).find( ".tcal-event-resize-handle" )
                .text( "=" )
                .bind( "touchstart", $.proxy( function( e ) {
                    e.stopPropagation();
                    e.preventDefault();
                    var opts = this.options,
                    target = $( e.currentTarget ).parents( ".tcal-event:first" );

                    if ( !opts.editable || target.hasClass( "editing" )) {
                        return;
                    }

                    if ( this._editingEvent ) {
                        this._dismissAddEvent( true );
                    }

                    this._editingEvent = target.addClass( "editing" );
                    this._editingEvent.data({
                        originStart: this._editingEvent.data( "start" ),
                        originEnd: this._editingEvent.data( "end" ),
                        originCol: this._editingEvent.data( "col" )
                    });

                    var mirrorEvent = this._editingEvent.data( "mirrorEvent" );
                    if ( mirrorEvent ) {
                        mirrorEvent.data({
                            originStart: mirrorEvent.data( "start" ),
                            originEnd: mirrorEvent.data( "end" ),
                            originCol: mirrorEvent.data( "col" )
                        });
                    }

                    this._bodyInner.bind( "touchmove.tcal", {
                        originY: e.originalEvent.touches[0].pageY,
                        originX: e.originalEvent.touches[0].pageX,
                        resize: true
                    }, $.proxy( this._eventMoveStart , this ));

                }, this ));
            } else {
                eventEl.hover(
                function( e ) {
                    $( this )
                    .find( ".tcal-event-resize-handle" )
                    .text( "=" );
                },
                function( e ) {
                    $( this )
                    .find( ".tcal-event-resize-handle" )
                    .text( "" );
                });
            }

            return eventEl;
        },
        _sortData: function( date ) {
            if ( !date ) {
                $.each( this._cols, $.proxy( function( index, col ) {
                    this._sortData( $( col ).attr( "date" ));
                }, this ));
                return;
            }

            var opts = this.options;
            opts.data[date].sort( function( a, b ) {
                return a.start - b.start;
            });
        },
        _checkEventTime: function( date, start, end, excludeStart, excludeEnd ) {
            var result = true;
            for ( var i = start * 1; i < end * 1; i++ ) {
                if ( this._occupiedTime[date] && this._occupiedTime[date].indexOf( i + "" ) >= 0) {
                    if (( excludeStart || excludeStart === 0 ) && excludeEnd && i >= excludeStart && i < excludeEnd ) {
                        continue;
                    }
                    result = false;
                    break;
                }
            }
            return result;
        },
        _addEventTime: function( date, start, end ) {
            if ( !this._occupiedTime[date]) {
                this._occupiedTime[date] = [];
            }

            for (var i = start; i < end; i++ ) {
                if ( this._occupiedTime[date].indexOf( i + "" ) < 0 ) {
                    this._occupiedTime[date].push( i + "" );
                }
            }
        },
        _removeEventTime: function( date, start, end ) {
            if ( !this._occupiedTime[date] ) {
                return;
            }

            for (var i = start; i < end; i++ ) {
                var index = this._occupiedTime[date].indexOf( i + "" ) ;
                if ( index >= 0 ) {
                    this._occupiedTime[date].splice( index, 1 );
                }
            }
        },
        _calculateHour: function( logs ) {
            if ( !logs || !logs.length ) {
                return 0;
            }

            var hour = 0;
            $.each( logs, function( index, log ) {
                hour += ( log.end_time - log.start_time ) / 3600000;
            });

            return hour;
        },
        _cellClick: function( e ) {
            e.preventDefault();
            var cell = $( e.currentTarget ),
            logs = cell.data( "logs" );

            if ( cell.hasClass( "active" )) {
                cell.removeClass( "active" )
                .popbox( "destroy" );
                return;
            } else if ( !logs || !logs.length ) {
                this._body.find( ".tcal-month-cell.active" )
                .removeClass( "active" )
                .popbox( "destroy" );
                return;
            }

            cell.addClass( "active" )
            .siblings( ".tcal-month-cell.active" )
            .removeClass( "active" )
            .popbox( "destroy" );

            var date = new Date( cell.attr( "date" ) * 1 ),
            weekdays = ["日", "一", "二", "三", "四", "五", "六"],
            popContent = $( template.monthPop
            .replace( /\#\{date\}/g, date.toString( "M月d日" ))
            .replace( /\#\{weekday\}/g, "星期" + weekdays[date.getDay()])
            .replace( /\#\{hour\}/g, this._calculateHour( logs ).toFixed( 1 ) + "小时" ));

            var worklogList = popContent.find( ".cell-worklogs" );
            $.each( logs, function( index, log ) {
                $( template.worklog
                .replace( /\#\{hour\}/g, (( log.end_time - log.start_time ) / 3600000 ).toFixed( 1 ))
                .replace( /\#\{content\}/g, log.content ))
                .appendTo( worklogList );
            });

            popContent.click( function( e ) {
                return false;
            }).find( ".link-detail" ).click( $.proxy( function( e ) {
                e.preventDefault();
                this.element.trigger( "celldetail", [date] );
            }, this ));

            this.element.trigger( "cellpopover", [popContent] );

            cell.popbox({
                width: 340,
                content: popContent
            });

            return false;
        },
        loadData: function( data, startDate ) {
            var opts = this.options;
            opts.data = data;
            opts.startDate = startDate;

            if ( opts.view == "month" ) {
                var monthStart = new Date( startDate * 1 ),
                monthEnd = monthStart.clone().moveToLastDayOfMonth(),
                firstDate = monthStart.getTime(),
                lastDate = monthEnd.getTime(),
                today = Date.today().getTime();

                if ( monthStart.getDay() != 1 ) {
                    firstDate = monthStart.clone().moveToDayOfWeek( 1, -1 ).getTime();
                }

                if ( monthEnd.getDay() != 0 ) {
                    lastDate = monthEnd.clone().moveToDayOfWeek( 0 ).getTime();
                }

                this._body.empty();
                for ( var d = firstDate; d <= lastDate; d += 86400000 ) {
                    var date = new Date( d ),
                    hour = this._calculateHour( data[d] ),
                    cell = $( template.monthCell.replace( /\#\{date\}/g, date.getDate()));

                    cell.css({
                        width: this._slotWidth - 1,
                        height: this._slotWidth - 1
                    }).mouseenter( function( e ) {
                        $( this ).addClass( "over" );
                    }).mouseleave( function( e ) {
                        $( this ).removeClass( "over" );
                    }).click( $.proxy( this._cellClick, this ))
                    .attr( "date", d )
                    .data( "logs", data[d] );

                    cell.find( "span" ).css({
                        width: this._slotWidth - 9,
                        height: this._slotWidth - 9,
                        "line-height": ( this._slotWidth - 9 ) + "px"
                    });

                    if ( d == today ) {
                        cell.addClass( "today" );
                    }

                    if ( d < monthStart.getTime() || d > monthEnd.getTime() || d > today ) {
                        cell.addClass( "disabled" );
                    }

                    if ( hour > 0 && hour < 4 ) {
                        cell.addClass( "danteng" );
                    } else if ( hour >= 4 && hour <= 8 ) {
                        cell.addClass( "idle" );
                    } else if ( hour > 8 && hour <= 12 ) {
                        cell.addClass( "busy" );
                    } else if ( hour > 12 ) {
                        cell.addClass( "kouka" );
                    }

                    this._body.append( cell );
                }
            } else {
                this._body.find( ".tcal-events" ).empty();
                this._occupiedTime = {};

                var headerSlots = this._header.find( ".tcal-header-slot" ),
                today = Date.today().getTime();
                $.each( this._cols, $.proxy( function( index, col ) {
                    var date = opts.startDate + index * 86400000;

                    headerSlots.eq( index )
                    .find( ".date" )
                    .text(( new Date( date )).toString( "M / d" ));

                    $( col ).attr( "date", date );

                    if ( date == today ) {
                        $( col ).addClass( "today" );
                    } else {
                        $( col ).removeClass( "today" );
                    }

                    // if ( date > today ) {
                    //     $( col ).addClass( "future" );
                    //     this._addEventTime( date, 0, 48 );
                    // } else {
                    //     $( col ).removeClass( "future" );
                    // }

                    if ( !data[date] || !data[date].length ) {
                        return;
                    }

                    $.each( data[date], $.proxy( function( i, log ) {
                        this.addEvent( log );
                    }, this ));

                    $( col ).data( "logs", data[date] );
                }, this ));

                if ( opts.view == "day" && startDate == today ) {
                    var now = ( new Date()).getTime(),
                    y = ( now - today ) / 1800000 * this._slotHeight - this._bodyH / 2;
                    if ( false ) {
                        this._iscroll.scrollTo( 0, - y, 0 )
                    } else {
                        this._body.scrollTop( y );
                    }
                } else {
                    if ( false ) {
                        this._iscroll.scrollTo( 0, -18 * this._slotHeight, 0 )
                    } else {
                        this._body.scrollTop( 18 * this._slotHeight );
                    }
                }

                this._refreshTime();
                clearInterval( this._refreshInterval );
                this._refreshInterval = setInterval( $.proxy( this._refreshTime, this ), 300000 );
            }
        },
        addEvent: function( log ) {
            var date = ( new Date( log.start_time * 1 )).clearTime().getTime(),
            start = Math.round(( log.start_time - date ) / 1800000 ),
            end = Math.round(( log.end_time - date ) / 1800000 ),
            col = this._body.find( ".tcal-col[date=" + date + "]" ),
            colIndex = this._cols.indexOf( col[0] );

            if ( !col.length ) {
                return false;
            }

            var eventEl = this._createEventEl({
                content: log.content,
                col: colIndex,
                start: start,
                end: end
            });

            if ( log.labels && log.labels.length ) {
                eventEl.css({
                    background: log.labels[0].color
                });
            }

            if ( end > 48 ) {
                var mirrorDate = date + 86400000,
                mirrorStart = Math.round(( log.start_time - mirrorDate ) / 1800000 ),
                mirrorEnd = Math.round(( log.end_time - mirrorDate ) / 1800000 );

                var mirrorEventEl = this._createEventEl({
                    content: log.content,
                    col: colIndex + 1,
                    start: mirrorStart,
                    end: mirrorEnd
                });

                if ( log.labels && log.labels.length ) {
                    mirrorEventEl.css({
                        background: log.labels[0].color
                    });
                }

                mirrorEventEl.data({
                    "log": log,
                    "mirrorEvent": eventEl
                });

                if ( colIndex + 1 < this._cols.length ) {
                    this._addEventTime( mirrorDate, mirrorStart, mirrorEnd );
                }
            }

            eventEl.data({
                "log": log,
                "mirrorEvent": mirrorEventEl
            });
            this._addEventTime( date, start, end );

            return eventEl;
        },
        destroy: function() {
            $.Widget.prototype.destroy.apply( this, arguments );
            // now do other stuff particular to this widget
        }
    });

})( jQuery );



var year = new Date().getFullYear();
var month = new Date().getMonth();
var day = new Date().getDate();

var eventData = {
  events : [
  ]
};



$(document).ready(function() {

  var calendar = $('#calendar');

  calendar.weekCalendar({
    firstDayOfWeek: 1,
    timeFormat: 'G:i',
    dateFormat: 'n / d',
    use24Hour: true,
    useShortDayNames: true,
    timeslotsPerHour: 2,
    showHeader: false,
    buttons: false,
    headerSeparator: '<br>',
    hourLine: true,
    timeslotHeight: 30,
    height: function($calendar){
      return $(window).height() - 150;
    },
    eventRender : function(calEvent, $event) {
      $event.attr('data-id', calEvent.id);
    },
    // eventNew : function(calEvent, $event) {
    //   // displayMessage("<strong>Added event</strong><br/>Start: " + calEvent.start + "<br/>End: " + calEvent.end);
    //   // alert("You've added a new event. You would capture this event, add the logic for creating a new event with your own fields, data and whatever backend persistence you require.");
    //   // $('#event-dialog').off('hidden').on('hidden', function() {
    //     // $event.fadeOut('fast', function() {
    //       // calendar.weekCalendar('removeEvent', calEvent.id);
    //     // });
    //   // }).modal();
    // },

    // eventClick : function(calEvent, $event) {
    //   displayMessage("<strong>Clicked Event</strong><br/>Start: " + calEvent.start + "<br/>End: " + calEvent.end);
    // },
    // eventMouseover : function(calEvent, $event) {
    //   displayMessage("<strong>Mouseover Event</strong><br/>Start: " + calEvent.start + "<br/>End: " + calEvent.end);
    // },
    // eventMouseout : function(calEvent, $event) {
    //   displayMessage("<strong>Mouseout Event</strong><br/>Start: " + calEvent.start + "<br/>End: " + calEvent.end);
    // },
    // noEvents : function() {
    //   displayMessage("There are no events for this week");
    // },
    data:eventData
  });

  function displayMessage(message) {
    // $("#message").html(message).fadeIn();
  }

  // $("<div id=\"message\" class=\"ui-corner-all\"></div>").prependTo($("body"));

});


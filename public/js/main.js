$(function() {

  // Attach FastClick to remove the 300ms tap delay
  FastClick.attach(document.body);

  // Init Responsive Nav
  var navigation = responsiveNav(".nav-collapse", {

    // Close the navigation when it's tapped
    closeOnNavClick: true
  });

  var navHidden = false;
  function hideNav() {
    if (!navHidden) {
      $('.logo').slideUp();
      $('.nav-collapse').slideUp();
      $('.nav-toggle').slideUp();
      navHidden = true;
    }
  }
  function showNav() {
    if (navHidden) {
      $('.logo').slideDown();
      $('.nav-collapse').slideDown();
      $('.nav-toggle').slideDown();
      setTimeout( hideNav, 5000);
      navHidden = false;
    }
  }

  // On slides page
  //if(window.location.href === "/") {
    // hide nav after two seconds
    setTimeout( hideNav, 2000);

    // show it on drag
    var $slides = $('#slides');
    Hammer($slides[0]).on('dragstart', function () {
      showNav();
    });

    Hammer($slides[0]).on("swipeleft", function(e) {
      $slides.data('superslides').animate('next');
    });
    Hammer($slides[0]).on("swiperight", function(e) {
      $slides.data('superslides').animate('prev');
    });
    $slides.superslides({
      hashchange: true
    });
//  }
});

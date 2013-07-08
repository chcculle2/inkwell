var login = (function(){
  var 
  method = {},
  $overlay,
  $modal,
  $content,
  $close;

  // Center the modal in the viewport
  method.center = function () {
    var top, left;

    top = (Math.max($(window).height() - $modal.outerHeight(), 0) / 2) - 200;
    left = Math.max($(window).width() - $modal.outerWidth(), 0) / 2;

    $modal.css({
      top:top + $(window).scrollTop(), 
      left:left + $(window).scrollLeft()
    });
  };

  // Open the modal
  method.open = function (settings) {
    $content.empty().append(settings.content);

    $modal.css({
      width: settings.width || 'auto', 
      height: settings.height || 'auto'
    });

    method.center();
    $(window).bind('resize.modal', method.center);
    $modal.fadeIn();//show();
    $overlay.fadeIn();//show();
  };

  // Close the modal
  method.close = function () {
    $modal.hide();
    $overlay.fadeOut();
    $content.empty();
    $(window).unbind('resize.modal');
  };

  // Generate the HTML and add it to the document
  $overlay = $('<div id="login-overlay"></div>');
  $modal = $('<div id="login-box"></div>');
  $content = $('<div id="login-content"></div>');
  $close = $('<a id="login-close" href="#">close</a>');

  $modal.hide();
  $overlay.hide();
  $modal.append($content, $close);

  $(document).ready(function(){
    $('body').append($overlay, $modal);                     
  });

  $close.click(function(e){
    e.preventDefault();
    method.close();
  });
  
  return method;
}());

// Wait until the DOM has loaded before querying the document
$(document).ready(function(){

  $('#login-button').click(function(e){
    e.preventDefault();

    data =  '<div id="login-box-modal">';
    data += '<div id="login-box-oauth">';
    data += '<a href="/users/auth/facebook"><img src="/assets/facebook_128.png"></a>';
    data += '<a href="/users/auth/google_oauth2"><img src="/assets/google_128.png"></a><br>';
    data += '<form action="/users/sign_in" method="post" id="login-form">';
    data += '<input autofocus="autofocus" id="user_email" name="user[email]" size="30" type="email" value="" placeholder="Email">';
    data += '<input id="user_password" name="user[password]" size="30" type="password" placeholder="Password">';
    data += '<input id="user_remember_me" name="user[remember_me]" type="checkbox" value="1" checked>';
    data += '<input name="commit" type="submit" value="Sign in" id="sign-in-button">';
    data += '<a href="/users/sign_up" class="login-link">Sign up</a><br>';
    data += '<a href="/users/password/new" class="login-link">Forgot your password?</a>';
    data += '</form>';

    data += '</div></div>';

    login.open({content: data, width: '320', height: '337'});
  });
});

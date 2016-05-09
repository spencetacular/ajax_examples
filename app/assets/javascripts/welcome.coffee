$(document).ready ->
  baseUrl = 'http://devpoint-ajax-example-server.herokuapp.com/api/v1/'

  addToList = (id, name) ->
    $.ajax '/users_template',
      type: 'GET'
      data:
        id: id
        name: name
      dataType: 'HTML'
      success: (data) ->
        $('#users_list').append(data)
      error: (data) ->
        console.log(data)

  reloadList = ->
    $('#users_list').children().remove()
    $.ajax "#{baseUrl}users",
      type: 'GET'
      success: (data) ->
        if data.users.length
          for user in data.users
            addToList user.id, user.first_name
        else
          $('#message_div').text("No users found.  Please add one!").slideToggle()
      error: (data) ->
        console.log data

  $(document).on 'click', '.user_delete', ->
    parent = $(@).parent()
    userId = parent.find('.user_item').attr('href')
    $.ajax "#{baseUrl}users/#{userId}",
      type: 'DELETE'
      success: (data) ->
        parent.slideToggle()
      error: (data) ->
        alert "The user was not deleted.  Please try again."

  $(document).on 'click', '.user_edit', ->
    $(@).parent().children('form').slideToggle()

  $(document).on 'click', '.user_item', (e) ->
    e.preventDefault()
    userId = $(@).attr('href')
    $.ajax "#{baseUrl}users/#{userId}",
      type: 'GET'
      success: (data) ->
        user = data.user
        $('#user_name').text "#{user.first_name} #{user.last_name}"
      error: (data) ->
        console.log data

  $(document).on 'click', '.reset', ->
    el = $(@).siblings('input')
    el.val(el.data('user_name'))

  $(document).on 'submit', '.edit-form', (e) ->
    e.preventDefault()
    name = $(@).children('input').val()
    id = $(@).data('user_id')
    $.ajax "#{baseUrl}users/#{id}",
      type: 'PUT'
      data: $(@).serializeArray()
      success: (data) ->
        reloadList()
      error: (data) ->
        console.log data

  $('#create_user_form').on 'submit', (e) ->
    e.preventDefault()
    $.ajax "#{baseUrl}users",
      type: 'POST'
      data: $(@).serializeArray()
      success: (data) ->
        $('#users_list').append(addToList(data.user.id, data.user.first_name))
        $('#create_user_form')[0].reset()
      error: (data) ->
        console.log data

  reloadList()


#$(document).ready(function(){
#  var baseUrl = 'http://devpoint-ajax-example-server.herokuapp.com/api/v1/'
#
#  function addToList(id, name) {
#    $.ajax('/users_template', {
#      type: 'GET',
#      data: { id: id, name: name },
#      dataType: 'HTML',
#      success: function(data) {
#        $('#users_list').append(data);
#      },
#      error: function(data) {
#      }
#    });
#
#    var x = 1;
#  }
#
#  reloadList();
#  function reloadList() {
#    $('#users_list').children().remove();
#    $.ajax(baseUrl + 'users', {
#      type: 'GET',
#      success: function(data) {
#        // data.users = array
#        // iterate data.users
#        if(data.users.length) {
#          for(var i = 0; i < data.users.length; i++) {
#            var user = data.users[i];
#            // populate users_list element with each users first name
#            // use the jquery append method on users_list
#            addToList(user.id, user.first_name);
#          }
#        } else {
#          $('#message_div').text('No users found. Please add one!').slideToggle();
#        }
#      },
#      error: function(data) {
#        debugger
#      }
#    });
#  }
#
#  $(document).on('click', '.user_delete', function() {
#    var $parent = $(this).parent();
#    var userId = $parent.find('.user_item').attr('href');
#    $.ajax(baseUrl + 'users/' + userId, {
#      type: 'DELETE',
#      success: function(data) {
#        $parent.slideToggle();
#      },
#      error: function(data) {
#        alert('The user was not deleted. Please try again.');
#      }
#    });
#  });
#
#  $(document).on('click', '.user_edit', function() {
#    $(this).parent().children('form').slideToggle();
#  });
#
#  $(document).on('click', '.user_item', function(e){
#    e.preventDefault();
#    var userId = $(this).attr('href');
#    $.ajax(baseUrl + 'users/' + userId, {
#      type: 'GET',
#      success: function(data) {
#        var user = data.user;
#        $('#user_name').text(user.first_name + ' ' + user.last_name);
#        $('#user_phone').text(user.phone_number);
#      },
#      error: function(data) {
#        debugger
#      }
#    });
#  });
#
#  $(document).on('click', '.reset', function(e){
#    var element = $(this).siblings('input');
#    element.val(element.data('user_name'));
#  });
#
#  $(document).on('submit', '.edit-form', function(e) {
#    e.preventDefault();
#    var self = $(this);
#    var name = $(this).siblings('input').val();
#    var id = $(this).data('user_id');
#    $.ajax(baseUrl + 'users/' + id, {
#      type: 'PUT',
#      data: $(this).serializeArray(),
#      success: function(data) {
#        reloadList();
#      }
#    });
#
#  });
#
#  $('#create_user_form').submit(function(e){
#    debugger
#    e.preventDefault();
#    $.ajax(baseUrl + 'users', {
#      type: 'POST',
#      data: $(this).serializeArray(),
#      success: function(data) {
#        $('#users_list').append(addToList(data.user.id, data.user.first_name));
#        $('#create_user_form')[0].reset();
#      },
#      error: function(data) {
#        console.log(data);
#      }
#    });
#  });
#});

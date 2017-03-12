@Users = React.createClass
  getInitialState: ->
    users: @props.users
    user_types: @props.user_types
  getDefaultProps: ->
    users: []
    user_types: {}
  componentDidMount: ->
    $.get "/users", (data) =>
      @setState users: data
  newUser: (user)->
    users = React.addons.update(@state.users, { $push: [user] })
    @setState users: users
  deleteUser: (user) ->
    index = @state.users.indexOf user
    users = React.addons.update(@state.users, { $splice: [[index, 1]] })
    @replaceState users: users
  updateUser: (user, data) ->
    index = @state.users.indexOf user
    users = React.addons.update(@state.users, { $splice: [[index, 1, data]] })
    @replaceState users: users
  render: ->
    React.DOM.div
      className: 'users'
      React.createElement UserForm, handleNewUser: @newUser, user_types: @props.user_types
      React.DOM.table
        className: 'table table-bordered'
        React.DOM.thead null,
          React.DOM.tr null,
            React.DOM.th null, 'Name'
            React.DOM.th null, 'Email'
            React.DOM.th null, 'Password'
            React.DOM.th null, 'User Type'
            React.DOM.th null, 'Actions'
        React.DOM.tbody null,
          for user in @state.users
            React.createElement User, key: user.id, user: user, user_types: @props.user_types, handleDeleteUser: @deleteUser, handleEditUser: @updateUser

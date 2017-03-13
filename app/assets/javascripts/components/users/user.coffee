@User = React.createClass
  getInitialState: ->
    edit: false
    error_message: {}
  handleToggle: (e) ->
    e.preventDefault()
    @setState edit: !@state.edit
    if @state.edit == false
      @setState error_message: {}
  handleDelete: (e) ->
    e.preventDefault()
    $.ajax
      method: 'DELETE'
      url: "/users"
      data:
        id: @props.user.id
      dataType: 'JSON'
      success: () =>
        @props.handleDeleteUser @props.user
  handleEdit: (e) ->
    e.preventDefault()
    data =
      name: ReactDOM.findDOMNode(@refs.name).value
      email: ReactDOM.findDOMNode(@refs.email).value
      user_type_id: ReactDOM.findDOMNode(@refs.user_type_id).value
    password = ReactDOM.findDOMNode(@refs.password).value
    if password
      data['password'] = password
      data['password_confirmation'] = password
    $.ajax
      method: 'PUT'
      url: "/users"
      dataType: 'JSON'
      data:
        user: data
        id: @props.user.id
      success: (data) =>
        @setState edit: false
        @props.handleEditUser @props.user, data
      error: (data) =>
        @setState error_message: data['responseJSON']
  errorMessage: ->
    option = ''
    $.map @state.error_message, (messages, k) ->
      value = ""
      for message in messages
        value = "#{value} #{message}"
      option = "#{option} #{k}: #{value};"
    option
  optionSet: ->
    option = $.map @props.user_types, (k,v) ->
      React.DOM.option
        key: "option_#{v}"
        value: v
        "#{k}"
    option
  userRow: ->
    React.DOM.tr null,
      React.DOM.td null, @props.user.name
      React.DOM.td null, @props.user.email
      React.DOM.td null, @props.user.password
      React.DOM.td null, @props.user.user_type['name']
      React.DOM.td null,
        React.DOM.a
          className: 'btn btn-default'
          onClick: @handleToggle
          'Edit'
        React.DOM.a
          className: 'btn btn-danger'
          onClick: @handleDelete
          'Delete'
  userForm: ->
    React.DOM.tr null,
      React.DOM.td null,
        React.DOM.input
          className: 'form-control'
          type: 'text'
          defaultValue: @props.user.name
          ref: 'name'
      React.DOM.td null,
        React.DOM.input
          className: 'form-control'
          type: 'text'
          defaultValue: @props.user.email
          ref: 'email'
      React.DOM.td null,
        React.DOM.input
          className: 'form-control'
          type: 'password'
          defaultValue: @props.user.password
          ref: 'password'
      React.DOM.td null,
        React.DOM.select
          className: 'form-control'
          name: 'user_type_id'
          defaultValue: @props.user.user_type_id
          ref: 'user_type_id'
          @optionSet()
      React.DOM.td null,
        React.DOM.a
          className: 'btn btn-default'
          onClick: @handleEdit
          'Update'
        React.DOM.a
          className: 'btn btn-danger'
          onClick: @handleToggle
          'Cancel'
        React.DOM.div null,
          @errorMessage()
  render: ->
    if @state.edit
      @userForm()
    else
      @userRow()

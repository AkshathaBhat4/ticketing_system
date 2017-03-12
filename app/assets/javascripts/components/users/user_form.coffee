@UserForm = React.createClass
  getInitialState: ->
    name: ''
    email: ''
    password: ''
    password_confirmation: ''
    user_type_id: null
    error_message: {}
  handleSubmit: (e) ->
    e.preventDefault()
    $.ajax
      method: 'POST'
      url: "/users"
      dataType: 'JSON'
      data: {user: @state}
      success: (data) =>
        @props.handleNewUser data
        @setState @getInitialState()
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
  handleChange: (e) ->
    name = e.target.name
    @setState "#{ name }": e.target.value
    if name == 'password'
      @setState password_confirmation: e.target.value
  valid: ->
    @state.name && @state.email && @state.password
  optionSet: ->
    option = $.map @props.user_types, (k,v) ->
      React.DOM.option
        key: "option_#{v}"
        value: v
        "#{k}"
    option
  render: ->
    React.DOM.form
      className: 'form-inline'
      onSubmit: @handleSubmit
      React.DOM.div
        className: 'form-group'
        React.DOM.input
          type: 'text'
          className: 'form-control'
          placeholder: 'Name'
          name: 'name'
          value: @state.name
          onChange: @handleChange
      React.DOM.div
        className: 'form-group'
        React.DOM.input
          type: 'text'
          className: 'form-control'
          placeholder: 'Email Id'
          name: 'email'
          value: @state.email
          onChange: @handleChange
      React.DOM.div
        className: 'form-group'
        React.DOM.input
          type: 'password'
          className: 'form-control'
          placeholder: 'Password'
          name: 'password'
          value: @state.password
          onChange: @handleChange
      React.DOM.div
        className: 'form-group'
        React.DOM.select
          className: 'form-control'
          name: 'user_type_id'
          onChange: @handleChange
          @optionSet()
      React.DOM.button
        type: 'submit'
        className: 'btn btn-primary'
        disabled: !@valid()
        'Create New User'
      React.DOM.div
        className: 'form-group'
        React.DOM.p null,
          @errorMessage()

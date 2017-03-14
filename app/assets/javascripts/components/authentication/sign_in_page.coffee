@SignInPage = React.createClass
  getInitialState: ->
    email: ''
    password: ''
    error_message: {}
  handleSubmit: (e) ->
    e.preventDefault()
    $.ajax
      method: 'POST'
      url: "/users/sign_in.json"
      dataType: 'JSON'
      data: {user: @state}
      success: (data) =>
        @props.handleUserSignIn data
      error: (data) =>
        @setState error_message: data['responseJSON']
  handleChange: (e) ->
    name = e.target.name
    @setState "#{ name }": e.target.value
  valid: ->
    @state.email && @state.password
  errorMessage: ->
    option = ''
    $.map @state.error_message, (messages, k) ->
      value = ""
      for message in messages
        value = "#{value} #{message}"
      option = "#{option} #{k}: #{value};"
    option
  render: ->
    React.DOM.div
      className: 'sign_in col-md-6 col-md-offset-3'
      React.DOM.form
        onSubmit: @handleSubmit
        React.DOM.div
          className: 'form-group'
          id: 'error_message'
          React.DOM.label null, @errorMessage()
        React.DOM.div
          className: 'form-group'
          React.DOM.input
            type: 'email'
            className: 'form-control email'
            placeholder: 'Email Id'
            name: 'email'
            value: @state.email
            onChange: @handleChange
         React.DOM.div
           className: 'form-group'
           React.DOM.input
             type: 'password'
             className: 'form-control password'
             placeholder: 'Password'
             name: 'password'
             value: @state.password
             onChange: @handleChange
          React.DOM.div
            className: 'form-group text-center'
            React.DOM.button
              type: 'submit'
              className: 'btn btn-primary'
              id: 'submit_button'
              'Login'

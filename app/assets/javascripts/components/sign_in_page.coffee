@SignInPage = React.createClass
  getInitialState: ->
    email: ''
    password: ''
  handleSubmit: (e) ->
    e.preventDefault()
    $.post '/users/sign_in.json', { user: @state }, (data) =>
      @props.handleUserSignIn data
    , 'JSON'
  handleChange: (e) ->
    name = e.target.name
    @setState "#{ name }": e.target.value
  valid: ->
    @state.email && @state.password
  render: ->
    React.DOM.div
      className: 'sign_in col-md-6 col-md-offset-3'
      React.DOM.form
        onSubmit: @handleSubmit
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
            className: 'form-group text-center'
            React.DOM.button
              type: 'submit'
              className: 'btn btn-primary'
              disabled: !@valid()
              'Login'

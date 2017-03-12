@Welcome = React.createClass
  getInitialState: ->
    user_signed_in: @props.user_signed_in
    user_type: @props.user_type
    user_types: @props.user_types
  getDefaultProps: ->
    user_signed_in: false
    user_type: ''
    user_types: {}
  handleSignOut: ->
    @setState user_signed_in: false
  handleSignIn: (user) ->
    @setState user_signed_in: true
    @setState user_type: @props.user_types[user.user_type_id]
  render: ->
    React.DOM.div
      className: 'panel panel-success'
      React.DOM.div
        className: 'panel-heading text-center'
        React.DOM.h2 null,
          'Welcome to Ticketing System'
          if @state.user_signed_in
            React.createElement SignOutPage, handleUserSignOut: @handleSignOut
      React.DOM.div
        className: 'panel-body'
        React.DOM.div
          className: 'welcome'
          if @state.user_signed_in
            if @state.user_type == 'admin'
              React.createElement Users, user_types: @props.user_types
            else
              React.DOM.div
                className: 'after_sign_in_div'
                React.createElement Tickets
                React.DOM.div null, @state.user_type
          else
            React.createElement SignInPage, handleUserSignIn: @handleSignIn

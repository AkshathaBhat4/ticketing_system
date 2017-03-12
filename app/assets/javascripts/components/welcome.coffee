@Welcome = React.createClass
  getInitialState: ->
    user_signed_in: @props.user_signed_in
    tickets: @props.tickets
  handleSignOut: ->
    @setState user_signed_in: false
  handleSignIn: ->
    @setState user_signed_in: true
  render: ->
    React.DOM.div
      className: 'welcome'
      if @state.user_signed_in
        React.DOM.div
          className: 'after_sign_in_div'
          React.createElement SignOutPage, handleUserSignOut: @handleSignOut
          React.createElement Tickets, tickets: @state.tickets
      else
        React.createElement SignInPage, handleUserSignIn: @handleSignIn

@SignOutPage = React.createClass
  handleSignOut: ->
    $.ajax
      url: '/users/sign_out.json'
      method: 'DELETE'
    @props.handleUserSignOut()
  render: ->
    React.DOM.div
      className: 'sign_out pull-right'
      React.DOM.a
        className: 'btn btn-primary'
        onClick: @handleSignOut
        'Sign Out'

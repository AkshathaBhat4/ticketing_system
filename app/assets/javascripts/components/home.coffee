@Home = React.createClass
  getInitialState: ->
    user_signed_in: @props.user_signed_in
    user_type: @props.user_type
    user_types: @props.user_types
    selected_tab: ''
    user_tabs: {}
  getDefaultProps: ->
    user_signed_in: false
    user_type: ''
    user_types: {}
    selected_tab: ''
    user_tabs: {}
  componentDidMount: ->
    @getUserTabs()
  handleSignOut: ->
    @setState user_signed_in: false
  handleSignIn: (user) ->
    @setState user_signed_in: true
    @setState user_type: @props.user_types[user.user_type_id]
    @getUserTabs()
  getUserTabs: ->
    $.get "/users/get_user_tabs", (data) =>
      @setState user_tabs: data
      @setState selected_tab: Object.keys(@state.user_tabs)[0]
  tabClicked: (e) ->
    name = e.target.name
    @setState selected_tab: name
  userTabs: ->
    tabs = $.map @state.user_tabs, (value, name) =>
      React.DOM.a
        className: 'btn btn-default'
        key: name
        name: name
        onClick: @tabClicked
        "#{value}"
    tabs
  adminBlock: ->
    React.DOM.div
      className: 'row'
      if @state.selected_tab == 'tickets'
        React.createElement Tickets
      else
        React.createElement Users, user_types: @props.user_types
  userBlock: ->
    React.DOM.div
      className: 'row'
      if @state.selected_tab == 'tickets'
        React.createElement Tickets
      else if @state.selected_tab == 'users'
        React.createElement Users, user_types: @props.user_typess
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
            React.DOM.div null,
              React.DOM.div
                className: 'row'
                @userTabs()
              React.DOM.div
                className: 'row'
                React.DOM.hr
                  className: 'tabbed_hr'
              @userBlock()
          else
            React.createElement SignInPage, handleUserSignIn: @handleSignIn

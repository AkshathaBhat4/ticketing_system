@Tickets = React.createClass
  getInitialState: ->
    tickets: @props.tickets
    user_type: @props.user_type
    allowed_states: {}
    all_states: {}
  getDefaultProps: ->
    tickets: []
    allowed_states: {}
    all_states: {}
  componentDidMount: ->
    $.get "/tickets", (data) =>
      @setState tickets: data
    $.get "/users/allowed_states", (data) =>
      @setState allowed_states: data
    $.get "/users/all_states", (data) =>
      @setState all_states: data
  newTicket: (ticket)->
    tickets = React.addons.update(@state.tickets, { $push: [ticket] })
    @setState tickets: tickets
  replaceTicket: (tickets) ->
    @setState tickets: tickets
  updateTicket: (ticket, data) ->
    index = @state.tickets.indexOf ticket
    tickets = React.addons.update(@state.tickets, { $splice: [[index, 1, data]] })
    @setState tickets: tickets
  render: ->
    React.DOM.div
      className: 'tickets col-xs-12'
      React.DOM.div
        className: 'row'
        if (@state.user_type == 'admin' or @state.user_type == 'agent')
          React.createElement DownloadTickets
        React.createElement SearchBlock, all_states: @state.all_states, handleReplaceTicket: @replaceTicket
      React.DOM.div
        className: 'row'
        React.DOM.br null
        React.DOM.table
          className: 'table table-bordered'
          React.DOM.thead null,
            React.DOM.tr null,
              React.DOM.th null, 'Name'
              React.DOM.th null, 'Description'
              React.DOM.th null, 'Customer Name'
              React.DOM.th null, 'Agent Name'
              React.DOM.th null, 'Status'
              React.DOM.th null, 'Actions'
          React.DOM.tbody null,
            for ticket in @state.tickets
              React.createElement Ticket, key: ticket.id, ticket: ticket, allowed_states: @state.allowed_states, handleUpdateTicket: @updateTicket, handleEditTicket: @updateTicket

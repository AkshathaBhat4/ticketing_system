@Ticket = React.createClass
  getInitialState: ->
    ticket: @props.ticket
  handleChange: (e)->
    e.preventDefault()
    name = e.target.name
    $.ajax
      method: 'PUT'
      url: "/tickets/change_state"
      data:
        id: @props.ticket.id
        state: name
      dataType: 'JSON'
      success: (data) =>
        @props.handleUpdateTicket @props.ticket, data
  ticketActions: ->
    actions = $.map @props.allowed_states, (value, name) =>
      React.DOM.a
        className: 'btn btn-default'
        key: name
        name: name
        onClick: @handleChange
        "#{value}"
    actions
  getName: (type) ->
    if @props.ticket[type]
      @props.ticket[type]['name']
    else
      ''
  ticketRow: ->
    React.DOM.tr null,
      React.DOM.td null, @props.ticket.name
      React.DOM.td null, @props.ticket.description
      React.DOM.td null, @getName('customer')
      React.DOM.td null, @getName('agent')
      React.DOM.td null, @getName('state')
      React.DOM.td null,
        @ticketActions()
  render: ->
    @ticketRow()

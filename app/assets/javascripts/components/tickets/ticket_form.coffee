@TicketForm = React.createClass
  getInitialState: ->
    name: ''
    description: ''
    error_message: {}
  handleSubmit: (e) ->
    e.preventDefault()
    $.ajax
      method: 'POST'
      url: "/tickets"
      dataType: 'JSON'
      data: {ticket: @state}
      success: (data) =>
        @props.handleNewTicket data
        # @setState @getInitialState()
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
  valid: ->
    @state.name && @state.description
  render: ->
    React.DOM.form
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
        React.DOM.textarea
          className: 'form-control'
          placeholder: 'Description'
          name: 'description'
          value: @state.description
          onChange: @handleChange
      React.DOM.button
        type: 'submit'
        className: 'btn btn-primary'
        disabled: !@valid()
        'Submit Ticket'
      React.DOM.div
        className: 'form-group'
        React.DOM.p null,
          @errorMessage()

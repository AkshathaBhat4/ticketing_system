@SearchBlock = React.createClass
  getInitialState: ->
    all_states: @props.all_states
    state: ''
  handleSubmit: (e) ->
    e.preventDefault()
    data =
      state: $('select[name=state]').val()
    $.ajax
      method: 'GET'
      url: "/tickets"
      dataType: 'JSON'
      data: data
      success: (data) =>
        @props.handleReplaceTicket data
  handleChange: (e) ->
    name = e.target.name
    @setState "#{ name }": e.target.value
  optionSet: ->
    option = for name in @props.all_states
      React.DOM.option
        key: "option_#{name}"
        value: name
        "#{name}"
    option
  render: ->
    React.DOM.form
      className: 'form-inline'
      onSubmit: @handleSubmit
      React.DOM.div
        className: 'form-group'
        React.DOM.select
          className: 'form-control'
          name: 'state'
          onChange: @handleChange
          @optionSet()
      React.DOM.button
        type: 'submit'
        className: 'btn btn-primary'
        'Search'

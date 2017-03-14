TestUtils = React.addons.TestUtils
describe 'Add New Ticket Form', ->
  it "Display Add New Ticket Form Block", ->
    @result = TestUtils.renderIntoDocument(React.createElement(TicketForm))
    form = TestUtils.findRenderedDOMComponentWithTag(@result, "form")
    expect(form).toBeDefined()

    input_box = TestUtils.findRenderedDOMComponentWithTag(@result, "input")
    expect(input_box).toBeDefined()

    textarea = TestUtils.findRenderedDOMComponentWithTag(@result, "textarea")
    expect(textarea).toBeDefined()

    button = TestUtils.findRenderedDOMComponentWithTag(@result, "button")
    expect(button).toBeDefined()

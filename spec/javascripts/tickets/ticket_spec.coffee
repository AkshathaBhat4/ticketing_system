TestUtils = React.addons.TestUtils
describe 'Ticket', ->
  beforeEach ->
    @props =
      ticket: {"id":5,"name":"Test Ticket 2","description":"Test Ticket 2 Description","customer":{"name":"Customer"},"state":{"name":"close"},"agent":{"name":"Customer 5"}}
      allowed_states: {"inprogress":"Inprogress","close":"Close","delete":"Delete"}
    @result = TestUtils.renderIntoDocument(React.createElement(Ticket, @props))

  it "Validate Ticket Action Buttons", ->
    action_buttons = TestUtils.scryRenderedDOMComponentsWithTag(@result, "a")
    expect(action_buttons).toBeDefined()
    expect(action_buttons.length).toEqual(3)

    expect(action_buttons[0].textContent).toContain("Inprogress")
    expect(action_buttons[1].textContent).toContain("Close")
    expect(action_buttons[2].textContent).toContain("Delete")

  it "Display Ticket Block", ->
    expect(TestUtils.findRenderedDOMComponentWithTag(@result, "tr")).toBeDefined()
    expect(TestUtils.findRenderedDOMComponentWithTag(@result, "tr")).not.toEqual([ ])

  it "Validate Ticket Content", ->
    table_blocks = TestUtils.scryRenderedDOMComponentsWithTag(@result, "td")
    expect(table_blocks).toBeDefined()
    expect(table_blocks.length).toEqual(6)
    expect(table_blocks[0].textContent).toContain(@result.state.ticket.name)
    expect(table_blocks[1].textContent).toContain(@result.state.ticket.description)
    expect(table_blocks[2].textContent).toContain(@result.state.ticket.customer.name)
    expect(table_blocks[3].textContent).toContain(@result.state.ticket.agent.name)
    expect(table_blocks[4].textContent).toContain(@result.state.ticket.state.name)

TestUtils = React.addons.TestUtils
describe 'Add New User Form', ->
  it "Display Add New User Form Block", ->
    @props =
      user_types:
        1: 'admin'
        2: 'agent'
        3: 'customer'
    @result = TestUtils.renderIntoDocument(React.createElement(UserForm, @props))
    form = TestUtils.findRenderedDOMComponentWithTag(@result, "form")
    expect(form).toBeDefined()

    input_blocks = TestUtils.scryRenderedDOMComponentsWithTag(@result, "input")
    expect(input_blocks).toBeDefined()
    expect(input_blocks.length).toEqual(3)

    select_blocks = TestUtils.scryRenderedDOMComponentsWithTag(@result, "select")
    expect(select_blocks).toBeDefined()
    expect(select_blocks.length).toEqual(1)

    option_blocks = TestUtils.scryRenderedDOMComponentsWithTag(@result, "option")
    expect(option_blocks).toBeDefined()
    expect(option_blocks.length).toEqual(3)

    button = TestUtils.findRenderedDOMComponentWithTag(@result, "button")
    expect(button).toBeDefined()

TestUtils = React.addons.TestUtils
describe 'User', ->
  beforeEach ->
    @props =
      edit: false
      user: {"id":7,"email":"customer6@gmail.com","user_type_id":2,"name":"Agent 6","user_type":{"name":"agent"}}
      error_message: {}
      user_types:
        1: 'admin'
        2: 'agent'
        3: 'customer'
    @result = TestUtils.renderIntoDocument(React.createElement(User, @props))

  describe 'Display User', ->
    beforeEach ->
      @result.setState(edit: false)

    it "Validate User Action Buttons", ->
      action_buttons = TestUtils.scryRenderedDOMComponentsWithTag(@result, "a")
      expect(action_buttons).toBeDefined()
      expect(action_buttons.length).toEqual(2)

      expect(action_buttons[0].textContent).toContain("Edit")
      expect(action_buttons[1].textContent).toContain("Delete")

    it "Validate User Content", ->
      table_blocks = TestUtils.scryRenderedDOMComponentsWithTag(@result, "td")
      expect(table_blocks).toBeDefined()
      expect(table_blocks.length).toEqual(5)
      expect(table_blocks[0].textContent).toContain(@props.user.name)
      expect(table_blocks[1].textContent).toContain(@props.user.email)
      expect(table_blocks[3].textContent).toContain(@props.user.user_type.name)

  describe 'Edit User', ->
    beforeEach ->
      @result.setState(edit: true)

    it "Validate User Action Buttons", ->
      action_buttons = TestUtils.scryRenderedDOMComponentsWithTag(@result, "a")
      expect(action_buttons).toBeDefined()
      expect(action_buttons.length).toEqual(2)

      expect(action_buttons[0].textContent).toContain("Update")
      expect(action_buttons[1].textContent).toContain("Cancel")

    it "Validate User Form", ->
      table_blocks = TestUtils.scryRenderedDOMComponentsWithTag(@result, "td")
      expect(table_blocks).toBeDefined()
      expect(table_blocks.length).toEqual(5)

      input_blocks = TestUtils.scryRenderedDOMComponentsWithTag(@result, "input")
      expect(input_blocks).toBeDefined()
      expect(input_blocks.length).toEqual(3)

      select_blocks = TestUtils.scryRenderedDOMComponentsWithTag(@result, "select")
      expect(select_blocks).toBeDefined()
      expect(select_blocks.length).toEqual(1)

      option_blocks = TestUtils.scryRenderedDOMComponentsWithTag(@result, "option")
      expect(option_blocks).toBeDefined()
      expect(option_blocks.length).toEqual(3)

  it "Display User Block", ->
    expect(TestUtils.findRenderedDOMComponentWithTag(@result, "tr")).toBeDefined()
    expect(TestUtils.findRenderedDOMComponentWithTag(@result, "tr")).not.toEqual([ ])

TestUtils = React.addons.TestUtils
describe 'Search Block', ->
  it "Display Search Block Contents", ->
    @props =
      all_states: ["all","new","inprogress","close","delete"]
    @result = TestUtils.renderIntoDocument(React.createElement(SearchBlock, @props))
    expect(TestUtils.findRenderedDOMComponentWithTag(@result, "select")).toBeDefined()
    expect(TestUtils.findRenderedDOMComponentWithTag(@result, "select")).not.toEqual([ ])
    option_block = TestUtils.scryRenderedDOMComponentsWithTag(@result, "option")
    expect(option_block).toBeDefined()
    expect(option_block.length).toEqual(@props.all_states.length)
    expect(TestUtils.findRenderedDOMComponentWithTag(@result, "button")).toBeDefined()
    expect(TestUtils.findRenderedDOMComponentWithTag(@result, "button")).not.toEqual([ ])

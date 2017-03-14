TestUtils = React.addons.TestUtils
describe 'Users', ->
  beforeEach ->
    @props =
      users: [
        {"id":7,"email":"customer6@gmail.com","user_type_id":2,"name":"Agent 6","user_type":{"name":"agent"}},
        {"id":13,"email":"customer5@gmail.com","user_type_id":2,"name":"Customer 5","user_type":{"name":"agent"}}
      ]
      user_types:
        1: 'admin'
        2: 'agent'
        3: 'customer'
    @result = TestUtils.renderIntoDocument(React.createElement(Users, @props))

  it "Display Users Page", ->
    expect(TestUtils.findRenderedDOMComponentWithClass(@result, "users")).toBeDefined()
  it "List All Users Block Displayed", ->
    expect(TestUtils.findRenderedDOMComponentWithTag(@result, "table")).toBeDefined()
    expect(TestUtils.scryRenderedComponentsWithType(@result, User)).toBeDefined()
    expect(TestUtils.scryRenderedComponentsWithType(@result, User)).not.toEqual([ ])
  it "Display Create New User Block", ->
    expect(TestUtils.scryRenderedComponentsWithType(@result, UserForm)).toBeDefined()
    expect(TestUtils.scryRenderedComponentsWithType(@result, UserForm)).not.toEqual([ ])

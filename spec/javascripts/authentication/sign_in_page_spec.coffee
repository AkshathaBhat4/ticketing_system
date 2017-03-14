TestUtils = React.addons.TestUtils
describe 'Sign In Page', ->
  beforeEach ->
    @props =
      email: 'sdfdfss@dgdfbd.dfdg'
      password: 'sdfdgdgdg'
      error_message: {}
    @submitHandler = jasmine.createSpy "submitHandler"
    @result = TestUtils.renderIntoDocument(React.createElement(SignInPage, handleSubmit: @submitHandler))
  it "Display Sign In Page", ->
    expect(ReactDOM.findDOMNode(@result).textContent).toContain('Login')
    expect(@result).toBeDefined()
  it "Display Sign In Form Elements", ->
    expect(TestUtils.findRenderedDOMComponentWithTag(@result, "form")).toBeDefined()
    expect(TestUtils.findRenderedDOMComponentWithClass(@result, "email")).toBeDefined()
    expect(TestUtils.findRenderedDOMComponentWithClass(@result, "password")).toBeDefined()
    expect(TestUtils.findRenderedDOMComponentWithTag(@result, "button")).toBeDefined()
    expect(TestUtils.findRenderedDOMComponentWithTag(@result, "label")).toBeDefined()

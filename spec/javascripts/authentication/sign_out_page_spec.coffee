TestUtils = React.addons.TestUtils
describe 'Sign Out Page', ->
  it "Display Sign Out Button", ->
    @result = TestUtils.renderIntoDocument(React.createElement(SignOutPage))
    download_button = TestUtils.findRenderedDOMComponentWithTag(@result, "a")
    expect(download_button).toBeDefined()
    expect(download_button).not.toEqual([ ])
    expect(download_button.textContent).toContain("Sign Out")

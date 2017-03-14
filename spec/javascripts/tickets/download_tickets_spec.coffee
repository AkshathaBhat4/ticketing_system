TestUtils = React.addons.TestUtils
describe 'Download Tickets', ->
  it "Generate Monthly Report (Closed) Block Contents", ->
    @result = TestUtils.renderIntoDocument(React.createElement(DownloadTickets))
    download_button = TestUtils.findRenderedDOMComponentWithTag(@result, "a")
    expect(download_button).toBeDefined()
    expect(download_button).not.toEqual([ ])
    expect(download_button.textContent).toContain("Generate Monthly Report (Closed)")

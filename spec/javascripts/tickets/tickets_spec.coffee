TestUtils = React.addons.TestUtils
describe 'Tickets', ->
  describe 'Admin Login', ->
    beforeEach ->
      @props =
        user_type: 'admin'
        tickets: [
          {"id":5,"name":"Test Ticket 2","description":"Test Ticket 2 Description","customer":{"name":"Customer"},"state":{"name":"close"},"agent":{"name":"Customer 5"}}
        ]
      @result = TestUtils.renderIntoDocument(React.createElement(Tickets, @props))
    it "Display Ticket Page", ->
      expect(TestUtils.findRenderedDOMComponentWithClass(@result, "tickets")).toBeDefined()
    it "List All Tickets Block Displayed", ->
      expect(TestUtils.findRenderedDOMComponentWithTag(@result, "table")).toBeDefined()
      expect(TestUtils.scryRenderedComponentsWithType(@result, Ticket)).toBeDefined()
      expect(TestUtils.scryRenderedComponentsWithType(@result, Ticket)).not.toEqual([ ])
    it "Display Generate Monthly Report (Closed) Block", ->
      expect(TestUtils.scryRenderedComponentsWithType(@result, DownloadTickets)).toBeDefined()
      expect(TestUtils.scryRenderedComponentsWithType(@result, DownloadTickets)).not.toEqual([ ])
    it "Display Search Block", ->
      expect(TestUtils.scryRenderedComponentsWithType(@result, SearchBlock)).toBeDefined()
      expect(TestUtils.scryRenderedComponentsWithType(@result, SearchBlock)).not.toEqual([ ])

  describe 'Agent Login', ->
    beforeEach ->
      @props =
        user_type: 'agent'
        tickets: [
          {"id":5,"name":"Test Ticket 2","description":"Test Ticket 2 Description","customer":{"name":"Customer"},"state":{"name":"close"},"agent":{"name":"Customer 5"}}
        ]
      @result = TestUtils.renderIntoDocument(React.createElement(Tickets, @props))
    it "Display Ticket Page", ->
      expect(TestUtils.findRenderedDOMComponentWithClass(@result, "tickets")).toBeDefined()
    it "List All Tickets Block Displayed", ->
      expect(TestUtils.findRenderedDOMComponentWithTag(@result, "table")).toBeDefined()
      expect(TestUtils.scryRenderedComponentsWithType(@result, Ticket)).toBeDefined()
      expect(TestUtils.scryRenderedComponentsWithType(@result, Ticket)).not.toEqual([ ])
    it "Display Generate Monthly Report (Closed) Block", ->
      expect(TestUtils.scryRenderedComponentsWithType(@result, DownloadTickets)).toBeDefined()
      expect(TestUtils.scryRenderedComponentsWithType(@result, DownloadTickets)).not.toEqual([ ])
    it "Display Search Block", ->
      expect(TestUtils.scryRenderedComponentsWithType(@result, SearchBlock)).toBeDefined()
      expect(TestUtils.scryRenderedComponentsWithType(@result, SearchBlock)).not.toEqual([ ])

  describe 'Customer Login', ->
    beforeEach ->
      @props =
        user_type: 'customer'
        tickets: [
          {"id":5,"name":"Test Ticket 2","description":"Test Ticket 2 Description","customer":{"name":"Customer"},"state":{"name":"close"},"agent":{"name":"Customer 5"}}
        ]
      @result = TestUtils.renderIntoDocument(React.createElement(Tickets, @props))
    it "Display Ticket Page", ->
      expect(TestUtils.findRenderedDOMComponentWithClass(@result, "tickets")).toBeDefined()
    it "List All Tickets Block Displayed", ->
      expect(TestUtils.findRenderedDOMComponentWithTag(@result, "table")).toBeDefined()
      expect(TestUtils.scryRenderedComponentsWithType(@result, Ticket)).toBeDefined()
      expect(TestUtils.scryRenderedComponentsWithType(@result, Ticket)).not.toEqual([ ])
    it "Not To Display Generate Monthly Report (Closed) Block", ->
      expect(TestUtils.scryRenderedComponentsWithType(@result, DownloadTickets)).toBeDefined()
      expect(TestUtils.scryRenderedComponentsWithType(@result, DownloadTickets)).toEqual([ ])
    it "Display Search Block", ->
      expect(TestUtils.scryRenderedComponentsWithType(@result, SearchBlock)).toBeDefined()
      expect(TestUtils.scryRenderedComponentsWithType(@result, SearchBlock)).not.toEqual([ ])

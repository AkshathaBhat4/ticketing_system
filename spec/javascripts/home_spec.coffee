TestUtils = React.addons.TestUtils
describe 'Home', ->
  beforeEach ->
    @props =
      user_signed_in: false
      tickets: []
      user_type: ''
      user_types:
        1: 'admin'
        2: 'agent'
        3: 'customer'
    @result = TestUtils.renderIntoDocument(React.createElement(Home, @props))
  describe 'User Not Logged In', ->
    it "Display Login Screen", ->
      expect(TestUtils.scryRenderedComponentsWithType(@result, SignInPage)).toBeDefined()
      expect(TestUtils.scryRenderedComponentsWithType(@result, SignInPage)).not.toEqual([ ])
    it "Do Not Display Tickets Screen", ->
      expect(TestUtils.scryRenderedComponentsWithType(@result, Tickets)).toBeDefined()
      expect(TestUtils.scryRenderedComponentsWithType(@result, Tickets)).toEqual([ ])
    it "Do Not Display Users Screen", ->
      expect(TestUtils.scryRenderedComponentsWithType(@result, Users)).toBeDefined()
      expect(TestUtils.scryRenderedComponentsWithType(@result, Users)).toEqual([ ])
    it "Do Not Display Sign Out Button Screen", ->
      expect(TestUtils.scryRenderedComponentsWithType(@result, SignOutPage)).toBeDefined()
      expect(TestUtils.scryRenderedComponentsWithType(@result, SignOutPage)).toEqual([ ])
    it "Do Not Display Tabs Block", ->
      result = TestUtils.renderIntoDocument(React.createElement(Home, @props))
      tab_block = TestUtils.scryRenderedDOMComponentsWithClass(@result, 'tabs')
      expect(tab_block).toBeDefined()
      expect(tab_block).toEqual([ ])
  describe 'User Logged In', ->
    beforeEach ->
      @result.setState(user_signed_in: true)
    describe 'Admin User', ->
      beforeEach ->
        @result.setState(user_type: 'admin')
      it "Display Admin Tabs", ->
        @result.setState(user_tabs: {"users":"Manage Users","tickets":"Manage Tickets", 'new_ticket': 'Raise Ticket'})
        tabs = TestUtils.scryRenderedDOMComponentsWithClass(@result, 'tab')
        expect(tabs).toBeDefined()
        expect(tabs.length).toEqual(3)
        expect(tabs[0].textContent).toEqual("Manage Users")
        expect(tabs[1].textContent).toEqual("Manage Tickets")
        expect(tabs[2].textContent).toEqual("Raise Ticket")
      it "Display Manage Users Page", ->
        @result.setState(selected_tab: "users")
        expect(TestUtils.scryRenderedComponentsWithType(@result, Users)).toBeDefined()
        expect(TestUtils.scryRenderedComponentsWithType(@result, Users)).not.toEqual([ ])

      it "Display Manage Tickets Page", ->
        @result.setState(selected_tab: "tickets")
        @result.setState(selected_tab: "tickets")
        expect(TestUtils.scryRenderedComponentsWithType(@result, Tickets)).toBeDefined()
        expect(TestUtils.scryRenderedComponentsWithType(@result, Tickets)).not.toEqual([ ])

    describe 'Agent User', ->
      beforeEach ->
        @result.setState(user_type: 'agent')
      it "Display Agent Tabs", ->
        @result.setState(user_tabs: {"tickets":"Manage Tickets"})
        tabs = TestUtils.scryRenderedDOMComponentsWithClass(@result, 'tab')
        expect(tabs).toBeDefined()
        expect(tabs.length).toEqual(1)
        expect(tabs[0].textContent).toEqual("Manage Tickets")

      it "Display Manage Tickets Page", ->
        @result.setState(selected_tab: "tickets")
        @result.setState(selected_tab: "tickets")
        expect(TestUtils.scryRenderedComponentsWithType(@result, Tickets)).toBeDefined()
        expect(TestUtils.scryRenderedComponentsWithType(@result, Tickets)).not.toEqual([ ])
    describe 'Customer User', ->
      beforeEach ->
        @result.setState(user_type: 'customer')
      it "Display Customer Tabs", ->
        @result.setState(user_tabs: {"tickets":"Manage Tickets","new_ticket":"Raise Ticket"})
        tabs = TestUtils.scryRenderedDOMComponentsWithClass(@result, 'tab')
        expect(tabs).toBeDefined()
        expect(tabs.length).toEqual(2)
        expect(tabs[0].textContent).toEqual("Manage Tickets")
        expect(tabs[1].textContent).toEqual("Raise Ticket")

      it "Display Manage Tickets Page", ->
        @result.setState(selected_tab: "tickets")
        @result.setState(selected_tab: "tickets")
        expect(TestUtils.scryRenderedComponentsWithType(@result, Tickets)).toBeDefined()
        expect(TestUtils.scryRenderedComponentsWithType(@result, Tickets)).not.toEqual([ ])

      it "Display Add New Ticket Form", ->
        @result.setState(selected_tab: "new_ticket")
        expect(TestUtils.scryRenderedComponentsWithType(@result, TicketForm)).toBeDefined()
        expect(TestUtils.scryRenderedComponentsWithType(@result, TicketForm)).not.toEqual([ ])

    it "Display Sign Out Button", ->
      result = TestUtils.renderIntoDocument(React.createElement(Home, @props))
      expect(TestUtils.scryRenderedComponentsWithType(@result, SignOutPage)).toBeDefined()
      expect(TestUtils.scryRenderedComponentsWithType(@result, SignOutPage)).not.toEqual([ ])
    it "Display Tabs Block", ->
      result = TestUtils.renderIntoDocument(React.createElement(Home, @props))
      expect(TestUtils.scryRenderedDOMComponentsWithClass(@result, 'tabs')).toBeDefined()
      expect(TestUtils.scryRenderedDOMComponentsWithClass(@result, 'tabs')).not.toEqual([ ])
  it "Display Home Screen", ->
    expect(ReactDOM.findDOMNode(@result).textContent).toContain('Welcome to Ticketing System')

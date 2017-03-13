@DownloadTickets = React.createClass
  downloadPdf: (e)->
    e.preventDefault()
    $.ajax
      method: 'POST'
      url: "/tickets/generate_report"
      data: {}
      dataType: 'text'
      success: (res) =>
        data = new Blob([res], {type: 'text/pdf'})
        csvURL = window.URL.createObjectURL(data)
        tempLink = document.createElement('a')
        tempLink.href = csvURL
        tempLink.setAttribute('download', 'monthly_report.pdf')
        tempLink.click()
  render: ->
    React.DOM.div
      className: 'pull-right'
      React.DOM.a
        className: 'btn btn-default pull-right'
        onClick: @downloadPdf
        "Generate Monthly Report (Closed)"

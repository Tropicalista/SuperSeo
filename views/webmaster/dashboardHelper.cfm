<cfoutput>

    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script type="text/javascript">

      // Load the Visualization API and the piechart package.
      google.load('visualization', '1.0', {'packages':['corechart','table']});

      // Set a callback to run when the Google Visualization API is loaded.
      google.setOnLoadCallback(getReport);

      var data = {
            startDate: '#DateFormat(DateAdd( "d", -60, Now()), "YYYY-MM-DD" )#',
            endDate: '#DateFormat(Now(),"YYYY-MM-DD")#',
            dimensions: ["date"],
            site: '#prc.settings.site#'
          }

      function getReport(){
        $.ajax({
          url: "#prc.CBHelper.buildModuleLink('superSeo', 'wmt.query')#",
          data: data,
          //contentType: 'application/json',
          dataType: 'json',
          type: 'POST'
        }).done(function(data) {
          drawChart(data);
          getTopKeys();
        });
      }

      function getTopKeys(){
        $.ajax({
          url: "#prc.CBHelper.buildModuleLink('superSeo', 'wmt.query')#",
          dataType: 'json',
          type: 'POST',
          data: {
            startDate: '#DateFormat(DateAdd( "d", -60, Now()), "YYYY-MM-DD" )#',
            endDate: '#DateFormat(Now(),"YYYY-MM-DD")#',
            dimensions: ["query"],
            site: '#prc.settings.site#'
          },
        }).done(function(data) {
          drawTable(data);
        });
      }

      // Callback that creates and populates a data table,
      // instantiates the pie chart, passes in the data and
      // draws it.
      function drawChart(result) {

        // Create the data table.
        var data = new google.visualization.DataTable();
        data.addColumn('string', 'Keys');
        data.addColumn('number', 'Clicks');
        data.addColumn('number', 'Impressions');
        data.addColumn('number', 'CTR');
        data.addColumn('number', 'Position');

        //data.addRows(result.rows);
        for (var i=0; i<result.rows.length; i++) {
          var row = result.rows[i];
          data.addRow([row.keys[0],parseInt(row.clicks),parseInt(row.impressions),
              row.ctr,parseInt(row.position)]);
          //data.addRow([row.keys[0],parseInt(row.position)]);
        }

        // Set chart options
        var options = {
            focusTarget: 'category',
            //aggregationTarget: 'category',
            selectionMode: 'multiple',
            hAxis: {
                textPosition: 'none'
            },
            vAxes: {
              0: {direction: -1},
              1: {logScale: false, maxValue: 2},
              2: { 
                  format: '##%',
                  baselineColor: '##fff',
                  textPosition: 'none'                
              }
            },

            series: {
                0: { type: "line", targetAxisIndex: 1 },
                1: { type: "line", targetAxisIndex: 1 },
                2: { type: "line", targetAxisIndex: 2 },
                3: { type: "line", targetAxisIndex: 0 }
            },
            height: 300
        }

        // Instantiate and draw our chart, passing in some options.
        var chart = new google.visualization.LineChart(document.getElementById('chart'));
        chart.draw(data, options);
      }

      function drawTable(result){
        var data = new google.visualization.DataTable();
        data.addColumn('string', 'Query');
        data.addColumn('number', 'Clicks');
        data.addColumn('number', 'Impressions');
        data.addColumn('number', 'CTR');
        data.addColumn('number', 'Position');
        for (var i=0; i<result.rows.length; i++) {
          var row = result.rows[i];
          data.addRow([row.keys[0],parseInt(row.clicks),parseInt(row.impressions),
              row.ctr,parseInt(row.position)]);
        }

        var table = new google.visualization.Table(document.getElementById('query'));
        table.draw(data, {showRowNumber: false, width: '100%', height: '100%'});

      }

    </script>

</cfoutput>
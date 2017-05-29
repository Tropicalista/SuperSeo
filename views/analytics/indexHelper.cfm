<script>
(function(w,d,s,g,js,fs){
  g=w.gapi||(w.gapi={});g.analytics={q:[],ready:function(f){this.q.push(f);}};
  js=d.createElement(s);fs=d.getElementsByTagName(s)[0];
  js.src='https://apis.google.com/js/platform.js';
  fs.parentNode.insertBefore(js,fs);js.onload=function(){g.load('analytics');};
}(window,document,'script'));
</script>

<cfoutput>
<script>

gapi.analytics.ready(function() {

  /**
   * Authorize the user with an access token obtained server side.
   */
  gapi.analytics.auth.authorize({
    'serverAuth': {
      'access_token': '#prc.accessToken#'
    }
  });


  /**
   * Creates a new DataChart instance showing sessions over the past 30 days.
   * It will be rendered inside an element with the id "chart-1-container".
   */
  var dataChart1 = new gapi.analytics.googleCharts.DataChart({
    query: {
      'ids': 'ga:#prc.settings.analyticsView#', // The Demos & Tools website view.
      'start-date': '30daysAgo',
      'end-date': 'yesterday',
      'metrics': 'ga:sessions,ga:users',
      'dimensions': 'ga:date'
    },
    chart: {
      'container': 'chart-1-container',
      'type': 'LINE',
      'options': {
        'width': '100%'
      }
    }
  });
  dataChart1.execute();


  /**
   * Creates a new DataChart instance showing top 5 most popular demos/tools
   * amongst returning users only.
   * It will be rendered inside an element with the id "chart-3-container".
   */
  var dataChart2 = new gapi.analytics.googleCharts.DataChart({
    query: {
      'ids': 'ga:#prc.settings.analyticsView#', // The Demos & Tools website view.
      'dimensions': 'ga:browser',
      'metrics': 'ga:pageviews',
      'sort': '-ga:pageviews',
      'max-results': 5
    },
    chart: {
      'container': 'chart-2-container',
      'type': 'PIE',
      'options': {
        'width': '100%',
        'pieHole': 4/9,
      }
    }
  });
  dataChart2.execute();

  /**
   * Create a new DataChart for top countries over the past 30 days.
   * It will be rendered inside an element with the id "chart-1-container".
   */
  var dataChart3 = new gapi.analytics.googleCharts.DataChart({
    query: {
      'metrics': 'ga:sessions',
      'dimensions': 'ga:country',
      'ids': 'ga:#prc.settings.analyticsView#', // The Demos & Tools website view.
      'start-date': '30daysAgo',
      'end-date': 'yesterday',
      'max-results': 6,
      sort: '-ga:sessions'
    },
    chart: {
      container: 'chart-3-container',
      type: 'PIE',
      options: {
        width: '100%',
        pieHole: 4/9
      }
    }
  });
  dataChart3.execute();

  var geo = new gapi.analytics.googleCharts.DataChart({
    query: {
    'ids': 'ga:#prc.settings.analyticsView#',
      'start-date': '30daysAgo',
      'end-date': 'yesterday',
      'dimensions': 'ga:country',
      'metrics': 'ga:users',
    },
    chart: {
      type: 'GEO',
      container: 'chart-geo'
    }
  });
  geo.execute();

});
</script>

</cfoutput>
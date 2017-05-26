/**
* A normal ColdBox Event Handler
*/
component{

	property name="settingService"	inject="SettingService@cb";
	property name="jLoader" inject="loader@cbjavaloader";
	property name="s" inject="Google@SuperSeo";
	property name="a" inject="Analytics@SuperSeo";
	property name="g" inject="SearchConsole@SuperSeo";

	public function preHandler( event, action, eventArguments ) {


    g.loadWMT();
    a.loadAnalytics();

    dump(g.getToken());
    g.loadWMT();
    dump(g.getToken());

		var wmt = g.loadWMT();

		c = wmt.sites().list().execute();
		dump(c);

		v = wmt.urlcrawlerrorscounts().query("https://www.piccoloprestitoinpdap.net").execute();
dump(v);
    
    query = jLoader.create("com.google.api.services.webmasters.model.SearchAnalyticsQueryRequest");


    query.setStartDate("2017-01-01")
    query.setEndDate("2017-05-01")
    query.setDimensions(['date'])

    c = wmt.searchanalytics().query("https://www.piccoloprestitoinpdap.net/",query).execute()
    dump(c);
		abort;
	}

	function index(event,rc,prc){

		prc.settings = deserializeJSON( settingService.getSetting( "cbox-super-seo" ) );
		event.setView( "settings" );

	}

	function dashboard(event,rc,prc){

		prc.settings = deserializeJSON( settingService.getSetting( "cbox-super-seo" ) );
		event.setView( "webmaster/dashboard" );

	}

	function saveSettings(event,rc,prc){

		var args = { name="cbox-super-seo" };
		prc.settings = settingService.findWhere( criteria=args );

		prc.settings.setValue( serializeJSON(rc.seo) );
		settingService.save( prc.settings );
		settingService.flushSettingsCache();

		setNextEvent('cbadmin.module.SuperSeo.home');

	}

}
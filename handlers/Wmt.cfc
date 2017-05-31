/**
* A normal ColdBox Event Handler
*/
component{

	this.prehandler_only = "index,queryErrorCount,queryErrorSample,sitemaps";

	property name="wmt" inject="SearchConsole@SuperSeo";
	property name="settingService"	inject="SettingService@cb";

	public function preHandler( event, action, eventArguments ) {

		prc.settings = deserializeJSON( settingService.getSetting( "cbox-super-seo" ) );
		if( !wmt.isFileUploaded() ){
			setNextEvent( 'cbadmin.module.SuperSeo.wmt.settings' );
		}
	    wmt.loadwmt();
	    prc.accessToken = wmt.getToken();

	}

	function index(event,rc,prc){

		if( !structKeyExists( prc.settings, 'site' ) ){
			setNextEvent( 'cbadmin.module.SuperSeo.wmt.settings' );
		}
		event.setView( "webmaster/dashboard" );

	}

	function query(){

		var result = wmt.searchAnalytics( argumentCollection = rc );
		var result = serializeJSON(result.response);

		event.renderData( data=result, contentType="application/json" );

	}

	function queryErrorCount(event,rc,prc){

		prc.errors = wmt.queryErrorCount(prc.settings.site).countPerTypes;

		event.setView( "webmaster/errors" );

	}

	function queryErrorSample(event,rc,prc){

		prc.errorSample = wmt.queryErrorSample( prc.settings.site, rc.category, rc.platform ).urlCrawlErrorSample;

		event.setView( "webmaster/errorSample" );

	}

	function sitemaps(event,rc,prc){

		var sitemaps = wmt.sitemaps( prc.settings.site ).sitemap.toString();

		prc.sitemaps = deserializeJSON(sitemaps);

		event.setView( "webmaster/sitemaps" );

	}

	function settings(event,rc,prc){

		prc.settings = deserializeJSON( settingService.getSetting( "cbox-super-seo" ) );

		if( !wmt.isFileUploaded() and structKeyExists(prc.settings,"apiKey") and len( prc.settings.apiKey ) ){
	    		wmt.setFilePath( prc.settings.apiKey );
	   	 	wmt.loadwmt();
		}


		if( wmt.isFileUploaded() ){
			prc.sites = wmt.getSites().siteEntry;
		}

		prc.settings = deserializeJSON( settingService.getSetting( "cbox-super-seo" ) );
		event.setView( "webmaster/settings" );

	}

	function saveSettings(event,rc,prc){

		var args = { name="cbox-super-seo" };
		prc.settings = settingService.findWhere( criteria=args );

		var tmp = deserializeJSON( prc.settings.getValue() );
		tmp.site = rc.site;

		prc.settings.setValue( serializeJSON( tmp ) );
		settingService.save( prc.settings );
		settingService.flushSettingsCache();

		setNextEvent( 'cbadmin.module.SuperSeo.wmt' );

	}

}
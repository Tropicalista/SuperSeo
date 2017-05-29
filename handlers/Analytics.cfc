/**
* A normal ColdBox Event Handler
*/
component{

	this.prehandler_only = "index,settings";

	property name="analytics" inject="Analytics@SuperSeo";
	property name="settingService"	inject="SettingService@cb";

	public function preHandler( event, action, eventArguments ) {

		prc.settings = deserializeJSON( settingService.getSetting( "cbox-super-seo" ) );
		if( !analytics.isFileUploaded() OR !len( prc.settings.analyticsView ) ){
			setNextEvent( 'cbadmin.module.SuperSeo.analytics.settings' );
		}
	    analytics.loadAnalytics();
	    prc.accessToken = analytics.getToken();

	}

	function index(event,rc,prc){

		if( !structKeyExists( prc.settings, 'analyticsView' ) ){
			setNextEvent( 'cbadmin.module.SuperSeo.analytics.settings' );
		}
		event.setView( "analytics/index" );

	}

	function settings(event,rc,prc){
		
		prc.profiles = analytics.getProfiles().items;

		prc.settings = deserializeJSON( settingService.getSetting( "cbox-super-seo" ) );
		event.setView( "analytics/settings" );

	}

	function saveSettings(event,rc,prc){

		var args = { name="cbox-super-seo" };
		prc.settings = settingService.findWhere( criteria=args );

		var tmp = deserializeJSON( prc.settings.getValue() );
		tmp.analyticsView = rc.profile;

		prc.settings.setValue( serializeJSON( tmp ) );
		settingService.save( prc.settings );
		settingService.flushSettingsCache();

		setNextEvent( 'cbadmin.module.SuperSeo.analytics' );

	}

}
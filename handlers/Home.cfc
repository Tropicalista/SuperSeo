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

		prc.settings = deserializeJSON( settingService.getSetting( "cbox-super-seo" ) );

	}

	function index(event,rc,prc){

		event.setView( "settings" );

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
/**
* A normal ColdBox Event Handler
*/
component{

	property name="settingService"	inject="SettingService@cb";
	property name="menuService"	inject="AdminMenuService@cb";
	property name="jLoader" inject="loader@cbjavaloader";
	property name="s" inject="Google@SuperSeo";
	property name="analytics" inject="Analytics@SuperSeo";
	property name="searchConsole" inject="SearchConsole@SuperSeo";

	public function preHandler( event, action, eventArguments ) {

		prc.settings = deserializeJSON( settingService.getSetting( "cbox-super-seo" ) );

	}

	function index(event,rc,prc){

		param name='prc.settings.apiKey' default='';
		param name='prc.settings.site' default='';
		param name='prc.settings.analyticsView' default='';

		if( len( prc.settings.apiKey ) ){

	    	analytics.loadAnalytics( prc.settings.apiKey );
			prc.profiles = analytics.getProfiles().items;

		}

		event.setView( "settings" );

	}

	function saveSettings(event,rc,prc){

		var args = { name="cbox-super-seo" };
		prc.settings = settingService.findWhere( criteria=args );

		if( rc.seo.enableAnalytics ){
			if( ArrayIsEmpty( structFindValue( menuservice.getTopMenuMap().superSeo, 'analytics') ) )
				menuService.addSubMenu( topMenu="superSeo", name="Analytics", label="Analytics", href="#menuService.buildModuleLink( 'superSeo', 'analytics.index' )#");
		}else{
			menuService.removeSubMenu( topMenu="superSeo", name="Analytics");
		}

		if( rc.seo.enableSearchConsole ){
			if( ArrayIsEmpty( structFindValue( menuservice.getTopMenuMap().superSeo, 'Search Console') ) )
				menuService.addSubMenu( topMenu="superSeo", name="Search Console", label="Search Console", href="#menuService.buildModuleLink( 'superSeo', 'wmt.index' )#");
		}else{
			menuService.removeSubMenu( topMenu="superSeo", name="Search Console");
		}

		prc.settings.setValue( serializeJSON(rc.seo) );
		settingService.save( prc.settings );
		settingService.flushSettingsCache();

		setNextEvent('cbadmin.module.SuperSeo.home');

	}

}
/**
* A normal ColdBox Event Handler
*/
component{

	this.prehandler_only = "index";

	property name="analytics" inject="Analytics@SuperSeo";
	property name="widgetService" inject="entityservice:ssWidget";
	property name="settingService"	inject="SettingService@cb";

	public function preHandler( event, action, eventArguments ) {

		prc.settings = deserializeJSON( settingService.getSetting( "cbox-super-seo" ) );

		if( len( prc.settings.apiKey ) ){

	    	analytics.loadAnalytics( prc.settings.apiKey );
			//prc.profiles = analytics.getProfiles().items;

		}else{
			setNextEvent( 'cbadmin.module.SuperSeo.home.index' );
		}

	}

	function index(event,rc,prc){

	    prc.accessToken = analytics.getToken();
	    var jqueryUI = event.buildLink(getModuleConfig("SuperSeo").invocationPath) & "/includes/js/jquery-ui.min.js";

	    addAsset(jqueryUI);

	    addAsset("https://cdn.jsdelivr.net/lodash/4.17.4/lodash.min.js");

		addAsset("https://cdnjs.cloudflare.com/ajax/libs/vue/2.3.0/vue.js");
		addAsset("https://cdn.jsdelivr.net/vue.resource/0.9.3/vue-resource.min.js");

		addAsset("https://cdnjs.cloudflare.com/ajax/libs/gridstack.js/0.3.0/gridstack.all.js");

		htmlhead text='<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/gridstack.js/0.3.0/gridstack.min.css" />';

		event.setView( "analytics/index2" );

	}

	function list(){
		var list = widgetService.getAll();

		var result = [];

		for( w in list ){
			result.append( w.getMemento() );
		}

		event.renderData( type="json", data=result );
	}

	function save(){
        event.paramValue("id",0);
        event.paramValue("x",0);
        event.paramValue("y",0);
        event.paramValue("width",4);
        event.paramValue("height",4);

        var data = deserializeJSON( rc.settings );

        var widget = widgetService.get( rc.id );

        widget.setName( data.title );
        widget.setX( rc.x );
        widget.setY( rc.y );
        widget.setWidth( rc.width );
        widget.setHeight( rc.height );
        widget.setSettings( data.settings );

        widgetService.save( widget );

		event.renderData( type="json", data=widget.getMemento() );
	}

    function delete(event,rc,prc){
        event.paramValue("id",0);
        widgetService.deleteByID( rc.id );
		
		event.renderData( type="json", data="widget deleted" );

    }

}
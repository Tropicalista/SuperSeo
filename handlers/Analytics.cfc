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

		if( structKeyExists (prc.settings,"apiKey") and len( prc.settings.apiKey ) ){

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

        var data = deserializeJSON( rc.widget );
		if( !structKeyExists( data, "id" ) ){
			data.id = 0;
		}


        var widget = populateModel( model=widgetService.get( data.id) , memento=data );

        widgetService.save( widget );

		event.renderData( type="json", data=widget.getMemento() );
	}

    function bulkSave(event,rc,prc){

    	var widgets = deserializeJSON( rc.widgets );

		var sql = "INSERT INTO cb_ss_widget (id,x,y,width,height) VALUES ";
		for( w in widgets ){
			sql &= "( #w.id#, #w.x#, #w.y#, #w.width#, #w.height# ),";
		}
		sql = left( sql, len(sql) -1 );

		sql &= " ON DUPLICATE KEY UPDATE `x`=VALUES(`x`),`y`=VALUES(`y`),`width`=VALUES(`width`),`height`=VALUES(`height`);";

	    myQry = new Query();     
	    myQry.setSQL(sql);
	    qryRes = myQry.execute();
 	
		event.renderData( type="json", data="widget updated" );

    }

    function delete(event,rc,prc){
        event.paramValue("id",0);
        widgetService.deleteByID( rc.id );

		event.renderData( type="json", data="widget deleted" );

    }

}
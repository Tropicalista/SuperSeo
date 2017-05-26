component {

	// Module Properties
	this.title 				= "SuperSeo";
	this.author 			= "Francesco Pepe";
	this.webURL 			= "www.tropicalseo.net";
	this.description 		= "A seo module for ContentBox";
	this.version			= "1.0.0";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point
	this.entryPoint			= "SuperSeo";
	// Model Namespace
	this.modelNamespace		= "SuperSeo";
	// CF Mapping
	this.cfmapping			= "SuperSeo";
	// Auto-map models
	this.autoMapModels		= true;
	// Module Dependencies
	this.dependencies 		= ["cbjavaloader"];

	function configure(){

		// parent settings
		parentSettings = {

		};

		// module settings - stored in modules.name.settings
		settings = {
			validExtensions 	= "xml,json,jsont,rss,html,htm,cfm,print,pdf,doc",
			enableCanonical	 	= false,
			autoExcerpt		 	= false,
			disableContentRSS 	= false,
			disableBlogRSS 		= false
		};

		// Layout Settings
		layoutSettings = {
			defaultLayout = ""
		};

		// datasources
		datasources = {

		};

		// SES Routes
		routes = [
			// Module Entry Point
			{ pattern="/", handler="home", action="index" },
			// Convention Route
			{ pattern="/:handler/:action?" }
		];

		// Custom Declared Points
		interceptorSettings = {
			customInterceptionPoints = ""
		};

		// Custom Declared Interceptors
		interceptors = [
			{ class="#moduleMapping#.interceptors.Seo", properties={ entryPoint="cbadmin" }, name="Seo@SuperSeo" }
		];

		// Binder Mappings
		// binder.map("Alias").to("#moduleMapping#.model.MyService");

	}

	/**
	* Fired when the module is registered and activated.
	*/
	function onLoad(){
		// Let's add ourselves to the main menu in the Modules section
		var menuService = controller.getWireBox().getInstance("AdminMenuService@cb");
		// Add Menu Contribution
		menuService.addTopMenu( name="superSeo", label='<i class="fa fa-google"></i> SuperSeo', href="##" );
		menuService.addSubMenu( topMenu="superSeo", name="Analytics", label="Analytics", href="#menuService.buildModuleLink( 'superSeo', 'analytics.index' )#");
		menuService.addSubMenu( topMenu="superSeo", name="Search Console", label="Search Console", href="#menuService.buildModuleLink( 'superSeo', 'wmt.index' )#");
		menuService.addSubMenu( topMenu="superSeo", name="Settings", label="Settings", href="#menuService.buildModuleLink( 'superSeo', 'home' )#");
		// load lib
		var jLoader = controller.getWireBox().getInstance( "loader@cbjavaloader" );
		jLoader.appendPaths( modulePath & "\lib" );

	}

	function onActivate() {
		var settingService = controller.getWireBox().getInstance("SettingService@cb");
		// store default settings
		var findArgs = { name="cbox-super-seo" };
		var setting = settingService.findWhere( criteria=findArgs );
		if( isNull( setting ) ){
			var args = { name="cbox-super-seo", value=serializeJSON( settings )};
			var settings = settingService.new( properties=args );
			settingService.save( settings );
			settingService.flushSettingsCache();
		}
	}

	/**
	* Fired when the module is unregistered and unloaded
	*/
	function onUnload(){
		// Let's remove ourselves to the main menu in the Modules section
		var menuService = controller.getWireBox().getInstance("AdminMenuService@cb");
		// Remove Menu Contribution
		menuService.removeTopMenu( "superSeo" );

		var settingService = controller.getWireBox().getInstance("SettingService@cb");
		var args = { name="cbox-super-seo" };
		var setting = settingService.findWhere( criteria=args );
		if( !isNull( setting ) ){
			settingService.delete( setting );
		}

	}

}
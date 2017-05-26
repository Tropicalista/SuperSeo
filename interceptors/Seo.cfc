component extends="coldbox.system.Interceptor"{

	property name="settingService"	inject="SettingService@cb";

	/**
	* Configure CB Request
	*/
	function configure(){

		var findArgs = { name="cbox-super-seo" };
		var setting = settingService.findWhere( criteria=findArgs );
		if( !isNull(setting) ){

			variables.settingsSeo = deserializeJSON( settingService.getSetting( "cbox-super-seo" ) );

		}

	}

	/**
	* Set valid extensions
	*/
	function afterConfigurationLoad( event, rc, prc, interceptData, buffer ){

		getInterceptor("SES").setValidExtensions( variables.settingsSeo.validExtensions );

	}

	/**
	* Fired pre event rendering
	*/
	function preEvent( event, rc, prc, interceptData, buffer ) eventPattern="^contentbox-ui"{

		var config = getSetting(prc);

		if( config.disableContentRSS AND Find( "__rss/", prc.currentRoute ) ){

			event.overrideEvent( "contentbox-ui:page.index" );
			return;

		};

		if( config.disableBlogRSS AND Find( prc.cbsettings.cb_site_blog_entrypoint & "/rss/", prc.currentRoutedURL ) ){

			event.overrideEvent( "contentbox-ui:page.index" );
			return;

		};

	}		

	function cbui_beforeHeadEnd( event, rc, prc, interceptData, buffer ) eventPattern="^contentbox-ui"{

		var config = getSetting(prc);

		if( config.enableCanonical ){

			switch( rc.format ){
				case "pdf" : case "xml" : case "json" : case "doc" : case "print" :
				addCanonicalHeader( rc.namespace, event.buildlink(""), rc );
				break;
				default :
				addCanonical( rc.namespace, event.buildlink(""), rc );
			}	

		}

	}

	function addCanonical( ns, link, rc ){

		if( arguments.ns EQ "blog" ){
			var slug = arguments.rc.entrySlug ?: ""; 
			appendToBuffer( '<link rel="canonical" href="#arguments.link##slug#">' );
		}

		if( arguments.ns EQ "" ){
			var slug = arguments.rc.pageSlug ?: ""; 
			appendToBuffer( '<link rel="canonical" href="#arguments.link##arguments.rc.pageSlug#">' );
		}

	}

	function addCanonicalHeader( ns, link, rc ){

		if( arguments.ns EQ "blog" ){
			var slug = arguments.rc.entrySlug ?: ""; 
		    cfheader(
		        name = "Link",
		        value = '<#arguments.link##slug#>; rel="canonical"'
		    );
		}

		if( arguments.ns EQ "" ){
			var slug = arguments.rc.pageSlug ?: ""; 
		    cfheader(
		        name = "Link",
		        value = '<#arguments.link##slug#>; rel="canonical"'
		    );
		}

	}

	function cbadmin_preEntrySave( event, rc, prc, interceptData, buffer ){

		var config = getSetting(prc);

		if( !interceptData.entry.hasExcerpt() AND config.autoExcerpt ){
			interceptData.entry.setExcerpt( autoExcerpt( prc, rc ) );
		}

	}

	function cbadmin_prePageSave( event, rc, prc, interceptData, buffer ){

		var config = getSetting(prc);

		if( !interceptData.page.hasExcerpt() AND config.autoExcerpt ){
			interceptData.page.setExcerpt( autoExcerpt( prc, rc ) );
		}

	}

	/**
	* Create an excerpt from first 200 characters
	*/
	function autoExcerpt( prc, rc ){

		// Default excerpt from content in non HTML mode
		return HTMLEditFormat(
			REReplaceNoCase( 
				left( arguments.rc.content, 200 ), 
				"<[^>]*>", 
				"", 
				"ALL" 
			)
		);

	}

	function getSetting(prc){

		return deserializeJSON(arguments.prc.cbsettings["cbox-super-seo"]);

	}

}
component extends="Google" {

	Analytics function init(){
		super.init();
		return this;
	}

	public function loadAnalytics(){

		var scopes = jLoader.create("com.google.api.services.analytics.AnalyticsScopes");

		if( isFileUploaded() ){

			variables.credential = generateCredential( scopes.all() );
			generateToken();
			variables.analytics 	= variables.analyticsBuilder
		    			.setApplicationName("searchConsoleAppName")
						.setHttpRequestInitializer(credential)					
						.build();

			return variables.analytics;

		}

	}

	public function getProfiles(){
		return variables.analytics.management().profiles().list("~all", "~all").execute();
	}

}
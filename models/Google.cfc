component accessors="true" singleton{
		
	property name="jLoader" inject="loader@cbjavaloader";
	property name="token";
	property name="expire";
	property name="scope";

	THIS.applicationName = cgi.SERVER_NAME;

	Google function init(){
		return this;
	}

	public function onDIComplete(){

		variables.httpTransport           	= jLoader.create("com.google.api.client.http.javanet.NetHttpTransport").init();
		variables.jsonFactory             	= jLoader.create("com.google.api.client.json.jackson2.JacksonFactory").init();

		variables.credential				= jLoader.create("com.google.api.client.googleapis.auth.oauth2.GoogleCredential").init();

		variables.fileObj                 	= createObject("java", "java.io.FileInputStream");

		variables.wmtBuilder = jLoader.create("com.google.api.services.webmasters.Webmasters$Builder").init(
				variables.httpTransport,
				variables.jsonFactory,
				javaCast("null", "")
			);

		variables.analyticsBuilder = jLoader.create("com.google.api.services.analytics.Analytics$Builder").init(
				variables.httpTransport,
				variables.jsonFactory,
				javaCast("null", "")
			);
		variables.SAQueryRequest = jLoader.create("com.google.api.services.webmasters.model.SearchAnalyticsQueryRequest");

	}

	public function generateCredential( required scopes ){

		return variables.credential
			.fromStream( variables.fileObj.init(getFileName()),
						variables.httpTransport,
						variables.jsonFactory )
			.createScoped( arguments.scopes );
	}

	public function getToken(){

		if(isNull(variables.token) OR isExpiredToken()){
			generateToken();
		}

		return variables.token;

	}

	public function generateToken(){

		variables.credential.refreshToken();
		var access_token = variables.credential.getAccessToken();
		setToken(access_token);
		setExpire(DateAdd("n",45,Now()));

	}

	public function isExpiredToken(){

		var diff = DateDiff("n", Now(), variables.expire)
		return diff LTE 1 ? true : false;

	}

	public function isFileUploaded(){
		return fileExists( getFileName() );
	}

	private function getFileName(){
		return getDirectoryFromPath( getCurrentTemplatePath() )  & "google.json";
	}

}
component extends="Google" {

	SearchConsole function init(){
		super.init();
		return this;
	}

	public function loadWMT(){

		var scopes = jLoader.create("com.google.api.services.webmasters.WebmastersScopes");

		if( isFileUploaded() ){

			variables.credential = generateCredential( scopes.all() );
			generateToken();
			variables.wmt 	= variables.wmtBuilder
		    			.setApplicationName("searchConsoleAppName")
						.setHttpRequestInitializer(credential)					
						.build();

			return variables.wmt;

		}

	}

	public function getSites(){
		return variables.wmt.sites().list().execute();
	}

	public function queryErrorCount( required string site ){
		return variables.wmt.urlcrawlerrorscounts().query( arguments.site ).execute();
	}

	public function queryErrorSample( required string site, required string category, required string platform ){
		return variables.wmt.urlcrawlerrorssamples().list( arguments.site, arguments.category, arguments.platform ).execute();
	}

	function searchAnalytics(
			required string site,
			string startDate,
			string endDate,
			string searchType,
			string aggregationType="auto",
			numeric rowLimit=1000,
			numeric startRow=0,
			array dimensions=[],
			array filterGroups=[]
		){

			var local 			= structNew();
			local.structReturn 	= {success=true, error=""};			

			switch ( arguments.searchType ) {
				case 'video':
				case 'image':
					local.searchType = lCase( arguments.searchType );
					break;
				default:
					local.searchType = 'web';
			}

			switch ( arguments.aggregationType ) {
				case 'byPage':
					local.aggregationType = 'byPage';
					break;
				case 'byProperty':
					local.aggregationType = 'byProperty';
					break;
				default:
					local.aggregationType = 'auto';
			}

			local.queryRequest = variables.SAQueryRequest
				.clone()
				.setStartDate( arguments.startDate )
				.setEndDate( arguments.endDate )
				.setRowLimit(javacast('int', arguments.rowLimit))
				.setStartRow(javacast('int', arguments.startRow))
				.setSearchType(local.searchType)
				.setAggregationType(local.aggregationType);

			if (arrayLen(arguments.dimensions)) {
				local.queryRequest.setDimensions(arguments.dimensions);
			}

			local.iLenFilterGroups = arrayLen(arguments.filterGroups);
			if (local.iLenFilterGroups gt 0) {
				local.lstFiltergroups = arrayNew(1);
				for (local.i=1; local.i lte iLenFilterGroups; local.i++){

					local.structFilterGroup = arguments.filterGroups[local.i];

					if (structKeyExists(local.structFilterGroup, 'filters')) {

						local.objFilterGroup = variables.objFilterGroup.clone();
						if (structKeyExists(local.structFilterGroup, 'groupType')) {
							local.objFilterGroup.setGroupType(javacast('string', local.structFilterGroup.groupType));
						} else {
							local.objFilterGroup.setGroupType(javacast('string', 'and'));
						}
						local.arrFilters = local.structFilterGroup.filters;
						local.iLenFilters = arrayLen(local.arrFilters);
						local.lstFilters = arrayNew(1);
						for (local.j=1; local.j lte iLenFilters; local.j++){
							local.objFilter = variables.objFilter.clone();
							local.objFilter.setDimension(local.arrFilters[local.j].dimension);
							local.objFilter.setOperator(local.arrFilters[local.j].operator);
							local.objFilter.setExpression(local.arrFilters[local.j].expression);
							arrayAppend(local.lstFilters,local.objFilter);
						}
						local.objFilterGroup.setFilters(local.lstFilters);						
					}
					arrayAppend(local.lstFiltergroups,local.objFilterGroup);
				}				
				local.queryRequest.setDimensionFilterGroups(local.lstFiltergroups);				
			}
					
			local.structReturn.response = variables.wmt.searchanalytics().query( arguments.site, local.queryRequest ).execute();			
			local.structReturn.request = local.queryRequest;
			return local.structReturn;

	}

}
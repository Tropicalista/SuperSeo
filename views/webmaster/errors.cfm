<cfoutput>

<cfinclude template="navbar.cfm">

<div class="row">
	
	<div class="col-md-12">
	        
	    <div class="panel panel-primary">
	        <div class="panel-heading">
	            <h3 class="panel-title"> #prc.settings.site#: error on web</h3>
	        </div>
	        <div class="panel-body">

				<table class="table table-responsive">
				<thead>
					<tr>
						<cfloop array="#prc.errors#" index="error">
							<cfif error.platform EQ "web">
								<th>#error.category#</th>
							</cfif>
						</cfloop>
					</tr>
				</thead>
				<tbody>
					<tr>
						<cfloop array="#prc.errors#" index="error">
							<cfif error.platform EQ "web">
								<th>
									#error.entries[1].count#
									<cfif error.entries[1].count>
										<a href="#event.buildLink( 'cbadmin.module.SuperSeo.wmt.queryErrorSample?category=#error.category#&platform=#error.platform#' )#"><i class="fa fa-info"></i></a>
									</cfif>
								</th>
							</cfif>
						</cfloop>
					</tr>
				</tbody>
				</table>
	        </div>
	    </div>
	    
	</div>

	<div class="col-md-12">
	        
	    <div class="panel panel-primary">
	        <div class="panel-heading">
	            <h3 class="panel-title"> #prc.settings.site#: error on smartphone</h3>
	        </div>
	        <div class="panel-body">

				<table class="table table-responsive">
				<thead>
					<tr>
						<cfloop array="#prc.errors#" index="error">
							<cfif error.platform EQ "smartphoneonly">
								<th>#error.category#</th>
							</cfif>
						</cfloop>
					</tr>
				</thead>
				<tbody>
					<tr>
						<cfloop array="#prc.errors#" index="error">
							<cfif error.platform EQ "smartphoneonly">
								<th>#error.entries[1].count#</th>
							</cfif>
						</cfloop>
					</tr>
				</tbody>
				</table>
	        </div>
	    </div>
	    
	</div>

</div>
</cfoutput>
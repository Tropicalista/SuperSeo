<cfoutput>

<cfinclude template="navbar.cfm">

<div class="row">
	
	<div class="col-md-12">
	        
	    <div class="panel panel-primary">
	        <div class="panel-heading">
	            <h3 class="panel-title"> #prc.settings.site#</h3>
	        </div>
	        <div class="panel-body">

				<cfloop array="#prc.sitemaps#" index="sitemap">

					<h3>#sitemap.path#</h3>

					<cfloop array="#sitemap.contents#" index="s">
					<ul>
						<cfloop collection="#s#" item="key">
							<li>
							#key#: #s[key]#<br />
							</li>  	
						</cfloop>
					</ul>
					</cfloop>

				<table class="table table-responsive">
				<thead>
					<tr>
						<th>Errors</th>
						<th>Is pending</th>
						<th>Is sitemap index</th>
						<th>Last downloaded</th>
						<th>Path</th>
						<th>Warnings</th>
					</tr>
				</thead>
				<tbody>
					<tr>	      
						<td>
							#sitemap.errors#
						</td>
						<td>
							#sitemap.isPending#
						</td>
						<td>
							#sitemap.isSitemapsIndex#
						</td>
						<td>
							#sitemap.lastDownloaded#
						</td>
						<td>
							#sitemap.path#
						</td>
						<td>
							#sitemap.warnings#
						</td>
					</tr>
				</tbody>
				</table>
				</cfloop>
	        </div>
	    </div>
	    
	</div>

</div>
</cfoutput>
<cfoutput>

<cfinclude template="navbar.cfm">

<div class="row">
	
	<div class="col-md-12">
	        
	        <div class="panel panel-primary">
	            <div class="panel-heading">
	                <h3 class="panel-title"><i class="fa fa-line-chart"></i> #prc.settings.site#</h3>
	            </div>
	            <div class="panel-body">
	                <div id="chart"></div>
	            </div>
	        </div>
	    
	</div>

	<div class="col-md-12">
	        
	        <div class="panel panel-primary">
	            <div class="panel-heading">
	                <h3 class="panel-title"><i class="fa fa-bars"></i> #prc.settings.site#</h3>
	            </div>
	            <div class="panel-body">
	                <div id="query"></div>
	            </div>
	        </div>
	    
	</div>

</div>

</cfoutput>
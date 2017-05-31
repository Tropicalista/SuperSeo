<cfoutput>

<cfinclude template="navbar.cfm">

<div class="row">

    <cfif structKeyExists( prc, "sites" ) && ArrayLen(prc.sites)>
    <div class="col-md-6">

        #getInstance("MessageBox@cbmessagebox").renderit()#

        #html.startForm(name="superseoform", action=prc.CBHelper.buildModuleLink('SuperSeo', 'wmt.saveSettings'))#
        #html.anchor(name="top")#
        
        <div class="panel panel-default">

            <div class="panel-heading">
                <h3 class="panel-title">Analytics settings</h3>
            </div>

            <div class="panel-body">     

    		    <div class="form-group">
    		        <label class="control-label" for="site">Site:</label>
    		        <select class="form-control" name="site">
    		            <cfloop array=#prc.sites# index="site">
    		                <option value="#site.siteUrl#" <cfif site.siteUrl EQ prc.settings.site>selected</cfif>>#site.siteUrl# (#site.permissionLevel#)</option>
    		            </cfloop>
    		        </select>
    		    </div>

            </div>

            <!--- Button Bar --->
            <div class="form-actions">
                #html.submitButton(value="Save Settings", class="btn btn-danger" )#
            </div>   

        </div>

        #html.endForm()#

    </div>

    <cfelse>

    <div class="col-md-6">
        <div class="panel panel-default">

            <div class="panel-heading">
                <h3 class="panel-title">Docs</h3>
            </div>

            <div class="panel-body">
    			<p>Before you start, you should follow the documentation.</p>      
            </div>
        </div>

    </div>
    </cfif>

</div>
</cfoutput>
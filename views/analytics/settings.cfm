<cfoutput>

<div class="col-md-6">

    #getInstance("MessageBox@cbmessagebox").renderit()#

    #html.startForm(name="superseoform", action=prc.CBHelper.buildModuleLink('SuperSeo', 'analytics.saveSettings'))#
    #html.anchor(name="top")#
    
    <div class="panel panel-default">

        <div class="panel-heading">
            <h3 class="panel-title">Analytics settings</h3>
        </div>

        <div class="panel-body">     

    		<cfif ArrayLen(prc.profiles)>
		    <div class="form-group">
		        <label class="control-label" for="profile">Profile:</label>
		        <select class="form-control" name="profile">
		            <cfloop array=#prc.profiles# index="profile">
		                <option value="#profile.id#" <cfif profile.id EQ prc.settings.analyticsView>selected</cfif>>#profile.name#</option>
		            </cfloop>
		        </select>
		    </div>
		    </cfif>

        </div>

        <!--- Button Bar --->
        <div class="form-actions">
            #html.submitButton(value="Save Settings", class="btn btn-danger" )#
        </div>   

    </div>

    #html.endForm()#

</div>

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

</cfoutput>
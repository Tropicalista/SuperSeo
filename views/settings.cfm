<cfoutput>

<div class="col-md-8">

    #getInstance("MessageBox@cbmessagebox").renderit()#

    #html.startForm(name="superseoform", action=prc.CBHelper.buildModuleLink('SuperSeo', 'home.saveSettings'))#
    #html.anchor(name="top")#
    
    <div class="panel panel-default">

        <div class="panel-heading">
            <h3 class="panel-title">Seo settings</h3>
        </div>

        <div class="panel-body">     

            <div class="form-group">
                #html.label(
                    class   = "control-label",
                    field   = "seo.validExtensions",
                    content = "Valid extensions:"
                )#
                
                <div class="controls">
                    <small>By default <code>xml,json,jsont,rss,html,htm,cfm,print,pdf,doc,txt</code></small> extensions are enabled.
                    <br/>
                    <br/>         
                    #html.textField(
                        name    = "seo.validExtensions",
                        class="form-control",
                        value=prc.settings.validExtensions,
                        wrapper="div class=controls",
                        groupWrapper="div class=form-group"
                    )#
                </div>
            </div>

            <div class="form-group">
                #html.label(
                    class   = "control-label",
                    field   = "seo.disableBlogRSS",
                    content = "Disable Blog RSS Features:"
                )#
                
                <div class="controls">
                    <small>If disabled, blog RSS link will not work anymore</small><br/><br/>      
                    #html.checkbox(
                        name    = "disableBlogRSS_toggle",
                        data    = { toggle: 'toggle', match: 'seo\.disableBlogRSS' },
                        checked = prc.settings.disableBlogRSS
                    )#
                    #html.hiddenField(
                        name    = "seo.disableBlogRSS",
                        value = prc.settings.disableBlogRSS
                    )#
                </div>
            </div>

            <div class="form-group">
                #html.label(
                    class   = "control-label",
                    field   = "seo.disableContentRSS",
                    content = "Disable content RSS Features:"
                )#
                
                <div class="controls">
                    <small>If disabled, content RSS link will not work anymore</small><br/><br/>      
                    #html.checkbox(
                        name    = "disableContentRSS_toggle",
                        data    = { toggle: 'toggle', match: 'seo\.disableContentRSS' },
                        checked = prc.settings.disableContentRSS
                    )#
                    #html.hiddenField(
                        name    = "seo.disableContentRSS",
                        value = prc.settings.disableContentRSS
                    )#
                </div>
            </div>

            <div class="form-group">
                #html.label(
                    class   = "control-label",
                    field   = "seo.autoExcerpt",
                    content = "Enable auto excerpt:"
                )#
                
                <div class="controls">
                    <small>If enabled, it will save excerpt from first 200 character from all content without excerpt</small><br/><br/>      
                    #html.checkbox(
                        name    = "autoExcerpt_toggle",
                        data    = { toggle: 'toggle', match: 'seo\.autoExcerpt' },
                        checked = prc.settings.autoExcerpt
                    )#
                    #html.hiddenField(
                        name    = "seo.autoExcerpt",
                        value = prc.settings.autoExcerpt
                    )#
                </div>
            </div>

            <div class="form-group">
                #html.label(
                    class   = "control-label",
                    field   = "seo.enableCanonical",
                    content = "Enable rel canonical:"
                )#
                
                <div class="controls">
                    <small>If enabled, it will add rel=canonical to all page</small><br/><br/>      
                    #html.checkbox(
                        name    = "enableCanonical_toggle",
                        data    = { toggle: 'toggle', match: 'seo\.enableCanonical' },
                        checked = prc.settings.enableCanonical
                    )#
                    #html.hiddenField(
                        name    = "seo.enableCanonical",
                        value = prc.settings.enableCanonical
                    )#
                </div>
            </div>

            <div class="form-group">
                #html.label(
                    class   = "control-label",
                    field   = "seo.enableSearchConsole",
                    content = "Enable Google Search Console dashboard:"
                )#
                
                <div class="controls">
                    <small>If enabled, it will add a dashboard to display your Search Console chart</small><br/><br/>      
                    #html.checkbox(
                        name    = "enableSearchConsole_toggle",
                        data    = { toggle: 'toggle', match: 'seo\.enableSearchConsole' },
                        checked = prc.settings.enableSearchConsole
                    )#
                    #html.hiddenField(
                        name    = "seo.enableSearchConsole",
                        value = prc.settings.enableSearchConsole
                    )#
                </div>
            </div>

            <cfif prc.settings.enableAnalytics && structKeyExists( prc, "profiles" ) && ArrayLen(prc.profiles)>

            <div class="form-group">
                <label class="control-label" for="profile">Profile:</label>
                <select class="form-control" name="seo.site">
                    <cfloop array=#prc.profiles# index="profile">
                        <option value="#profile.id#" <cfif profile.id EQ prc.settings.site>selected</cfif>>#profile.name#</option>
                    </cfloop>
                </select>
            </div>

            </cfif>

            <div class="form-group">
                #html.label(
                    class   = "control-label",
                    field   = "seo.enableAnalytics",
                    content = "Enable Google Analytics dashboard:"
                )#
                
                <div class="controls">
                    <small>If enabled, it will add a dashboard to display your Analytics chart</small><br/><br/>      
                    #html.checkbox(
                        name    = "enableAnalytics_toggle",
                        data    = { toggle: 'toggle', match: 'seo\.enableAnalytics' },
                        checked = prc.settings.enableAnalytics
                    )#
                    #html.hiddenField(
                        name    = "seo.enableAnalytics",
                        value = prc.settings.enableAnalytics
                    )#
                </div>
            </div>

            <cfif prc.settings.enableAnalytics || prc.settings.enableSearchConsole>

            <div class="form-group">
                <label class="control-label" for="profile">Your json file name:</label>
                <input type="text" name="seo.apiKey" value="#prc.settings.apiKey#" class="form-control valid" title="" data-original-title="Insert your json file api key name" aria-invalid="false">
            </div>

            </cfif>

            <cfif prc.settings.enableAnalytics && structKeyExists( prc, "profiles" ) && ArrayLen(prc.profiles)>

            <div class="form-group">
                <label class="control-label" for="profile">Profile:</label>
                <select class="form-control" name="seo.analyticsView">
                    <cfloop array=#prc.profiles# index="profile">
                        <option value="#profile.id#" <cfif profile.id EQ prc.settings.analyticsView>selected</cfif>>#profile.name#</option>
                    </cfloop>
                </select>
            </div>

            </cfif>

            <!--- Button Bar --->
            <div class="form-actions">
                #html.submitButton(value="Save Settings", class="btn btn-danger" )#
            </div>                    


        </div>

    </div>

    #html.endForm()#

</div>

<div class="col-md-4">
    <div class="panel panel-default">

        <div class="panel-heading">
            <h3 class="panel-title">Sites available</h3>
        </div>

        <div class="panel-body">
        <cfif structKeyExists(prc, 'sites')>
            <table class="table table-striped">
                <tr>
                    <td>Site</td>
                    <td>Action</td>
                </tr>
                <cfloop array=#prc.sites.siteEntry# index="site">
                <tr>
                    <td>#site.siteUrl#</td>
                    <td>
                        <a href=""><i class="fa fa-edit"></i></a>
                        <a href=""><i class="fa fa-times"></i></a>
                    </td>
                </tr>
                </cfloop>
            </table>
        </cfif>          
        </div>
    </div>

</div>

<script type="text/javascript">
    
    // toggle checkboxes
    $( '.panel-body' ).find( 'input[data-toggle="toggle"]' ).change( function() {
        var inputMatch = $( this ).data( 'match' );
        $( "##" + inputMatch ).val( $( this ).prop( 'checked' ) );
    });

</script>
</cfoutput>
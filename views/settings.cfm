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
                    field   = "seo.autoExcerpt",
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
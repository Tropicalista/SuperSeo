<cfoutput>

<!-- This file should primarily consist of HTML with a little bit of PHP. -->
<div class="wrap"  id="manage-vue">

	<button type="button" class="btn btn-primary" @click="openModal()">Add widget</button>
	<button type="button" class="btn btn-danger" v-if="showSaveButton" @click="saveDashboard()">Save</button>

	<modal v-if="showModal" :item="item" :edit="edit"> 
		<h3 slot="header" class="modal-title">
			Edit {{item.name}}
		</h3>

		<div slot="footer">
			<button type="button" class="btn btn-outline-info" @click="showModal = false"> Close </button>
			<button type="button" class="btn btn-primary" data-dismiss="modal" @click="saveWidget(item)">
			 Submit
			</button>
		</div>
	</modal>

    <div class="grid-stack">

        <dashboard-widget v-for="widget in widgets" v-bind:widget="widget" :key="widget.id" ref="widgets"></dashboard-widget>

    </div>

</div>

<!-- template for the modal component -->
<script type="text/x-template" id="modal-template">
<transition name="modal">
 <div class="modal" style="display: block" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <slot name="header"></slot>
      </div>
      
      	<div class="modal-body">
			<form action="##" @submit.prevent="edit ? updateWidget(item.id) : saveWidget()">
				<div class="form-group">
					<label class="control-label" for="name">Name:</label>
					<div class="controls">
						<input type="text" v-model="item.name" name="name" class="form-control">
					</div>
				</div>			  
				<div class="form-group">
					<label class="control-label" for="metrics">Metrics:</label>
					<div class="controls">
					<select v-model="item.settings" name="metrics" class="form-control">
						<optgroup v-for="(option, key) in metricOptions" v-bind:label="key">
						<option v-for="sub in option" v-bind:value="sub.value">{{sub.label}}</option>
						</optgroup>                    
					</select>  
					</div>
				</div>			  
				<div class="form-group">
					<label for="date">Date</label>
					<select v-model="item.settings.date" name="date" class="form-control">
						<option v-for="option in dateOptions" v-bind:value="option.value">
						{{ option.label }}
						</option>
					</select>   
				</div>			  
			</form>
      	</div>
      
      <div class="modal-footer">
        <slot name="footer"></slot>
      </div>
    </div>
  </div>
</div>
</transition>
</script>

<script type="text/x-template" id="my-widget">

<div class="grid-stack-item" :data-gs-x="widget.x" :data-gs-y="widget.y" :data-gs-width="widget.width" :data-gs-height="widget.height" :data-gs-min-width="widget.minWidth" :data-gs-min-height="widget.minHeight" :data-gs-max-width="widget.maxWidth" :data-gs-max-height="widget.maxHeight" :data-gs-id="widget.id">
	<div class="grid-stack-item-content">
		<div class="panel panel-default">
			<div class="panel-heading"><h3 class="panel-title">{{widget.name}}</h3>
				<div class="actions pull-right">
					<div class="btn-group btn-group-sm">
						<a class="btn btn-primary btn-sm" v-on:click="$parent.editWidget(widget.id)"><i class="fa fa-cog"></i></a>
						<a class="btn btn-danger btn-sm" v-on:click="$parent.deleteWidget(widget.id)"><i class="fa fa-times"></i></a>
					</div>
				</div>
			</div>
			<div v-bind:id="'widget-' + widget.id" class="panel-body" style="min-height:100%"></div>
		</div>
	</div>
</div>

</script>
</cfoutput>
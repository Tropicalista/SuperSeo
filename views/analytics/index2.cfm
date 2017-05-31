<cfoutput>

<!-- This file should primarily consist of HTML with a little bit of PHP. -->
<div class="wrap"  id="manage-vue">

	<button type="button" class="btn btn-primary" @click="showModal = true" data-toggle="modal" data-target="##myModal">Add widget</button>

	<!-- use the modal component, pass in the prop -->
	<modal v-if="showModal" @close="showModal = false" :item="item" :edit="edit" @clicked="createWidget">
	</modal>

    <div class="grid-stack">

        <dashboard-widget v-for="widget in widgets" v-bind:widget="widget" :key="widget.id" ref="widgets"></dashboard-widget>

    </div>


</div>

<!-- template for the modal component -->
<script type="text/x-template" id="modal-template">

<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
		<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
			<h4 class="modal-title" id="myModalLabel">Modal title</h4>
		</div>
      	<div class="modal-body">
			<form action="##" @submit.prevent="edit ? updateWidget(item.id) : createWidget()">
			  <div class="input-group">
			      <label for="title">Title</label>
			      <input v-model="item.title" type="text" name="title" class="form-control" autofocus>
			  </div>
			      <label for="metrics">Metrics</label>
			      <select v-model="item.settings" name="metrics">
			        <optgroup v-for="(option, key) in metricOptions" v-bind:label="key">
			          <option v-for="sub in option" v-bind:value="sub.value">{{sub.label}}</option>
			        </optgroup>                    
			      </select>                  
			      <label for="date">Date</label>
			      <select v-model="item.settings.date" name="date">
			        <option v-for="option in dateOptions" v-bind:value="option.value">
			          {{ option.label }}
			        </option>
			      </select>                  
			</form>
      	</div>
		<div class="modal-footer">
			<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
			<button v-show="!edit" type="submit" class="button button-primary" @click="$emit('clicked', item)">New Widget</button>
		</div>
    </div>
  </div>
</div>

</script>
</cfoutput>
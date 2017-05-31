<cfoutput>
<script type="text/javascript">

(function(w,d,s,g,js,fs){
  g=w.gapi||(w.gapi={});g.analytics={q:[],ready:function(f){this.q.push(f);}};
  js=d.createElement(s);fs=d.getElementsByTagName(s)[0];
  js.src='https://apis.google.com/js/platform.js';
  fs.parentNode.insertBefore(js,fs);js.onload=function(){g.load('analytics');};
}(window,document,'script'));

// global variables
var view = '#prc.settings.analyticsView#';
var access_token = '#prc.accessToken#';
	
(function( $ ) {
	'use strict';

	gapi.analytics.ready(function() {

		/**
		* Authorize the user with an access token obtained server side.
		*/
		gapi.analytics.auth.authorize({
			'serverAuth': {
			  'access_token': access_token
			}
		});

		Vue.component('modal', {
			template: '##modal-template',
			props: ['item','edit'],
			data: function () {
			  return {
			    metricOptions : {
			        Audience : [
				        { value: { metrics: ['ga:sessions','ga:pageviews','ga:users'], dimensions: ['ga:date'] }, label: 'Overview' },
				        { value: { metrics: ['ga:users'], dimensions: ['ga:date'] }, label: 'Users' },
				        { value: { metrics: ['ga:users'], dimensions: ['ga:userAgeBracket'], chart: 'PIE' }, label: 'Users Age' },
				        { value: { metrics: ['ga:sessions'], dimensions: ['ga:date'] }, label: 'Sessions' },
				        { value: { metrics: ['ga:newUsers'], dimensions: ['ga:date'] }, label: 'New Users' },
				        { value: { metrics: ['ga:pageviews'], dimensions: ['ga:date'] }, label: 'Pageviews' },
				        { value: { metrics: ['ga:pageviewsPerSession'], dimensions: ['ga:date'] }, label: 'Pageviews per session' },
				        { value: { metrics: ['ga:uniquePageviews'], dimensions: ['ga:date'] }, label: 'Unique pageviews' },
				        { value: { metrics: ['ga:sessions'], dimensions: ['ga:userType'], chart: 'PIE' }, label: 'New vs Returning' },
				        { value: { metrics: ['ga:sessions'], dimensions: ['ga:country'], sort: ['-ga:sessions'], chart: 'GEO' }, label: 'Country' },
				        { value: { metrics: ['ga:sessions, ga:bounceRate, ga:sessionDuration, ga:goalConversionRateAll'], dimensions: ['ga:pageTitle'], chart: 'table' }, label: 'Seo' },
				        { value: { metrics: ['ga:sessions'], dimensions: ['ga:mobileDeviceInfo'], maxresults: 5, sort: ['-ga:sessions'], chart: 'PIE' }, label: 'Mobile Traffic' }
			        ],
			        Technology : [
				        { value: { metrics: ['ga:sessions'], dimensions: ['ga:browser'], sort: ['-ga:sessions'], maxresults: 5, chart: 'PIE' }, label: 'Top browser' },
				        { value: { metrics: ['ga:sessions'], dimensions: ['ga:networkLocation'], sort: ['-ga:sessions'], maxresults: 5 }, label: 'Top network', chart: 'PIE' }
			        ],
			        Devices : [
				        { value: { metrics: ['ga:sessions'], dimensions: ['ga:deviceCategory'], sort: ['-ga:sessions'] }, label: 'Device', chart: 'PIE' },
				        { value: { metrics: ['ga:sessions'], dimensions: ['ga:mobileDeviceModel'], sort: ['-ga:sessions'], filters:'ga:mobileDeviceModel!=(not set)', maxresults: 5, chart: 'PIE' }, label: 'Device model' }
			        ],
			        Interests : [
				        { value: { metrics: ['ga:users'], dimensions: ['ga:interestAffinityCategory'], maxresults: 5, chart:'BAR' }, label: 'Interest affinity' },
				        { value: { metrics: ['ga:users'], dimensions: ['ga:interestInMarketCategory'], maxresults: 5, chart:'BAR' }, label: 'Interest in marketing' },
				        { value: { metrics: ['ga:users'], dimensions: ['ga:interestAffinityCategory'], maxresults: 5, chart:'BAR' }, label: 'Other categories' }
			        ],
			        Demographics : [
				        { value: { metrics: ['ga:users'], dimensions: ['ga:userAgeBracket'], chart:'BAR' }, label: 'Age' },
				        { value: { metrics: ['ga:users'], dimensions: ['ga:userGender'], chart:'PIE' }, label: 'Gender' },
				        { value: { metrics: ['ga:users'], dimensions: ['ga:date','ga:userGender'], filters:'ga:userGender==male' }, label: 'Male' },
				        { value: { metrics: ['ga:users'], dimensions: ['ga:date','ga:userGender'], filters:'ga:userGender==female' }, label: 'Female' }
			        ]
			    },
			    dateOptions :[
			        { label: 'Last 3 days', value: { startDate: '3daysAgo', endDate: 'today' } },
			        { label: 'Last 7 days', value: { startDate: '7daysAgo', endDate: 'today' } },
			        { label: 'Last 14 days', value: { startDate: '14daysAgo', endDate: 'today' } },
			        { label: 'Last 30 days', value: { startDate: '30daysAgo', endDate: 'today' } },
			        { label: 'Last 90 days', value: { startDate: '90daysAgo', endDate: 'today' } }
			    ]}
			}

		})

		Vue.component('dashboard-widget', {
			props: ['widget'],
			template: '<div class="grid-stack-item"' +
			':data-gs-x="widget.x" :data-gs-y="widget.y" :data-gs-width="widget.width" :data-gs-height="widget.height" :data-gs-min-width="widget.minWidth" :data-gs-min-height="widget.minHeight" :data-gs-max-width="widget.maxWidth" :data-gs-max-height="widget.maxHeight" :data-gs-id="widget.id">' +
			'<div class="grid-stack-item-content">' +
			'<div class="panel panel-default">' +
			'<div class="panel-heading"><h3 class="panel-title">{{widget.name}}</h3>' +
			'<div class="actions pull-right">'+
			'<div class="btn-group btn-group-sm">' +
			'<a class="btn btn-primary btn-sm" @click="showModal = true" v-on:click="$parent.editWidget(widget.id)"><i class="fa fa-edit"></i></a>'+
			'<a class="btn btn-danger btn-sm" v-on:click="$parent.deleteWidget(widget.id)"><i class="fa fa-times"></i></a>' +
			'</div>'+
			'</div>'+
			'</div>'+
    		'<div v-bind:id="widget.id" class="panel-body"></div>' +
			'</div>' +
			'</div>' +
			'</div>',

			mounted: function () {

				jQuery('.grid-stack').data('gridstack').addWidget(this.$el);

				this.renderChart();
			},

			methods:{
				renderChart: function(){
					console.log(this.widget)
					var dataChart = new gapi.analytics.googleCharts.DataChart({
						query: {
							ids: 'ga:' + view,
							metrics: this.widget.settings.metrics,
							dimensions: this.widget.settings.dimensions,
							'start-date': this.widget.settings.date.startDate,
							'end-date': this.widget.settings.date.endDate
						},
						chart: {
							container: this.widget.id,
							type: this.widget.settings.chart ? this.widget.settings.chart : 'LINE',
							options: {
								width: '100%',
								height: this.$el.offsetHeight - 60
							}
						}
					}).execute();

				}
			}	

		});

		var vm = new Vue({

		    el: '##manage-vue',

		    data: {
				showModal: false,
				edit: false,
				widgets: [],
				item:{
					title: '',
					settings: {}
				}
		    },

		  	mounted : function(){

		  		this.getWidgets();
				var options = {
				  cellHeight: 100,
				  verticalMargin: 10,
				  auto: true
				};
				jQuery('.grid-stack').gridstack(options);

		  		var mm = this;
				jQuery('.grid-stack').on('change', function(event, items) {
					//mm.updateWidgets(items)
				})

				$('.grid-stack').on('gsresizestop', function(event, elem) {
					var comp = _.find(mm.$refs.widgets, function(item) {
					    return item.widget.id == $(elem).attr("data-gs-id"); 
					});
				    comp.renderChart()
				});

		  	},

		  	methods : {

				getWidgets: function(){
					this.$http.get( "#event.buildLink('cbadmin.module.SuperSeo.analytics.list')#", {action: "list_widgets"}, {
						emulateJSON: true
						} ).then( function(response){
							this.widgets = response.data
						});
				},

				createWidget (item) {
					console.log(item);
					this.$http.post("#event.buildLink('cbadmin.module.SuperSeo.analytics.save')#",{action:'add_widget',settings:JSON.stringify(item)}, {emulateJSON:true}).then( function(response){
						this.getWidgets();
					})

					this.showModal = false;

				},

		        deleteWidget: function(item){
					this.$http.post("#event.buildLink('cbadmin.module.SuperSeo.analytics.delete')#", { action: "delete_widget", id: JSON.stringify(item) }, {
						emulateJSON: true
						} ).then( function(response){
							this.getWidgets();
							toastr.success('Item Deleted Successfully.', 'Success Alert', {timeOut: 3000});
						});
		        },

		        editWidget: function(item){

					this.item = this.widgets.filter(function(elem){
						if(elem.id == item) return elem; 
					})

		        },

		        updateItem: function(id){
		          	var input = this.fillItem;
		          	console.log(this.fillItem)
		              this.changePage(this.pagination.current_page);
		              this.fillItem = {'title':'','description':'','id':''};
		              $("##edit-item").modal('hide');
		              this.items.push(this.fillItem);
		              toastr.success('Item Updated Successfully.', 'Success Alert', {timeOut: 5000});

		        },

		        updateWidgets: function(items){
	                var res = _.map($('.grid-stack .grid-stack-item:visible'), function (el) {
	                    el = $(el);
	                    var node = el.data('_gridstack_node');

	                    if(typeof node != 'undefined'){
		                    return {
		                        id: node.id,
		                        x: node.x,
		                        y: node.y,
		                        width: node.width,
		                        height: node.height
		                    };
		                }
	                });
	                if(res.length) {     
						this.$http.post("#event.buildLink('cbadmin.module.SuperSeo.analytics.list')#", {action: 'update_multi', widgets:_.without(res, undefined)}, {
						emulateJSON: true
						} )
					}
		        }

		    }

		});

	});


})( jQuery );


</script>
</cfoutput>
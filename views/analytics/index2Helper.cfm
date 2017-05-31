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
			template: '##my-widget',

			mounted: function () {

				jQuery('.grid-stack').data('gridstack').addWidget(this.$el);

				this.renderChart();
			},

			methods:{

				renderChart: function(){

					var dataChart = new gapi.analytics.googleCharts.DataChart({
						query: {
							ids: 'ga:' + view,
							metrics: this.widget.settings.metrics,
							dimensions: this.widget.settings.dimensions,
							'start-date': this.widget.settings.date.startDate,
							'end-date': this.widget.settings.date.endDate
						},
						chart: {
							container: "widget-" + this.widget.id,
							type: this.widget.settings.chart ? this.widget.settings.chart : 'LINE',
							options: {
								width: '100%',
								height: this.$el.offsetHeight - 100
							}
						}
					}).execute();

				}
			}	

		});

		var vm = new Vue({

		    el: '##manage-vue',

		    data: {
				showSaveButton	: false,
				showModal		: false,
				edit 			: false,
				widgets 		: [],
				item 			: {}
		    },

		  	mounted : function(){

		  		this.getWidgets();
				var options = {
				  cellHeight: 100,
				  verticalMargin: 10,
				  auto: true
				};
				$('.grid-stack').gridstack(options);

		  		var mm = this;

				$('.grid-stack').on('gsresizestop', function(event, elem) {
					mm.showSaveButton = true;
					console.log(this.showSaveButton)
					var comp = _.find(mm.$refs.widgets, function(item) {
					    return item.widget.id == $(elem).attr("data-gs-id"); 
					});
					mm.updateWidgets()
				    comp.renderChart()
				});

				$('.grid-stack').on('dragstop', function(event, ui) {
					mm.updateWidgets()
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

				saveWidget (item) {

					this.$http.post("#event.buildLink('cbadmin.module.SuperSeo.analytics.save')#",{widget:JSON.stringify(item)}, {emulateJSON:true}).then( function(response){
						this.getWidgets();
					})
					var comp = _.find(this.$refs.widgets, function(w) {
					    return w.widget.id == item.id; 
					});
					comp.renderChart();
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

					var obj = this.widgets.filter(function(elem){
						if(elem.id == item) return elem; 
					})
					this.item = obj[0];
					this.showModal = true;

		        },

		        openModal: function(){

		        	this.showModal = true;
		        	this.item = {
		        		settings: {}
		        	};

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
						this.$http.post("#event.buildLink('cbadmin.module.SuperSeo.analytics.bulkSave')#", {widgets: JSON.stringify(_.without(res, undefined)) }, {
						emulateJSON: true
						} ).then( function(response){
							toastr.success('Dashboard saved!', 'Success Alert', {timeOut: 3000});
						});
					}
		        }

		    }

		});

	});


})( jQuery );


</script>
</cfoutput>
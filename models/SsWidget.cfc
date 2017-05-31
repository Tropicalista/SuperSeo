component entityname="ssWidget" 
			persistent="true" 
			table="cb_ss_widget" {
		
	property name="id" fieldtype="id" generator="native" setter="false";
	property name="name";
	property name="x";
	property name="y";
	property name="width";
	property name="height";
	property name="settings";
	property name="minWidth";
	property name="minHeight";
	property name="maxWidth";
	property name="maxHeight";

	SsWidget function init(){
		return this;
	}

	function getSettings(){
		return deserializeJSON( variables.settings );
	}

	function setSettings( settings ){
		variables.settings = serializeJSON( arguments.settings );
	}

	/**
	* Get memento representation
	*/
	public struct function getMemento(string exclude=""){
		var data = {};
		var props = getMetaData(this).properties;
		
		for(var x=1; x <= arrayLen(props); x++){
			// if we want to exclude properties from automatically getting set
			// we can pass an exclude list user.toStruct('roles');
			if( listFindNoCase(arguments.exclude,props[x].name) == 0 ){
				var method = this["get" & props[x].name];				
				data["#props[x].name#"] = method();
			}
		}
		
		return data;

	}

}
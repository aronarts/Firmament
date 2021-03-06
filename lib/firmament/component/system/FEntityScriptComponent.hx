
package firmament.component.system;

import firmament.util.loader.FDataLoader;
import firmament.component.base.FEntityComponent;
import firmament.core.FConfig;
import firmament.core.FEvent;

class FEntityScriptComponent extends FEntityComponent {

	private var events:FConfig;

	public function new(gameInstance:firmament.core.FGame) {
		super(gameInstance);
	}

	override public function init(conf:Dynamic) {
		var config:FConfig = conf;
		if(Reflect.isObject(config['events'])){
			events = config['events'];
		}else{
			throw "events property missing for eventMap";
		}

		for(event in Reflect.fields(events)){
			log("Adding listener " + event + " to execute script");
			var value:FConfig = events[event], scriptText:String = null;
			for( field in Reflect.fields(value) ) {
				var val = value.get(field,String,null);
				switch(field) {
					case "file":
						log("Loading file");
						scriptText = FDataLoader.loadFile(val);
						break;
					default:
						log("Loading script");
						scriptText = val;
						break;
				}
			}
			
			if( scriptText != null ) {
				// log("Processing <"+event+"> -> " + scriptText );
				on(_entity,event,this,function(e:FEvent):Dynamic{
					log(e.name + " event fired, running script");
					var ret:Dynamic = _entity.getGameInstance().eval(scriptText, this);
					var triggerEvent:String = _config.get('trigger',String,null);
					if( triggerEvent != null ) {
						_entity.trigger( new FEvent(triggerEvent) );
					}
					return ret;
				});
			}
		}
	}

	override public function getType() {
		return "script";
	}

}
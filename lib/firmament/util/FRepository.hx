
package firmament.util;

class FRepository {

	static var _instance:FRepository;

	var _hash:Map<String,Dynamic>;

	private function new(){
		_hash = new Map<String,Dynamic>();
	}


	public static function getInstance():FRepository{
		if(_instance == null){
			_instance = new FRepository();
		}
		return _instance;
	}


	public function set(key:String,val:Dynamic){
		_hash.set(key,val);

	}


	public function get(key:String):Dynamic{
		return _hash.get(key);
	}

	public function getAll(){
		return _hash;
	}
}
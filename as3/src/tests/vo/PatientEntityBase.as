package tests.vo {
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import mx.events.PropertyChangeEvent;
	import mx.collections.errors.ItemPendingError;
	import org.davekeen.flextrine.orm.collections.PersistentCollection;
	import org.davekeen.flextrine.orm.events.EntityEvent;
	import org.davekeen.flextrine.util.EntityUtil;
	import org.davekeen.flextrine.flextrine;
	import tests.vo.Doctor;

	[Bindable]
	public class PatientEntityBase extends EventDispatcher {
		
		public var isUnserialized__:Boolean;
		
		public var isInitialized__:Boolean = true;
		
		flextrine var itemPendingError:ItemPendingError;
		
		[Id]
		public function get id():String { return _id; }
		public function set id(value:String):void { _id = value; }
		private var _id:String;
		
		public function get name():String { checkIsInitialized("name"); return _name; }
		public function set name(value:String):void { _name = value; }
		private var _name:String;
		
		public function get address():String { checkIsInitialized("address"); return _address; }
		public function set address(value:String):void { _address = value; }
		private var _address:String;
		
		public function get postcode():String { checkIsInitialized("postcode"); return _postcode; }
		public function set postcode(value:String):void { _postcode = value; }
		private var _postcode:String;
		
		[Association(side="inverse", oppositeAttribute="patient", oppositeCardinality="1")]
		public function get appointments():PersistentCollection { checkIsInitialized("appointments"); return _appointments; }
		public function set appointments(value:PersistentCollection):void { _appointments = value; }
		private var _appointments:PersistentCollection;
		
		[Association(side="inverse", oppositeAttribute="patient", oppositeCardinality="1")]
		public function get phoneNumbers():PersistentCollection { checkIsInitialized("phoneNumbers"); return _phoneNumbers; }
		public function set phoneNumbers(value:PersistentCollection):void { _phoneNumbers = value; }
		private var _phoneNumbers:PersistentCollection;
		
		[Association(side="owning", oppositeAttribute="patients", oppositeCardinality="*")]
		public function get doctor():Doctor { checkIsInitialized("doctor"); return _doctor; }
		public function set doctor(value:Doctor):void { (value) ? value.flextrine::addValue('patients', this) : ((_doctor) ? _doctor.flextrine::removeValue('patients', this) : null); _doctor = value; }
		private var _doctor:Doctor;
		
		public function PatientEntityBase() {
			if (!_appointments) _appointments = new PersistentCollection(null, true, "appointments", this);
			if (!_phoneNumbers) _phoneNumbers = new PersistentCollection(null, true, "phoneNumbers", this);
		}
		
		override public function toString():String {
			return "[Patient id=" + id + "]";
		}
		
		private function checkIsInitialized(property:String):void {
			if (!isInitialized__ && isUnserialized__ && !EntityUtil.flextrine::isCopying) {
				if (!flextrine::itemPendingError) {
					flextrine::itemPendingError = new ItemPendingError("ItemPendingError - initializing entity " + this);
					dispatchEvent(new EntityEvent(EntityEvent.INITIALIZE_ENTITY, property, flextrine::itemPendingError));
				}
			}
		}
		
		flextrine function setValue(attributeName:String, value:*):void {
			if (isInitialized__) {
				if (this["_" + attributeName] is PersistentCollection)
					throw new Error("Internal error - Flextrine attempted to setValue on a PersistentCollection.");
					
				var propertyChangeEvent:PropertyChangeEvent = PropertyChangeEvent.createUpdateEvent(this, attributeName, this[attributeName], value);
				
				this["_" + attributeName] = value;
				
				dispatchEvent(propertyChangeEvent);
			}
		}
		
		flextrine function addValue(attributeName:String, value:*):void {
			if (isInitialized__) {
				if (!(this["_" + attributeName] is PersistentCollection))
					throw new Error("Internal error - Flextrine attempted to addValue on a non-PersistentCollection.");
					
				this["_" + attributeName].flextrine::addItemNonRecursive(value);
			}
		}
		
		flextrine function removeValue(attributeName:String, value:*):void {
			if (isInitialized__) {
				if (!(this["_" + attributeName] is PersistentCollection))
					throw new Error("Internal error - Flextrine attempted to removeValue on a non-PersistentCollection.");
				
				this["_" + attributeName].flextrine::removeItemNonRecursive(value);
			}
		}
		
		flextrine function saveState():Dictionary {
			if (isInitialized__) {
				var memento:Dictionary = new Dictionary(true);
				memento["id"] = id;
				memento["name"] = name;
				memento["address"] = address;
				memento["postcode"] = postcode;
				memento["appointments"] = appointments.flextrine::saveState();
				memento["phoneNumbers"] = phoneNumbers.flextrine::saveState();
				memento["doctor"] = doctor;
				return memento;
			}
			
			return null;
		}
		
		flextrine function restoreState(memento:Dictionary):void {
			if (isInitialized__) {
				id = memento["id"];
				name = memento["name"];
				address = memento["address"];
				postcode = memento["postcode"];
				appointments.flextrine::restoreState(memento["appointments"]);
				phoneNumbers.flextrine::restoreState(memento["phoneNumbers"]);
				doctor = memento["doctor"];
			}
		}
		
	}

}

(function ($global) { "use strict";
function $extend(from, fields) {
	var proto = Object.create(from);
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
Math.__name__ = true;
var Std = function() { };
Std.__name__ = true;
Std.string = function(s) {
	return js_Boot.__string_rec(s,"");
};
var champuru_Worker = function() { };
champuru_Worker.__name__ = true;
champuru_Worker.onMessage = function(e) {
	try {
		var fwd = js_Boot.__cast(e.data.fwd , String);
		var rev = js_Boot.__cast(e.data.rev , String);
		var scoreCalculationMethod = js_Boot.__cast(e.data.score , Int);
		var i = js_Boot.__cast(e.data.i , Int);
		var j = js_Boot.__cast(e.data.j , Int);
		var use = js_Boot.__cast(e.data.useOffsets , Bool);
		var result = "";
		champuru_Worker.workerScope.postMessage(result);
	} catch( _g ) {
		var e = haxe_Exception.caught(_g).unwrap();
		champuru_Worker.workerScope.postMessage("The following error occurred: " + Std.string(e));
	}
};
champuru_Worker.main = function() {
	champuru_Worker.workerScope = self;
	champuru_Worker.workerScope.onmessage = champuru_Worker.onMessage;
};
var champuru_base_AmbiguousNucleotideSequence = function(seq) {
	if(seq == null) {
		this.mSequence = new haxe_ds_IntMap();
		this.mLength = 0;
	} else {
		this.mSequence = new haxe_ds_IntMap();
		var i = 0;
		var _g_head = seq.h;
		while(_g_head != null) {
			var val = _g_head.item;
			_g_head = _g_head.next;
			var c = val;
			this.mSequence.h[i] = c;
			++i;
		}
		this.mLength = seq.length;
	}
};
champuru_base_AmbiguousNucleotideSequence.__name__ = true;
champuru_base_AmbiguousNucleotideSequence.fromString = function(str) {
	var list = new haxe_ds_List();
	var _g = 0;
	var _g1 = str.length;
	while(_g < _g1) {
		var i = _g++;
		var ch = str.charAt(i);
		var nucleotide = champuru_base_SingleAmbiguousNucleotide.getNucleotideByIUPACCode(ch);
		list.add(nucleotide);
	}
	return new champuru_base_AmbiguousNucleotideSequence(list);
};
champuru_base_AmbiguousNucleotideSequence.main = function() {
};
champuru_base_AmbiguousNucleotideSequence.prototype = {
	length: function() {
		return this.mLength;
	}
	,iterator: function() {
		var seq = new haxe_ds_List();
		var _g = 0;
		var _g1 = this.mLength;
		while(_g < _g1) {
			var i = _g++;
			var c = this.mSequence.h[i];
			seq.add(c);
		}
		return new haxe_ds__$List_ListIterator(seq.h);
	}
	,get: function(i) {
		if(!(0 <= i && i < this.mLength)) {
			throw haxe_Exception.thrown("Position " + i + " out of range [0," + this.mLength + "(");
		}
		return this.mSequence.h[i];
	}
	,replace: function(i,c) {
		if(c == null) {
			throw haxe_Exception.thrown("c must not be null!");
		}
		if(!(0 <= i && i < this.mLength)) {
			throw haxe_Exception.thrown("Position " + i + " out of range [0," + this.mLength + "(");
		}
		this.mSequence.h[i] = c;
	}
	,reverse: function() {
		var seq = new haxe_ds_List();
		var i = this.mLength - 1;
		while(i <= 0) {
			var c = this.mSequence.h[i];
			seq.add(c);
			--i;
		}
		var result = new champuru_base_AmbiguousNucleotideSequence(seq);
		return result;
	}
	,toString: function() {
		var result = new haxe_ds_List();
		var _g = 0;
		var _g1 = this.mLength;
		while(_g < _g1) {
			var i = _g++;
			var c = this.mSequence.h[i];
			var s = c.toIUPACCode();
			result.add(s);
		}
		return result.join("");
	}
	,countAmbigiuous: function() {
		var result = 0;
		var _g = 0;
		var _g1 = this.mLength;
		while(_g < _g1) {
			var i = _g++;
			var c = this.mSequence.h[i];
			var count = c.countPossibleNucleotides();
			if(count >= 2) {
				++result;
			}
		}
		return result;
	}
	,countGaps: function() {
		var result = 0;
		var _g = 0;
		var _g1 = this.mLength;
		while(_g < _g1) {
			var i = _g++;
			var c = this.mSequence.h[i];
			if(!c.mAdenine && !c.mCytosine && !c.mGuanine && !c.mThymine) {
				++result;
			}
		}
		return result;
	}
	,matches: function(s) {
		if(this.mLength != s.mLength) {
			return false;
		}
		var _g = 0;
		var _g1 = this.mLength;
		while(_g < _g1) {
			var i = _g++;
			if(!(0 <= i && i < this.mLength)) {
				throw haxe_Exception.thrown("Position " + i + " out of range [0," + this.mLength + "(");
			}
			var c1 = this.mSequence.h[i];
			if(!(0 <= i && i < s.mLength)) {
				throw haxe_Exception.thrown("Position " + i + " out of range [0," + s.mLength + "(");
			}
			var c2 = s.mSequence.h[i];
			if(!c1.matches(c2)) {
				return false;
			}
		}
		return true;
	}
	,isWithin: function(s) {
		if(this.mLength != s.mLength) {
			return false;
		}
		var _g = 0;
		var _g1 = this.mLength;
		while(_g < _g1) {
			var i = _g++;
			if(!(0 <= i && i < this.mLength)) {
				throw haxe_Exception.thrown("Position " + i + " out of range [0," + this.mLength + "(");
			}
			var c1 = this.mSequence.h[i];
			if(!(0 <= i && i < s.mLength)) {
				throw haxe_Exception.thrown("Position " + i + " out of range [0," + s.mLength + "(");
			}
			var c2 = s.mSequence.h[i];
			if(!c1.isWithin(c2)) {
				return false;
			}
		}
		return true;
	}
	,clone: function() {
		var seq = new haxe_ds_List();
		var _g = 0;
		var _g1 = this.mLength;
		while(_g < _g1) {
			var i = _g++;
			if(!(0 <= i && i < this.mLength)) {
				throw haxe_Exception.thrown("Position " + i + " out of range [0," + this.mLength + "(");
			}
			var c = this.mSequence.h[i];
			seq.add(c);
		}
		return new champuru_base_AmbiguousNucleotideSequence(seq);
	}
	,__class__: champuru_base_AmbiguousNucleotideSequence
};
var champuru_base_SingleAmbiguousNucleotide = function(adenine,cythosine,thymine,guanine,quality) {
	this.mQuality = true;
	this.mGuanine = false;
	this.mThymine = false;
	this.mCytosine = false;
	this.mAdenine = false;
	this.mAdenine = adenine;
	this.mCytosine = cythosine;
	this.mThymine = thymine;
	this.mGuanine = guanine;
	this.mQuality = quality;
};
champuru_base_SingleAmbiguousNucleotide.__name__ = true;
champuru_base_SingleAmbiguousNucleotide.getNucleotideByIUPACCode = function(ocode) {
	var code = ocode.toUpperCase();
	var quality = code == ocode;
	if(code == "." || code == "-") {
		return new champuru_base_SingleAmbiguousNucleotide(false,false,false,false,quality);
	} else if(code == "A") {
		return new champuru_base_SingleAmbiguousNucleotide(true,false,false,false,quality);
	} else if(code == "C") {
		return new champuru_base_SingleAmbiguousNucleotide(false,true,false,false,quality);
	} else if(code == "T") {
		return new champuru_base_SingleAmbiguousNucleotide(false,false,true,false,quality);
	} else if(code == "G") {
		return new champuru_base_SingleAmbiguousNucleotide(false,false,false,true,quality);
	} else if(code == "K") {
		return new champuru_base_SingleAmbiguousNucleotide(false,false,true,true,quality);
	} else if(code == "S") {
		return new champuru_base_SingleAmbiguousNucleotide(false,true,false,true,quality);
	} else if(code == "R") {
		return new champuru_base_SingleAmbiguousNucleotide(true,false,false,true,quality);
	} else if(code == "Y") {
		return new champuru_base_SingleAmbiguousNucleotide(false,true,true,false,quality);
	} else if(code == "W") {
		return new champuru_base_SingleAmbiguousNucleotide(true,false,true,false,quality);
	} else if(code == "M") {
		return new champuru_base_SingleAmbiguousNucleotide(true,true,false,false,quality);
	} else if(code == "B") {
		return new champuru_base_SingleAmbiguousNucleotide(false,true,true,true,quality);
	} else if(code == "D") {
		return new champuru_base_SingleAmbiguousNucleotide(true,false,true,true,quality);
	} else if(code == "V") {
		return new champuru_base_SingleAmbiguousNucleotide(true,true,false,true,quality);
	} else if(code == "H") {
		return new champuru_base_SingleAmbiguousNucleotide(true,true,true,false,quality);
	} else if(code == "N") {
		return new champuru_base_SingleAmbiguousNucleotide(true,true,true,true,quality);
	}
	throw haxe_Exception.thrown("Unknown character " + code + ". Cannot convert it into a nucleotide!");
};
champuru_base_SingleAmbiguousNucleotide.union = function(l) {
	var containsA = false;
	var _g_head = l.h;
	while(_g_head != null) {
		var val = _g_head.item;
		_g_head = _g_head.next;
		var aa = val;
		if(aa.mAdenine) {
			containsA = true;
			break;
		}
	}
	var containsC = false;
	var _g1_head = l.h;
	while(_g1_head != null) {
		var val = _g1_head.item;
		_g1_head = _g1_head.next;
		var aa = val;
		if(aa.mCytosine) {
			containsC = true;
			break;
		}
	}
	var containsT = false;
	var _g2_head = l.h;
	while(_g2_head != null) {
		var val = _g2_head.item;
		_g2_head = _g2_head.next;
		var aa = val;
		if(aa.mThymine) {
			containsT = true;
			break;
		}
	}
	var containsG = false;
	var _g3_head = l.h;
	while(_g3_head != null) {
		var val = _g3_head.item;
		_g3_head = _g3_head.next;
		var aa = val;
		if(aa.mGuanine) {
			containsG = true;
			break;
		}
	}
	return new champuru_base_SingleAmbiguousNucleotide(containsA,containsC,containsT,containsG,true);
};
champuru_base_SingleAmbiguousNucleotide.main = function() {
	var seq = "CTRAATTCAAATCACACTCGCGAAAWYMWKRAA";
	var seq2 = "YWRAWTYMAAWYMMMMYYSSSRAAATCATGAA";
	console.log("champuru/base/SingleAmbiguousNucleotide.hx:345:","  " + seq);
	var _g = 0;
	var _g1 = seq2.length;
	while(_g < _g1) {
		var j = _g++;
		var oc = seq2.charAt(j);
		var result = [];
		result.push(oc);
		result.push(" ");
		var _g2 = 0;
		var _g3 = seq.length;
		while(_g2 < _g3) {
			var i = _g2++;
			var c = seq.charAt(i);
			var other = champuru_base_SingleAmbiguousNucleotide.getNucleotideByIUPACCode(oc);
			var x = champuru_base_SingleAmbiguousNucleotide.getNucleotideByIUPACCode(c).matches(other);
			if(x) {
				result.push("#");
			} else {
				result.push(" ");
			}
		}
		console.log("champuru/base/SingleAmbiguousNucleotide.hx:361:",result.join(""));
	}
};
champuru_base_SingleAmbiguousNucleotide.prototype = {
	canStandForAdenine: function() {
		return this.mAdenine;
	}
	,canStandForCythosine: function() {
		return this.mCytosine;
	}
	,canStandForThymine: function() {
		return this.mThymine;
	}
	,canStandForGuanine: function() {
		return this.mGuanine;
	}
	,isQuality: function() {
		return this.mQuality;
	}
	,isGap: function() {
		if(!this.mAdenine && !this.mCytosine && !this.mGuanine) {
			return !this.mThymine;
		} else {
			return false;
		}
	}
	,isN: function() {
		if(this.mAdenine && this.mCytosine && this.mGuanine) {
			return this.mThymine;
		} else {
			return false;
		}
	}
	,toIUPACCode: function() {
		var result = "-";
		if(this.mAdenine && this.mCytosine && this.mGuanine && this.mThymine) {
			result = "N";
		} else if(this.mAdenine && this.mCytosine && this.mGuanine) {
			result = "V";
		} else if(this.mAdenine && this.mCytosine && this.mThymine) {
			result = "H";
		} else if(this.mAdenine && this.mGuanine && this.mThymine) {
			result = "D";
		} else if(this.mCytosine && this.mGuanine && this.mThymine) {
			result = "B";
		} else if(this.mAdenine && this.mCytosine) {
			result = "M";
		} else if(this.mAdenine && this.mThymine) {
			result = "W";
		} else if(this.mAdenine && this.mGuanine) {
			result = "R";
		} else if(this.mCytosine && this.mThymine) {
			result = "Y";
		} else if(this.mCytosine && this.mGuanine) {
			result = "S";
		} else if(this.mThymine && this.mGuanine) {
			result = "K";
		} else if(this.mAdenine) {
			result = "A";
		} else if(this.mCytosine) {
			result = "C";
		} else if(this.mThymine) {
			result = "T";
		} else if(this.mGuanine) {
			result = "G";
		}
		if(!this.mQuality) {
			result = result.toLowerCase();
		}
		return result;
	}
	,countPossibleNucleotides: function() {
		var i = 0;
		if(this.mAdenine) {
			++i;
		}
		if(this.mCytosine) {
			++i;
		}
		if(this.mThymine) {
			++i;
		}
		if(this.mGuanine) {
			++i;
		}
		return i;
	}
	,isAmbiguous: function() {
		var count = this.countPossibleNucleotides();
		return count >= 2;
	}
	,matches: function(o) {
		if(this.mAdenine && o.mAdenine) {
			return true;
		}
		if(this.mCytosine && o.mCytosine) {
			return true;
		}
		if(this.mThymine && o.mThymine) {
			return true;
		}
		if(this.mGuanine && o.mGuanine) {
			return true;
		}
		return false;
	}
	,isWithin: function(o) {
		if(!this.mAdenine && o.mAdenine) {
			return false;
		}
		if(!this.mCytosine && o.mCytosine) {
			return false;
		}
		if(!this.mThymine && o.mThymine) {
			return false;
		}
		if(!this.mGuanine && o.mGuanine) {
			return false;
		}
		return true;
	}
	,equals: function(o,alsoEq) {
		if(this.mAdenine != o.mAdenine) {
			return false;
		}
		if(this.mCytosine != o.mCytosine) {
			return false;
		}
		if(this.mThymine != o.mThymine) {
			return false;
		}
		if(this.mGuanine != o.mGuanine) {
			return false;
		}
		if(alsoEq) {
			if(this.mQuality != o.mQuality) {
				return false;
			}
		}
		return true;
	}
	,reverse: function() {
		var adenine = this.mThymine;
		var cythosine = this.mGuanine;
		var thymine = this.mAdenine;
		var guanine = this.mCytosine;
		return new champuru_base_SingleAmbiguousNucleotide(adenine,cythosine,thymine,guanine,this.mQuality);
	}
	,clone: function() {
		return new champuru_base_SingleAmbiguousNucleotide(this.mAdenine,this.mCytosine,this.mThymine,this.mGuanine,this.mQuality);
	}
	,cloneWithQual: function(quality) {
		return new champuru_base_SingleAmbiguousNucleotide(this.mAdenine,this.mCytosine,this.mThymine,this.mGuanine,quality);
	}
	,__class__: champuru_base_SingleAmbiguousNucleotide
};
var haxe_IMap = function() { };
haxe_IMap.__name__ = true;
haxe_IMap.__isInterface__ = true;
var haxe_Exception = function(message,previous,native) {
	Error.call(this,message);
	this.message = message;
	this.__previousException = previous;
	this.__nativeException = native != null ? native : this;
};
haxe_Exception.__name__ = true;
haxe_Exception.caught = function(value) {
	if(((value) instanceof haxe_Exception)) {
		return value;
	} else if(((value) instanceof Error)) {
		return new haxe_Exception(value.message,null,value);
	} else {
		return new haxe_ValueException(value,null,value);
	}
};
haxe_Exception.thrown = function(value) {
	if(((value) instanceof haxe_Exception)) {
		return value.get_native();
	} else if(((value) instanceof Error)) {
		return value;
	} else {
		var e = new haxe_ValueException(value);
		return e;
	}
};
haxe_Exception.__super__ = Error;
haxe_Exception.prototype = $extend(Error.prototype,{
	unwrap: function() {
		return this.__nativeException;
	}
	,get_native: function() {
		return this.__nativeException;
	}
	,__class__: haxe_Exception
});
var haxe_ValueException = function(value,previous,native) {
	haxe_Exception.call(this,String(value),previous,native);
	this.value = value;
};
haxe_ValueException.__name__ = true;
haxe_ValueException.__super__ = haxe_Exception;
haxe_ValueException.prototype = $extend(haxe_Exception.prototype,{
	unwrap: function() {
		return this.value;
	}
	,__class__: haxe_ValueException
});
var haxe_ds_IntMap = function() {
	this.h = { };
};
haxe_ds_IntMap.__name__ = true;
haxe_ds_IntMap.__interfaces__ = [haxe_IMap];
haxe_ds_IntMap.prototype = {
	__class__: haxe_ds_IntMap
};
var haxe_ds_List = function() {
	this.length = 0;
};
haxe_ds_List.__name__ = true;
haxe_ds_List.prototype = {
	add: function(item) {
		var x = new haxe_ds__$List_ListNode(item,null);
		if(this.h == null) {
			this.h = x;
		} else {
			this.q.next = x;
		}
		this.q = x;
		this.length++;
	}
	,join: function(sep) {
		var s_b = "";
		var first = true;
		var l = this.h;
		while(l != null) {
			if(first) {
				first = false;
			} else {
				s_b += sep == null ? "null" : "" + sep;
			}
			s_b += Std.string(l.item);
			l = l.next;
		}
		return s_b;
	}
	,__class__: haxe_ds_List
};
var haxe_ds__$List_ListNode = function(item,next) {
	this.item = item;
	this.next = next;
};
haxe_ds__$List_ListNode.__name__ = true;
haxe_ds__$List_ListNode.prototype = {
	__class__: haxe_ds__$List_ListNode
};
var haxe_ds__$List_ListIterator = function(head) {
	this.head = head;
};
haxe_ds__$List_ListIterator.__name__ = true;
haxe_ds__$List_ListIterator.prototype = {
	hasNext: function() {
		return this.head != null;
	}
	,next: function() {
		var val = this.head.item;
		this.head = this.head.next;
		return val;
	}
	,__class__: haxe_ds__$List_ListIterator
};
var haxe_iterators_ArrayIterator = function(array) {
	this.current = 0;
	this.array = array;
};
haxe_iterators_ArrayIterator.__name__ = true;
haxe_iterators_ArrayIterator.prototype = {
	hasNext: function() {
		return this.current < this.array.length;
	}
	,next: function() {
		return this.array[this.current++];
	}
	,__class__: haxe_iterators_ArrayIterator
};
var js_Boot = function() { };
js_Boot.__name__ = true;
js_Boot.getClass = function(o) {
	if(o == null) {
		return null;
	} else if(((o) instanceof Array)) {
		return Array;
	} else {
		var cl = o.__class__;
		if(cl != null) {
			return cl;
		}
		var name = js_Boot.__nativeClassName(o);
		if(name != null) {
			return js_Boot.__resolveNativeClass(name);
		}
		return null;
	}
};
js_Boot.__string_rec = function(o,s) {
	if(o == null) {
		return "null";
	}
	if(s.length >= 5) {
		return "<...>";
	}
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) {
		t = "object";
	}
	switch(t) {
	case "function":
		return "<function>";
	case "object":
		if(((o) instanceof Array)) {
			var str = "[";
			s += "\t";
			var _g = 0;
			var _g1 = o.length;
			while(_g < _g1) {
				var i = _g++;
				str += (i > 0 ? "," : "") + js_Boot.__string_rec(o[i],s);
			}
			str += "]";
			return str;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( _g ) {
			return "???";
		}
		if(tostr != null && tostr != Object.toString && typeof(tostr) == "function") {
			var s2 = o.toString();
			if(s2 != "[object Object]") {
				return s2;
			}
		}
		var str = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		var k = null;
		for( k in o ) {
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str.length != 2) {
			str += ", \n";
		}
		str += s + k + " : " + js_Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str += "\n" + s + "}";
		return str;
	case "string":
		return o;
	default:
		return String(o);
	}
};
js_Boot.__interfLoop = function(cc,cl) {
	if(cc == null) {
		return false;
	}
	if(cc == cl) {
		return true;
	}
	var intf = cc.__interfaces__;
	if(intf != null) {
		var _g = 0;
		var _g1 = intf.length;
		while(_g < _g1) {
			var i = _g++;
			var i1 = intf[i];
			if(i1 == cl || js_Boot.__interfLoop(i1,cl)) {
				return true;
			}
		}
	}
	return js_Boot.__interfLoop(cc.__super__,cl);
};
js_Boot.__instanceof = function(o,cl) {
	if(cl == null) {
		return false;
	}
	switch(cl) {
	case Array:
		return ((o) instanceof Array);
	case Bool:
		return typeof(o) == "boolean";
	case Dynamic:
		return o != null;
	case Float:
		return typeof(o) == "number";
	case Int:
		if(typeof(o) == "number") {
			return ((o | 0) === o);
		} else {
			return false;
		}
		break;
	case String:
		return typeof(o) == "string";
	default:
		if(o != null) {
			if(typeof(cl) == "function") {
				if(js_Boot.__downcastCheck(o,cl)) {
					return true;
				}
			} else if(typeof(cl) == "object" && js_Boot.__isNativeObj(cl)) {
				if(((o) instanceof cl)) {
					return true;
				}
			}
		} else {
			return false;
		}
		if(cl == Class ? o.__name__ != null : false) {
			return true;
		}
		if(cl == Enum ? o.__ename__ != null : false) {
			return true;
		}
		return false;
	}
};
js_Boot.__downcastCheck = function(o,cl) {
	if(!((o) instanceof cl)) {
		if(cl.__isInterface__) {
			return js_Boot.__interfLoop(js_Boot.getClass(o),cl);
		} else {
			return false;
		}
	} else {
		return true;
	}
};
js_Boot.__cast = function(o,t) {
	if(o == null || js_Boot.__instanceof(o,t)) {
		return o;
	} else {
		throw haxe_Exception.thrown("Cannot cast " + Std.string(o) + " to " + Std.string(t));
	}
};
js_Boot.__nativeClassName = function(o) {
	var name = js_Boot.__toStr.call(o).slice(8,-1);
	if(name == "Object" || name == "Function" || name == "Math" || name == "JSON") {
		return null;
	}
	return name;
};
js_Boot.__isNativeObj = function(o) {
	return js_Boot.__nativeClassName(o) != null;
};
js_Boot.__resolveNativeClass = function(name) {
	return $global[name];
};
String.prototype.__class__ = String;
String.__name__ = true;
Array.__name__ = true;
var Int = { };
var Dynamic = { };
var Float = Number;
var Bool = Boolean;
var Class = { };
var Enum = { };
js_Boot.__toStr = ({ }).toString;
champuru_Worker.main();
})(typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this);

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
var StringTools = function() { };
StringTools.__name__ = true;
StringTools.htmlEscape = function(s,quotes) {
	var buf_b = "";
	var _g_offset = 0;
	var _g_s = s;
	while(_g_offset < _g_s.length) {
		var s = _g_s;
		var index = _g_offset++;
		var c = s.charCodeAt(index);
		if(c >= 55296 && c <= 56319) {
			c = c - 55232 << 10 | s.charCodeAt(index + 1) & 1023;
		}
		var c1 = c;
		if(c1 >= 65536) {
			++_g_offset;
		}
		var code = c1;
		switch(code) {
		case 34:
			if(quotes) {
				buf_b += "&quot;";
			} else {
				buf_b += String.fromCodePoint(code);
			}
			break;
		case 38:
			buf_b += "&amp;";
			break;
		case 39:
			if(quotes) {
				buf_b += "&#039;";
			} else {
				buf_b += String.fromCodePoint(code);
			}
			break;
		case 60:
			buf_b += "&lt;";
			break;
		case 62:
			buf_b += "&gt;";
			break;
		default:
			buf_b += String.fromCodePoint(code);
		}
	}
	return buf_b;
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
	,push: function(item) {
		var x = new haxe_ds__$List_ListNode(item,this.h);
		this.h = x;
		if(this.q == null) {
			this.q = x;
		}
		this.length++;
	}
	,last: function() {
		if(this.q == null) {
			return null;
		} else {
			return this.q.item;
		}
	}
	,clear: function() {
		this.h = null;
		this.q = null;
		this.length = 0;
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
var champuru_Worker = function() { };
champuru_Worker.__name__ = true;
champuru_Worker.out = function(s) {
	champuru_Worker.mMsgs.add(s);
};
champuru_Worker.generateHtml = function(fwd,rev,scoreCalculationMethod,iOffset,jOffset,useThisOffsets) {
	champuru_Worker.mMsgs.clear();
	champuru_Worker.out("<fieldset>");
	champuru_Worker.out("<legend>Input</legend>");
	champuru_Worker.out("<p>Forward sequence of length " + fwd.length + ": <span class='sequence'>");
	champuru_Worker.out(fwd);
	champuru_Worker.out("</p><p>Reverse sequence of length " + rev.length + ": <span class='sequence'>");
	champuru_Worker.out(rev);
	champuru_Worker.out("</p>");
	champuru_Worker.out("<p>Score calculation method: " + scoreCalculationMethod + "</p>");
	if(useThisOffsets) {
		champuru_Worker.out("<p>Offsets to use: " + iOffset + " and " + jOffset + ".</p>");
	} else {
		champuru_Worker.out("<p>Calculate offsets and use best offsets.</p>");
	}
	champuru_Worker.out("</fieldset>");
	champuru_Worker.out("<br>");
	champuru_Worker.out("<fieldset>");
	champuru_Worker.out("<legend>Output of &quot;old&quot; Champuru 1.0 program</legend>");
	champuru_Worker.out("<div style='overflow-x: scroll; width:720px'>");
	champuru_Worker.out("<pre style='font-family: monospace;'>");
	var output = champuru_perl_PerlChampuruReimplementation.runChampuru(fwd,rev,false).getOutput();
	output = StringTools.htmlEscape(output);
	champuru_Worker.out(output);
	champuru_Worker.out("</pre>");
	champuru_Worker.out("</div>");
	champuru_Worker.out("</fieldset>");
	champuru_Worker.out("<br>");
	return { result : champuru_Worker.mMsgs.join("")};
};
champuru_Worker.onMessage = function(e) {
	try {
		var fwd = js_Boot.__cast(e.data.fwd , String);
		var rev = js_Boot.__cast(e.data.rev , String);
		var scoreCalculationMethod = js_Boot.__cast(e.data.score , Int);
		var i = js_Boot.__cast(e.data.i , Int);
		var j = js_Boot.__cast(e.data.j , Int);
		var use = js_Boot.__cast(e.data.useOffsets , Bool);
		var result = champuru_Worker.generateHtml(fwd,rev,scoreCalculationMethod,i,j,use);
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
var champuru_perl_PerlChampuruReimplementation = function() { };
champuru_perl_PerlChampuruReimplementation.__name__ = true;
champuru_perl_PerlChampuruReimplementation.stringifyIntMap = function(o) {
	var result = new haxe_ds_List();
	var minVal = 0;
	var maxVal = 0;
	var init = true;
	var key = o.keys();
	while(key.hasNext()) {
		var key1 = key.next();
		if(init) {
			minVal = key1;
			maxVal = key1;
			init = false;
		}
		if(key1 < minVal) {
			minVal = key1;
		}
		if(key1 > maxVal) {
			maxVal = key1;
		}
	}
	var _g = minVal;
	var _g1 = maxVal + 1;
	while(_g < _g1) {
		var key = _g++;
		if(o.h.hasOwnProperty(key)) {
			var v = o.h[key];
			result.add(v);
		}
	}
	return result.join("");
};
champuru_perl_PerlChampuruReimplementation.replaceCharInString = function(s,i,c) {
	var prev = s.substring(0,i);
	var end = s.substring(i + 1,s.length);
	return prev + c + end;
};
champuru_perl_PerlChampuruReimplementation.splice = function(s,i,l) {
	var start = s.substring(0,i);
	var end = s.substring(i + l);
	return start + end;
};
champuru_perl_PerlChampuruReimplementation.reverseString = function(s) {
	var result = new haxe_ds_List();
	var _g = 0;
	var _g1 = s.length;
	while(_g < _g1) {
		var i = _g++;
		var c = s.charAt(i);
		result.push(c);
	}
	return result.join("");
};
champuru_perl_PerlChampuruReimplementation.comp = function(a,b) {
	var intersection = champuru_perl_PerlChampuruReimplementation.code.h[a] & champuru_perl_PerlChampuruReimplementation.code.h[b];
	if(intersection == 0) {
		return 0;
	} else {
		return 1;
	}
};
champuru_perl_PerlChampuruReimplementation.inter = function(a,b) {
	var intersection = champuru_perl_PerlChampuruReimplementation.code.h[a] & champuru_perl_PerlChampuruReimplementation.code.h[b];
	if(intersection == 0) {
		return "_";
	} else {
		return champuru_perl_PerlChampuruReimplementation.rev_code.h[intersection];
	}
};
champuru_perl_PerlChampuruReimplementation.max = function(a,b) {
	if(a > b) {
		return a;
	} else {
		return b;
	}
};
champuru_perl_PerlChampuruReimplementation.min = function(a,b) {
	if(a < b) {
		return a;
	} else {
		return b;
	}
};
champuru_perl_PerlChampuruReimplementation.runChampuru = function(forward,reverse,opt_c) {
	var result = new champuru_perl_PerlChampuruResult();
	result.print("\n");
	result.print("Champuru (command-line version)\n\n");
	result.print("Reference:\nFlot, J.-F. (2007) Champuru 1.0: a computer software for unraveling mixtures of two DNA sequences of unequal lengths. Molecular Ecology Notes 7 (6): 974-977\n\n");
	result.print("Usage: perl champuru.pl -f <forward sequence> -r <reverse sequence> -o <FASTA output> -n <sample name> -c\nThe forward and reverse sequences should be provided as text files (with the whole sequence on a single line).\nPlease use the switch -c if the reverse sequence has to be reverse-complemented (this switch should not be used if the sequence has already been reverse-complemented, for instance because it is copied from a contig editor).\nIf an output file name is specified and no problem is detected in the input data, the two reconstructed sequences will be appended to the output file in FASTA format using the specified sample name followed by 'a' and 'b'.\n\n");
	var _g = 0;
	var _g1 = forward.length;
	while(_g < _g1) {
		var i = _g++;
		var r = forward.charAt(i);
		if(champuru_perl_PerlChampuruReimplementation.bases.indexOf(r) == -1) {
			result.print("Unknown base (" + r + ") in forward sequence!");
			return result;
		}
	}
	var _g = 0;
	var _g1 = reverse.length;
	while(_g < _g1) {
		var i = _g++;
		var r = reverse.charAt(i);
		if(champuru_perl_PerlChampuruReimplementation.bases.indexOf(r) == -1) {
			result.print("Unknown base ($r) in reverse sequence!");
			return result;
		}
	}
	result.print("Length of forward sequence: " + forward.length + " bases\n");
	result.print("Length of reverse sequence: " + reverse.length + " bases\n");
	if(opt_c) {
		var sb = new haxe_ds_List();
		var i = reverse.length - 1;
		while(i >= 0) {
			var c = reverse.charAt(i);
			var rev = champuru_perl_PerlChampuruReimplementation.complement.h[c];
			sb.add(rev);
			--i;
		}
		reverse = sb.join("");
	}
	var scoremax1 = 0;
	var scoremax2 = 0;
	var scoremax3 = 0;
	var imax1 = 0;
	var imax2 = 0;
	var imax3 = 0;
	var i = -(forward.length - 1);
	while(i < reverse.length) {
		var score = 0;
		if(i < 0) {
			var _g = 0;
			var a = forward.length + i;
			var b = reverse.length;
			var _g1 = a < b ? a : b;
			while(_g < _g1) {
				var j = _g++;
				score += champuru_perl_PerlChampuruReimplementation.comp(forward.charAt(j - i),reverse.charAt(j));
			}
			score -= (forward.length + i) / 4;
		} else if(i > 0) {
			var _g2 = 0;
			var a1 = forward.length;
			var b1 = reverse.length - i;
			var _g3 = a1 < b1 ? a1 : b1;
			while(_g2 < _g3) {
				var j1 = _g2++;
				score += champuru_perl_PerlChampuruReimplementation.comp(forward.charAt(j1),reverse.charAt(j1 + i));
			}
			score -= (forward.length + i) / 4;
		} else if(i == 0) {
			var _g4 = 0;
			var a2 = forward.length;
			var b2 = reverse.length;
			var _g5 = a2 < b2 ? a2 : b2;
			while(_g4 < _g5) {
				var j2 = _g4++;
				score += champuru_perl_PerlChampuruReimplementation.comp(forward.charAt(j2),reverse.charAt(j2));
			}
			score -= (forward.length + i) / 4;
		}
		if(score > scoremax1) {
			imax3 = imax2;
			imax2 = imax1;
			imax1 = i;
			scoremax3 = scoremax2;
			scoremax2 = scoremax1;
			scoremax1 = score;
		} else if(score > scoremax2) {
			imax3 = imax2;
			imax2 = i;
			scoremax3 = scoremax2;
			scoremax2 = score;
		} else if(score > scoremax3) {
			imax3 = i;
			scoremax3 = score;
		}
		++i;
	}
	result.print("Best compatibility score: " + scoremax1 + " (offset: " + imax1 + ")\n");
	result.print("Second best compatibility score: " + scoremax2 + " (offset: " + imax2 + ")\n");
	result.print("Third best compatibility score: " + scoremax3 + " (offset: " + imax3 + ")\n\n");
	var seq1_ = new haxe_ds_IntMap();
	var seq2_ = new haxe_ds_IntMap();
	var j = -(imax1 < 0 ? imax1 : 0);
	while(true) {
		var a = forward.length;
		var b = reverse.length - imax1;
		if(!(j < (a < b ? a : b))) {
			break;
		}
		var value = champuru_perl_PerlChampuruReimplementation.inter(forward.charAt(j),reverse.charAt(j + (imax1 < 0 ? imax1 : 0) + (imax1 > 0 ? imax1 : 0)));
		seq1_.h[j + (imax1 < 0 ? imax1 : 0)] = value;
		++j;
	}
	j = -(imax2 < 0 ? imax2 : 0);
	while(true) {
		var a = forward.length;
		var b = reverse.length - imax2;
		if(!(j < (a < b ? a : b))) {
			break;
		}
		var value = champuru_perl_PerlChampuruReimplementation.inter(forward.charAt(j),reverse.charAt(j + (imax2 < 0 ? imax2 : 0) + (imax2 > 0 ? imax2 : 0)));
		seq2_.h[j + (imax2 < 0 ? imax2 : 0)] = value;
		++j;
	}
	var incomp = 0;
	var k = seq1_.keys();
	while(k.hasNext()) {
		var k1 = k.next();
		var r = seq1_.h[k1];
		if(r == "_") {
			++incomp;
		}
	}
	var k = seq2_.keys();
	while(k.hasNext()) {
		var k1 = k.next();
		var r = seq2_.h[k1];
		if(r == "_") {
			++incomp;
		}
	}
	var seq1 = champuru_perl_PerlChampuruReimplementation.stringifyIntMap(seq1_);
	var seq2 = champuru_perl_PerlChampuruReimplementation.stringifyIntMap(seq2_);
	if(incomp > 0) {
		result.print("First reconstructed sequence: ");
		result.print(seq1);
		result.print("\n");
		result.print("Second reconstructed sequence: ");
		result.print(seq2);
		result.print("\n");
	}
	if(incomp == 1) {
		result.print("There is 1 incompatible position (indicated with an underscore), please check the input sequences.\n");
		return result;
	}
	if(incomp > 1) {
		result.print("There are " + incomp + " incompatible positions (indicated with underscores), please check the input sequences.\n");
		return result;
	}
	var seq1rev = champuru_perl_PerlChampuruReimplementation.reverseString(seq1);
	var seq2rev = champuru_perl_PerlChampuruReimplementation.reverseString(seq2);
	var reverserev = champuru_perl_PerlChampuruReimplementation.reverseString(reverse);
	var a = forward.length - 1 - (reverse.length - 1) + imax1;
	var a1 = forward.length - 1 - (reverse.length - 1) + imax2;
	var a2 = (a < 0 ? a : 0) - (a1 < 0 ? a1 : 0);
	seq1rev = champuru_perl_PerlChampuruReimplementation.splice(seq1rev,0,a2 > 0 ? a2 : 0);
	var a = forward.length - 1 - (reverse.length - 1) + imax2;
	var a1 = forward.length - 1 - (reverse.length - 1) + imax1;
	var a2 = (a < 0 ? a : 0) - (a1 < 0 ? a1 : 0);
	seq2rev = champuru_perl_PerlChampuruReimplementation.splice(seq2rev,0,a2 > 0 ? a2 : 0);
	var a = forward.length - 1 - (reverse.length - 1) + (imax1 < imax2 ? imax1 : imax2);
	var cutreverserev = -(a < 0 ? a : 0);
	reverserev = champuru_perl_PerlChampuruReimplementation.splice(reverserev,0,cutreverserev);
	seq1 = champuru_perl_PerlChampuruReimplementation.reverseString(seq1rev);
	seq2 = champuru_perl_PerlChampuruReimplementation.reverseString(seq2rev);
	reverse = champuru_perl_PerlChampuruReimplementation.reverseString(reverserev);
	var a = (imax1 < 0 ? imax1 : 0) - (imax2 < 0 ? imax2 : 0);
	seq1 = champuru_perl_PerlChampuruReimplementation.splice(seq1,0,a > 0 ? a : 0);
	var a = (imax2 < 0 ? imax2 : 0) - (imax1 < 0 ? imax1 : 0);
	seq2 = champuru_perl_PerlChampuruReimplementation.splice(seq2,0,a > 0 ? a : 0);
	var a = imax1 < imax2 ? imax1 : imax2;
	var cutforward = -(a < 0 ? a : 0);
	forward = champuru_perl_PerlChampuruReimplementation.splice(forward,0,cutforward);
	var _g = 0;
	while(_g < 3) {
		var i = _g++;
		var _g1 = 0;
		var a = seq1.length;
		var b = seq2.length;
		var _g2 = a < b ? a : b;
		while(_g1 < _g2) {
			var j = _g1++;
			if(seq1.charAt(j) != seq2.charAt(j)) {
				if(champuru_perl_PerlChampuruReimplementation.comp(seq1.charAt(j),seq2.charAt(j)) == 1) {
					if(champuru_perl_PerlChampuruReimplementation.code.h[seq1.charAt(j)] > champuru_perl_PerlChampuruReimplementation.code.h[seq2.charAt(j)]) {
						seq1 = champuru_perl_PerlChampuruReimplementation.replaceCharInString(seq1,j,champuru_perl_PerlChampuruReimplementation.rev_code.h[champuru_perl_PerlChampuruReimplementation.code.h[seq1.charAt(j)] - champuru_perl_PerlChampuruReimplementation.code.h[seq2.charAt(j)]]);
					} else {
						seq2 = champuru_perl_PerlChampuruReimplementation.replaceCharInString(seq2,j,champuru_perl_PerlChampuruReimplementation.rev_code.h[champuru_perl_PerlChampuruReimplementation.code.h[seq2.charAt(j)] - champuru_perl_PerlChampuruReimplementation.code.h[seq1.charAt(j)]]);
					}
				}
			}
			if(seq1.charAt(seq1.length - 1 - j) != seq2.charAt(seq2.length - 1 - j)) {
				if(champuru_perl_PerlChampuruReimplementation.comp(seq1.charAt(seq1.length - 1 - j),seq2.charAt(seq2.length - 1 - j)) == 1) {
					if(champuru_perl_PerlChampuruReimplementation.code.h[seq1.charAt(seq1.length - 1 - j)] > champuru_perl_PerlChampuruReimplementation.code.h[seq2.charAt(seq2.length - 1 - j)]) {
						seq1 = champuru_perl_PerlChampuruReimplementation.replaceCharInString(seq1,seq1.length - 1 - j,champuru_perl_PerlChampuruReimplementation.rev_code.h[champuru_perl_PerlChampuruReimplementation.code.h[seq1.charAt(seq1.length - 1 - j)] - champuru_perl_PerlChampuruReimplementation.code.h[seq2.charAt(seq2.length - 1 - j)]]);
					} else {
						seq2 = champuru_perl_PerlChampuruReimplementation.replaceCharInString(seq2,seq2.length - 1 - j,champuru_perl_PerlChampuruReimplementation.rev_code.h[champuru_perl_PerlChampuruReimplementation.code.h[seq2.charAt(seq2.length - 1 - j)] - champuru_perl_PerlChampuruReimplementation.code.h[seq1.charAt(seq1.length - 1 - j)]]);
					}
				}
			}
		}
	}
	result.print("First reconstructed sequence: ");
	result.print(seq1);
	result.print("\n");
	result.print("Second reconstructed sequence: ");
	result.print(seq2);
	result.print("\n");
	var tocheck = new haxe_ds_List();
	tocheck.add("s");
	var _g = 0;
	var a = seq1.length;
	var b = seq2.length;
	var _g1 = a < b ? a : b;
	while(_g < _g1) {
		var j = _g++;
		if(champuru_perl_PerlChampuruReimplementation.code.h[forward.charAt(j)] != (champuru_perl_PerlChampuruReimplementation.code.h[seq1.charAt(j)] | champuru_perl_PerlChampuruReimplementation.code.h[seq2.charAt(j)])) {
			tocheck.add("" + (j + cutforward + 1));
		}
	}
	var ftocheck = tocheck.length - 1;
	if(tocheck.length - 1 > 0) {
		result.print("Check position");
		if(tocheck.length - 1 == 1) {
			result.print(" " + tocheck.last() + " ");
		} else {
			var _g7_head = tocheck.h;
			while(_g7_head != null) {
				var val = _g7_head.item;
				_g7_head = _g7_head.next;
				var r = val;
				result.print(r + " ");
			}
		}
		result.print("on the forward chromatogram.\n");
	}
	tocheck.clear();
	tocheck.add("s");
	var _g = 0;
	var a = seq1.length;
	var b = seq2.length;
	var _g1 = a < b ? a : b;
	while(_g < _g1) {
		var j = _g++;
		if(champuru_perl_PerlChampuruReimplementation.code.h[reverse.charAt(reverse.length - 1 - j)] != (champuru_perl_PerlChampuruReimplementation.code.h[seq1.charAt(seq1.length - 1 - j)] | champuru_perl_PerlChampuruReimplementation.code.h[seq2.charAt(seq2.length - 1 - j)])) {
			if(!opt_c) {
				tocheck.add("" + (1 + reverse.length - 1 - j));
			} else {
				tocheck.add("" + (j + cutreverserev + 1));
			}
		}
	}
	var rtocheck = tocheck.length - 1;
	if(tocheck.length - 1 > 0) {
		result.print("Check position");
		if(tocheck.length - 1 == 1) {
			result.print(" " + tocheck.last() + " ");
		} else {
			if(!opt_c) {
				var tocheck_ = new haxe_ds_List();
				var _g9_head = tocheck.h;
				while(_g9_head != null) {
					var val = _g9_head.item;
					_g9_head = _g9_head.next;
					var e = val;
					if(e == "s") {
						continue;
					}
					tocheck_.push(e);
				}
				tocheck_.push("s");
				tocheck = tocheck_;
			}
			var _g9_head = tocheck.h;
			while(_g9_head != null) {
				var val = _g9_head.item;
				_g9_head = _g9_head.next;
				var r = val;
				result.print(r + " ");
			}
		}
		result.print("on the reverse chromatogram.\n");
	}
	if(ftocheck + rtocheck < 1) {
		result.print("The two sequences that were mixed in the forward and reverse chromatograms have been successfully deconvoluted.\n");
	}
	result.index1 = imax1;
	result.index2 = imax2;
	result.index3 = imax3;
	result.sequence1 = seq1;
	result.sequence2 = seq2;
	return result;
};
var champuru_perl_PerlChampuruResult = function() {
	this.mOutput = new haxe_ds_List();
};
champuru_perl_PerlChampuruResult.__name__ = true;
champuru_perl_PerlChampuruResult.prototype = {
	print: function(s) {
		this.mOutput.add(s);
	}
	,getOutput: function() {
		return this.mOutput.join("");
	}
	,__class__: champuru_perl_PerlChampuruResult
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
	keys: function() {
		var a = [];
		for( var key in this.h ) if(this.h.hasOwnProperty(key)) a.push(+key);
		return new haxe_iterators_ArrayIterator(a);
	}
	,__class__: haxe_ds_IntMap
};
var haxe_ds__$List_ListNode = function(item,next) {
	this.item = item;
	this.next = next;
};
haxe_ds__$List_ListNode.__name__ = true;
haxe_ds__$List_ListNode.prototype = {
	__class__: haxe_ds__$List_ListNode
};
var haxe_ds_StringMap = function() {
	this.h = Object.create(null);
};
haxe_ds_StringMap.__name__ = true;
haxe_ds_StringMap.__interfaces__ = [haxe_IMap];
haxe_ds_StringMap.prototype = {
	__class__: haxe_ds_StringMap
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
if( String.fromCodePoint == null ) String.fromCodePoint = function(c) { return c < 0x10000 ? String.fromCharCode(c) : String.fromCharCode((c>>10)+0xD7C0)+String.fromCharCode((c&0x3FF)+0xDC00); }
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
champuru_Worker.mMsgs = new haxe_ds_List();
champuru_perl_PerlChampuruReimplementation.bases = ["A","T","G","C","R","Y","M","K","W","S","V","B","H","D","N"];
champuru_perl_PerlChampuruReimplementation.complement = (function($this) {
	var $r;
	var _g = new haxe_ds_StringMap();
	_g.h["A"] = "T";
	_g.h["T"] = "A";
	_g.h["G"] = "C";
	_g.h["C"] = "G";
	_g.h["R"] = "Y";
	_g.h["Y"] = "R";
	_g.h["M"] = "K";
	_g.h["K"] = "M";
	_g.h["W"] = "W";
	_g.h["S"] = "S";
	_g.h["V"] = "B";
	_g.h["B"] = "V";
	_g.h["H"] = "D";
	_g.h["D"] = "H";
	_g.h["N"] = "N";
	$r = _g;
	return $r;
}(this));
champuru_perl_PerlChampuruReimplementation.code = (function($this) {
	var $r;
	var _g = new haxe_ds_StringMap();
	_g.h["A"] = 1;
	_g.h["T"] = 2;
	_g.h["G"] = 4;
	_g.h["C"] = 8;
	_g.h["R"] = 5;
	_g.h["Y"] = 10;
	_g.h["M"] = 9;
	_g.h["K"] = 6;
	_g.h["W"] = 3;
	_g.h["S"] = 12;
	_g.h["V"] = 13;
	_g.h["B"] = 14;
	_g.h["H"] = 11;
	_g.h["D"] = 7;
	_g.h["N"] = 15;
	$r = _g;
	return $r;
}(this));
champuru_perl_PerlChampuruReimplementation.rev_code = (function($this) {
	var $r;
	var _g = new haxe_ds_IntMap();
	_g.h[1] = "A";
	_g.h[2] = "T";
	_g.h[4] = "G";
	_g.h[8] = "C";
	_g.h[5] = "R";
	_g.h[10] = "Y";
	_g.h[9] = "M";
	_g.h[3] = "W";
	_g.h[12] = "S";
	_g.h[6] = "K";
	_g.h[13] = "V";
	_g.h[14] = "B";
	_g.h[11] = "H";
	_g.h[7] = "D";
	_g.h[15] = "N";
	$r = _g;
	return $r;
}(this));
champuru_Worker.main();
})(typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this);

(function ($global) { "use strict";
var $estr = function() { return js_Boot.__string_rec(this,''); },$hxEnums = $hxEnums || {},$_;
function $extend(from, fields) {
	var proto = Object.create(from);
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
var HxOverrides = function() { };
HxOverrides.__name__ = true;
HxOverrides.now = function() {
	return Date.now();
};
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
StringTools.replace = function(s,sub,by) {
	return s.split(sub).join(by);
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
champuru_Worker.timeToStr = function(f) {
	return "" + Math.round(f * 1000);
};
champuru_Worker.formatFloat = function(f) {
	var number = f * Math.pow(10,3);
	return "" + Math.round(number) / Math.pow(10,3);
};
champuru_Worker.generateHtml = function(fwd,rev,scoreCalculationMethod,iOffset,jOffset,useThisOffsets,searchForAlternativeSolutions) {
	champuru_Worker.mMsgs.clear();
	champuru_Worker.out("<fieldset>");
	champuru_Worker.out("<legend>Input</legend>");
	champuru_Worker.out("<p>Forward sequence of length " + fwd.length + ": <span id='input1' class='sequence'>");
	champuru_Worker.out(fwd);
	champuru_Worker.out("</p><p>Reverse sequence of length " + rev.length + ": <span id='input2' class='sequence'>");
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
	var timestamp = HxOverrides.now() / 1000;
	champuru_Worker.out("<legend>Output of the original Champuru 1.0 program</legend>");
	champuru_Worker.out("<span id='champuruOutput' style='font-family: monospace; word-break: break-all; display: none;'>");
	var perlReimplementationOutput = champuru_perl_PerlChampuruReimplementation.runChampuru(fwd,rev,false);
	var output = perlReimplementationOutput.getOutput();
	output = StringTools.htmlEscape(output);
	output = StringTools.replace(output,"\n","<br/>");
	champuru_Worker.out(output);
	champuru_Worker.out("</span>");
	champuru_Worker.out("<span class='middle'><button id='showLink' onclick='document.getElementById(\"champuruOutput\").style.display = \"block\";document.getElementById(\"showLink\").style.display = \"none\";'>Show output</button></span>");
	champuru_Worker.out("<div class='timelegend'>Calculation took " + ("" + Math.round((HxOverrides.now() / 1000 - timestamp) * 1000)) + "ms</div>");
	champuru_Worker.out("</fieldset>");
	champuru_Worker.out("<br>");
	var s1 = champuru_base_NucleotideSequence.fromString(fwd);
	var s2 = champuru_base_NucleotideSequence.fromString(rev);
	var timestamp = HxOverrides.now() / 1000;
	var lst = champuru_score_ScoreCalculatorList.instance();
	var calculator = lst.getScoreCalculator(scoreCalculationMethod);
	var scores = calculator.calcOverlapScores(s1,s2);
	var sortedScores = new champuru_score_ScoreSorter().sort(scores);
	var ge = new champuru_score_GumbelDistributionEstimator(s1,s2);
	var scores1 = new haxe_ds_List();
	var _g = 0;
	while(_g < 20) {
		var i = _g++;
		var _g1 = 0;
		while(_g1 < 100) {
			var j = _g1++;
			var s = ge.mSeq1;
			var copySequence = new haxe_ds_List();
			var sLen = s.mLength;
			var _g2 = 0;
			var _g3 = sLen;
			while(_g2 < _g3) {
				var i1 = _g2++;
				var randomPos = Math.floor(Math.random() * sLen);
				if(!(0 <= randomPos && randomPos < s.mLength)) {
					throw haxe_Exception.thrown("Position " + randomPos + " out of range [0," + s.mLength + "(");
				}
				var newNN = s.mSequence.h[randomPos];
				copySequence.add(newNN);
			}
			var result = new champuru_base_NucleotideSequence(copySequence);
			var randomFwd = result;
			var s3 = ge.mSeq2;
			var copySequence1 = new haxe_ds_List();
			var sLen1 = s3.mLength;
			var _g4 = 0;
			var _g5 = sLen1;
			while(_g4 < _g5) {
				var i2 = _g4++;
				var randomPos1 = Math.floor(Math.random() * sLen1);
				if(!(0 <= randomPos1 && randomPos1 < s3.mLength)) {
					throw haxe_Exception.thrown("Position " + randomPos1 + " out of range [0," + s3.mLength + "(");
				}
				var newNN1 = s3.mSequence.h[randomPos1];
				copySequence1.add(newNN1);
			}
			var result1 = new champuru_base_NucleotideSequence(copySequence1);
			var randomRev = result1;
			var a = -randomFwd.mLength;
			var b = randomRev.mLength;
			var result2 = 0;
			var rand = Math.random();
			if(rand > 0.5) {
				result2 = Math.floor(a * Math.random());
			} else {
				result2 = Math.floor(b * Math.random());
			}
			var randPos = result2;
			var score = calculator.calcScore(randPos,randomFwd,randomRev);
			scores1.add(score.score);
		}
	}
	var summe = 0.0;
	var _g_head = scores1.h;
	while(_g_head != null) {
		var val = _g_head.item;
		_g_head = _g_head.next;
		var score = val;
		summe += score;
	}
	var mean = summe / scores1.length;
	var summe = 0.0;
	var _g_head = scores1.h;
	while(_g_head != null) {
		var val = _g_head.item;
		_g_head = _g_head.next;
		var score = val;
		var diff = score - mean;
		summe += diff * diff;
	}
	var deviation = Math.sqrt(summe / (scores1.length - 1));
	var beta = Math.sqrt(6) * deviation / Math.PI;
	var mu = mean - champuru_score_GumbelDistribution.eulerMascheroniConst * beta;
	var distribution = new champuru_score_GumbelDistribution(mu,beta);
	var sortedScoresStringList = new haxe_ds_List();
	sortedScoresStringList.add("#\tOffset\tScore\tMatches\tMismatches\tP(score)\tP(higher score)");
	var i = 1;
	var _g = 0;
	while(_g < sortedScores.length) {
		var score = sortedScores[_g];
		++_g;
		var z = (score.score - distribution.mMu) / distribution.mBeta;
		var s = -(score.score - distribution.mMu) / distribution.mBeta;
		sortedScoresStringList.add(i + "\t" + score.index + "\t" + score.score + "\t" + score.matches + "\t" + score.mismatches + "\t" + 1.0 / distribution.mBeta * Math.exp(-(z + Math.exp(-z))) + "\t" + (1 - Math.exp(-Math.exp(s))));
		++i;
	}
	var sortedScoresString = sortedScoresStringList.join("\n");
	var sortedScoresStringB64 = haxe_crypto_Base64.encode(haxe_io_Bytes.ofString(sortedScoresString));
	var vis = new champuru_score_ScoreListVisualizer(scores,sortedScores);
	var scorePlot = vis.genScorePlot();
	var histPlot = vis.genScorePlotHist(distribution);
	champuru_Worker.out("<fieldset>");
	champuru_Worker.out("<legend>1. Step - Compatibility score calculation</legend>");
	champuru_Worker.out("<p>The following table [<a href-lang='text/tsv' title='table.tsv' href='data:text/tsv;base64,\n");
	champuru_Worker.out(sortedScoresStringB64);
	champuru_Worker.out("' title='table.tsv' download='table.tsv'>Download</a>] lists the best compatibility scores and their positions:</p>");
	champuru_Worker.out("<table class='scoreTable center'>");
	champuru_Worker.out("<tr class='header'>");
	champuru_Worker.out("<td>#</td><td>Offset</td><td>Score</td><td>Matches</td><td>Mismatches</td><td>P(score)</td><td>P(higher score)</td>");
	champuru_Worker.out("</tr>");
	var i = 1;
	var _g = 0;
	while(_g < sortedScores.length) {
		var score = sortedScores[_g];
		++_g;
		champuru_Worker.out("<tr class='" + (i % 2 == 0 ? "odd" : "even") + "' onmouseover='highlight(\"c" + score.index + "\")' onmouseout='removeHighlight(\"c" + score.index + "\")'>");
		var z = (score.score - distribution.mMu) / distribution.mBeta;
		var number = 1.0 / distribution.mBeta * Math.exp(-(z + Math.exp(-z))) * Math.pow(10,3);
		var s = -(score.score - distribution.mMu) / distribution.mBeta;
		var number1 = (1 - Math.exp(-Math.exp(s))) * Math.pow(10,3);
		champuru_Worker.out("<td>" + i + "</td><td>" + score.index + "</td><td>" + score.score + "</td><td>" + score.matches + "</td><td>" + score.mismatches + "</td><td>" + ("" + Math.round(number) / Math.pow(10,3)) + "</td><td>" + ("" + Math.round(number1) / Math.pow(10,3)) + "</td>");
		champuru_Worker.out("</tr>");
		++i;
		if(i >= 6) {
			break;
		}
	}
	champuru_Worker.out("</table>");
	champuru_Worker.out("<p>Here is a plot of the shift calculation result:</p>");
	champuru_Worker.out(scorePlot);
	champuru_Worker.out("<p>Warning: Close points may be overlapping!</p>");
	champuru_Worker.out("<p>And as histogram:</p>");
	champuru_Worker.out(histPlot);
	var score1 = sortedScores[0].index;
	var score2 = sortedScores[1].index;
	if(useThisOffsets) {
		score1 = iOffset;
		score2 = jOffset;
	}
	if(useThisOffsets) {
		champuru_Worker.out("<p>User requested to use the offsets " + iOffset + " and " + jOffset + " for calculation.</p>");
	} else {
		champuru_Worker.out("<p>Using offsets " + score1 + " and " + score2 + " for calculation.</p>");
	}
	champuru_Worker.out("<span class='middle'><button onclick='rerunAnalysisWithDifferentOffsets(\"" + fwd + "\", \"" + rev + "\", " + scoreCalculationMethod + ")'>Use different offsets</button></span>");
	champuru_Worker.out("<div class='timelegend'>Calculation took " + ("" + Math.round((HxOverrides.now() / 1000 - timestamp) * 1000)) + "ms</div>");
	champuru_Worker.out("</fieldset>");
	champuru_Worker.out("<br>");
	var timestamp = HxOverrides.now() / 1000;
	var o1 = new champuru_consensus_OverlapSolver(score1,s1,s2).solve();
	var o2 = new champuru_consensus_OverlapSolver(score2,s1,s2).solve();
	champuru_Worker.out("<fieldset>");
	champuru_Worker.out("<legend>2. Step - Calculate consensus sequences</legend>");
	champuru_Worker.out("<p>First consensus sequence: <span id='consensus1' class='sequence'>");
	var result = new haxe_ds_List();
	var _g = 0;
	var _g1 = o1.mLength;
	while(_g < _g1) {
		var i = _g++;
		var c = o1.mSequence.h[i];
		var s = c.toIUPACCode();
		result.add(s);
	}
	champuru_Worker.out(result.join(""));
	champuru_Worker.out("</span></p>");
	champuru_Worker.out("<p>Second consensus sequence: <span id='consensus2' class='sequence'>");
	var result = new haxe_ds_List();
	var _g = 0;
	var _g1 = o2.mLength;
	while(_g < _g1) {
		var i = _g++;
		var c = o2.mSequence.h[i];
		var s = c.toIUPACCode();
		result.add(s);
	}
	champuru_Worker.out(result.join(""));
	champuru_Worker.out("</span></p>");
	var problems = o1.countGaps() + o2.countGaps();
	var remainingAmbFwd = o1.countPolymorphisms();
	var remainingAmbRev = o2.countPolymorphisms();
	if(problems == 1) {
		champuru_Worker.out("<p>There is 1 incompatible position (indicated with an underscore), please check the input sequences.</p>");
	} else if(problems > 1) {
		champuru_Worker.out("<p>There are " + problems + " incompatible positions (indicated with underscores), please check the input sequences.</p>");
	}
	if(problems > 0) {
		champuru_Worker.out("<span class='middle'><button onclick='colorConsensusByIncompatiblePositions()'>Color underscores</button><button onclick='removeColor()'>Remove color</button></span>");
	}
	if(remainingAmbFwd == 1) {
		champuru_Worker.out("<p>There is 1 ambiguity in the first consensus sequence.</p>");
	} else if(remainingAmbFwd > 1) {
		champuru_Worker.out("<p>There are " + remainingAmbFwd + " ambiguities in the first consensus sequence.</p>");
	}
	if(remainingAmbRev == 1) {
		champuru_Worker.out("<p>There is 1 ambiguity in the second consensus sequence.</p>");
	} else if(remainingAmbRev > 1) {
		champuru_Worker.out("<p>There are " + remainingAmbRev + " ambiguities in the second consensus sequence.</p>");
	}
	if(remainingAmbFwd + remainingAmbRev > 0) {
		champuru_Worker.out("<span class='middle'><button onclick='colorConsensusByAmbPositions()'>Color ambiguities</button><button onclick='removeColor()'>Remove color</button></span>");
	}
	champuru_Worker.out("<div class='timelegend'>Calculation took " + ("" + Math.round((HxOverrides.now() / 1000 - timestamp) * 1000)) + "ms</div>");
	champuru_Worker.out("</fieldset>");
	champuru_Worker.out("<br>");
	if(problems > 0) {
		return { result : champuru_Worker.mMsgs.join("")};
	}
	var timestamp = HxOverrides.now() / 1000;
	var result = champuru_reconstruction_SequenceReconstructor.reconstruct(o1,o2);
	champuru_Worker.out("<fieldset>");
	champuru_Worker.out("<legend>3. Step - Sequence reconstruction</legend>");
	champuru_Worker.out("<p>First reconstructed sequence [<a href='#' onclick='return toClipboard(\"reconstructed1\")'>Copy all bases to clipboard</a>] [<a href='#' onclick='return toClipboard(\"reconstructed1\", false)'>Copy only overlap between the two chromatograms (in capital letters) to clipboard</a>]: <span id='reconstructed1' class='sequence'>");
	var _this = result.seq1;
	var result1 = new haxe_ds_List();
	var _g = 0;
	var _g1 = _this.mLength;
	while(_g < _g1) {
		var i = _g++;
		var c = _this.mSequence.h[i];
		var s = c.toIUPACCode();
		result1.add(s);
	}
	champuru_Worker.out(result1.join(""));
	champuru_Worker.out("</span></p>");
	champuru_Worker.out("<p>Second reconstructed sequence [<a href='#' onclick='return toClipboard(\"reconstructed2\")'>Copy all bases to clipboard</a>] [<a href='#' onclick='return toClipboard(\"reconstructed2\", false)'>Copy only overlap between the two chromatograms (in capital letters) to clipboard</a>]: <span id='reconstructed2' class='sequence'>");
	var _this = result.seq2;
	var result1 = new haxe_ds_List();
	var _g = 0;
	var _g1 = _this.mLength;
	while(_g < _g1) {
		var i = _g++;
		var c = _this.mSequence.h[i];
		var s = c.toIUPACCode();
		result1.add(s);
	}
	champuru_Worker.out(result1.join(""));
	champuru_Worker.out("</span></p>");
	champuru_Worker.out("<div class='timelegend'>Calculation took " + ("" + Math.round((HxOverrides.now() / 1000 - timestamp) * 1000)) + "ms</div>");
	champuru_Worker.out("</fieldset>");
	champuru_Worker.out("<br>");
	var timestamp = HxOverrides.now() / 1000;
	champuru_Worker.out("<fieldset>");
	champuru_Worker.out("<legend>4. Step - Checking sequences</legend>");
	var successfullyDeconvoluted = true;
	problems = result.seq1.countGaps() + result.seq2.countGaps();
	if(problems != 0) {
		if(problems == 1) {
			champuru_Worker.out("<p>There is 1 problematic position!</p>");
			successfullyDeconvoluted = false;
		} else if(problems > 1) {
			champuru_Worker.out("<p>There are " + problems + " problematic positions!</p>");
			successfullyDeconvoluted = false;
		}
	}
	if(problems > 0) {
		champuru_Worker.out("<span class='middle'><button onclick='colorProblems()'>Color problems</button><button onclick='removeColorFinal()'>Remove color</button></span>");
	}
	var p1 = result.seq1.countPolymorphisms();
	var p2 = result.seq2.countPolymorphisms();
	var p1u = result.seq1.countPolymorphisms(0.8);
	var p2u = result.seq2.countPolymorphisms(0.8);
	var p1l = p1 - p1u;
	var p2l = p2 - p2u;
	if(p1u + p2u != 0) {
		if(p1u > 0) {
			champuru_Worker.out("<p>There " + (p1u == 1 ? "is" : "are") + " " + p1u + " ambiguit" + (p1u == 1 ? "y" : "ies") + " on the first reconstructed sequence left!</p>");
			successfullyDeconvoluted = false;
		}
		if(p1l > 0) {
			champuru_Worker.out("<p>" + p1l + " ambiguit" + (p1l == 1 ? "y" : "ies") + " remain in the first reconstructed sequence in places where the two chromatograms do not overlap.</p>");
		}
		if(p2u > 0) {
			champuru_Worker.out("<p>There " + (p2u == 1 ? "is" : "are") + " " + p2u + " ambiguit" + (p2u == 1 ? "y" : "ies") + " on the second reconstructed sequence left!</p>");
			successfullyDeconvoluted = false;
		}
		if(p2l > 0) {
			champuru_Worker.out("<p>" + p2l + " ambiguit" + (p2l == 1 ? "y" : "ies") + " remain in the first reconstructed sequence in places where the two chromatograms do not overlap.</p>");
		}
	}
	if(p1 + p2 > 0) {
		champuru_Worker.out("<span class='middle'><button onclick='colorFinalByAmbPositions()'>Color ambiguities</button><button onclick='removeColorFinal()'>Remove color</button></span>");
		champuru_Worker.out("<br>");
	}
	var seqChecker = new champuru_reconstruction_SequenceChecker(s1,s2);
	seqChecker.setOffsets(score1,score2);
	var checkerResult = seqChecker.check(result.seq1,result.seq2);
	if(checkerResult.pF.length + checkerResult.pR.length >= 1) {
		champuru_Worker.out("<p>");
		if(checkerResult.pF.length > 0) {
			champuru_Worker.out("Check position" + (checkerResult.pF.length == 1 ? "" : "s") + " on forward (and/or the facing positions on the reverse): <span class='sequence'>" + checkerResult.pF.join(",") + "</span>");
		}
		if(checkerResult.pF.length > 0 && checkerResult.pR.length > 0) {
			champuru_Worker.out("<br>");
		}
		if(checkerResult.pR.length > 0) {
			champuru_Worker.out("Check position" + (checkerResult.pR.length == 1 ? "" : "s") + " on reverse (and/or the facing positions on the forward): <span class='sequence'>" + checkerResult.pR.join(",") + "</span>");
		}
		champuru_Worker.out("</p>");
		successfullyDeconvoluted = false;
	}
	if(checkerResult.pF.length + checkerResult.pR.length > 0) {
		champuru_Worker.out("<span class='middle'><button onclick='colorFinalByPositions(\"" + checkerResult.pF.join(",") + "\", \"" + checkerResult.pR.join(",") + "\", \"" + checkerResult.pFHighlight.join(",") + "\", \"" + checkerResult.pRHighlight.join(",") + "\");'>Color positions</button><button onclick='removeColorFinal()'>Remove color</button></span>");
		champuru_Worker.out("<br>");
	}
	if(successfullyDeconvoluted && p1u + p2u == 0) {
		if(p1l + p2l == 0) {
			champuru_Worker.out("<p>The bases overlapping in the forward and reverse chromatograms have been successfully deconvoluted.</p>");
		} else if(p1l > 0 && p2l > 0) {
			champuru_Worker.out("<p>The bases overlapping in the forward and reverse chromatograms have been successfully deconvoluted. However " + p1l + " ambiguit" + (p1l == 1 ? "y" : "ies") + " remain in the first reconstructed sequence in places where the two chromatograms do not overlap and " + p2l + " ambiguit" + (p2l == 1 ? "y" : "ies") + " remain in the second reconstructed sequence in places where the two chromatograms do not overlap.</p>");
		} else {
			champuru_Worker.out("<p>The bases overlapping in the forward and reverse chromatograms have been successfully deconvoluted. However " + (p1l + p2l) + " ambiguit" + (p1l + p2l == 1 ? "y" : "ies") + " remain in the " + (p1l > 0 ? "first" : "second") + " reconstructed sequence in places where the two chromatograms do not overlap.</p>");
		}
	}
	var firstSequenceIsSame;
	var _this = result.seq1;
	var result1 = new haxe_ds_List();
	var _g = 0;
	var _g1 = _this.mLength;
	while(_g < _g1) {
		var i = _g++;
		var c = _this.mSequence.h[i];
		var s = c.toIUPACCode();
		result1.add(s);
	}
	if(result1.join("").indexOf(perlReimplementationOutput.sequence1) == -1) {
		var _this = result.seq1;
		var result1 = new haxe_ds_List();
		var _g = 0;
		var _g1 = _this.mLength;
		while(_g < _g1) {
			var i = _g++;
			var c = _this.mSequence.h[i];
			var s = c.toIUPACCode();
			result1.add(s);
		}
		firstSequenceIsSame = result1.join("").indexOf(perlReimplementationOutput.sequence2) != -1;
	} else {
		firstSequenceIsSame = true;
	}
	var secondSequenceIsSame;
	var _this = result.seq2;
	var result1 = new haxe_ds_List();
	var _g = 0;
	var _g1 = _this.mLength;
	while(_g < _g1) {
		var i = _g++;
		var c = _this.mSequence.h[i];
		var s = c.toIUPACCode();
		result1.add(s);
	}
	if(result1.join("").indexOf(perlReimplementationOutput.sequence1) == -1) {
		var _this = result.seq2;
		var result = new haxe_ds_List();
		var _g = 0;
		var _g1 = _this.mLength;
		while(_g < _g1) {
			var i = _g++;
			var c = _this.mSequence.h[i];
			var s = c.toIUPACCode();
			result.add(s);
		}
		secondSequenceIsSame = result.join("").indexOf(perlReimplementationOutput.sequence2) != -1;
	} else {
		secondSequenceIsSame = true;
	}
	if(!firstSequenceIsSame || !secondSequenceIsSame) {
		var idx1Same = perlReimplementationOutput.index1 == score1 || perlReimplementationOutput.index1 == score2;
		var idx2Same = perlReimplementationOutput.index2 == score1 || perlReimplementationOutput.index2 == score2;
		if(idx1Same && idx2Same) {
			champuru_Worker.out("<p>The deconvoluted sequences from the (reimplemented) original Champuru program mismatches with the deconvoluted sequences from this program although the same offsets have been used. If you find this in a real life example please send your chromatograms to <a href='mailto: jflot@ulb.ac.be'>jflot@ulb.be</a>.</p>");
		} else {
			champuru_Worker.out("<p>The deconvoluted sequences from the (reimplemented) original Champuru program mismatches with the deconvoluted sequences from this program because different offsets have been used.<p>");
		}
	}
	champuru_Worker.out("<div class='timelegend'>Calculation took " + ("" + Math.round((HxOverrides.now() / 1000 - timestamp) * 1000)) + "ms</div>");
	champuru_Worker.out("</fieldset>");
	champuru_Worker.out("<br>");
	if(searchForAlternativeSolutions) {
		var timestamp = HxOverrides.now() / 1000;
		champuru_Worker.out("<fieldset>");
		champuru_Worker.out("<legend>5. Step - Analyzing further offset pairs</legend>");
		var possibleMatches = new haxe_ds_List();
		var i = 0;
		var _g = 0;
		while(_g < sortedScores.length) {
			var score = sortedScores[_g];
			++_g;
			if(i > 5) {
				break;
			}
			++i;
			if(score.mismatches <= 10) {
				possibleMatches.add(score.index);
			}
		}
		var possibilities = new haxe_ds_List();
		var _g3_head = possibleMatches.h;
		while(_g3_head != null) {
			var val = _g3_head.item;
			_g3_head = _g3_head.next;
			var p1 = val;
			var _g3_head1 = possibleMatches.h;
			while(_g3_head1 != null) {
				var val1 = _g3_head1.item;
				_g3_head1 = _g3_head1.next;
				var p2 = val1;
				if(p1 > p2) {
					if(!(p1 == score1 && p2 == score2 || p2 == score1 && p1 == score2)) {
						possibilities.add({ a : p1, b : p2});
					}
				}
			}
		}
		var scores = [];
		var _g4_head = possibilities.h;
		while(_g4_head != null) {
			var val = _g4_head.item;
			_g4_head = _g4_head.next;
			var p = val;
			var o1 = new champuru_consensus_OverlapSolver(p.a,s1,s2).solve();
			var o2 = new champuru_consensus_OverlapSolver(p.b,s1,s2).solve();
			var result2 = champuru_reconstruction_SequenceReconstructor.reconstruct(o1,o2);
			var seqChecker2 = new champuru_reconstruction_SequenceChecker(s1,s2);
			seqChecker2.setOffsets(p.a,p.b);
			var checkerResult2 = seqChecker2.check(result2.seq1,result2.seq2);
			var score = { score : checkerResult2.pF.length + checkerResult2.pR.length + result2.seq1.countGaps() + result2.seq2.countGaps(), idx1 : p.a, idx2 : p.b, pF : checkerResult2.pF.length, pR : checkerResult2.pR.length, p : result2.seq1.countGaps() + result2.seq2.countGaps()};
			scores.push(score);
		}
		scores.sort(function(a,b) {
			return a.score - b.score;
		});
		champuru_Worker.out("<table class='offsetTable center'>");
		champuru_Worker.out("<tr class='header'>");
		champuru_Worker.out("<td>#</td><td>Nr. of issues</td><td>Offset 1</td><td>Offset 2</td><td>Use</td>");
		champuru_Worker.out("</tr>");
		var i = 1;
		var _g = 0;
		while(_g < scores.length) {
			var score = scores[_g];
			++_g;
			champuru_Worker.out("<tr class='" + (i % 2 == 0 ? "odd" : "even") + "'>");
			champuru_Worker.out("<td>" + i + "</td><td>" + score.score + "</td><td>" + score.idx1 + "</td><td>" + score.idx2 + "</td><td><a href='#' onclick='rerunAnalysisWithDifferentOffsets2(\"" + fwd + "\", \"" + rev + "\", " + scoreCalculationMethod + ", " + score.idx1 + ", " + score.idx2 + "); return false;'>Calculate</a></td>");
			champuru_Worker.out("</tr>");
			++i;
			if(i > 5) {
				break;
			}
		}
		champuru_Worker.out("</table>");
		champuru_Worker.out("<div class='timelegend'>Calculation took " + ("" + Math.round((HxOverrides.now() / 1000 - timestamp) * 1000)) + "ms</div>");
		champuru_Worker.out("</fieldset>");
		champuru_Worker.out("<br>");
	}
	if(problems == 0) {
		champuru_Worker.out("<fieldset>");
		champuru_Worker.out("<legend>Download area</legend>");
		champuru_Worker.out("<span class='middle'><button onclick='downloadFasta(true)'>Download FASTA (all bases)</button><button onclick='downloadFasta(false)'>Download FASTA (only overlap)</button></span><br>");
		champuru_Worker.out("</fieldset>");
	}
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
		var searchForAlternativeSolutions = js_Boot.__cast(e.data.searchForAlternativeSolutions , Bool);
		var result = champuru_Worker.generateHtml(fwd,rev,scoreCalculationMethod,i,j,use,searchForAlternativeSolutions);
		champuru_Worker.workerScope.postMessage(result);
	} catch( _g ) {
		var e = haxe_Exception.caught(_g);
		console.log("champuru/Worker.hx:426:",e);
		champuru_Worker.workerScope.postMessage({ result : "The following error occurred: " + Std.string(e)});
	}
};
champuru_Worker.main = function() {
	champuru_Worker.workerScope = self;
	champuru_Worker.workerScope.onmessage = champuru_Worker.onMessage;
};
var champuru_base_NucleotideSequence = function(seq) {
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
			if(c == null) {
				throw haxe_Exception.thrown("c must not be null!");
			}
			this.mSequence.h[i] = c;
			++i;
		}
		this.mLength = seq.length;
	}
};
champuru_base_NucleotideSequence.__name__ = true;
champuru_base_NucleotideSequence.fromString = function(str) {
	var list = new haxe_ds_List();
	var _g = 0;
	var _g1 = str.length;
	while(_g < _g1) {
		var i = _g++;
		var ch = str.charAt(i);
		var nucleotide = champuru_base_SingleNucleotide.createNucleotideByIUPACCode(ch);
		list.add(nucleotide);
	}
	return new champuru_base_NucleotideSequence(list);
};
champuru_base_NucleotideSequence.prototype = {
	toString: function() {
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
	,length: function() {
		return this.mLength;
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
		var result = new champuru_base_NucleotideSequence(seq);
		return result;
	}
	,getReverseComplement: function() {
		var seq = new haxe_ds_List();
		var i = this.mLength - 1;
		while(i <= 0) {
			var c = this.mSequence.h[i];
			var code = 0;
			code += (c.mCode & champuru_base_SingleNucleotide.sAdenine) != 0 ? champuru_base_SingleNucleotide.sThymine : 0;
			code += (c.mCode & champuru_base_SingleNucleotide.sCytosine) != 0 ? champuru_base_SingleNucleotide.sGuanine : 0;
			code += (c.mCode & champuru_base_SingleNucleotide.sGuanine) != 0 ? champuru_base_SingleNucleotide.sCytosine : 0;
			code += (c.mCode & champuru_base_SingleNucleotide.sThymine) != 0 ? champuru_base_SingleNucleotide.sAdenine : 0;
			c = new champuru_base_SingleNucleotide(c.mCode,c.mQuality);
			seq.add(c);
			--i;
		}
		var result = new champuru_base_NucleotideSequence(seq);
		return result;
	}
	,clone: function() {
		var seq = new haxe_ds_List();
		var _g = 0;
		var _g1 = this.mLength;
		while(_g < _g1) {
			var i = _g++;
			var c = this.mSequence.h[i];
			seq.add(c);
		}
		return new champuru_base_NucleotideSequence(seq);
	}
	,countGaps: function() {
		var count = 0;
		var seq = new haxe_ds_List();
		var _g = 0;
		var _g1 = this.mLength;
		while(_g < _g1) {
			var i = _g++;
			var c = this.mSequence.h[i];
			seq.add(c);
		}
		var _g_head = seq.h;
		while(_g_head != null) {
			var val = _g_head.item;
			_g_head = _g_head.next;
			var c = val;
			if(c.mCode == 0) {
				++count;
			}
		}
		return count;
	}
	,countPolymorphisms: function(minQual) {
		if(minQual == null) {
			minQual = -1;
		}
		var count = 0;
		var seq = new haxe_ds_List();
		var _g = 0;
		var _g1 = this.mLength;
		while(_g < _g1) {
			var i = _g++;
			var c = this.mSequence.h[i];
			seq.add(c);
		}
		var _g_head = seq.h;
		while(_g_head != null) {
			var val = _g_head.item;
			_g_head = _g_head.next;
			var c = val;
			if(!c.isNotPolymorphism() && c.mQuality >= minQual) {
				++count;
			}
		}
		return count;
	}
	,countNotPolymorphisms: function(minQual) {
		if(minQual == null) {
			minQual = -1;
		}
		var count = 0;
		var seq = new haxe_ds_List();
		var _g = 0;
		var _g1 = this.mLength;
		while(_g < _g1) {
			var i = _g++;
			var c = this.mSequence.h[i];
			seq.add(c);
		}
		var _g_head = seq.h;
		while(_g_head != null) {
			var val = _g_head.item;
			_g_head = _g_head.next;
			var c = val;
			if(c.isNotPolymorphism() && c.mQuality >= minQual) {
				++count;
			}
		}
		return count;
	}
	,__class__: champuru_base_NucleotideSequence
};
var champuru_base_SingleNucleotide = function(code,quality) {
	if(quality == null) {
		quality = 1.0;
	}
	this.mQuality = 1.0;
	this.mCode = 0;
	this.mCode = code;
	this.mQuality = quality;
};
champuru_base_SingleNucleotide.__name__ = true;
champuru_base_SingleNucleotide.createNucleotideByBools = function(adenine,cytosine,thymine,guanine,quality) {
	if(quality == null) {
		quality = 100;
	}
	var code = (adenine ? champuru_base_SingleNucleotide.sAdenine : 0) + (cytosine ? champuru_base_SingleNucleotide.sCytosine : 0) + (thymine ? champuru_base_SingleNucleotide.sThymine : 0) + (guanine ? champuru_base_SingleNucleotide.sGuanine : 0);
	return new champuru_base_SingleNucleotide(code,quality);
};
champuru_base_SingleNucleotide.createNucleotideByIUPACCode = function(s,origQuality) {
	if(origQuality == null) {
		origQuality = -1;
	}
	var code = s.toUpperCase();
	var quality = origQuality == -1 ? code == s ? 100 : 50 : origQuality;
	if(code == "." || code == "-" || code == "_") {
		return new champuru_base_SingleNucleotide(0,quality);
	} else if(code == "A") {
		return new champuru_base_SingleNucleotide(champuru_base_SingleNucleotide.sAdenine,quality);
	} else if(code == "C") {
		return new champuru_base_SingleNucleotide(champuru_base_SingleNucleotide.sCytosine,quality);
	} else if(code == "T") {
		return new champuru_base_SingleNucleotide(champuru_base_SingleNucleotide.sThymine,quality);
	} else if(code == "G") {
		return new champuru_base_SingleNucleotide(champuru_base_SingleNucleotide.sGuanine,quality);
	} else if(code == "K") {
		return new champuru_base_SingleNucleotide(champuru_base_SingleNucleotide.sThymine + champuru_base_SingleNucleotide.sGuanine,quality);
	} else if(code == "S") {
		return new champuru_base_SingleNucleotide(champuru_base_SingleNucleotide.sCytosine + champuru_base_SingleNucleotide.sGuanine,quality);
	} else if(code == "R") {
		return new champuru_base_SingleNucleotide(champuru_base_SingleNucleotide.sAdenine + champuru_base_SingleNucleotide.sGuanine,quality);
	} else if(code == "Y") {
		return new champuru_base_SingleNucleotide(champuru_base_SingleNucleotide.sCytosine + champuru_base_SingleNucleotide.sThymine,quality);
	} else if(code == "W") {
		return new champuru_base_SingleNucleotide(champuru_base_SingleNucleotide.sAdenine + champuru_base_SingleNucleotide.sThymine,quality);
	} else if(code == "M") {
		return new champuru_base_SingleNucleotide(champuru_base_SingleNucleotide.sAdenine + champuru_base_SingleNucleotide.sCytosine,quality);
	} else if(code == "B") {
		return new champuru_base_SingleNucleotide(champuru_base_SingleNucleotide.sCytosine + champuru_base_SingleNucleotide.sThymine + champuru_base_SingleNucleotide.sGuanine,quality);
	} else if(code == "D") {
		return new champuru_base_SingleNucleotide(champuru_base_SingleNucleotide.sGuanine + champuru_base_SingleNucleotide.sAdenine + champuru_base_SingleNucleotide.sThymine,quality);
	} else if(code == "V") {
		return new champuru_base_SingleNucleotide(champuru_base_SingleNucleotide.sGuanine + champuru_base_SingleNucleotide.sCytosine + champuru_base_SingleNucleotide.sAdenine,quality);
	} else if(code == "H") {
		return new champuru_base_SingleNucleotide(champuru_base_SingleNucleotide.sAdenine + champuru_base_SingleNucleotide.sCytosine + champuru_base_SingleNucleotide.sThymine,quality);
	} else if(code == "N") {
		return new champuru_base_SingleNucleotide(champuru_base_SingleNucleotide.sAdenine + champuru_base_SingleNucleotide.sCytosine + champuru_base_SingleNucleotide.sThymine + champuru_base_SingleNucleotide.sGuanine,quality);
	}
	throw haxe_Exception.thrown("Unknown character " + code + ". Cannot convert it into a nucleotide!");
};
champuru_base_SingleNucleotide.prototype = {
	toIUPACCode: function() {
		var result = "_";
		if((this.mCode & champuru_base_SingleNucleotide.sAdenine) != 0 && (this.mCode & champuru_base_SingleNucleotide.sCytosine) != 0 && (this.mCode & champuru_base_SingleNucleotide.sGuanine) != 0 && (this.mCode & champuru_base_SingleNucleotide.sThymine) != 0) {
			result = "N";
		} else if((this.mCode & champuru_base_SingleNucleotide.sAdenine) != 0 && (this.mCode & champuru_base_SingleNucleotide.sCytosine) != 0 && (this.mCode & champuru_base_SingleNucleotide.sGuanine) != 0) {
			result = "V";
		} else if((this.mCode & champuru_base_SingleNucleotide.sAdenine) != 0 && (this.mCode & champuru_base_SingleNucleotide.sCytosine) != 0 && (this.mCode & champuru_base_SingleNucleotide.sThymine) != 0) {
			result = "H";
		} else if((this.mCode & champuru_base_SingleNucleotide.sAdenine) != 0 && (this.mCode & champuru_base_SingleNucleotide.sGuanine) != 0 && (this.mCode & champuru_base_SingleNucleotide.sThymine) != 0) {
			result = "D";
		} else if((this.mCode & champuru_base_SingleNucleotide.sCytosine) != 0 && (this.mCode & champuru_base_SingleNucleotide.sGuanine) != 0 && (this.mCode & champuru_base_SingleNucleotide.sThymine) != 0) {
			result = "B";
		} else if((this.mCode & champuru_base_SingleNucleotide.sAdenine) != 0 && (this.mCode & champuru_base_SingleNucleotide.sCytosine) != 0) {
			result = "M";
		} else if((this.mCode & champuru_base_SingleNucleotide.sAdenine) != 0 && (this.mCode & champuru_base_SingleNucleotide.sThymine) != 0) {
			result = "W";
		} else if((this.mCode & champuru_base_SingleNucleotide.sAdenine) != 0 && (this.mCode & champuru_base_SingleNucleotide.sGuanine) != 0) {
			result = "R";
		} else if((this.mCode & champuru_base_SingleNucleotide.sCytosine) != 0 && (this.mCode & champuru_base_SingleNucleotide.sThymine) != 0) {
			result = "Y";
		} else if((this.mCode & champuru_base_SingleNucleotide.sCytosine) != 0 && (this.mCode & champuru_base_SingleNucleotide.sGuanine) != 0) {
			result = "S";
		} else if((this.mCode & champuru_base_SingleNucleotide.sThymine) != 0 && (this.mCode & champuru_base_SingleNucleotide.sGuanine) != 0) {
			result = "K";
		} else if((this.mCode & champuru_base_SingleNucleotide.sAdenine) != 0) {
			result = "A";
		} else if((this.mCode & champuru_base_SingleNucleotide.sCytosine) != 0) {
			result = "C";
		} else if((this.mCode & champuru_base_SingleNucleotide.sThymine) != 0) {
			result = "T";
		} else if((this.mCode & champuru_base_SingleNucleotide.sGuanine) != 0) {
			result = "G";
		}
		if(this.mQuality <= 0.5) {
			result = result.toLowerCase();
		}
		return result;
	}
	,getCode: function() {
		return this.mCode;
	}
	,isGap: function() {
		return this.mCode == 0;
	}
	,canStandForAdenine: function() {
		return (this.mCode & champuru_base_SingleNucleotide.sAdenine) != 0;
	}
	,isAdenine: function() {
		return this.mCode == champuru_base_SingleNucleotide.sAdenine;
	}
	,canStandForCytosine: function() {
		return (this.mCode & champuru_base_SingleNucleotide.sCytosine) != 0;
	}
	,isCytosine: function() {
		return this.mCode == champuru_base_SingleNucleotide.sCytosine;
	}
	,canStandForThymine: function() {
		return (this.mCode & champuru_base_SingleNucleotide.sThymine) != 0;
	}
	,isThymine: function() {
		return this.mCode == champuru_base_SingleNucleotide.sThymine;
	}
	,canStandForGuanine: function() {
		return (this.mCode & champuru_base_SingleNucleotide.sGuanine) != 0;
	}
	,isGuanine: function() {
		return this.mCode == champuru_base_SingleNucleotide.sGuanine;
	}
	,isN: function() {
		return this.mCode == champuru_base_SingleNucleotide.sAdenine + champuru_base_SingleNucleotide.sCytosine + champuru_base_SingleNucleotide.sThymine + champuru_base_SingleNucleotide.sGuanine;
	}
	,getQuality: function() {
		return this.mQuality;
	}
	,countPolymorphism: function() {
		var i = 0;
		if((this.mCode & champuru_base_SingleNucleotide.sAdenine) != 0) {
			++i;
		}
		if((this.mCode & champuru_base_SingleNucleotide.sCytosine) != 0) {
			++i;
		}
		if((this.mCode & champuru_base_SingleNucleotide.sThymine) != 0) {
			++i;
		}
		if((this.mCode & champuru_base_SingleNucleotide.sGuanine) != 0) {
			++i;
		}
		return i;
	}
	,isNotPolymorphism: function() {
		if(this.mCode == 0) {
			return true;
		}
		if(this.mCode == champuru_base_SingleNucleotide.sAdenine) {
			return true;
		}
		if(this.mCode == champuru_base_SingleNucleotide.sCytosine) {
			return true;
		}
		if(this.mCode == champuru_base_SingleNucleotide.sGuanine) {
			return true;
		}
		if(this.mCode == champuru_base_SingleNucleotide.sThymine) {
			return true;
		}
		return false;
	}
	,isPolymorphism: function() {
		return !this.isNotPolymorphism();
	}
	,getReverseComplement: function() {
		var code = 0;
		code += (this.mCode & champuru_base_SingleNucleotide.sAdenine) != 0 ? champuru_base_SingleNucleotide.sThymine : 0;
		code += (this.mCode & champuru_base_SingleNucleotide.sCytosine) != 0 ? champuru_base_SingleNucleotide.sGuanine : 0;
		code += (this.mCode & champuru_base_SingleNucleotide.sGuanine) != 0 ? champuru_base_SingleNucleotide.sCytosine : 0;
		code += (this.mCode & champuru_base_SingleNucleotide.sThymine) != 0 ? champuru_base_SingleNucleotide.sAdenine : 0;
		return new champuru_base_SingleNucleotide(this.mCode,this.mQuality);
	}
	,union: function(o) {
		var code = this.mCode & o.mCode;
		var quality = Math.min(this.mQuality,o.mQuality);
		return new champuru_base_SingleNucleotide(code,quality);
	}
	,intersection: function(o) {
		var code = this.mCode | o.mCode;
		var quality = Math.min(this.mQuality,o.mQuality);
		return new champuru_base_SingleNucleotide(code,quality);
	}
	,difference: function(o) {
		var code = this.mCode ^ o.mCode;
		var quality = Math.min(this.mQuality,o.mQuality);
		return new champuru_base_SingleNucleotide(code,quality);
	}
	,isSubset: function(o) {
		if((this.mCode & champuru_base_SingleNucleotide.sAdenine) != 0) {
			if((o.mCode & champuru_base_SingleNucleotide.sAdenine) == 0) {
				return false;
			}
		}
		if((this.mCode & champuru_base_SingleNucleotide.sCytosine) != 0) {
			if((o.mCode & champuru_base_SingleNucleotide.sCytosine) == 0) {
				return false;
			}
		}
		if((this.mCode & champuru_base_SingleNucleotide.sGuanine) != 0) {
			if((o.mCode & champuru_base_SingleNucleotide.sGuanine) == 0) {
				return false;
			}
		}
		if((this.mCode & champuru_base_SingleNucleotide.sThymine) != 0) {
			if((o.mCode & champuru_base_SingleNucleotide.sThymine) == 0) {
				return false;
			}
		}
		return true;
	}
	,isSuperset: function(o) {
		if((o.mCode & champuru_base_SingleNucleotide.sAdenine) != 0) {
			if((this.mCode & champuru_base_SingleNucleotide.sAdenine) == 0) {
				return false;
			}
		}
		if((o.mCode & champuru_base_SingleNucleotide.sCytosine) != 0) {
			if((this.mCode & champuru_base_SingleNucleotide.sCytosine) == 0) {
				return false;
			}
		}
		if((o.mCode & champuru_base_SingleNucleotide.sGuanine) != 0) {
			if((this.mCode & champuru_base_SingleNucleotide.sGuanine) == 0) {
				return false;
			}
		}
		if((o.mCode & champuru_base_SingleNucleotide.sThymine) != 0) {
			if((this.mCode & champuru_base_SingleNucleotide.sThymine) == 0) {
				return false;
			}
		}
		return true;
	}
	,isDisjoint: function(o) {
		var code = this.mCode & o.mCode;
		return code == 0;
	}
	,isOverlapping: function(o) {
		var code = this.mCode & o.mCode;
		return code != 0;
	}
	,clone: function(newQuality) {
		if(newQuality == null) {
			newQuality = -1;
		}
		return new champuru_base_SingleNucleotide(this.mCode,newQuality == -1 ? this.mQuality : newQuality);
	}
	,equals: function(o,alsoEq) {
		if(alsoEq == null) {
			alsoEq = false;
		}
		if(this.mCode != o.mCode) {
			return false;
		}
		if(alsoEq) {
			if(this.mQuality != o.mQuality) {
				return false;
			}
		}
		return true;
	}
	,__class__: champuru_base_SingleNucleotide
};
var champuru_consensus_OverlapSolver = function(pos,fwd,rev) {
	this.mPos = pos;
	this.mFwd = fwd;
	this.mRev = rev;
};
champuru_consensus_OverlapSolver.__name__ = true;
champuru_consensus_OverlapSolver.prototype = {
	solve: function() {
		var explained = new haxe_ds_List();
		if(this.mPos > 0) {
			var _g = 0;
			var _g1 = this.mPos;
			while(_g < _g1) {
				var i = _g++;
				var _this = this.mRev;
				if(!(0 <= i && i < _this.mLength)) {
					throw haxe_Exception.thrown("Position " + i + " out of range [0," + _this.mLength + "(");
				}
				var c = _this.mSequence.h[i];
				var newQuality = 0.5;
				if(newQuality == null) {
					newQuality = -1;
				}
				var copy = new champuru_base_SingleNucleotide(c.mCode,newQuality == -1 ? c.mQuality : newQuality);
				explained.add(copy);
			}
		} else if(this.mPos < 0) {
			var _g = 0;
			var _g1 = -this.mPos;
			while(_g < _g1) {
				var i = _g++;
				var _this = this.mFwd;
				if(!(0 <= i && i < _this.mLength)) {
					throw haxe_Exception.thrown("Position " + i + " out of range [0," + _this.mLength + "(");
				}
				var c = _this.mSequence.h[i];
				var newQuality = 0.5;
				if(newQuality == null) {
					newQuality = -1;
				}
				var copy = new champuru_base_SingleNucleotide(c.mCode,newQuality == -1 ? c.mQuality : newQuality);
				explained.add(copy);
			}
		}
		var fwdCorr = this.mPos < 0 ? -this.mPos : 0;
		var revCorr = this.mPos > 0 ? this.mPos : 0;
		var fwdL = fwdCorr + this.mRev.mLength;
		var revL = revCorr + this.mFwd.mLength;
		var overlap = (fwdL < revL ? fwdL : revL) - (fwdCorr + revCorr);
		var _g = 0;
		var _g1 = overlap;
		while(_g < _g1) {
			var pos = _g++;
			var _this = this.mFwd;
			var i = pos + fwdCorr;
			if(!(0 <= i && i < _this.mLength)) {
				throw haxe_Exception.thrown("Position " + i + " out of range [0," + _this.mLength + "(");
			}
			var a = _this.mSequence.h[i];
			var _this1 = this.mRev;
			var i1 = pos + revCorr;
			if(!(0 <= i1 && i1 < _this1.mLength)) {
				throw haxe_Exception.thrown("Position " + i1 + " out of range [0," + _this1.mLength + "(");
			}
			var b = _this1.mSequence.h[i1];
			var adenine = (a.mCode & champuru_base_SingleNucleotide.sAdenine) != 0 && (b.mCode & champuru_base_SingleNucleotide.sAdenine) != 0;
			var cytosine = (a.mCode & champuru_base_SingleNucleotide.sCytosine) != 0 && (b.mCode & champuru_base_SingleNucleotide.sCytosine) != 0;
			var thymine = (a.mCode & champuru_base_SingleNucleotide.sThymine) != 0 && (b.mCode & champuru_base_SingleNucleotide.sThymine) != 0;
			var guanine = (a.mCode & champuru_base_SingleNucleotide.sGuanine) != 0 && (b.mCode & champuru_base_SingleNucleotide.sGuanine) != 0;
			var code = a.mCode & b.mCode;
			var quality = Math.min(a.mQuality,b.mQuality);
			var copy = new champuru_base_SingleNucleotide(code,quality);
			explained.add(copy);
		}
		var lenFwd = this.mFwd.mLength + (this.mPos > 0 ? this.mPos : 0);
		var lenRev = this.mRev.mLength + (this.mPos < 0 ? -this.mPos : 0);
		if(lenFwd > lenRev) {
			var len = lenFwd - lenRev;
			var posStart = this.mFwd.mLength - len;
			var _g = 0;
			var _g1 = len;
			while(_g < _g1) {
				var i = _g++;
				var _this = this.mFwd;
				var i1 = posStart + i;
				if(!(0 <= i1 && i1 < _this.mLength)) {
					throw haxe_Exception.thrown("Position " + i1 + " out of range [0," + _this.mLength + "(");
				}
				var c = _this.mSequence.h[i1];
				var newQuality = 0.5;
				if(newQuality == null) {
					newQuality = -1;
				}
				var copy = new champuru_base_SingleNucleotide(c.mCode,newQuality == -1 ? c.mQuality : newQuality);
				explained.add(copy);
			}
		} else if(lenRev > lenFwd) {
			var len = lenRev - lenFwd;
			var posStart = this.mRev.mLength - len;
			var _g = 0;
			var _g1 = len;
			while(_g < _g1) {
				var i = _g++;
				var _this = this.mRev;
				var i1 = posStart + i;
				if(!(0 <= i1 && i1 < _this.mLength)) {
					throw haxe_Exception.thrown("Position " + i1 + " out of range [0," + _this.mLength + "(");
				}
				var c = _this.mSequence.h[i1];
				var newQuality = 0.5;
				if(newQuality == null) {
					newQuality = -1;
				}
				var copy = new champuru_base_SingleNucleotide(c.mCode,newQuality == -1 ? c.mQuality : newQuality);
				explained.add(copy);
			}
		}
		return new champuru_base_NucleotideSequence(explained);
	}
	,__class__: champuru_consensus_OverlapSolver
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
var champuru_reconstruction_SequenceChecker = function(fwd,rev) {
	this.mFwd = fwd;
	this.mRev = rev;
};
champuru_reconstruction_SequenceChecker.__name__ = true;
champuru_reconstruction_SequenceChecker.prototype = {
	setOffsets: function(offset1,offset2) {
		this.mOffset1 = offset1;
		this.mOffset2 = offset2;
	}
	,_check: function(s1,s2,c1I,c2I,c3I,c4I) {
		var pF = new haxe_ds_List();
		var pR = new haxe_ds_List();
		var _g = 0;
		var _g1 = this.mFwd.mLength;
		while(_g < _g1) {
			var fwdPos = _g++;
			var s1Pos = fwdPos + c1I;
			var s2Pos = fwdPos + c2I;
			if(s1Pos < 0 || s2Pos < 0 || s1Pos >= s1.mLength || s2Pos >= s2.mLength) {
				continue;
			}
			var _this = this.mFwd;
			if(!(0 <= fwdPos && fwdPos < _this.mLength)) {
				throw haxe_Exception.thrown("Position " + fwdPos + " out of range [0," + _this.mLength + "(");
			}
			var tmp = _this.mSequence.h[fwdPos].mCode;
			if(!(0 <= s1Pos && s1Pos < s1.mLength)) {
				throw haxe_Exception.thrown("Position " + s1Pos + " out of range [0," + s1.mLength + "(");
			}
			var tmp1 = s1.mSequence.h[s1Pos].mCode;
			if(!(0 <= s2Pos && s2Pos < s2.mLength)) {
				throw haxe_Exception.thrown("Position " + s2Pos + " out of range [0," + s2.mLength + "(");
			}
			if(tmp != (tmp1 | s2.mSequence.h[s2Pos].mCode)) {
				pF.add(fwdPos + 1);
			}
		}
		var _g = 0;
		var _g1 = this.mRev.mLength;
		while(_g < _g1) {
			var revPos = _g++;
			var s1Pos = revPos + c3I;
			var s2Pos = revPos + c4I;
			if(s1Pos < 0 || s2Pos < 0 || s1Pos >= s1.mLength || s2Pos >= s2.mLength) {
				continue;
			}
			var _this = this.mRev;
			if(!(0 <= revPos && revPos < _this.mLength)) {
				throw haxe_Exception.thrown("Position " + revPos + " out of range [0," + _this.mLength + "(");
			}
			var tmp = _this.mSequence.h[revPos].mCode;
			if(!(0 <= s1Pos && s1Pos < s1.mLength)) {
				throw haxe_Exception.thrown("Position " + s1Pos + " out of range [0," + s1.mLength + "(");
			}
			var tmp1 = s1.mSequence.h[s1Pos].mCode;
			if(!(0 <= s2Pos && s2Pos < s2.mLength)) {
				throw haxe_Exception.thrown("Position " + s2Pos + " out of range [0," + s2.mLength + "(");
			}
			if(tmp != (tmp1 | s2.mSequence.h[s2Pos].mCode)) {
				pR.add(revPos + 1);
			}
		}
		return { pF : pF, pR : pR};
	}
	,listContains: function(l,ele) {
		var _g_head = l.h;
		while(_g_head != null) {
			var val = _g_head.item;
			_g_head = _g_head.next;
			var item = val;
			if(ele == item) {
				return true;
			}
		}
		return false;
	}
	,addToListIfNotPresent: function(l,ele) {
		if(!this.listContains(l,ele)) {
			l.push(ele);
		}
	}
	,check: function(s1,s2) {
		var pFbest = new haxe_ds_List();
		var pRbest = new haxe_ds_List();
		var eBest = this.mFwd.mLength + this.mRev.mLength + 1000;
		var data = "-";
		var l = new haxe_ds_List();
		if(!this.listContains(l,0)) {
			l.push(0);
		}
		var ele = -this.mOffset1;
		if(!this.listContains(l,ele)) {
			l.push(ele);
		}
		var ele = -this.mOffset2;
		if(!this.listContains(l,ele)) {
			l.push(ele);
		}
		var ele = this.mOffset1;
		if(!this.listContains(l,ele)) {
			l.push(ele);
		}
		var ele = this.mOffset2;
		if(!this.listContains(l,ele)) {
			l.push(ele);
		}
		var ele = this.mOffset2 - this.mOffset1;
		if(!this.listContains(l,ele)) {
			l.push(ele);
		}
		var ele = this.mOffset1 - this.mOffset2;
		if(!this.listContains(l,ele)) {
			l.push(ele);
		}
		var ele = this.mOffset2 + this.mOffset1;
		if(!this.listContains(l,ele)) {
			l.push(ele);
		}
		var ele = this.mOffset1 + this.mOffset2;
		if(!this.listContains(l,ele)) {
			l.push(ele);
		}
		var _g_head = l.h;
		while(_g_head != null) {
			var val = _g_head.item;
			_g_head = _g_head.next;
			var c1I = val;
			var _g_head1 = l.h;
			while(_g_head1 != null) {
				var val1 = _g_head1.item;
				_g_head1 = _g_head1.next;
				var c2I = val1;
				var _g_head2 = l.h;
				while(_g_head2 != null) {
					var val2 = _g_head2.item;
					_g_head2 = _g_head2.next;
					var c3I = val2;
					var _g_head3 = l.h;
					while(_g_head3 != null) {
						var val3 = _g_head3.item;
						_g_head3 = _g_head3.next;
						var c4I = val3;
						var c = this._check(s1,s2,c1I,c2I,c3I,c4I);
						var e = c.pF.length + c.pR.length;
						if(e < eBest) {
							pFbest = c.pF;
							pRbest = c.pR;
							eBest = e;
							data = "" + c1I + ", " + c2I + ", " + c3I + ", " + c4I;
						}
						console.log("champuru/reconstruction/SequenceChecker.hx:119:","Calculated " + c1I + ", " + c2I + ", " + c3I + ", " + c4I + ": " + e);
					}
				}
			}
		}
		console.log("champuru/reconstruction/SequenceChecker.hx:124:","Best for " + data + ": " + eBest);
		return { pF : pFbest, pR : pRbest, pFHighlight : new haxe_ds_List(), pRHighlight : new haxe_ds_List()};
	}
	,__class__: champuru_reconstruction_SequenceChecker
};
var champuru_reconstruction_SequenceReconstructor = function() { };
champuru_reconstruction_SequenceReconstructor.__name__ = true;
champuru_reconstruction_SequenceReconstructor.getBegin = function(s) {
	var begin = 0;
	while(true) {
		if(!(0 <= begin && begin < s.mLength)) {
			throw haxe_Exception.thrown("Position " + begin + " out of range [0," + s.mLength + "(");
		}
		if(!(s.mSequence.h[begin].mQuality < 0.75)) {
			break;
		}
		++begin;
	}
	return begin;
};
champuru_reconstruction_SequenceReconstructor.getEnd = function(s) {
	var end = s.mLength - 1;
	while(true) {
		if(!(0 <= end && end < s.mLength)) {
			throw haxe_Exception.thrown("Position " + end + " out of range [0," + s.mLength + "(");
		}
		if(!(s.mSequence.h[end].mQuality < 0.75)) {
			break;
		}
		--end;
	}
	return end;
};
champuru_reconstruction_SequenceReconstructor.reconstruct = function(seq1,seq2) {
	var seq1begin = champuru_reconstruction_SequenceReconstructor.getBegin(seq1);
	var seq2begin = champuru_reconstruction_SequenceReconstructor.getBegin(seq2);
	var seq1end = champuru_reconstruction_SequenceReconstructor.getEnd(seq1);
	var seq2end = champuru_reconstruction_SequenceReconstructor.getEnd(seq2);
	var changed = true;
	var round = 1;
	while(changed) {
		changed = false;
		var seqLen1 = seq1.mLength;
		var seqLen2 = seq2.mLength;
		var seqLen = seqLen1 > seqLen2 ? seqLen2 : seqLen1;
		console.log("champuru/reconstruction/SequenceReconstructor.hx:60:","=== Reconstruction round " + round + " (" + seq1begin + ", " + seq2begin + ", " + seqLen + ") ===");
		++round;
		var _g = 0;
		var _g1 = seqLen;
		while(_g < _g1) {
			var j = _g++;
			var idx1 = seq1begin + j;
			var idx2 = seq2begin + j;
			var tmp;
			var tmp1;
			if(!(idx1 >= seqLen1 || idx2 >= seqLen2)) {
				if(!(0 <= idx1 && idx1 < seq1.mLength)) {
					throw haxe_Exception.thrown("Position " + idx1 + " out of range [0," + seq1.mLength + "(");
				}
				tmp1 = seq1.mSequence.h[idx1].mQuality < 0.75;
			} else {
				tmp1 = true;
			}
			if(!tmp1) {
				if(!(0 <= idx2 && idx2 < seq2.mLength)) {
					throw haxe_Exception.thrown("Position " + idx2 + " out of range [0," + seq2.mLength + "(");
				}
				tmp = seq2.mSequence.h[idx2].mQuality < 0.75;
			} else {
				tmp = true;
			}
			if(!tmp) {
				if(!(0 <= idx1 && idx1 < seq1.mLength)) {
					throw haxe_Exception.thrown("Position " + idx1 + " out of range [0," + seq1.mLength + "(");
				}
				var seq1n = seq1.mSequence.h[idx1];
				if(!(0 <= idx2 && idx2 < seq2.mLength)) {
					throw haxe_Exception.thrown("Position " + idx2 + " out of range [0," + seq2.mLength + "(");
				}
				var seq2n = seq2.mSequence.h[idx2];
				if(!seq1n.isNotPolymorphism() || !seq2n.isNotPolymorphism()) {
					var data = "F Positions " + idx1 + ", " + idx2 + ": " + seq1n.toIUPACCode() + " " + seq2n.toIUPACCode() + " ";
					var code = seq1n.mCode & seq2n.mCode;
					var data1 = data + Std.string(seq1n.mCode != seq2n.mCode) + " " + Std.string(code != 0);
					if(seq1n.mCode != seq2n.mCode) {
						var code1 = seq1n.mCode & seq2n.mCode;
						if(code1 != 0) {
							if(seq1n.mCode > seq2n.mCode) {
								var code2 = seq1n.mCode - seq2n.mCode;
								var newN = new champuru_base_SingleNucleotide(code2);
								seq1.replace(idx1,newN);
								changed = true;
								data1 = data1 + " (seq1) " + idx1 + "->" + newN.toIUPACCode();
							} else {
								var code3 = seq2n.mCode - seq1n.mCode;
								var newN1 = new champuru_base_SingleNucleotide(code3);
								seq2.replace(idx2,newN1);
								changed = true;
								data1 = data1 + " (seq2) " + idx2 + "->" + newN1.toIUPACCode();
							}
						}
					}
					console.log("champuru/reconstruction/SequenceReconstructor.hx:90:",data1);
				}
			}
			var idx1_ = seq1end - j;
			var idx2_ = seq2end - j;
			var tmp2;
			var tmp3;
			if(!(idx1_ < 0 || idx2_ < 0)) {
				if(!(0 <= idx1_ && idx1_ < seq1.mLength)) {
					throw haxe_Exception.thrown("Position " + idx1_ + " out of range [0," + seq1.mLength + "(");
				}
				tmp3 = seq1.mSequence.h[idx1_].mQuality < 0.75;
			} else {
				tmp3 = true;
			}
			if(!tmp3) {
				if(!(0 <= idx2_ && idx2_ < seq2.mLength)) {
					throw haxe_Exception.thrown("Position " + idx2_ + " out of range [0," + seq2.mLength + "(");
				}
				tmp2 = seq2.mSequence.h[idx2_].mQuality < 0.75;
			} else {
				tmp2 = true;
			}
			if(!tmp2) {
				if(!(0 <= idx1_ && idx1_ < seq1.mLength)) {
					throw haxe_Exception.thrown("Position " + idx1_ + " out of range [0," + seq1.mLength + "(");
				}
				var seq1n_ = seq1.mSequence.h[idx1_];
				if(!(0 <= idx2_ && idx2_ < seq2.mLength)) {
					throw haxe_Exception.thrown("Position " + idx2_ + " out of range [0," + seq2.mLength + "(");
				}
				var seq2n_ = seq2.mSequence.h[idx2_];
				if(!seq1n_.isNotPolymorphism() || !seq2n_.isNotPolymorphism()) {
					var data2 = "R Positions " + idx1_ + ", " + idx2_ + ": " + seq1n_.toIUPACCode() + " " + seq2n_.toIUPACCode() + " ";
					var code4 = seq1n_.mCode & seq2n_.mCode;
					var data3 = data2 + Std.string(seq1n_.mCode != seq2n_.mCode) + " " + Std.string(code4 != 0);
					if(seq1n_.mCode != seq2n_.mCode) {
						var code5 = seq1n_.mCode & seq2n_.mCode;
						if(code5 != 0) {
							if(seq1n_.mCode > seq2n_.mCode) {
								var code6 = seq1n_.mCode - seq2n_.mCode;
								var newN2 = new champuru_base_SingleNucleotide(code6);
								seq1.replace(idx1_,newN2);
								changed = true;
								data3 = data3 + " (seq1) " + idx1_ + "->" + newN2.toIUPACCode();
							} else {
								var code7 = seq2n_.mCode - seq1n_.mCode;
								var newN3 = new champuru_base_SingleNucleotide(code7);
								seq2.replace(idx2_,newN3);
								changed = true;
								data3 = data3 + " (seq2) " + idx2_ + "->" + newN3.toIUPACCode();
							}
						}
					}
					console.log("champuru/reconstruction/SequenceReconstructor.hx:121:",data3);
				}
			}
		}
		console.log("champuru/reconstruction/SequenceReconstructor.hx:125:","changed " + (changed == null ? "null" : "" + changed));
	}
	return { seq1 : seq1, seq2 : seq2};
};
champuru_reconstruction_SequenceReconstructor.reconstruct2 = function(seq1,seq2,round) {
	if(round == null) {
		round = 0;
	}
	var seq1begin = champuru_reconstruction_SequenceReconstructor.getBegin(seq1);
	var seq2begin = champuru_reconstruction_SequenceReconstructor.getBegin(seq2);
	var toChange = new haxe_ds_List();
	var round = 1;
	var seqLen1 = seq1.mLength;
	var seqLen2 = seq2.mLength;
	var seqLen = seqLen1 > seqLen2 ? seqLen2 : seqLen1;
	++round;
	var _g = 0;
	var _g1 = seqLen;
	while(_g < _g1) {
		var j = _g++;
		var idx1 = seq1begin + j;
		var idx2 = seq2begin + j;
		var tmp;
		var tmp1;
		if(!(idx1 >= seqLen1 || idx2 >= seqLen2)) {
			if(!(0 <= idx1 && idx1 < seq1.mLength)) {
				throw haxe_Exception.thrown("Position " + idx1 + " out of range [0," + seq1.mLength + "(");
			}
			tmp1 = seq1.mSequence.h[idx1].mQuality < 0.75;
		} else {
			tmp1 = true;
		}
		if(!tmp1) {
			if(!(0 <= idx2 && idx2 < seq2.mLength)) {
				throw haxe_Exception.thrown("Position " + idx2 + " out of range [0," + seq2.mLength + "(");
			}
			tmp = seq2.mSequence.h[idx2].mQuality < 0.75;
		} else {
			tmp = true;
		}
		if(!tmp) {
			if(!(0 <= idx1 && idx1 < seq1.mLength)) {
				throw haxe_Exception.thrown("Position " + idx1 + " out of range [0," + seq1.mLength + "(");
			}
			var seq1n = seq1.mSequence.h[idx1];
			if(!(0 <= idx2 && idx2 < seq2.mLength)) {
				throw haxe_Exception.thrown("Position " + idx2 + " out of range [0," + seq2.mLength + "(");
			}
			var seq2n = seq2.mSequence.h[idx2];
			if(!seq1n.isNotPolymorphism() || !seq2n.isNotPolymorphism()) {
				if(seq1n.mCode != seq2n.mCode) {
					var code = seq1n.mCode & seq2n.mCode;
					if(code != 0) {
						if(seq1n.mCode > seq2n.mCode) {
							var code1 = seq1n.mCode - seq2n.mCode;
							var newN = new champuru_base_SingleNucleotide(code1);
							toChange.add({ isSeq1 : true, pos : idx1, newNN : newN});
						} else {
							var code2 = seq2n.mCode - seq1n.mCode;
							var newN1 = new champuru_base_SingleNucleotide(code2);
							toChange.add({ isSeq1 : false, pos : idx2, newNN : newN1});
						}
					}
				}
			}
		}
	}
	console.log("champuru/reconstruction/SequenceReconstructor.hx:218:","Length of toChange " + toChange.length);
	var result = new haxe_ds_List();
	if(toChange.length > 0) {
		var _g2_head = toChange.h;
		while(_g2_head != null) {
			var val = _g2_head.item;
			_g2_head = _g2_head.next;
			var change = val;
			if(result.length > 5) {
				break;
			}
			var r = new haxe_ds_List();
			if(change.isSeq1) {
				var seq1Clone = seq1.clone();
				seq1Clone.replace(change.pos,change.newNN);
				r = champuru_reconstruction_SequenceReconstructor.reconstruct2(seq1Clone,seq2,round++);
			} else {
				var seq2Clone = seq2.clone();
				seq2Clone.replace(change.pos,change.newNN);
				r = champuru_reconstruction_SequenceReconstructor.reconstruct2(seq1,seq2Clone,round++);
			}
			var _g2_head1 = r.h;
			while(_g2_head1 != null) {
				var val1 = _g2_head1.item;
				_g2_head1 = _g2_head1.next;
				var e = val1;
				if(result.length > 5) {
					break;
				}
				var _this = e.seq1;
				var result1 = new haxe_ds_List();
				var _g = 0;
				var _g1 = _this.mLength;
				while(_g < _g1) {
					var i = _g++;
					var c = _this.mSequence.h[i];
					var s = c.toIUPACCode();
					result1.add(s);
				}
				var s1 = result1.join("");
				var _this1 = e.seq2;
				var result2 = new haxe_ds_List();
				var _g2 = 0;
				var _g3 = _this1.mLength;
				while(_g2 < _g3) {
					var i1 = _g2++;
					var c1 = _this1.mSequence.h[i1];
					var s2 = c1.toIUPACCode();
					result2.add(s2);
				}
				var s21 = result2.join("");
				var found = false;
				var _g2_head2 = result.h;
				while(_g2_head2 != null) {
					var val2 = _g2_head2.item;
					_g2_head2 = _g2_head2.next;
					var ele = val2;
					var _this2 = e.seq1;
					var result3 = new haxe_ds_List();
					var _g4 = 0;
					var _g5 = _this2.mLength;
					while(_g4 < _g5) {
						var i2 = _g4++;
						var c2 = _this2.mSequence.h[i2];
						var s3 = c2.toIUPACCode();
						result3.add(s3);
					}
					var s1ele = result3.join("");
					var _this3 = e.seq2;
					var result4 = new haxe_ds_List();
					var _g6 = 0;
					var _g7 = _this3.mLength;
					while(_g6 < _g7) {
						var i3 = _g6++;
						var c3 = _this3.mSequence.h[i3];
						var s4 = c3.toIUPACCode();
						result4.add(s4);
					}
					var s2ele = result4.join("");
					if(s1 == s1ele && s21 == s2ele) {
						found = true;
						break;
					}
				}
				if(!found) {
					result.add(e);
				}
			}
		}
	} else {
		var result1 = new haxe_ds_List();
		var _g = 0;
		var _g1 = seq1.mLength;
		while(_g < _g1) {
			var i = _g++;
			var c = seq1.mSequence.h[i];
			var s = c.toIUPACCode();
			result1.add(s);
		}
		var tmp = "Solution: " + result1.join("") + " ";
		var result1 = new haxe_ds_List();
		var _g = 0;
		var _g1 = seq2.mLength;
		while(_g < _g1) {
			var i = _g++;
			var c = seq2.mSequence.h[i];
			var s = c.toIUPACCode();
			result1.add(s);
		}
		console.log("champuru/reconstruction/SequenceReconstructor.hx:256:",tmp + result1.join("") + " " + round);
		result.add({ seq1 : seq1, seq2 : seq2});
	}
	return result;
};
var champuru_score_AScoreCalculator = function() {
};
champuru_score_AScoreCalculator.__name__ = true;
champuru_score_AScoreCalculator.prototype = {
	calcOverlapScores: function(fwd,rev) {
		var result = [];
		var _g = -fwd.mLength + 1;
		var _g1 = rev.mLength;
		while(_g < _g1) {
			var i = _g++;
			var score = this.calcScore(i,fwd,rev);
			result.push({ nr : i - fwd.mLength + 1, index : i, score : score.score, matches : score.matches, mismatches : score.mismatches});
		}
		return result;
	}
	,__class__: champuru_score_AScoreCalculator
};
var champuru_score_AmbiguityCorrectionScoreCalculator = function() {
	champuru_score_AScoreCalculator.call(this);
};
champuru_score_AmbiguityCorrectionScoreCalculator.__name__ = true;
champuru_score_AmbiguityCorrectionScoreCalculator.__super__ = champuru_score_AScoreCalculator;
champuru_score_AmbiguityCorrectionScoreCalculator.prototype = $extend(champuru_score_AScoreCalculator.prototype,{
	getName: function() {
		return "Ambiguity correction";
	}
	,getDescription: function() {
		return "A modification of the score correction method described in the Champuru 1.0 paper. The score will get corrected for the fact that ambiguous characters (e.g. W) can match multiple other characters (e.g. A, T). Preliminary results suggests that this score calculation method works better when the reconstructed consensus sequences contain a lot of ambiguities. However this score correction method seems to work less good on short input sequences.";
	}
	,calcScore: function(i,fwd,rev) {
		var matches = 0;
		var fullMatches = 0;
		var mismatches = 0;
		var fwdCorr = i < 0 ? -i : 0;
		var revCorr = i > 0 ? i : 0;
		var fwdL = fwdCorr + rev.mLength;
		var revL = revCorr + fwd.mLength;
		var overlap = (fwdL < revL ? fwdL : revL) - (fwdCorr + revCorr);
		var _g = 0;
		var _g1 = overlap;
		while(_g < _g1) {
			var pos = _g++;
			var i = pos + fwdCorr;
			if(!(0 <= i && i < fwd.mLength)) {
				throw haxe_Exception.thrown("Position " + i + " out of range [0," + fwd.mLength + "(");
			}
			var a = fwd.mSequence.h[i];
			var i1 = pos + revCorr;
			if(!(0 <= i1 && i1 < rev.mLength)) {
				throw haxe_Exception.thrown("Position " + i1 + " out of range [0," + rev.mLength + "(");
			}
			var b = rev.mSequence.h[i1];
			if(a.equals(b,false) && a.isNotPolymorphism()) {
				++fullMatches;
			} else {
				var code = a.mCode & b.mCode;
				if(code != 0) {
					++matches;
				} else {
					++mismatches;
				}
			}
		}
		return { matches : matches + fullMatches, mismatches : mismatches, score : fullMatches + 0.5 * matches - 0.25 * overlap};
	}
	,__class__: champuru_score_AmbiguityCorrectionScoreCalculator
});
var champuru_score_GumbelDistribution = function(mu,beta) {
	this.mMu = mu;
	this.mBeta = beta;
};
champuru_score_GumbelDistribution.__name__ = true;
champuru_score_GumbelDistribution.getEstimatedGumbelDistribution = function(mean,deviation) {
	var beta = Math.sqrt(6) * deviation / Math.PI;
	var mu = mean - champuru_score_GumbelDistribution.eulerMascheroniConst * beta;
	return new champuru_score_GumbelDistribution(mu,beta);
};
champuru_score_GumbelDistribution.prototype = {
	getMu: function() {
		return this.mMu;
	}
	,getBeta: function() {
		return this.mBeta;
	}
	,getProbabilityForScore: function(score) {
		var z = (score - this.mMu) / this.mBeta;
		return 1.0 / this.mBeta * Math.exp(-(z + Math.exp(-z)));
	}
	,getProbabilityForHigherScore: function(score) {
		var s = -(score - this.mMu) / this.mBeta;
		return 1 - Math.exp(-Math.exp(s));
	}
	,__class__: champuru_score_GumbelDistribution
};
var champuru_score_GumbelDistributionEstimator = function(seq1,seq2) {
	this.mSeq1 = seq1;
	this.mSeq2 = seq2;
};
champuru_score_GumbelDistributionEstimator.__name__ = true;
champuru_score_GumbelDistributionEstimator.prototype = {
	shuffleSequence: function(s) {
		var copySequence = new haxe_ds_List();
		var sLen = s.mLength;
		var _g = 0;
		var _g1 = sLen;
		while(_g < _g1) {
			var i = _g++;
			var randomPos = Math.floor(Math.random() * sLen);
			if(!(0 <= randomPos && randomPos < s.mLength)) {
				throw haxe_Exception.thrown("Position " + randomPos + " out of range [0," + s.mLength + "(");
			}
			var newNN = s.mSequence.h[randomPos];
			copySequence.add(newNN);
		}
		var result = new champuru_base_NucleotideSequence(copySequence);
		return result;
	}
	,calculateMean: function(scores) {
		var summe = 0.0;
		var _g_head = scores.h;
		while(_g_head != null) {
			var val = _g_head.item;
			_g_head = _g_head.next;
			var score = val;
			summe += score;
		}
		return summe / scores.length;
	}
	,calculateVar: function(scores,mean) {
		var summe = 0.0;
		var _g_head = scores.h;
		while(_g_head != null) {
			var val = _g_head.item;
			_g_head = _g_head.next;
			var score = val;
			var diff = score - mean;
			summe += diff * diff;
		}
		return summe / (scores.length - 1);
	}
	,randI: function(a,b) {
		var result = 0;
		var rand = Math.random();
		if(rand > 0.5) {
			result = Math.floor(a * Math.random());
		} else {
			result = Math.floor(b * Math.random());
		}
		return result;
	}
	,calculate: function(scoreCalculator) {
		var scores = new haxe_ds_List();
		var _g = 0;
		while(_g < 20) {
			var i = _g++;
			var _g1 = 0;
			while(_g1 < 100) {
				var j = _g1++;
				var s = this.mSeq1;
				var copySequence = new haxe_ds_List();
				var sLen = s.mLength;
				var _g2 = 0;
				var _g3 = sLen;
				while(_g2 < _g3) {
					var i1 = _g2++;
					var randomPos = Math.floor(Math.random() * sLen);
					if(!(0 <= randomPos && randomPos < s.mLength)) {
						throw haxe_Exception.thrown("Position " + randomPos + " out of range [0," + s.mLength + "(");
					}
					var newNN = s.mSequence.h[randomPos];
					copySequence.add(newNN);
				}
				var result = new champuru_base_NucleotideSequence(copySequence);
				var randomFwd = result;
				var s1 = this.mSeq2;
				var copySequence1 = new haxe_ds_List();
				var sLen1 = s1.mLength;
				var _g4 = 0;
				var _g5 = sLen1;
				while(_g4 < _g5) {
					var i2 = _g4++;
					var randomPos1 = Math.floor(Math.random() * sLen1);
					if(!(0 <= randomPos1 && randomPos1 < s1.mLength)) {
						throw haxe_Exception.thrown("Position " + randomPos1 + " out of range [0," + s1.mLength + "(");
					}
					var newNN1 = s1.mSequence.h[randomPos1];
					copySequence1.add(newNN1);
				}
				var result1 = new champuru_base_NucleotideSequence(copySequence1);
				var randomRev = result1;
				var a = -randomFwd.mLength;
				var b = randomRev.mLength;
				var result2 = 0;
				var rand = Math.random();
				if(rand > 0.5) {
					result2 = Math.floor(a * Math.random());
				} else {
					result2 = Math.floor(b * Math.random());
				}
				var randPos = result2;
				var score = scoreCalculator.calcScore(randPos,randomFwd,randomRev);
				scores.add(score.score);
			}
		}
		var summe = 0.0;
		var _g_head = scores.h;
		while(_g_head != null) {
			var val = _g_head.item;
			_g_head = _g_head.next;
			var score = val;
			summe += score;
		}
		var mean = summe / scores.length;
		var summe = 0.0;
		var _g_head = scores.h;
		while(_g_head != null) {
			var val = _g_head.item;
			_g_head = _g_head.next;
			var score = val;
			var diff = score - mean;
			summe += diff * diff;
		}
		var deviation = Math.sqrt(summe / (scores.length - 1));
		var beta = Math.sqrt(6) * deviation / Math.PI;
		var mu = mean - champuru_score_GumbelDistribution.eulerMascheroniConst * beta;
		return new champuru_score_GumbelDistribution(mu,beta);
	}
	,__class__: champuru_score_GumbelDistributionEstimator
};
var champuru_score_LongestLengthScoreCalculator = function() {
	champuru_score_AScoreCalculator.call(this);
};
champuru_score_LongestLengthScoreCalculator.__name__ = true;
champuru_score_LongestLengthScoreCalculator.__super__ = champuru_score_AScoreCalculator;
champuru_score_LongestLengthScoreCalculator.prototype = $extend(champuru_score_AScoreCalculator.prototype,{
	getName: function() {
		return "Longest Length";
	}
	,getDescription: function() {
		return "Take the longest number of consecutive matching nucleotides as score.";
	}
	,calcScore: function(i,fwd,rev) {
		var matches = 0;
		var mismatches = 0;
		var fwdCorr = i < 0 ? -i : 0;
		var revCorr = i > 0 ? i : 0;
		var fwdL = fwdCorr + rev.mLength;
		var revL = revCorr + fwd.mLength;
		var overlap = (fwdL < revL ? fwdL : revL) - (fwdCorr + revCorr);
		var maxScore = 0;
		var cScore = 0;
		var _g = 0;
		var _g1 = overlap;
		while(_g < _g1) {
			var pos = _g++;
			var i = pos + fwdCorr;
			if(!(0 <= i && i < fwd.mLength)) {
				throw haxe_Exception.thrown("Position " + i + " out of range [0," + fwd.mLength + "(");
			}
			var a = fwd.mSequence.h[i];
			var i1 = pos + revCorr;
			if(!(0 <= i1 && i1 < rev.mLength)) {
				throw haxe_Exception.thrown("Position " + i1 + " out of range [0," + rev.mLength + "(");
			}
			var b = rev.mSequence.h[i1];
			var code = a.mCode & b.mCode;
			if(code != 0) {
				++matches;
				++cScore;
			} else {
				++mismatches;
				cScore = 0;
			}
			if(maxScore <= cScore) {
				maxScore = cScore;
			}
		}
		return { matches : matches, mismatches : mismatches, score : maxScore};
	}
	,__class__: champuru_score_LongestLengthScoreCalculator
});
var champuru_score_PaperScoreCalculator = function() {
	champuru_score_AScoreCalculator.call(this);
};
champuru_score_PaperScoreCalculator.__name__ = true;
champuru_score_PaperScoreCalculator.__super__ = champuru_score_AScoreCalculator;
champuru_score_PaperScoreCalculator.prototype = $extend(champuru_score_AScoreCalculator.prototype,{
	getName: function() {
		return "Paper";
	}
	,getDescription: function() {
		return "The score correction method described in the Champuru 1.0 paper.";
	}
	,calcScore: function(i,fwd,rev) {
		var matches = 0;
		var mismatches = 0;
		var fwdCorr = i < 0 ? -i : 0;
		var revCorr = i > 0 ? i : 0;
		var fwdL = fwdCorr + rev.mLength;
		var revL = revCorr + fwd.mLength;
		var overlap = (fwdL < revL ? fwdL : revL) - (fwdCorr + revCorr);
		var _g = 0;
		var _g1 = overlap;
		while(_g < _g1) {
			var pos = _g++;
			var i = pos + fwdCorr;
			if(!(0 <= i && i < fwd.mLength)) {
				throw haxe_Exception.thrown("Position " + i + " out of range [0," + fwd.mLength + "(");
			}
			var a = fwd.mSequence.h[i];
			var i1 = pos + revCorr;
			if(!(0 <= i1 && i1 < rev.mLength)) {
				throw haxe_Exception.thrown("Position " + i1 + " out of range [0," + rev.mLength + "(");
			}
			var b = rev.mSequence.h[i1];
			var code = a.mCode & b.mCode;
			if(code != 0) {
				++matches;
			} else {
				++mismatches;
			}
		}
		return { matches : matches, mismatches : mismatches, score : matches - 0.25 * overlap};
	}
	,__class__: champuru_score_PaperScoreCalculator
});
var champuru_score_ScoreCalculatorList = function() {
	var this1 = new Array(3);
	this.mLst = this1;
	this.mLst[0] = new champuru_score_PaperScoreCalculator();
	this.mLst[1] = new champuru_score_AmbiguityCorrectionScoreCalculator();
	this.mLst[2] = new champuru_score_LongestLengthScoreCalculator();
};
champuru_score_ScoreCalculatorList.__name__ = true;
champuru_score_ScoreCalculatorList.instance = function() {
	if(champuru_score_ScoreCalculatorList.sInstance == null) {
		champuru_score_ScoreCalculatorList.sInstance = new champuru_score_ScoreCalculatorList();
	}
	return champuru_score_ScoreCalculatorList.sInstance;
};
champuru_score_ScoreCalculatorList.prototype = {
	length: function() {
		return this.mLst.length;
	}
	,getDefaultScoreCalculatorIndex: function() {
		return 1;
	}
	,getDefaultScoreCalculator: function() {
		var idx = 1;
		return this.mLst[idx];
	}
	,getScoreCalculator: function(i) {
		var result = null;
		if(0 <= i && i < this.mLst.length) {
			result = this.mLst[i];
		}
		return result;
	}
	,__class__: champuru_score_ScoreCalculatorList
};
var champuru_score_ScoreListVisualizer = function(scores,sortedScores) {
	this.scores = scores;
	this.sortedScores = sortedScores;
	this.high = sortedScores[0].score;
	var lowScore = sortedScores.pop();
	sortedScores.push(lowScore);
	this.low = lowScore.score;
};
champuru_score_ScoreListVisualizer.__name__ = true;
champuru_score_ScoreListVisualizer.prototype = {
	genScorePlot: function() {
		var result = new haxe_ds_List();
		result.add("<svg id='scorePlot' class='plot middle' width='600' height='400'>");
		result.add("<rect width='600' height='400' style='fill:white' />");
		result.add("<text x='010' y='200' text-anchor='middle' style='font-family: monospace; text-size: 12.5px' transform='rotate(270 7.5 195)'>Score</text>");
		result.add("<text x='300' y='395' text-anchor='middle' style='font-family: monospace; text-size: 12.5px'>Offset</text>");
		var d = this.high - this.low;
		var i = 0;
		var _g = 0;
		var _g1 = this.scores;
		while(_g < _g1.length) {
			var score = _g1[_g];
			++_g;
			var x = 30 + 560.0 * (i / this.scores.length);
			var y = 370 - 350 * ((score.score - this.low) / d);
			var alertMsg = "Offset: " + score.index + "\\nScore: " + score.score + "\\nMatches: " + score.matches + "\\nMismatches: " + score.mismatches;
			result.add("<circle id='c" + score.index + "' cx='" + x + "' cy='" + y + "' r='2' fill='black' title='" + 1 + "' onclick='alert(\"" + alertMsg + "\")' />");
			++i;
		}
		result.add("</svg>");
		return result.join("");
	}
	,genScorePlotHist: function(distribution) {
		var d = this.high - this.low;
		var result = new haxe_ds_List();
		result.add("<svg id='scorePlotHist' class='plot middle' width='600' height='400'>");
		result.add("<rect width='600' height='400' style='fill:white' />");
		result.add("<text x='010' y='200' text-anchor='middle' style='font-family: monospace; text-size: 12.5px' transform='rotate(270 7.5 195)'>Frequency</text>");
		result.add("<text x='025' y='200' text-anchor='middle' style='font-family: monospace; text-size: 12.5px; fill: #00f' transform='rotate(270 20.5 195)'>Probability</text>");
		result.add("<text x='300' y='395' text-anchor='start' style='font-family: monospace; text-size: 12.5px'>Score</text>");
		result.add("<text x='030' y='380' text-anchor='middle' style='font-family: monospace; text-size: 12.5px'>" + Math.floor(this.low) + "</text>");
		result.add("<text x='170' y='380' text-anchor='middle' style='font-family: monospace; text-size: 12.5px'>" + Math.round(d / 4) + "</text>");
		result.add("<text x='310' y='380' text-anchor='middle' style='font-family: monospace; text-size: 12.5px'>" + Math.round(d / 2) + "</text>");
		result.add("<text x='450' y='380' text-anchor='middle' style='font-family: monospace; text-size: 12.5px'>" + Math.round(d / 4 * 3) + "</text>");
		result.add("<text x='590' y='380' text-anchor='end' style='font-family: monospace; text-size: 12.5px'>" + Math.ceil(this.high) + "</text>");
		var hd = d / 28;
		var i = 0;
		var this1 = new Array(28);
		var v = this1;
		v[0] = 0;
		v[1] = 0;
		v[2] = 0;
		v[3] = 0;
		v[4] = 0;
		v[5] = 0;
		v[6] = 0;
		v[7] = 0;
		v[8] = 0;
		v[9] = 0;
		v[10] = 0;
		v[11] = 0;
		v[12] = 0;
		v[13] = 0;
		v[14] = 0;
		v[15] = 0;
		v[16] = 0;
		v[17] = 0;
		v[18] = 0;
		v[19] = 0;
		v[20] = 0;
		v[21] = 0;
		v[22] = 0;
		v[23] = 0;
		v[24] = 0;
		v[25] = 0;
		v[26] = 0;
		v[27] = 0;
		var _g = 0;
		var _g1 = this.sortedScores;
		while(_g < _g1.length) {
			var score = _g1[_g];
			++_g;
			var scoreP = (score.score - this.low) / d;
			var b = scoreP * 28;
			var i = Math.floor(b);
			if(i >= 28) {
				i = 27;
			}
			v[i] += 1;
		}
		var highest = 0;
		var _g = 0;
		while(_g < v.length) {
			var val = v[_g];
			++_g;
			if(highest <= val) {
				highest = val;
			}
		}
		result.add("<g style='stroke-width:1;stroke:#000;fill:#fff'>");
		var _g = 0;
		while(_g < 28) {
			var i = _g++;
			if(v[i] == 0) {
				continue;
			}
			var val = v[i] / highest;
			var x = 30 + i * 20;
			var h = val * 350;
			var y = 365 - h;
			var from = Math.round((i * hd + this.low) * 10) / 10.0;
			var to = Math.round(((i + 1) * hd + this.low) * 10) / 10.0;
			var percentage = Math.round(v[i] / this.sortedScores.length * 1000) / 10.0;
			var z = (from - distribution.mMu) / distribution.mBeta;
			var pval1 = Math.round(1.0 / distribution.mBeta * Math.exp(-(z + Math.exp(-z))) * 1000) / 1000;
			var z1 = (to - distribution.mMu) / distribution.mBeta;
			var pval2 = Math.round(1.0 / distribution.mBeta * Math.exp(-(z1 + Math.exp(-z1))) * 1000) / 1000;
			var s = -(from - distribution.mMu) / distribution.mBeta;
			var s1 = -(to - distribution.mMu) / distribution.mBeta;
			var cdfVal = Math.round((1 - Math.exp(-Math.exp(s)) - (1 - Math.exp(-Math.exp(s1)))) * 1000) / 1000;
			var alertMsg = "From: " + from + "\\nTo: " + to + "\\nCount: " + v[i] + " (" + percentage + "%)\\nProbability from: " + pval1 + "-" + pval2 + "\\nCDF: " + cdfVal;
			result.add("<rect x='" + x + "' y='" + y + "' width='20' height='" + h + "' onclick='alert(\"" + alertMsg + "\");' />");
		}
		result.add("</g>");
		var highestPVal = 0;
		var listOfPoints = new haxe_ds_List();
		var _g = 0;
		while(_g < 28) {
			var i = _g++;
			var val = i * hd + this.low;
			var z = (val - distribution.mMu) / distribution.mBeta;
			var pval = 1.0 / distribution.mBeta * Math.exp(-(z + Math.exp(-z)));
			listOfPoints.add({ x : val, y : pval, i : i});
			if(!(highestPVal > pval)) {
				highestPVal = pval;
			}
			val = (i * hd + this.low) * 3 / 4 + ((i + 1) * hd + this.low) / 4;
			var z1 = (val - distribution.mMu) / distribution.mBeta;
			pval = 1.0 / distribution.mBeta * Math.exp(-(z1 + Math.exp(-z1)));
			if(!(highestPVal > pval)) {
				highestPVal = pval;
			}
			listOfPoints.add({ x : val, y : pval, i : i + 0.25});
			val = (i * hd + this.low + ((i + 1) * hd + this.low)) / 2;
			var z2 = (val - distribution.mMu) / distribution.mBeta;
			pval = 1.0 / distribution.mBeta * Math.exp(-(z2 + Math.exp(-z2)));
			if(!(highestPVal > pval)) {
				highestPVal = pval;
			}
			listOfPoints.add({ x : val, y : pval, i : i + 0.5});
			val = (i * hd + this.low) / 4 + ((i + 1) * hd + this.low) * 3 / 4;
			var z3 = (val - distribution.mMu) / distribution.mBeta;
			pval = 1.0 / distribution.mBeta * Math.exp(-(z3 + Math.exp(-z3)));
			if(!(highestPVal > pval)) {
				highestPVal = pval;
			}
			listOfPoints.add({ x : val, y : pval, i : i + 0.75});
		}
		result.add("<g style='stroke-width:1;stroke:#00f;'>");
		var lastX = -1;
		var lastY = -1;
		var _g5_head = listOfPoints.h;
		while(_g5_head != null) {
			var val = _g5_head.item;
			_g5_head = _g5_head.next;
			var obj = val;
			var val1 = obj.x;
			var pval = obj.y;
			var x = 30 + obj.i * 20;
			var h = pval / highestPVal * 350;
			var y = 365 - h;
			if(lastX != -1 && lastY != -1) {
				result.add("<line x1='" + lastX + "' y1='" + lastY + "' x2='" + x + "' y2='" + y + "'/>");
			}
			lastX = x;
			lastY = y;
		}
		result.add("</g>");
		result.add("</svg>");
		return result.join("");
	}
	,__class__: champuru_score_ScoreListVisualizer
};
var champuru_score_ScoreSorter = function() {
};
champuru_score_ScoreSorter.__name__ = true;
champuru_score_ScoreSorter.prototype = {
	sort: function(scores) {
		var result = scores.slice();
		result.sort(function(a,b) {
			var result = b.score - a.score;
			if(result == 0) {
				return a.mismatches - b.mismatches;
			} else if(result > 0) {
				return 1;
			}
			return -1;
		});
		return result;
	}
	,__class__: champuru_score_ScoreSorter
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
	toString: function() {
		return this.get_message();
	}
	,get_message: function() {
		return this.message;
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
	__class__: haxe_ValueException
});
var haxe_io_Bytes = function(data) {
	this.length = data.byteLength;
	this.b = new Uint8Array(data);
	this.b.bufferValue = data;
	data.hxBytes = this;
	data.bytes = this.b;
};
haxe_io_Bytes.__name__ = true;
haxe_io_Bytes.ofString = function(s,encoding) {
	if(encoding == haxe_io_Encoding.RawNative) {
		var buf = new Uint8Array(s.length << 1);
		var _g = 0;
		var _g1 = s.length;
		while(_g < _g1) {
			var i = _g++;
			var c = s.charCodeAt(i);
			buf[i << 1] = c & 255;
			buf[i << 1 | 1] = c >> 8;
		}
		return new haxe_io_Bytes(buf.buffer);
	}
	var a = [];
	var i = 0;
	while(i < s.length) {
		var c = s.charCodeAt(i++);
		if(55296 <= c && c <= 56319) {
			c = c - 55232 << 10 | s.charCodeAt(i++) & 1023;
		}
		if(c <= 127) {
			a.push(c);
		} else if(c <= 2047) {
			a.push(192 | c >> 6);
			a.push(128 | c & 63);
		} else if(c <= 65535) {
			a.push(224 | c >> 12);
			a.push(128 | c >> 6 & 63);
			a.push(128 | c & 63);
		} else {
			a.push(240 | c >> 18);
			a.push(128 | c >> 12 & 63);
			a.push(128 | c >> 6 & 63);
			a.push(128 | c & 63);
		}
	}
	return new haxe_io_Bytes(new Uint8Array(a).buffer);
};
haxe_io_Bytes.prototype = {
	getString: function(pos,len,encoding) {
		if(pos < 0 || len < 0 || pos + len > this.length) {
			throw haxe_Exception.thrown(haxe_io_Error.OutsideBounds);
		}
		if(encoding == null) {
			encoding = haxe_io_Encoding.UTF8;
		}
		var s = "";
		var b = this.b;
		var i = pos;
		var max = pos + len;
		switch(encoding._hx_index) {
		case 0:
			var debug = pos > 0;
			while(i < max) {
				var c = b[i++];
				if(c < 128) {
					if(c == 0) {
						break;
					}
					s += String.fromCodePoint(c);
				} else if(c < 224) {
					var code = (c & 63) << 6 | b[i++] & 127;
					s += String.fromCodePoint(code);
				} else if(c < 240) {
					var c2 = b[i++];
					var code1 = (c & 31) << 12 | (c2 & 127) << 6 | b[i++] & 127;
					s += String.fromCodePoint(code1);
				} else {
					var c21 = b[i++];
					var c3 = b[i++];
					var u = (c & 15) << 18 | (c21 & 127) << 12 | (c3 & 127) << 6 | b[i++] & 127;
					s += String.fromCodePoint(u);
				}
			}
			break;
		case 1:
			while(i < max) {
				var c = b[i++] | b[i++] << 8;
				s += String.fromCodePoint(c);
			}
			break;
		}
		return s;
	}
	,toString: function() {
		return this.getString(0,this.length);
	}
	,__class__: haxe_io_Bytes
};
var haxe_io_Encoding = $hxEnums["haxe.io.Encoding"] = { __ename__:true,__constructs__:null
	,UTF8: {_hx_name:"UTF8",_hx_index:0,__enum__:"haxe.io.Encoding",toString:$estr}
	,RawNative: {_hx_name:"RawNative",_hx_index:1,__enum__:"haxe.io.Encoding",toString:$estr}
};
haxe_io_Encoding.__constructs__ = [haxe_io_Encoding.UTF8,haxe_io_Encoding.RawNative];
var haxe_crypto_Base64 = function() { };
haxe_crypto_Base64.__name__ = true;
haxe_crypto_Base64.encode = function(bytes,complement) {
	if(complement == null) {
		complement = true;
	}
	var str = new haxe_crypto_BaseCode(haxe_crypto_Base64.BYTES).encodeBytes(bytes).toString();
	if(complement) {
		switch(bytes.length % 3) {
		case 1:
			str += "==";
			break;
		case 2:
			str += "=";
			break;
		default:
		}
	}
	return str;
};
var haxe_crypto_BaseCode = function(base) {
	var len = base.length;
	var nbits = 1;
	while(len > 1 << nbits) ++nbits;
	if(nbits > 8 || len != 1 << nbits) {
		throw haxe_Exception.thrown("BaseCode : base length must be a power of two.");
	}
	this.base = base;
	this.nbits = nbits;
};
haxe_crypto_BaseCode.__name__ = true;
haxe_crypto_BaseCode.prototype = {
	encodeBytes: function(b) {
		var nbits = this.nbits;
		var base = this.base;
		var size = b.length * 8 / nbits | 0;
		var out = new haxe_io_Bytes(new ArrayBuffer(size + (b.length * 8 % nbits == 0 ? 0 : 1)));
		var buf = 0;
		var curbits = 0;
		var mask = (1 << nbits) - 1;
		var pin = 0;
		var pout = 0;
		while(pout < size) {
			while(curbits < nbits) {
				curbits += 8;
				buf <<= 8;
				buf |= b.b[pin++];
			}
			curbits -= nbits;
			out.b[pout++] = base.b[buf >> curbits & mask];
		}
		if(curbits > 0) {
			out.b[pout++] = base.b[buf << nbits - curbits & mask];
		}
		return out;
	}
	,__class__: haxe_crypto_BaseCode
};
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
var haxe_ds_StringMap = function() {
	this.h = Object.create(null);
};
haxe_ds_StringMap.__name__ = true;
haxe_ds_StringMap.__interfaces__ = [haxe_IMap];
haxe_ds_StringMap.prototype = {
	__class__: haxe_ds_StringMap
};
var haxe_io_Error = $hxEnums["haxe.io.Error"] = { __ename__:true,__constructs__:null
	,Blocked: {_hx_name:"Blocked",_hx_index:0,__enum__:"haxe.io.Error",toString:$estr}
	,Overflow: {_hx_name:"Overflow",_hx_index:1,__enum__:"haxe.io.Error",toString:$estr}
	,OutsideBounds: {_hx_name:"OutsideBounds",_hx_index:2,__enum__:"haxe.io.Error",toString:$estr}
	,Custom: ($_=function(e) { return {_hx_index:3,e:e,__enum__:"haxe.io.Error",toString:$estr}; },$_._hx_name="Custom",$_.__params__ = ["e"],$_)
};
haxe_io_Error.__constructs__ = [haxe_io_Error.Blocked,haxe_io_Error.Overflow,haxe_io_Error.OutsideBounds,haxe_io_Error.Custom];
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
		if(o.__enum__) {
			var e = $hxEnums[o.__enum__];
			var con = e.__constructs__[o._hx_index];
			var n = con._hx_name;
			if(con.__params__) {
				s = s + "\t";
				return n + "(" + ((function($this) {
					var $r;
					var _g = [];
					{
						var _g1 = 0;
						var _g2 = con.__params__;
						while(true) {
							if(!(_g1 < _g2.length)) {
								break;
							}
							var p = _g2[_g1];
							_g1 = _g1 + 1;
							_g.push(js_Boot.__string_rec(o[p],s));
						}
					}
					$r = _g;
					return $r;
				}(this))).join(",") + ")";
			} else {
				return n;
			}
		}
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
		return o.__enum__ != null ? $hxEnums[o.__enum__] == cl : false;
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
if(typeof(performance) != "undefined" ? typeof(performance.now) == "function" : false) {
	HxOverrides.now = performance.now.bind(performance);
}
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
champuru_base_SingleNucleotide.sAdenine = 1;
champuru_base_SingleNucleotide.sCytosine = 2;
champuru_base_SingleNucleotide.sThymine = 4;
champuru_base_SingleNucleotide.sGuanine = 8;
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
champuru_score_GumbelDistribution.eulerMascheroniConst = 0.5772156649015328606065120900824024310421593359399235988057672348;
haxe_crypto_Base64.CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
haxe_crypto_Base64.BYTES = haxe_io_Bytes.ofString(haxe_crypto_Base64.CHARS);
champuru_Worker.main();
})(typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this);

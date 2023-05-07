/**
 * Copyright (c) 2023 Université libre de Bruxelles, eeg-ebe Department, Yann Spöri
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package champuru;

import champuru.base.AmbiguousNucleotideSequence;
import champuru.base.SingleAmbiguousNucleotide;

/**
 * Main entry point for web.
 *
 * @author Yann Spoeri
 */
class Worker
{
	static var mMsgs:List<String> = new List<String>();

	public static function out(s:String) {
		mMsgs.add(s);
	}

	public static function generateHtml(fwd:String, rev:String, scoreCalculationMethod:Int, iOffset:Int, jOffset:Int, useThisOffsets:Bool) {
	    mMsgs.clear();
		
		out("<fieldset>");
        out("<legend>Input</legend>");
        out("<p>Forward sequence of length " + (fwd.length) + ": <span class='sequence'>");
        out(fwd);
        out("</p><p>Reverse sequence of length " + (rev.length) + ": <span class='sequence'>");
        out(rev);
        out("</p>");
        out("<p>Score calculation method: " + scoreCalculationMethod + "</p>");
        if (useThisOffsets) {
            out("<p>Offsets to use: " + iOffset + " and " + jOffset + ".</p>");
        } else {
			out("<p>Calculate offsets and use best offsets.</p>");
		}
        out("</fieldset>");
        out("<br>");

		return {
            result : mMsgs.join("")
        };
	}

    #if js
    static var workerScope:js.html.DedicatedWorkerGlobalScope;

    public static function onMessage(e:js.html.MessageEvent):Void {
        try {
            var fwd:String = cast(e.data.fwd, String);
            var rev:String = cast(e.data.rev, String);
            var scoreCalculationMethod:Int = cast(e.data.score, Int);
            var i:Int = cast(e.data.i, Int);
            var j:Int = cast(e.data.j, Int);
            var use:Bool = cast(e.data.useOffsets, Bool);
            var result = generateHtml(fwd, rev, scoreCalculationMethod, i, j, use); // ""; //doChampuru(fwd, rev, scoreCalculationMethod, i, j, use);
            workerScope.postMessage(result);
        } catch(e:Dynamic) {
            workerScope.postMessage("The following error occurred: " + e);
        }
    }
    public static function main() {
        workerScope = untyped self;
        workerScope.onmessage = onMessage;
	}
    #end
}
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
package champuru.score;

import haxe.ds.Vector;

/**
 * Visualize the score results.
 * 
 * @author Yann Spoeri
 */
class ScoreListVisualizer
{
	var scores:Array<{nr:Int, index:Int, score:Float, matches:Int, mismatches:Int}>;
	var high:Float;
	var low:Float;

	public function new(sortedScores:Array<{nr:Int, index:Int, score:Float, matches:Int, mismatches:Int}>) {
		scores = sortedScores;
		high = sortedScores[0].score;
		var lowScore = sortedScores.pop();
		sortedScores.push(lowScore);
		low = lowScore.score;
	}

    public function genScorePlot():String {
        var result:List<String> = new List<String>();
        result.add("<svg id='scorePlot' class='plot middle' width='600' height='400'>");
        result.add("<rect width='600' height='400' style='fill:white' />");
        result.add("<text x='010' y='200' text-anchor='middle' style='font-family: monospace; text-size: 12.5px' transform='rotate(270 7.5 195)'>Score</text>");
        result.add("<text x='300' y='395' text-anchor='middle' style='font-family: monospace; text-size: 12.5px'>Offset</text>");
        var d:Float = high - low;
        var i:Int = 0;
        for (score in scores) {
            var x:Float = 30 + (560.0 * (i / scores.length));
            var y:Float = 370 - (350 * ((score.score - low) / d));
            var alertMsg:String = "Offset: " + score.index + "\\nScore: " + score.score + "\\nMatches: " + score.matches + "\\nMismatches: " + score.mismatches;
            result.add("<circle id='c" + score.index + "' cx='" + x + "' cy='" + y + "' r='2' fill='black' title='" + 1 + "' onclick='alert(\"" + alertMsg + "\")' />");
            i++;
        }
        result.add("</svg>");
        return result.join("");
    }

    public function genScorePlotHist():String {
        var d:Float = high - low;
        var result:List<String> = new List<String>();
        result.add("<svg id='scorePlotHist' class='plot middle' width='600' height='400'>");
        result.add("<rect width='600' height='400' style='fill:white' />");
        result.add("<text x='010' y='200' text-anchor='middle' style='font-family: monospace; text-size: 12.5px' transform='rotate(270 7.5 195)'>Frequency</text>");
        result.add("<text x='300' y='395' text-anchor='start' style='font-family: monospace; text-size: 12.5px'>Score</text>");
        result.add("<text x='030' y='380' text-anchor='middle' style='font-family: monospace; text-size: 12.5px'>" + Math.floor(low) + "</text>");
        result.add("<text x='170' y='380' text-anchor='middle' style='font-family: monospace; text-size: 12.5px'>" + Math.round(d / 4) + "</text>");
        result.add("<text x='310' y='380' text-anchor='middle' style='font-family: monospace; text-size: 12.5px'>" + Math.round(d / 2) + "</text>");
        result.add("<text x='450' y='380' text-anchor='middle' style='font-family: monospace; text-size: 12.5px'>" + Math.round(d / 4 * 3) + "</text>");
        result.add("<text x='590' y='380' text-anchor='end' style='font-family: monospace; text-size: 12.5px'>" + Math.ceil(high) + "</text>");
        var hd:Float = d / 28;
        var i:Int = 0;
        var v:Vector<Int> = new Vector<Int>(28);
        for (i in 0...28) {
            v[i] = 0;
        }
        for (score in scores) {
            var scoreP:Float = ((score.score - low) / d);
            var b:Float = scoreP * 28;
            var i:Int = Math.floor(b);
            if (i >= 28) {
                i = 27;
            }
            v[i]++;
        }
        var highest:Int = 0;
        for (val in v) {
            highest = (highest > val) ? highest : val;
        }
        result.add("<g style='stroke-width:1;stroke:#000;fill:#fff'>");
        for (i in 0...28) {
            if (v[i] == 0) {
                continue;
            }
            var val:Float = v[i] / highest;
            var x:Float = 30 + i * 20;
            var h:Float = val * 350;
            var y:Float = 365 - h;
            var from:Float = Math.round((i * hd + low) * 10) / 10.0;
            var to:Float = Math.round(((i + 1) * hd + low) * 10) / 10.0;
            var percentage:Float = (Math.round(v[i] / scores.length * 1000) / 10.0);
            var alertMsg:String = "From: " + from + "\\nTo: " + to + "\\nCount: " + v[i] + " (" + percentage + "%)";
            result.add("<rect x='" + x + "' y='" + y + "' width='20' height='" + h + "' onclick='alert(\"" + alertMsg + "\");' />");
        }
        result.add("</g>");
        result.add("</svg>");
        return result.join("");
    }
}
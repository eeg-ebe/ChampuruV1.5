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

import champuru.score.GumbelDistribution;
import haxe.ds.Vector;

/**
 * Visualize the score results.
 * 
 * @author Yann Spoeri
 */
class ScoreListVisualizer
{
    var scores:Array<{nr:Int, index:Int, score:Float, matches:Int, mismatches:Int}>;
    var sortedScores:Array<{nr:Int, index:Int, score:Float, matches:Int, mismatches:Int}>;
    var high:Float;
    var low:Float;

    public function new(scores:Array<{nr:Int, index:Int, score:Float, matches:Int, mismatches:Int}>, sortedScores:Array<{nr:Int, index:Int, score:Float, matches:Int, mismatches:Int}>) {
        this.scores = scores;
        this.sortedScores = sortedScores;
        high = sortedScores[0].score;
        var lowScore = sortedScores.pop();
        sortedScores.push(lowScore);
        low = lowScore.score;
    }

    public function genScorePlot():String {
        var result:List<String> = new List<String>();
        result.add("<svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' id='scorePlot' class='plot middle' width='600' height='400'>");
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

    public function genScorePlotHist(distribution:GumbelDistribution):String {
        var d:Float = high - low;
        var result:List<String> = new List<String>();
        result.add("<svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' id='scorePlotHist' class='plot middle' width='600' height='400'>");
        result.add("<rect width='600' height='400' style='fill:white' />");
        result.add("<text x='010' y='200' text-anchor='middle' style='font-family: monospace; text-size: 12.5px' transform='rotate(270 7.5 195)'>Frequency</text>");
        result.add("<text x='025' y='200' text-anchor='middle' style='font-family: monospace; text-size: 12.5px' transform='rotate(270 20.5 195)'>Probability</text>");
        result.add("<text x='380' y='020' text-anchor='start' style='font-family: monospace; text-size: 12.5px; fill: #0ff'>P (higher score)</text>");
        result.add("<text x='380' y='035' text-anchor='start' style='font-family: monospace; text-size: 12.5px; fill: #00f'>P (score)</text>");
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
        for (score in sortedScores) {
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
            var percentage:Float = (Math.round(v[i] / sortedScores.length * 1000) / 10.0);
            var pval1:Float = Math.round(distribution.getProbabilityForScore(from) * 1000) / 1000;
            var pval2:Float = Math.round(distribution.getProbabilityForScore(to) * 1000) / 1000;
            var cdfVal:Float = Math.round((distribution.getProbabilityForHigherScore(from) - distribution.getProbabilityForHigherScore(to)) * 1000) / 1000;
            var alertMsg:String = "From: " + from + "\\nTo: " + to + "\\nCount: " + v[i] + " (" + percentage + "%)\\nProbability from: " + pval1 + "-" + pval2 + "\\nCDF: " + cdfVal;
            result.add("<rect x='" + x + "' y='" + y + "' width='20' height='" + h + "' onclick='alert(\"" + alertMsg + "\");' />");
        }
        result.add("</g>");
        
        var highestPVal:Float = 0;
        var listOfPoints:List<{x:Float, y:Float, i:Float, d:Float}> = new List<{x:Float, y:Float, i:Float, d:Float}>();
        for (i in 0...28) {
            var val:Float = (i * hd + low);
            var pval:Float = distribution.getProbabilityForScore(val);
            var d:Float = distribution.getProbabilityForHigherScore(val);
            listOfPoints.add({x : val, y : pval, i : i, d : d});
            highestPVal = (highestPVal > pval) ? highestPVal : pval;
            
            val = (i * hd + low) * 3 / 4 + ((i + 1) * hd + low) / 4;
            pval = distribution.getProbabilityForScore(val);
            d = distribution.getProbabilityForHigherScore(val);
            highestPVal = (highestPVal > pval) ? highestPVal : pval;
            listOfPoints.add({x : val, y : pval, i : i + 0.25, d : d});
            
            val = ((i * hd + low) + ((i + 1) * hd + low)) / 2;
            pval = distribution.getProbabilityForScore(val);
            d = distribution.getProbabilityForHigherScore(val);
            highestPVal = (highestPVal > pval) ? highestPVal : pval;
            listOfPoints.add({x : val, y : pval, i : i + 0.5, d : d});
            
            val = (i * hd + low) / 4 + ((i + 1) * hd + low) * 3 / 4;
            pval = distribution.getProbabilityForScore(val);
            d = distribution.getProbabilityForHigherScore(val);
            highestPVal = (highestPVal > pval) ? highestPVal : pval;
            listOfPoints.add({x : val, y : pval, i : i + 0.75, d : d});
        }
        result.add("<g style='stroke-width:1;stroke:#00f;'>");
        var lastX:Float = -1, lastY:Float = -1, lastY2:Float = -1;
        for (obj in listOfPoints) {
            var val:Float = obj.x;
            var pval:Float = obj.y;
            var x:Float = 30 + obj.i * 20;
            var h:Float = pval / highestPVal * 350;
            var y:Float = 365 - h;
            
            var y2:Float = 365 - obj.d * 350;
            
            if (lastX != -1 && lastY != -1) {
                result.add("<line x1='" + lastX + "' y1='" + lastY + "' x2='" + x + "' y2='" + y + "'/>");
                result.add("<line x1='" + lastX + "' y1='" + lastY2 + "' x2='" + x + "' y2='" + y2 + "' style='stroke:#0ff'/>");
            }
            lastX = x;
            lastY = y;
            lastY2 = y2;
        }
        result.add("</g>");
        result.add("</svg>");
        return result.join("");
    }
}
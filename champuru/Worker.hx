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

import champuru.base.NucleotideSequence;

import champuru.score.AScoreCalculator;
import champuru.score.ScoreCalculatorList;
import champuru.score.ScoreSorter;
import champuru.score.ScoreListVisualizer;
import champuru.consensus.OverlapSolver;
/*

import champuru.base.AmbiguousNucleotideSequence;

import champuru.reconstruction.Reconstructor;
import champuru.reconstruction.UnexplainedSequenceConstructor;
import champuru.checker.DirectSequencingSimulator;
*/
import champuru.perl.PerlChampuruReimplementation;

import haxe.crypto.Base64;
import haxe.io.Bytes;
import haxe.Timer;

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

        // 0. Step - old champuru
        out("<fieldset>");
        out("<legend>Output of the original Champuru 1.0 program</legend>");
        out("<span style='font-family: monospace; word-break: break-all;'>");
        var output:String = PerlChampuruReimplementation.runChampuru(fwd, rev, false).getOutput();
        output = StringTools.htmlEscape(output);
        output = StringTools.replace(output, "\n", "<br/>");
        out(output);
        out("</span>");
        out("</fieldset>");
        out("<br>");
        
        var s1:NucleotideSequence = NucleotideSequence.fromString(fwd);
        var s2:NucleotideSequence = NucleotideSequence.fromString(rev);

        // 1. Step
        var lst:ScoreCalculatorList = ScoreCalculatorList.instance();
        var calculator:AScoreCalculator = lst.getScoreCalculator(1);
        var scores = calculator.calcOverlapScores(s1, s2);
        var sortedScores = new ScoreSorter().sort(scores);

        var sortedScoresStringList:List<String> = new List<String>();
        sortedScoresStringList.add("#\tOffset\tScore\tMatches\tMismatches");
        var i:Int = 1;
        for (score in sortedScores) {
            sortedScoresStringList.add(i + "\t" + score.index + "\t" + score.score + "\t" + score.matches + "\t" + score.mismatches);
            i++;
        }
        var sortedScoresString:String = sortedScoresStringList.join("\n");
        var sortedScoresStringB64:String = Base64.encode(Bytes.ofString(sortedScoresString));
        
        var vis = new ScoreListVisualizer(scores, sortedScores);
        var scorePlot:String = vis.genScorePlot();
        var histPlot:String = vis.genScorePlotHist();
        
        out("<fieldset>");
        out("<legend>1. Step - Compatibility score calculation</legend>");
        out("<p>The following table [<a href-lang='text/tsv' title='table.tsv' href='data:text/tsv;base64,\n");
        out(sortedScoresStringB64);
        out("' title='table.tsv' download='table.tsv'>Download</a>] lists the best compatibility scores and their positions:</p>");
        out("<table class='scoreTable center'>");
        out("<tr class='header'>");
        out("<td>#</td><td>Offset</td><td>Score</td><td>Matches</td><td>Mismatches</td>");
        out("</tr>");
        var i:Int = 1;
        for (score in sortedScores) {
            out("<tr class='" + ((i % 2 == 0) ? "odd" : "even") + "' onmouseover='highlight(\"c" + score.index + "\")' onmouseout='removeHighlight(\"c" + score.index + "\")'>");
            out("<td>" + i + "</td><td>" + score.index + "</td><td>" + score.score + "</td><td>" +  score.matches + "</td><td>" + score.mismatches + "</td>");
            out("</tr>");
            i++;
            if (i >= 6) { break; }
        }
        out("</table>");
        out("<p>Here is a plot of the shift calculation result:</p>");
        out(scorePlot);
        out("<p>Warning: Close points may be overlapping!</p>");
        out("<p>And as histogram:</p>");
        out(histPlot);
        
        var score1:Int = sortedScores[0].index;
        var score2:Int = sortedScores[1].index;
        if (useThisOffsets) {
            score1 = iOffset;
            score2 = jOffset;
        }
        
        if (useThisOffsets) {
            out("<p>User requested to use the offsets " + iOffset + " and " + jOffset + " for calculation.</p>");
        } else {
            out("<p>Using offsets " + score1 + " and " + score2 + " for calculation.</p>");
        }
        out("<span class='middle'><button onclick='rerunAnalysisWithDifferentOffsets(\"" + fwd + "\", \"" + rev + "\", " + scoreCalculationMethod + ")'>Use different offsets</button></span>");
        out("</fieldset>");
        out("<br>");
        
        // 2. Step - Calculate consensus sequences
        var o1 = new OverlapSolver(score1, s1, s2).solve();
        var o2 = new OverlapSolver(score2, s1, s2).solve();
        
        out("<fieldset>");
        out("<legend>2. Step - Calculate consensus sequences</legend>");
        out("<p>First consensus sequence: <span id='consensus1' class='sequence'>");
        out(o1.toString());
        out("</span></p>");
        out("<p>Second consensus sequence: <span id='consensus2' class='sequence'>");
        out(o2.toString());
        out("</span></p>");
        var problems:Int = o1.countGaps() + o2.countGaps();
        var remainingAmbFwd:Int = o1.countPolymorphisms();
        var remainingAmbRev:Int = o2.countPolymorphisms();
        if (problems == 1) {
            out("<p>There is 1 incompatible position (indicated with an underscore), please check the input sequences.</p>");
        } else if (problems > 1) {
            out("<p>There are " + problems + " incompatible positions (indicated with underscores), please check the input sequences.</p>");
        }
        if (problems > 0) {
            out("<span class='middle'><button onclick='colorConsensusByIncompatiblePositions()'>Color underscores</button><button onclick='removeColor()'>Remove color</button></span>");
        }
        if (remainingAmbFwd == 1) {
            out("<p>There is 1 ambiguity in the first consensus sequence.</p>");
        } else if (remainingAmbFwd > 1) {
            out("<p>There are " + remainingAmbFwd + " ambiguities in the first consensus sequence.</p>");
        }
        if (remainingAmbRev == 1) {
            out("<p>There is 1 ambiguity in the second consensus sequence.</p>");
        } else if (remainingAmbRev > 1) {
            out("<p>There are " + remainingAmbRev + " ambiguities in the second consensus sequence.</p>");
        }
        if (remainingAmbFwd + remainingAmbRev > 0) {
            out("<span class='middle'><button onclick='colorConsensusByAmbPositions()'>Color ambiguities</button><button onclick='removeColor()'>Remove color</button></span>");
        }
        out("</fieldset>");
        out("<br>");
        
        // 3. Step - Sequence reconstruction
        // 4. Step - Checking
        // 5. Step - Searching for alternative solutions
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
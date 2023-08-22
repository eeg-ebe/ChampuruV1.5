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
import champuru.reconstruction.SequenceReconstructor;
import champuru.reconstruction.SequenceChecker;
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
    
    public static inline function timeToStr(f:Float):String {
        return "" + Math.round(f * 1000);
    }

    public static function generateHtml(fwd:String, rev:String, scoreCalculationMethod:Int, iOffset:Int, jOffset:Int, useThisOffsets:Bool) {
        mMsgs.clear();
        
        out("<fieldset>");
        out("<legend>Input</legend>");
        out("<p>Forward sequence of length " + (fwd.length) + ": <span id='input1' class='sequence'>");
        out(fwd);
        out("</p><p>Reverse sequence of length " + (rev.length) + ": <span id='input2' class='sequence'>");
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
        var timestamp:Float = Timer.stamp();
        out("<legend>Output of the original Champuru 1.0 program</legend>");
        out("<span id='champuruOutput' style='font-family: monospace; word-break: break-all; display: none;'>");
        var output:String = PerlChampuruReimplementation.runChampuru(fwd, rev, false).getOutput();
        output = StringTools.htmlEscape(output);
        output = StringTools.replace(output, "\n", "<br/>");
        out(output);
        out("</span>");
        out("<span class='middle'><button id='showLink' onclick='document.getElementById(\"champuruOutput\").style.display = \"block\";document.getElementById(\"showLink\").style.display = \"none\";'>Show output</button></span>");
        out("<div class='timelegend'>Calculation took " + timeToStr(Timer.stamp() - timestamp) + "ms</div>");
        out("</fieldset>");
        out("<br>");
        
        var s1:NucleotideSequence = NucleotideSequence.fromString(fwd);
        var s2:NucleotideSequence = NucleotideSequence.fromString(rev);

        // 1. Step
        var timestamp:Float = Timer.stamp();
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
        out("<div class='timelegend'>Calculation took " + timeToStr(Timer.stamp() - timestamp) + "ms</div>");
        out("</fieldset>");
        out("<br>");
        
        // 2. Step - Calculate consensus sequences
        var timestamp:Float = Timer.stamp();
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
        out("<div class='timelegend'>Calculation took " + timeToStr(Timer.stamp() - timestamp) + "ms</div>");
        out("</fieldset>");
        out("<br>");
        
        // 3. Step - Sequence reconstruction
        var timestamp:Float = Timer.stamp();
        var result = SequenceReconstructor.reconstruct(o1, o2);
        out("<fieldset>");
        out("<legend>3. Step - Sequence reconstruction</legend>");
        out("<p>First reconstructed sequence [<a href='#' onclick='return toClipboard(\"reconstructed1\")'>Copy all bases to clipboard</a>] [<a href='#' onclick='return toClipboard(\"reconstructed1\", false)'>Copy only overlap between the two chromatograms (in capital letters) to clipboard</a>]: <span id='reconstructed1' class='sequence'>");
        out(result.seq1.toString());
        out("</span></p>");
        out("<p>Second reconstructed sequence [<a href='#' onclick='return toClipboard(\"reconstructed2\")'>Copy all bases to clipboard</a>] [<a href='#' onclick='return toClipboard(\"reconstructed2\", false)'>Copy only overlap between the two chromatograms (in capital letters) to clipboard</a>]: <span id='reconstructed2' class='sequence'>");
        out(result.seq2.toString());
        out("</span></p>");
//        out("<span class='middle'><button onclick='download()'>Download</button></span>");
        out("<div class='timelegend'>Calculation took " + timeToStr(Timer.stamp() - timestamp) + "ms</div>");
        out("</fieldset>");
        out("<br>");
        
        // 4. Step - Checking
        var timestamp:Float = Timer.stamp();
        out("<fieldset>");
        out("<legend>4. Step - Checking sequences</legend>");
        // polymorphisms left
        var p1:Int = result.seq1.countPolymorphisms();     // all
        var p2:Int = result.seq2.countPolymorphisms();
        var p1u:Int = result.seq1.countPolymorphisms(0.8); // in upper
        var p2u:Int = result.seq2.countPolymorphisms(0.8);
        var p1l:Int = p1 - p1u;                            // in lower
        var p2l:Int = p2 - p2u;
        if (p1u + p2u == 0) {
            if (p1l + p2l == 0) {
                out("<p>The bases overlapping in the forward and reverse chromatograms have been successfully deconvoluted.</p>");
            } else if (p1l > 0 && p2l > 0) {
                out("<p>The bases overlapping in the forward and reverse chromatograms have been successfully deconvoluted. However " + p1l + " ambiguit" + ((p1l == 1) ? "y" : "ies") + " remain in the first reconstructed sequence in places where the two chromatograms do not overlap and " + p2l + " ambiguit" + ((p2l == 1) ? "y" : "ies") + " remain in the second reconstructed sequence in places where the two chromatograms do not overlap.</p>");
            } else {
                out("<p>The bases overlapping in the forward and reverse chromatograms have been successfully deconvoluted. However " + (p1l + p2l) + " ambiguit" + (((p1l + p2l) == 1) ? "y" : "ies") + " remain in the " + ((p1l > 0) ? "first" : "second") + " reconstructed sequence in places where the two chromatograms do not overlap.</p>");
            }
        } else {
            if (p1u > 0) {
                out("<p>There " + ((p1u == 1) ? "is" : "are") + " " + p1u + " ambiguit" + ((p1u == 1) ? "y" : "ies") + " on the first reconstructed sequence left!</p>");
            }
            if (p1l > 0) {
                out("<p>" + p1l + " ambiguit" + ((p1l == 1) ? "y" : "ies") + " remain in the first reconstructed sequence in places where the two chromatograms do not overlap.</p>");
            }
            if (p2u > 0) {
                out("<p>There " + ((p2u == 1) ? "is" : "are") + " " + p2u + " ambiguit" + ((p2u == 1) ? "y" : "ies") + " on the second reconstructed sequence left!</p>");
            }
            if (p2l > 0) {
                out("<p>" + p2l + " ambiguit" + ((p2l == 1) ? "y" : "ies") + " remain in the first reconstructed sequence in places where the two chromatograms do not overlap.</p>");
            }
        }
        if (p1 + p2 > 0) {
            out("<span class='middle'><button onclick='colorFinalByAmbPositions()'>Color ambiguities</button><button onclick='removeColorFinal()'>Remove color</button></span>");
            out("<br>");
        }
        // Check positions
        var seqChecker:SequenceChecker = new SequenceChecker(s1, s2);
        seqChecker.setOffsets(score1, score2);
        var checkerResult = seqChecker.check(result.seq1, result.seq2);
        if (checkerResult.pF.length + checkerResult.pR.length >= 1)  {
            out("<p>");
            if (checkerResult.pF.length > 0) {
                out("Check position" + ((checkerResult.pF.length == 1) ? "" : "s") + " on forward (and/or the facing positions on the reverse): <span class='sequence'>" + checkerResult.pF.join(",") + "</span>");
            }
            if (checkerResult.pF.length > 0 && checkerResult.pR.length > 0) {
                out("<br>");
            }
            if (checkerResult.pR.length > 0) {
                out("Check position" + ((checkerResult.pR.length == 1) ? "" : "s") + " on reverse (and/or the facing positions on the forward): <span class='sequence'>" + checkerResult.pR.join(",") + "</span>");
            }
            out("</p>");
        }
        if (checkerResult.pF.length + checkerResult.pR.length > 0) {
            out("<span class='middle'><button onclick='colorFinalByPositions(\"" + checkerResult.pF.join(",") + "\", \"" + checkerResult.pR.join(",") + "\", \"" + checkerResult.pFHighlight.join(",") + "\", \"" + checkerResult.pRHighlight.join(",") + "\");'>Color positions</button><button onclick='removeColorFinal()'>Remove color</button></span>");
            out("<br>");
        }
        // problems
        problems = result.seq1.countGaps() + result.seq2.countGaps();
        if (problems == 0) {
        } else if (problems == 1) {
            out("<p>There is 1 problematic position!</p>");
        } else if (problems > 1) {
            out("<p>There are " + problems + " problematic positions!</p>");
        }
        if (problems > 0) {
            out("<span class='middle'><button onclick='colorProblems()'>Color problems</button><button onclick='removeColorFinal()'>Remove color</button></span>");
        }
        out("<div class='timelegend'>Calculation took " + timeToStr(Timer.stamp() - timestamp) + "ms</div>");
        out("</fieldset>");
        out("<br>");
        
        // 5. Step - Searching for alternative solutions
        //AAAHNSYKRWTYMMMMMRSSRMSGSCCYWRSMWWMCCSRRGGRWYSGRARR
        //MRMTGMTKMWYMMMRCRRCGRCSSYMSYAKMMYMSMSGRRKSRKMRGRRKA
        /*        out("<fieldset>");
        out("<legend>5. Step - Searching for alternative solutions</legend>");
        var possibleMatches:List<Int> = new List<Int>();
        var i:Int = 0;
        for (score in sortedScores) {
            if (i > 5) {
                break;
            }
            i++;
            if (score.mismatches <= 10) {
                possibleMatches.add(score.index);
            }
        }
        var possibilities:List<{a:Int, b:Int}> = new List<{a:Int, b:Int}>();
        for (p1 in possibleMatches) {
            for (p2 in possibleMatches) {
                possibilities.add({a: p1, b: p2});
            }
        }
        for (p in possibilities) {
            out("=== Checking offset " + p.a + " " + p.b + " ===<br>");
            
            var o1 = new OverlapSolver(p.a, s1, s2).solve();
            var o2 = new OverlapSolver(p.b, s1, s2).solve();
        }
        out("</fieldset>");
        out("<br>");*/
        
        // Download area
        if (problems == 0) {
            out("<fieldset>");
            out("<legend>Download area</legend>");
            out("<span class='middle'><button onclick='downloadFasta(true)'>Download FASTA (all bases)</button><button onclick='downloadFasta(false)'>Download FASTA (only overlap)</button></span><br>");
            out("</fieldset>");
        }
        
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
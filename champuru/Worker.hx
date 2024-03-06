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
import champuru.score.GumbelDistribution;
import champuru.score.GumbelDistributionEstimator;
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
    
    public static inline function formatFloat(f:Float):String {
        var number:Float = f * Math.pow(10, 3);
        return "" + (Math.round(number) / Math.pow(10, 3));
    }

    public static function generateHtml(fwd:String, rev:String, scoreCalculationMethod:Int, iOffset:Int, jOffset:Int, useThisOffsets:Bool, searchForAlternativeSolutions:Bool) {
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
        var perlReimplementationOutput = PerlChampuruReimplementation.runChampuru(fwd, rev, false);
        var output:String = perlReimplementationOutput.getOutput();
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
        var calculator:AScoreCalculator = lst.getScoreCalculator(scoreCalculationMethod);
        var scores = calculator.calcOverlapScores(s1, s2);
        var sortedScores = new ScoreSorter().sort(scores);

        var ge:GumbelDistributionEstimator = new GumbelDistributionEstimator(s1, s2);
        var distribution:GumbelDistribution = ge.calculate(calculator);
        
        var sortedScoresStringList:List<String> = new List<String>();
        sortedScoresStringList.add("#\tOffset\tScore\tMatches\tMismatches\tP(score)\tP(higher score)");
        var i:Int = 1;
        for (score in sortedScores) {
            sortedScoresStringList.add(i + "\t" + score.index + "\t" + score.score + "\t" + score.matches + "\t" + score.mismatches + "\t" + distribution.getProbabilityForScore(score.score) + "\t" + distribution.getProbabilityForHigherScore(score.score));
            i++;
        }
        var sortedScoresString:String = sortedScoresStringList.join("\n");
        var sortedScoresStringB64:String = Base64.encode(Bytes.ofString(sortedScoresString));
        
        var vis = new ScoreListVisualizer(scores, sortedScores);
        
        var scorePlot:String = vis.genScorePlot();
        var histPlot:String = vis.genScorePlotHist(distribution);
        
        out("<fieldset>");
        out("<legend>Step 1 - Alignment score calculation</legend>");
        out("<p>The following table <a style='display:none' id='downloadScoreTable' href-lang='text/tsv' title='table.tsv' href='data:text/tsv;base64,\n");
        out(sortedScoresStringB64);
        out("' title='table.tsv' download='table.tsv'>Download</a>lists the best compatibility scores and their positions:</p>");
        out("<table class='scoreTable center'>");
        out("<tr class='header'>");
        out("<td>#</td><td>Offset</td><td>Score</td><td>Matches</td><td>Mismatches</td><td>P(score)</td><td>P(higher score)</td>");
        out("</tr>");
        var i:Int = 1;
        for (score in sortedScores) {
            out("<tr class='" + ((i % 2 == 0) ? "odd" : "even") + "' onmouseover='highlight(\"c" + score.index + "\")' onmouseout='removeHighlight(\"c" + score.index + "\")'>");
            out("<td>" + i + "</td><td>" + score.index + "</td><td>" + score.score + "</td><td>" +  score.matches + "</td><td>" + score.mismatches + "</td><td>" + formatFloat(distribution.getProbabilityForScore(score.score)) + "</td><td>" + formatFloat(distribution.getProbabilityForHigherScore(score.score)) + "</td>");
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
        out("<span class='middle'><button onclick='rerunAnalysisWithDifferentOffsets(\"" + fwd + "\", \"" + rev + "\", " + scoreCalculationMethod + ")'>Use different offsets</button><button onclick='document.getElementById(\"downloadScoreTable\").click();'>Download score table</button></span>");
        out("<span class='middle'><button onclick='downloadPlot(\"scorePlot\")'>Download dot plot</button><button onclick='downloadPlot(\"scorePlotHist\")'>Download histogram</button></span>");
        out("<div class='timelegend'>Calculation took " + timeToStr(Timer.stamp() - timestamp) + "ms</div>");
        out("</fieldset>");
        out("<br>");
        
        // 2. Step - Calculate consensus sequences
        var timestamp:Float = Timer.stamp();
        var o1 = new OverlapSolver(score1, s1, s2).solve();
        var o2 = new OverlapSolver(score2, s1, s2).solve();
        
        out("<fieldset>");
        out("<legend>Step 2 - Consensus sequence calculation</legend>");
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
        
        if (problems > 0) {
            return {
                result : mMsgs.join("")
            };
        }
        
        // 3. Step - Sequence reconstruction
        var timestamp:Float = Timer.stamp();
        var result = SequenceReconstructor.reconstruct(o1, o2);
        out("<fieldset>");
        out("<legend>Step 3 - Sequence reconstruction</legend>");
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
        out("<legend>Step 4 - Checking sequences</legend>");
        var successfullyDeconvoluted:Bool = true;
        // problems
        problems = result.seq1.countGaps() + result.seq2.countGaps();
        if (problems == 0) {
        } else if (problems == 1) {
            out("<p>There is 1 problematic position!</p>");
            successfullyDeconvoluted = false;
        } else if (problems > 1) {
            out("<p>There are " + problems + " problematic positions!</p>");
            successfullyDeconvoluted = false;
        }
        if (problems > 0) {
            out("<span class='middle'><button onclick='colorProblems()'>Color problems</button><button onclick='removeColorFinal()'>Remove color</button></span>");
        }
        // polymorphisms left
        var p1:Int = result.seq1.countPolymorphisms();     // all
        var p2:Int = result.seq2.countPolymorphisms();
        var p1u:Int = result.seq1.countPolymorphisms(0.8); // in upper
        var p2u:Int = result.seq2.countPolymorphisms(0.8);
        var p1l:Int = p1 - p1u;                            // in lower
        var p2l:Int = p2 - p2u;
        if (p1u + p2u == 0) {
            // ignore for now!
        } else {
            if (p1u > 0) {
                out("<p>There " + ((p1u == 1) ? "is" : "are") + " " + p1u + " ambiguit" + ((p1u == 1) ? "y" : "ies") + " on the first reconstructed sequence left!</p>");
//                successfullyDeconvoluted = false;
            }
            if (p1l > 0) {
                out("<p>" + p1l + " ambiguit" + ((p1l == 1) ? "y" : "ies") + " remain in the first reconstructed sequence in places where the two chromatograms do not overlap.</p>");
            }
            if (p2u > 0) {
                out("<p>There " + ((p2u == 1) ? "is" : "are") + " " + p2u + " ambiguit" + ((p2u == 1) ? "y" : "ies") + " on the second reconstructed sequence left!</p>");
//                successfullyDeconvoluted = false;
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
            successfullyDeconvoluted = false;
        }
        if (checkerResult.pF.length + checkerResult.pR.length > 0) {
            out("<span class='middle'><button onclick='colorFinalByPositions(\"" + checkerResult.pF.join(",") + "\", \"" + checkerResult.pR.join(",") + "\", \"" + checkerResult.pFHighlight.join(",") + "\", \"" + checkerResult.pRHighlight.join(",") + "\");'>Color positions</button><button onclick='removeColorFinal()'>Remove color</button></span>");
            out("<br>");
        }
        if (successfullyDeconvoluted && p1u + p2u == 0) {
            if (p1l + p2l == 0) {
                out("<p>The bases overlapping in the forward and reverse chromatograms have been successfully deconvoluted.</p>");
            } else if (p1l > 0 && p2l > 0) {
                out("<p>The bases overlapping in the forward and reverse chromatograms have been successfully deconvoluted. However " + p1l + " ambiguit" + ((p1l == 1) ? "y" : "ies") + " remain in the first reconstructed sequence in places where the two chromatograms do not overlap and " + p2l + " ambiguit" + ((p2l == 1) ? "y" : "ies") + " remain in the second reconstructed sequence in places where the two chromatograms do not overlap.</p>");
            } else {
                out("<p>The bases overlapping in the forward and reverse chromatograms have been successfully deconvoluted. However " + (p1l + p2l) + " ambiguit" + (((p1l + p2l) == 1) ? "y" : "ies") + " remain in the " + ((p1l > 0) ? "first" : "second") + " reconstructed sequence in places where the two chromatograms do not overlap.</p>");
            }
        }
        // Check that the output is similar to the output of the "original" Champuru program
        var firstSequenceIsSame:Bool = result.seq1.toString().indexOf(perlReimplementationOutput.sequence1) != -1 || result.seq1.toString().indexOf(perlReimplementationOutput.sequence2) != -1;
        var secondSequenceIsSame:Bool = result.seq2.toString().indexOf(perlReimplementationOutput.sequence1) != -1 || result.seq2.toString().indexOf(perlReimplementationOutput.sequence2) != -1;
        if (!firstSequenceIsSame || !secondSequenceIsSame) {
            var idx1Same = perlReimplementationOutput.index1 == score1 || perlReimplementationOutput.index1 == score2;
            var idx2Same = perlReimplementationOutput.index2 == score1 || perlReimplementationOutput.index2 == score2;
            if (idx1Same && idx2Same) {
                out("<p>The deconvoluted sequences from the (reimplemented) original Champuru program mismatches with the deconvoluted sequences from this program although the same offsets have been used. If you find this in a real life example please send your chromatograms to <a href='mailto: jflot@ulb.ac.be'>jflot@ulb.be</a>.</p>");
            } else {
                out("<p>The deconvoluted sequences from the (reimplemented) original Champuru program mismatches with the deconvoluted sequences from this program because different offsets have been used.<p>");
            }
        }
        out("<div class='timelegend'>Calculation took " + timeToStr(Timer.stamp() - timestamp) + "ms</div>");
        out("</fieldset>");
        out("<br>");
        
        // 5. Step - Searching for alternative solutions
        if (searchForAlternativeSolutions) {
            var timestamp:Float = Timer.stamp();
            out("<fieldset>");
            out("<legend>Step 5 - Analyzing further offset pairs</legend>");
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
                    if (p1 > p2) {
                        if (!((p1 == score1 && p2 == score2) || (p2 == score1 && p1 == score2))) {
                            possibilities.add({a: p1, b: p2});
                        }
                    }
                }
            }
            var scores:Array<{score:Int, idx1:Int, idx2:Int, pF:Int, pR:Int, p:Int}> = new Array<{score:Int, idx1:Int, idx2:Int, pF:Int, pR:Int, p:Int}>();
            for (p in possibilities) {
                var o1 = new OverlapSolver(p.a, s1, s2).solve();
                var o2 = new OverlapSolver(p.b, s1, s2).solve();
                var result2 = SequenceReconstructor.reconstruct(o1, o2);
                
                var seqChecker2:SequenceChecker = new SequenceChecker(s1, s2);
                seqChecker2.setOffsets(p.a, p.b);
                var checkerResult2 = seqChecker2.check(result2.seq1, result2.seq2);
                
                var score = {
                    score : checkerResult2.pF.length + checkerResult2.pR.length + result2.seq1.countGaps() + result2.seq2.countGaps(),
                    idx1 : p.a,
                    idx2 : p.b,
                    pF : checkerResult2.pF.length,
                    pR : checkerResult2.pR.length,
                    p : result2.seq1.countGaps() + result2.seq2.countGaps()
                };
                scores.push(score);
            }
            scores.sort(function(a:{score:Int, idx1:Int, idx2:Int, pF:Int, pR:Int, p:Int}, b:{score:Int, idx1:Int, idx2:Int, pF:Int, pR:Int, p:Int}):Int {
                return a.score - b.score;
            });
            out("<table class='offsetTable center'>");
            out("<tr class='header'>");
            out("<td>#</td><td>Nr. of issues</td><td>Offset 1</td><td>Offset 2</td><td>Use</td>");
            out("</tr>");
            var i:Int = 1;
            for (score in scores) {
                out("<tr class='" + ((i % 2 == 0) ? "odd" : "even") + "'>");
                out("<td>" + i + "</td><td>" + score.score + "</td><td>" + score.idx1 + "</td><td>" +  score.idx2 + "</td><td><a href='#' onclick='rerunAnalysisWithDifferentOffsets3(\"" + fwd + "\", \"" + rev + "\", " + scoreCalculationMethod + ", " + score.idx1 + ", " + score.idx2 + ", true); return false;'>Calculate</a></td>");
                out("</tr>");
                i++;
                if (i > 5) {
                    break;
                }
            }
            out("</table>");
            //if (() || ()) {
            //    out("<p>Use offsets</p>");
            //}
            out("<div class='timelegend'>Calculation took " + timeToStr(Timer.stamp() - timestamp) + "ms</div>");
            out("</fieldset>");
            out("<br>");
        }
        
        // Download area
        if (problems == 0 && successfullyDeconvoluted) {
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
            var searchForAlternativeSolutions:Bool = cast(e.data.searchForAlternativeSolutions, Bool);
            var result = generateHtml(fwd, rev, scoreCalculationMethod, i, j, use, searchForAlternativeSolutions); // ""; //doChampuru(fwd, rev, scoreCalculationMethod, i, j, use);
            workerScope.postMessage(result);
        } catch(e) {
            trace(e);
            workerScope.postMessage({
                result : "The following error occurred: " + e
            });
        }
    }
    public static function main() {
        workerScope = untyped self;
        workerScope.onmessage = onMessage;
    }
    #end
}
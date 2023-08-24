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
import champuru.score.AScoreCalculator;
import champuru.score.ScoreSorter;
import champuru.score.ScoreCalculatorList;
import champuru.score.ScoreListVisualizer;
import champuru.consensus.OverlapSolver;
import champuru.reconstruction.Reconstructor;
import champuru.reconstruction.UnexplainedSequenceConstructor;
import champuru.checker.DirectSequencingSimulator;

class Champuru
{
    /**
     * Generate the needed spaces for text outputting.
     */
    public static function genSpaceStr(n:Int):String {
        if (n <= 0) {
            return "";
        }
        var result:List<String> = new List<String>();
        for (i in 0...n) {
            result.add(" ");
        }
        return result.join("");
    }
    
    public static function runChampuru(i:Int, j:Int, s1:AmbiguousNucleotideSequence, s2:AmbiguousNucleotideSequence):{ new1:AmbiguousNucleotideSequence, new2:AmbiguousNucleotideSequence } {
        return {
            new1: null,
            new2: null
        }
    }
    
    /**
     *
     */
    public static function main() {
        var args = Sys.args();
        var s1:AmbiguousNucleotideSequence = null;
        var s2:AmbiguousNucleotideSequence = null;
        if (args.length == 2) {
            s1 = AmbiguousNucleotideSequence.fromString(args[0]);
            s2 = AmbiguousNucleotideSequence.fromString(args[1]);
        } else {
    //        var s1:AmbiguousNucleotideSequence = AmbiguousNucleotideSequence.fromString("CTRAATTCAAATCACACTCGCGAAAWYMWKRAA");
    //        var s2:AmbiguousNucleotideSequence = AmbiguousNucleotideSequence.fromString("YWRAWTYMAAWYMMMMYYSSSRAAATCRTGAA");
            
              s1 = AmbiguousNucleotideSequence.fromString("AAATSSYKRWTYMMMMMRSSRMSGSCCYWRSMWWMCCSRRGGRWYSGRARR");
              s2 = AmbiguousNucleotideSequence.fromString("MRMTGMTKMWYMMMRCRRCGRCSSYMSYAKMMYMSMSGRRKSRKMRGRRKA");
              s1 = AmbiguousNucleotideSequence.fromString("ATCGTGGGCGGCCGGCCCTGCCACAGACGGGGTTGTCACCCTCTGCGACGTGCCGTTCCAAGCAACTTAGGCAGGGCCCCTCCGCCTAGAAAGTGCTTCTCGCAACTACAACTCGCCGATGCAGGCATCGGAGATTTCAAATTTGAGCTCTTCCCGCTTCACTCGCCGTTACTGGGGGAATCCTTGTTAGTTTCTTTTCCTCCGCTTATTAATATGCTTAAATTCAGCGGGTAGCCTTGCCTGATCTGAGGTCTGGAAGGCGATTCCTTTTTTCCTTTGAGATGCCGCCACCGCTACCCGGCGGCAGCAGAAAAAAGAATCGAATGGAGAAAGATTTGTTCCGTCAAAGCGATAGAGCCGTGGCCGTTTGGGGTACATTGTTCTATGATCCCCGCGCGACACCGGATGTCGCTTGGCGGATCTTTCTCCCTGAATTTCAAGGGACGCGGTAAACCGACCGGTCGGGCCGAGCAGCACCAGGGCTGGCTAGCTAGCGCACGACCGGTCATCTCGACCGCGACCCTCAACGCCGCACGAACCCGTTCACGGCGGGCGCGYSYCSSSSCCMYMYSCKMYASASRSGGRSMMSRSGSRSRCGCGCRCRCGSRKWYKCRCRMKRKRKRTKTKWRWAKASACWCWSASASASAYRYKCYYSKGRGARMMCMMRAGMGCSMYWTKYGYKYWMARAKWYKMKRWKWYWCWSWRWWYTCYGCWWYTCACWCTWYWTMTCRSMMTCKMKCTGA");
              s2 = AmbiguousNucleotideSequence.fromString("GTGCRMTMTCAACACMCSASTCTCGMRACRCATMKYGKGSGSSSSSSSCYSYSMCASASRSGGKKKTSWCMCYCTSYGMSRYGYSSYKYYMMRMRMMWYWKRSRSRGSSCCYCYSCSYMKARARWGYKYYTCKCRMMWMYAMMWCKCSSMKRYRSRSRYMKSRGAKWTYWMAWWTKWGMKCTYYYCSCKYYWCWCKCSSYKWYWSKGGGRRWMYYYKTKWKWKTYTYTTYYYCYSCKYWTWWWWATRYKYWWAWWYWSMGSGKRKMSYYKYSYSWKMTSWGRKSTSKRRRRSGMKWYYYYTTTTYYYYTKWGAKRYSSCSMCMSCKMYMCSSSGSSRSMRSARAAAARARWMKMRWRKRGARARAKWTKTKYYSYSWMARMGMKAKAGMSSYGKSSSYKTKKGGKRYAYWKTKYTMTRWKMYCCSCGCGMSACMSSRKRTSKCKYKKSGSRKMTYTYTCYCYSWRWWTYWMRRGRSRCGSKRWAMMSMSMSSKSKSGSSSMGMRSMRCMMSRGSKSKSKMKMKMKMGCRCRMSMSSKSWYMTCKMSMSCGMSMCYCWMMRCSSCRCRMRMMCSYKYWCRSSGSGSGCGCGTCCCGGCCCCATCCGCTACAGACGGGGACCAGGCGGACGCGCGCACGCGGATTCGCACGATGGATGTTTGAATAGACACTCAGACAGACATGCTCCTGGGAGAACCCAAGAGCGCCATTTGCGTTCAAAGATTCGATGATTCACTGAAT");

    //        s1 = AmbiguousNucleotideSequence.fromString("AATKCRRSYSTT");
    //        s2 = AmbiguousNucleotideSequence.fromString("AAWTSSAGCYKT");
//            s1 = AmbiguousNucleotideSequence.fromString("AWRKMYKSMRWWSCGAA");
//            s2 = AmbiguousNucleotideSequence.fromString("AAAWYKGRMWYYSMRRM");
            s1 = AmbiguousNucleotideSequence.fromString("ATYSRRRAA");
            s2 = AmbiguousNucleotideSequence.fromString("AAWTYRRRRA");
    //        s1 = AmbiguousNucleotideSequence.fromString("ATTYSRGRRCA");
    //        s2 = AmbiguousNucleotideSequence.fromString("AAWWTYSGAGSA");
    
    
//            s1 = AmbiguousNucleotideSequence.fromString("AAATSSYKRWTYMMMMMRSSRMSGSCCYWRSMWWMCCSRRGGRWYSGRARR");
//            s2 = AmbiguousNucleotideSequence.fromString("MRMTGMTKMWYMMMRCRRCGRCSSYMSYAKMMYMSMSGRRKSRKMRGRRKA");
        }
        
        trace("Input:");
        trace("s1: " + s1.toString());
        trace("s2: " + s2.toString());
        trace("");
        
        var lst:ScoreCalculatorList = ScoreCalculatorList.instance();
        var calculator:AScoreCalculator = lst.getScoreCalculator(0);
        var scores = calculator.calcOverlapScores(s1, s2);
        
        var sortedScores = new ScoreSorter().sort(scores);
//        sortedScores[0].index = -4;
//        sortedScores[1].index = 0;
        
        var bestScore0:Int = sortedScores[0].index;
        var bestScore1:Int = sortedScores[1].index;
        var bestScore2:Int = sortedScores[2].index;
        var bestScore3:Int = sortedScores[3].index;
        var bestScore4:Int = sortedScores[4].index;
        trace("best positions: " + bestScore0 + " " + bestScore1 + " " + bestScore2 + " " + bestScore3 + " " + bestScore4);
        
        var vis = new ScoreListVisualizer(scores, sortedScores);
        vis.genScorePlot();
        vis.genScorePlotHist();
        
        var o1 = new OverlapSolver(sortedScores[0].index, s1, s2).solve();
        var o2 = new OverlapSolver(sortedScores[1].index, s1, s2).solve();
        
        var indent1:Int = (sortedScores[0].index >= 0) ? sortedScores[0].index : 0;
        var indent2:Int = (sortedScores[0].index < 0) ? -sortedScores[0].index : 0;
        var indent3:Int = (sortedScores[1].index >= 0) ? sortedScores[1].index : 0;
        var indent4:Int = (sortedScores[1].index < 0) ? -sortedScores[1].index : 0;
        var x1 = UnexplainedSequenceConstructor.minus(indent1, s1, o1, true);
        var x2 = UnexplainedSequenceConstructor.minus(indent2, s2, o1, true);
        var x3 = UnexplainedSequenceConstructor.minus(indent3, s1, o2, true);
        var x4 = UnexplainedSequenceConstructor.minus(indent4, s2, o2, true);
        
        trace("O " + genSpaceStr(sortedScores[0].index) + s1.toString());
        trace("O " + genSpaceStr(-sortedScores[0].index) + s2.toString());
        trace("C " + o1);
        trace("R " + x1);
        trace("R " + x2);
        trace("");
        trace("O " + genSpaceStr(sortedScores[1].index) + s1.toString());
        trace("O " + genSpaceStr(-sortedScores[1].index) + s2.toString());
        trace("C " + o2);
        trace("R " + x3);
        trace("R " + x4);
        trace("");
        trace("");

        var spaceA:Int = 1;
        var spaceB:Int = 0;
        var diff:Int = sortedScores[1].index + sortedScores[1].index;
        var t1:AmbiguousNucleotideSequence = new OverlapSolver( spaceA, o1, x3).solve();
        var t2:AmbiguousNucleotideSequence = new OverlapSolver(-spaceB, o1, x4).solve();
        var t3:AmbiguousNucleotideSequence = new OverlapSolver(-spaceA, o2, x1).solve();
        var t4:AmbiguousNucleotideSequence = new OverlapSolver( spaceB, o2, x2).solve();
        trace("T1 o1 " + genSpaceStr(spaceA) + o1);
        trace("T1 x3 " + genSpaceStr(-spaceA) + x3);
        trace("T1 t1 " + t1);
        trace("");
        trace("T2 o1 " + genSpaceStr(-spaceB) + o1);
        trace("T2 x4 " + genSpaceStr(spaceB) + x4);
        trace("T2 t2 " + t2);
        trace("");
        trace("T3 o2 " + genSpaceStr(-spaceA) + o2);
        trace("T3 x1 " + genSpaceStr(spaceA) + x1);
        trace("T3 t3 " + t3);
        trace("");
        trace("T4 o2 " + genSpaceStr(spaceB) + o2);
        trace("T4 x2 " + genSpaceStr(-spaceB) + x2);
        trace("T4 t4 " + t4);
        
        /*
        var new1:AmbiguousNucleotideSequence = x1;
        var new2:AmbiguousNucleotideSequence = x3;
        for (i in 0...3) {
            var old1:AmbiguousNucleotideSequence = new1;
            var old2:AmbiguousNucleotideSequence = new2;
            
            
        }

        var co1:AmbiguousNucleotideSequence = o1;
        var co2:AmbiguousNucleotideSequence = o2;
        /*
        var ol = UnexplainedSequenceConstructor.minus(0, o2l, co1, true);
        var o2 = UnexplainedSequenceConstructor.minus(0, o1l, co2, true);
        
        trace("A " + o2l);
        trace("B " + co1);
        trace("C " + ol);
        trace("");
        trace("A " + o1l);
        trace("B " + co2);
        trace("C " + o2);
        trace("");
        */
    }
    
    
}
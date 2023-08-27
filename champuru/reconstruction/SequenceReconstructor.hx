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
package champuru.reconstruction;

import champuru.base.NucleotideSequence;
import champuru.base.SingleNucleotide;

/**
 * Reconstructor.
 *
 * @author Yann Spoeri
 */
class SequenceReconstructor
{
    public static function getBegin(s:NucleotideSequence):Int {
        var begin:Int = 0;
        while (s.get(begin).getQuality() < 0.75) {
            begin++;
        }
        return begin;
    }
    public static function getEnd(s:NucleotideSequence):Int {
        var end:Int = s.length() - 1;
        while (s.get(end).getQuality() < 0.75) {
            end--;
        }
        return end;
    }

    /**
     * Reconstruct sequences.
     */
    public static function reconstruct(seq1:NucleotideSequence, seq2:NucleotideSequence):{seq1:NucleotideSequence, seq2:NucleotideSequence} {
        var seq1begin:Int = getBegin(seq1);
        var seq2begin:Int = getBegin(seq2);
        
        var changed:Bool = true;
        var round:Int = 1;
        while (changed) {
            changed = false;
            
            var seqLen1:Int = seq1.length();
            var seqLen2:Int = seq2.length();
            var seqLen:Int = (seqLen1 > seqLen2) ? seqLen2 : seqLen1;
            trace("=== Reconstruction round " + round + " (" + seq1begin + ", " + seq2begin + ", " + seqLen + ") ===");
            round++;
            
            for (j in 0...seqLen) {
                var idx1:Int = seq1begin + j;
                var idx2:Int = seq2begin + j;
                
                if (!(idx1 >= seqLen1 || idx2 >= seqLen2 || seq1.get(idx1).getQuality() < 0.75 || seq2.get(idx2).getQuality() < 0.75)) {
                    var seq1n:SingleNucleotide = seq1.get(idx1);
                    var seq2n:SingleNucleotide = seq2.get(idx2);
                    
                    if(seq1n.isPolymorphism() || seq2n.isPolymorphism()) {
                        var data:String = "F Positions " + idx1 + ", " + idx2 + ": " + seq1n.toIUPACCode() + " " + seq2n.toIUPACCode() + " " + (seq1n.getCode() != seq2n.getCode()) + " " + seq1n.isOverlapping(seq2n);
                        if (seq1n.getCode() != seq2n.getCode()) {
                            if (seq1n.isOverlapping(seq2n)) {
                                if (seq1n.getCode() > seq2n.getCode()) {
                                    var code:Int = seq1n.getCode() - seq2n.getCode();
                                    var newN:SingleNucleotide = new SingleNucleotide(code);
                                    seq1.replace(idx1, newN);
                                    changed = true;
                                    data = data + " (seq1) " + idx1 + "->" + newN.toIUPACCode();
                                } else { // $seq2[$j]=$rev_code{$code{$seq2[$j]}-$code{$seq1[$j]}}
                                    var code:Int = seq2n.getCode() - seq1n.getCode();
                                    var newN:SingleNucleotide = new SingleNucleotide(code);
                                    seq2.replace(idx2, newN);
                                    changed = true;
                                    data = data + " (seq2) " + idx2 + "->" + newN.toIUPACCode();
                                }
                            }
                        }
                        trace(data);
                    }
                }
                
                
                var idx1_:Int = seq1.length() - 1 - j;
                var idx2_:Int = seq2.length() - 1 - j;
                
                if (!(idx1_ < 0 || idx2_ < 0 || seq1.get(idx1_).getQuality() < 0.75 || seq2.get(idx2_).getQuality() < 0.75)) {
                    var seq1n_:SingleNucleotide = seq1.get(idx1_);
                    var seq2n_:SingleNucleotide = seq2.get(idx2_);
                    
                    if(seq1n_.isPolymorphism() || seq2n_.isPolymorphism()) {
                        var data:String = "R Positions " + idx1_ + ", " + idx2_ + ": " + seq1n_.toIUPACCode() + " " + seq2n_.toIUPACCode() + " " + (seq1n_.getCode() != seq2n_.getCode()) + " " + seq1n_.isOverlapping(seq2n_);
                        if ((seq1n_.getCode() != seq2n_.getCode())) {
                            if (seq1n_.isOverlapping(seq2n_)) {
                                if (seq1n_.getCode() > seq2n_.getCode()) {
                                    var code:Int = seq1n_.getCode() - seq2n_.getCode();
                                    var newN:SingleNucleotide = new SingleNucleotide(code);
                                    seq1.replace(idx1_, newN);
                                    changed = true;
                                    data = data + " (seq1) " + idx1_ + "->" + newN.toIUPACCode();
                                } else {
                                    var code:Int = seq2n_.getCode() - seq1n_.getCode();
                                    var newN:SingleNucleotide = new SingleNucleotide(code);
                                    seq2.replace(idx2_, newN);
                                    changed = true;
                                    data = data + " (seq2) " + idx2_ + "->" + newN.toIUPACCode();
                                }
                            }
                        }
                        trace(data);
                    }
                }
            }
            trace("changed " + changed);
        }
        
        return {
            seq1: seq1,
            seq2: seq2
        };
    }
    
    /**
     * Reconstruct sequences.
     */
    public static function reconstruct2(seq1:NucleotideSequence, seq2:NucleotideSequence, round=0):List<{seq1:NucleotideSequence, seq2:NucleotideSequence}> {
        var seq1begin:Int = getBegin(seq1);
        var seq2begin:Int = getBegin(seq2);
        
        var toChange:List<{isSeq1:Bool, pos:Int, newNN:SingleNucleotide}> = new List<{isSeq1:Bool, pos:Int, newNN:SingleNucleotide}>();
        var round:Int = 1;
            
        var seqLen1:Int = seq1.length();
        var seqLen2:Int = seq2.length();
        var seqLen:Int = (seqLen1 > seqLen2) ? seqLen2 : seqLen1;
        round++;
        
        for (j in 0...seqLen) {
            var idx1:Int = seq1begin + j;
            var idx2:Int = seq2begin + j;
            
            if (!(idx1 >= seqLen1 || idx2 >= seqLen2 || seq1.get(idx1).getQuality() < 0.75 || seq2.get(idx2).getQuality() < 0.75)) {
                var seq1n:SingleNucleotide = seq1.get(idx1);
                var seq2n:SingleNucleotide = seq2.get(idx2);
                
                if(seq1n.isPolymorphism() || seq2n.isPolymorphism()) {
                    //trace("F Positions " + idx1 + ", " + idx2 + ": " + seq1n.toIUPACCode() + " " + seq2n.toIUPACCode() + " " + (seq1n.getCode() != seq2n.getCode()) + " " + seq1n.isOverlapping(seq2n));
                    if (seq1n.getCode() != seq2n.getCode()) {
                        if (seq1n.isOverlapping(seq2n)) {
                            if (seq1n.getCode() > seq2n.getCode()) {
                                var code:Int = seq1n.getCode() - seq2n.getCode();
                                var newN:SingleNucleotide = new SingleNucleotide(code);
                                toChange.add({
                                    isSeq1 : true,
                                    pos : idx1,
                                    newNN : newN
                                });
                            } else { // $seq2[$j]=$rev_code{$code{$seq2[$j]}-$code{$seq1[$j]}}
                                var code:Int = seq2n.getCode() - seq1n.getCode();
                                var newN:SingleNucleotide = new SingleNucleotide(code);
                                toChange.add({
                                    isSeq1 : false,
                                    pos : idx2,
                                    newNN : newN
                                });
                            }
                        }
                    }
                }
            }
            
            /*
            var idx1_:Int = seq1.length() - 1 - j;
            var idx2_:Int = seq2.length() - 1 - j;
            
            if (!(idx1_ < 0 || idx2_ < 0 || seq1.get(idx1_).getQuality() < 0.75 || seq2.get(idx2_).getQuality() < 0.75)) {
                var seq1n_:SingleNucleotide = seq1.get(idx1_);
                var seq2n_:SingleNucleotide = seq2.get(idx2_);
                
                if(seq1n_.isPolymorphism() || seq2n_.isPolymorphism()) {
                    //trace("R Positions " + idx1_ + ", " + idx2_ + ": " + seq1n_.toIUPACCode() + " " + seq2n_.toIUPACCode() + " " + (seq1n_.getCode() != seq2n_.getCode()) + " " + seq1n_.isOverlapping(seq2n_));
                    if ((seq1n_.getCode() != seq2n_.getCode())) {
                        if (seq1n_.isOverlapping(seq2n_)) {
                            if (seq1n_.getCode() > seq2n_.getCode()) {
                                var code:Int = seq1n_.getCode() - seq2n_.getCode();
                                var newN:SingleNucleotide = new SingleNucleotide(code);
                                toChange.add({
                                    isSeq1 : true,
                                    pos : idx1_,
                                    newNN : newN
                                });
                            } else {
                                var code:Int = seq2n_.getCode() - seq1n_.getCode();
                                var newN:SingleNucleotide = new SingleNucleotide(code);
                                toChange.add({
                                    isSeq1 : false,
                                    pos : idx2_,
                                    newNN : newN
                                });
                            }
                        }
                    }
                }
            }*/
        }
        
        trace("Length of toChange " + toChange.length);
        var result:List<{seq1:NucleotideSequence, seq2:NucleotideSequence}> = new List<{seq1:NucleotideSequence, seq2:NucleotideSequence}>();
        if (toChange.length > 0) {
            for (change in toChange) {
                if (result.length > 5) {
                    break;
                }
                var r:List<{seq1:NucleotideSequence, seq2:NucleotideSequence}> = new List<{seq1:NucleotideSequence, seq2:NucleotideSequence}>();
                if (change.isSeq1) {
                    var seq1Clone = seq1.clone();
                    seq1Clone.replace(change.pos, change.newNN);
                    r = reconstruct2(seq1Clone, seq2, round++);
                } else {
                    var seq2Clone = seq2.clone();
                    seq2Clone.replace(change.pos, change.newNN);
                    r = reconstruct2(seq1, seq2Clone, round++);
                }
                for (e in r) {
                    if (result.length > 5) {
                        break;
                    }
                    var s1:String = e.seq1.toString();
                    var s2:String = e.seq2.toString();
                    var found:Bool = false;
                    for (ele in result) {
                        var s1ele:String = e.seq1.toString();
                        var s2ele:String = e.seq2.toString();
                        if (s1 == s1ele && s2 == s2ele) {
                            found = true;
                            break;
                        }
                    }
                    if (!found) {
                        result.add(e);
                    }
                }
            }
        } else {
            trace("Solution: " + seq1.toString() + " " + seq2.toString() + " " + round);
            result.add({
                seq1: seq1,
                seq2: seq2
            });
        }
        return result;
    }
}
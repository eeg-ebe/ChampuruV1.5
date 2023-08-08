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

    /**
     * Reconstruct sequences.
     */
    public static function reconstruct(seq1:NucleotideSequence, seq2:NucleotideSequence):{seq1:NucleotideSequence, seq2:NucleotideSequence} {
        var seq1begin:Int = getBegin(seq1);
        var seq2begin:Int = getBegin(seq2);

        var changed:Bool = true;
        while (changed) {
            changed = false;
            
            var seqLen1:Int = seq1.length();
            var seqLen2:Int = seq2.length();
            var seqLen:Int = (seqLen1 > seqLen2) ? seqLen2 : seqLen1;
            
            for (j in 0...seqLen) {
                var idx1:Int = seq1begin + j;
                var idx2:Int = seq2begin + j;
                
                if (idx1 >= seqLen1 || idx2 >= seqLen2) {
                    break;
                }
                
                var seq1n:SingleNucleotide = seq1.get(idx1);
                var seq2n:SingleNucleotide = seq2.get(idx2);
                
                if ((seq1n.getCode() != seq2n.getCode()) && (seq1n.isOverlapping(seq2n))) {
                    if (seq1n.getCode() > seq2n.getCode()) {
                        var code:Int = seq1n.getCode() - seq2n.getCode();
                        var newN:SingleNucleotide = new SingleNucleotide(code);
                        seq1.replace(idx1, newN);
                        changed = true;
                    } else { // $seq2[$j]=$rev_code{$code{$seq2[$j]}-$code{$seq1[$j]}}
                        var code:Int = seq2n.getCode() - seq1n.getCode();
                        var newN:SingleNucleotide = new SingleNucleotide(code);
                        seq2.replace(idx2, newN);
                        changed = true;
                    }
                }
                
                //var seq1n_:SingleNucleotide = seq1.get(idx1);
                //var seq2n_:SingleNucleotide = seq2.get(idx2);
                
                
                
//                if ($seq1[$#seq1-$j] ne $seq2[$#seq2-$j]) {
        //             if (comp($seq1[$#seq1-$j],$seq2[$#seq2-$j])==1) {
        //                 if  ($code{$seq1[$#seq1-$j]} > $code{$seq2[$#seq2-$j]}) {
        //                     $seq1[$#seq1-$j]=$rev_code{$code{$seq1[$#seq1-$j]}-$code{$seq2[$#seq2-$j]}}
        //                 } else {
        //                     $seq2[$#seq2-$j]=$rev_code{$code{$seq2[$#seq2-$j]}-$code{$seq1[$#seq1-$j]}}
        //                 }
        //             }
        //         }
            }
        }
        
        return {
            seq1: seq1,
            seq2: seq2
        };
    }
}
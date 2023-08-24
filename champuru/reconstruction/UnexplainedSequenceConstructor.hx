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

import champuru.base.AmbiguousNucleotideSequence;
import champuru.base.SingleAmbiguousNucleotide;

/**
 * Calculate the unexplained part of a particular overlap.
 *
 * @author Yann Spoeri
 */
class UnexplainedSequenceConstructor
{
    public static function minusAA(a:SingleAmbiguousNucleotide, b:SingleAmbiguousNucleotide):SingleAmbiguousNucleotide {
        if (a.equals(b, false)) {
            return a.cloneWithQual(a.isQuality() && b.isQuality()); // copy a
        } else if (a.matches(b)) {
            var adenine:Bool   = (a.canStandForAdenine() && b.canStandForAdenine()) ? false : a.canStandForAdenine();
            var cytosine:Bool = (a.canStandForCytosine() && b.canStandForCytosine()) ? false : a.canStandForCytosine();
            var thymine:Bool   = (a.canStandForThymine() && b.canStandForThymine()) ? false : a.canStandForThymine();
            var guanine:Bool   = (a.canStandForGuanine() && b.canStandForGuanine()) ? false : a.canStandForGuanine();
            var quality:Bool   = a.isQuality() && b.isQuality();
            return new SingleAmbiguousNucleotide(adenine, cytosine, thymine, guanine, quality);
        }
        // not matching ... (There is probably a problem with the input)
        var adenine:Bool   = a.canStandForAdenine() || b.canStandForAdenine();
        var cytosine:Bool = a.canStandForCytosine() || b.canStandForCytosine();
        var thymine:Bool   = a.canStandForThymine() || b.canStandForThymine();
        var guanine:Bool   = a.canStandForGuanine() || b.canStandForGuanine();
        var quality:Bool   = a.isQuality() && b.isQuality();
        return new SingleAmbiguousNucleotide(adenine, cytosine, thymine, guanine, quality);
    }

    public static function minus(pos:Int, seq1:AmbiguousNucleotideSequence, seq2:AmbiguousNucleotideSequence, copyEnd:Bool):AmbiguousNucleotideSequence {
        var l:List<SingleAmbiguousNucleotide> = new List<SingleAmbiguousNucleotide>();
        
        // prev
        if (pos > 0) {
            for (i in 0...pos) {
                var c:SingleAmbiguousNucleotide = seq2.get(i);
                var copy:SingleAmbiguousNucleotide = c.cloneWithQual(false);
                l.add(copy);
            }
        } else if (pos < 0) {
            for (i in 0...-pos) {
                var c:SingleAmbiguousNucleotide = seq1.get(i);
                var copy:SingleAmbiguousNucleotide = c.cloneWithQual(false);
                l.add(copy);
            }
        } // ignore 0
        
        // mid
        var fwdCorr:Int = (pos < 0) ? -pos : 0;
        var revCorr:Int = (pos > 0) ?  pos : 0;
        var fwdL:Int = fwdCorr + seq2.length();
        var revL:Int = revCorr + seq1.length();
        var overlap:Int = ((fwdL < revL) ? fwdL : revL) - (fwdCorr + revCorr);

        for (pos in 0...overlap) {
            var a:SingleAmbiguousNucleotide = seq1.get(pos + fwdCorr);
            var b:SingleAmbiguousNucleotide = seq2.get(pos + revCorr);
            var copy:SingleAmbiguousNucleotide = minusAA(a, b);
            l.add(copy);
        }

        // end
        if (copyEnd) {
            var lenFwd:Int = seq1.length() + ((pos > 0) ? pos : 0);
            var lenRev:Int = seq2.length() + ((pos < 0) ? -pos : 0);
            if (lenFwd > lenRev) {
                var len:Int = lenFwd - lenRev;
                var posStart:Int = seq1.length() - len;
                for (i in 0...len) {
                    var c:SingleAmbiguousNucleotide = seq1.get(posStart + i);
                    var copy:SingleAmbiguousNucleotide = c.cloneWithQual(false);
                    l.add(copy);
                }
            } else if (lenRev > lenFwd) {
                var len:Int = lenRev - lenFwd;
                var posStart:Int = seq2.length() - len;
                for (i in 0...len) {
                    var c:SingleAmbiguousNucleotide = seq2.get(posStart + i);
                    var copy:SingleAmbiguousNucleotide = c.cloneWithQual(false);
                    l.add(copy);
                }
            }
        }
        
        return new AmbiguousNucleotideSequence(l);
    }

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
    public static function main() {
        var s1 = AmbiguousNucleotideSequence.fromString("AMSSSGKKRMGTT");
        var s2 = AmbiguousNucleotideSequence.fromString("aMRCGSKGWSRgtt");
        var r = minus(0, s1, s2, true);
        trace("" + r);
        /*
        var shift = 1;
        var s1 = AmbiguousNucleotideSequence.fromString("AWTYSRRRAA");
        var s2 = AmbiguousNucleotideSequence.fromString("aAWTYGRRRAa");
        var r = minus(shift, s1, s2, true);
        trace(genSpaceStr(shift) + s1.toString());
        trace(genSpaceStr(-shift) + s2.toString());
        trace(r.toString());
        */
    }
}
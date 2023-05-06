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
package champuru.checker;

import champuru.base.AmbiguousNucleotideSequence;
import champuru.base.SingleAmbiguousNucleotide;

/**
 * An ScoreCalculator.
 *
 * @author Yann Spoeri
 */
class DirectSequencingSimulator
{
    /**
     * Simulate direct sequencing.
     */
    public static inline function simulateDirectSequencing(withEnds:Bool, pos:Int, fwd:AmbiguousNucleotideSequence, rev:AmbiguousNucleotideSequence):AmbiguousNucleotideSequence {
        var result:List<SingleAmbiguousNucleotide> = new List<SingleAmbiguousNucleotide>();
        
        // start
        if (withEnds) {
            if (pos > 0) {
                for (i in 0...pos) {
                    var curr:SingleAmbiguousNucleotide = rev.get(i);
                    var copy:SingleAmbiguousNucleotide = curr.cloneWithQual(false);
                    result.add(copy);
                }
            } else if (pos < 0) {
                for (i in 0...-pos) {
                    var curr:SingleAmbiguousNucleotide = fwd.get(i);
                    var copy:SingleAmbiguousNucleotide = curr.cloneWithQual(false);
                    result.add(copy);
                }
            }
        }
        
        // mid
        var fwdCorr:Int = (pos < 0) ? -pos : 0;
        var revCorr:Int = (pos > 0) ?  pos : 0;
        var fwdL:Int = fwdCorr + rev.length();
        var revL:Int = revCorr + fwd.length();
        var overlap:Int = ((fwdL < revL) ? fwdL : revL) - (fwdCorr + revCorr);
        
        for (pos in 0...overlap) {
            var a:SingleAmbiguousNucleotide = fwd.get(pos + fwdCorr);
            var b:SingleAmbiguousNucleotide = rev.get(pos + revCorr);
            
            var adenine:Bool   = a.canStandForAdenine() || b.canStandForAdenine();
            var cythosine:Bool = a.canStandForCythosine() || b.canStandForCythosine();
            var thymine:Bool   = a.canStandForThymine() || b.canStandForThymine();
            var guanine:Bool   = a.canStandForGuanine() || b.canStandForGuanine();
            
            var copy:SingleAmbiguousNucleotide = new SingleAmbiguousNucleotide(adenine, cythosine, thymine, guanine, true);
            result.add(copy);
        }
        
        // end
        if (withEnds) {
            var lenFwd:Int = fwd.length() + ((pos > 0) ? pos : 0);
            var lenRev:Int = rev.length() + ((pos < 0) ? -pos : 0);
            if (lenFwd > lenRev) {
                var len:Int = lenFwd - lenRev;
                var posStart:Int = fwd.length() - len;
                for (i in 0...len) {
                    var c:SingleAmbiguousNucleotide = fwd.get(posStart + i);
                    var copy:SingleAmbiguousNucleotide = c.cloneWithQual(false);
                    result.add(copy);
                }
            } else if (lenRev > lenFwd) {
                var len:Int = lenRev - lenFwd;
                var posStart:Int = rev.length() - len;
                for (i in 0...len) {
                    var c:SingleAmbiguousNucleotide = rev.get(posStart + i);
                    var copy:SingleAmbiguousNucleotide = c.cloneWithQual(false);
                    result.add(copy);
                }
            }
        }
        
        return new AmbiguousNucleotideSequence(result);
    }
	
	public static inline function main():Void {
		var s1:AmbiguousNucleotideSequence = AmbiguousNucleotideSequence.fromString("cTAAATTCAAATCACACTCGCGAAAATCATGAA");
		var s2:AmbiguousNucleotideSequence = AmbiguousNucleotideSequence.fromString("CTRAATTCAAATCACACTCGCGAAATCATGAAa");
		var r = simulateDirectSequencing(false, -1, s1, s2);
		var orig:AmbiguousNucleotideSequence = AmbiguousNucleotideSequence.fromString("YWRAWTYMAAWYMMMMYYSSSRAAATCRTGAA");
		trace(r.toString());
		trace(orig.isWithin(r));
	}
}

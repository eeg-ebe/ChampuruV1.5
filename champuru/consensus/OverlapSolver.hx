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
package champuru.consensus;

import champuru.base.AmbiguousNucleotideSequence;
import champuru.base.SingleAmbiguousNucleotide;

/**
 * Solver for a particular overlap.
 *
 * @author Yann Spoeri
 */
class OverlapSolver
{
    /**
     * The position.
     */
    var mPos:Int;
    
    /**
     * The forward sequence.
     */
    var mFwd:AmbiguousNucleotideSequence;
    
    /**
     * The reverse sequence.
     */
    var mRev:AmbiguousNucleotideSequence;

    /**
     * Create a new Overlap Solver.
     */
    public function new(pos:Int, fwd:AmbiguousNucleotideSequence, rev:AmbiguousNucleotideSequence) {
        mPos = pos;
        mFwd = fwd;
        mRev = rev;
    }
    
    /**
     * Solve a particular overlap.
     */
    public function solve():AmbiguousNucleotideSequence {
        var l:List<SingleAmbiguousNucleotide> = new List<SingleAmbiguousNucleotide>();
        
        // prev
        if (mPos > 0) {
            for (i in 0...mPos) {
                var c:SingleAmbiguousNucleotide = mRev.get(i);
                var copy:SingleAmbiguousNucleotide = c.cloneWithQual(false);
                l.add(copy);
            }
        } else if (mPos < 0) {
            for (i in 0...-mPos) {
                var c:SingleAmbiguousNucleotide = mFwd.get(i);
                var copy:SingleAmbiguousNucleotide = c.cloneWithQual(false);
                l.add(copy);
            }
        } // ignore 0
        
        // mid
        var fwdCorr:Int = (mPos < 0) ? -mPos : 0;
        var revCorr:Int = (mPos > 0) ?  mPos : 0;
        var fwdL:Int = fwdCorr + mRev.length();
        var revL:Int = revCorr + mFwd.length();
        var overlap:Int = ((fwdL < revL) ? fwdL : revL) - (fwdCorr + revCorr);
        
        for (pos in 0...overlap) {
            var a:SingleAmbiguousNucleotide = mFwd.get(pos + fwdCorr);
            var b:SingleAmbiguousNucleotide = mRev.get(pos + revCorr);
            
            var adenine:Bool   = a.canStandForAdenine() && b.canStandForAdenine();
            var cythosine:Bool = a.canStandForCythosine() && b.canStandForCythosine();
            var thymine:Bool   = a.canStandForThymine() && b.canStandForThymine();
            var guanine:Bool   = a.canStandForGuanine() && b.canStandForGuanine();
            
            var copy:SingleAmbiguousNucleotide = new SingleAmbiguousNucleotide(adenine, cythosine, thymine, guanine, true);
            l.add(copy);
        }
        
        // end
        var lenFwd:Int = mFwd.length() + ((mPos > 0) ? mPos : 0);
        var lenRev:Int = mRev.length() + ((mPos < 0) ? -mPos : 0);
        if (lenFwd > lenRev) {
            var len:Int = lenFwd - lenRev;
            var posStart:Int = mFwd.length() - len;
            for (i in 0...len) {
                var c:SingleAmbiguousNucleotide = mFwd.get(posStart + i);
                var copy:SingleAmbiguousNucleotide = c.cloneWithQual(false);
                l.add(copy);
            }
        } else if (lenRev > lenFwd) {
            var len:Int = lenRev - lenFwd;
            var posStart:Int = mRev.length() - len;
            for (i in 0...len) {
                var c:SingleAmbiguousNucleotide = mRev.get(posStart + i);
                var copy:SingleAmbiguousNucleotide = c.cloneWithQual(false);
                l.add(copy);
            }
        }
        
        return new AmbiguousNucleotideSequence(l);
    }
}
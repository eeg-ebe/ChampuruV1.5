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
 * Class to reconstruct a particular Champuru situation.
 *
 * @author Yann Spoeri
 */
class Reconstructor
{
    /**
     * The best score.
     */
    var mBestScore:Int;
    
    /**
     * The second best score.
     */
    var mSecondBestScore:Int;

    /**
     * The original forward sequence.
     */
    var mFwd:AmbiguousNucleotideSequence;

    /**
     * The original reverse sequence.
     */
    var mRev:AmbiguousNucleotideSequence;

    /**
     * The first reconstructed overlap.
     */
    var mOverlap1:AmbiguousNucleotideSequence;

    /**
     * Create a new complete solver.
     */
    public function new(bestScore:Int, secondBestScore:Int, fwd:AmbiguousNucleotideSequence, rev:AmbiguousNucleotideSequence) {
        mBestScore = bestScore;
        mSecondBestScore = secondBestScore;
        mFwd = fwd;
        mRev = rev;
    }

    /**
     * Get the unexplained part of an overlap.
     */
    public function resolve(orig:AmbiguousNucleotideSequence, neg:AmbiguousNucleotideSequence):AmbiguousNucleotideSequence {
        var l:List<SingleAmbiguousNucleotide> = new List<SingleAmbiguousNucleotide>();

        var pointer1:Int = 0;
        var pointer2:Int = 0;
        
        // begin
        for (i in 0...orig.length()) {
            var c:SingleAmbiguousNucleotide = orig.get(i);
            if (c.isQuality()) {
                break;
            }
            l.add(c);
            pointer1 = i;
        }
        for (i in 0...neg.length()) {
            var c:SingleAmbiguousNucleotide = neg.get(i);
            if (c.isQuality()) {
                break;
            }
            pointer2 = i;
        }
        
        // mid
        while(pointer1 < orig.length() && pointer2 < neg.length()) {
            var a:SingleAmbiguousNucleotide = orig.get(pointer1);
            pointer1++;
            var b:SingleAmbiguousNucleotide = neg.get(pointer2);
            pointer2++;
            
            if (!a.isQuality() || !b.isQuality()) {
                break;
            }
            
            var adenine:Bool   = a.canStandForAdenine() && b.canStandForAdenine();
            var cytosine:Bool  = a.canStandForCytosine() && b.canStandForCytosine();
            var thymine:Bool   = a.canStandForThymine() && b.canStandForThymine();
            var guanine:Bool   = a.canStandForGuanine() && b.canStandForGuanine();
            
            var m:SingleAmbiguousNucleotide = new SingleAmbiguousNucleotide(adenine, cytosine, thymine, guanine, true);
            if (m.countPossibleNucleotides() == 0) {
                //m = a;
            }
            
            l.add(m);
        }
        
        // end
        while (pointer1 < orig.length()) {
            var c:SingleAmbiguousNucleotide = orig.get(pointer1);
            pointer1++;
            l.add(c);
        }

        var result:AmbiguousNucleotideSequence = new AmbiguousNucleotideSequence(l);
        return result;
    }

    /**
     * Solve a particular situation.
     */
    public function solve(overlap1:AmbiguousNucleotideSequence, overlap2:AmbiguousNucleotideSequence):{ newOverlap1:AmbiguousNucleotideSequence, newOverlap2:AmbiguousNucleotideSequence, changed:Bool, problems:Bool } {
        var cpy1:AmbiguousNucleotideSequence = overlap1.clone();
        var cpy2:AmbiguousNucleotideSequence = overlap2.clone();
        
        var changed:Bool = false;
        var problems:Bool = false;
        
        
        
        return {
            newOverlap1 : cpy1,
            newOverlap2 : cpy2,
            changed: changed,
            problems: problems
        }
    }
    
    /**
     * Solve a particular situation.
     */
    private function _solve(overlap1:AmbiguousNucleotideSequence, overlap2:AmbiguousNucleotideSequence, r1:AmbiguousNucleotideSequence, r2:AmbiguousNucleotideSequence):List<PossibleSolution> {
        var l:List<PossibleSolution> = new List<PossibleSolution>();
        
        var s1:AmbiguousNucleotideSequence = resolve(overlap1, r2);
        var s2:AmbiguousNucleotideSequence = resolve(overlap2, r1);
        
        var p:PossibleSolution = new PossibleSolution(s1, s2, 1);
        l.add(p);
        return l;
    }
}
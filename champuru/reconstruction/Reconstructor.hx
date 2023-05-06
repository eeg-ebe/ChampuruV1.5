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
     * Solve a particular situation.
     */
    public function solve(overlap1:AmbiguousNucleotideSequence, overlap2:AmbiguousNucleotideSequence):List<PossibleSolution> {
        var cpy1:AmbiguousNucleotideSequence = overlap1.clone();
        var cpy2:AmbiguousNucleotideSequence = overlap2.clone();
        
        return null; // _solve(cpy1, cpy2); // TODO
    }
}
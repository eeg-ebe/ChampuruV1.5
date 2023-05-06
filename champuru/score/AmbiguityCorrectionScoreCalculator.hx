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
package champuru.score;

import champuru.base.AmbiguousNucleotideSequence;
import champuru.base.SingleAmbiguousNucleotide;

/**
 * An ScoreCalculator.
 *
 * @author Yann Spoeri
 */
class AmbiguityCorrectionScoreCalculator extends AScoreCalculator
{
    /**
     * Get the name of this score calculator method.
     */
    public function getName():String {
        return "Ambiguity correction";
    }
    
    /**
     * Get a textual description of this calculator method.
     */
    public function getDescription():String {
        return "A modification of the score correction method described in the Champuru 1.0 paper. The score will get corrected for the fact that ambiguous characters (e.g. W) can match multiple other characters (e.g. A, T). Preliminary results suggests that this score calculation method works better when the reconstructed consensus sequences contain a lot of ambiguities. However this score correction method seems to work less good on short input sequences.";
    }
    
    /**
     * Calculate the overlap score for a particular position.
     */
    public function calcScore(i:Int, fwd:AmbiguousNucleotideSequence, rev:AmbiguousNucleotideSequence):{score:Float, matches:Int, mismatches:Int} {
        var matches:Int = 0, fullMatches:Int = 0, mismatches:Int = 0;
        
        var fwdCorr:Int = (i < 0) ? -i : 0;
        var revCorr:Int = (i > 0) ?  i : 0;
        var fwdL:Int = fwdCorr + rev.length();
        var revL:Int = revCorr + fwd.length();
        var overlap:Int = ((fwdL < revL) ? fwdL : revL) - (fwdCorr + revCorr);
        
        for (pos in 0...overlap) {
            var a:SingleAmbiguousNucleotide = fwd.get(pos + fwdCorr);
            var b:SingleAmbiguousNucleotide = rev.get(pos + revCorr);
            if (a.equals(b, false) && (!a.isAmbiguous())) {
                fullMatches++;
            } else if (a.matches(b)) {
                matches++;
            } else {
                mismatches++;
            }
        }
        
        return {
            matches : matches + fullMatches,
            mismatches : mismatches,
            score : fullMatches + 0.5 * matches - 0.25 * overlap
        };
    }
}
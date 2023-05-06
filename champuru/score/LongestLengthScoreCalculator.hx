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
class LongestLengthScoreCalculator extends AScoreCalculator
{
    /**
     * Get the name of this score calculator method.
     */
    public function getName():String {
        return "Longest Length";
    }
    
    /**
     * Get a textual description of this calculator method.
     */
    public function getDescription():String {
        return "Take the longest number of consecutive matching nucleotides as score.";
    }
    
    /**
     * Calculate the overlap score for a particular position.
     */
    public function calcScore(i:Int, fwd:AmbiguousNucleotideSequence, rev:AmbiguousNucleotideSequence):{score:Float, matches:Int, mismatches:Int} {
        var matches:Int = 0, mismatches:Int = 0;
        
        var fwdCorr:Int = (i < 0) ? -i : 0;
        var revCorr:Int = (i > 0) ?  i : 0;
        var fwdL:Int = fwdCorr + rev.length();
        var revL:Int = revCorr + fwd.length();
        var overlap:Int = ((fwdL < revL) ? fwdL : revL) - (fwdCorr + revCorr);
        
        var maxScore:Int = 0;
        var cScore:Int = 0;
        for (pos in 0...overlap) {
            var a:SingleAmbiguousNucleotide = fwd.get(pos + fwdCorr);
            var b:SingleAmbiguousNucleotide = rev.get(pos + revCorr);
            if (a.matches(b)) {
                matches++;
                cScore++;
            } else {
                mismatches++;
                cScore = 0;
            }
            maxScore = (maxScore > cScore) ? maxScore : cScore;
        }
        return {
            matches : matches,
            mismatches : mismatches,
            score : maxScore
        };
    }
}
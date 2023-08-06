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

import champuru.base.NucleotideSequence;

/**
 * An abstract class describing a ScoreCalculator.
 *
 * @author Yann Spoeri
 */
abstract class AScoreCalculator
{
    /**
     * Create a new ScoreCalculator.
     */
    public function new() {
    }

    /**
     * Calculate all overlap scores.
     */
    public function calcOverlapScores(fwd:NucleotideSequence, rev:NucleotideSequence):Array<{nr:Int, index:Int, score:Float, matches:Int, mismatches:Int}> {
        var result:Array<{nr:Int, index:Int, score:Float, matches:Int, mismatches:Int}> = new Array<{nr:Int, index:Int, score:Float, matches:Int, mismatches:Int}>();
        for (i in -fwd.length()+1...rev.length()) {
            var score:{score:Float, matches:Int, mismatches:Int} = calcScore(i, fwd, rev);
            result.push({
                nr : i - fwd.length() + 1,
                index : i,
                score : score.score,
                matches : score.matches,
                mismatches : score.mismatches
            });
        }
        return result;
    }

    /**
     * Get the name of this score calculator method.
     */
    public abstract function getName():String;
    
    /**
     * Get a textual description of this calculator method.
     */
    public abstract function getDescription():String;
    
    /**
     * Calculate the overlap score for a particular position.
     */
    public abstract function calcScore(i:Int, fwd:NucleotideSequence, rev:NucleotideSequence):{score:Float, matches:Int, mismatches:Int};
}

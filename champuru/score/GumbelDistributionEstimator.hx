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
import champuru.base.SingleNucleotide;

/**
 * Estimator for the mean and variance .
 *
 * @author Yann Spoeri
 */
class GumbelDistributionEstimator
{
    /**
     * The first sequence.
     */
    private var mSeq1:NucleotideSequence;
    
    /**
     * The second sequence.
     */
    private var mSeq2:NucleotideSequence;
    
    /**
     * Create a new gumble distribution estimator.
     */
    public function new(seq1:NucleotideSequence, seq2:NucleotideSequence) {
        mSeq1 = seq1;
        mSeq2 = seq2;
    }
    
    /**
     * Create a "random" sequence out of another sequence.
     */
    private inline function shuffleSequence(s:NucleotideSequence):NucleotideSequence {
        var copySequence:List<SingleNucleotide> = new List<SingleNucleotide>();
        var sLen:Int = s.length();
        for (i in 0...sLen) {
            var randomPos:Int = Math.floor(Math.random() * sLen);
            var newNN:SingleNucleotide = s.get(randomPos);
            copySequence.add(newNN);
        }
        var result:NucleotideSequence = new NucleotideSequence(copySequence);
        return result;
    }
    
    /**
     * Calculate the mean of a list of floats.
     */
    private inline function calculateMean(scores:List<Float>):Float {
        var summe:Float = 0.0;
        for (score in scores) {
            summe += score;
        }
        return summe / scores.length;
    }
    
    /**
     * Calculate the variance of a list of floats.
     */
    private inline function calculateVar(scores:List<Float>, mean:Float):Float {
        var summe:Float = 0.0;
        for (score in scores) {
            var diff:Float = score - mean;
            summe += diff * diff;
        }
        return summe / (scores.length - 1);
    }
    
    /**
     * Get a random integer between a and b (exclusive).
     * a is known to be negative and b is know to be positive.
     */
    private inline function randI(a:Int, b:Int):Int {
        var result:Int = 0;
        var rand:Float = Math.random();
        if (rand > 0.5) {
            result = Math.floor(a * Math.random());
        } else {
            result = Math.floor(b * Math.random());
        }
        return result;
    }
    
    /**
     * Estimate a Gumble distribution.
     */
    public inline function calculate(scoreCalculator:AScoreCalculator):GumbelDistribution {
        var scores:List<Float> = new List<Float>();
        for (i in 0...20) {
            for (j in 0...100) {
                var randomFwd:NucleotideSequence = shuffleSequence(mSeq1);
                var randomRev:NucleotideSequence = shuffleSequence(mSeq2);
                var randPos:Int = randI(-randomFwd.length(), randomRev.length());
                var score:{score:Float, matches:Int, mismatches:Int} = scoreCalculator.calcScore(randPos, randomFwd, randomRev);
                scores.add(score.score);
            }
        }
        var mean:Float = calculateMean(scores);
        var deviation:Float = Math.sqrt(calculateVar(scores, mean));
        return GumbelDistribution.getEstimatedGumbelDistribution(mean, deviation);
    }
}
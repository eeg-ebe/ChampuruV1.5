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

/**
 * Gumbel distribution calculations.
 *
 * @author Yann Spoeri
 */
class GumbelDistribution
{
    @:final public static var eulerMascheroniConst:Float = 0.5772156649015328606065120900824024310421593359399235988057672348;
    
    /**
     * The mu parameter of the gumble distribution.
     */
    private var mMu:Float;
    
    /**
     * The beta parameter of the gumble distribution.
     */
    private var mBeta:Float;
    
    public function new(mu:Float, beta:Float) {
        mMu = mu;
        mBeta = beta;
    }
    
    public static inline function getEstimatedGumbelDistribution(mean:Float, deviation:Float):GumbelDistribution {
        var beta:Float = Math.sqrt(6) * deviation / Math.PI;
        var mu:Float = mean - eulerMascheroniConst * beta;
        return new GumbelDistribution(mu, beta);
    }
    
    /**
     * Get the mu parameter of this gumble distribution.
     */
    public inline function getMu():Float {
        return mMu;
    }
    
    /**
     * Get the beta parameter of this gumble distribution.
     */
    public inline function getBeta():Float {
        return mBeta;
    }
    
    /**
     * Calculate the probability of a particular score.
     */
    public inline function getProbabilityForScore(score:Float):Float {
        var z:Float = (score - mMu) / mBeta;
        return 1.0 / mBeta * Math.exp(-(z + Math.exp(-z)));
    }
    
    /**
     * Calculate the probability of getting a higher score.
     */
    public inline function getProbabilityForHigherScore(score:Float):Float {
        var s:Float = -(score - mMu) / mBeta;
        return 1 - Math.exp(-Math.exp(s));
    }
}
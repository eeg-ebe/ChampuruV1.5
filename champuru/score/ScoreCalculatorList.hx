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

import haxe.ds.Vector;

/**
 * A list of all known score calculators.
 *
 * @author Yann Spoeri
 */
class ScoreCalculatorList
{
    /**
     * The list of ScoreCalculators.
     */
    var mLst:Vector<AScoreCalculator>;
    
	/**
	 * An instance of this object.
	 */
	private static var sInstance:ScoreCalculatorList;
	
    /**
     * Create the ScoreCalculatorList.
     */
    private function new() {
        mLst = new Vector<AScoreCalculator>(3);
        mLst[0] = new PaperScoreCalculator();
        mLst[1] = new AmbiguityCorrectionScoreCalculator();
        mLst[2] = new LongestLengthScoreCalculator();
    }
    
    /**
     * Get the number of score calculators.
     */
    public function length():Int {
        return mLst.length;
    }
    
    /**
     * Get the index of the default score calculator.
     */
    public inline function getDefaultScoreCalculatorIndex():Int {
        return 1;
    }
    
    /**
     * Get the default score calculator.
     */
    public function getDefaultScoreCalculator():AScoreCalculator {
        var idx:Int = getDefaultScoreCalculatorIndex();
        return mLst[idx];
    }
    
    /**
     * Get a particular score calculator.
     */
    public function getScoreCalculator(i:Int):AScoreCalculator {
        var result:AScoreCalculator = null;
        if (0 <= i && i < mLst.length) {
            result = mLst[i];
        }
        return result;
    }
	
	/**
	 * Get an instance of this class.
	 */
	public static function instance():ScoreCalculatorList {
		if (sInstance == null) {
			sInstance = new ScoreCalculatorList();
		}
		return sInstance;
	}
}
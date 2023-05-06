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
 * A possible solution for the champuru problem.
 *
 * @author Yann Spoeri
 */
class PossibleSolution
{
    /**
     * The first sequence connected to this solution.
     */
    var mSeq1:AmbiguousNucleotideSequence;
	
	/**
	 * The second sequence connected to this solution.
	 */
    var mSeq2:AmbiguousNucleotideSequence;
	
	/**
	 * The quality connected to this solution.
	 */
	var mQuality:Int;
	
	public function new(seq1:AmbiguousNucleotideSequence, seq2:AmbiguousNucleotideSequence, quality:Int) {
		mSeq1 = seq1;
		mSeq2 = seq2;
		mQuality = quality;
	}
	
	public function getSeq1():AmbiguousNucleotideSequence {
		return mSeq1;
	}
	
	public function getSeq2():AmbiguousNucleotideSequence {
		return mSeq2;
	}
	
	public function getQuality():Int {
		return mQuality;
	}
}
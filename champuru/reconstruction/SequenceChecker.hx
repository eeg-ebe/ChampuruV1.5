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

import champuru.base.NucleotideSequence;

/**
 * Checker for the sequence.
 *
 * @author Yann Spoeri
 */
class SequenceChecker
{
    private var mFwd:NucleotideSequence;
    private var mRev:NucleotideSequence;
    private var mOffset1:Int;
    private var mOffset2:Int;

    public function new(fwd:NucleotideSequence, rev:NucleotideSequence) {
        mFwd = fwd;
        mRev = rev;
    }
    
    public function setOffsets(offset1:Int, offset2:Int):Void {
        mOffset1 = offset1;
        mOffset2 = offset2;
    }
    
    public function check(s1:NucleotideSequence, s2:NucleotideSequence) {
        var pF:List<Int> = new List<Int>();
        var pR:List<Int> = new List<Int>();
        var pFHighlight:List<Int> = new List<Int>();
        var pRHighlight:List<Int> = new List<Int>();
    
        for (fwdPos in 0...mFwd.length()) {
            var s1Pos:Int = fwdPos + ((mOffset2 > 0) ? 0 : -mOffset2);
            var s2Pos:Int = fwdPos + ((mOffset2 < 0) ? 0 : mOffset2);
            
            if (s1Pos < 0 || s2Pos < 0 || s1Pos >= s1.length() || s2Pos >= s2.length()) {
                continue;
            }
            if (mFwd.get(fwdPos).getCode() != s1.get(s1Pos).getCode() | s2.get(s2Pos).getCode()) {
                pF.push(fwdPos + 1);
                pFHighlight.push(s1Pos + 1);
                pRHighlight.push(s2Pos + 1);
            }
        }
        for (revPos in 0...mRev.length()) {
            var s1Pos:Int = revPos + ((mOffset1 > 0) ? 0 : -mOffset1);
            var s2Pos:Int = revPos + ((mOffset1 < 0) ? 0 : mOffset1);
            
            if (s1Pos < 0 || s2Pos < 0 || s1Pos >= s1.length() || s2Pos >= s2.length()) {
                continue;
            }
            if (mRev.get(revPos).getCode() != s1.get(s1Pos).getCode() | s2.get(s2Pos).getCode()) {
                pR.push(revPos + 1);
                pFHighlight.push(s1Pos + 1);
                pRHighlight.push(s2Pos + 1);
            }
        }
    
        return {
            pF : pF,
            pR : pR,
            pFHighlight : pFHighlight,
            pRHighlight : pRHighlight
        }
    }
}
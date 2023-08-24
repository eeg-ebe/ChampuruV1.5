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
    
    public function _check(s1:NucleotideSequence, s2:NucleotideSequence, c1I:Int, c2I:Int, c3I:Int, c4I:Int) {
        var pF:List<Int> = new List<Int>();
        var pR:List<Int> = new List<Int>();
    
        for (fwdPos in 0...mFwd.length()) {
            var s1Pos:Int = fwdPos + c1I;
            var s2Pos:Int = fwdPos + c2I;
            
            if (s1Pos < 0 || s2Pos < 0 || s1Pos >= s1.length() || s2Pos >= s2.length()) {
                continue;
            }
            if (mFwd.get(fwdPos).getCode() != s1.get(s1Pos).getCode() | s2.get(s2Pos).getCode()) {
                pF.push(fwdPos + 1);
            }
        }
        
        for (revPos in 0...mRev.length()) {
            var s1Pos:Int = revPos + c3I;
            var s2Pos:Int = revPos + c4I;
            
            if (s1Pos < 0 || s2Pos < 0 || s1Pos >= s1.length() || s2Pos >= s2.length()) {
                continue;
            }
            if (mRev.get(revPos).getCode() != s1.get(s1Pos).getCode() | s2.get(s2Pos).getCode()) {
                pR.push(revPos + 1);
            }
        }
    
        return {
            pF : pF,
            pR : pR
        }
    }
    
    public function listContains(l:List<Int>, ele:Int):Bool {
        for (item in l) {
            if (ele == item) {
                return true;
            }
        }
        return false;
    }
    public inline function addToListIfNotPresent(l:List<Int>, ele:Int):Void {
        if (!listContains(l, ele)) {
            l.push(ele);
        }
    }
    
    public function check(s1:NucleotideSequence, s2:NucleotideSequence) {
        var pFbest = new List<Int>();
        var pRbest = new List<Int>();
        var eBest = mFwd.length() + mRev.length() + 1000;
        var data = "-";
        
        var l:List<Int> = new List<Int>();
        addToListIfNotPresent(l, 0);
        addToListIfNotPresent(l, -mOffset1);
        addToListIfNotPresent(l, -mOffset2);
        addToListIfNotPresent(l, mOffset1);
        addToListIfNotPresent(l, mOffset2);
        addToListIfNotPresent(l, mOffset2 - mOffset1);
        addToListIfNotPresent(l, mOffset1 - mOffset2);
        addToListIfNotPresent(l, mOffset2 + mOffset1);
        addToListIfNotPresent(l, mOffset1 + mOffset2);
        
        for (c1I in l) {
            for (c2I in l) {
                for (c3I in l) {
                    for (c4I in l) {
                        var c = _check(s1, s2, c1I, c2I, c3I, c4I);
                        var e:Int = c.pF.length + c.pR.length;
                        if (e < eBest) {
                            pFbest = c.pF;
                            pRbest = c.pR;
                            eBest = e;
                            data = "" + c1I + ", " + c2I + ", " + c3I + ", " + c4I;
                        }
                        trace("Calculated " + c1I + ", " + c2I + ", " + c3I + ", " + c4I + ": " + e);
                    }
                }
            }
        }
        trace("Best for " + data + ": " + eBest);
        
        return {
            pF : pFbest,
            pR : pRbest,
            pFHighlight : new List<Int>(),
            pRHighlight : new List<Int>()
        }
    }
    
    /*
    public function check(s1:NucleotideSequence, s2:NucleotideSequence) {
        var pF:List<Int> = new List<Int>();
        var pR:List<Int> = new List<Int>();
        var pFHighlight:List<Int> = new List<Int>();
        var pRHighlight:List<Int> = new List<Int>();
    
        var c1I:Int = ((mOffset2 - mOffset1 > 0) ? 0 : -(mOffset2 - mOffset1));
        var c2I:Int = ((mOffset2 - mOffset1 < 0) ? 0 : mOffset2 - mOffset1);
    
        for (fwdPos in 0...mFwd.length()) {
            var s1Pos:Int = fwdPos + c1I;
            var s2Pos:Int = fwdPos + c2I;
            
            if (s1Pos < 0 || s2Pos < 0 || s1Pos >= s1.length() || s2Pos >= s2.length()) {
                continue;
            }
            if (mFwd.get(fwdPos).getCode() != s1.get(s1Pos).getCode() | s2.get(s2Pos).getCode()) {
                pF.add(fwdPos + 1);
                //pFHighlight.push(s1Pos + 1);
                //pRHighlight.push(s2Pos + 1);
            }
        }
        
        var c3I:Int = ((mOffset1 - mOffset2 > 0) ? 0 : -(mOffset1 - mOffset2));
        var c4I:Int = ((mOffset1 - mOffset2 < 0) ? 0 : mOffset1 - mOffset2);
        
        for (revPos in 0...mRev.length()) {
            var s1Pos:Int = revPos + c3I;
            var s2Pos:Int = revPos + c4I;
            
            if (s1Pos < 0 || s2Pos < 0 || s1Pos >= s1.length() || s2Pos >= s2.length()) {
                continue;
            }
            if (mRev.get(revPos).getCode() != s1.get(s1Pos).getCode() | s2.get(s2Pos).getCode()) {
                pR.add(revPos + 1);
                //pFHighlight.push(s1Pos + 1);
                //pRHighlight.push(s2Pos + 1);
            }
        }
    
        return {
            pF : pF,
            pR : pR,
            pFHighlight : pFHighlight,
            pRHighlight : pRHighlight
        }
    }*/
}
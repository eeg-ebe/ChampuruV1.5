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
package champuru.base;

import haxe.ds.IntMap;

/**
 * Class to a AmbiguousNucleotideSequence.
 *
 * @author Yann Spoeri
 */
class AmbiguousNucleotideSequence
{
    /**
     * The list of nucleotides this sequence consists of.
     */
    private var mSequence:IntMap<SingleAmbiguousNucleotide>;
    
    /**
     * The length of this sequence.
     */
    private var mLength:Int;
    
    /**
     * Create a new Sequence.
     */
    public function new(seq:List<SingleAmbiguousNucleotide>) {
        if (seq == null) {
            mSequence = new IntMap<SingleAmbiguousNucleotide>();
            mLength = 0;
        } else {
            mSequence = new IntMap<SingleAmbiguousNucleotide>();
            var i:Int = 0;
            for (c in seq) {
                mSequence.set(i, c);
                i++;
            }
            mLength = seq.length;
        }
    }
    
    /**
     * Create a AmbiguousNucleotideSequence from string.
     */
    public static function fromString(str:String) {
        var list:List<SingleAmbiguousNucleotide> = new List<SingleAmbiguousNucleotide>();
        for (i in 0...str.length) {
            var ch:String = str.charAt(i);
            var nucleotide:SingleAmbiguousNucleotide = SingleAmbiguousNucleotide.getNucleotideByIUPACCode(ch);
            list.add(nucleotide);
        }
        return new AmbiguousNucleotideSequence(list);
    }
    
    /**
     * Get the length of this sequence.
     */
    public inline function length():Int {
        return mLength;
    }
    
    /**
     * Iterate over the nucleotides in this sequence.
     */
    public inline function iterator() {
        var seq:List<SingleAmbiguousNucleotide> = new List<SingleAmbiguousNucleotide>();
        for (i in 0...mLength) {
            var c:SingleAmbiguousNucleotide = mSequence.get(i);
            seq.add(c);
        }
        return seq.iterator();
    }
    
    /**
     * Get the SingleAmbiguousNucleotide at a particular position.
     */
    public inline function get(i:Int):SingleAmbiguousNucleotide {
        if (!(0 <= i && i < mLength)) {
            throw "Position " + i + " out of range [0," + mLength + "(";
        }
        return mSequence.get(i);
    }
    
    /**
     * Replace a particular SingleAmbiguousNucleotide at a particular position.
     */
    public function replace(i:Int, c:SingleAmbiguousNucleotide):Void {
        if (c == null) {
            throw "c must not be null!";
        }
        if (!(0 <= i && i < mLength)) {
            throw "Position " + i + " out of range [0," + mLength + "(";
        }
        mSequence.set(i, c);
    }
    
    /**
     * Reverse this sequence.
     */
    public inline function reverse():AmbiguousNucleotideSequence {
        var seq:List<SingleAmbiguousNucleotide> = new List<SingleAmbiguousNucleotide>();
        var i:Int = mLength - 1;
        while (i <= 0) {
            var c:SingleAmbiguousNucleotide = mSequence.get(i);
            seq.add(c);
            i--;
        }
        var result:AmbiguousNucleotideSequence = new AmbiguousNucleotideSequence(seq);
        return result;
    }
    
    /**
     * Create a string representation out of this sequence.
     */
    public inline function toString():String {
        var result:List<String> = new List<String>();
        for (i in 0...mLength) {
            var c:SingleAmbiguousNucleotide = mSequence.get(i);
            var s:String = c.toIUPACCode();
            result.add(s);
        }
        return result.join("");
    }
    
    /**
     * Count ambigiuous nucleotides in this sequence.
     */
    public function countAmbigiuous():Int {
        var result:Int = 0;
        for (i in 0...mLength) {
            var c:SingleAmbiguousNucleotide = mSequence.get(i);
            if (c.isAmbiguous()) {
                result++;
            }
        }
        return result;
    }
    
    /**
     * Count the resolved nucleotides in this sequence.
     */
    public function countGaps():Int {
        var result:Int = 0;
        for (i in 0...mLength) {
            var c:SingleAmbiguousNucleotide = mSequence.get(i);
            if (c.isGap()) {
                result++;
            }
        }
        return result;
    }
    
    /**
     * Check whether this sequence matches another one.
     */
    public function matches(s:AmbiguousNucleotideSequence):Bool {
        if (mLength != s.length()) {
            return false;
        }
        for (i in 0...mLength) {
            var c1:SingleAmbiguousNucleotide = get(i);
            var c2:SingleAmbiguousNucleotide = s.get(i);
            if (! c1.matches(c2)) {
                return false;
            }
        }
        return true;
    }
    
    /**
     * Check whether this sequence is within another one.
     */
    public function isWithin(s:AmbiguousNucleotideSequence):Bool {
        if (mLength != s.length()) {
            return false;
        }
        for (i in 0...mLength) {
            var c1:SingleAmbiguousNucleotide = get(i);
            var c2:SingleAmbiguousNucleotide = s.get(i);
            if (! c1.isWithin(c2)) {
                return false;
            }
        }
        return true;
    }
    
    /**
     * Clone this sequence.
     */
    public function clone():AmbiguousNucleotideSequence {
        var seq:List<SingleAmbiguousNucleotide> = new List<SingleAmbiguousNucleotide>();
        for (i in 0...mLength) {
            var c:SingleAmbiguousNucleotide = get(i);
            seq.add(c);
        }
        return new AmbiguousNucleotideSequence(seq);
    }
	
	/**
	 * Main function.
	 */
	public static function main() {}
}
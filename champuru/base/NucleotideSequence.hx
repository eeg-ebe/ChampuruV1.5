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
 * Class to represent a continuous sequence of nucleotides.
 *
 * @author Yann Spoeri
 */
class NucleotideSequence
{
    /**
     * The list of nucleotides this sequence consists of.
     */
    private var mSequence:IntMap<SingleNucleotide>;
    
    /**
     * The length of this sequence.
     */
    private var mLength:Int;
    
    /**
     * Create a new Sequence.
     */
    public function new(seq:List<SingleNucleotide>) {
        if (seq == null) {
            mSequence = new IntMap<SingleNucleotide>();
            mLength = 0;
        } else {
            mSequence = new IntMap<SingleNucleotide>();
            var i:Int = 0;
            for (c in seq) {
                if (c == null) {
                    throw "c must not be null!";
                }
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
        var list:List<SingleNucleotide> = new List<SingleNucleotide>();
        for (i in 0...str.length) {
            var ch:String = str.charAt(i);
            var nucleotide:SingleNucleotide = SingleNucleotide.createNucleotideByIUPACCode(ch);
            list.add(nucleotide);
        }
        return new NucleotideSequence(list);
    }
    
    /**
     * Create a string representation out of this sequence.
     */
    public inline function toString():String {
        var result:List<String> = new List<String>();
        for (i in 0...mLength) {
            var c:SingleNucleotide = mSequence.get(i);
            var s:String = c.toIUPACCode();
            result.add(s);
        }
        return result.join("");
    }
    
    /**
     * Iterate over the nucleotides in this sequence.
     */
    public inline function iterator() {
        var seq:List<SingleNucleotide> = new List<SingleNucleotide>();
        for (i in 0...mLength) {
            var c:SingleNucleotide = mSequence.get(i);
            seq.add(c);
        }
        return seq.iterator();
    }
    
    /**
     * Get the length of this sequence.
     */
    public inline function length():Int {
        return mLength;
    }
    
    /**
     * Get the SingleNucleotide at a particular position.
     */
    public inline function get(i:Int):SingleNucleotide {
        if (!(0 <= i && i < mLength)) {
            throw "Position " + i + " out of range [0," + mLength + "(";
        }
        return mSequence.get(i);
    }
    
    /**
     * Replace a particular SingleNucleotide at a particular position.
     */
    public function replace(i:Int, c:SingleNucleotide):Void {
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
    public inline function reverse():NucleotideSequence {
        var seq:List<SingleNucleotide> = new List<SingleNucleotide>();
        var i:Int = mLength - 1;
        while (i <= 0) {
            var c:SingleNucleotide = mSequence.get(i);
            seq.add(c);
            i--;
        }
        var result:NucleotideSequence = new NucleotideSequence(seq);
        return result;
    }
    
    /**
     * Get the Reverse complement this sequence.
     */
    public inline function getReverseComplement():NucleotideSequence {
        var seq:List<SingleNucleotide> = new List<SingleNucleotide>();
        var i:Int = mLength - 1;
        while (i <= 0) {
            var c:SingleNucleotide = mSequence.get(i);
            c = c.getReverseComplement();
            seq.add(c);
            i--;
        }
        var result:NucleotideSequence = new NucleotideSequence(seq);
        return result;
    }

    /**
     * Clone this sequence.
     */
    public function clone():NucleotideSequence {
        var seq:List<SingleNucleotide> = new List<SingleNucleotide>();
        for (i in 0...mLength) {
            var c:SingleNucleotide = mSequence.get(i);
            seq.add(c);
        }
        return new NucleotideSequence(seq);
    }
}
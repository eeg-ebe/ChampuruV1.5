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

/**
 * Class to represent a single (ambiguous) Nucleotid in a sequence.
 *
 * @author Yann Spoeri
 */
class SingleAmbiguousNucleotide
{
    @:final private static var sAdenine:Int = 1;
    @:final private static var sCythosine:Int = 2;
    @:final private static var sThymine:Int = 4;
    @:final private static var sGuanine:Int = 8;

    /**
     * A code.
     */
    private var mCode:Int = 0;
    
    /**
     * Quality nucleotide.
     */
    private var mQuality:Bool = true;
    
    /**
     * Whether this is no real SingleAmbiguousNucleotide but represents a
     * space instead.
     */
    private var mSpace:Bool = true;
    
    /**
     * Create a new SingleAmbiguousNucleotide object.
     */
    public function new(adenine:Bool, cythosine:Bool, thymine:Bool, guanine:Bool, quality:Bool, ?space=false) {
        mCode = ((adenine) ? sAdenine : 0) + ((cythosine) ? sCythosine : 0) + ((thymine) ? sThymine : 0) + ((guanine) ? sGuanine : 0);
        mQuality = quality;
        mSpace = false;
    }

    /**
     * Create a SingleAmbiguousNucleotide object via it's IUPAC code.
     */
    public static function getNucleotideByIUPACCode(ocode:String):SingleAmbiguousNucleotide {
        var code:String = ocode.toUpperCase();
        var quality:Bool = code == ocode;
        if (code == "." || code == "-") {
            return new SingleAmbiguousNucleotide(false, false, false, false, quality);
        } else if (code == "A") {
            return new SingleAmbiguousNucleotide(true, false, false, false, quality);
        } else if (code == "C") {
            return new SingleAmbiguousNucleotide(false, true, false, false, quality);
        } else if (code == "T") {
            return new SingleAmbiguousNucleotide(false, false, true, false, quality);
        } else if (code == "G") {
            return new SingleAmbiguousNucleotide(false, false, false, true, quality);
        } else if (code == "K") {
            return new SingleAmbiguousNucleotide(false, false, true, true, quality);
        } else if (code == "S") {
            return new SingleAmbiguousNucleotide(false, true, false, true, quality);
        } else if (code == "R") {
            return new SingleAmbiguousNucleotide(true, false, false, true, quality);
        } else if (code == "Y") {
            return new SingleAmbiguousNucleotide(false, true, true, false, quality);
        } else if (code == "W") {
            return new SingleAmbiguousNucleotide(true, false, true, false, quality);
        } else if (code == "M") {
            return new SingleAmbiguousNucleotide(true, true, false, false, quality);
        } else if (code == "B") {
            return new SingleAmbiguousNucleotide(false, true, true, true, quality);
        } else if (code == "D") {
            return new SingleAmbiguousNucleotide(true, false, true, true, quality);
        } else if (code == "V") {
            return new SingleAmbiguousNucleotide(true, true, false, true, quality);
        } else if (code == "H") {
            return new SingleAmbiguousNucleotide(true, true, true, false, quality);
        } else if (code == "N") {
            return new SingleAmbiguousNucleotide(true, true, true, true, quality);
        }
        throw "Unknown character " + code + ". Cannot convert it into a nucleotide!";
    }
    
    public static function union(l:List<SingleAmbiguousNucleotide>):SingleAmbiguousNucleotide {
        var containsA:Bool = false;
        for (aa in l) {
            if (aa.canStandForAdenine()) {
                containsA = true;
                break;
            }
        }
        var containsC:Bool = false;
        for (aa in l) {
            if (aa.canStandForCytosine()) {
                containsC = true;
                break;
            }
        }
        var containsT:Bool = false;
        for (aa in l) {
            if (aa.canStandForThymine()) {
                containsT = true;
                break;
            }
        }
        var containsG:Bool = false;
        for (aa in l) {
            if (aa.canStandForGuanine()) {
                containsG = true;
                break;
            }
        }
        return new SingleAmbiguousNucleotide(containsA, containsC, containsT, containsG, true);
    }
    
    /**
     * Check whether this is a space.
     */
    public inline function isSpace():Bool {
        return mSpace;
    }
    
    /**
     * Check whether this SingleAmbiguousNucleotide can stand for adenine.
     */
    public inline function canStandForAdenine():Bool {
        return mCode & sAdenine != 0;
    }
    
    /**
     * Check whether this SingleAmbiguousNucleotide can stand for cythosine.
     */
    public inline function canStandForCytosine():Bool {
        return mCode & sCythosine != 0;
    }
    
    /**
     * Check whether this SingleAmbiguousNucleotide can stand for thymine.
     */
    public inline function canStandForThymine():Bool {
        return mCode & sThymine != 0;
    }
    
    /**
     * Check whether this SingleAmbiguousNucleotide can stand for guanine.
     */
    public inline function canStandForGuanine():Bool {
        return mCode & sGuanine != 0;
    }
    
    /**
     * Is quality character.
     */
    public inline function isQuality():Bool {
        return mQuality;
    }
    
    /**
     * Check whether this SingleAmbiguousNucleotide doesn't stand for A,C,T or G and
     * thus is standing for a gap.
     */
    public inline function isGap():Bool {
        return !canStandForAdenine() && !canStandForCytosine() && !canStandForGuanine() && !canStandForThymine();
    }
    
    /**
     * Check whether this SingleAmbiguousNucleotide is standing for all possibilities.
     */
    public inline function isN():Bool {
        return canStandForAdenine() && canStandForCytosine() && canStandForGuanine() && canStandForThymine();
    }
    
    /**
     * Get the IUPAC Code for this SingleAmbiguousNucleotide.
     */
    public function toIUPACCode():String {
        var result:String = "-";
        if (mSpace) {
            result = " ";
        } else if (canStandForAdenine() && canStandForCytosine() && canStandForGuanine() && canStandForThymine()) {
            result = "N";
        } else if (canStandForAdenine() && canStandForCytosine() && canStandForGuanine()) {
            result = "V";
        } else if (canStandForAdenine() && canStandForCytosine() && canStandForThymine()) {
            result = "H";
        } else if (canStandForAdenine() && canStandForGuanine() && canStandForThymine()) {
            result = "D";
        } else if (canStandForCytosine() && canStandForGuanine() && canStandForThymine()) {
            result = "B";
        } else if (canStandForAdenine() && canStandForCytosine()) {
            result = "M";
        } else if (canStandForAdenine() && canStandForThymine()) {
            result = "W";
        } else if (canStandForAdenine() && canStandForGuanine()) {
            result = "R";
        } else if (canStandForCytosine() && canStandForThymine()) {
            result = "Y";
        } else if (canStandForCytosine() && canStandForGuanine()) {
            result = "S";
        } else if (canStandForThymine() && canStandForGuanine()) {
            result = "K";
        } else if (canStandForAdenine()) {
            result = "A";
        } else if (canStandForCytosine()) {
            result = "C";
        } else if (canStandForThymine()) {
            result = "T";
        } else if (canStandForGuanine()) {
            result = "G";
        }
        if (!mQuality) {
            result = result.toLowerCase();
        }
        return result;
    }
    
    /**
     * Count the number of possible nucleotides this class is standing for.
     */
    public function countPossibleNucleotides():Int {
        var i:Int = 0;
        if (canStandForAdenine()) {
            i++;
        }
        if (canStandForCytosine()) {
            i++;
        }
        if (canStandForThymine()) {
            i++;
        }
        if (canStandForGuanine()) {
            i++;
        }
        return i;
    }
    
    /**
     * Check whether there are at least two possibilities this class is standing for.
     */
    public inline function isAmbiguous():Bool {
        var count:Int = countPossibleNucleotides();
        return count >= 2;
    }
    
    /**
     * Check whether there is an overlap over the possibilities this nucleotide presents
     * and the another SingleAmbiguousNucleotide.
     */
    public function matches(o:SingleAmbiguousNucleotide):Bool {
        if (canStandForAdenine() && o.canStandForAdenine()) {
            return true;
        }
        if (canStandForCytosine() && o.canStandForCytosine()) {
            return true;
        }
        if (canStandForThymine() && o.canStandForThymine()) {
            return true;
        }
        if (canStandForGuanine() && o.canStandForGuanine()) {
            return true;
        }
        return false;
    }
    
    /**
     * Check whether this nucleotide is within another one.
     */
    public function isWithin(o:SingleAmbiguousNucleotide):Bool {
        if (!canStandForAdenine() && o.canStandForAdenine()) {
            return false;
        }
        if (!canStandForCytosine() && o.canStandForCytosine()) {
            return false;
        }
        if (!canStandForThymine() && o.canStandForThymine()) {
            return false;
        }
        if (!canStandForGuanine() && o.canStandForGuanine()) {
            return false;
        }
        return true;
    }
    
    /**
     * Check whether this nucleotide equals another one.
     */
    public function equals(o:SingleAmbiguousNucleotide, alsoEq:Bool):Bool {
        if (canStandForAdenine() != o.canStandForAdenine()) {
            return false;
        }
        if (canStandForCytosine() != o.canStandForCytosine()) {
            return false;
        }
        if (canStandForThymine() != o.canStandForThymine()) {
            return false;
        }
        if (canStandForGuanine() != o.canStandForGuanine()) {
            return false;
        }
        if (alsoEq) {
            if (mQuality != o.mQuality) {
                return false;
            }
        }
        return true;
    }

    /**
     * Get the reverse nucleotide.
     */
    public function reverse():SingleAmbiguousNucleotide {
        var adenine:Bool = canStandForThymine();
        var cythosine:Bool = canStandForGuanine();
        var thymine:Bool = canStandForAdenine();
        var guanine:Bool = canStandForCytosine();
        return new SingleAmbiguousNucleotide(adenine, cythosine, thymine, guanine, mQuality);
    }
    
    /**
     * Clone this sequence.
     */
    public inline function clone():SingleAmbiguousNucleotide {
        return new SingleAmbiguousNucleotide(canStandForAdenine(), canStandForCytosine(), canStandForThymine(), canStandForGuanine(), mQuality);
    }
    /**
     * Clone this sequence without quality.
     */
    public inline function cloneWithQual(quality:Bool):SingleAmbiguousNucleotide {
        return new SingleAmbiguousNucleotide(canStandForAdenine(), canStandForCytosine(), canStandForThymine(), canStandForGuanine(), quality);
    }
    
    public static function main() {
        var seq:String = "CTRAATTCAAATCACACTCGCGAAAWYMWKRAA";
        var seq2:String = "YWRAWTYMAAWYMMMMYYSSSRAAATCATGAA";
        trace("  " + seq);
        for (j in 0...seq2.length) {
            var oc:String = seq2.charAt(j);
            var result:Array<String> = new Array<String>();
            result.push(oc);
            result.push(" ");
            for (i in 0...seq.length) {
                var c:String = seq.charAt(i);
                var other:SingleAmbiguousNucleotide = getNucleotideByIUPACCode(oc);
                var x:Bool = getNucleotideByIUPACCode(c).matches(other);
                if (x) {
                    result.push("#");
                } else {
                    result.push(" ");
                }
            }
            trace(result.join(""));
        }
    }
}
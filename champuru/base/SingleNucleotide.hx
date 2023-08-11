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
 * Class to represent a single nucleotide. The nucleotide is internally
 * represented by an integer. 1 does stand for adenine and so on (see static
 * final variables).
 *
 * @author Yann Spoeri
 */
class SingleNucleotide
{
    /**
     * The code that represents adenine.
     */
    @:final public static var sAdenine:Int = 1;
    
    /**
     * The code that represents cytosine.
     */
    @:final public static var sCytosine:Int = 2;
    
    /**
     * The code that represents thymine.
     */
    @:final public static var sThymine:Int = 4;
    
    /**
     * The code that represents guanine.
     */
    @:final public static var sGuanine:Int = 8;
    
    /**
     * The code that this nucleotide represents.
     */
    private var mCode:Int = 0;
    
    /**
     * The quality of this nucleotide. Qualities should be between 0 and 1.
     */
    private var mQuality:Float = 1.0;
    
    /**
     * Create a new SingleNucleotide. Use the static create* functions to
     * create a corresponding object.
     */
    public inline function new(code:Int, ?quality:Float=1.0) {
        mCode = code;
        mQuality = quality;
    }
    
    /**
     * Create a new nucleotide by explicitly stating which single-base polymorphisms
     * this nucleotide object can stand for.
     */
    public static inline function createNucleotideByBools(adenine:Bool, cytosine:Bool, thymine:Bool, guanine:Bool, ?quality:Int=100):SingleNucleotide {
        var code:Int = ((adenine) ? sAdenine : 0) + ((cytosine) ? sCytosine : 0) + ((thymine) ? sThymine : 0) + ((guanine) ? sGuanine : 0);
        return new SingleNucleotide(code, quality);
    }
    
    /**
     * Create a new nucleotide by it's IUPAC code.
     */
    public static function createNucleotideByIUPACCode(s:String, ?origQuality:Float=-1):SingleNucleotide {
        var code:String = s.toUpperCase();
        var quality:Float = (origQuality == -1) ? ((code == s) ? 100 : 50) : origQuality;
        if (code == "." || code == "-" || code == "_") {
            return new SingleNucleotide(0, quality);
        } else if (code == "A") {
            return new SingleNucleotide(sAdenine, quality);
        } else if (code == "C") {
            return new SingleNucleotide(sCytosine, quality);
        } else if (code == "T") {
            return new SingleNucleotide(sThymine, quality);
        } else if (code == "G") {
            return new SingleNucleotide(sGuanine, quality);
        } else if (code == "K") {
            return new SingleNucleotide(sThymine + sGuanine, quality);
        } else if (code == "S") {
            return new SingleNucleotide(sCytosine + sGuanine, quality);
        } else if (code == "R") {
            return new SingleNucleotide(sAdenine + sGuanine, quality);
        } else if (code == "Y") {
            return new SingleNucleotide(sCytosine + sThymine, quality);
        } else if (code == "W") {
            return new SingleNucleotide(sAdenine + sThymine, quality);
        } else if (code == "M") {
            return new SingleNucleotide(sAdenine + sCytosine, quality);
        } else if (code == "B") {
            return new SingleNucleotide(sCytosine + sThymine + sGuanine, quality);
        } else if (code == "D") {
            return new SingleNucleotide(sGuanine + sAdenine + sThymine, quality);
        } else if (code == "V") {
            return new SingleNucleotide(sGuanine + sCytosine + sAdenine, quality);
        } else if (code == "H") {
            return new SingleNucleotide(sAdenine + sCytosine + sThymine, quality);
        } else if (code == "N") {
            return new SingleNucleotide(sAdenine + sCytosine + sThymine + sGuanine, quality);
        }
        throw "Unknown character " + code + ". Cannot convert it into a nucleotide!";
    }
    
    /**
     * Get the IUPAC Code for this SingleNucleotide.
     */
    public function toIUPACCode():String {
        var result:String = "_";
        if (canStandForAdenine() && canStandForCytosine() && canStandForGuanine() && canStandForThymine()) {
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
        if (mQuality <= 0.5) {
            result = result.toLowerCase();
        }
        return result;
    }
    
    /**
     * Get the code of this SingleNucleotide.
     */
    public inline function getCode():Int {
        return mCode;
    }
    
    /**
     * Check whether this nucleotide is standing for a gap.
     */
    public inline function isGap():Bool {
        return mCode == 0;
    }
    
    /**
     * Check whether this nucleotide can stand for adenine.
     */
    public inline function canStandForAdenine():Bool {
        return mCode & sAdenine != 0;
    }
    
    /**
     * Check whether this nucleotide can only stand for adenine.
     */
    public inline function isAdenine():Bool {
        return mCode == sAdenine;
    }
    
    /**
     * Check whether this nucleotide can stand for cytosine.
     */
    public inline function canStandForCytosine():Bool {
        return mCode & sCytosine != 0;
    }
    
    /**
     * Check whether this nucleotide can only stand for cytosine.
     */
    public inline function isCytosine():Bool {
        return mCode == sCytosine;
    }
    
    /**
     * Check whether this nucleotide can stand for thymine.
     */
    public inline function canStandForThymine():Bool {
        return mCode & sThymine != 0;
    }
    
    /**
     * Check whether this nucleotide can only stand for thymine.
     */
    public inline function isThymine():Bool {
        return mCode == sThymine;
    }
    
    /**
     * Check whether this nucleotide can stand for guanine.
     */
    public inline function canStandForGuanine():Bool {
        return mCode & sGuanine != 0;
    }
    
    /**
     * Check whether this nucleotide can only stand for guanine.
     */
    public inline function isGuanine():Bool {
        return mCode == sGuanine;
    }
    
    /**
     * Check whether this nucleotide can stand for all nucleotides.
     */
    public inline function isN():Bool {
        return mCode == sAdenine + sCytosine + sThymine + sGuanine;
    }
    
    /**
     * Get the quality connected to this nucleotide.
     */
    public inline function getQuality():Float {
        return mQuality;
    }
    
    /**
     * Count the number of polymorphisms this nucleotide can stand for.
     */
    public inline function countPolymorphism():Int {
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
     * Check whether this nucleotide is not polymorphismic.
     */
    public function isNotPolymorhism():Bool {
        if (isGap()) {
            return true;
        }
        if (isAdenine()) {
            return true;
        }
        if (isCytosine()) {
            return true;
        }
        if (isGuanine()) {
            return true;
        }
        if (isThymine()) {
            return true;
        }
        return false;
    }
    
    /**
     * Check whether this nucleotide is polymorphismic.
     */
    public inline function isPolymorhism():Bool {
        return !isNotPolymorhism();
    }
    
    /**
     * Get the reverse complement of this nucleotide.
     */
    public inline function getReverseComplement():SingleNucleotide {
        var code:Int = 0;
        code += canStandForAdenine() ? sThymine : 0;
        code += canStandForCytosine() ? sGuanine : 0;
        code += canStandForGuanine() ? sCytosine : 0;
        code += canStandForThymine() ? sAdenine : 0;
        return new SingleNucleotide(mCode, mQuality);
    }
    
    /**
     * Calculate the "union" of this nucleotide with another nucleotide.
     */
    public inline function union(o:SingleNucleotide):SingleNucleotide {
        var code:Int = mCode & o.getCode();
        var quality:Float = Math.min(mQuality, o.getQuality());
        return new SingleNucleotide(code, quality);
    }
    
    /**
     * Calculate the "intersection" of this nucleotide with another nucleotide.
     */
    public inline function intersection(o:SingleNucleotide):SingleNucleotide {
        var code:Int = mCode | o.getCode();
        var quality:Float = Math.min(mQuality, o.getQuality());
        return new SingleNucleotide(code, quality);
    }
    
    /**
     * Calculate the "difference" of this nucleotide with another nucleotide.
     */
    public inline function difference(o:SingleNucleotide):SingleNucleotide {
        var code:Int = mCode ^ o.getCode();
        var quality:Float = Math.min(mQuality, o.getQuality());
        return new SingleNucleotide(code, quality);
    }
    
    /**
     * Calculate whether this nucleotide is a "subset" of another one.
     */
    public inline function isSubset(o:SingleNucleotide):Bool {
        if (canStandForAdenine()) {
            if (!o.canStandForAdenine()) {
                return false;
            }
        }
        if (canStandForCytosine()) {
            if (!o.canStandForCytosine()) {
                return false;
            }
        }
        if (canStandForGuanine()) {
            if (!o.canStandForGuanine()) {
                return false;
            }
        }
        if (canStandForThymine()) {
            if (!o.canStandForThymine()) {
                return false;
            }
        }
        return true;
    }
    
    /**
     * Calculate whether this nucleotide is a "superset" of another one.
     */
    public inline function isSuperset(o:SingleNucleotide):Bool {
        if (o.canStandForAdenine()) {
            if (!canStandForAdenine()) {
                return false;
            }
        }
        if (o.canStandForCytosine()) {
            if (!canStandForCytosine()) {
                return false;
            }
        }
        if (o.canStandForGuanine()) {
            if (!canStandForGuanine()) {
                return false;
            }
        }
        if (o.canStandForThymine()) {
            if (!canStandForThymine()) {
                return false;
            }
        }
        return true;
    }
    
    /**
     * Calculate whether this nucleotide is "disjoint" to another one.
     */
    public inline function isDisjoint(o:SingleNucleotide):Bool {
        var code:Int = mCode & o.getCode();
        return code == 0;
    }
    
    /**
     * Calculate whether this nucleotide is "overlapping" to another one.
     */
    public inline function isOverlapping(o:SingleNucleotide):Bool {
        var code:Int = mCode & o.getCode();
        return code != 0;
    }
    
    /**
     * Get a copy of this object.
     */
    public inline function clone(?newQuality:Float=-1):SingleNucleotide {
        return new SingleNucleotide(mCode, (newQuality == -1) ? mQuality : newQuality);
    }
    
    /**
     * Check whether this nucleotide equals another one.
     */
    public function equals(o:SingleNucleotide, ?alsoEq:Bool=false):Bool {
        if (mCode != o.getCode()) {
            return false;
        }
        if (alsoEq) {
            if (mQuality != o.mQuality) {
                return false;
            }
        }
        return true;
    }
}

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
package champuru.perl;

import haxe.ds.IntMap;
import haxe.ds.StringMap;

/**
 * Reimplementation of the original Champuru PERL code.
 *
 * @author Yann Spoeri
 */
class PerlChampuruReimplementation
{
    // helper functions

    public static function stringifyIntMap(o:IntMap<String>):String {
        var result:List<String> = new List<String>();
        var minVal:Int = 0; var maxVal:Int = 0;
        var init:Bool = true;
        for (key in o.keys()) {
            if (init) {
                minVal = key;
                maxVal = key;
                init = false;
            }
            minVal = (key < minVal) ? key : minVal;
            maxVal = (key > maxVal) ? key : maxVal;
        }
        for (key in minVal...maxVal+1) {
            if (o.exists(key)) {
                var v:String = o.get(key);
                result.add(v);
            }
        }
        return result.join("");
    }
    
    public static function replaceCharInString(s:String, i:Int, c:String):String {
        var prev:String = s.substring(0, i);
        var end:String = s.substring(i + 1, s.length);
        return prev + c + end;
    }
    
    // reimplementation of perl functions
    
    public static function splice(s:String, i:Int, l:Int):String {
        var start:String = s.substring(0, i);
        var end:String = s.substring(i + l);
        return start + end;
    }
    
    public static function reverseString(s:String):String {
        var result:List<String> = new List<String>();
        for (i in 0...s.length) {
            var c:String = s.charAt(i);
            result.push(c);
        }
        return result.join("");
    }
    
    // original code

    // my@bases = ('A', 'T', 'G', 'C', 'R', 'Y', 'M', 'K', 'W', 'S', 'V', 'B', 'H', 'D', 'N');
    @:final private static var bases:Array<String> = [ "A", "T", "G", "C", "R", "Y", "M", "K", "W", "S", "V", "B", "H", "D", "N" ];
    // my %complement = ('A'=>'T', 'T'=>'A', 'G'=>'C', 'C'=>'G', 'R'=>'Y', 'Y'=>'R', 'M'=>'K', 'K'=>'M', 'W'=>'W', 'S'=>'S', 'V'=>'B', 'B'=>'V', 'H'=>'D', 'D'=>'H', 'N'=>'N');
    @:final private static var complement:StringMap<String> = [ "A"=>"T", "T"=>"A", "G"=>"C", "C"=>"G", "R"=>"Y", "Y"=>"R", "M"=>"K", "K"=>"M", "W"=>"W", "S"=>"S", "V"=>"B", "B"=>"V", "H"=>"D", "D"=>"H", "N"=>"N" ];
    // my %code = ('A'=>1, 'T'=>2, 'G'=>4, 'C'=>8, 'R'=>5, 'Y'=>10, 'M'=>9, 'K'=>6, 'W'=>3, 'S'=>12, 'V'=>13, 'B'=>14, 'H'=>11, 'D'=>7, 'N'=>15);
    @:final private static var code:StringMap<Int> = [ "A"=>1, "T"=>2, "G"=>4, "C"=>8, "R"=>5, "Y"=>10, "M"=>9, "K"=>6, "W"=>3, "S"=>12, "V"=>13, "B"=>14, "H"=>11, "D"=>7, "N"=>15 ];
    // my %rev_code = (1=>'A', 2=>'T', 4=>'G', 8=>'C', 5=>'R', 10=>'Y', 9=>'M', 3=>'W', 12=>'S', 6=>'K', 13=>'V', 14=>'B', 11=>'H', 7=>'D', 15=>'N');
    @:final private static var rev_code:IntMap<String> = [ 1=>"A", 2=>"T", 4=>"G", 8=>"C", 5=>"R", 10=>"Y", 9=>"M", 3=>"W", 12=>"S", 6=>"K", 13=>"V", 14=>"B", 11=>"H", 7=>"D", 15=>"N" ];
    
    // sub comp { my $compatible; my $intersection;
    // $intersection = ($code{$_[0]} & $code{$_[1]});
    // if ($intersection == 0) {$compatible = 0} else {$compatible=1}
    // return ($compatible)}  ;
    public static function comp(a:String, b:String):Int {
        var intersection:Int = code.get(a) & code.get(b);
        return (intersection == 0) ? 0 : 1;
    }
    
    // sub inter { my $intersection;
    // $intersection = ($code{$_[0]} & $code{$_[1]});
    // if ($intersection == 0) { $intersection = '_'}
    //       else {$intersection=$rev_code{$intersection}};
    // return ($intersection)};
    public static function inter(a:String, b:String):String {
        var intersection:Int = code.get(a) & code.get(b);
        return (intersection == 0) ? "_" : rev_code.get(intersection);
    }
    
    // sub max { my $max = shift; $_ > $max and $max = $_ for @_; $max };
    public static inline function max(a:Int, b:Int) {
        return (a > b) ? a : b;
    }
    // sub min { my $min = shift; $_ < $min and $min = $_ for @_; $min };
    public static inline function min(a:Int, b:Int) {
        return (a < b) ? a : b;
    }
    
    public static function runChampuru(forward:String, reverse:String, opt_c:Bool):PerlChampuruResult {
        var result:PerlChampuruResult = new PerlChampuruResult();
        // print "\n";
        // print "Champuru (command-line version)\n\n";
        // print "Reference:\nFlot, J.-F. (2007) Champuru 1.0: a computer software for unraveling mixtures of two DNA sequences of unequal lengths. Molecular Ecology Notes 7 (6): 974-977\n\n";
        // print "Usage: perl champuru.pl -f <forward sequence> -r <reverse sequence> -o <FASTA output> -n <sample name> -c\nThe forward and reverse sequences should be provided as text files (with the whole sequence on a single line).\nPlease use the switch -c if the reverse sequence has to be reverse-complemented (this switch should not be used if the sequence has already been reverse-complemented, for instance because it is copied from a contig editor).\nIf an output file name is specified and no problem is detected in the input data, the two reconstructed sequences will be appended to the output file in FASTA format using the specified sample name followed by 'a' and 'b'.\n\n";
        result.print("\n");
        result.print("Champuru (command-line version)\n\n");
        result.print("Reference:\nFlot, J.-F. (2007) Champuru 1.0: a computer software for unraveling mixtures of two DNA sequences of unequal lengths. Molecular Ecology Notes 7 (6): 974-977\n\n");
        result.print("Usage: perl champuru.pl -f <forward sequence> -r <reverse sequence> -o <FASTA output> -n <sample name> -c\nThe forward and reverse sequences should be provided as text files (with the whole sequence on a single line).\nPlease use the switch -c if the reverse sequence has to be reverse-complemented (this switch should not be used if the sequence has already been reverse-complemented, for instance because it is copied from a contig editor).\nIf an output file name is specified and no problem is detected in the input data, the two reconstructed sequences will be appended to the output file in FASTA format using the specified sample name followed by 'a' and 'b'.\n\n");
        
        // #processing input data
        // my $for = <F>; chomp($for); my@forward=split('', $for);
        // foreach my$r(@forward){if (!grep(/$r/, @bases)) {print "Unknown base ($r) in forward sequence!"; exit}};
        for (i in 0...forward.length) {
            var r:String = forward.charAt(i);
            if (!bases.contains(r)) {
                result.print("Unknown base (" + r + ") in forward sequence!");
                return result;
            }
        }
        // my $rev = <R>; chomp($rev); my@reverse=split('', $rev);
        // foreach my$r(@reverse){if (!grep(/$r/, @bases)) {print "Unknown base ($r) in reverse sequence!"; exit}};
        for (i in 0...reverse.length) {
            var r:String = reverse.charAt(i);
            if (!bases.contains(r)) {
                result.print("Unknown base ($r) in reverse sequence!");
                return result;
            }
        }
        // print "Length of forward sequence: $#forward bases\n";
        // print "Lenth of reverse sequence: $#reverse bases\n";
        result.print("Length of forward sequence: " + forward.length + " bases\n"); // XXX: length - 1
        result.print("Length of reverse sequence: " + reverse.length + " bases\n"); // XXX: length - 1, typo in length
        
        // if ($opt_c) {@reverse=reverse(@reverse); foreach my$base(@reverse){$base=$complement{$base}}};
        if (opt_c) {
            var sb:List<String> = new List<String>();
            var i:Int = reverse.length - 1;
            while (i >= 0) {
                var c:String = reverse.charAt(i);
                var rev:String = complement.get(c);
                sb.add(rev);
                --i;
            }
            reverse = sb.join("");
        }
        
        // #computing the scores of all possible alignments
        // my $scoremax1 = 0; my $scoremax2=0; my $scoremax3=0 ;
        // my $imax1=0; my $imax2=0 ; my $imax3=0;
        // my $i; my $j;
        // for ($i=(-$#forward); $i<=($#reverse) ;$i++) {
        //                 my $score = 0;
        //                 if ($i<0) {for ($j=0; $j<=min(($#forward+$i),$#reverse);$j++) {$score=($score+comp($forward[$j-$i],$reverse[$j]))}; $score=$score-(($#forward+$i)+1)/4}
        //                 elsif ($i>0) {for ($j=0; $j<=min($#forward,($#reverse-$i));$j++){$score=($score+comp($forward[$j],$reverse[$j+$i]))}; $score=$score-(($#reverse-$i)+1)/4}
        //                 elsif ($i==0) {for ($j=0; $j<=min($#forward,$#reverse);$j++){$score=($score+comp($forward[$j],$reverse[$j]))}; $score=$score-(min($#forward,$#reverse)+1)/4};
        // 
        //         if ($score > $scoremax1) {$imax3=$imax2; $imax2=$imax1; $imax1=$i; $scoremax3=$scoremax2; $scoremax2=$scoremax1; $scoremax1=$score}
        //                 elsif ($score > $scoremax2){$imax3=$imax2; $imax2=$i; $scoremax3=$scoremax2; $scoremax2=$score}
        //                 elsif ($score > $scoremax3){$imax3=$i; $scoremax3=$score}} ;
        var scoremax1:Float = 0, scoremax2:Float = 0, scoremax3:Float = 0;
        var imax1:Int = 0, imax2:Int = 0, imax3:Int = 0;
        var i:Int, j:Int;
        i = -(forward.length - 1);
        while (i < reverse.length) {
            var score:Float = 0;
            if (i < 0) { // for ($j=0; $j<=min(($#forward+$i),$#reverse);$j++) {$score=($score+comp($forward[$j-$i],$reverse[$j]))}; $score=$score-(($#forward+$i)+1)/4
                for (j in 0...min((forward.length + i), reverse.length)) {
                    score = score + comp(forward.charAt(j - i), reverse.charAt(j));
                }
                score = score - (forward.length + i) / 4;
            } else if (i > 0) { // for ($j=0; $j<=min($#forward,($#reverse-$i));$j++){$score=($score+comp($forward[$j],$reverse[$j+$i]))}; $score=$score-(($#reverse-$i)+1)/4
                for (j in 0...min(forward.length, reverse.length - i)) {
                    score = score + comp(forward.charAt(j), reverse.charAt(j + i));
                }
                score = score - (forward.length + i) / 4;
            } else if (i == 0) { // for ($j=0; $j<=min($#forward,$#reverse);$j++){$score=($score+comp($forward[$j],$reverse[$j]))}; $score=$score-(min($#forward,$#reverse)+1)/4
                for (j in 0...min(forward.length, reverse.length)) {
                    score = score + comp(forward.charAt(j), reverse.charAt(j));
                }
                score = score - (forward.length + i) / 4;
            }
            
            if (score > scoremax1) {
                imax3 = imax2;
                imax2 = imax1;
                imax1 = i;
                scoremax3 = scoremax2;
                scoremax2 = scoremax1;
                scoremax1 = score;
            } else if (score > scoremax2) {
                imax3 = imax2;
                imax2 = i;
                scoremax3 = scoremax2;
                scoremax2 = score;
            } else if (score > scoremax3) {
                imax3 = i;
                scoremax3 = score;
            }
            
            
            i++;
        }

        // print "Best compatibility score: $scoremax1 (offset: $imax1)\n";
        // print "Second best compatibility score: $scoremax2 (offset: $imax2)\n";
        // print "Third best compatibility score: $scoremax3 (offset: $imax3)\n\n";
        result.print("Best compatibility score: " + scoremax1 + " (offset: " + imax1+ ")\n");
        result.print("Second best compatibility score: " + scoremax2 + " (offset: " + imax2 + ")\n");
        result.print("Third best compatibility score: " + scoremax3 + " (offset: " + imax3 + ")\n\n");

        // #combining forward and reverse information into strict consensus sequences
        // my @seq1;
        // my @seq2;
        var seq1_:IntMap<String> = new IntMap<String>();
        var seq2_:IntMap<String> = new IntMap<String>();
        
        // for ($j=-min($imax1,0); $j<=min($#forward,$#reverse-$imax1);$j++) {
        //   $seq1[$j+min($imax1,0)]=inter($forward[$j],$reverse[$j+min($imax1,0)+max($imax1,0)])}
        j = -min(imax1, 0);
        while(j < min(forward.length, reverse.length - imax1)) {
            seq1_.set(j + min(imax1, 0), inter(forward.charAt(j), reverse.charAt(j + min(imax1, 0) + max(imax1, 0))));
            j++;
        }

        // for ($j=-min($imax2,0); $j<=min($#forward,$#reverse-$imax2);$j++) {
        //   $seq2[$j+min($imax2,0)]=inter($forward[$j],$reverse[$j+min($imax2,0)+max($imax2,0)])}
        j = -min(imax2, 0);
        while (j < min(forward.length, reverse.length - imax2)) {
            seq2_.set(j + min(imax2, 0), inter(forward.charAt(j), reverse.charAt(j + min(imax2, 0) + max(imax2, 0))));
            j++;
        }
        
        // my $incomp=0;
        // foreach my$r(@seq1){if ($r eq '_') {$incomp=$incomp+1}};
        // foreach my$r(@seq2){if ($r eq '_') {$incomp=$incomp+1}};
        // if ($incomp>0) {print "First reconstructed sequence: "; foreach my$r(@seq1){print $r}; print "\n";
        //                 print "Second reconstructed sequence: "; foreach my$r(@seq2){print $r}; print "\n"}
        // if ($incomp==1) {print "There is 1 incompatible position (indicated with an underscore), please check the input sequences.\n" ; exit};
        // if ($incomp>1) {print "There are $incomp incompatible positions (indicated with underscores), please check the input sequences.\n" ; exit};
        var incomp:Int = 0;
        for (k in seq1_.keys()) {
            var r:String = seq1_.get(k);
            if (r == "_") {
                incomp = incomp + 1;
            }
        }
        for (k in seq2_.keys()) {
            var r:String = seq2_.get(k);
            if (r == "_") {
                incomp = incomp + 1;
            }
        }
        
        var seq1:String = stringifyIntMap(seq1_);
        var seq2:String = stringifyIntMap(seq2_);
        
        if (incomp>0) {
            result.print("First reconstructed sequence: ");
            result.print(seq1);
            result.print("\n");
            result.print("Second reconstructed sequence: ");
            result.print(seq2);
            result.print("\n");
        }
        if (incomp == 1) {
            result.print("There is 1 incompatible position (indicated with an underscore), please check the input sequences.\n");
            return result;
        }
        if (incomp > 1) {
            result.print("There are " + incomp + " incompatible positions (indicated with underscores), please check the input sequences.\n");
            return result;
        }
        
        // #cleaning up ambiguities by sequence comparison
        // my @seq1rev=reverse(@seq1); my @seq2rev=reverse(@seq2);
        // my @reverserev=reverse(@reverse);
        var seq1rev:String = reverseString(seq1);
        var seq2rev:String = reverseString(seq2);
        var reverserev:String = reverseString(reverse);
        // splice(@seq1rev,0,max(min($#forward-$#reverse+$imax1,0)-min($#forward-$#reverse+$imax2,0),0));
        // splice(@seq2rev,0,max(min($#forward-$#reverse+$imax2,0)-min($#forward-$#reverse+$imax1,0),0));
        seq1rev = splice(seq1rev, 0, max(min((forward.length - 1) - (reverse.length - 1) + imax1, 0) - min((forward.length - 1) - (reverse.length - 1) + imax2, 0), 0));
        seq2rev = splice(seq2rev, 0, max(min((forward.length - 1) - (reverse.length - 1) + imax2, 0) - min((forward.length - 1) - (reverse.length - 1) + imax1, 0), 0));
        // my $cutreverserev=-min($#forward-$#reverse+min($imax1,$imax2),0);
        var cutreverserev:Int = -min((forward.length - 1) - (reverse.length - 1) + min(imax1, imax2), 0);
        // splice(@reverserev,0,$cutreverserev);
        reverserev = splice(reverserev, 0, cutreverserev);
        // @seq1=reverse(@seq1rev); @seq2=reverse(@seq2rev);@reverse=reverse(@reverserev);
        seq1 = reverseString(seq1rev);
        seq2 = reverseString(seq2rev);
        reverse = reverseString(reverserev);
        // splice(@seq1,0,max(min($imax1,0)-min($imax2,0),0));
        // splice(@seq2,0,max(min($imax2,0)-min($imax1,0),0));
        seq1 = splice(seq1, 0, max(min(imax1, 0) - min(imax2, 0), 0));
        seq2 = splice(seq2, 0, max(min(imax2, 0) - min(imax1, 0), 0));
        // my $cutforward=-min(min($imax1,$imax2),0);
        var cutforward:Int = -min(min(imax1, imax2), 0);
        // splice(@forward,0,$cutforward);
        forward = splice(forward, 0, cutforward);
        
        // for ($i=0;$i<3;$i++){
        //     for ($j=0;$j<=min($#seq1,$#seq2);$j++) {
        //         if ($seq1[$j] ne $seq2[$j]) {
        //             if (comp($seq1[$j],$seq2[$j])==1) {
        //                 if  ($code{$seq1[$j]} > $code{$seq2[$j]}) {
        //                     $seq1[$j]=$rev_code{$code{$seq1[$j]}-$code{$seq2[$j]}}
        //                 } else {
        //                     $seq2[$j]=$rev_code{$code{$seq2[$j]}-$code{$seq1[$j]}}
        //                 }
        //             }
        //         };
        //         if ($seq1[$#seq1-$j] ne $seq2[$#seq2-$j]) {
        //             if (comp($seq1[$#seq1-$j],$seq2[$#seq2-$j])==1) {
        //                 if  ($code{$seq1[$#seq1-$j]} > $code{$seq2[$#seq2-$j]}) {
        //                     $seq1[$#seq1-$j]=$rev_code{$code{$seq1[$#seq1-$j]}-$code{$seq2[$#seq2-$j]}}
        //                 } else {
        //                     $seq2[$#seq2-$j]=$rev_code{$code{$seq2[$#seq2-$j]}-$code{$seq1[$#seq1-$j]}}
        //                 }
        //             }
        //         }
        //     }
        // };
        for (i in 0...3) {
            for (j in 0...min(seq1.length, seq2.length)) {
                if (seq1.charAt(j) != seq2.charAt(j)) {
                    if (comp(seq1.charAt(j), seq2.charAt(j)) == 1) {
                        if (code.get(seq1.charAt(j)) > code.get(seq2.charAt(j))) {
                            seq1 = replaceCharInString(seq1, j, rev_code.get(code.get(seq1.charAt(j)) - code.get(seq2.charAt(j))));
                        } else {
                            seq2 = replaceCharInString(seq2, j, rev_code.get(code.get(seq2.charAt(j)) - code.get(seq1.charAt(j))));
                            
                        }
                    }
                }
                if (seq1.charAt(seq1.length - 1 - j) != seq2.charAt(seq2.length - 1 - j)) {
                    if (comp(seq1.charAt(seq1.length - 1 - j), seq2.charAt(seq2.length - 1 - j)) == 1) {
                        if (code.get(seq1.charAt(seq1.length - 1 - j)) > code.get(seq2.charAt(seq2.length - 1 - j))) {
                            seq1 = replaceCharInString(seq1, seq1.length - 1 - j, rev_code.get(code.get(seq1.charAt(seq1.length - 1 - j)) - code.get(seq2.charAt(seq2.length - 1 - j))));
                        } else {
                            seq2 = replaceCharInString(seq2, seq2.length - 1 - j, rev_code.get(code.get(seq2.charAt(seq2.length - 1 - j)) - code.get(seq1.charAt(seq1.length - 1 - j))));
                        }
                    }
                    
                }
            }
        }
        
        // print "First reconstructed sequence: ";
        // foreach my$r(@seq1){print "$r"}; print "\n";
        // print "Second reconstructed sequence: ";
        // foreach my$r(@seq2){print "$r"}; print "\n";
        result.print("First reconstructed sequence: ");
        result.print(seq1);
        result.print("\n");
        result.print("Second reconstructed sequence: ");
        result.print(seq2);
        result.print("\n");
        
        // #simulating direct sequencing
        // Check positions 6 11 on the forward chromatogram.
        // my @tocheck=('s');
        var tocheck:List<String> = new List<String>();
        tocheck.add("s");
        // for ($j=0; $j<=min($#seq1,$#seq2);$j++) {
        //   if ($code{$forward[$j]}!=($code{$seq1[$j]}|$code{$seq2[$j]})) {push(@tocheck,$j+$cutforward+1)}};
        for (j in 0...min(seq1.length, seq2.length)) {
            if (code.get(forward.charAt(j)) != (code.get(seq1.charAt(j)) | code.get(seq2.charAt(j)))) {
                tocheck.add("" + (j + cutforward + 1));
            }
        }
        // my $ftocheck=$#tocheck;
        var ftocheck = tocheck.length - 1;
        // if ($#tocheck > 0) {print "Check position";
        // if ($#tocheck==1) {print " $tocheck[1] "} else {foreach my$r(@tocheck){print "$r "}};
        //   print "on the forward chromatogram.\n"};
        if (tocheck.length - 1 > 0) {
            result.print("Check position");
            if (tocheck.length - 1 == 1) {
                result.print(" " + tocheck.last() + " ");
            } else {
                for (r in tocheck) {
                    result.print(r + " ");
                }
            }
            result.print("on the forward chromatogram.\n");
        }
        
        // @tocheck=('s');
        tocheck.clear();
        tocheck.add("s");
        // for ($j=0; $j<=min($#seq1,$#seq2);$j++) {
        //   if ($code{$reverse[$#reverse-$j]}!=($code{$seq1[$#seq1-$j]}|$code{$seq2[$#seq2-$j]})) {
        //     if (!$opt_c) {@tocheck=(@tocheck,1+$#reverse-$j)} else {push(@tocheck,$j+$cutreverserev+1)}  }};
        for (j in 0...min(seq1.length, seq2.length)) {
            if (code.get(reverse.charAt(reverse.length - 1 - j)) != (code.get(seq1.charAt(seq1.length - 1 - j)) | code.get(seq2.charAt(seq2.length - 1 - j)))) {
                if (!opt_c) {
                    tocheck.add("" + (1 + reverse.length - 1 - j));
                } else {
                    tocheck.add("" + (j + cutreverserev + 1));
                }
            }
        }
        // my $rtocheck=$#tocheck;
        var rtocheck = tocheck.length - 1;
        // if ($#tocheck > 0) {print "Check position";
        // if ($#tocheck==1) {print " $tocheck[1] "} else {
        //   if (!$opt_c)  {@tocheck=reverse(@tocheck); unshift(@tocheck,pop(@tocheck))};
        //   foreach my$r(@tocheck){print "$r "}};
        // print "on the reverse chromatogram.\n"};
        if (tocheck.length - 1 > 0) {
            result.print("Check position");
            if (tocheck.length - 1 == 1) {
                result.print(" " + tocheck.last() + " ");// TODO
            } else {
                if (!opt_c) {
                    var tocheck_:List<String> = new List<String>();
                    for (e in tocheck) {
                        if (e == "s") {
                            continue;
                        }
                        tocheck_.push(e);
                    }
                    tocheck_.push("s");
                    tocheck = tocheck_;
                }
                for (r in tocheck) {
                    result.print(r + " ");
                }
            }
            result.print("on the reverse chromatogram.\n");
        }
        // if ($ftocheck+$rtocheck<1) {print "The two sequences that were mixed in the forward and reverse chromatograms have been successfully deconvoluted.\n"};
        if (ftocheck + rtocheck < 1) {
            result.print("The two sequences that were mixed in the forward and reverse chromatograms have been successfully deconvoluted.\n");
        }
        
        // #writing FASTA output if all problems have been solved
        // XXX: Write everything to result
        result.index1 = imax1;
        result.index2 = imax2;
        result.index3 = imax3;
        result.sequence1 = seq1;
        result.sequence2 = seq2;
        
        return result;
     }
    
    public static function main() {
        var r = runChampuru("CTRAATTCAAATCACACTCGCGAAAWYMWKRAA", "TTCATGATTTYSSSRRKKKKRWYTKRAWTYWR", true); // que 23
        //  var r = runChampuru("CTRAATTCAAATCACACTCGCGAAAWYMWKRAA", "YWRAWTYMAAWYMMMMYYSSSRAAATCATGAA", true);
        //var r = runChampuru("ATSYKRMKY", "WWKCTGAST", false);
        //var r = runChampuru("ATCGTGGGCGGCCGGCCCTGCCACAGACGGGGTTGTCACCCTCTGCGACGTGCCGTTCCAAGCAACTTAGGCAGGGCCCCTCCGCCTAGAAAGTGCTTCTCGCAACTACAACTCGCCGATGCAGGCATCGGAGATTTCAAATTTGAGCTCTTCCCGCTTCACTCGCCGTTACTGGGGGAATCCTTGTTAGTTTCTTTTCCTCCGCTTATTAATATGCTTAAATTCAGCGGGTAGCCTTGCCTGATCTGAGGTCTGGAAGGCGATTCCTTTTTTCCTTTGAGATGCCGCCACCGCTACCCGGCGGCAGCAGAAAAAAGAATCGAATGGAGAAAGATTTGTTCCGTCAAAGCGATAGAGCCGTGGCCGTTTGGGGTACATTGTTCTATGATCCCCGCGCGACACCGGATGTCGCTTGGCGGATCTTTCTCCCTGAATTTCAAGGGACGCGGTAAACCGACCGGTCGGGCCGAGCAGCACCAGGGCTGGCTAGCTAGCGCACGACCGGTCATCTCGACCGCGACCCTCAACGCCGCACGAACCCGTTCACGGCGGGCGCGYSYCSSSSCCMYMYSCKMYASASRSGGRSMMSRSGSRSRCGCGCRCRCGSRKWYKCRCRMKRKRKRTKTKWRWAKASACWCWSASASASAYRYKCYYSKGRGARMMCMMRAGMGCSMYWTKYGYKYWMARAKWYKMKRWKWYWCWSWRWWYTCYGCWWYTCACWCTWYWTMTCRSMMTCKMKCTGA", "ATTCAGTGAATCATCGAATCTTTGAACGCAAATGGCGCTCTTGGGTTCTCCCAGGAGCATGTCTGTCTGAGTGTCTATTCAAACATCCATCGTGCGAATCCGCGTGCGCGCGTCCGCCTGGTCCCCGTCTGTAGCGGATGGGGCCGGGACGCGCSCSCSSYGWRMRSGKKYKYGYGSSGYKKWGRGKSKCGSKSKMGAKRWSMSSKSKYGYGCKMKMKMKMSMSMSCYSKKGYKSYKCKSSSCSMSMSSKSKSKKTWYMSCGYSYCYYKWRAWWYWSRGRGARARAKMYSCSMMRMGMSAYMYSSKGTSKCGCGSGGRKMWYAKARMAMWRTRYMCCMMAMRSSSMCRSSKCTMTMKCKYTKWSRSRRMAMAWMTYTYTCYMYWYKMKWYTYTTTTYTSYKSYSSCSSSGKRKMGSKGKSGSSRYMTCWMARRRRAAAARRRRWMKCSYYYYMSASMYCWSAKMWSRSRMRRSKMYMCSCKSWRWWTWWRMRYATWWWWAWRMGSRGRRRAARARAMWMWMAMRRRKWYYCCCMSWRWMRSSGMGWGWRRMGSGRRRAGMKCWMAWWTKWRAWMTCYSMKRYSYSYRYMKSSGMGWKKTRKWKKYGMGARRMRCWYTYTMKRSGSRGRGGSSCYSYSYMWRWKKYKYKKRRMRSSRCRYSKCRSAGRGKGWSAMMMCCSYSTSTGKSRSRGSSSSSSSCSCMCRMKATGYGTYKCGAGASTSGKGTGTTGAKAKYGCAC", true);
        trace(r.mOutput.join(""));
    }
}

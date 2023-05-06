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
 * A score sorter.
 *
 * @author Yann Spoeri
 */
class ScoreSorter
{
    /**
     * Create a new ScoreSorter.
     */
    public function new() {
    }

    /**
     * Sort a particular scores array.
     */
    public function sort(scores:Array<{nr:Int, index:Int, score:Float, matches:Int, mismatches:Int}>):Array<{nr:Int, index:Int, score:Float, matches:Int, mismatches:Int}> {
        var result:Array<{nr:Int, index:Int, score:Float, matches:Int, mismatches:Int}> = scores.copy();
        result.sort(function(a:{nr:Int, index:Int, score:Float, matches:Int, mismatches:Int}, b:{nr:Int, index:Int, score:Float, matches:Int, mismatches:Int}):Int {
            var result:Float = b.score - a.score;
            if (result == 0) {
                return a.mismatches - b.mismatches;
            } else if (result > 0) {
                return 1;
            }
            return -1;
        });
        return result;
    }
}

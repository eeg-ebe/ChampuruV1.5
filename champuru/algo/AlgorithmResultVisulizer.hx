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
package champuru.algo;

/**
 * Visualize the results of an algorithm.
 *
 * @author Yann Spoeri
 */
abstract class AlgorithmResultVisulizer
{
    @:final public static var AS_TEXT:Int = 0;
    @:final public static var AS_HTML:Int = 1;

    public abstract function visualize(type:Int):String;
}
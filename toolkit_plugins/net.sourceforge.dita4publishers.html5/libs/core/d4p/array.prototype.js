/**
 *  @file <filename>
 *
 *  <description>
 *
 *  Copyright 2012 DITA For Publishers  
 * 
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 */
Array.prototype.clean = function (s) {
    var i = 0;
    for (var i = 0; i < this.length; i++) {
        if (this.hasOwnProperty(i)) {
            if (this[i] == s) {
                this.splice(i, 1);
                i = i-1;
            }
        }
    }
    return this;
};
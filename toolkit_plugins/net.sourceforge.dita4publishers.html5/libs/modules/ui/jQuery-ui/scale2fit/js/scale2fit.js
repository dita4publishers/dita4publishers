/**
 *  @file scale2fit
 *
 *  An attempt to allow image to be scaled on double click
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
(function (d4p) {

    d4p.ui.scale2fit = {

        scale: function (obj, r) {
            obj.css("-webkit-transform-origin", "50% 0%");
            obj.css("-moz-transform-origin", "50% 0%");
            obj.css("-ms-transform-origin", "50% 0%");
            obj.css("-o-transform-origin", "50% 0%");
            obj.css("transform-origin", "50% 0%");

            obj.css('-webkit-transition', 'all 300ms linear');
            obj.css('-moz-transition', 'all 300ms linear');
            obj.css('-ms-transition', 'all 300ms linear');
            obj.css('-o-transition', 'all 300ms linear');
            obj.css('transition', 'all 300ms linear');

            obj.css('-webkit-transform', 'scale(' + r + ')');
            obj.css('-moz-transform', 'scale(' + r + ')');
            obj.css('-ms-transform', 'scale(' + r + ')');
            obj.css('-o-transformn', 'scale(' + r + ')');
            obj.css('transform', 'scale(' + r + ')');
        },


        init: function (obj) {
            // store  img size information		
            var s = new Object();
            var self = this;

            // get size of the parent container
            var scale = false;

            var e = obj.closest(".topic");
            var p = obj.parent();
            var w = e.innerWidth();
            var l = parseInt(e.css('padding-left'));
            var r = parseInt(e.css('padding-right'));
            w = w - r - l;

            // Create new offscreen image 
            var img = new Image();
            img.src = obj.attr("src");

            img.onload = function () {

                // Get accurate measurements
                s.ow = this.width;
                s.oh = this.height;

                // trigger scale if we have a better image resolution
                if (s.ow > w) {
                    // ratio is set by the size of the image
                    s.r = Math.round(w / s.ow * 100) / 100;
                    s.w = Math.round(s.ow * s.r) - 1;
                    s.h = Math.round(s.oh * s.r) - 1;
                    console.log("Image scaled with ratio %f", s.r);
                    img.setAttribute('width', s.w);
                    img.setAttribute('height', s.h);

                    if (Modernizr.csstransforms) {

                        var div = $("<div/>").attr('class', 'scalable'),
                        span = $("<span/>").attr('class', 'ui-icon ui-icon ui-icon-arrowthick-2-ne-sw').html("Scale Up"),
                        b1 = $("<button/>").attr('class', 'scale-button ').append(span);

                        b1.click(function () {
                            obj.trigger('dblclick');
                        });

                        div.data('size', s);

                        div.dblclick(function () {

                            var p = $(this);
                            var s = $(this).data('size');


                            if ($(this).hasClass("scaled")) {

                                $(this).removeClass("scaled");
                                $(this).children('button').html("Scale Up");
                                //self.scale(p, 1);
                                self.scale($(this).children('img'), 1);

                            } else {

                                $(this).children('button').html("Scale Down");

                                $(this).addClass("scaled");
                                //self.scale(p, 1/  s.r);
                                self.scale($(this).children('img'), 1 / s.r);
                            }

                        });

                    }
                    div.append(b1);
                    div.append($(img));
                    obj.replaceWith(div);

                }

            };


        }

    };

})(d4p);
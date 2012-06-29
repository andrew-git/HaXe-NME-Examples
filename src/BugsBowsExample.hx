////////////////////////////////////////////////////////////////////////////////
//=BEGIN LICENSE MIT
//
// Copyright (c) 2012, Original author & contributors
// Original author : spanvega ( http://wonderfl.net/user/spanvega )
// Contributors: Niel Drummond
//               Andras Csizmadia <andras@vpmedia.eu>
//
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
// 
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
// LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//  
//=END LICENSE MIT
////////////////////////////////////////////////////////////////////////////////

import flash.geom.Point;
import flash.geom.Rectangle;
import flash.geom.ColorTransform;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.StageScaleMode;
import flash.display.StageAlign;
import flash.display.BlendMode;
import flash.filters.BlurFilter;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.Lib;

import com.gskinner.motion.GTween;
import com.gskinner.motion.easing.Bounce;
import com.gskinner.motion.easing.Circular;
import com.gskinner.motion.easing.Cubic;
import com.gskinner.motion.easing.Elastic;
import com.gskinner.motion.easing.Exponential;
import com.gskinner.motion.easing.Linear;
import com.gskinner.motion.easing.Quadratic;
import com.gskinner.motion.easing.Quartic;
import com.gskinner.motion.easing.Quintic;
import com.gskinner.motion.easing.Sine;

import com.gskinner.motion.plugins.jeash.JeashDisplayObjectPlugin;

#if js
import Html5Dom;
#end

class BugsBowsExample extends Sprite
{
    var blob_vector : Array<Blobb>;

    var blob_ease : String;
    var blob_tween : Class<Dynamic>;

    var blob_blend : BlendMode;
    var blob_speed : Float;
    var blob_area : Float;
    var diagonal  : Float;

    var blob_holder : Sprite;

    var panel  : Sprite;

    var stageW : Float;
    var stageH : Float;
    var appliX : Float;
    var appliY : Float;

    var num_dups : Int;

    static function main () {

        var bugsBows = new BugsBowsExample();
        Lib.current.stage.addChild(bugsBows);
        #if js
        GTween.patchTick(bugsBows);
        #end
        bugsBows.init(null);

    }

    public function new ()
    {
    blob_blend = BlendMode.NORMAL;
        blob_ease = 'easeIn';
        blob_tween = Quadratic;
        blob_speed = 15;
        blob_area = 0;
        num_dups = 6;

        super();

    }

    function init (_)
    {
        if (hasEventListener (Event.ADDED_TO_STAGE))
        {
            removeEventListener (Event.ADDED_TO_STAGE, init);
        }

        stageH = stage.stageHeight;
        stageW = stage.stageWidth;

        appliX = stageW / 2;
        appliY = stageH / 2;

        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;

        diagonal = onDistance (0,0);

        //

        //

        onGenerate ();

        // --o PANEL

        onPanel ();

        //

        stage.addEventListener
            (
             MouseEvent.CLICK, onGenerateProxy
            );

        addEventListener (Event.ENTER_FRAME, onRender);
    }

    function onRender (e : Event)
    {
        // --o BITMAPDATA SCROLL [ 0 - 10 ]

        var sx : Float = (blob_speed / appliX) * (mouseX - appliX);
        var sy : Float = (blob_speed / appliY) * (mouseY - appliY);

        sx = -(sx < blob_speed ? sx : blob_speed);
        sy = -(sy < blob_speed ? sy : blob_speed);

        var sp : Float = Math.abs (sx) + Math.abs (sy);

        // --o BLOB AREA

        blob_area = 10 + sp * 6;

        // --o MOUSE DISTANCE

        var distance : Float = onDistance (mouseX, mouseY);

        distance = (distance < diagonal ? distance : diagonal);

        // --o ALPHA MULTIPLIER [ 0.45 - 0.95 ]

        var am : Float = 0.05 + (distance / diagonal * .5);

        for (b in blob_vector)
        {
            // --o BEVEL FILTER ANGLE DISTANCE

            var degrees : Float = Math.atan2
                (mouseY - b.y, mouseX - b.x) * (180 / Math.PI);

            //

            if (b.moved)
            {    
                b.moved = false;

                b.point = onArea (b.width, b.height);

                // --o INCREASE TWEEN DURATION ACCORDING TO SPEED

                var duration : Float = 1 + ((20 - sp) * Math.random () / 5);

                    var self = this;
                    var g =new GTween(b, duration, {
                        x : b.point.x - x,
                        y : b.point.y - y,
                        alpha : am
                    }, { ease : Reflect.field(blob_tween, blob_ease) });
                    g.onComplete = function (_) {return self.onPointMoved(b);}
                    g.onChange = function (_) { 
                        var tgt = cast(g.target, Blobb);
                        tgt.child.update(new Point(tgt.x, tgt.y), sx, sy, tgt.alpha); }
            }
        }
    }

    function onArea (w : Float, h : Float) : Point
    {
        return new Point
            (
             blob_area + (w/2) + (Math.random () * (stageW - (w + blob_area*2))),
             blob_area + (h/2) + (Math.random () * (stageH - (h + blob_area*2)))
            );
    }

    function onDistance (p1 : Float, p2 : Float) : Float
    {
        var n1 : Float = p1 - appliX;
        var n2 : Float = p2 - appliY;

        return Math.sqrt (n1 * n1 + n2 * n2);
    }

    function onGenerate () 
    {
        var blob_nb : Int = 15 + Math.round (Math.random () * 15);

        //

        blob_holder = new Sprite ();

        blob_vector = [];

        for (i in 0...blob_nb)
        {
            var b : Blobb = new Blobb
                (
                 new Point (appliX, appliY)
                );

            b.blendMode = blob_blend;

            blob_holder.addChild (b);
            blob_vector.push (b);

            for (i in 0...num_dups) {
                b = b.duplicate(i);
                blob_holder.addChild(b);
            }
        }

        addChild(blob_holder);
    }

    function onGenerateProxy (e : MouseEvent) 
    {
        if (! panel.hitTestPoint (mouseX, mouseY))
        {
            onGenerate ();
        }
    }

    //

    function onPanel () 
    {
        panel = new Sprite ();

        // --o BACKGROUND

        var rect : Sprite = new Sprite ();
        rect.graphics.lineStyle (1, 0xAAAAAA);
        rect.graphics.beginFill (0xFFFFFF, 0.5);
        rect.graphics.moveTo (0, 0);
        rect.graphics.lineTo (129, 0);
        rect.graphics.lineTo (129, 123);
        rect.graphics.lineTo (20, 123);
        rect.graphics.lineTo (20, 20);
        rect.graphics.lineTo (0, 20);
        rect.graphics.lineTo (0, 0);
        rect.graphics.endFill ();

    }


    private function onPointMoved (b :Blobb)
    {
        b.moved = true;
    }
}


import flash.geom.Point;
import flash.display.Shape;


class Blobb extends Shape
{

    public var color : Int;
    public var size : Int;

    public var moved : Bool;
    public var point : Point;
    public var child : Blobb;
    public var num : Int;

    static inline var alphaDiff = 0.05;
    static inline var sizeDiff = 1;

    public function new (p : Point, color = 0, size = 0)
    {
        this.color = color == 0 ? Math.round(0xFF0000 * Math.random ()) : color;
        this.size = size == 0 ? 1 + Math.round(Math.random () * 14) : size;
        moved = true;

        super();

        point = p;

        graphics.lineStyle (2, 0xFFFFFF);
        graphics.beginFill (this.color, 1);
        graphics.drawCircle(0, 0, this.size);
        graphics.endFill();

        x = p.x;
        y = p.y;

    }

    public function duplicate(i:Int) {
        child = new Blobb(point, color, size - sizeDiff);
        child.alpha = alpha - alphaDiff;
        child.num = i+1;
        return child;
    }
    public function update(p : Point, x:Float, y:Float, a:Float) {
        this.x = this.x + (p.x + x - this.x) / (4 * num);
        this.y = this.y + (p.y + y - this.y) / (4 * num);
        this.alpha = a - alphaDiff;
        if (child != null) 
            child.update(new Point(this.x, this.y), x, y, this.alpha);
    }

}


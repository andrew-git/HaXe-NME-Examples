////////////////////////////////////////////////////////////////////////////////
//=BEGIN LICENSE MIT
//
// Copyright (c) 2012, Original author & contributors
// Original author : Andre Michelle, http://lab.andre-michelle.com/lines
// Contributors: Frank Wienberg(FWI).
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
package;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.GradientType;
import flash.display.PixelSnapping;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.filters.BlurFilter;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.media.SoundChannel;
import flash.media.SoundTransform;

class ParticleExample extends Sprite
{
    public static inline var WIDTH:Int=384;
    public static inline var HEIGHT:Int=384;
    
    private static inline var PARTICLE_NUM:Int=100;
    
    private var bitmap:Bitmap;
    
    private var particles:Array<Dynamic>;
    
    private var forceXPhase:Float;
    private var forceYPhase:Float;
    
    public function new()
    {                                        
        super();                        
        flash.Lib.current.addChild(this);
        init();
    }
    
    private function init():Void
    {
        var m:Matrix=new Matrix();
        m.createGradientBox(WIDTH, HEIGHT, Math.PI/2);
        
        graphics.beginGradientFill(GradientType.LINEAR, [ 0x212121, 0x404040, 0x0 ], [ 1, 1, 1 ], [ 0, 0x84, 0xff ], m);
        graphics.drawRect(0, 0, WIDTH, HEIGHT);
        graphics.endFill();
        
        forceXPhase=Math.random()* Math.PI;
        forceYPhase=Math.random()* Math.PI;
        
        particles=new Array();
        
        var particle:Particle;
        
        var a:Float;
        var r:Float;
        
        for(i in 0...PARTICLE_NUM-1)
        {
            a=Math.PI * 2 / PARTICLE_NUM * i;
            r=(1 + i / PARTICLE_NUM * 4)* 1;
            
            particle=new Particle(Math.cos(a)* 32, Math.sin(a)* 32);
            particle.vx=Math.sin(-a)* r;
            particle.vy=-Math.cos(a)* r;
            particles.push(particle);
        }
        
        bitmap=new Bitmap(new BitmapData(WIDTH, HEIGHT, true, 0), PixelSnapping.AUTO, false);
        addChild(bitmap);
        
        addEventListener(Event.ENTER_FRAME, onEnterFrame);
    }
    
    private function onEnterFrame(event:Event):Void
    {
        render();
    }
    
    private function render():Void
    {
        var bitmapData:BitmapData=bitmap.bitmapData;
        
        bitmapData.colorTransform(bitmapData.rect, new ColorTransform(1, 1, 1, 1, 0, 0, 0, -1));
        
        var p0:Particle;
        var p1:Particle;
        
        var dx:Float;
        var dy:Float;
        var dd:Float;
        
        var shape:Shape=new Shape();
        
        shape.graphics.clear();
        shape.graphics.lineStyle(0, 0xffffff, 1);
        
        forceXPhase +=.0025261;
        forceYPhase +=.000621;
        
        var forceX:Float=1000 + Math.sin(forceXPhase)* 500;
        var forceY:Float=1000 + Math.sin(forceYPhase)* 500;
        
        for(p0 in particles)
        {
            shape.graphics.moveTo(p0.sx +(WIDTH>>1), p0.sy +(HEIGHT>>1));
//                shape.graphics.moveTo(p0.sx, p0.sy);
            
            p0.vx -=p0.sx / forceX;
            p0.vy -=p0.sy / forceY;
            
            p0.sx +=p0.vx;
            p0.sy +=p0.vy;
            
            shape.graphics.lineTo(p0.sx +(WIDTH>>1), p0.sy +(HEIGHT>>1));
//                shape.graphics.lineTo(p0.sx, p0.sy);
        }
        
        // FWI:transform on drawing, not on blitting Into the bitmap:
//            bitmapData.draw(shape, new Matrix(1, 0, 0, 1, WIDTH>>1, HEIGHT>>1));
        bitmapData.draw(shape);
    }
}
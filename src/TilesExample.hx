////////////////////////////////////////////////////////////////////////////////
//=BEGIN LICENSE MIT
//
// Copyright (c) 2012, Original author & contributors
// Original author : Team of NME Development
// Contributors: Andras Csizmadia <andras@vpmedia.eu>
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

import flash.Lib;
import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Tilesheet;
import flash.display.Graphics;
import flash.events.Event;

class Particle
{
   var x:Float;
   var y:Float;
   var red:Float;
   var green:Float;
   var blue:Float;
   var alpha:Float;
   var angle:Float;
   var aspect:Float;
   var size:Float;

   var dx:Float;
   var dy:Float;
   var da:Float;
   var daspect:Float;


   public function new()
   {
      x = 320;
      y = 240;
      angle = 0;
      dx = Math.random()*2.0 - 1.0;
      dy = Math.random()*2.0 - 1.0;
      da = Math.random()*0.2 - 0.1;
      daspect = Math.random()*0.1;

      aspect = Math.random()*1 + 0.25;

      red = Math.random();
      green = Math.random();
      blue = Math.random();
      alpha = Math.random();

      size = Math.random()*1.9+0.1;
   }

   public function addSimple(data:Array<Float>)
   {
      data.push(x);
      data.push(y);
      data.push(0);
   }

   public function add(data:Array<Float>)
   {
      data.push(x);
      data.push(y);
      data.push(0);
      data.push(size);
      data.push(angle);
      data.push(red);
      data.push(green);
      data.push(blue);
      data.push(alpha);
   }

   public function addTrans(data:Array<Float>)
   {
      data.push(x);
      data.push(y);
      data.push(0);

      var t00 = size*Math.cos(angle);
      var t01 = size*Math.sin(angle);
      var t10 = - t01;
      var t11 = t00;

      var wobble = 1.0 + Math.cos(aspect)*0.75;
      data.push(t00 * wobble); // Squish in x-direction...
      data.push(t01 * wobble);

      data.push(t10);
      data.push(t11);

      data.push(red);
      data.push(green);
      data.push(blue);
      data.push(alpha);
   }


   public function addColoured(data:Array<Float>)
   {
      data.push(x);
      data.push(y);
      data.push(0);
      data.push(red);
      data.push(green);
      data.push(blue);
      data.push(alpha);
   }


   public function move()
   {
      var rad = 30 * size;

      x+=dx;
      if (x<rad)
      {
         x = rad;
         dx = -dx;
      }
      if (x>640-rad)
      {
         x = 640-rad;
         dx = -dx;
      }

      y+=dy;
      if (y<rad)
      {
         y = rad;
         dy = -dy;
      }
      if (y>480-rad)
      {
         y = 480-rad;
         dy = -dy;
      }

      angle += da;
      aspect += daspect;

   }
}

class TilesExample extends Sprite
{
   var tid:Int;
   var particles : Array<Particle>;
   var tilesheet : Tilesheet;

   public function new()
   {
      super();

      Lib.current.stage.addChild(this);

      var shape = new flash.display.Shape();
      var gfx = shape.graphics;
      gfx.beginFill(0xffffff);
      gfx.lineStyle(1,0x000000);
      gfx.drawCircle(32,32,30);
      gfx.endFill();
      gfx.moveTo(32,32);
      gfx.lineTo(62,32);
      var bmp = new BitmapData(64,64,true,#if neko { rgb:0, a:0 } #else 0x00000000 #end );
      bmp.draw(shape);

      tilesheet = new Tilesheet(bmp);
      tilesheet.addTileRect( new flash.geom.Rectangle(0,0,64,64), new flash.geom.Point(32,32) );
      tid = 0;

      particles = [];
      for(i in 0...100)
         particles.push( new Particle() );

      stage.addEventListener( Event.ENTER_FRAME, onEnter );
   }

   public function onEnter(_)
   {
     var data = new Array<Float>();
      var flags = 0;
      particles[0].addSimple(data);
      graphics.drawTiles(tilesheet,data,true,flags);

      var data = new Array<Float>();

      /*
      var flags = Graphics.TILE_SCALE | Graphics.TILE_ROTATION |
                  Graphics.TILE_ALPHA | Graphics.TILE_RGB | Graphics.TILE_BLEND_ADD;
      for(p in particles)
      {
         p.move();
         p.add(data);
      }
      */

       var flags = Graphics.TILE_TRANS_2x2 |
                  Graphics.TILE_ALPHA | Graphics.TILE_RGB | Graphics.TILE_BLEND_ADD;
      for(p in particles)
      {
         p.move();
         p.addTrans(data);
      }


      /*
      var flags = Graphics.TILE_ALPHA | Graphics.TILE_RGB | Graphics.TILE_BLEND_ADD;
      for(p in particles)
      {
         p.move();
         p.addColoured(data);
      }
      */
      graphics.clear();
      graphics.drawTiles(tilesheet,data,true,flags);

 

   }

}

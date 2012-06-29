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

import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;   



/**
 * Based on code by Joa Ebert
 */


class PointParticle 
{
   public function new() { x=y=z=0.0; }

   public var x: Float;
   public var y: Float;
   public var z: Float;
}


class PointsExample extends Sprite 
{
#if neko
   private static var MAX_PARTICLES: Int = 10000;
#elseif iphone
   private static var MAX_PARTICLES: Int = 50000;
#else
   private static var MAX_PARTICLES: Int = 500000;
#end
   private var _targetX: Float;
   private var _targetY: Float;

   private var _text : TextField;
   private var _particles: Array<PointParticle>;
   private var _xy: Array<Float>;
   private var _times: Array<Float>;
   private var _cols: Array<Int>;
   
   public function new()
   {
      super();
      flash.Lib.current.addChild(this);
      _targetX = 0.0;
      _targetY = 0.0;
      _xy = [];
      _times = [];
      _cols = [];
      screenSetup();
      createParticles();
      calculatePositions();

      addEventListener( Event.ENTER_FRAME, onEnterFrame );
   }

   private function screenSetup(): Void
   {
      var tf : TextFormat = new TextFormat();
      tf.font = 'arial';
      tf.size = 10;
      tf.color = 0xffffff;
      
      _text = new TextField();
      _text.autoSize = TextFieldAutoSize.LEFT;
      _text.defaultTextFormat = tf;
      _text.selectable = false;
      _text.text = "0 fps";
      _text.y = 400 - _text.height;
      _text.opaqueBackground = 0x000000;
      addChild( _text );
   }
   
   private function createParticles(): Void
   {
      _particles = [];
      _particles[MAX_PARTICLES-1] = null;
      _cols[MAX_PARTICLES-1] = 0;
      for(i in 0...MAX_PARTICLES)
      {
         _particles[i] = new PointParticle();
         _cols[i] = flash.display.Graphics.RGBA(Std.int(Math.random()*0xffffff),0x10);
      }
   }
   
   private function calculatePositions(): Void
   {
      var _a:Float = 1.111;
      var _b:Float = 1.479;
      var _f:Float = 4.494;
      var _g:Float = 0.44;
       var _d:Float = 0.135;
      var cx:Float = 1;
      var cy:Float = 1;
      var cz:Float = 1;
      var mx:Float = 0;
      var my:Float = 0;
      var mz:Float = 0;
      
      var scale:Float = 40;
      
      for(particle in _particles)
      {
         mx = cx + _d * (-_a * cx - cy * cy - cz * cz + _a * _f);
         my = cy + _d * (-cy + cx * cy - _b * cx * cz + _g);
         mz = cz + _d * (-cz + _b * cx * cy + cx * cz);
         
         cx = mx;
         cy = my;
         cz = mz;
         
         particle.x = mx * scale;
         particle.y = my * scale;
         particle.z = mz * scale;
      }
   }
   
   private function onEnterFrame( event: Event ): Void
   {
       var mx = mouseX;
       var my = mouseY;
      _targetX += ( mx - 275 ) * 0.0003;
      _targetY += ( my - 150 ) * 0.0003;
      
      
      var x: Float;
      var y: Float;
      var z: Float;
      var w: Float;
      
      var pz: Float;
      
      var xi: Int;
      var yi: Int;

      var cx = Math.cos(_targetX);
      var sx = Math.sin(_targetX);
      var cy = Math.cos(_targetY);
      var sy = Math.sin(_targetY);

      var p00: Float = -sy;
      var p01: Float = 0;
      var p02: Float = cy;

      var p10: Float = sx*cy;
      var p11: Float = cx;
      var p12: Float = sx*sy;

      var p20: Float = cx*cy;
      var p21: Float = -sx;
      var p22: Float = cx*sy;

      var p23: Float = 10;
  
      
      var cx: Float = 240.0;
      var cy: Float = 200.0;
      var minZ: Float = 0.0;

      var xy = _xy;
      var idx = 0;

      for(particle in _particles)
      {
         x = particle.x; y = particle.y; z = particle.z;
         xy[idx++] = (( x * p00 + y * p01 + z * p02 ) + cx );
         xy[idx++] = (( x * p10 + y * p11 + z * p12 ) + cy );
      }

      var gfx = graphics;
      gfx.clear();
      gfx.drawPoints(xy,_cols,0,2);

      var now = haxe.Timer.stamp();
      _times.push(now);
      while(_times[0]<now-1)
          _times.shift();
      _text.text = _times.length + " fps";

   }

}


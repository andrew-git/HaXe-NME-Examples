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
import flash.display.Graphics;
import flash.display.Sprite;
import flash.display.Shape;
import flash.geom.Rectangle;

import flash.display.DisplayObject;
import flash.geom.Matrix;
import flash.events.Event;
import flash.events.MouseEvent;

import flash.Lib;

import flash.filters.BlurFilter;


class FiltersExample extends Sprite
{
   var small_objs:Array<DisplayObject>;
   var big_objs:Array<DisplayObject>;

   public function new()
   {
      super();
      flash.Lib.current.addChild(this);

      small_objs = [];
      big_objs = [];

      for(q in 1...6)
         for(str in 1...4)
         {
             var obj = new Shape();
             var gfx = obj.graphics;
             gfx.beginFill(0xa00000);
             gfx.lineStyle(0,0);
             gfx.drawCircle(q*100,str*100-50,40);
             addChild(obj);

             small_objs.push(obj);
         }

      for(flags in 0...8)
      {
          var obj = new Shape();
          var gfx = obj.graphics;
          gfx.beginFill(0xa00000);
          gfx.lineStyle(0,2);
          gfx.drawCircle(flags*80+40,420,25);

          addChild(obj);
          big_objs.push(obj);
      }


      addEventListener(Event.ENTER_FRAME, OnEnterFrame);
      stage.addEventListener(MouseEvent.MOUSE_MOVE, OnMouseMove);
   }

   function OnMouseMove(e:MouseEvent)
   {
      var x = e.stageX - stage.stageWidth/2;
      var y = e.stageY - stage.stageHeight/2;
      SetupFilters(Math.sqrt(x*x+y*y)*0.05,Math.atan2(y,x)*180/Math.PI,10);
   }


   function SetupFilters(inDist:Float, inRad:Float,inBlur:Float)
   {
      var idx=0;
      for(q in 1...6)
         for(str in 1...4)
         {
             var glow = new flash.filters.GlowFilter(0xff0000,0.5,
                               inDist,inDist, str,q, false,(q&0x1)==0);
             var f = new Array<flash.filters.BitmapFilter>();
             f.push(glow);
             small_objs[idx++].filters = f;
         }
      idx = 0;
      for(flags in 0...8)
      {
          var filter = new flash.filters.DropShadowFilter(inDist,inRad,
                             0x000000,0.3, 10,10,1,2,
                            (flags&0x01) > 0 ,(flags&0x02) > 0 ,(flags&0x04) > 0 );
          var f = new Array<flash.filters.BitmapFilter>();
          f.push(filter);
          big_objs[idx++].filters = f;
      }
   }



   function OnEnterFrame(inEvent:Event)
   {
      // scene.x = Std.int(scene.x + 1) & 0x1ff;
   }

}

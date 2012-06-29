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
import flash.events.MouseEvent;     
import flash.events.TouchEvent;  
import flash.events.Event;
import flash.display.DisplayObject;
import flash.display.IGraphicsData;
import flash.display.BitmapData;
import flash.display.Bitmap;
import flash.display.GradientType;
import flash.display.Sprite;
import flash.display.StageDisplayState;
import flash.geom.Matrix;
import flash.ui.Multitouch;   
import flash.ui.MultitouchInputMode; 

class MultiTouchExample extends Sprite
{
   var colourHash:IntHash<Int>;
   var mBitmap:BitmapData;
   var mMultiTouch:Bool;
   
   public function new()
   {
      super();
      Lib.current.addChild(this);

      mMultiTouch = Multitouch.supportsTouchEvents;
      if (mMultiTouch)
         Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
      trace("Using multi-touch : " + mMultiTouch);
      mBitmap = new BitmapData(320,480);
      addChild(new Bitmap(mBitmap));
      colourHash = new IntHash<Int>();
   
      var me = this;
      var cols = [ 0xff0000, 0x00ff00, 0x0000ff ];
      var gfx = graphics;

      for(i in 0...3)
      {
         var pot = new Sprite();
         var gfx = pot.graphics;
         gfx.beginFill( cols[i] );
         gfx.drawCircle( 40+80*i, 40, 25 );
         addChild(pot);

         if (mMultiTouch)
            pot.addEventListener(TouchEvent.TOUCH_BEGIN, 
                function(e) { me.OnDown(e,cols[i]); } );
         else
            pot.addEventListener(MouseEvent.MOUSE_DOWN, 
                function(e) { me.OnDown(e,cols[i]); } );
      gfx.drawRoundRect(10,100,40,30,10,10);
      }

      if (mMultiTouch)
      {
         stage.addEventListener(TouchEvent.TOUCH_MOVE, OnMove);
         stage.addEventListener(TouchEvent.TOUCH_END, OnUp);
      }
      else
      {
         stage.addEventListener(MouseEvent.MOUSE_MOVE, OnMove);
         stage.addEventListener(MouseEvent.MOUSE_UP, OnUp);
      }
   }
   
   function OnDown(event,pot)
   {
      colourHash.set(mMultiTouch ? event.touchPointID : 0, pot);
   }
   
   function OnMove(event)
   {
      var id = mMultiTouch ? event.touchPointID : 0;
      if (colourHash.exists(id))
      {
         var col = colourHash.get(mMultiTouch ? event.touchPointID : 0);
         var cx = Std.int(event.localX);
         var cy = Std.int(event.localY);
         trace("ID : " + id + " " + cx + "," + cy + " = " + col);
         for(x in cx-2 ... cx+3)
            for(y in cy-2 ... cy+3)
               if (x>=0 && y>=0 && x<mBitmap.width && y<mBitmap.height)
                  mBitmap.setPixel(x,y,col);
      }
   }
   
   function OnUp(event)
   {
      colourHash.remove(mMultiTouch ? event.touchPointID : 0);
   }
   
}

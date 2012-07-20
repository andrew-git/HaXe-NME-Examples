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
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.GradientType;
import flash.Lib;
import flash.display.Shape;
import flash.text.TextField;
import flash.geom.Matrix;
import flash.geom.Transform;
import flash.geom.ColorTransform;
import flash.events.MouseEvent;
import nme.installer.Assets;

class ColorTransformExample extends Sprite 
{
   public function new()
   {
      super();
      Lib.current.addChild(this);

      var target:Sprite = new Sprite();
      draw(target);

      addChild(target);
      var data:BitmapData = ApplicationMain.getAsset("image.jpg");
      var bmp = new Bitmap(data);
      bmp.alpha = 0.5;
      bmp.x = 50;
      bmp.y = 50;
      target.addChild(bmp);
      target.alpha = 0.5;

      var box = new Sprite();
      box.alpha = 0.2;
      draw(box);
      box.x = 160;
      box.y = 160;
      addChild(box);

      var data = new BitmapData(100,100,true, 0x00);
      var s = new Shape();
      s.graphics.beginFill(0x00ff00,1);
      s.graphics.drawCircle(0,0,100);
      data.draw(s);

      var data2 = new BitmapData(100,100,true, 0x00);
      data2.draw( new Bitmap(data), null, new ColorTransform(0,0,0,-1,0,0,0,255) );

      var bmp2 = new Bitmap(data2);
      bmp2.x = 200;
      addChild( bmp2 );

      //target.useHandCursor = true;
      //target.buttonMode = true;
      target.addEventListener(MouseEvent.CLICK, clickHandler);
   }

   public function draw(sprite:Sprite)
   {
      var red = 0xFF0000;
      var green = 0x00FF00;
      var blue = 0x0000FF;
      var size = 100.0;
      var mat:Matrix = new Matrix();

      sprite.graphics.beginGradientFill(GradientType.LINEAR, [red, blue, green], [1, 0.5, 1], [0.0, 200, 255]);

      sprite.graphics.drawRect(0, 0, 100, 100);

      sprite.graphics.beginFill(0x808080);
      sprite.graphics.drawRect(80, 80, 100, 100);
   }

   public function clickHandler(event:MouseEvent)
   {
      var d:DisplayObject = this;
      var t:Transform = d.transform;
      var rOffset = t.colorTransform.redOffset + 25;
      var bOffset = t.colorTransform.redOffset - 25;
      var a = d.alpha;
      t.colorTransform = new ColorTransform(1, 1, 1, a*0.9, rOffset, 0, bOffset, 0);
   }
}


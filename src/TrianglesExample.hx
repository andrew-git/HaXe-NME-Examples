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
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.TriangleCulling;  
import flash.net.URLRequest; 
import flash.display.Bitmap;  
import flash.display.Loader;
import flash.Lib;

class TrianglesExample extends Sprite 
{
   var t0:Float;
   var s0:Sprite;
   var s1:Sprite;
   var s2:Sprite;

   public function new()
   {
      super();
      Lib.current.addChild(this);
      addChild(s0 = new Sprite());
      addChild(s1 = new Sprite());
      addChild(s2 = new Sprite());

      s0.scaleX = s0.scaleY = 0.5;
      s1.scaleX = s1.scaleY = 0.5;
      s2.scaleX = s2.scaleY = 0.5;
      s1.x = 550/2;
      s2.y = 400/2;

      #if !flash
        onLoaded(BitmapData.load("../03-Bitmaps/Image.jpg"));
        #else
       var loader = new Loader();
       var me = this;
       loader.contentLoaderInfo.addEventListener(Event.COMPLETE,
          function(e:Event)
             {
             var obj:Bitmap = untyped loader.content;
             me.onLoaded(obj.bitmapData);
             }
          );
       loader.load(new URLRequest("../03-Bitmaps/Image.jpg"));
        #end
   }

    function onLoaded(inData:BitmapData)
    {
      var me = this;
      t0 = haxe.Timer.stamp();
      stage.addEventListener( Event.ENTER_FRAME, function(_) { me.doUpdate(inData); } );
    }

    function doUpdate(inData:BitmapData)
    {

        var sx = 1.0/inData.width;
        var sy = 1.0/inData.height;

      var theta = (haxe.Timer.stamp()-t0);
      var cos = Math.cos(theta);
      var sin = Math.cos(theta);
      var z = sin*100;
      var w0 = 150.0/(200.0+z);
      var w1 = 150.0/(200.0-z);

      var x0 = 200;
      var y0 = 200;
        var vertices = [
          x0 + 100*cos*w0,  y0  -100*w0,
          x0 + 100*cos*w0,  y0  +100*w0,
          x0 - 100*cos*w1,  y0  +100*w1,
          x0 - 100*cos*w1,  y0  -100*w1];

        var indices = [
           0, 1, 2,
            2, 3, 0 ];

        var tex_uv = [
          100.0*sx, 000.0*sy,
          100.0*sx, 200.0*sy,
          300.0*sx, 200.0*sy,
          300.0*sx, 000.0*sy  ];

        var tex_uvt = [
          100.0*sx, 000.0*sy, w0,
          100.0*sx, 200.0*sy, w0,
          300.0*sx, 200.0*sy, w1,
          300.0*sx, 000.0*sy, w1  ];

      #if cpp
        var cols = [ 0xffff0000,
                   0xff00ff00,
                   0xff0000ff,
                   0xffffffff ];
      #end

        var gfx = s0.graphics;
      gfx.clear();
        gfx.beginBitmapFill(inData);
        gfx.lineStyle(4,0x0000ff);
      drawTriangles(gfx, vertices, indices, tex_uvt );

        var gfx = s1.graphics;
      gfx.clear();
        gfx.beginBitmapFill(inData);
        gfx.lineStyle(4,0x0000ff);
      drawTriangles(gfx, vertices, indices, tex_uv );

      #if cpp
        var gfx = s2.graphics;
      gfx.clear();
        gfx.beginFill(0x000000);
        gfx.lineStyle(4,0x808080);
      drawTriangles(gfx, vertices, indices, null, null, cols );
      #end
   }

   function drawTriangles(inGfx:Graphics, ?verts:Array<Float>, ?indices:Array<Int>,
                    ?tex:Array<Float>, ?cull:TriangleCulling, ? cols:Array<Int> )
   {
      #if flash
      var verts_v = new flash.Vector<Float>(verts.length);
      for(i in 0...verts.length) verts_v[i] = verts[i];
      var indices_v = new flash.Vector<Int>(indices.length);
      for(i in 0...indices.length) indices_v[i] = indices[i];
      var tex_v = new flash.Vector<Float>(tex.length);
      for(i in 0...tex.length) tex_v[i] = tex[i];

      inGfx.drawTriangles(verts_v, indices_v, tex_v, cull);
      #else
      inGfx.drawTriangles(verts, indices, tex, cull,cols);
      #end

   }

   private function onEnterFrame( event: Event ): Void
   {
   }


}


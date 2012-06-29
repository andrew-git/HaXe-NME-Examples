////////////////////////////////////////////////////////////////////////////////
//=BEGIN LICENSE MIT
//
// Copyright (c) 2012, Original author & contributors
// Original author : Andre Michelle, http://lab.andre-michelle.com/lines
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

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;  
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;  
import flash.geom.Matrix;
import flash.text.TextField;

class RaycasterExample extends Sprite
{
    private static inline var w:Int=320;
    private static inline var h:Int=208;
    
    private static inline var bounds:Rectangle=new Rectangle(0, 0, w, h);
    private static inline var origin:Point=new Point();
    
    private var engine:Raycaster;
    private var buffer:BitmapData;
    
    private var bmp:Bitmap;
    
    private var mouseDown:Bool;
    
    public function new()
    {
    super();    
    flash.Lib.current.addChild(this);   
        stage.scaleMode=StageScaleMode.NO_SCALE;
        
        engine=new Raycaster(w, h);
        buffer=new BitmapData(w, h);
        
        bmp=new Bitmap(buffer);
        
        bmp.x=(stage.stageWidth - bmp.width)/ 2;
        bmp.y=(stage.stageHeight - bmp.height)/ 2;
        
        addChild(bmp);
        
        engine.render();
        
        stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
        stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
        stage.addEventListener(Event.ENTER_FRAME, enterFrame);
    }
    
    private function onMouseDown(event:Event):Void
    {
        mouseDown=true;
    }
    
    private function onMouseUp(event:Event):Void
    {
        mouseDown=false;
    }
    
    private function enterFrame(event:Event):Void
    {
        engine.angle +=(mouseX - stage.stageWidth / 2)/ 4000;
        
        engine.roll +=(mouseY - stage.stageHeight / 2)/ 32;
        engine.roll=engine.roll>80 ? 80:engine.roll<-80 ? -80:engine.roll;
        
        if(mouseDown)
        {
            engine.x +=Math.cos(engine.angle)* 6;
            engine.y +=Math.sin(engine.angle)* 6;
            
            engine.z -=engine.roll / 50;
            engine.z=engine.z>60 ? 60:engine.z<4 ? 4:engine.z;
        }
        
        engine.z +=(32 - engine.z)/ 128;

        engine.render();
        
        buffer.copyPixels(engine, bounds, origin);
    }
}
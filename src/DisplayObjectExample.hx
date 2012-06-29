////////////////////////////////////////////////////////////////////////////////
//=BEGIN LICENSE MIT
//
// Copyright (c) 2012, Original author & contributors
// Original author : Andras Csizmadia <andras@vpmedia.eu>
// Contributors: -
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

class DisplayObjectExample extends Sprite {
    public function new(){
        super();  
        flash.Lib.current.addChild(this);
        var child:CustomDisplayObject=new CustomDisplayObject();
        addChild(child);
    }
}

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.display.Stage;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;  
import flash.events.MouseEvent;

class CustomDisplayObject extends Sprite {
    private var bgColor:Int;
    private var size:Int;
    
    public function new(){ 
        bgColor=0xFFCC00;
        size=80;
        super();
        draw();
        addEventListener(Event.ADDED, addedHandler);
        addEventListener(Event.ENTER_FRAME, enterFrameHandler);
        addEventListener(Event.REMOVED, removedHandler);
        addEventListener(MouseEvent.CLICK, clickHandler);
        addEventListener(Event.RENDER, renderHandler);
    }
    
    private function draw():Void {
        graphics.beginFill(bgColor);
        graphics.drawRect(0, 0, size, size);
        graphics.endFill();
    }
    
    private function clickHandler(event:MouseEvent):Void {
        trace("clickHandler:" + event);
        parent.removeChild(this);
    }
    
    private function addedHandler(event:Event):Void {
        trace("addedHandler:" + event);
        stage.scaleMode=StageScaleMode.NO_SCALE;
        stage.align=StageAlign.TOP_LEFT;
        stage.addEventListener("resize", resizeHandler);
    }
    
    private function enterFrameHandler(event:Event):Void {
        trace("enterFrameHandler:" + event);
        removeEventListener("enterFrame", enterFrameHandler);
    }
    
    private function removedHandler(event:Event):Void {
        trace("removedHandler:" + event);
        stage.removeEventListener("resize", resizeHandler);
    }
    
    private function renderHandler(event:Event):Void {
        trace("renderHandler:" + event);
    }
    
    private function resizeHandler(event:Event):Void {
        trace("resizeHandler:" + event);
    }

}
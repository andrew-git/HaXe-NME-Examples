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
import flash.events.MouseEvent;

class SpriteExample extends Sprite {
    private var size:Int;
    private var bgColor:Int;

    public function new(){ 
        super();    
        flash.Lib.current.addChild(this);   
        size=100;
        bgColor=0xFFCC00;
        var child:Sprite=new Sprite();
        child.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
        child.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
        draw(child);
        addChild(child);
    }

    private function mouseDownHandler(event:MouseEvent):Void {
        trace("mouseDownHandler");
        var sprite:Sprite=cast(event.target,Sprite);
        sprite.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
        sprite.startDrag();
    }

    private function mouseUpHandler(event:MouseEvent):Void {
        trace("mouseUpHandler");
        var sprite:Sprite=cast(event.target,Sprite);
        sprite.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
        sprite.stopDrag();
    }

    private function mouseMoveHandler(event:MouseEvent):Void {
        trace("mouseMoveHandler");
        event.updateAfterEvent();
    }

    private function draw(sprite:Sprite):Void {
        sprite.graphics.beginFill(bgColor);
        sprite.graphics.drawRect(0, 0, size, size);
        sprite.graphics.endFill();
    }
}
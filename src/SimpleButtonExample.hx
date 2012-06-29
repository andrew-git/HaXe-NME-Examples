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

class SimpleButtonExample extends Sprite {
    public function new(){  
        super();
        flash.Lib.current.addChild(this);
        var button:CustomSimpleButton=new CustomSimpleButton();
        addChild(button);
    }
}

import flash.display.DisplayObject;
import flash.display.Shape;
import flash.display.SimpleButton;

class CustomSimpleButton extends SimpleButton {
private var upColor:Int;
private var overColor:Int;
private var downColor:Int;
private var size:Int;

public function new(){  
    upColor;
    overColor=0xCCFF00;
    downColor=0x00CCFF;
    size    =80;     
    super();
    downState    =new ButtonDisplayState(downColor, size);
    overState    =new ButtonDisplayState(overColor, size);
    upState        =new ButtonDisplayState(upColor, size);
    hitTestState=new ButtonDisplayState(upColor, size * 2);
    hitTestState.x=-(size / 4);
    hitTestState.y=hitTestState.x;
    useHandCursor=true;
}
}

class ButtonDisplayState extends Shape {
private var bgColor:Int;
private var size:Int;

public function new(bgColor:Int, size:Int){
    super();
    this.bgColor=bgColor;
    this.size    =size;
    draw();
}

private function draw():Void {
    graphics.beginFill(bgColor);
    graphics.drawRect(0, 0, size, size);
    graphics.endFill();
}
}
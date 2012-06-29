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

import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;

class GraphicsExample extends Sprite {
    private var size:Int;
    private var bgColor:Int;
    private var borderColor:Int;
    private var borderSize:Int;
    private var cornerRadius:Int;
    private var gutter:Int;

    public function new(){    
        size=80;
        bgColor=0xFFCC00;
        borderColor=0x666666;
        borderSize=0;
        cornerRadius=9;
        gutter=5;
        super();   
        flash.Lib.current.addChild(this);
        doDrawCircle();
        doDrawRoundRect();
        doDrawRect();
        refreshLayout();
    }

    private function refreshLayout():Void {
        var ln:Int=numChildren;
        var child:DisplayObject;
        var lastChild:DisplayObject=getChildAt(0);
        lastChild.x=gutter;
        lastChild.y=gutter;
        for(i in 1...ln-1){
            child=getChildAt(i);
            child.x=gutter + lastChild.x + lastChild.width;
            child.y=gutter;
            lastChild=child;
        }
    }

    private function doDrawCircle():Void {
        var child:Shape=new Shape();
        var halfSize:Int=Math.round(size / 2);
        child.graphics.beginFill(bgColor);
        child.graphics.lineStyle(borderSize, borderColor);
        child.graphics.drawCircle(halfSize, halfSize, halfSize);
        child.graphics.endFill();
        addChild(child);
    }

    private function doDrawRoundRect():Void {
        var child:Shape=new Shape();
        child.graphics.beginFill(bgColor);
        child.graphics.lineStyle(borderSize, borderColor);
        child.graphics.drawRoundRect(0, 0, size, size, cornerRadius, cornerRadius);
        child.graphics.endFill();
        addChild(child);
    }

    private function doDrawRect():Void {
        var child:Shape=new Shape();
        child.graphics.beginFill(bgColor);
        child.graphics.lineStyle(borderSize, borderColor);
        child.graphics.drawRect(0, 0, size, size);
        child.graphics.endFill();
        addChild(child);
    }
}
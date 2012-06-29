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
import flash.display.IGraphicsData;
import flash.display.GraphicsGradientFill;
import flash.display.GraphicsSolidFill;
import flash.display.GraphicsPath;
import flash.display.GraphicsStroke;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.geom.Matrix;
import flash.events.Event;
import flash.Lib;
import flash.Vector;  

class GraphicsDataExample extends Sprite {
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
        doDrawGraphics();
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

    private function doDrawGraphics():Void {
        var child:Shape=new Shape();
        
    // establish the fill properties
        var myFill:GraphicsGradientFill = new GraphicsGradientFill();
        myFill.colors = [0xEEFFEE, 0x0000FF];
        myFill.matrix = new Matrix();
        myFill.matrix.createGradientBox(size, size, 0);     
        // establish the stroke properties
        var myStroke:GraphicsStroke = new GraphicsStroke(borderSize);
        myStroke.fill = new GraphicsSolidFill(borderColor);     
        // establish the path properties
        var myPath:GraphicsPath = new GraphicsPath(new Vector<Int>(), new Vector<Float>());
        myPath.commands.push(1);
        myPath.commands.push(2);
        myPath.commands.push(2);
        myPath.commands.push(2);
        myPath.commands.push(2);
        myPath.data.push(10);
        myPath.data.push(10);    
        myPath.data.push(10);    
        myPath.data.push(100);    
        myPath.data.push(100);    
        myPath.data.push(100);    
        myPath.data.push(10);     
        myPath.data.push(10);    
        myPath.data.push(10);
        myPath.data.push(10);    
        // populate the IGraphicsData Vector array
        var myDrawing:Vector<IGraphicsData> = new Vector();
        myDrawing.push(myFill);
        myDrawing.push(myStroke);
        myDrawing.push(myPath);                                                     
    child.graphics.drawGraphicsData(myDrawing);
        addChild(child);
    }
}
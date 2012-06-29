////////////////////////////////////////////////////////////////////////////////
//=BEGIN LICENSE MIT
//
// Copyright (c) 2012, Original author & contributors
// Original author : Trevor McCauley, www.senocular.com
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
import flash.display.DisplayObject; 
import flash.display.StageScaleMode;
import flash.display.StageAlign;
import flash.events.Event;    
import flash.geom.Rectangle;
import flash.Lib;

import com.eclecticdesignstudio.layout.LayoutManager;
import com.eclecticdesignstudio.layout.LayoutItem;
import com.eclecticdesignstudio.layout.LayoutGroup;
import com.eclecticdesignstudio.layout.LayoutType;


class LayoutExample extends Sprite 
{        
  private var subject:LayoutGroup;
    
    public function new()
    {
    flash.Lib.current.addChild(this);
        super();
        initialize();
    }
    
    public function createBox():Sprite
    {
        var result:Sprite = new Sprite();
        result.graphics.beginFill(0xFF0000);
        result.graphics.drawRect(0, 0, 50, 50);
        result.graphics.endFill();
        //result.x = Std.int(Math.random() * Lib.current.stage.stageWidth);
        //result.y = Std.int(Math.random() * Lib.current.stage.stageHeight);
        return result;
    }
    
    public function initialize():Void
    {
        trace(this+"::"+"initialize");
        
        var box1:Sprite = createBox();
        addChild(box1);
        var box2:Sprite = createBox();
        addChild(box2);
        var box3:Sprite = createBox();
        addChild(box3);
        var box4:Sprite = createBox();
        addChild(box4);
        var box5:Sprite = createBox();
        addChild(box5);
        var box6:Sprite = createBox();
        addChild(box6);        
        
        // don't scale flash player contents and
        // keep the SWF at the top left of the player
        Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
        Lib.current.stage.align = StageAlign.TOP_LEFT;
        Lib.current.stage.addEventListener(Event.RESIZE,stageHandler);
    
        // when using the stage as a layout target
        // the layout will automatically fit to
        // stage.stageWidth and stage.stageHeight and
        // draw its children when the stage resizes
        subject = new LayoutGroup(LayoutType.STRETCH, LayoutType.STRETCH);
        //subject.addEventListener(Event.RESIZE, layoutHandler); 
        
        subject.addItem(new LayoutItem(box1,LayoutType.LEFT, LayoutType.TOP));
        subject.addItem(new LayoutItem(box2,LayoutType.LEFT, LayoutType.BOTTOM));
        subject.addItem(new LayoutItem(box3,LayoutType.RIGHT, LayoutType.TOP));
        subject.addItem(new LayoutItem(box4,LayoutType.RIGHT, LayoutType.BOTTOM));
        subject.addItem(new LayoutItem(box5,LayoutType.CENTER, LayoutType.CENTER));
        subject.addItem(new LayoutItem(box6,LayoutType.CENTER, LayoutType.BOTTOM));
        
        subject.resize(Lib.current.stage.stageWidth,Lib.current.stage.stageHeight);

    }
       
    private function stageHandler(event:Event):Void
    {                   
        trace("stageHandler::"+event + "::" +subject.width+"x"+subject.height);
        
        subject.resize(Lib.current.stage.stageWidth,Lib.current.stage.stageHeight);
    }
  
    private function layoutHandler(event:Event):Void
    {                   
        trace("layoutHandler::"+event+"::"+subject.width+"x"+subject.height);
    }
    
    
}

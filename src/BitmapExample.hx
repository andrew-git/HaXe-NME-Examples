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

import flash.display.Bitmap;
import nme.display.BitmapData;
import flash.display.Loader;  
import flash.display.LoaderInfo;
import flash.display.Sprite;
import flash.events.Event;  
import flash.events.IOErrorEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.net.URLRequest;

class BitmapExample extends Sprite {
    private var url:String;
    private var size:Int;

    public function new(){
        url="textures.gif";   
        size=192;          
        super();               
        flash.Lib.current.addChild(this);
            configureAssets();
    }

    private function configureAssets():Void {
        var loader:Loader=new Loader();
    var info:LoaderInfo = loader.contentLoaderInfo;
        info.addEventListener(Event.COMPLETE, completeHandler);
        info.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);

        var request:URLRequest=new URLRequest(url);
        loader.x=size * numChildren;
        loader.load(request);
        addChild(loader);
    }

    private function duplicateImage(original:Bitmap):Bitmap {
        var image:Bitmap=new Bitmap(original.bitmapData.clone());
        image.x=size * numChildren;
        addChild(image);
        return image;
    }

    private function completeHandler(event:Event):Void {
        var loader:Loader=cast(event.target.loader,Loader);
        var image:Bitmap=cast(loader.content,Bitmap);

        var duplicate:Bitmap=duplicateImage(image);
        var bitmapData:BitmapData=duplicate.bitmapData;
    
        var sourceRect:Rectangle=new Rectangle(0, 0, bitmapData.width, bitmapData.height);
        var destPoint:Point=new Point();
        var operation:String=">=";
        var threshold:Int=0xFF3F271D;
        var color:Int=0xFF0000FF;
        var mask:Int=0xFF00FF00;
        var copySource:Bool=true;

        bitmapData.threshold(bitmapData,
                             sourceRect,
                             destPoint,
                             operation,
                             threshold,
                             color,
                             mask,
                             copySource);   // NME not implemented!
    }
    
    private function ioErrorHandler(event:IOErrorEvent):Void {
        trace("Unable to load image:" + url);
    }
}
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

import flash.display.Loader;  
import flash.display.LoaderInfo;
import flash.display.Sprite;
import flash.events.Event;  
import flash.events.IOErrorEvent;
import flash.net.URLRequest;

class LoaderExample extends Sprite {
    private var url:String;

    public function new(){
        url="textures.gif";
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
        loader.load(request);
        addChild(loader);
    }

    private function completeHandler(event:Event):Void {
        var loader:Loader=cast(event.target.loader,Loader);
        trace(event);
    }
    
    private function ioErrorHandler(event:IOErrorEvent):Void {
        trace(event);
    }
}
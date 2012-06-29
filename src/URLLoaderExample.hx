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

import flash.Lib;
import flash.display.Sprite;
import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.errors.SecurityError;
import flash.errors.TypeError;
import flash.net.URLVariables;
import flash.net.URLRequestMethod;

  
class URLLoaderExample extends Sprite {
    private var postTextField:TextField;
    private var xmlTextField:TextField;
    private var externalXML:Xml;    
    private var loader:URLLoader;

    public function new()
     {
         super();
          flash.Lib.current.addChild(this);

        //var request:URLRequest = new URLRequest("http://www.w3schools.com/xml/cd_catalog.xml");
        var request:URLRequest = new URLRequest("https://twitter.com/");
        #if !flash
        request.basicAuth("basic","basic");
        request.cookieString = "name=value";
        request.verbose = true;
        #end
        loader = new URLLoader();
        loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
        loader.addEventListener(Event.COMPLETE, loaderCompleteHandler);
        loader.addEventListener(ProgressEvent.PROGRESS, onProgress);

        try {
            loader.load(request);
        }
        catch (error:SecurityError)
        {
            trace("A SecurityError has occurred.");
        }

        postTextField = new TextField();
        postTextField.x = 10;
        postTextField.y = 10;
        postTextField.background = true;
        postTextField.autoSize = TextFieldAutoSize.LEFT;

        addChild(postTextField);


        xmlTextField = new TextField();
        xmlTextField.x = 10;
        xmlTextField.y = 100;
        xmlTextField.background = true;
        xmlTextField.autoSize = TextFieldAutoSize.LEFT;

        addChild(xmlTextField);

        var image_loader = new flash.display.Loader();
        image_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(_) {
            var bmp:flash.display.Bitmap = cast image_loader.content;
            trace("Loaded image " + bmp.bitmapData.width + "x" + bmp.bitmapData.height);
        });

        var request:URLRequest = new URLRequest("http://upload.wikimedia.org/wikipedia/en/7/72/Example-serious.jpg");
        image_loader.load(request);
        image_loader.x = 180;
        image_loader.y = 180;
        addChild(image_loader);

        var post = new URLRequest("http://www.snee.com/xml/crud/posttest.cgi");
        var vars = new URLVariables();
        vars.fname = "Milla";
        vars.lname = "Jovovich";
        vars.submit = "1";
        post.method = URLRequestMethod.POST;
        post.data = vars;
        #if !flash
        post.verbose = true;
        #end
        var postLoad = new URLLoader();
        postLoad.addEventListener(Event.COMPLETE, function(_) {
           postTextField.htmlText = postLoad.data.toString();
        } );

        try {
            postLoad.load(post);
        }
        catch (error:SecurityError)
        {
            trace("A SecurityError has occurred.");
        }
    }

     function onProgress(event:ProgressEvent)
     {
        trace("Loaded " + event.bytesLoaded + "/" + event.bytesTotal );
     }

    private function loaderCompleteHandler(event:Event):Void {

            try {
                xmlTextField.text = loader.data;
            } catch (e:TypeError) {
                trace("Could not load the XML file.");
            }
    }


    private function errorHandler(e:IOErrorEvent):Void {
        xmlTextField.text = "Error:" + e.text;
    }

}


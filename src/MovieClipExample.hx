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

import flash.display.MovieClip;
import flash.text.TextField;

class MovieClipExample extends MovieClip {

    public function new(){
        super();     
        flash.Lib.current.addChild(this);
        var outputText:TextField=new TextField();
        outputText.text=getPropertiesString();
        outputText.width=stage.stageWidth;
        outputText.height=outputText.textHeight;
        addChild(outputText);
    }

    private function getPropertiesString():String {
        var str:String=""
            + "currentFrame:" + currentFrame + "\n"
            //+ "currentLabel:" + currentLabel + "\n"  // NME not implemented!
            //+ "currentScene:" + currentScene + "\n"  // NME not implemented!
            + "framesLoaded:" + framesLoaded + "\n"
            + "totalFrames:" + totalFrames + "\n";
            //+ "trackAsMenu:" + trackAsMenu + "\n";  // NME not implemented!
        return str;
    }
}
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
import flash.text.TextField;  
import flash.text.TextFieldType;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;     
import flash.events.Event;
import flash.events.TextEvent;
import flash.events.MouseEvent;

class TextInputExample extends Sprite
{
    private var myTextBox1:TextField;
    private var myTextBox2:TextField;

    public function new(){      
        myTextBox1=new TextField();
        myTextBox2=new TextField();
        super();                           
        flash.Lib.current.addChild(this);
        myTextBox1.type=TextFieldType.INPUT;
        myTextBox1.width=200;
        myTextBox1.height=20;
        myTextBox1.background=true;
        myTextBox1.border=true;
        
        myTextBox2.x=220;

        addChild(myTextBox1);
        addChild(myTextBox2);
        myTextBox1.addEventListener(TextEvent.TEXT_INPUT,textInputHandler);
    }

    public function textInputHandler(event:TextEvent):Void
    {
       myTextBox2.text=event.text;
    }
}
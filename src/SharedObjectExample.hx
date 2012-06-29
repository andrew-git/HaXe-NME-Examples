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
package;
import flash.Lib;
import flash.text.TextField;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.events.Event;
import flash.net.SharedObject;


class SharedObjectExample extends Sprite
{
   private var so:SharedObject;
   var label:TextField;
   
   public function new()
   {
      super();
      label=new TextField();
      label.width=600;
      label.height=800;
      Lib.current.stage.addChild(this);
      label.text="";
      addChild(label);
      label.text="Loading SO 'nmeTest':";

      so=SharedObject.getLocal("nmeTest");     

      var strData:String=expandAsString(so.data);
      trace("str data:'"+strData+"'");
      label.text+=strData;
      label.text+="\n, Click to save and flush!";

      Lib.current.stage.addEventListener(MouseEvent.CLICK,onClick);
   }

   public function onClick(inEvent:MouseEvent)
   {
      Reflect.setField(so.data,"name","John Doe");
      Reflect.setField(so.data,"age","24");
      so.flush();
      label.text+="DONE";
   }
   
   private static function expandAsString(obj:Dynamic):String
   {
      if (obj==null)
      {
         return null;
      }
      
      var str:String="{";
      var iter:Iterator<String>=Reflect.fields(obj).iterator();
      for (i in iter)
      {
         str+=i+"="+Reflect.field(obj,i);
         if (iter.hasNext())
         {
            str+=",";
         }
      }
      str+="}";
      
      return str;
   }

}

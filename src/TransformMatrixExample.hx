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

import flash.geom.Matrix;    
import flash.geom.Point;  
import flash.display.Sprite;
import flash.events.MouseEvent;

class TransformMatrixExample extends Sprite 
{
    private var size:Int;
    private var bgColor:Int;

    public function new()
  { 
        super();    
        flash.Lib.current.addChild(this);   
          size=100;
           bgColor=0xFFCC00;
            var child:Sprite=new Sprite();
            draw(child);
            addChild(child);
        
        var matrix:Matrix=child.transform.matrix.clone();
        rotateAroundInternalPoint(matrix, child.width / 2, child.height / 2, 45);//center rotate
        child.transform.matrix=matrix; 
    } 
  
  public static function rotateAroundInternalPoint(m:Matrix, x:Float, y:Float, angleDegrees:Float):Void
  {
    var point:Point=new Point(x, y);
    point=m.transformPoint(point);
    m.tx-=point.x;
    m.ty-=point.y;
    m.rotate(angleDegrees * (Math.PI / 180));
    m.tx+=point.x;
    m.ty+=point.y;
  }   

    private function draw(sprite:Sprite):Void 
  {
        sprite.graphics.beginFill(bgColor);
        sprite.graphics.drawRect(0, 0, size, size);
        sprite.graphics.endFill();
    }
}
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
import flash.display.BitmapData;
import flash.geom.Rectangle;
import flash.geom.Point;  
import flash.geom.Matrix;

class Raycaster extends BitmapData
{
    private var map:BitmapData;
    
    //-- WORLD COORDINATES --//
    public var x:Int;
    public var y:Int;
    public var z:Int;
    public var angle:Float;
    public var roll:Float;
    
    private var iceil:BitmapData;
    private var ifloor:BitmapData;
    private var iwall:BitmapData;

    //-- PRE COMPUTE --//
    public var fov:Float;
    private var eyeDistance:Float;
    private var subRayAngle:Float;
    private var p_center:Float;
    
    private var sin:Array<Dynamic>;
    private var cos:Array<Dynamic>;
    private var tan:Array<Dynamic>;
    
    //[Embed(source='assets/textures.gif')] public var TBmp:Class;
    
    public function new(width:Int, height:Int)
    {
        super(width, height, false, 0);
        
        var tbmp:Bitmap;//=new TBmp();
        var textures:BitmapData=new BitmapData(192, 64, false, 0);
        textures.draw(tbmp, new Matrix());
        
        ifloor=new BitmapData(64, 64, false, 0xffcc00);
        iceil=new BitmapData(64, 64, false, 0xff0000);
        iwall=new BitmapData(64, 64, false, 0xcccccc);
        
        ifloor.copyPixels(textures, new Rectangle(0, 0, 64, 64), new Point(0, 0));
        iceil.copyPixels(textures, new Rectangle(64, 0, 64, 64), new Point(0, 0));
        iwall.copyPixels(textures, new Rectangle(128, 0, 64, 64), new Point(0, 0));

        x=64 * 64 + 32;
        y=64 * 64 + 32;
        z=32;
        
        map=new BitmapData(128, 128, false, 0);
        
        for(iy in 0...128-1)
        {
            for(ix in 0...128-1)
            {
                map.setPixel(ix, iy, Math.random()<.1 ? 1:0);
            }
        }
        
        angle=0;
        roll=0;

        fov=60 * Math.PI / 180;
        
        //-- fill lookup table
        sin=new Array();
        cos=new Array();
        tan=new Array();
        
        for(i in 0...7200-1)
        {
            sin[i]=Math.sin(i / 3600 * Math.PI);
            cos[i]=Math.cos(i / 3600 * Math.PI);
            tan[i]=Math.tan(i / 3600 * Math.PI);
        }

        init();
    }

    public function init():Void
    {
        eyeDistance=(width / 2)/ Math.tan(fov / 2);
        subRayAngle=fov / width;
    }

    public function render():Void
    {
        //-- LOCAL VARIABLES --//
        var rx:Int=x>>6;
        var ry:Int=y>>6;
        
        var tx:Int=rx;
        var ty:Int=ry;

        var ax:Float;
        var ay:Float;
        var dx:Float;
        var dy:Float;
        var distance:Float;

        var offset:Float=0;
        var nearest:Float;
        var beta:Float;
        var ht:Float;
        var tn:Float;
        var cs:Float;
        var sn:Float;
        
        var distort:Float;
        var cf:Float;
        var ff:Float;
        var c0:Int;
        var c1:Int;
        var dg:Int;
        
        var color:Int;
        
        //-- clamp angle for lookup tables
        if(angle<0)angle +=Math.PI * 2;
        if(angle>Math.PI * 2)angle -=Math.PI * 2;

        var a:Float=angle + fov * .5;
        if(a>Math.PI * 2)a -=Math.PI * 2;
        
        var sx:Int=width - 1;
        var sy:Int;

        //-- PRECOMPUTE --//
        p_center=height / 2 - roll;
        var oz:Float=64 - z;
        
        var ang:Int=Math.floor(angle *(3600 / Math.PI))| 0;

        while(--sx>-1)
        {
            nearest=Number.POSITIVE_INFINITY;
            
            dg=(a *(3600 / Math.PI))>>0;
            
            tn=tan[ dg ];
            sn=sin[ dg ];
            cs=cos[ dg ];

            rx=tx;
            ry=ty;
            
            if(sn<0)
            {
                while(ry>-1 && rx>-1 && rx<128)
                {
                    ay=ry<<6;
                    ax=x +(ay - y)/ tn;
                    rx=ax>>6;
                    
                    ry--;
                    
                    if(map.getPixel(rx, ry))
                    {
                        dx=ax - x;
                        dy=ay - y;
                        
                        nearest=dx * dx + dy * dy;
                        offset=ax & 63;
                        break;
                    }
                }
            }
            else
            {
                while(ry<128 && rx>-1 && rx<128)
                {
                    ++ry;
                    
                    ay=ry<<6;
                    ax=x +(ay - y)/ tn;
                    rx=ax>>6;
                    
                    if(map.getPixel(rx, ry))
                    {
                        dx=ax - x;
                        dy=ay - y;
                        
                        nearest=dx * dx + dy * dy;
                        offset=64 - ax & 63;
                        break;
                    }
                }
            }
            rx=tx;
            ry=ty;
            if(cs<0)
            {
                while(rx>-1 && ry>-1 && ry<128)
                {
                    ax=rx<<6;
                    ay=y +(ax - x)* tn;
                    ry=ay>>6;
                    
                    rx--;
                    
                    if(map.getPixel(rx, ry))
                    {
                        dx=ax - x;
                        dy=ay - y;
                        
                        distance=dx * dx + dy * dy;
                        
                        if(distance<nearest)
                        {
                            nearest=distance;
                            offset=64 - ay & 63;
                        }
                        break;
                    }
                }
            }
            else
            {
                while(rx<128 && ry>-1 && ry<128)
                {
                    ++rx;
                    ax=rx<<6;
                    ay=y +(ax - x)* tn;
                    ry=ay>>6;
                    
                    if(map.getPixel(rx, ry))
                    {
                        dx=ax - x;
                        dy=ay - y;
                        
                        distance=dx * dx + dy * dy;
                        
                        if(distance<nearest)
                        {
                            nearest=distance;
                            offset=ay & 63;
                        }
                        break;
                    }
                }
            }
            
            if(dg<ang)
            {
                distort=eyeDistance / cos[ 7200 + dg - ang ];
            }
            else
            {
                distort=eyeDistance / cos[ dg - ang ];
                
            }
            
            ht=distort / Math.sqrt(nearest);
            
            cf=oz * distort;
            ff=z * distort;

            c0=Std.int(p_center - ht * oz);
            c1=Std.int(p_center + ht * z + .5);
            
            sy=height;
            
            while(--sy>c1)
            {
                if(sy<0)break;
                
                //-- FLOOR TILES --//
                distance=ff /(sy - p_center);
                
                color=ifloor.getPixel((x + cs * distance)& 63,(y + sn * distance)& 63);
                
                setPixel(sx, sy, color);
            }

            while(--sy>c0)
            {
                if(sy<0)break;
                
                //-- BLOCKS --//
                color=iwall.getPixel(offset,(sy - c0)/ ht);
                
                setPixel(sx, sy, color);
            }
            
            while(--sy>-1)
            {
                if(sy<0)break;
                
                //-- CEILING --//
                distance=cf /(p_center - sy);
                
                color=iceil.getPixel((x + cs * distance)& 63,(y + sn * distance)& 63);
                
                setPixel(sx, sy, color);
            }
            
            a -=subRayAngle;
            
            if(a<0)a +=Math.PI * 2;
        }
    }
}
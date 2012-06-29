////////////////////////////////////////////////////////////////////////////////
//=BEGIN LICENSE MIT
//
// Copyright (c) 2012, Original author & contributors
// Original author : spanvega ( http://wonderfl.net/user/spanvega )
// Contributors: Niel Drummond
//               Andras Csizmadia <andras@vpmedia.eu>
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

//import com.bit101.components.Label;
//import com.bit101.components.PushButton;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.BlendMode;
import flash.display.Sprite;
import flash.display.StageQuality;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.geom.ColorTransform;
import flash.geom.Rectangle;
import flash.Lib;

class AntsExample extends Sprite {
    public static var DISPLAY:Rectangle = new Rectangle(0, 0, 465, 465);
    public static var ANTSNUM:Int = 180;
    public static var ADDNUM:Int = 30;
    public static var ANTSMAX:Int = 1000;
    public static var MATERIAL_URL:String = "40c16871d560d547ebb1fc1725db47922ef9f261.png";
    public var world:World;
    public var bg:Sprite;
    public var containerAnts:Sprite;
    public var containerFoods:Sprite;
    public var canvasBmp:Bitmap;
    public var pheromoneBmp:Bitmap;
    public var canvas:BitmapData;
    public var loader:ImageLoader;
    //public var stats:Label;
    public var whiteColor:ColorTransform;
    public function new() {   
        super();  
    flash.Lib.current.addChild(this);
        whiteColor = new ColorTransform();

        //stage.frameRate = 30;
        //stage.quality = StageQuality.MEDIUM;
        //Wonderfl.capture_delay(5);
        whiteColor.color = 0xFFFFFF;
        
        world = new World();
        world.home.setPosition(110, 350);
        world.obstacles.push(new Obstacle(280, 225, 90));
        world.obstacles.push(new Obstacle(0, -150, 280));
        world.init(DISPLAY.width, DISPLAY.height);
        
        bg = new Sprite();
        bg.graphics.beginFill(0x444444, 1);
        bg.graphics.drawRect(0, 0, DISPLAY.width, DISPLAY.height);
        bg.graphics.endFill();
        
        addChild(bg);
        
        loader = new ImageLoader();
        loader.load(MATERIAL_URL, onLoadImage, onErrorImage);
    }
    private function onErrorImage(str:String) {        
  onLoadImage();
    }
    private function onLoadImage() {
        if(loader.ground != null)
    {
      loader.ground.width = DISPLAY.width;
          loader.ground.height = DISPLAY.height;
        }
        pheromoneBmp = new Bitmap(world.pheromone.map);
        pheromoneBmp.visible = false;
        pheromoneBmp.blendMode = BlendMode.LIGHTEN;
        
        for (obs in world.obstacles) {
            var sp:Sprite = cast addChild(new Sprite());
            sp.graphics.beginFill(0x444444, 0);
            sp.graphics.drawCircle(obs.center.x, obs.center.y, obs.radius);
            sp.graphics.endFill();
        }
        canvas = new BitmapData(Math.round(DISPLAY.width), Math.round(DISPLAY.height), true, 0x00FFFFFF);
        canvasBmp = new Bitmap(canvas);
        canvasBmp.filters = [new DropShadowFilter(3, 45, 0x222222, 0.8, 3, 3, 1, 1)];
        containerAnts = new Sprite();
        containerFoods = new Sprite();
        containerFoods.mouseChildren = false;
        containerFoods.mouseEnabled = false;
        
        var menu:Sprite = new Sprite();
        var blackBox:Sprite = cast menu.addChild(new Sprite());
        blackBox.graphics.beginFill(0x000000, 0.5);
        blackBox.graphics.drawRect(0, 0, DISPLAY.width, 25);
        blackBox.graphics.endFill();
        //new SwitchButton(menu, DISPLAY.width - 160, 5, ["PHEROMONE: OFF", "PHEROMONE: ON"], onSwitchPheromon);
        //new PushButton(menu, DISPLAY.width - 55, 5, "RESET", onClickClear).setSize(50, 16);
        //new PushButton(menu, 5, 5, "+" + ADDNUM + " ANTS", onClickAdd).setSize(70, 16);
        //stats = new Label(menu, 85, 3, "");
        //stats.transform.colorTransform = whiteColor;
        menu.y = DISPLAY.height - menu.height;
        
    if(loader.ground != null)
    {
          addChild(loader.ground);
        }
    addChild(pheromoneBmp);
        addChild(world.home);
        addChild(canvasBmp);
        addChild(containerFoods);
        addChild(menu);
        //new Label(this, 5, 3, "CLICK TO FEED").transform.colorTransform = whiteColor;
        
        init(ANTSNUM);
        //bg.addEventListener(MouseEvent.MOUSE_DOWN, onClickStage);
        addEventListener(MouseEvent.MOUSE_DOWN, onClickStage);
        addEventListener(Event.ENTER_FRAME, onEnter);
    }

    private function init(num:Int) {
        world.clear();
        var wait:Float = 10;
        for (i in 0...num) {
            wait += Math.max(0.05, 15 / (i * i / 100 + 1));
            containerAnts.addChild(world.addAnt(Math.round(wait)).body);
        }
    }

    private function onClickClear(e:MouseEvent){
        init(ANTSNUM);
    }

    private function onClickAdd(e:MouseEvent) {
        var num:Int = Math.round(Math.min(ADDNUM, ANTSMAX - world.ants.length));
        for (i in 0...num)
            containerAnts.addChild(world.addAnt(Math.round(i/2)).body);
    }

    private function onSwitchPheromon(mode:Int){
        pheromoneBmp.visible = mode == 0 ? false : true;
    }

    private function onClickStage(e:MouseEvent) {
        var img:ImageData_ = loader.feeds[Math.round(Math.random() * loader.feeds.length) | 0];
        containerFoods.addChild(world.addFood(Math.round(stage.mouseX), Math.round(stage.mouseY), img).sprite);
    }

    static var start:Float = haxe.Timer.stamp();
    static var frame:Int = 1;
    private function onEnter(e:Event) {
        /*
        #if js
        if (frame++ % 20 == 0) {
            untyped document.getElementById('haxe:trace').innerHTML = Math.round(20/(haxe.Timer.stamp()-start)) + " fps";
            start = haxe.Timer.stamp();
        }
        #end
        */
        //world.pheromone.map.lock();
        for (a in world.ants) a.action(world);
        world.pheromone.vaporize();
        //world.pheromone.map.unlock();

        canvas.fillRect(DISPLAY, 0x00000000);
        //canvas.jeashClearCanvas();
        
        //canvas.draw(loader.ground);
        //canvas.draw(world.home);
        canvas.draw(containerAnts);
    }
}

//import com.bit101.components.PushButton;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.BlendMode;
import flash.display.DisplayObjectContainer;
import flash.display.Loader;
import flash.display.Sprite;
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.MouseEvent;
import flash.events.SecurityErrorEvent;
import flash.filters.DropShadowFilter;
import flash.geom.ColorTransform;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.net.URLRequest;
#if flash
import flash.system.LoaderContext;
#end
import flash.system.System;
class Angle {
    static public var ALL_RADIAN:Float = Math.PI * 2;
    static public var TO_RADIAN:Float = Math.PI / 180;
    static public var TO_ROTATION:Float = 180 / Math.PI;
    static public function between(a1:Float, a2:Float, per:Float):Float {
        var minus:Float = a1 - a2;
        var r180:Float = (minus % Angle.ALL_RADIAN + Angle.ALL_RADIAN) % Angle.ALL_RADIAN;
        if (r180 > Math.PI) r180 -= Angle.ALL_RADIAN;
        var a0:Float = r180 + a2;
        return a0 * (1 - per) + a2 * (per);
    }
}

class World {
    public var area:Rectangle;
    public var ants:Array<Ant>;
    public var foods:Array<Food>;
    public var obstacles:Array<Obstacle>;
    public var home:AntsHill;
    public var pheromone:Pheromone;
    public function new() { 
        ants = new Array<Ant>();
        foods = new Array<Food>();
        obstacles = new Array<Obstacle>();
        home = new AntsHill();
    }
    public function init(width:Float, height:Float) {
        area = new Rectangle(0, 0, width, height);
        pheromone = new Pheromone(width, height);
    }
    public function cutFood(f:Food) {
        if (f.cut()) {
            f.remove();
            foods.splice(Lambda.indexOf(foods, f), 1);
        }
    }
    public function addFood(x:Int, y:Int, img:ImageData_):Food {
        var f:Food = new Food(x, y, 50, 200, img);
        foods.push(f);
        return f;
    }
    public function addAnt(wait:Int):Ant {
        var a:Ant = new Ant(home.position.x, home.position.y);
        a.thinkTime = wait;
        ants.push(a);
        return a;
    }
    public function clear() {
        for (f in foods) f.remove();
        for (a in ants) a.remove();
        ants = [];
        foods = [];
        pheromone.clear();
        //System.gc();
    }
}
class ImageData_ {
    private var _colors:Array<Int>;
    public var bmd:BitmapData;
    public function new(bmd:BitmapData) {
        var px:Int, py:Int, rgba:Int;
        this.bmd = bmd;
        _colors = new Array();
        px = 0; 
        while (px < bmd.width) {
            py = 0; 
            while (py < bmd.width) {
                rgba = bmd.getPixel32(px, py);
                if (rgba >>> 24 == 255) _colors.push(rgba & 0xFFFFFF);
                py += 8;
            }
            px += 8;
        }
    }
    public function getRandomColor():Int {
        return _colors[Math.round(Math.random() * _colors.length) | 0];
    }
}
class ImageLoader {
    public var ground:Bitmap;
    public var feeds:Array<ImageData_>;
    private static var FEED_NUM:Int = 5;
    private var _loader:Loader;
    private var _completeFunc:Dynamic;
    private var _errorFunc:Dynamic;
    public function new() {
        _loader = new Loader();
    }
    public function load(src:String, complete:Dynamic, error:Dynamic){
        _completeFunc = complete;
        _errorFunc = error;
        _loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onErrorImage);
        _loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onErrorImage);
        _loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadImage);
        #if flash
    _loader.load(new URLRequest(src), new LoaderContext(true));
    #else
    _loader.load(new URLRequest(src));
    #end
    }
    private function removeEvent() {
        _loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onErrorImage);
        _loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onErrorImage);
        _loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadImage);
    }
    private function onErrorImage(e:ErrorEvent) {
        removeEvent();
        _errorFunc(e.text);
    }
    private function onLoadImage(e:Event) {
        removeEvent();
        var bmp:BitmapData = cast(_loader.content, Bitmap).bitmapData;
        feeds = new Array<ImageData_>();
        for (i in 0...FEED_NUM) {
            var bmp2:BitmapData = new BitmapData(64, 64, true, 0x00FFFFFF);
            bmp2.copyPixels(bmp, new Rectangle(64 * i, 0, 64, 64), new Point(0, 0));
            feeds.push(new ImageData_(bmp2));
        }
        ground = new Bitmap(new BitmapData(bmp.width, bmp.height-64, false));
        ground.bitmapData.copyPixels(bmp, new Rectangle(0, 64, ground.width, ground.height), new Point());
        ground.smoothing = true;
        _completeFunc();
    }
}
class AntsHill extends Sprite {
    public var position:Point;
    public function new() {
        super();
        graphics.beginFill(0x000000, 0.3);
        graphics.drawCircle(0, 0, 9);
        graphics.beginFill(0x000000, 1);
        graphics.drawCircle(0, 0, 7);
        graphics.endFill();
        position = new Point();
    }
    public function setPosition(x:Float, y:Float) {
        this.x = position.x = x;
        this.y = position.y = y;
    }
}
class Pheromone {
    public var map:BitmapData;
    private var _ct:ColorTransform;
    private var _timeCount:Int;
    public function new(width:Float, height:Float) {
        _timeCount = 0;
        _ct = new ColorTransform(1, 0.99, 1, 1, 0, 0, 0, 0);
        map = new BitmapData(Math.round(width), Math.round(height), true, 0x00000000);
    }
    public function getGuidepost(x:Int, y:Int):Float {
        var isNone:Bool = true, tx:Float = 0, ty:Float = 0, px:Int, py:Int;
        px = -2;
        while (px <= 2) {
            py = -2;
            while (py <= 2) {
                if (px != 0 || py != 0) {
                    // Note: getPixel* is still too slow for hot code... 
                    var per:Float = 0; //(map.getPixel32(x + px * 4, y + py * 4) >> 8 & 0xFF) / 255;
                    //var per:Float = (map.getPixel(x + px * 4, y + py * 4) >> 8 & 0xFF) / 255;
                    tx += per * px;
                    ty += per * py;
                    if (per != 0) isNone = false;
                }
                py++;
            }
            px++;
        }
        var angle:Float;
        if ((tx == 0 && ty == 0) || isNone) {
            angle = Math.NaN;
        } else {
            var angleRate:Float = (map.getPixel32(x, y) & 0xFF) / 255;
            var dx:Float, dy:Float;
            if (angleRate == 0) {
                dx = tx;
                dy = ty;
            } else {
                var radian:Float = angleRate * Angle.ALL_RADIAN + Math.PI;
                dx = Math.cos(radian) * 40 + tx;
                dy = Math.sin(radian) * 40 + ty;
            }
            angle = Math.atan2(dy, dx);
        }
        return angle;
    }
    public function putPheromone(x:Int, y:Int, radianPer:Float) {
        var rgb:Int = 0xF0 << 24 | 0xFF << 16 | 0xFF << 8 | Math.round(0xFF * radianPer);
        map.fillRect(new Rectangle(x-5, y-5, 11, 11), rgb);
    }
    public function vaporize() {
        //if ((++_timeCount % 2) == 0) map.colorTransform(map.rect, _ct);
    }
    public function clear() {
        map.fillRect(map.rect, 0x00000000);
    }
}
class Food {
    public var sprite:Sprite;
    public var position:Point;
    public var size:Float;
    public var quantity:Int;
    public var image:ImageData_;
    private var _max:Int;
    private var _mask:BitmapData;
    private var _noise:BitmapData;
    public function new(x:Float = 0, y:Float = 0, size:Float = 10, num:Int = 10, img:ImageData_ = null) {
        position = new Point(x, y);
        this.size = size;
        quantity = num;
        _max = num;
        sprite = new Sprite();
        sprite.x = x;
        sprite.y = y;
        sprite.scaleX = sprite.scaleY = 0.7;
        sprite.filters = [new DropShadowFilter(5, 45, 0x111111, 0.7, 8, 8, 1, 1)];
        image = img;
        var foodBmp:Bitmap = cast sprite.addChild(new Bitmap(image.bmd));
        foodBmp.smoothing = true;
        _mask = new BitmapData(image.bmd.width, image.bmd.height, true);
        _mask.fillRect(_mask.rect, 0x00888888);
        _noise = new BitmapData(image.bmd.width, image.bmd.height, false);
        //_noise.perlinNoise(20, 20, 3, Int(Math.random() * 100), false, true, 1, true);
        //var maskBmp:Bitmap = cast sprite.addChild(new Bitmap(_mask));
        var maskBmp:Bitmap = new Bitmap(_mask);
        maskBmp.blendMode = BlendMode.ERASE;
        foodBmp.x = maskBmp.x = -foodBmp.width / 2;
        foodBmp.y = maskBmp.y = -foodBmp.height / 2;
    }
    public function cut():Bool {
        quantity--;
        var per:Float = quantity / _max * 0.4 + 0.4;
        _mask.fillRect(_mask.rect, 0xFF888888);
        //_mask.threshold(_noise, _noise.rect, new Point(), "<", per * 255, 0x00000000, 255, false);
        return quantity == 0;
    }
    public function remove() {
        _mask.dispose();
        _noise.dispose();
        if (sprite.parent != null) sprite.parent.removeChild(sprite);
    }
}
class Obstacle {
    public var center:Point;
    public var radius:Float;
    public function new(x:Float = 0, y:Float = 0, radius:Float = 50) {
        center = new Point(x, y);
        this.radius = radius;
    }
}
class Ant {
    public var body:Sprite;
    public var position:Point;
    public var thinkTime:Int;
    private var _locus:Array<Point>;    
    private var _radian:Float;
    private var _speed:Float;
    private var _status:Int;
    private var _freeTime:Int;
    private var _view:Float;
    private var _wanderCnt:Int;
    private var _food:Sprite;
    private var _randomRad:Float;
    private var _startReturn:Bool;
    private var _searchCnt:Int;
    private var _targetFood:Food;
    public function new(x:Float = 0, y:Float = 0) {
        thinkTime = 0;
        _radian = 0;    
        _speed = 2;    
        _status = 0;    
        _freeTime = 0;    
        _view = 20;    
        _wanderCnt = 1;
        _startReturn = false;
        _searchCnt = -1;
        _targetFood = null;

        body = new Sprite();
        body.graphics.beginFill(0x000000, 1);
        body.graphics.drawRect(-4, -1, 4, 2);
        body.graphics.drawRect(1, -1, 1, 2);
        body.graphics.drawRect(3, -1, 2, 2);
        body.graphics.endFill();
        body.visible = false;
        _food = new Sprite();
        body.addChild(_food);
        _food.graphics.beginFill(0xFFFFFF, 1);
        _food.graphics.drawRect(-2, -2, 4, 4);
        _food.graphics.endFill();
        _food.x = 6;
        _food.visible = false;
        _food.name = "food";
        position = new Point(x, y);
        _locus = new Array<Point>();
        _radian = Math.random() * Angle.ALL_RADIAN;
        _randomRad = (Math.random() * 10 - 5) * Angle.TO_RADIAN;
    }
    public function action(w:World) {
        if (thinkTime != 0) {
            if (--thinkTime == 0) {
                if (_status == 0) startSearch();
                if (_startReturn) {
                    _startReturn = false;
                    toFace(w.home.position);
                }
            }
            return;
        } else {
            randomThink(0.015, Math.round(Math.random() * 10 + 15));
        }
        if (_status == 0) {
            _searchCnt = ++_searchCnt % 3;
            if (_searchCnt == 0) {
                var near:Float = Math.POSITIVE_INFINITY;
                _targetFood = null;
                for (f in w.foods) {
                    var distance:Float = position.subtract(f.position).length;
                    if (distance <= f.size/2 + 1) {
                        thinkTime = Math.round(Math.random() * 50) + 30;
                        getFood(f.image.getRandomColor());
                        w.cutFood(f);
                        return;
                    }
                    var d:Float = distance - f.size/2;
                    if (d <= _view && d < near) {
                        near = d;
                        _targetFood = f;
                    }
                }
            }
            if (_targetFood != null) {
                toFace(_targetFood.position);
            } else {
                if (_freeTime > 0) _freeTime--;
                var rad:Float = (_freeTime > 0)? Math.NaN : w.pheromone.getGuidepost(Math.round(position.x), Math.round(position.y));
                if (Math.isNaN(rad)) {
                    wander();
                } else {
                    _radian = Angle.between(rad, _radian, 0.5) + Angle.TO_RADIAN + _randomRad;
                    checkStay();
                }
            }
        }
        
        if (_status == 1) {
            var per:Float = _radian / Angle.ALL_RADIAN;
            w.pheromone.putPheromone(Math.round(position.x), Math.round(position.y), per);
            goto(w.home.position);
            if (w.home.position.subtract(position).length < 5) backHome();
        }
        
        position.x += Math.cos(_radian) * _speed;
        position.y += Math.sin(_radian) * _speed;
        
        adjustPosition(w);
        
        body.x = position.x;
        body.y = position.y;
        body.rotation = _radian * Angle.TO_ROTATION;
    }
    private function wander() {
        _wanderCnt = ++_wanderCnt % 4;
        if (_wanderCnt == 0) _radian += (Math.random() * 60 - 30) * Angle.TO_RADIAN;
    }
    private function toFace(target:Point) {
        _radian = Math.atan2(target.y - position.y, target.x - position.x);
    }
    private function goto(target:Point) {
        _wanderCnt = ++_wanderCnt % 4;
        if (_wanderCnt == 0) {
            var minus:Point = target.subtract(position);
            var rad:Float = Math.atan2(minus.y, minus.x);
            var per:Float = minus.length / 100;
            if (per > 1) per = 1;
            _radian = Angle.between(rad, _radian, 0.75 * per) + (Math.random() * 30 - 15) * Angle.TO_RADIAN;
        }
    }
    private function checkStay() {
        _locus.unshift(position.clone());
        //_locus.length = 4;
        if (_locus[3] != null && _locus[0].subtract(_locus[3]).length <= _speed * 2) _freeTime = 60;
    }
    private function adjustPosition(w:World) {
        var adjustRad1:Float = Math.NaN;
        var plus:Point = new Point(Math.cos(_radian) * _speed, Math.sin(_radian) * _speed);
        var nextPos:Point = position.add(plus);
        for (obs in w.obstacles) {
            var distance:Float = Point.distance(nextPos, obs.center);
            if (distance < obs.radius) {
                var radius:Point = nextPos.subtract(obs.center);
                if (radius.length < obs.radius) {
                    radius.normalize(obs.radius);
                    var fixPos:Point = obs.center.add(radius);
                    adjustRad1 = Math.atan2(fixPos.y - position.y, fixPos.x - position.x);
                }
                break;
            }
        }
        if(!Math.isNaN(adjustRad1)) _radian = Angle.between(adjustRad1, _radian, 0.85);
        
        var rect:Rectangle = w.area;
        var adjustRad2:Float = Math.NaN;
        var padding:Int = 5;
        if (position.x < rect.left + padding) {
            position.x = rect.left + padding;
            adjustRad2 = 0;
        }
        if (position.x > rect.right - padding) {
            position.x = rect.right - padding;
            adjustRad2 = Math.PI;
        }
        if (position.y > rect.bottom - padding) {
            position.y = rect.bottom - padding;
            adjustRad2 = Math.PI * 1.5;
        }
        if (position.y < rect.top + padding) {
            position.y = rect.top + padding;
            adjustRad2 = Math.PI * 0.5;
        }
        if (!Math.isNaN(adjustRad2)) _radian = Angle.between(adjustRad2, _radian, 0.9);
    }
    private function randomThink(per:Float, time:Int) {
        if (Math.random() <= per) thinkTime = time;
    }
    private function startSearch() {
        body.visible = true;
        _status = 0;
    }
    private function backHome() {
        _status = 0;
        _food.visible = false;
        body.visible = false;
        thinkTime = Math.round(Math.random() * 100) + 100;
    }
    private function getFood(color:Int = 0xFFFFFF) {
        _status = 1;
        _startReturn = true;
        _food.visible = true;
        var ct:ColorTransform = new ColorTransform();
        ct.color = color;
        _food.transform.colorTransform = ct;
    }
    public function remove() {
        _targetFood = null;
        if (body.parent != null) body.parent.removeChild(body);
    }
}

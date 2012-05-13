package {
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.ByteArray;
	
	import org.libspark.flartoolkit.core.FLARCode;
	import org.libspark.flartoolkit.core.param.FLARParam;
	import org.libspark.flartoolkit.core.raster.rgb.FLARRgbRaster_BitmapData;
	import org.libspark.flartoolkit.core.transmat.FLARTransMatResult;
	import org.libspark.flartoolkit.detector.FLARSingleMarkerDetector;
	import org.libspark.flartoolkit.support.pv3d.FLARBaseNode;
	import org.libspark.flartoolkit.support.pv3d.FLARCamera3D;
	import org.papervision3d.materials.MovieMaterial;
	import org.papervision3d.objects.primitives.*;
	import org.papervision3d.render.BasicRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.Viewport3D;
	import org.papervision3d.materials.*;
	import org.papervision3d.materials.MovieMaterial;
	import org.papervision3d.events.InteractiveScene3DEvent;
	
	import caurina.transitions.Tweener;
	
	[SWF(width="640", height="480", frameRate="30", backgroundColor="#FFFFFF")]

	public class BizcardAnim extends Sprite
	{
		[Embed(source="marker1.pat", mimeType="application/octet-stream")]
		private var pattern:Class;
		
		[Embed(source="camera_para.dat", mimeType="application/octet-stream")]
		private var params:Class;
		
		private var fparams:FLARParam;
		private var mpattern:FLARCode;
		private var vid:Video;
		private var cam:Camera;
		private var bmd:BitmapData;
		private var raster:FLARRgbRaster_BitmapData;
		private var detector:FLARSingleMarkerDetector;
		private var scene:Scene3D;
		private var camera:FLARCamera3D;
		private var container:FLARBaseNode;
		private var vp:Viewport3D;
		private var bre:BasicRenderEngine;
		private var trans:FLARTransMatResult;
		
		//my code
		private var plane:Plane;
		private var sphere:Sphere;
		private var vc:VideoComponent;
		private var mat:MovieMaterial;
		
		public function BizcardAnim()
		{
			setupFLAR();
			setupCamera();
			setupBitmap();
			setupPV3D();
			addEventListener(Event.ENTER_FRAME, loop);
		}
		
		private function setupFLAR():void
		{
			fparams = new FLARParam();
			fparams.loadARParam(new params() as ByteArray);
			mpattern = new FLARCode(16, 16);
			mpattern.loadARPatt(new pattern());
		}	
		
		private function setupCamera():void
		{
			vid = new Video(320, 240);
			cam = Camera.getCamera();
			cam.setMode(320, 240, 60);
			vid.attachCamera(cam);
			addChild(vid);
		}	
		
		private function setupBitmap():void
		{
			bmd = new BitmapData(640, 480);
			bmd.draw(vid);
			raster = new FLARRgbRaster_BitmapData(bmd);
			detector = new FLARSingleMarkerDetector(fparams, mpattern, 80);
		}	
		
		private function setupPV3D():void
		{
			scene = new Scene3D();
			camera = new FLARCamera3D(fparams);
			container = new FLARBaseNode();
			scene.addChild(container);
			
			/* var pl:PointLight3D = new PointLight3D();
			pl.x = 1000;
			pl.y = 1000;
			pl.z = -1000; */
			
			//var ml:MaterialsList = new MaterialsList({all: new FlatShadeMaterial(pl)});
			
			/*var cube1:Cube = new Cube(ml, 30, 30, 30);
			var cube2:Cube = new Cube(ml, 30, 30, 30);
			cube2.z = 50;
			var cube3:Cube = new Cube(ml, 30, 30, 30);
			cube3.z = 100;
			
			container.addChild(cube1);
			container.addChild(cube2);
			container.addChild(cube3); */
			
			//---------------------my code-----------------------------------------
			
			//BitmapFileMaterial
			/*var bmf:BitmapFileMaterial = new BitmapFileMaterial("baltslim_logo.jpg");
			bmf.doubleSided = true;
			plane = new Plane(bmf, 50, 50, 24, 16);
			plane.localRotationZ = 90;
			//var plane2:Plane = new Plane(bmf, 50, 50);
			//plane2.z = -500;
			//plane2.y = 100;
			container.addChild(plane);*/
			//container.addChild(plane2);	
			
			//MovieMaterial
			vc = new VideoComponent();
			mat = new MovieMaterial(vc, true, true);
			mat.doubleSided = true
			mat.interactive = true;
			mat.smooth = true;
			
			plane = new Plane(mat, 150, 115, 10, 10);
			plane.localRotationZ = 90;
			//plane.localRotationZ += 90;
			//sphere = new Sphere( mat, 50, 20, 20 );
			container.addChild(plane);
			
			vc.blueSphere.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler, false, 0, true);
			plane.addEventListener(InteractiveScene3DEvent.OBJECT_CLICK, objectClickHandler);


			/* var videoMat:Sprite = new Sprite();
			videoMat.width = 320;
			videoMat.height = 240;			 
			
			var laservid:Video = new Video();
			laservid.attachCamera(Camera.getCamera());
			var conn:NetConnection = new NetConnection();
			conn.connect(null);
			
			var stream:NetStream = new NetStream(conn);
			//laservid.attachNetStream(stream);
			//stream.play("bendable_lasers.flv"); 
			
					
			//addChild(videoMat);	
			
			var material:VideoStreamMaterial = new VideoStreamMaterial(laservid, stream, true, true);
			//material.doubleSided = true;
			material.animated = true;
						
			plane = new Plane(material);
			container.addChild(plane); */
				
			//---------------------------------------------------------------------//
			/* var video:Video = new Video();
			var conn:NetConnection = new NetConnection();
			conn.connect(null)
			var stream:NetStream = new NetStream(conn);
			video.attachNetStream(stream);
			stream.play("bendable_lasers.flv");
			
			var material:VideoStreamMaterial = new VideoStreamMaterial(video, stream);
			material.animated = true;
			
			plane = new Plane(material, 100, 100)
			container.addChild(plane); */
			//---------------------------------------------------------------------
			
			bre = new BasicRenderEngine();
			trans = new FLARTransMatResult();
			
			vp = new Viewport3D();
			addChild(vp);
		}	
		
		private function objectClickHandler(e:InteractiveScene3DEvent):void
		{
			trace(e.currentTarget.name);
		}
		
		private function mouseOverHandler(e:MouseEvent):void
		{
			Tweener.addTween(vc.blueSphere, { x: Math.random() * (400 - 200), y: Math.random()* (1000 - 300), transition:"EaseInOutBounce", time: 1})
		}
			
		
		private function loop(e:Event):void
		{
			bmd.draw(vid);
			//plane.pitch(70);
			
						
			try
			{
				if(detector.detectMarkerLite(raster, 80) && detector.getConfidence() > 0.5)
				{
					detector.getTransformMatrix(trans);
					container.setTransformMatrix(trans);
					bre.renderScene(scene, camera, vp);
				}
			}
			catch(e:Error)
			{
				//bmd.dispose();
			}
		}
	}
}

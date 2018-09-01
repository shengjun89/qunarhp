CarouselComponent = require "carouselcomponent/CarouselComponent"
n = Screen.width/750	
Screen.backgroundColor = "#FFF"


homeScroll = new ScrollComponent
	size: Screen.size
	scrollHorizontal: false
homeScroll.contentInset =
	bottom: 112*n


# 为模块标题添加箭头 手机演示有报错
# Layer.prototype.addArrow = ()->
# 	arrow = new Layer
# 		parent: this
# 		x: this.width
# 		y: Align.center
# 		width: 36*n
# 		height: 36*n
# 		background:null
# 		image: "images/arrow.svg"
		
# Layer.prototype.pullDown = ()->
# 	arrow = new Layer
# 		parent: this
# 		x: this.width
# 		y: Align.center
# 		width: 28*n
# 		height: 28*n
# 		background:null
# 		image: "images/pulldown.svg"		

# 搜索框/加载交互

top = new Layer
	width: Screen.width
	height:180*n
# 	image: "images/top.png"
	z: 3
	backgroundColor: "#FFF"

localName = new TextLayer
	parent: top
	x: 32*n
	y: 80*n
	text: "云南"
	fontSize: 32*n
	fontFamily: "PingFang SC"
	fontWeight: 500
	textAlign: "left"
	color: "rgba(47,47,47,1)"

msgIcon = new Layer
	x: Align.right(-32*n)
	y: 76*n
	parent: top
	width: 48*n
	height: 48*n	
	image: "images/msgIcon.svg"	
	
localNameArrow = new Layer
	parent: localName
	x: localName.width+8*n
	y: Align.center
	width: 28*n
	height: 24*n
	image: "images/pulldown.svg"

#判断是否iPhoneX，预留底部空间
		
if Screen.height>=812	
	bottom = new Layer
		width: Screen.width
		height:166*n
		y: Align.bottom(0)
		image: "images/bottom.png"
		shadowY: -4
		shadowColor: "rgba(0,0,0,0.03057065217391304)"
		shadowBlur: 8
		z: 3
else
	bottom = new Layer
		width: Screen.width
		height:166*n
		y: Align.bottom(64*n)
		image: "images/bottom.png"
		shadowY: -4
		shadowColor: "rgba(0,0,0,0.03057065217391304)"
		shadowBlur: 8
		z: 3		

input = new Layer
	width: Screen.width-64*n
	x: Align.center
	height: 76*n
	backgroundColor: "#ECECEC"
	opacity: 0.8
	y: 172*n
	z: 4
	originX: 0.5
	originY: 1
	backgroundBlur: 12

holdplace = new Layer
	parent: input
	x: 40*n
	y: Align.center
	width: 240*n
	height: 28*n
	backgroundColor: null
	image: "images/holdplace.png"
	
	
# 下拉加载
frameStep = 38
frameWidth = 260
frameRate = 2.2

# topGdt = new Layer
# 	width: Screen.width
# 	height: 360*n
# 	image: "images/gradiantbg.png"
# 	background:null
# 	z: 2
# 	opacity: 0
	
view = new Layer
	width: 260*n
	height: 180*n
	x: Align.center
	y: 280*n
	backgroundColor: null
	clip: true
	opacity: 0
	scale: 0.8
	
loadcontent = new Layer
	parent: view
	x: 0
	width: 9880*n
	height: 180*n
	image: "images/startsprite.png"
	
	
# 新建函数控制播放到多少帧，	将帧数作为传递对象
pullAnimate = (s) ->
	loadcontent.states =
		on:
			x:-frameWidth*n*s		
	loadcontent.animate "on",time:0	

loadtxt = new TextLayer
	text: "下拉加载"
	fontSize: 24*n
	x: Align.center
	y: view.y+view.height-24*n
	opacity: 0
	
loadtxt.placeBehind(homeScroll)
view.placeBehind(homeScroll)


sound = new Audio("sounds/pop03.wav")			
	
homeScroll.on Events.Move, ->
	scrolltoY(homeScroll.scrollY)

if Screen.height<812
	scrolltoY = (y) ->
# 		print y
		top.y = Utils.modulate(y,[94*n,110*n],[0,-16*n],true)
		top.height = Utils.modulate(y,[110*n,140*n],[180*n,150*n],true)
		input.y = Utils.modulate(y,[10*n,110*n],[172*n,56*n],true)
# 		localName.y = Utils.modulate(y,[20*n,74*n],[80*n,106*n],true)
# 		msgIcon.y = Utils.modulate(y,[20*n,74*n],[76*n,102*n],true)
		input.height = Utils.modulate(y,[74*n,94*n],[76*n,60*n],true)
		holdplace.y  = Utils.modulate(y,[109*n,110*n],[Align.center,16*n],true)
		input.width = Utils.modulate(y,[0*n,30*n],[Screen.width-64*n,Screen.width-280*n],true)
		input.x = Utils.modulate(y,[0,30*n],[32*n,166*n],true)
		
		#下拉加载
		loadtxt.opacity = Utils.modulate(y, [-80*n, -120*n], [0,1], true)
		view.y = Utils.modulate(y, [0, -80*n], [280*n,230*n], true)
		view.opacity = Utils.modulate(y, [0, -20*n], [0,1], true)
		loadtxt.y = Utils.modulate(y, [0, -80*n], [view.y+view.height-24*n,view.y+view.height-32*n], true)
		s = Math.round(homeScroll.content.y/frameRate)
	# 	print scroll.content.y
		
		beyondNum = frameStep*frameRate
		loadtxt.text = "下拉加载"
		
		
		if s < 0
			s = 0
			loadcontent.image = "images/startsprite.png"
		
		if s == 28
			sound.play()
			
		if s >= frameStep-1
	# 		print s
			loadtxt.text = "加载中..."
			loadcontent.image = "images/sprite.gif"
	# 		scroll.content.onDragEnd (event, layer) ->
	# 			sound.play()
			s = frameStep-1
		else
			loadcontent.image = "images/startsprite.png"
		
		pullAnimate(s)	
		
else
	scrolltoY = (y) ->
		top.y = Utils.modulate(y,[94*n,110*n],[0,0],true)
		input.y = Utils.modulate(y,[20*n,60*n],[172*n,96*n],true)
		localName.y = Utils.modulate(y,[20*n,74*n],[80*n,106*n],true)
		msgIcon.y = Utils.modulate(y,[20*n,74*n],[76*n,102*n],true)
		input.height = Utils.modulate(y,[74*n,94*n],[76*n,60*n],true)
		holdplace.y  = Utils.modulate(y,[109*n,110*n],[Align.center,16*n],true)
		input.width = Utils.modulate(y,[0*n,20*n],[Screen.width-64*n,Screen.width-280*n],true)
		input.x = Utils.modulate(y,[0,20*n],[32*n,166*n],true)
		
		#下拉加载
		loadtxt.opacity = Utils.modulate(y, [-80*n, -120*n], [0,1], true)
		view.y = Utils.modulate(y, [0, -80*n], [280*n,230*n], true)
		view.opacity = Utils.modulate(y, [0, -20*n], [0,1], true)
		loadtxt.y = Utils.modulate(y, [0, -80*n], [view.y+view.height-24*n,view.y+view.height-32*n], true)
		s = Math.round(homeScroll.content.y/frameRate)
	# 	print scroll.content.y
		
		beyondNum = frameStep*frameRate
		loadtxt.text = "下拉加载"
		
		
		if s < 0
			s = 0
			loadcontent.image = "images/startsprite.png"
		
		if s == 28
			sound.play()
			
		if s >= frameStep-1
	# 		print s
			loadtxt.text = "加载中..."
			loadcontent.image = "images/sprite.gif"
	# 		scroll.content.onDragEnd (event, layer) ->
	# 			sound.play()
			s = frameStep-1
		else
			loadcontent.image = "images/startsprite.png"
		
		pullAnimate(s)	

# 状态栏底部阴影
# 	if y>= 80*n
# 		top.shadowY = 1
# 		top.shadowColor = "rgba(0,0,0,0.12)"
# 	else
# 		top.shadowY = 0

# inputScroll = input.copy()
# inputScroll.z = 3
# inputScroll.y = 62*n
# inputScroll.opacity = 0
# inputScroll.width = Screen.width/2-20*n
# inputScroll.height = 56*n
# inputScroll.x = Align.center
# holdplaceScroll = holdplace.copy()
# holdplaceScroll.parent = inputScroll
# holdplaceScroll.y = Align.center(2*n)

# 头部banner位
banner = new PageComponent
	parent: homeScroll.content
	width: Screen.width-64*n
	x: Align.center
	y: input.y+96*n
	height: 246*n
	z: 2
	shadowY:2
	shadowColor:"rgba(0,0,0,0.12)"
	shadowBlur: 12
bannerpicArr = ["images/banner01.png","images/banner02.png","images/banner03.png"]
banner.content.draggable.vertical = false

for number in [0...bannerpicArr.length]
	bannerContent = new Layer
		parent: banner.content
		width: banner.width
		height: banner.height
		x: banner.width*number
		image: bannerpicArr[number]
		
#指示器
allIndicators = []
for number in [0...bannerpicArr.length]
	indicator = new Layer
		parent:homeScroll.content
		backgroundColor: "#949494"
		width:12*n
		height:6*n
		x: (banner.width/36)*number+banner.width/2
		y: banner.y+260*n
		opacity: 0.3
	indicator.states.add(active:{opacity:1})
	indicator.states.animationOptions = time:0.25
	allIndicators.push(indicator)	

allIndicators[0].opacity = 1
# allIndicators[0].scaleX = 1.5		
banner.on "change:currentPage", ->
	current = banner.horizontalPageIndex(banner.currentPage)
	indicator.states.switch("default") for indicator in allIndicators
	allIndicators[current].states.switch("active")			


# 十字交互体验优化
banner.content.on Events.DragMove, ->
	if Math.abs(banner.content.draggable.offset.x)>40*n
# 	if localHotItem.row.content.draggable.offset < 56*n
		homeScroll.content.draggable.enabled = false
	else
		homeScroll.content.draggable.enabled = true	

banner.content.on Events.DragEnd, ->
	homeScroll.content.draggable.enabled = true
		
# 宫格
grid = new Layer
	parent: homeScroll.content
	width: Screen.width-64*n
	x: Align.center
	y: banner.y+300*n
	height: 466*n
	image: "images/gridNav.png"

# 二类入口
cgybar = new Layer
	parent: homeScroll.content
	x: Align.center
	y: grid.y+492*n
	width: Screen.width-64*n
	height: 114*n
	image: "images/cgytxt.png"
	backgroundColor: "rgba(255,255,255,1)"
	borderColor: "rgba(231,233,241,1)"
	borderWidth: 0.5
	shadowColor: "rgba(0,0,0,0.03057065217391304)"
	shadowX: 0
	shadowY: 8
	shadowBlur: 16
	shadowSpread: 0

# 当地玩乐大类	
playbar = new Layer
	parent: homeScroll.content
	width: Screen.width-64*n
	height: 180*n
	y: cgybar.y+144*n
	x: Align.center
	backgroundColor: null

	
playbarArr = ["images/paybar01.png","images/paybar02.png","images/paybar03.png","images/paybar04.png"]

for i in [0..3]
	playNav = new Layer
		parent: playbar
		height: playbar.height
		width: (playbar.width-30*n)/4
		image: playbarArr[i]
		x: (173*n)*i
		borderColor: "rgba(231,233,241,1)"
		borderWidth: 0.5
		shadowColor: "rgba(0,0,0,0.03057065217391304)"
		shadowX: 0
		shadowY: 8
		shadowBlur: 16
		shadowSpread: 0
		
# lowpriceName = new TextLayer


# 找低价
lowpriceName = new TextLayer
	parent: homeScroll.content
	x: Align.left(32*n)
	y: playbar.y+232*n
	text: "找低价"
	fontSize: 36*n
	fontFamily: "PingFang SC"
	fontWeight: 500
	textAlign: "left"
	color: "rgba(63,69,72,1)"

lowpriceImage = new Layer
	parent: lowpriceName
	y: 70*n
	width: Screen.width-64*n
	height: 328*n
	image: "images/lowprice.png"

# 当地热门
localHotItem = new CarouselComponent
	parent: homeScroll.content
	x: 0
	y: lowpriceName.y+lowpriceImage.height+132*n
	backgroundColor:"#FFF"
	title: "当地热门"
	titleFontSize: 36*n
	titleFontWeight: 500
	titleColor: "rgba(63,69,72,1)"
	itemCount: 2
	itemMargin: 10*n
	itemWidth: 510*n
	itemHeight: 576*n
	itemBorderRadius: 0
	imagePrefix: "images/items"
	margins: [72*n, 32*n, 32*n, 32*n]
	titleMargin: 32*n



localHotItem.row.width = 750*n
localHotItem.row.height = 576*n
localHotItem.row.content.children[0].height = 576*n
localHotItem.row.content.children[1].height = 576*n
localHotItem.row.content.children[0].borderColor = "rgba(231,233,241,1)"	
# localHotItem.row.content.children[0].borderWidth = 1*n
localHotItem.row.content.children[0].shadowColor = "rgba(0,0,0,0.03057065217391304)"
localHotItem.row.content.children[0].shadowY = 16*n
localHotItem.row.content.children[0].shadowBlur = 32*n

localHotItem.row.content.children[1].borderColor = "rgba(231,233,241,1)"	
# localHotItem.row.content.children[1].borderWidth = 1*n
localHotItem.row.content.children[1].shadowColor = "rgba(0,0,0,0.03057065217391304)"
localHotItem.row.content.children[1].shadowY = 16*n
localHotItem.row.content.children[1].shadowBlur = 32*n
localHotItem.row.content.children[0].children[1].destroy()
localHotItem.row.content.children[1].children[1].destroy()
# localHotItem.destroy()
# 十字交互体验优化
localHotItem.row.content.on Events.DragMove, ->
	if Math.abs(localHotItem.row.content.draggable.offset.x)>40*n
# 	if localHotItem.row.content.draggable.offset < 56*n
		homeScroll.content.draggable.enabled = false
	else
		homeScroll.content.draggable.enabled = true	
# 
localHotItem.row.content.on Events.DragEnd, ->
	homeScroll.content.draggable.enabled = true

# 热门目的地
hotDest = new TextLayer
	parent: homeScroll.content
	x: Align.left(32*n)
	y: localHotItem.y+localHotItem.height-80*n
	text: "热门目的地"
	fontSize: 36*n
	fontFamily: "PingFang SC"
	fontWeight: 500
	textAlign: "left"
	color: "rgba(63,69,72,1)"
# hotDest.addArrow()
hotDestarrow = new Layer
	parent: hotDest
	x: hotDest.width
	y: Align.center
	width: 36*n
	height: 36*n
	background:null
	image: "images/arrow.svg"

pageCount = 48
gutter = -5*n

# Create PageComponent
pageScroller = new PageComponent
	parent: hotDest
	x: 0
	y: 80*n
	point: Align.center
	width: 222*n
	height: 400*n
	scrollVertical: false
	clip: false

hotdestTxt = new Layer
	parent: homeScroll.content
	width: Screen.width-64*n
	x: 32*n
	y: hotDest.y+424*n
	height: 132*n
	image: "images/hotdesttxt01.png"

hotDestPics = ["images/hotdest01.png","images/hotdest02.png","images/hotdest03.png","images/hotdest01.png","images/hotdest02.png","images/hotdest03.png","images/hotdest01.png","images/hotdest02.png","images/hotdest03.png","images/hotdest01.png","images/hotdest02.png","images/hotdest03.png","images/hotdest01.png","images/hotdest02.png","images/hotdest03.png","images/hotdest01.png","images/hotdest02.png","images/hotdest03.png","images/hotdest01.png","images/hotdest02.png","images/hotdest03.png","images/hotdest01.png","images/hotdest02.png","images/hotdest03.png","images/hotdest01.png","images/hotdest02.png","images/hotdest03.png","images/hotdest01.png","images/hotdest02.png","images/hotdest03.png","images/hotdest01.png","images/hotdest02.png","images/hotdest03.png","images/hotdest01.png","images/hotdest02.png","images/hotdest03.png","images/hotdest01.png","images/hotdest02.png","images/hotdest03.png","images/hotdest01.png","images/hotdest02.png","images/hotdest03.png","images/hotdest01.png","images/hotdest02.png","images/hotdest03.png","images/hotdest01.png","images/hotdest02.png","images/hotdest03.png"]

hotDestTxtArr = ["images/hotdesttxt01.png","images/hotdesttxt02.png","images/hotdesttxt03.png","images/hotdesttxt01.png","images/hotdesttxt02.png","images/hotdesttxt03.png","images/hotdesttxt01.png","images/hotdesttxt02.png","images/hotdesttxt03.png","images/hotdesttxt01.png","images/hotdesttxt02.png","images/hotdesttxt03.png","images/hotdesttxt01.png","images/hotdesttxt02.png","images/hotdesttxt03.png","images/hotdesttxt01.png","images/hotdesttxt02.png","images/hotdesttxt03.png","images/hotdesttxt01.png","images/hotdesttxt02.png","images/hotdesttxt03.png","images/hotdesttxt01.png","images/hotdesttxt02.png","images/hotdesttxt03.png","images/hotdest01.png","images/hotdest02.png","images/hotdest03.png","images/hotdest01.png","images/hotdest02.png","images/hotdest03.png","images/hotdest01.png","images/hotdest02.png","images/hotdest03.png","images/hotdest01.png","images/hotdest02.png","images/hotdest03.png","images/hotdest01.png","images/hotdest02.png","images/hotdest03.png","images/hotdest01.png","images/hotdest02.png","images/hotdest03.png","images/hotdest01.png","images/hotdest02.png","images/hotdest03.png","images/hotdest01.png","images/hotdest02.png","images/hotdest03.png"]		
pages = []
# Loop to create pages
for index in [0...pageCount]
	page = new Layer
		width: pageScroller.width
		height: 294*n
		x: (222*n + gutter) * index+22*n
		backgroundColor: "#00AAFF"
		originX: 0.9
# 		hueRotate: index * 20
		parent: pageScroller.content
		image: hotDestPics[index]
# 		borderColor: "rgba(231,233,241,1)"
		borderWidth: 0.5
		shadowColor: "rgba(0,0,0,0.12)"
		shadowX: 0
		shadowY: 8
		shadowBlur: 8
		shadowSpread: 0

	pages.push(page)
	pages[index].scale = 0.9
	
	page.states =
		on:
			scale : 1.1
			options: 
				curve: "spring(160,30,10)"
		off:	
			scale : 0.9
			options: 
				curve: "spring(160,30,10)"
pages[0].scale = 1.1
pages[0].z = 2
# pages[0].shadowBlur = 32*n
# pages[0].shadowY = 8*n
# pages[0].shadowColor = "rgba(0,0,0,0.2)"
# pages[0].style =
# 	"padding-right": "32px"

# 十字交互体验优化
pageScroller.content.on Events.DragMove, ->
	if Math.abs(pageScroller.content.draggable.offset.x)>40*n
# 	if localHotItem.row.content.draggable.offset < 56*n
		homeScroll.content.draggable.enabled = false
	else
		homeScroll.content.draggable.enabled = true	

pageScroller.content.on Events.DragEnd, ->
	homeScroll.content.draggable.enabled = true
# pageScroller.content.on Events.DragMove, ->
# 	if pageScroller.content.x < -56*n
# 		homeScroll.content.draggable.enabled = false
# 	else
# 		homeScroll.content.draggable.enabled = true	
# # 
# pageScroller.content.on Events.DragEnd, ->
# 	homeScroll.content.draggable.enabled = true


pageScroller.animationOptions =
	curve: Bezier.ease
	time: 0.25
pageScroller.on "change:currentPage", ->
	pageScroller.x = 24*n
	current = pageScroller.currentPage.index
	for index in [0...pageCount]
		pages[index].animate "off"
		pages[index].z = 1
	for index in [0...current]
		pages[index].opacity = 0.2
# 		pages[index].z = 1
	for index in [current...pageCount]
		pages[index].opacity = 1
	pages[current].animate "on"
	pages[current].z = 2
	hotdestTxt.image = hotDestTxtArr[current]

# 全网比价
priceInq = new TextLayer
	parent: homeScroll.content
	x: Align.left(32*n)
	y: hotDest.y+590*n
	text: "找低价"
	fontSize: 36*n
	fontFamily: "PingFang SC"
	fontWeight: 500
	textAlign: "left"
	color: "rgba(63,69,72,1)"
	
priceInqPic = new Layer
	y: 72*n
	x: -32*n
	parent: priceInq
	width: Screen.width
	height: 320*n
	image: "images/priceInqpic.png"	
	
innerPic = new Layer
	parent: homeScroll.content
	width: Screen.width-40*n
	height: 382*n
	x: Align.center
	y: priceInq.y+480*n
	image: "images/innerPic.png"
		
# 主题游
themItme = new CarouselComponent
	parent: homeScroll.content
	x: 0
	y: innerPic.y+420*n
	backgroundColor:"#FFF"
	title: "主题游"
	titleFontSize: 36*n
	titleFontWeight: 500
	titleColor: "rgba(63,69,72,1)"
	itemCount: 6
	itemMargin: 10*n
	itemWidth: 268*n
	itemHeight: 242*n
	itemBorderRadius: 0
	imagePrefix: "images/theme"
	margins: [72*n, 32*n, 32*n, 32*n]
	titleMargin: 32*n
# 	textBlock = "12315"
captions: ["12351","12351","12351","12351","12351","12351"]
subcaptions: ["12351","12351","12351","12351","12351","12351"]

themItme.row.width = 750*n
themItme.row.height = 242*n
for i in [0...themItme.row.content.children.length]
# # 	print 1
	themItme.row.content.children[i].height = 242*n

# 十字交互体验优化
themItme.row.content.on Events.DragMove, ->
	if Math.abs(themItme.row.content.draggable.offset.x)>40*n
# 	if themItme.row.content.draggable.offset < 56*n
		homeScroll.content.draggable.enabled = false
	else
		homeScroll.content.draggable.enabled = true	
# 
themItme.row.content.on Events.DragEnd, ->
	homeScroll.content.draggable.enabled = true

# 猜你喜欢
guessPicNum = 8


	
guessName = new TextLayer
	parent: homeScroll.content
	x: Align.left(32*n)
	y: themItme.y+360*n
	height: (guessPicNum+2)*226*n
	text: "猜你喜欢"
	fontSize: 36*n
	fontFamily: "PingFang SC"
	fontWeight: 500
	textAlign: "left"
	color: "rgba(63,69,72,1)"

guessPicArr = ["images/guess01.png","images/guess02.png","images/guess03.png","images/guess01.png","images/guess02.png","images/guess03.png","images/guess01.png","images/guess02.png","images/guess03.png",]	
for i in [0..guessPicNum]
	guessPic = new Layer
		parent: guessName
		width: Screen.width-64*n
		height: 226*n
		y: 72*n+226*n*i
		image: guessPicArr[i]
		
# bottom.onClick (event, layer) ->
# 	homeScroll.scrollToLayer(themItme,0,-0.23,)
--ステータスバーを非表示に設定
display.setStatusBar( display.HiddenStatusBar )

--scroll.luaファイルの読み込み（scroll.lua内のfunctionが利用可能となります）
local scroll = require("scroll")

--効果音を読み込み、SE_coinに代入。（音声のため、オブジェクトとは扱いが異なります）
local SE_coin = audio.loadSound( "Coin.mp3" )

local _W = display.contentWidth
local _H = display.contentHeight

--変数の宣言
local m = 0
local s = 0

--背景画像オブジェクトを宣言
local Back
-------------------------------------------------------------------
--端末のピクセル高さが９６０を越えていたら、次の処理
if(display.pixelHeight > 960)then
	--背景画像オブジェクト
	Back = scroll.newBackGround( {"LoopBack568"}, {dir = "right", speed = 2} )
--それ以外の端末の場合は、次の処理
else
	--背景画像オブジェクト
	Back = scroll.newBackGround( {"LoopBack"}, {dir = "right", speed = 2} )
end

--背景画像の表示
Back:show()
-------------------------------------------------------------------
-------------------------------------------------------------------
--右ボタン
local Right = display.newImage("Button_R.png", 100, _H -30)

--左ボタン
local Left = display.newImage("Button_L.png", 40, _H -30)

--ジャンプボタン
local Jump = display.newImage("Button_J.png", _W -40, _H -30)

--キャラクター
local myBall = display.newImage("ball.png", 30, _H *7/10 +18)

--コイン
local coin =  display.newImage("coin.png", _W+100, _H/2)
-------------------------------------------------------------------
--スプライトシートを指定
--local sheet = graphics.newImageSheet("PointAnim.png", { width = 100, height = 100, numFrames = 4})
local opt = { frames = require("PointAnim").options.frames, }
local sheet = graphics.newImageSheet("PointAnim.png", opt)
--アニメーションを作成
local instance = display.newSprite( sheet, { name = 'PointAnim', start = 1, count = 4, time = 400, loopCount = 1})
--座標を設定
instance.x = coin.x; instance.y = _H/2 -50
--アニメーションを非表示にする
instance.isVisible = false
-------------------------------------------------------------------
-------------------------------------------------------------------
--背景をスクロールするfunction
local function moveBack()
	m = m +1
	if(m == 1)then
		--背景画像のスクロール開始を呼び出す
		Back:start()
		s = 0
	end
end

--背景スクロールを停止するfunction
local function stopBack()
	s = s +1
	if(s == 1)then
		--背景画像のスクロール停止を呼び出す
		Back:stop()
		m = 0
	end
end
-------------------------------------------------------------------
-------------------------------------------------------------------
--画面の再描画ごとにキャラクターが右に動くfunction
local function moveRight()
	--キャラクターのx座標が画面の中央より左のとき
	if(myBall.x < _W/2)then
		--キャラクターのx座標を５足す
		myBall.x = myBall.x + 5
	end
	
	--キャラクターの位置が画面の３分の１より右のとき
	if(myBall.x > _W/3)then
		--背景をスクロールするfunctionを呼び出す
		moveBack()
		
		--コインのx座標を５引く
		coin.x = coin.x - 5
		--instance.x = coin.x
	end
end

--右ボタンを押した時のfunction
local function onRight( event )
	local target = event.target
	local phase = event.phase

	if ( phase == "began" ) then
		display.getCurrentStage():setFocus( target )
		target.isFocus = true

		--画面の再描画ごとにmoveRightを呼び出す
		Runtime:addEventListener("enterFrame", moveRight)
	elseif ( target.isFocus ) then

		if ( phase == "ended" or phase == "cancelled" ) then
			--画面の再描画ごとにmoveRightを呼び出すのを停止する
			Runtime:removeEventListener("enterFrame", moveRight)
			display.getCurrentStage():setFocus(nil)
			target.isFocus = false
			
			--キャラクターの位置が画面の３分の１より右のとき
			if(myBall.x > _W/3)then
				--背景スクロールを停止するfunctionを呼び出す
				stopBack()
			end
		end
	end

	return true
end

--右ボタンにタッチイベントのfunctionを設定
Right:addEventListener( "touch", onRight )
-------------------------------------------------------------------
-------------------------------------------------------------------
--画面の再描画ごとにキャラクターが左に動くfunction
local function moveLeft()
	--キャラクターのx座標が30以上のとき
	if(myBall.x >= 30)then
		--キャラクターのx座標を５引く
		myBall.x = myBall.x - 5
		
		--キャラクターの位置が画面の4分の１より右、かつ３分の１より左のとき
		if((myBall.x > _W/4) and (myBall.x < _W/3))then
			--背景スクロールを停止するfunctionを呼び出す
			stopBack()
		end
	end
end

--左ボタンを押した時のfunction
local function onLeft( event )
	local target = event.target 
	local phase = event.phase

	if ( phase == "began" ) then
		display.getCurrentStage():setFocus( target )
		target.isFocus = true

		--画面の再描画ごとにmoveLeftを呼び出す
		Runtime:addEventListener("enterFrame", moveLeft)
	elseif ( target.isFocus ) then

		if ( phase == "ended" or phase == "cancelled" ) then
			--画面の再描画ごとにmoveLeftを呼び出すのを停止する
			Runtime:removeEventListener("enterFrame", moveLeft)
			
			display.getCurrentStage():setFocus(nil)
			target.isFocus = false
			
		end
	end

	return true
end

--左ボタンにタッチイベントのfunctionを設定
Left:addEventListener( "touch", onLeft )
-------------------------------------------------------------------
-------------------------------------------------------------------
--ジャンプボタンを押した時のfunction
local function onJump( event )
	if(event.phase == "began")then
		--指定した座標から、指定した時間をかけて移動
		transition.from(myBall, {time = 100, y = _H/2 })--, alpha = 0})
		--指定した座標へ、指定した時間をかけて移動
		transition.to(myBall, {time = 100, y = _H *7/10 +18 })--, alpha = 1})
		
		--onJump内でのみ有効な変数を宣言
		local l,h,length_W,length_H
		
		--コインとキャラクターの座標を比較し
		l = coin.x - myBall.x
		--座標の差の絶対値をとる
		length_W = math.abs( l )
		
		--座標の差が30未満のとき
		if(length_W < 30)then
			--効果音を鳴らす
			audio.play( SE_coin )
			
			--アニメーションの座標
			instance.x = coin.x
			--アニメーションを表示
			instance.isVisible = true
			--アニメーションを再生
			instance:play()
			
			--コインを獲得すると画面の外に消える
			coin.x = _W+100
		end
	end
end

--ジャンプボタンにタッチイベントのfunctionを設定
Jump:addEventListener( "touch", onJump )

-------------------------------------------------------------------
-------------------------------------------------------------------

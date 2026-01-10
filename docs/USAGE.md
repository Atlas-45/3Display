# 起動・使い方ガイド

## 起動

1. ワークスペースを開く
   - `open ThreeDisplay.xcworkspace`
2. Xcode で `ThreeDisplay` スキームを選択して Run
   - CLI ビルドのみ行う場合: `xcodebuild -workspace ThreeDisplay.xcworkspace -scheme ThreeDisplay build`

## 使い方

- 起動すると、透明オーバーレイ上に 3D コンテンツが表示されます。
- 初期状態は入力パススルーで、キーボード/マウス操作は他のアプリに通ります。
- 操作したい場合はメニュー `Overlay > Enable Interaction`（Option+Command+I）で切り替えます。
- 左上のコントロールパネルで以下を操作できます（操作モード時）。
  - **Load USDZ**: 表示したい USDZ / USD / USDC ファイルを選択します。
  - **Use Box**: 内蔵のボックスモデルに戻します。
  - **Auto rotate**: モデルの基本回転アニメーションを ON/OFF します。
  - **Direction**: 飛び出し方向（角度）を調整します。
  - **Strength**: 飛び出し量を調整します。
- 右上の **Hide UI / Show UI** でコントロール表示を切り替えできます。

## 補足

- サンドボックスのため、USDZ ファイルはダイアログから毎回選択してください。
- 終了は通常どおり `⌘Q` で行えます。

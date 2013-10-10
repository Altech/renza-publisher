2on2アーケードゲーム「機動戦士ガンダムSEED DESTINY 連合 VS. Z.A.F.T.II」の対戦動画データを自動で分割〜アップロード、プレイリストの作成まで行なうツール。

１ゲームごとへの分割はサンプル画像を与えてやることで行なう。

Youtube Data API を利用するための client_secrets.json を直下に置いておく。内容は[Client Secrets - Google APIs Client Library for Python — Google Developers](https://developers.google.com/api-client-library/python/guide/aaa_client_secrets)などを参照。

また、動画の処理にはffmpeg、画像の判定などにはImageMagickを使用しているので、それらをインストールする必要がある。

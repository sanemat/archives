---
pagetitle: gemspecとGemfileの役割をはっきりさせておく
css:
  - github-markdown.css
  - page.css
  - http://fonts.googleapis.com/css?family=Lato
canonical: http://sanemat.github.io/archives/langturn.com-translations-33/
lang: ja
description: gemspecとGemfileの役割をはっきりさせておく
ogimage: http://sanemat.github.io/archives/langturn.com-translations-33/NO_IMAGE_YET.png
---
<script type="text/javascript">
  window.analytics=window.analytics||[],window.analytics.methods=["identify","group","track","page","pageview","alias","ready","on","once","off","trackLink","trackForm","trackClick","trackSubmit"],window.analytics.factory=function(t){return function(){var a=Array.prototype.slice.call(arguments);return a.unshift(t),window.analytics.push(a),window.analytics}};for(var i=0;i<window.analytics.methods.length;i++){var key=window.analytics.methods[i];window.analytics[key]=window.analytics.factory(key)}window.analytics.load=function(t){if(!document.getElementById("analytics-js")){var a=document.createElement("script");a.type="text/javascript",a.id="analytics-js",a.async=!0,a.src=("https:"===document.location.protocol?"https://":"http://")+"cdn.segment.io/analytics.js/v1/"+t+"/analytics.min.js";var n=document.getElementsByTagName("script")[0];n.parentNode.insertBefore(a,n)}},window.analytics.SNIPPET_VERSION="2.0.9",
  window.analytics.load("FvpAD3BCTG");
  window.analytics.page();
</script>

# gemspecとGemfileの役割をはっきりさせておく

- Original:
    - URL: [Clarifying the Roles of the .gemspec and Gemfile](http://yehudakatz.com/2010/12/16/clarifying-the-roles-of-the-gemspec-and-gemfile/)
    - Date: Thursday, December 16th, 2010 at 9:41 pm
- Translation:
    - URL: [gemspecとGemfileの役割をはっきりさせておく](http://langturn.com/translations/33?locale=ja) (Not Found)
    - Salvage from [Internet Archive](https://web.archive.org/web/20130402161316/http://langturn.com/translations/33?locale=ja)

## 要約

~~Gemfile~~Gemfile.lock(修正)は依存関係を厳密に指定するのが目的なので、アプリケーションを開発するときはレポジトリにチェックインすべき。
一方Gemを開発するときは依存関係を緩やかに定義し柔軟性を持たせることが重要なポイントなので、~~Gemfile~~Gemfile.lock(修正)はレポジトリにチェックインしてはいけない。
他、Gemfileとgemspecをうまく組み合わせて使う方法など。

## 短い方の説明

アプリケーションもgemも「依存関係」という同じような概念を持っているように思えるかも知れませんが、この言葉はそれぞれにとって重要な違いがあります。
Gemは他のgemとそのバージョンに依存しますが、それらがどこから来るのかは気にしません。
一方アプリケーションは厳密にデプロイメントを調整する必要があります。

__Gemを開発するときは__、Gemfileには[gemspec](http://gembundler.com/rubygems.html)を使って重複を回避しましょう。
普通、GemfileにはRubygemsのソースとgemspecの一行だけが書かれるべきです。
__Gemfile.lockはバージョン管理にチェックインしてはいけません__。
Gemコマンドで扱われないような精密さを要求してしまうからです。
精密さが満たされるとしても、利用者側からすると依存関係のバージョンがズレていると使えないことになってしまって不便です。

__アプリケーションを開発するときは、Gemfile.lockはチェックインすべきです__。
Bundlerによってどの環境でも同じソースの同じGemが使えるのは大変ありがたいからです。

以前この件について記事を書いて以来、bundlerで使われるGemfileとRubygemsで使われる.gemspecの役割の違いについて色々と質問を受けてきました。
多くの人はこの二つの役目が重複していると感じて、重複を解決するためにまた別のツールを導入したりしてしまっているようです。

## Rubyのライブラリ

Rubyのライブラリはgemという形式にまとめてrubygems.orgにて配布されるのが一般的です。
gemには以下のような有用な情報が含まれます。

- メタデータ。名前、バージョン、説明、著者のメールアドレスなど
- 含まれるファイルのリスト。
- 実行ファイルとその場所のリスト（binなど）。
- Rubyのload pathに含まれるべきパスのリスト（libなど）。
- 必要となるほかのライブラリ（依存関係）

最後の「依存関係」というのがGemfileと重なるところですね。
Gemが依存関係を記述するときは、名前とバージョン範囲をリストアップします。
個々で重要なのは依存先ライブラリのソースについては気にしないということです。
ということは、依存先のGemとして自分でミラーしたものやハックしたものを使うことができるわけです。
要するにRubygemの依存というのはシンボリックなものであって、インターネットのどの場所にあるどのGem、という厳密な依存ではないのです。

他の要素と相まって、このことがRubygemsというシステムをロバストなものにしています。

また、Gemの作者は依存先ライブラリのバージョンを範囲で指定します。
開発時に利用していた依存先が、利用時には別のものになっていることも考慮して作らなければいけません。
特に依存先の依存先についてはよくあることです。

## Rubyアプリケーション

Rubyアプリケーション（Railsアプリなど）は大抵、依存するサードパーティ製コードが複雑かつ精密なものになりがちです。
開発に着手したときにどのバージョンのnokogiriを使ってるかは気にしなくても、開発時とデプロイ時で同じものを使う必要はあります。
Gemの作者と違ってアプリの作者はデプロイ環境を意のままにするので、そのアプリをサードパーティが使うかもということは考えなくてよく、依存関係はとにかく精度の高いものにすることになります。

結果的に、アプリケーションが使うGemがインターネットのどこに置かれているかまで厳密に指定するわけです。
長期にわたって影響なく使い続けられる事を考えなければいけないGem作者とは対照的な立場です。

また、アプリの作者は公開されているGemをハックしたり、未公開の"edge"バージョンを使ったりする必要があったりもします。
Bundlerではそのためにgemの場所を特定のgitレポジトリとして指定することも可能です。
Gemの作者は依存関係をシンボリックに定義しているので、アプリの作者は独自のミラー（gitなど）でその依存関係を満たすという選択ができます。

このように、永続性と柔軟性を重視するGem開発者と、どの環境においても同じ依存先を使うことを重視するアプリ開発者とでは全く必要とするものが違ってくるのです。

## RubygemsとBundler

Rubygemsというライブラリ（そのCLIとAPI）は、Gem作者の要求を満たすよう設計されています。
特にgemspecはrubygems.orgにデプロイするgemの標準的なデータ書式です。
上に述べた理由により、gemspecでは依存先の場所という過渡的な情報は保持しません。

一方Bundlerはアプリ開発者の要求を満たすよう設計されています。
Gemfileはメタデータ、ファイルリストなどは含みません。
なぜなら依存関係を厳密に定義するという目的から外れるからです。
そのかわり、依存関係については本当に厳密に定義できます。

## Git上の「Gem」

アプリケーションはまだリリースされていないようなgemに依存することもあると言いました。
Bundlerではgitレポジトリの中の.gemspecファイルを見て、まるでgemのように扱うことができます。

## Gemを開発するときは

Gemを開発していくとこの二つの世界の狭間に陥ることがあります。
理由は

- 開発の先端ではrubygems.orgに公開されていないgemを使うことがあるから。
  したがってそのgemの正確な場所を指定する必要がある。
- Rubygemsの力だけでは必要なもの全てをload path内に置くことができないから。
  たとえばある依存先はローカル、あるgemはどこかのgitレポジトリ、あるgemはrubygems.orgから引っ張ってこなければいけないような状況。
  Railsの開発などはこれにあてはまる。

開発中のgemはいずれ成長して普通のgemとして公開するわけですから、.gemspecを仕様に従って書く必要があります。
Gemfileに書いているだけではいけません。

Gemの開発においてGemfileとgemspecに同じような内容を書かなくてすむよう、Bundlerにはこういう設定項目があります（[bundlerのドキュメント](http://gembundler.com/rubygems.html)）：

```ruby
source "http://www.rubygems.org"
gemspec
```

このディレクティブを書くと、Bundlerは近くの.gemspecファイルを探してくれます。
そしてbundleを実行するとそれをGemとみなし、その依存関係を解決してくれます。
load pathにも追加してくるので、記述の重複なしにgemspecとbundlerを使うことができるわけです。

まだリリースされていないGemを使う必要があるときは（たとえばRailsではRack, Arel, Mailなどのプレリリースをよく使いますが）、Gemfileにそれぞれのgemの場所を書いていきます。
依存の解決のためには.gemspecを見ますが、その取得先についてはGemfileを尊重してくれます。

```ruby
source "http://www.rubygems.org"
gemspec
# このgitレポジトリにあるrackが.gemspecで指定されたバージョンと
# ズレていたら、Bundlerがエラーを吐く
gem "rack", :git => "git://github.com/rack/rack.git"
```

この情報はいずれ.gemspecを公開することを考えると.gemspecには書きたくありません。
繰り返しますが.gemspecではこの情報を指定しないことによって柔軟性を確保し、Gemfileでは（開発時に限って）厳密に指定することができています。

Gemfile.lockをレポジトリにチェックインするなというのはこういう理由です。
Bundlerによって自動生成されるこのファイルには必要となる全てのgemの厳密な場所が書かれていますが、それによってGemとしての柔軟性が失われるからです。

.gemspecで指定したどんな依存先でも問題なく使えるという保証にはなりませんが、とにかく、そのバージョンを指定してしまうことによるメリットはありません。

## 追記

確認ですが、アプリケーションの開発ではGemfile.lockをチェックインすべきです。
このファイルには使用するgemの正確なバージョンと場所が書かれています。
これはアプリケーション開発では望ましいことですが、Gem開発では嬉しくありません。

----

<iframe src="http://expando.github.io/add/?u=http%3A%2F%2Fsanemat.github.io%2Farchives%2Flangturn.com-translations-33%2F&t=gemspec%E3%81%A8Gemfile%E3%81%AE%E5%BD%B9%E5%89%B2%E3%82%92%E3%81%AF%E3%81%A3%E3%81%8D%E3%82%8A%E3%81%95%E3%81%9B%E3%81%A6%E3%81%8A%E3%81%8F" frameborder=0 frametransparency=1 scrolling=no height=30 width=400>
</iframe>

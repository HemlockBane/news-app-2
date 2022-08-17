import 'package:dio/dio.dart';
import 'package:collection/collection.dart';
import 'package:news_app_2/core/data/models/article.dart';
import 'package:news_app_2/core/data/models/article_preview.dart';

class MockArticlePreviewInterceptor extends Interceptor {
  final _previewPath = "/wp-json/api/articles_preview";

  final _numberOfArticlesPerPage = 15;

  int get pageCount => (articles.length / _numberOfArticlesPerPage).ceil();

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final uri = options.uri;
    if (uri.path.toString() == _previewPath) {
      final pageNumber = options.queryParameters["page"];

      final response = await _getPreviewsForPage(pageNumber, options.data);

      final articlePreviews = response.map((article) {
        return ArticlePreview(
          id: article.id,
          title: article.title,
          date: article.date,
          image: article.image,
          difficultyLevel: article.difficultyLevel,
          readTime: article.readTime,
          categories: article.categories,
        ).toJson();
      }).toList();

      final allArticlesCount = articlePreviews.length;
      final responseBody = {
        "article_preview_body": {
          "grandTotalCount": allArticlesCount,
          "article_previews": articlePreviews
        }
      };
      return handler.resolve(
          Response(requestOptions: options, data: responseBody), true);
    }

    super.onRequest(options, handler);
  }

  Future<List<Article>> _getPreviewsForPage(
      int pageNumber, Map<String, dynamic> body) async {
    final startIdx = ((pageNumber - 1) * _numberOfArticlesPerPage);
    final nextBatchIdx = startIdx + _numberOfArticlesPerPage;

    final difficultyFilter = body["difficulty_level"] as List<String>?;
    final categoryFilter = body["category"];
    final readTimeFilter = body["read_time"] as List<int>?;

    var articlesDB = [...articles];
    var endIdx =
        (nextBatchIdx > articlesDB.length) ? articlesDB.length : (nextBatchIdx);

    if (difficultyFilter != null ||
        categoryFilter != null ||
        readTimeFilter != null) {
      final l = articles.where((a) {
        final matchesDifficultyLevel = isNullOrElse<List<String>>(
            difficultyFilter,
            (t) => t!.contains(a.difficultyLevel ?? "beginner"));

        final matchesCategory = isNullOrElse<List<int>>(
            categoryFilter,
            (t) => getCategoryLabels(t!)
                .any((label) => (a.categories ?? []).contains(label)));

        final matchesReadTime = isNullOrElse<List<int>>(
            readTimeFilter,
            (t) =>
                (t!.first <= (a.readTime ?? 2) && (a.readTime ?? 2) <= t.last));

        return matchesDifficultyLevel && matchesReadTime && matchesCategory;
      }).toList();

      articlesDB = [...l];
      endIdx = (nextBatchIdx > articlesDB.length)
          ? articlesDB.length
          : (nextBatchIdx);
    }

    final value = await Future.delayed(
        const Duration(seconds: 3), () => articlesDB.sublist(startIdx, endIdx));
    return value;
  }

  bool isNullOrElse<T>(T? t, bool Function(T? t) predicate) {
    if (t != null) return predicate(t);
    return true;
  }
}

class MockArticleRequestInterceptor extends Interceptor {
  final _articlePath = "/wp-json/api/article_by_id";

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.uri.path.toString() == _articlePath) {
      final id = options.queryParameters["id"];

      final article = await Future.delayed(const Duration(seconds: 3),
          () => articles.firstWhereOrNull((article) => article.id == id));

      if (article == null) {
        return handler.reject(DioError(requestOptions: options));
      }

      final data = article.toJson();
      return handler.resolve(
        Response(requestOptions: options, data: {"article": data}),
      );
    }
    super.onRequest(options, handler);
  }
}

class MockFilterRequestInterceptor extends Interceptor {
  final _filterOptionsPath = "/wp-json/api/article_filter_options";

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.uri.path.toString() == _filterOptionsPath) {
      final res = await Future.delayed(const Duration(seconds: 3));
      final responseBody = {
        "filterOptions": {
          "categories": categories,
          "difficultyLevels": ["Beginner", "Intermediate", "Advanced"]
        }
      };

      return handler.resolve(
        Response(requestOptions: options, data: responseBody),
      );
    }

    super.onRequest(options, handler);
  }
}

List<String> getCategoryLabels(List<int> categoryIds) {
  return categories
      .where((e) => categoryIds.contains(e["id"]))
      .map((e) => e["name"] as String)
      .toList();
}

final categories = [
  {"id": 1, "name": "Crypto"},
  {"id": 2, "name": "Social Engineering"}
];

final data = [
  {
    "id": 1,
    "title":
        "Crypto-exchange BitMart reports \$150 million theft following hack",
    "content":
        "Cryptocurrency trading platform BitMart has revealed that around \$150 million worth of funds have been stolen by malicious hackers. Blockchain security firm Peckshield has estimated losses of around \$200 million following an attack on the platform on Saturday (December 4), comprising \$100 million on the Ethereum blockchain and \$96 million on the Binance Smart Chain. "
            ""
            "In a statement issued on the same day, BitMart said it was “temporarily suspending withdrawals until further notice” after detecting a “large-scale security breach” centered on two ‘hot’ wallets (meaning the wallets were connected to the internet). The Ethereum and Binance Smart Chain wallets accounted for “a small percentage of assets on BitMart and all of our other wallets are secure and unharmed”, said BitMart. “We are now conducting a thorough security review and we will post updates as we progress.” While BitMart said it was still investigating how the cyber-heist was executed, Peckshield yesterday (December 5) described the hack as “pretty straightforward: transfer-out, swap, and wash” – visualizing this on Twitter with a flow chart indicating the use of a decentralized exchange aggregator and privacy mixer to make the pilfered funds harder to trace.",
    "date": "2022-01-11 11:15:12",
    "image":
        "https://portswigger.net/cms/images/82/75/f0f3-article-211206-bitmart-body-text.png",
    "difficultyLevel": "Advanced",
    "readTime": 3,
    "categories": ["Crypto"]
  },
  {
    "id": 2,
    "title":
        "bZx crypto heist results in reported losses of more than \$55 million",
    "content":
        "bZx, the decentralized finance (DeFi) platform, says “possible terms of compensation” are being discussed as it continue to investigate the theft of millions of dollars’ worth of cryptocurrency funds. A cybercriminal pulled off the heist after compromising a bZx developer’s PC and stealing their personal cryptocurrency wallet’s private keys via a phishing attack, bZx revealed on Friday (November 5). The attacker then drained the developer’s wallet and obtained keys to the bZx protocol’s Polygon and Binance Smart Chain (BSC) deployments.\n\nThe hacker subsequently “drained the BSC and Polygon protocol, then upgraded the contract to allow draining of all tokens that the contracts had given unlimited approval”, said bZx in a ‘preliminary post mortem’.Blockchain security firm SlowMist has estimated that the crypto-thief made off with more than \$55 million.In response, bZx tweeted that “roughly 25% of this figure is personal losses from the team wallet that was compromised”\n\n. The DeFi platform said its Ethereum deployment escaped unscathed because it is governed by a DAO (decentralized autonomous organization) – something it said it will now implement for its BSC and Polygon implementations. Potential victims include “lenders, borrowers, and farmers with funds on Polygon and BSC, and those who had given unlimited approvals to those contracts”, said bZx. The DeFi platform said it is still investigating which specific wallets were affected but has confirmed that “a limited number of users who had approved the unlimited spend had funds stolen from their wallet”.\n\n bZx found the hacker’s IP address and tracked stolen funds to a number of wallet addresses after being alerted to suspicious activity on a user account on the morning of November 5. It subsequently disabled the user interface on Polygon and BSC to prevent further user deposits, and contacted Tether, Binance, and USDC, requesting that the cryptocurrency platforms freeze the hacker’s wallets.",
    "date": "2021-09-11 15:46:12",
    "image":
        "https://portswigger.net/cms/images/82/75/f0f3-article-211206-bitmart-body-text.png",
    "difficultyLevel": "Intermediate",
    "readTime": 3,
    "categories": ["Crypto"]
  },
  {
    "id": 3,
    "title": "What Are Nested Exchanges and Why Should You Avoid Them?",
    "content":
        "A nested cryptocurrency exchange provides its customers with crypto trading services through an account on another exchange. It does not facilitate trading directly itself. Instead, it acts as a bridge between users and other service providers. Nesting is commonly used in traditional banking to provide services a specific bank can't, such as international transfers.In the crypto space, nested exchanges often have lax KYC and AML processes or none at all. This lack of compliance is often explored by cybercriminals. Nested exchanges support money laundering, scammers, and ransomware payments. When you trade with a nested exchange, you are trusting it with the custody of your assets. They provide less security and fewer guarantees than a compliant centralized or decentralized exchange. You can also face legal issues for dealing with sanctioned nested exchanges. If you use an exchange, make sure it has proper KYC and AML checks. These often take days to process. If the exchange allows you to trade almost instantly without limits, you should investigate it further. A legitimate exchange won't hide how trades are made, and you can easily view the source of your funds on a blockchain explorer. \n\nIntroduction\n\n When you're buying and selling crypto, it's essential to trade using a trusted website. However, you need to have patience when completing KYC and AML checks to keep yourself safe. For this reason, some users choose to use exchanges that offer little or no sign-up checks and instant trading. While some may be legitimate decentralized exchanges, others could be nested exchanges that handle stolen and laundered funds. Your funds are never guaranteed to be safe with a nested exchange. To make sure you keep your crypto secure, it’s important to understand what nested exchanges are, what they do, and how you can recognize them. \n\nWhat is nesting?\n\nNesting occurs when a financial service provider creates an account with another financial institution to use their services. The account holder then acts as a bridge, offering services to their customers via the nested account. This happens for many reasons. For example, a bank in one country would provide its banking services and ecosystem to a bank operating in a different country, known as correspondent banking. Imagine a customer who wants to transfer money to a bank account in Australia. Their bank might not be able to do this, but they could use a correspondent bank to transfer the funds for them. The customer's bank would process the transfer request through its nested account with the correspondent bank. The correspondent bank must take care and conduct due diligence on the bank they work with. The correspondent bank essentially serves customers they don't know, so they need to trust the nested account holder. \n\nWhat is a nested cryptocurrency exchange? \n\nA nested cryptocurrency exchange works in a fairly simple way. An entity or person creates an account with a regulated exchange. They then use this account to offer trading services to third parties through their nested account. These nested exchanges are sometimes known as instant exchanges and often have multiple accounts across different exchanges.Some may ask for identifying documents, but others might require little to no identification at all. This makes them a popular choice with scammers, fraudsters, and ransomers. Some nested exchanges even allowed for the purchasing and selling of crypto in person with cash. What's the danger of nesting?When it comes to traditional finance, one of the biggest problems is the risk of money laundering. As the correspondent bank only deals directly with the underlying respondent bank, they cannot be sure exactly who they are dealing with. This is why nesting requires enhanced due diligence checks on the underlying bank. Individuals or whole countries may be blacklisted and have sanctions placed on them. If an underlying bank doesn't abide by these, the respondent bank may end up supporting illegal activities, such as avoiding sanctions or money laundering. \n\nAs the cryptocurrency industry is still developing robust regulations, it's easier for nested exchanges to operate under the radar. A nested exchange could open an account with a large crypto exchange without them easily knowing. \n\nWhat are the dangers of nested cryptocurrency exchange? When you use a nested cryptocurrency exchange, it doesn't just hurt centralized exchanges. You and your funds are also in danger for several reasons: \n\n1. Your deposits have fewer guarantees on their safety than with a regulated exchange. \n\n2. You might be supporting illegal activities that fund crime and terrorism. \n\n3. Regulatory authorities may shut down the exchange, causing you to lose your crypto or other funds. \n\n4. You could face legal repercussions from law enforcement if you knowingly work with an exchange that is involved with illicit activity. \n\nThe best way to avoid these is not to use nested crypto exchanges. Spotting them can be tricky as it's not always obvious. Follow our tips later on for the best chance to protect yourself. \n\nWhat's the difference between a nested exchange and a decentralized exchange? At first, a nested exchange and a decentralized exchange look similar. Decentralized exchanges require no KYC, and nested exchanges can have lax KYC processes or none at all. However, the way they deal with transactions is different. A decentralized exchange will connect buyers directly to sellers or even use liquidity pools. The exchange will never take custody of the traded cryptocurrency. Instead, smart contracts handle the process. However, a nested exchange will take direct custody of your crypto and use the services of another exchange.",
    "date": "2022-01-14 15:46:12",
    "image":
        "https://image.binance.vision/uploads-original/2829999dd6664d5d83bc56dbe6e38905.png",
    "difficultyLevel": "Beginner",
    "readTime": 6,
    "categories": ["Crypto"]
  },
  {
    "id": 4,
    "title": "The Ultimate Guide to Proof of Keys Day",
    "content":
        "\n\nIntroduction. \n\nKeeping your private keys safe and secure is essential to ensure financial independence. Unfortunately, many cryptocurrency investors trust their money to be left solely on exchanges. But this practice is far from being safe because the exchanges have full control over the cryptocurrency deposits. \n\nSince the early days of Bitcoin, billions were lost due to exchange hacks and scams. The hack of the Mt. Gox exchange in 2014 is one of the most famous and controversial cases, and it’s still under investigation. \n\nBut what does all that have to do with the Proof of Keys day? \n\nWhat is Proof of Keys? \n\nThe idea of Proof of Keys was created by Trace Mayer, a cryptocurrency investor and podcaster. He created the concept as an annual celebration that aims to incentivize cryptocurrency investors to reclaim their monetary autonomy. As previously discussed, many people leave their cryptocurrencies stored on exchanges. This is inherently dangerous because these exchanges have full control over the private keys of their deposit addresses. In this context, the Proof of Keys day aims to prevent investors' dependence on exchanges to conveniently store their cryptocurrencies. The concept is often presented with a short, but effective sentence: not your keys; not your Bitcoin. The first Proof of Keys day took place on January 3rd, 2019 - which was the 10th anniversary of the genesis block being mined on the Bitcoin network. Put in another way, the Proof of Keys day celebrates financial sovereignty. Its goal is to encourage cryptocurrency investors to move their funds from exchanges to their personal wallets. By taking full control over one's own private keys, they're ensuring no one but themselves can access their funds. There are numerous types of cryptocurrency wallets. But, hardware wallets are often the preferred choice as they're arguably the most secure way to store private keys. \n\nFour important outcomes of the Proof of Keys day\n\n The philosophy behind Proof of Keys day lines up perfectly with that of Bitcoin. By replacing third-party intermediaries with a trustless value-transfer system, individuals can cooperate securely and confidently with one another - without giving up their monetary autonomy. So, what are some of the important outcomes of the Proof of Keys day? Teach new investors how to move coins around Cryptocurrency investors should be comfortable moving cryptocurrencies from one place to another. While this may sound simple to some, newcomers often find it hard to understand the many types of wallets and how they are used. As such, the Proof of Keys day encourages investors to learn more about the different types of crypto wallets and to practice their use. It's also a reminder of how the transfer of value is performed on decentralized blockchain networks. Remind investors who really owns their private keys As stated, the main mission set out by Trace Mayer when starting the Proof of Keys day was to encourage every cryptocurrency investor to own their private keys. Leaving their cryptocurrencies on an exchange means that investors have zero control over their funds. Even though it only happens once a year, the Proof of Keys day is an opportunity for every investor to take control of their funds. While the day is a good reminder of who owns what, it means very little if investors don't follow through with securing what's theirs. Expose shady or dishonest exchange. Financial institutions are known for practicing what is known as fractional reserve banking. In essence, it's a way for institutions to leverage their existing deposits by lending out more money than they actually have. Unfortunately, this is risky for depositors since a \"bank run\" could lead to an institution going bankrupt. Within the cryptocurrency space, the Proof of Keys day may encourage thousands of investors to withdraw their funds from the exchanges. If a great percentage of investors decide to do that on the same day, it can eventually expose the exchanges that practice fractional reserve methods or that lie about their true reserves. Fortunately, though, the transparency of Bitcoin and other blockchain networks makes it easier for exchanges to make their holdings publicly verifiable. Celebrate the Bitcoin genesis block. Last but not least, the Proof of Keys day is a way to celebrate the first block to be mined on the Bitcoin network. Such a block is known as the genesis block. The genesis block contains the first Bitcoin transaction to take place, through which Satoshi Nakamoto sent 50 BTC to Hal Finney. Another memorable transaction took place on May 22nd, 2010, when two pizzas were bought for 10,000 bitcoins. The episode is now known as the Bitcoin Pizza day. \n\nHow to take part in the Proof of Keys movement. \n\nIt doesn’t matter if you are new to cryptocurrencies or a veteran. Participating in the Proof of Keys day is very easy. As mentioned, the idea is to declare financial autonomy by withdrawing all funds from exchanges (or other third party services). First, you can take an inventory of all the funds you have stored on cryptocurrency exchanges. This will give you an idea of who really owns what when it comes to your bitcoins and altcoins. Next, choose a cryptocurrency wallet that you are comfortable using. Along with usability, it’s also important to consider the level of security of each wallet type before making your choice. The last step involves sending your funds to your personal wallet so that you own and control your private keys. Some people participate in the Proof of Keys movement once a year. They move their funds away from the exchange for one day (on January 3rd) to celebrate and affirm their financial sovereignty.Such a practice is common among active traders, who need to hold funds on exchanges in order to trade. So after the celebration, they usually move funds back to exchanges. However, long term investors (HODLers) that don’t engage in short or mid-term trading are better off holding their funds on a personal wallet.",
    "date": "2019-23-12 11:15:12",
    "image":
        "https://image.binance.vision/uploads-original/F0l6idh6uQGMurDZldkT.png",
    "difficultyLevel": "Intermediate",
    "readTime": 5,
    "categories": ["Crypto"]
  },
];

final articles = data.map((e) => Article.fromJson(e)).toList();

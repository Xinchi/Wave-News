//
//  ViewController.m
//  Wave News
//
//  Created by Max Gu on 12/30/11.
//  Copyright (c) 2011 guxinchi2000@gmail.com. All rights reserved.
//

#import "ViewController.h"
#import "TableViewCell.h"
#import "TableFormCell.h"
#import "OffLineMode.h"
#import "Reachability.h"
#import "WaveNewsIAPHelper.h"

@interface ViewController()

// Private Properties:
@property (retain, nonatomic) UIPanGestureRecognizer *navigationBarPanGestureRecognizer;
@property dispatch_queue_t downloadQueue;

@end


@implementation ViewController
{
    ADBannerView *_bannerView;
}
@synthesize TabOfTableForm;
@synthesize navigator;
@synthesize TableFormCell;
@synthesize revealController;



@synthesize tableView;
@synthesize tableViewCellWithTableView;
@synthesize headerCell;
@synthesize currentSite;
@synthesize NewsCategories;
@synthesize database;
@synthesize sitesLimit;
@synthesize fieldsLimit;
@synthesize newsList;
@synthesize newsContentsDic;
@synthesize isloading;
@synthesize savedNews;
@synthesize navigationBarPanGestureRecognizer;
@synthesize downloadQueue;
@synthesize isRefreshing;
//@synthesize navigator;
@synthesize bakImgView;
@synthesize contentView = _contentView;
@synthesize tabBar;
@synthesize CopyOfNewsCategories;
@synthesize hud;
@synthesize display;
@synthesize TabOfWaveForm;
@synthesize isInWaveForm;
@synthesize enableADCountDown;


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
//    NSLog(@"%@ has been tapped", item.title);
    if([item.title isEqual:@"Table Style"])
    {
        isInWaveForm = NO;
        [tableView reloadData];
    }
    else
    {
        isInWaveForm = YES;
        [tableView reloadData];
    }
}
- (void)setupDatabase
{
//    NSLog(@"Now setting up database...");
    database = [[NSMutableArray alloc] init];
    //    NYT
    NSArray *fields = [[NSArray alloc] initWithObjects: 
                       @"World",
                       @"Business",
                       @"Technology",
                       @"Sports",
                       @"Science",
                       @"Health",
                       @"Arts",
                       @"Style",
                       @"Travel",
                       @"Real Estate",
                       nil];
    //    NSLog(@"%d",[fields count]);
    NSArray *urls = [[NSArray alloc] initWithObjects:
                     @"http://www.nytimes.com/services/xml/rss/nyt/World.xml",
                     @"http://www.nytimes.com/services/xml/rss/nyt/Business.xml",
                     @"http://www.nytimes.com/services/xml/rss/nyt/Technology.xml",
                     @"http://www.nytimes.com/services/xml/rss/nyt/Sports.xml",
                     @"http://www.nytimes.com/services/xml/rss/nyt/Science.xml",
                     @"http://www.nytimes.com/services/xml/rss/nyt/Health.xml",
                     @"http://www.nytimes.com/services/xml/rss/nyt/Arts.xml",
                     @"http://www.nytimes.com/services/xml/rss/nyt/Style.xml",
                     @"http://www.nytimes.com/services/xml/rss/nyt/Travel.xml",
                     @"http://www.nytimes.com/services/xml/rss/nyt/RealEstate.xml",
                     nil];
    //    NSLog(@"%d",[urls count]);
    NSDictionary *NYT = [[NSDictionary alloc] initWithObjects:urls forKeys:fields];
    [fields release];
    [urls release];
    //    NSLog([NYT objectForKey:@"Sports"]);
    
    //    MSNBC
    fields = [[NSArray alloc] initWithObjects:
              @"Business",
              @"US News",
              @"World",
              @"Politics",
              @"Sports",
              @"Health",
              @"Travel",
              @"Entertainment",
              @"Tech & Science",
              @"Weather",
              nil];
    urls = [[NSArray alloc] initWithObjects:
            @"http://rss.msnbc.msn.com/id/3032071/device/rss/rss.xml",
            @"http://rss.msnbc.msn.com/id/3032524/device/rss/rss.xml",
            @"http://rss.msnbc.msn.com/id/3032506/device/rss/rss.xml",
            @"http://rss.msnbc.msn.com/id/3032552/device/rss/rss.xml",
            @"http://rss.nbcsports.msnbc.com/id/3032112/device/rss/rss.xml",
            @"http://rss.msnbc.msn.com/id/3088327/device/rss/rss.xml",
            @"http://rss.msnbc.msn.com/id/3032122/device/rss/rss.xml",
            @"http://today.msnbc.msn.com/id/3032083/device/rss/rss.xml",
            @"http://rss.msnbc.msn.com/id/3032117/device/rss/rss.xml",
            @"http://rss.msnbc.msn.com/id/3032127/device/rss/rss.xml",
            nil];
    NSDictionary *MSNBC = [[NSDictionary alloc] initWithObjects:urls forKeys:fields];
    [fields release];
    [urls release];
    //    NSLog([MSNBC objectForKey:@"Politics"]);
    
    
    //SAN FRANCISCO CHRONICLE
	fields = [[NSArray alloc] initWithObjects:
              @"Top News",
              @"World",
              @"National",
              @"Bay Area News",
              @"Politics",
              @"Education",
              @"Sports",
              @"Business & Technology",
              @"Cars",
              @"Entertainment",
              @"Food & Dinning",
              @"Mark Morford",
              @"Jon Carroll",
              @"Giants News",
//              @"City Insider",
              @"The Bondage File",
              @"The City Exposed",
              @"Travel",
              @"Home & Garden",
              @"Hot Stuff",
              
              nil];
    urls = [[NSArray alloc] initWithObjects:
            @"http://feeds.sfgate.com/sfgate/rss/feeds/news",
            @"http://feeds.sfgate.com/sfgate/rss/feeds/news_world",
            @"http://feeds.sfgate.com/sfgate/rss/feeds/news_nation",
            @"http://feeds.sfgate.com/sfgate/rss/feeds/bayarea",
            @"http://feeds.sfgate.com/sfgate/rss/feeds/news_politics",
            @"http://feeds.sfgate.com/sfgate/rss/feeds/education",
            @"http://feeds.sfgate.com/sfgate/rss/feeds/sports",
            @"http://feeds.sfgate.com/sfgate/rss/feeds/business",
            @"http://feeds.sfgate.com/sfgate/rss/feeds/cars",
            @"http://feeds.sfgate.com/sfgate/rss/feeds/entertainment",
            @"http://feeds.sfgate.com/sfgate/rss/feeds/food",
            @"http://feeds.sfgate.com/sfgate/rss/feeds/morford",
            @"http://feeds.sfgate.com/sfgate/rss/feeds/jcarroll",
            @"http://feeds.sfgate.com/sfgate/rss/feeds/giants",
//            @"http://feeds.sfgate.com/sfgate/rss/feeds/blogs/sfgate/cityinsider/index_rss2",
            @"http://feeds.sfgate.com/sfgate/rss/feeds/bondage",
            @"http://feeds.sfgate.com/sfgate/rss/feeds/cityexposed",
            @"http://feeds.sfgate.com/sfgate/rss/feeds/travel",
            @"http://feeds.sfgate.com/sfgate/rss/feeds/homeandgarden",
            @"http://feeds.sfgate.com/sfgate/rss/feeds/hotstuff",
            nil];
    NSDictionary *SFCHRONICLE = [[NSDictionary alloc] initWithObjects:urls forKeys:fields];
    [fields release];
    [urls release];

    

    
    //    WSJ
    fields = [[NSArray alloc] initWithObjects:
              @"U.S. Home Page",
              @"Politics & Campaign",
              @"World",
              @"Asia",
              @"US Business",
              @"Technology",
              @"Markets",
              @"Real Estate",
              @"Lifestyle",
              nil];
    urls = [[NSArray alloc] initWithObjects:
            @"http://online.wsj.com/xml/rss/3_7011.xml",
            @"http://online.wsj.com/xml/rss/3_7087.xml",
            @"http://online.wsj.com/xml/rss/3_7085.xml",
            @"http://online.wsj.com/xml/rss/3_7013.xml",
            @"http://online.wsj.com/xml/rss/3_7014.xml",
            @"http://online.wsj.com/xml/rss/3_7455.xml",
            @"http://online.wsj.com/xml/rss/3_7031.xml",
            @"http://online.wsj.com/xml/rss/3_7400.xml",
            @"http://online.wsj.com/xml/rss/3_7201.xml",
            nil];
    NSDictionary *WSJ = [[NSDictionary alloc] initWithObjects:urls forKeys:fields];
    [fields release];
    [urls release];
    //    NSLog([WSJ objectForKey:@"U.S. Homepage"]);
    
    // USA Today
    fields = [[NSArray alloc] initWithObjects:
              @"TOP HEADLINES",
              @"NATIONAL",
              @"WASHINGTON",
              @"WORLD",
              @"RELIGION",
              @"EDUCATION",
              @"OFFBEAT NEWS",
              @"HEALTH",
              @"OPINION",
              @"ON POLITICS",
              @"THE OVAL",
              @"MONEY HEADLINES",
			  @"MONEY - TEST DRIVE by JAMES HEALEY",
			  @"MONEY - YOUR MONEY by SANDRA BLOCK",
			  @"MONEY - INVESTING by JOHN WAGGONER",
			  @"MONEY - SMALL BUSINESS by STEVE STRAUSS",
			  @"MONEY - STOCK by MATT KRANTZ",
			  @"MONEY - SMALL BUSINESS by Gladys Edmunds",
              nil];
    urls = [[NSArray alloc] initWithObjects:
            @"http://content.usatoday.com/marketing/rss/rsstrans.aspx?feedId=news1&xml=true",
            @"http://content.usatoday.com/marketing/rss/rsstrans.aspx?feedId=news2&xml=true",
            @"http://content.usatoday.com/marketing/rss/rsstrans.aspx?feedId=news3&xml=true",
            @"http://content.usatoday.com/marketing/rss/rsstrans.aspx?feedId=news4&xml=true",
            @"http://content.usatoday.com/marketing/rss/rsstrans.aspx?feedId=news55&xml=true",
            @"http://content.usatoday.com/marketing/rss/rsstrans.aspx?feedId=news56&xml=true",
            @"http://content.usatoday.com/marketing/rss/rsstrans.aspx?feedId=news5&xml=true",
            @"http://content.usatoday.com/marketing/rss/rsstrans.aspx?feedId=news6&xml=true",
            @"http://content.usatoday.com/marketing/rss/rsstrans.aspx?feedId=news20&xml=true",
            @"http://content.usatoday.com/marketing/rss/rsstrans.aspx?feedId=news25&xml=true",
            @"http://content.usatoday.com/marketing/rss/rsstrans.aspx?feedId=news27&xml=true",
            @"http://content.usatoday.com/marketing/rss/rsstrans.aspx?feedId=money1&xml=true",
			@"http://content.usatoday.com/marketing/rss/rsstrans.aspx?feedId=money2&xml=true",
			@"http://content.usatoday.com/marketing/rss/rsstrans.aspx?feedId=money3&xml=true",
			@"http://content.usatoday.com/marketing/rss/rsstrans.aspx?feedId=money4&xml=true",
			@"http://content.usatoday.com/marketing/rss/rsstrans.aspx?feedId=money5&xml=true",
			@"http://content.usatoday.com/marketing/rss/rsstrans.aspx?feedId=money6&xml=true",
			@"http://content.usatoday.com/marketing/rss/rsstrans.aspx?feedId=money8&xml=true",
            nil];
    
    NSDictionary *USATODAY = [[NSDictionary alloc] initWithObjects:urls forKeys:fields];
    [fields release];
    [urls release];
    
    //LOS ANGELES TODAYYYY
    fields = [[NSArray alloc] initWithObjects:
              @"Top News",
              @"Most E-mailed",
              @"California Local News",
              @"Orange County",
              @"World",
              @"National",
              @"Business",
              @"Education",
              @"Sports",
              @"Baseball",
              @"Lakers",
              @"Environment",
              @"Health",
              @"Entertainment",
              @"Travel",
              @"Music",
              @"TV News",
              @"Auto Racing",
              @"Religion",
              @"Science",
              nil];
    urls = [[NSArray alloc] initWithObjects:
            @"http://feeds.latimes.com/latimes/news?format=xml",
//            @"http://sports.espn.go.com/espn/rss/news",
            @"http://feeds.latimes.com/MostEmailed?format=xml",
            @"http://feeds.latimes.com/latimes/news/local?format=xml",
            @"http://feeds.latimes.com/latimes/news/local/orange/",
            @"http://feeds.latimes.com/latimes/news/nationworld/world?format=xml",
            @"http://feeds.latimes.com/latimes/news/nationworld/nation?format=xml",
            @"http://feeds.latimes.com/latimes/business?format=xml",
            @"http://feeds.latimes.com/latimes/news/education?format=xml",
            @"http://feeds.latimes.com/latimes/sports/",
            @"http://feeds.latimes.com/latimes/sports/baseball/mlb/",
            @"http://feeds.latimes.com/latimes/sports/basketball/nba/lakers/",
            @"http://feeds.latimes.com/latimes/news/science/environment?format=xml",
            @"http://feeds.latimes.com/latimes/features/health/",
            @"http://feeds.latimes.com/latimes/entertainment/",
            @"http://feeds.latimes.com/latimes/travel/",
            @"http://feeds.latimes.com/latimes/entertainment/news/music/",
            @"http://feeds.latimes.com/latimes/entertainment/news/tv/",
            @"http://feeds.latimes.com/latimes/sports/motorracing/",
            @"http://feeds.latimes.com/latimes/features/religion?format=xml",
            @"http://feeds.latimes.com/latimes/news/science?format=xml",
            nil];
    
    NSDictionary *LATIMES = [[NSDictionary alloc] initWithObjects:urls forKeys:fields];
    [fields release];
    [urls release];
    
    // Washington Post
    fields = [[NSArray alloc] initWithObjects:
              @"World",
              @"National",
              @"Politics",
              @"Business",
              @"Economy",
              @"Local",
              @"Sports",
              @"Entertainment",
              @"Lifestyle",
              @"Redskins/NFL",
              nil];
    urls = [[NSArray alloc] initWithObjects:
            @"http://feeds.washingtonpost.com/rss/world?format=xml",
            @"http://feeds.washingtonpost.com/rss/national?format=xml",
            @"http://feeds.washingtonpost.com/rss/politics?format=xml",
            @"http://feeds.washingtonpost.com/rss/business?format=xml",
            @"http://feeds.washingtonpost.com/rss/business/economy?format=xml",
            @"http://feeds.washingtonpost.com/rss/local?format=xml",
            @"http://feeds.washingtonpost.com/rss/sports?format=xml",
            @"http://feeds.washingtonpost.com/rss/entertainment?format=xml",
            @"http://feeds.washingtonpost.com/rss/lifestyle?format=xml",
            @"http://feeds.washingtonpost.com/rss/sports/redskins?format=xml",
            nil];
    NSDictionary *WASHINGTONPOST = [[NSDictionary alloc] initWithObjects:urls forKeys:fields];
    [fields release];
    [urls release];
    
    //NEW YORK POST
    fields = [[NSArray alloc] initWithObjects:
              @"All",
              @"News",
              @"Local News",
              @"Business",
              @"Travel",
              @"Entertainment",
              @"Fashion",
              @"Music",
              @"Theater",
              
              nil];
    urls = [[NSArray alloc] initWithObjects:
            @"http://www.nypost.com/rss/all_section.xml",
            @"http://www.nypost.com/rss/all_section.xml",
            @"http://www.nypost.com/rss/regionalnews.xml",
            @"http://www.nypost.com/rss/business.xml",
            @"http://www.nypost.com/rss/travel.xml",
            @"http://www.nypost.com/rss/entertainment.xml",
            @"http://www.nypost.com/rss/fashion.xml",
            @"http://www.nypost.com/rss/music.xml",
            @"http://www.nypost.com/rss/theater.xml",
            
            nil];

    NSDictionary *NEWYORKPOST = [[NSDictionary alloc] initWithObjects:urls forKeys:fields];
    [fields release];
    [urls release];
    
    
    //The Atlanta Journal-Constitution
    fields = [[NSArray alloc] initWithObjects:
              @"Breaking News",
              @"Atlanta & South Fulton",
              @"Business",
              @"Sports",
              @"Entertainment",
              @"Music",
              @"Events",
              @"Fashion & Style",
              @"Travel",
              @"Lifestyle",
              nil];
    urls = [[NSArray alloc] initWithObjects:
            @"http://www.ajc.com/genericList-rss.do?source=61499",
            @"http://www.ajc.com/section-rss.do?source=atlanta",
            @"http://www.ajc.com/genericList-rss.do?source=94547",
            @"http://www.ajc.com/genericList-rss.do?source=61510",
            @"http://www.accessatlanta.com/section-rss.do?source=entertainment",
            @"http://www.accessatlanta.com/section-rss.do?source=music",
            @"http://www.accessatlanta.com/section-rss.do?source=events",
            @"http://www.accessatlanta.com/section-rss.do?source=fashion-style",
            @"http://www.ajc.com/genericList-rss.do?source=61542",
            @"http://www.ajc.com/section-rss.do?source=lifestyle",
            nil];
    NSDictionary *AJC = [[NSDictionary alloc] initWithObjects:urls forKeys:fields];
    [fields release];
    [urls release];

//TRIBUNEEEE
    //Chicago Tribune
	fields = [[NSArray alloc] initWithObjects:
              @"Breaking News",
              @"Latest News",
              @"Hot Topics",
              @"Nation & World",
              @"Business",
              @"Opinion",
              @"Jobs",
              @"Arts",
              @"Movies",
              @"Health",
              @"Religion",
              @"Entertainment",
              @"Most E-mailed Stories",
              @"Most Viewed Stories",
              @"Books",
              @"Your Money",
              @"Music",
              @"Shopping",
              @"Travel",
              @"Fashion",
              @"Dinning",
              @"Real Estate",
              @"Auto",
              nil];
    urls = [[NSArray alloc] initWithObjects:
            @"http://feeds.feedburner.com/ChicagoBreakingNews?format=xml",
            @"http://feeds.chicagotribune.com/chicagotribune/news/",
            @"http://feeds.chicagotribune.com/chicagotribune/hottopics/",
            @"http://feeds.chicagotribune.com/chicagotribune/news/nationworld?format=xml",
            @"http://feeds.chicagotribune.com/chicagotribune/business?format=xml",
            @"http://feeds.chicagotribune.com/chicagotribune/opinion/",
            @"http://feeds.chicagotribune.com/chicagotribune/career?format=xml",
            @"http://feeds.chicagotribune.com/chicagotribune/arts?format=xml",
            @"http://feeds.chicagotribune.com/chicagotribune/movies?format=xml",
            @"http://feeds.chicagotribune.com/chicagotribune/health?format=xml",
            @"http://feeds.chicagotribune.com/chicagotribune/religion/",
            @"http://feeds.chicagotribune.com/chicagotribune/entertainment/",
            @"http://feeds.chicagotribune.com/chicagotribune/email?format=xml",
            @"http://feeds.chicagotribune.com/chicagotribune/views?format=xml",
            @"http://feeds.chicagotribune.com/chicagotribune/books?format=xml",
            @"http://feeds.chicagotribune.com/chicagotribune/yourmoney/",
            @"http://feeds.chicagotribune.com/chicagotribune/music/",
            @"http://feeds.chicagotribune.com/chicagotribune/shopping/",
            @"http://feeds.chicagotribune.com/chicagotribune/travel/",
            @"http://feeds.chicagotribune.com/chicagotribune/fashion/",
            @"http://feeds.chicagotribune.com/chicagotribune/dining/",
            @"http://feeds.chicagotribune.com/chicagotribune/realestate/",
            @"http://feeds.chicagotribune.com/chicagotribune/cars/",
            nil];
    NSDictionary *CHICAGOTRIBUNE = [[NSDictionary alloc] initWithObjects:urls forKeys:fields];
    [fields release];
    [urls release];

    //YAHOO
    fields = [[NSArray alloc] initWithObjects:
              @"Headlines",
              @"World",
              @"U.S News",
              @"Education",
              @"Weather",
              @"Religion",
              @"Politics",
              @"Business",
              @"Economy",
              @"Technology",
              @"Science",
              
              
              @"Finance",
              @"Sports",
              @"Health",
              @"Entertainment",
              @"Celebrity",
              
              
              @"Company News",
              @"Buzz",
              @"Music",
//              @"Trailers",
              @"Answers",
              nil];
    
    urls = [[NSArray alloc] initWithObjects:
            @"http://news.yahoo.com/rss?format=xml",
            @"http://news.yahoo.com/rss/world",
            @"http://news.yahoo.com/rss/us",
            @"http://news.yahoo.com/rss/education",
            @"http://news.yahoo.com/rss/weather",
            @"http://news.yahoo.com/rss/religion",
            @"http://news.yahoo.com/rss/politics",
            @"http://news.yahoo.com/rss/business",
            @"http://news.yahoo.com/rss/economy",
            @"http://news.yahoo.com/rss/tech",
            @"http://news.yahoo.com/rss/science",
            
            
            @"http://finance.yahoo.com/rss/topfinstories?format=xml",
            @"http://sports.yahoo.com/top/rss.xml",
            @"http://news.yahoo.com/rss/health",
            @"http://news.yahoo.com/rss/entertainment",
            @"http://news.yahoo.com/rss/celebrity",
            
            
            
            @"http://feeds.finance.yahoo.com/rss/2.0/headline?s=yhoo&region=US&lang=en-US&format=xml",
            @"http://buzzlog.yahoo.com/feeds/buzzlog.xml",
            @"http://rss.music.yahoo.com/charts/rssTopVideos.xml",
//            @"http://rss.ent.yahoo.com/movies/top25trailers.xml",
            @"http://answers.yahoo.com/rss/allq?format=xml",
            nil];

    NSDictionary *YAHOO = [[NSDictionary alloc] initWithObjects:urls forKeys:fields];
    [fields release];
    [urls release];
    
    //CNN
	fields = [[NSArray alloc] initWithObjects:
              @"CNN News",
              @"World",
              @"Americas",
              @"ASIA",
              @"US",
              @"Technology",
              @"Science",
              @"Entertainment",
              @"Travel",
              @"Sports",
              nil];
    urls = [[NSArray alloc] initWithObjects:
            @"http://rss.cnn.com/rss/edition.rss?format=xml",
            @"http://rss.cnn.com/rss/edition_world.rss?format=xml",
            @"http://rss.cnn.com/rss/edition_americas.rss?format=xml",
            @"http://rss.cnn.com/rss/edition_asia.rss?format=xml",
            @"http://rss.cnn.com/rss/edition_us.rss?format=xml",
            @"http://rss.cnn.com/rss/edition_technology.rss?format=xml",
            @"http://rss.cnn.com/rss/edition_space.rss?format=xml",
            @"http://rss.cnn.com/rss/edition_entertainment.rss?format=xml",
            @"http://rss.cnn.com/rss/edition_travel.rss?format=xml",
            @"http://rss.cnn.com/rss/edition_sport.rss?format=xml",
            nil];
    
    NSDictionary *CNN = [[NSDictionary alloc] initWithObjects:urls forKeys:fields];
    [fields release];
    [urls release];

    //GOOGLE
	fields = [[NSArray alloc] initWithObjects:
              @"Google News",
              @"World",
              @"Business",
              @"Technology",
              @"Science",
              @"Entertainment",
              @"Sports",
              @"Health",
              
              nil];
    urls = [[NSArray alloc] initWithObjects:
            @"http://news.google.com/news?ned=us&topic=h&output=rss&format=xml",
            @"http://news.google.com/news?ned=us&topic=w&output=rss&format=xml",
            @"http://news.google.com/news?pz=1&cf=all&ned=en_sg&hl=en&topic=b&output=rss",
            @"http://news.google.com/news?pz=1&cf=all&ned=en_sg&hl=en&topic=tc&output=rss",
            @"http://news.google.com/news?pz=1&cf=all&ned=en_sg&hl=en&topic=snc&output=rss",
            @"http://news.google.com/news?pz=1&cf=all&ned=en_sg&hl=en&topic=e&output=rss",
            @"http://news.google.com/?topic=s&output=rss&format=xml",
            @"http://news.google.com/news?pz=1&cf=all&ned=en_sg&hl=en&topic=m&output=rss",
            nil];
    
    NSDictionary *GOOGLE = [[NSDictionary alloc] initWithObjects:urls forKeys:fields];
    [fields release];
    [urls release];

    
    //FOX NEWS
	fields = [[NSArray alloc] initWithObjects:
              @"Headlines",
              @"US",
              @"World",
              @"Politics",
              @"Opinion",
              @"Entertainment",
              @"SciTech",
              @"Health",
              @"Sports",
              @"Leisure",
              
              nil];
    urls = [[NSArray alloc] initWithObjects:
            @"http://feeds.foxnews.com/foxnews/most-popular?format=xml",
            @"http://feeds.foxnews.com/foxnews/national?format=xml",
            @"http://feeds.foxnews.com/foxnews/world?format=xml",
            @"http://feeds.foxnews.com/foxnews/politics?format=xml",
            @"http://feeds.foxnews.com/foxnews/opinion?format=xml",
            @"http://feeds.foxnews.com/foxnews/entertainment?format=xml",
            @"http://feeds.foxnews.com/foxnews/scitech?format=xml",
            @"http://feeds.foxnews.com/foxnews/health?format=xml",
            @"http://feeds.foxnews.com/foxnews/sports?format=xml",
            @"http://feeds.foxnews.com/foxnews/leisure?format=xml",
            
            nil];
    
    NSDictionary *FOXNEWS = [[NSDictionary alloc] initWithObjects:urls forKeys:fields];
    [fields release];
    [urls release];

    
    //HEADLINESSSS
    
	fields = [[NSArray alloc] initWithObjects:
              @"LA Times",
              @"USA Today",     
              @"Chicago Tribune",
              @"CNN",
              @"San Francisco Chronicle",
              @"Washington Post",
              @"New York Post",
              @"The Atlanta Journal-Constitution",
              @"Yahoo!",
              @"Google News",
              @"Fox News",
              nil];
    

    urls = [[NSArray alloc] initWithObjects:
            @"http://feeds.latimes.com/latimes/news?format=xml",
            @"http://rssfeeds.usatoday.com/usatoday-NewsTopStories",     
            @"http://feeds.chicagotribune.com/chicagotribune/news/",
            @"http://rss.cnn.com/rss/edition.rss",
            @"http://feeds.sfgate.com/sfgate/rss/feeds/news",
            @"http://feeds.washingtonpost.com/rss/world?format=xml",
            @"http://www.nypost.com/rss/all_section.xml",
            @"http://www.ajc.com/genericList-rss.do?source=61499",
            @"http://news.yahoo.com/rss?format=xml",
            @"http://news.google.com/news?ned=us&topic=h&output=rss&format=xml",
            @"http://feeds.foxnews.com/foxnews/most-popular?format=xml",
            nil];
    
    NSDictionary *HEADLINES = [[NSDictionary alloc] initWithObjects:urls forKeys:fields];
    [fields release];
    [urls release];

    
    
    
    //MOST VIEWEDDDD
    
	fields = [[NSArray alloc] initWithObjects:
              @"LA Times",
              @"Wall Street Journal",
              @"Forbes.com",
              @"Barron",
              @"Guardian",
              @"Techmeme",
              @"Seatle Times",
              
              nil];
    urls = [[NSArray alloc] initWithObjects:
            @"http://feeds.latimes.com/MostEmailed",
            @"http://online.wsj.com/xml/rss/3_7251.xml",            
            @"http://www.forbes.com/fast/feed",
            @"http://online.barrons.com/xml/rss/3_7560.xml",
            @"http://www.guardian.co.uk/mostviewed/rss",
            @"http://www.techmeme.com/feed.xml",
            @"http://seattletimes.nwsource.com/rss/mostemailedarticles.xml",
            nil];
    NSDictionary *MOSTVIEWED = [[NSDictionary alloc] initWithObjects:urls forKeys:fields];
    [fields release];
    [urls release];

    
    
    //WORLDDDD
    
	fields = [[NSArray alloc] initWithObjects:
              @"New York Times",
              @"Yahoo!",
              @"LA Times",
              @"Wall Street Journal",
              @"USA Today",    
              @"BBC",
              @"Washington Post",
              nil];
    urls = [[NSArray alloc] initWithObjects:
            @"http://feeds.nytimes.com/nyt/rss/World",
            @"http://rss.news.yahoo.com/rss/world",
            @"http://feeds.latimes.com/latimes/news/nationworld/world?format=xml",
            @"http://online.wsj.com/xml/rss/3_7085.xml",
            @"http://rssfeeds.usatoday.com/UsatodaycomWorld-TopStories",    
            @"http://feeds.bbci.co.uk/news/rss.xml?edition=int",
            @"http://www.washingtonpost.com/wp-srv/world/rssheadlines.xml",
            nil];
    NSDictionary *WORLD = [[NSDictionary alloc] initWithObjects:urls forKeys:fields];
    [fields release];
    [urls release];


    //U.S....
    
	fields = [[NSArray alloc] initWithObjects:
              @"New York Times",
              @"LA Times",
              @"Yahoo!",
              @"Wall Street Journal",
              @"San Francisco Chronicle",
              @"CNN",
              @"Chicago Tribune",
              nil];
    urls = [[NSArray alloc] initWithObjects:
            @"http://feeds.nytimes.com/nyt/rss/US",
            @"http://feeds.latimes.com/latimes/news/nationworld/nation?format=xml",
            @"http://news.yahoo.com/rss/us",
            @"http://online.wsj.com/xml/rss/3_7011.xml",
            @"http://feeds.sfgate.com/sfgate/rss/feeds/news_nation",
            @"http://rss.cnn.com/rss/edition_us.rss",
            @"http://feeds.chicagotribune.com/chicagotribune/news/local/",
            nil];
    
    NSDictionary *US = [[NSDictionary alloc] initWithObjects:urls forKeys:fields];
    [fields release];
    [urls release];

    
    
    //POLITICSSSS
    
	fields = [[NSArray alloc] initWithObjects:
              @"New York Times",
              @"LA Times",
              @"Yahoo!",
              @"Wall Street Journal",
              @"USA Today",
              @"New York Post",
              @"ABC News",
              @"BBC News",
              @"The Politic",
              @"Washington Post",
              
              nil];
    urls = [[NSArray alloc] initWithObjects:
            @"http://feeds.nytimes.com/nyt/rss/Politics",
            @"http://feeds.latimes.com/latimes/news/politics?format=xml",
            @"http://news.yahoo.com/rss/politics",
            @"http://online.wsj.com/xml/rss/3_7087.xml",
            @"http://rssfeeds.usatoday.com/TP-OnPolitics",
            @"http://www.nypost.com/rss/politics.xml",
            @"http://feeds.abcnews.com/abcnews/politicsheadlines",
            @"http://feeds.bbci.co.uk/news/politics/rss.xml?edition=int",
            @"http://thepolitic.org/?feed=rss2",
            @"http://www.washingtonpost.com/wp-srv/politics/rssheadlines.xml",
            nil];
    
    NSDictionary *POLITICS = [[NSDictionary alloc] initWithObjects:urls forKeys:fields];
    [fields release];
    [urls release];

    
    
    
    //BUSINESSSSS
	fields = [[NSArray alloc] initWithObjects:
              @"Business Insider",
              @"BBC",
              @"Yahoo!",
              @"New York Times",
              @"Washington Post",
              @"LA Times",
              @"Wall Street Journal",
              @"Chicago Tribune",
              @"CNN",
              
              nil];
    urls = [[NSArray alloc] initWithObjects:
            @"http://feeds2.feedburner.com/businessinsider",
            @"http://feeds.bbci.co.uk/news/business/rss.xml?edition=int",
            @"http://rss.news.yahoo.com/rss/business",
            @"http://www.nytimes.com/services/xml/rss/userland/Business.xml",
            @"http://www.washingtonpost.com/wp-srv/business/rssheadlines.xml",
            @"http://feeds.latimes.com/latimes/business?format=xml",
            @"http://online.wsj.com/xml/rss/3_7014.xml",
            @"http://feeds.chicagotribune.com/chicagotribune/business/",
            @"http://rss.cnn.com/rss/edition_business.rss",
            
            nil];
    NSDictionary *BUSINESS = [[NSDictionary alloc] initWithObjects:urls forKeys:fields];
    [fields release];
    [urls release];

    
    //EDUCATIONNNN
	fields = [[NSArray alloc] initWithObjects:
              @"New York Times",
              @"Washington Post",
              @"Yahoo!",
              @"LA Times",
              @"USA Today",
              
              nil];
    urls = [[NSArray alloc] initWithObjects:
            @"http://www.nytimes.com/services/xml/rss/userland/Education.xml",
            @"http://www.washingtonpost.com/wp-srv/education/rssheadlines.xml",
            @"http://news.yahoo.com/rss/education",
            @"http://feeds.latimes.com/latimes/news/education?format=xml",
            @"http://rssfeeds.usatoday.com/Education-TopStories",
            
            nil];
    
    NSDictionary *EDUCATION = [[NSDictionary alloc] initWithObjects:urls forKeys:fields];
    [fields release];
    [urls release];

    
    //TECHNOLOGYYYY
	fields = [[NSArray alloc] initWithObjects:
              @"Techmeme",
              @"Yahoo!",
              @"Yahoo! - Open Source",
              @"Yahoo! - Internet",
              @"CNET - Reviews",
              @"CNET - Computer System",
              @"CNET - Laptops",
              @"CNET - Desktops",
              @"CNET - Digital Cameras",
              @"CNET - Handheld Devices",
              @"CNET - Portable Audio",
              @"CNET - Camcoders",
              @"CNET - Video Player",
              @"CNET - Cell Phones",
              @"CNET - Software",
              @"CNET - Home Audio",
              @"CNET - Networking and Wireless",
              @"CNET - Peripherals",
              @"CNET - Car Tech",
              @"CNET - GPS",
              @"CNET - Games and Gear",

              
              
              @"New York Times",
              @"LA Times",
              @"Wall Street Journal",
              @"USA Today",
              
              nil];
    urls = [[NSArray alloc] initWithObjects:
            @"http://www.techmeme.com/feed.xml",
            @"http://news.yahoo.com/rss/tech",
            @"http://news.yahoo.com/rss/open-source",
            @"http://news.yahoo.com/rss/internet",
            @"http://feeds.feedburner.com/cnet/YIff?orderBy=-7rvDte&maxhits=25&dedup=1&tag=rb_content%253brb_mtx",
            @"http://reviews.cnet.com/4924-3000_7-0.xml?orderBy=-7pop&7rType=70-80&maxhits=10&tag=rb_content;rb_mtx",
            @"http://reviews.cnet.com/4924-3121_7-0.xml?orderBy=-7pop&7rType=70-80&maxhits=10&tag=rb_content;rb_mtx",
            @"http://reviews.cnet.com/4924-3118_7-0.xml?orderBy=-7pop&7rType=70-80&maxhits=10&tag=rb_content;rb_mtx",
            @"http://reviews.cnet.com/4924-6501_7-0.xml?orderBy=-7pop&7rType=70-80&maxhits=10&tag=rb_content;rb_mtx",
            @"http://reviews.cnet.com/4924-3127_7-0.xml?orderBy=-7pop&7rType=70-80&maxhits=10&tag=rb_content;rb_mtx",
            @"http://reviews.cnet.com/4924-6450_7-0.xml?orderBy=-7pop&7rType=70-80&maxhits=10&tag=rb_content;rb_mtx",
            @"http://reviews.cnet.com/4924-6500_7-0.xml?orderBy=-7pop&7rType=70-80&maxhits=10&tag=rb_content;rb_mtx",
            @"http://reviews.cnet.com/4924-6463_7-0.xml?orderBy=-7pop&7rType=70-80&maxhits=10&tag=rb_content;rb_mtx",
            @"http://reviews.cnet.com/4924-3504_7-0.xml?orderBy=-7pop&7rType=70-80&maxhits=10&tag=rb_content;rb_mtx",
            @"http://reviews.cnet.com/4924-3513_7-0.xml?orderBy=-7pop&7rType=70-80&maxhits=10&tag=rb_content;rb_mtx",
            @"http://reviews.cnet.com/4924-6462_7-0.xml?orderBy=-7pop&7rType=70-80&maxhits=10&tag=rb_content;rb_mtx",
            @"http://reviews.cnet.com/4924-3243_7-0.xml?orderBy=-7pop&7rType=70-80&maxhits=10&tag=rb_content;rb_mtx",
            @"http://reviews.cnet.com/4924-3132_7-0.xml?orderBy=-7pop&7rType=70-80&maxhits=10&tag=rb_content;rb_mtx",
            @"http://reviews.cnet.com/4924-10863_7.xml?orderBy=-7pop&7rType=70-80&maxhits=10&tag=rb_content;rb_mtx",
            @"http://reviews.cnet.com/4924-3490_7-0.xml?orderBy=-7pop&7rType=70-80&maxhits=10&tag=rb_content;rb_mtx",
            @"http://reviews.cnet.com/4924-9020_7.xml?orderBy=-7pop&7rType=70-80&maxhits=10&tag=rb_content;rb_mtx",

            
            @"http://feeds.nytimes.com/nyt/rss/Technology",
            @"http://feeds.latimes.com/latimes/technology?format=xml",
            @"http://online.wsj.com/xml/rss/3_7455.xml",
            @"http://rssfeeds.usatoday.com/usatoday-TechTopStories",
            
            nil];
    
    NSDictionary *TECHNOLOGY = [[NSDictionary alloc] initWithObjects:urls forKeys:fields];
    [fields release];
    [urls release];

    
    
    //SPORTSSSS
	fields = [[NSArray alloc] initWithObjects:
              @"New York Times",
              @"LA Times",
              @"USA Today",
              @"The Atlanta Journal",
              @"Chicago Tribune",
              @"Yahoo!",
              @"ESPN Toplines",
              @"ESPN NFL",
              @"ESPN NBA",
              @"ESPN MLB",
              @"ESPN NHL",
              @"College Basketball",
              
              nil];
    urls = [[NSArray alloc] initWithObjects:
            @"http://feeds1.nytimes.com/nyt/rss/Sports",
            @"http://feeds.latimes.com/latimes/sports/",
            @"http://rssfeeds.usatoday.com/UsatodaycomSports-TopStories",
            @"http://www.ajc.com/genericList-rss.do?source=61510",
            @"http://feeds.chicagotribune.com/chicagotribune/sports/",
            @"http://rss.news.yahoo.com/rss/sports",
            @"http://sports.espn.go.com/espn/rss/news",
            @"http://sports.espn.go.com/espn/rss/nfl/news",
            @"http://sports.espn.go.com/espn/rss/nba/news",
            @"http://sports.espn.go.com/espn/rss/mlb/news",
            @"http://sports.espn.go.com/espn/rss/nhl/news",
            @"http://sports.espn.go.com/espn/rss/ncb/news",
            
            nil];
    
    NSDictionary *SPORTS = [[NSDictionary alloc] initWithObjects:urls forKeys:fields];
    [fields release];
    [urls release];

    
    
    //SCIENCEEEE
	fields = [[NSArray alloc] initWithObjects:
              @"New York Times",
              @"LA Times",
              @"Yahoo!",
              @"USA Today",
              @"NASA Science",
              @"NASA Earth Observatory",
              @"BBC News",
              @"National Geographic News",
              
              nil];
    urls = [[NSArray alloc] initWithObjects:
            @"http://feeds.nytimes.com/nyt/rss/Science",
            @"http://feeds.latimes.com/latimes/news/science?format=xml",
            @"http://rss.news.yahoo.com/rss/science",
            @"http://rssfeeds.usatoday.com/UsatodaycomScienceAndSpace-TopStories",
            @"http://science.nasa.gov/feeds/science-at-nasa-news/",
            @"http://earthobservatory.nasa.gov/Feeds/rss/eo.rss",
            @"http://feeds.bbci.co.uk/news/science_and_environment/rss.xml?edition=int",
            @"http://news.nationalgeographic.com/index.rss",
            
            nil];
    
    NSDictionary *SCIENCE = [[NSDictionary alloc] initWithObjects:urls forKeys:fields];
    [fields release];
    [urls release];

    
    
    
    //HEALTHHHH
	fields = [[NSArray alloc] initWithObjects:
              @"New York Times",
              @"LA Times",
              @"USA Today",
              @"Chicago Tribune",
              @"BBC News",
              @"Yahoo!",
              
              nil];
    urls = [[NSArray alloc] initWithObjects:
            @"http://feeds.nytimes.com/nyt/rss/Health",
            @"http://feeds.latimes.com/latimes/features/health?format=xml",
            @"http://rssfeeds.usatoday.com/UsatodaycomHealth-TopStories",
            @"http://feeds.chicagotribune.com/chicagotribune/religion/",
            @"http://feeds.bbci.co.uk/news/health/rss.xml?edition=int",
            @"http://rss.news.yahoo.com/rss/health",
            nil];
    
    NSDictionary *HEALTH = [[NSDictionary alloc] initWithObjects:urls forKeys:fields];
    [fields release];
    [urls release];

    
    //ARTSSSS
	fields = [[NSArray alloc] initWithObjects:
              @"New York Times",
              @"LA Times",
              @"Chicago Tribune",
              @"Yahoo!",
              
              nil];
    urls = [[NSArray alloc] initWithObjects:
            @"http://feeds.nytimes.com/nyt/rss/Arts",
            @"http://feeds.latimes.com/latimes/entertainment/news/arts?format=xml",
            @"http://feeds.chicagotribune.com/chicagotribune/arts/",
            @"http://news.yahoo.com/rss/arts",
            
            nil];
    NSDictionary *ARTS = [[NSDictionary alloc] initWithObjects:urls forKeys:fields];
    [fields release];
    [urls release];




    
    
    //TRAVELLLL
	fields = [[NSArray alloc] initWithObjects:
              @"New York Times",
              @"LA Times",
              @"The Atlanta Journal",
              @"Chicago Tribune",
              
              nil];
    urls = [[NSArray alloc] initWithObjects:
            @"http://feeds.nytimes.com/nyt/rss/Travel",
            @"http://feeds.latimes.com/latimes/travel?format=xml",
            @"http://www.ajc.com/genericList-rss.do?source=61542",
            @"http://feeds.chicagotribune.com/chicagotribune/travel/",
            
            nil];
    
    NSDictionary *TRAVEL = [[NSDictionary alloc] initWithObjects:urls forKeys:fields];
    [fields release];
    [urls release];

    
    
    //MAGAZINEEEE
	fields = [[NSArray alloc] initWithObjects:
              @"New York Times",
              
              nil];
    urls = [[NSArray alloc] initWithObjects:
            @"http://feeds.nytimes.com/nyt/rss/Magazine",
            
            nil];
    
    NSDictionary *MAGAZINE = [[NSDictionary alloc] initWithObjects:urls forKeys:fields];
    [fields release];
    [urls release];

    
    
    //JOBSSSS
	fields = [[NSArray alloc] initWithObjects:
              @"New York Times",
              @"Wall Street Journal",
              @"New York Post",
              @"Chicago Tribune",
              
              nil];
    urls = [[NSArray alloc] initWithObjects:
            @"http://www.nytimes.com/services/xml/rss/nyt/JobMarket.xml",
            @"http://online.wsj.com/xml/rss/3_7107.xml",
            @"http://www.nypost.com/rss/jobs.xml",
            @"http://feeds.chicagotribune.com/chicagotribune/career/",
            
            nil];
    
    NSDictionary *JOBS = [[NSDictionary alloc] initWithObjects:urls forKeys:fields];
    [fields release];
    [urls release];

    
    //ENTERTAINMENTTTT
	fields = [[NSArray alloc] initWithObjects:
              @"USA Today",
              @"New York Post",
              @"The Atlanta Journal",
              @"Chicago Tribune",
              @"Yahoo!",
              @"Yahoo! - Movies",
              @"Yahoo! - Music",
              @"Yahoo! - Odd News",
              
              nil];
    urls = [[NSArray alloc] initWithObjects:
            @"http://rssfeeds.usatoday.com/usatoday-LifeTopStories",
            @"http://www.nypost.com/rss/entertainment.xml",
            @"http://www.accessatlanta.com/section-rss.do?source=entertainment",
            @"http://feeds.chicagotribune.com/chicagotribune/entertainment/",
            @"http://news.yahoo.com/rss/entertainment",
            @"http://news.yahoo.com/rss/movies",
            @"http://news.yahoo.com/rss/music",
            @"http://news.yahoo.com/rss/odd",
            
            nil];
    
    NSDictionary *ENTERTAINMENT = [[NSDictionary alloc] initWithObjects:urls forKeys:fields];
    [fields release];
    [urls release];

    

    //FASHIONNNN
	fields = [[NSArray alloc] initWithObjects:
              @"Chicago Tribune",
              @"Yahoo!",
              @"myStyle",
              @"Style Scene",
              @"New York Times",
              @"Wall Street Journal",
              @"The Atlanta Journal",
              @"InStyle.com",

              
              nil];
    urls = [[NSArray alloc] initWithObjects:
            @"http://feeds.chicagotribune.com/chicagotribune/fashion/",
            @"http://news.yahoo.com/rss/fashion",
            @"http://www.mystyle.com/syndication/feeds/rssfeeds/mystyle.xml",
            @"http://www.mystyle.com/syndication/feeds/rssfeeds/style-scene.xml",
            @"http://feeds.nytimes.com/nyt/rss/FashionandStyle",
            @"http://online.wsj.com/xml/rss/3_7201.xml",
            @"http://www.accessatlanta.com/section-rss.do?source=fashion-style",
            @"http://feeds.instyle.com/instyle/thisjustin",
            nil];
    
    
    NSDictionary *FASHION = [[NSDictionary alloc] initWithObjects:urls forKeys:fields];
    [fields release];
    [urls release];
    
    
    //BLOGS
	fields = [[NSArray alloc] initWithObjects:
              @"Americas view",
              @"Babbage",
              @"Bagehot's notebook",
              @"Banyan's notebook",
              @"Baobab",
              @"Blighty",
              @"Buttonwood's notebook",
              @"Charlemagne's notebook",
              @"Clausewitz",
              @"Democracy in America",
              @"Eastern approaches",
              @"Free exchange",
              @"Global leadership",
              @"Graphic detail",
              @"Gulliver",
              @"Johnson",
              @"Leviathan",
              @"Lexington's notebook",
              @"Multimedia",
              @"Newsbook",
              @"Prospero",
              @"Schumpeter's notebook",


              
              nil];
    urls = [[NSArray alloc] initWithObjects:
            @"http://www.economist.com/blogs/americasview/index.xml",
            @"http://www.economist.com/blogs/babbage/index.xml",
            @"http://feeds2.feedburner.com/BagehotsNotebook?format=xml",
            @"http://www.economist.com/blogs/banyan/index.xml",
            @"http://www.economist.com/blogs/baobab/index.xml",
            @"http://www.economist.com/blogs/blighty/index.xml",
            @"http://feeds2.feedburner.com/ButtonwoodsNotebook?format=xml",
            @"http://feeds2.feedburner.com/CharlemagnesNotebook?format=xml",
            @"http://www.economist.com/blogs/clausewitz/index.xml",
            @"http://www.economist.com/blogs/democracyinamerica/index.xml",
            @"http://feeds.feedburner.com/economist/QxiO",
            @"http://www.economist.com/blogs/freeexchange/index.xml",
            @"http://www.economist.com/blogs/globalleadership/index.xml",
            @"http://www.economist.com/blogs/graphicdetail/index.xml",
            @"http://www.economist.com/blogs/gulliver/index.xml",
            @"http://feeds.feedburner.com/economist/SlNh",
            @"http://www.economist.com/blogs/leviathan/index.xml",
            @"http://feeds2.feedburner.com/LexingtonsNotebook?format=xml",
            @"http://www.economist.com/blogs/multimedia/index.xml",
            @"http://feeds.feedburner.com/economist/pJMW",
            @"http://www.economist.com/blogs/prospero/index.xml",
            @"http://feeds.feedburner.com/economist/Ztnh",

            
            nil];
    
    NSDictionary *BLOG = [[NSDictionary alloc] initWithObjects:urls forKeys:fields];
    [fields release];
    [urls release];


    
    //    Putting together
    NSArray *objects = [[NSArray alloc] initWithObjects:
                        NYT,
                        YAHOO,
                        LATIMES,
                        CHICAGOTRIBUNE,
                        SFCHRONICLE,
                        NEWYORKPOST,
                        MSNBC,
                        WSJ,
                        USATODAY,
                        WASHINGTONPOST,
                        AJC,
                        CNN,
                        GOOGLE,
                        FOXNEWS,
                        HEADLINES,
                        MOSTVIEWED,
                        WORLD,
                        US,
                        POLITICS,
                        BUSINESS,
                        EDUCATION,
                        TECHNOLOGY,
                        SPORTS,
                        SCIENCE,
                        HEALTH,
                        ARTS,
                        TRAVEL,
                        MAGAZINE,
                        JOBS,
                        ENTERTAINMENT,
                        FASHION,
                        BLOG,
                        nil];
    [NYT release];
    [MSNBC release];
    [SFCHRONICLE release];
    [WSJ release];
    [USATODAY release];
    [LATIMES release];
    [WASHINGTONPOST release];
    [NEWYORKPOST release];
    [AJC release];
    [CHICAGOTRIBUNE release];
    [YAHOO release];
    [CNN release];
    [GOOGLE release];
    [FOXNEWS release];
    [HEADLINES release];
    [MOSTVIEWED release];
    [WORLD release];
    [US release];
    [POLITICS release];
    [BUSINESS release];
    [EDUCATION release];
    [TECHNOLOGY release];
    [SPORTS release];
    [SCIENCE release];
    [HEALTH release];
    [ARTS release];
    [TRAVEL release];
    [MAGAZINE release];
    [JOBS release];
    [ENTERTAINMENT release];
    [FASHION release];
    [BLOG release];
    
    //    NSLog([NYT objectForKey:@"Science"]);
    NSString *sites = [[NSArray alloc] initWithObjects:
                       @"NEW YORK TIMES",
                       @"YAHOO",
                       @"LOS ANGELES TIMES",
                       @"CHICAGO TRIBUNE",
                       @"SAN FRANCISCO CHRONICLE",
                       @"NEW YORK POST",
                       @"MSNBC",
                       @"WALL STREET JOURNAL",
                       @"USA TODAY",
                       @"WASHINGTON POST",
                       @"THE ATLANTA JOURNAL-CONSTITUTION",
                       @"CNN",
                       @"GOOGLE",
                       @"FOX NEWS",
                       @"HEADLINES",
                       @"MOST VIEWED",
                       @"WORLD",
                       @"U.S.",
                       @"POLITICS",
                       @"BUSINESS",
                       @"EDUCATION",
                       @"TECHNOLOGY",
                       @"SPORTS",
                       @"SCIENCE",
                       @"HEALTH",
                       @"ARTS",
                       @"TRAVEL",
                       @"MAGAZINE",
                       @"JOBS",
                       @"ENTERTAINMENT",
                       @"FASHION",
                       @"BLOG",
                       
                       nil];
    self.database = [[NSDictionary alloc] initWithObjects:objects forKeys:sites];
    [objects release];
    [sites release];
    
//    NSLog(@"Now displaying designated datasource");
//    NSLog([[self.database objectForKey:@"USA TODAY"] objectForKey:@"NATIONAL"]);
}

- (void)setupNewsTobeDisplayed
{
    sitesLimit = 30;
    fieldsLimit = 30;
    self.NewsCategories = [[NSMutableArray alloc] initWithCapacity:sitesLimit];
    NSMutableArray *fields = [[NSMutableArray alloc] initWithCapacity:fieldsLimit]; 
    
    
    
    
    //    LOS ANGELES TIMESSSS
    fields = [[NSMutableArray alloc] initWithCapacity:fieldsLimit];
    [fields addObject:@"Top News"];
    [fields addObject:@"Most E-mailed"];
    [fields addObject:@"California Local News"];
    [fields addObject:@"Orange County"];
    [fields addObject:@"World"];
    [fields addObject:@"National"];
    [fields addObject:@"Business"];
    [fields addObject:@"Education"];
    [fields addObject:@"Sports"];
    [fields addObject:@"Baseball"];
    [fields addObject:@"Lakers"];
    [fields addObject:@"Environment"];
    [fields addObject:@"Health"];
    [fields addObject:@"Entertainment"];
    [fields addObject:@"Travel"];
    [fields addObject:@"Music"];
    [fields addObject:@"TV News"];
    [fields addObject:@"Auto Racing"];
    [fields addObject:@"Religion"];
    [fields addObject:@"Science"];
    
    NSArray *LATIMES = [[NSArray alloc] initWithObjects:@"LOS ANGELES TIMES",fields,nil];
    [self.NewsCategories addObject:LATIMES];
    [LATIMES release];
    [fields release];

    
    //    NYT
    fields = [[NSMutableArray alloc] initWithCapacity:fieldsLimit];
    [fields addObject:@"World"];
    [fields addObject:@"Business"];
    [fields addObject:@"Technology"];
    [fields addObject:@"Sports"];
    [fields addObject:@"Science"];
    [fields addObject:@"Health"];
    [fields addObject:@"Arts"];
    [fields addObject:@"Style"];
    NSArray *NYT = [[NSArray alloc] initWithObjects: @"NEW YORK TIMES",fields,nil];
    [self.NewsCategories addObject:NYT];
    [NYT release];
    [fields release];
    
    
    //Chicago Tribune
    fields = [[NSMutableArray alloc] initWithCapacity:fieldsLimit];
    [fields addObject:@"Breaking News"];
    [fields addObject:@"Nation & World"];
    [fields addObject:@"Business"];
    [fields addObject:@"Jobs"];
    [fields addObject:@"Arts"];
    [fields addObject:@"Movies"];
    [fields addObject:@"Health"];
    [fields addObject:@"Most E-mailed Stories"];
    [fields addObject:@"Most Viewed Stories"];
    [fields addObject:@"Books"];
    NSArray *CHICAGOTRIBUNE = [[NSArray alloc] initWithObjects: @"CHICAGO TRIBUNE",fields,nil];
    [self.NewsCategories addObject:CHICAGOTRIBUNE];
    [CHICAGOTRIBUNE release];
    [fields release];
    

    
    //YAHOO
    fields = [[NSMutableArray alloc] initWithCapacity:fieldsLimit];
    [fields addObject:@"Headlines"];
    [fields addObject:@"World"];
    [fields addObject:@"U.S News"];
    [fields addObject:@"Education"];
    [fields addObject:@"Weather"];
    [fields addObject:@"Religion"];
    [fields addObject:@"Politics"];
    [fields addObject:@"Business"];
    [fields addObject:@"Economy"];
    [fields addObject:@"Technology"];
    [fields addObject:@"Science"];
    [fields addObject:@"Finance"];
    [fields addObject:@"Sports"];
    [fields addObject:@"Health"];
    [fields addObject:@"Entertainment"];
    [fields addObject:@"Celebrity"];
    NSArray *YAHOO = [[NSArray alloc] initWithObjects: @"YAHOO",fields,nil];
    [self.NewsCategories addObject:YAHOO];
    [YAHOO release];
    [fields release];

    
    
    
    //    SAN FRANCISCO CHRONICLE
    fields = [[NSMutableArray alloc] initWithCapacity:fieldsLimit];
    [fields addObject:@"Top News"];
    [fields addObject:@"World"];
    [fields addObject:@"National"];
    [fields addObject:@"Bay Area News"];
    [fields addObject:@"Politics"];
    [fields addObject:@"Education"];
    [fields addObject:@"Sports"];
    [fields addObject:@"Business & Technology"];
    [fields addObject:@"Cars"];
    [fields addObject:@"Entertainment"];
    [fields addObject:@"Food & Dinning"];
    [fields addObject:@"Mark Morford"];
    [fields addObject:@"Jon Carroll"];
    [fields addObject:@"Giants News"];
    //    [fields addObject:@"City Insider"];
    [fields addObject:@"The Bondage File"];
    [fields addObject:@"The City Exposed"];
    [fields addObject:@"Travel"];
    [fields addObject:@"Home & Garden"];
    [fields addObject:@"Hot Stuff"];
    NSArray *SFCHRONICLE = [[NSArray alloc] initWithObjects: @"SAN FRANCISCO CHRONICLE",fields,nil];
    [self.NewsCategories addObject:SFCHRONICLE];
    [SFCHRONICLE release];
    [fields release];

    
    //    NEW YORK POST
    fields = [[NSMutableArray alloc] initWithCapacity:fieldsLimit];
    [fields addObject:@"All"];
    [fields addObject:@"News"];
    [fields addObject:@"Local News"];
    [fields addObject:@"Business"];
    [fields addObject:@"Entertainment"];
    [fields addObject:@"Fashion"];
    [fields addObject:@"Music"];
    [fields addObject:@"Theater"];
    NSArray *NEWYORKPOST = [[NSArray alloc] initWithObjects: @"NEW YORK POST",fields,nil];
    [self.NewsCategories addObject:NEWYORKPOST];
    [NEWYORKPOST release];
    [fields release];

    
    //    WSJ
    fields = [[NSMutableArray alloc] initWithCapacity:fieldsLimit];
    [fields addObject:@"U.S. Home Page"];
    [fields addObject:@"Politics & Campaign"];
    [fields addObject:@"World"];
    [fields addObject:@"Asia"];
    [fields addObject:@"US Business"];
    [fields addObject:@"Technology"];
    [fields addObject:@"Markets"];
    [fields addObject:@"Lifestyle"];
    NSArray *WSJ = [[NSArray alloc] initWithObjects: @"WALL STREET JOURNAL",fields,nil];
    [self.NewsCategories addObject:WSJ];
    [WSJ release];
    [fields release];

    
    //    USA TODAY
    fields = [[NSMutableArray alloc] initWithCapacity:fieldsLimit];
    [fields addObject:@"TOP HEADLINES"];
    [fields addObject:@"NATIONAL"];
    [fields addObject:@"WASHINGTON"];
    [fields addObject:@"WORLD"];
    [fields addObject:@"RELIGION"];
    [fields addObject:@"EDUCATION"];
    [fields addObject:@"OFFBEAT NEWS"];
    [fields addObject:@"HEALTH"];
    NSArray *USATODAY = [[NSArray alloc] initWithObjects: @"USA TODAY",fields,nil];
    [self.NewsCategories addObject:USATODAY];
    [USATODAY release];
    [fields release];
    
    //    WASHINGTON POST
    fields = [[NSMutableArray alloc] initWithCapacity:fieldsLimit];
    [fields addObject:@"World"];
    [fields addObject:@"National"];
    [fields addObject:@"Politics"];
    [fields addObject:@"Business"];
    [fields addObject:@"Economy"];
    [fields addObject:@"Local"];
    [fields addObject:@"Sports"];
    [fields addObject:@"Entertainment"];
    [fields addObject:@"Lifestyle"];
    [fields addObject:@"Redskins/NFL"];
    NSArray *WASHINGTONPOST = [[NSArray alloc] initWithObjects: @"WASHINGTON POST",fields,nil];
    [self.NewsCategories addObject:WASHINGTONPOST];
    [WASHINGTONPOST release];
    [fields release];
    
    
    //The Atlanta Journal-Constitution
    fields = [[NSMutableArray alloc] initWithCapacity:fieldsLimit];
    [fields addObject:@"Breaking News"];
    [fields addObject:@"Atlanta & South Fulton"];
    [fields addObject:@"Business"];
    [fields addObject:@"Sports"];
    [fields addObject:@"Entertainment"];
    [fields addObject:@"Music"];
    [fields addObject:@"Events"];
    [fields addObject:@"Fashion & Style"];
    [fields addObject:@"Travel"];
    [fields addObject:@"Lifestyle"];
    NSArray *AJC = [[NSArray alloc] initWithObjects: @"THE ATLANTA JOURNAL-CONSTITUTION",fields,nil];
    [self.NewsCategories addObject:AJC];
    [AJC release];
    [fields release];
    
    //CNN
    fields = [[NSMutableArray alloc] initWithCapacity:fieldsLimit];
    [fields addObject:@"CNN News"];
    [fields addObject:@"World"];
    [fields addObject:@"Americas"];
    [fields addObject:@"ASIA"];
    [fields addObject:@"US"];
    [fields addObject:@"Technology"];
    [fields addObject:@"Science"];
    [fields addObject:@"Entertainment"];
    [fields addObject:@"Travel"];
    [fields addObject:@"Sports"];
    NSArray *CNN = [[NSArray alloc] initWithObjects: @"CNN",fields,nil];
    [self.NewsCategories addObject:CNN];
    [CNN release];
    [fields release];
    
    //GOOGLE
    fields = [[NSMutableArray alloc] initWithCapacity:fieldsLimit];
    [fields addObject:@"Google News"];
    [fields addObject:@"World"];
    [fields addObject:@"Business"];
    [fields addObject:@"Technology"];
    [fields addObject:@"Science"];
    [fields addObject:@"Entertainment"];
    [fields addObject:@"Sports"];
    [fields addObject:@"Health"];
    NSArray *GOOGLE = [[NSArray alloc] initWithObjects: @"GOOGLE",fields,nil];
    [self.NewsCategories addObject:GOOGLE];
    [GOOGLE release];
    [fields release];
    
    //FOXNEWS
    fields = [[NSMutableArray alloc] initWithCapacity:fieldsLimit];
    [fields addObject:@"Headlines"];
    [fields addObject:@"US"];
    [fields addObject:@"World"];
    [fields addObject:@"Politics"];
    [fields addObject:@"Opinion"];
    [fields addObject:@"Entertainment"];
    [fields addObject:@"SciTech"];
    [fields addObject:@"Health"];
    [fields addObject:@"Sports"];
    [fields addObject:@"Leisure"];
    NSArray *FOXNEWS = [[NSArray alloc] initWithObjects: @"FOX NEWS",fields,nil];
    [self.NewsCategories addObject:FOXNEWS];
    [FOXNEWS release];
    [fields release];
    
    //HEADLINES
    fields = [[NSMutableArray alloc] initWithCapacity:fieldsLimit];
    [fields addObject:@"LA Times"];
    [fields addObject:@"USA Today"];
    [fields addObject:@"Chicago Tribune"];
    [fields addObject:@"New York Post"];
    [fields addObject:@"Yahoo!"];
    [fields addObject:@"San Francisco Chronicle"];
    
    NSArray *HEADLINES = [[NSArray alloc] initWithObjects: @"HEADLINES",fields,nil];
    [self.NewsCategories addObject:HEADLINES];
    [HEADLINES release];
    [fields release];
    
    //MOST VIEWED
    fields = [[NSMutableArray alloc] initWithCapacity:fieldsLimit];
    [fields addObject:@"LA Times"];
    [fields addObject:@"Guardian"];
    [fields addObject:@"Forbes.com"];
    [fields addObject:@"Wall Street Journal"];
    NSArray *MOSTVIEWED = [[NSArray alloc] initWithObjects: @"MOST VIEWED",fields,nil];
    [self.NewsCategories addObject:MOSTVIEWED];
    [MOSTVIEWED release];
    [fields release];

    
    //WORLD
    fields = [[NSMutableArray alloc] initWithCapacity:fieldsLimit];
    [fields addObject:@"New York Times"];
    [fields addObject:@"Yahoo!"];
    [fields addObject:@"LA Times"];
    [fields addObject:@"Wall Street Journal"];
    [fields addObject:@"USA Today"];
    [fields addObject:@"BBC"];
    [fields addObject:@"Washington Post"];
    NSArray *WORLD = [[NSArray alloc] initWithObjects: @"WORLD",fields,nil];
    [self.NewsCategories addObject:WORLD];
    [WORLD release];
    [fields release];
    
    //U.S.
    fields = [[NSMutableArray alloc] initWithCapacity:fieldsLimit];
    [fields addObject:@"LA Times"];
    [fields addObject:@"Yahoo!"];
    [fields addObject:@"San Francisco Chronicle"];
    [fields addObject:@"New York Times"];
    [fields addObject:@"Wall Street Journal"];
    [fields addObject:@"Chicago Tribune"];
    [fields addObject:@"CNN"];
    
    NSArray *US = [[NSArray alloc] initWithObjects: @"U.S.",fields,nil];
    [self.NewsCategories addObject:US];
    [US release];
    [fields release];
    
    //POLITICS
    fields = [[NSMutableArray alloc] initWithCapacity:fieldsLimit];
    [fields addObject:@"New York Times"];
    [fields addObject:@"Yahoo!"];
    [fields addObject:@"LA Times"];
    [fields addObject:@"Wall Street Journal"];
    [fields addObject:@"USA Today"];
    [fields addObject:@"New York Post"];
    [fields addObject:@"BBC News"];
    [fields addObject:@"Washington Post"];
    [fields addObject:@"ABC News"];
    [fields addObject:@"The Politic"];
    NSArray *POLITICS = [[NSArray alloc] initWithObjects: @"POLITICS",fields,nil];
    [self.NewsCategories addObject:POLITICS];
    [POLITICS release];
    [fields release];
    
    //BUSINESS
    fields = [[NSMutableArray alloc] initWithCapacity:fieldsLimit];
    [fields addObject:@"Business Insider"];
    [fields addObject:@"LA Times"];
    [fields addObject:@"Chicago Tribune"];
    [fields addObject:@"BBC"];
    [fields addObject:@"Yahoo!"];
    [fields addObject:@"New York Times"];
    [fields addObject:@"Washington Post"];
    
    NSArray *BUSINESS = [[NSArray alloc] initWithObjects: @"BUSINESS",fields,nil];
    [self.NewsCategories addObject:BUSINESS];
    [BUSINESS release];
    [fields release];
    
    
    //EDUCATION
    fields = [[NSMutableArray alloc] initWithCapacity:fieldsLimit];
    [fields addObject:@"New York Times"];
    [fields addObject:@"Yahoo!"];
    [fields addObject:@"Washington Post"];
    [fields addObject:@"LA Times"];
    [fields addObject:@"USA Today"];
    NSArray *EDUCATION = [[NSArray alloc] initWithObjects: @"EDUCATION",fields,nil];
    [self.NewsCategories addObject:EDUCATION];
    [EDUCATION release];
    [fields release];
    
    //TECHNOLOGY
    fields = [[NSMutableArray alloc] initWithCapacity:fieldsLimit];
    [fields addObject:@"Yahoo!"];
    [fields addObject:@"Yahoo! - Internet"];
    [fields addObject:@"CNET - Reviews"];
    [fields addObject:@"LA Times"];
    [fields addObject:@"New York Times"];
    [fields addObject:@"Techmeme"];
    [fields addObject:@"USA Today"];
    [fields addObject:@"CNET - Computer System"];
    [fields addObject:@"CNET - Laptops"];
    [fields addObject:@"CNET - Desktops"];
//    [fields addObject:@"CNET - Digital Cameras"];
//    [fields addObject:@"CNET - Handheld Devices"];
//    [fields addObject:@"CNET - Portable Audio"];
//    [fields addObject:@"CNET - Camcoders"];
//    [fields addObject:@"CNET - Video Player"];
//    [fields addObject:@"CNET - Cell Phones"];
//    [fields addObject:@"CNET - Software"];
//    [fields addObject:@"CNET - Home Audio"];
//    [fields addObject:@"CNET - Networking and Wireless"];
//    [fields addObject:@"CNET - Peripherals"];
//    [fields addObject:@"CNET - Car Tech"];
//    [fields addObject:@"CNET - GPS"];
//    [fields addObject:@"CNET - Games and Gear"];

    [fields addObject:@"New York Times"];
    [fields addObject:@"LA Times"];
    NSArray *TECHNOLOGY = [[NSArray alloc] initWithObjects: @"TECHNOLOGY",fields,nil];
    [self.NewsCategories addObject:TECHNOLOGY];
    [TECHNOLOGY release];
    [fields release];
    
    //SPORTS
    fields = [[NSMutableArray alloc] initWithCapacity:fieldsLimit];
    [fields addObject:@"Yahoo!"];
    [fields addObject:@"Chicago Tribune"];
    [fields addObject:@"LA Times"];
    [fields addObject:@"New York Times"];
    [fields addObject:@"USA Today"];
    [fields addObject:@"The Atlanta Journal"];
    [fields addObject:@"ESPN Toplines"];
    [fields addObject:@"ESPN NFL"];
    [fields addObject:@"ESPN NBA"];
    [fields addObject:@"ESPN MLB"];
    [fields addObject:@"ESPN NHL"];
    [fields addObject:@"College Basketball"];


    NSArray *SPORTS = [[NSArray alloc] initWithObjects: @"SPORTS",fields,nil];
    [self.NewsCategories addObject:SPORTS];
    [SPORTS release];
    [fields release];
    
    //SCIENCE
    fields = [[NSMutableArray alloc] initWithCapacity:fieldsLimit];
    [fields addObject:@"LA Times"];
    [fields addObject:@"National Geographic News"];
    [fields addObject:@"Yahoo!"];
    [fields addObject:@"New York Times"];
    [fields addObject:@"USA Today"];
    [fields addObject:@"NASA Science"];
    [fields addObject:@"NASA Earth Observatory"];
    [fields addObject:@"BBC News"];
    
    NSArray *SCIENCE = [[NSArray alloc] initWithObjects: @"SCIENCE",fields,nil];
    [self.NewsCategories addObject:SCIENCE];
    [SCIENCE release];
    [fields release];
    
    //HEALTH
    fields = [[NSMutableArray alloc] initWithCapacity:fieldsLimit];
    [fields addObject:@"New York Times"];
    [fields addObject:@"LA Times"];
    [fields addObject:@"Yahoo!"];
    [fields addObject:@"Chicago Tribune"];
    [fields addObject:@"BBC News"];
    [fields addObject:@"USA Today"];
    NSArray *HEALTH = [[NSArray alloc] initWithObjects: @"HEALTH",fields,nil];
    [self.NewsCategories addObject:HEALTH];
    [HEALTH release];
    [fields release];
    
    //ARTS
    fields = [[NSMutableArray alloc] initWithCapacity:fieldsLimit];
    [fields addObject:@"New York Times"];
    [fields addObject:@"LA Times"];
    [fields addObject:@"Chicago Tribune"];
    [fields addObject:@"Yahoo!"];
    NSArray *ARTS = [[NSArray alloc] initWithObjects: @"ARTS",fields,nil];
    [self.NewsCategories addObject:ARTS];
    [ARTS release];
    [fields release];
        
    
    //TRAVEL
    fields = [[NSMutableArray alloc] initWithCapacity:fieldsLimit];
    [fields addObject:@"Chicago Tribune"];
    [fields addObject:@"New York Times"];
    [fields addObject:@"LA Times"];
    [fields addObject:@"The Atlanta Journal"];
    NSArray *TRAVEL = [[NSArray alloc] initWithObjects: @"TRAVEL",fields,nil];
    [self.NewsCategories addObject:TRAVEL];
    [TRAVEL release];
    [fields release];


    //MAGAZINE
    fields = [[NSMutableArray alloc] initWithCapacity:fieldsLimit];
    [fields addObject:@"New York Times"];
    NSArray *MAGAZINE = [[NSArray alloc] initWithObjects: @"MAGAZINE",fields,nil];
    [self.NewsCategories addObject:MAGAZINE];
    [MAGAZINE release];
    [fields release];
    
    //JOBS
    fields = [[NSMutableArray alloc] initWithCapacity:fieldsLimit];
    [fields addObject:@"New York Times"];
    [fields addObject:@"Wall Street Journal"];
    [fields addObject:@"New York Post"];
    [fields addObject:@"Chicago Tribune"];
    NSArray *JOBS = [[NSArray alloc] initWithObjects: @"JOBS",fields,nil];
    [self.NewsCategories addObject:JOBS];
    [JOBS release];
    [fields release];
    
    //ENTERTAINMENT
    fields = [[NSMutableArray alloc] initWithCapacity:fieldsLimit];
    [fields addObject:@"New York Post"];
    [fields addObject:@"Chicago Tribune"];
    [fields addObject:@"Yahoo!"];
    [fields addObject:@"Yahoo! - Movies"];
    [fields addObject:@"Yahoo! - Odd News"];
    [fields addObject:@"Yahoo! - Music"];
    [fields addObject:@"USA Today"];
    
    [fields addObject:@"The Atlanta Journal"];
    NSArray *ENTERTAINMENT = [[NSArray alloc] initWithObjects: @"ENTERTAINMENT",fields,nil];
    [self.NewsCategories addObject:ENTERTAINMENT];
    [ENTERTAINMENT release];
    [fields release];
    
    
    //FASHIONNNN
    fields = [[NSMutableArray alloc] initWithCapacity:fieldsLimit];
    [fields addObject:@"InStyle.com"];
    [fields addObject:@"Chicago Tribune"];
    [fields addObject:@"Yahoo!"];
    [fields addObject:@"myStyle"];
    [fields addObject:@"Style Scene"];
    [fields addObject:@"New York Times"];
    [fields addObject:@"Wall Street Journal"];
    [fields addObject:@"The Atlanta Journal"];

    NSArray *FASHION = [[NSArray alloc] initWithObjects: @"FASHION",fields,nil];
    [self.NewsCategories addObject:FASHION];
    [FASHION release];
    [fields release];
    

    
    //BLOG
    fields = [[NSMutableArray alloc] initWithCapacity:fieldsLimit];
    [fields addObject:@"Americas view"];
    [fields addObject:@"Babbage"];
    [fields addObject:@"Bagehot's notebook"];
    [fields addObject:@"Banyan's notebook"];
    [fields addObject:@"Baobab"];
    [fields addObject:@"Blighty"];
    [fields addObject:@"Buttonwood's notebook"];
    [fields addObject:@"Charlemagne's notebook"];
    [fields addObject:@"Clausewitz"];
    [fields addObject:@"Democracy in America"];
    [fields addObject:@"Eastern approaches"];
    [fields addObject:@"Free exchange"];
    [fields addObject:@"Global leadership"];
    [fields addObject:@"Graphic detail"];
    [fields addObject:@"Gulliver"];
    [fields addObject:@"Johnson"];
    [fields addObject:@"Leviathan"];
    [fields addObject:@"Lexington's notebook"];
    [fields addObject:@"Multimedia"];
    [fields addObject:@"Newsbook"];
    [fields addObject:@"Prospero"];
    [fields addObject:@"Schumpeter's notebook"];
    NSArray *BLOG = [[NSArray alloc] initWithObjects: @"BLOG",fields,nil];
    [self.NewsCategories addObject:BLOG];
    [BLOG release];
    [fields release];




    


    
    



    
    

    
    //Deep Copy NewsCategories
    CopyOfNewsCategories = [self deepCopyNewsCatgorie:NewsCategories];
//    CopyOfNewsCategories = [[NSMutableArray alloc] initWithArray:NewsCategories copyItems:YES];
    
    
    
    //    NSData *archive = [NSPropertyListSerialization dataWithPropertyList:NewsCategories format:NSPropertyListBinaryFormat_v1_0 options:0 error:NULL];	
//    CopyOfNewsCategories = [NSPropertyListSerialization propertyListWithData:archive options:NSPropertyListMutableContainers format:NULL error:NULL];

    
//    NSLog(@"The number of objects in NewsCategories is : %d",[NewsCategories count]);
    //    Testing:
//    NSLog(@"---%@---", [[self.NewsCategories objectAtIndex:1] objectAtIndex:0]);
    
//    for (int i=0;i<[self.CopyOfNewsCategories count];i++)
//    {
//        NSLog(@"---%@---", [[self.CopyOfNewsCategories objectAtIndex:i] objectAtIndex:0]);
//        for(int j=0;j<[[[self.CopyOfNewsCategories objectAtIndex:i] objectAtIndex:1] count];j++)
//        {
//            NSLog([[[self.NewsCategories objectAtIndex:i] objectAtIndex:1] objectAtIndex:j]);
//        }
//    }

}

- (NSMutableArray *)deepCopyNewsCatgorie:(NSMutableArray *)originalArray
{
//    NSLog(@"Deep Copying");
    NSMutableArray *copiedItem = [[NSMutableArray alloc] initWithCapacity:[originalArray count]];
    for(int i=0;i<[originalArray count];i++)
    {
        NSArray *arrayWithTwoElements;

            NSString *site = [[NSString alloc] initWithString:[[originalArray objectAtIndex:i]objectAtIndex:0]]; 
            NSMutableArray *sections = [[NSMutableArray alloc] initWithCapacity:[[originalArray objectAtIndex:i]objectAtIndex:1]];
            for(int k=0;k<[[[originalArray objectAtIndex:i]objectAtIndex:1]count];k++)
            {
                NSString *temp = [[NSString alloc] initWithString:[[[originalArray objectAtIndex:i]objectAtIndex:1]objectAtIndex:k]];
                [sections addObject:temp];
                [temp release];
            }
            arrayWithTwoElements = [[NSArray alloc] initWithObjects:site,sections, nil];
            [site release];
            [sections release];
        
        [copiedItem addObject:arrayWithTwoElements];
        [arrayWithTwoElements release];
        
    }
    return copiedItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    //App Configiration
    enableADCountDown = YES;
    //////
    
    isInWaveForm = YES;
//    revealController.counter = 10;
    
    [tabBar setSelectedItem:TabOfWaveForm];

    [self setupDatabase];
    [self setupNewsTobeDisplayed];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
//    self.tableView.frame = CGRectMake(0, 0, 320, 433);
//    [self.tableView removeFromSuperview];
    navigator.frame = CGRectMake(0,385,320,30);
    navigator.contentSize = CGSizeMake(807,30);
//    [self.view addSubview:navigator];

    UIImageView* backgroundImage = [[UIImageView alloc] initWithFrame:self.navigationController.navigationBar.frame];
    backgroundImage.image = [UIImage imageNamed:@"homeNav.png"];
    
    backgroundImage.contentMode = UIViewContentModeLeft;
    
//    [self.navigationController.navigationItem.titleView addSubview:[[UIImageView alloc] initWithImage: [UIImage imageNamed:@"homeNavNaked.png"]]];
    
//    [self.navigationController.navigationBar insertSubview:backgroundImage atIndex:0];
    
    [self.navigationController.navigationBar setBackgroundImage:backgroundImage.image forBarMetrics:UIBarMetricsDefault];
    [backgroundImage release];
    
    
    self.navigationController.navigationBar.layer.shadowColor = [UIColor blackColor].CGColor;
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0, 1);
    self.navigationController.navigationBar.layer.shadowOpacity = 1;
    self.navigationController.navigationBar.layer.shadowRadius = 2.0;
    
    



    
    
    currentSite = @"LOS ANGELES TIMES";
    isRefreshing = NO;
    
    
    
    
    [self displayNews];
//    UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonSystemItemAction target:self action:@selector(homeButtonAction)];
    //    self.navigationItem.leftBarButtonItem = homeButton;
    
    
    UIButton *button2 =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setImage:[UIImage imageNamed:@"saveInact.png"] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(gotoHome:) forControlEvents:UIControlEventTouchUpInside];
    [button2 setFrame:CGRectMake(2, 2, 28, 28)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button2];
    
    
//    NSLog(@"Testing");
//    NSString *a = @"Hello";
//    NSString *b = [[NSString alloc] initWithString:a];
//    b = @"Max";
//    NSLog(a);
//    NSLog(b);
    
//    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:tabBar.frame];
//    loadingLabel.backgroundColor = [UIColor blueColor];
//    [self.view addSubview:loadingLabel];
    

    

}




- (void)homeButtonAction
{
    OpenFlowViewController *openFlowViewController = [[OpenFlowViewController alloc] init];
    openFlowViewController.viewController = self;
    [self.navigationController pushViewController:openFlowViewController animated:YES];
    [openFlowViewController release];
//    NSLog(@"Pressed");
}

- (void)displayNews
{
    TabOfTableForm.enabled = NO;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
//    self.title = currentSite;
    newsContentsDic = [[NSMutableDictionary alloc] initWithCapacity:sitesLimit];

    isRefreshing = YES;
//    NSLog(@"Now isRefreshing has been set to YES");
    isloading = YES;
    RSSParser *rss = [[RSSParser alloc] init];
    NSMutableArray *currentNewsContents =[[NSMutableArray alloc] initWithCapacity:fieldsLimit];
    NSArray *sectionNamesArray;
    for(int i=0;i<[self.CopyOfNewsCategories count];i++)
    {
        if([[[self.CopyOfNewsCategories objectAtIndex:i]objectAtIndex:0] isEqual:currentSite])
        {
            sectionNamesArray = [[self.CopyOfNewsCategories objectAtIndex:i]objectAtIndex:1];
            //                break;
        }
    }
    downloadQueue = dispatch_queue_create("img downloader",NULL);
    dispatch_async(downloadQueue, ^{
        dispatch_async(dispatch_get_main_queue(),^{
            [tableView reloadData];
            for(int i =0;i<[sectionNamesArray count];i++)
            {
                [tableView reloadSections:[NSIndexSet indexSetWithIndex:2*i] withRowAnimation:UITableViewRowAnimationNone]; 
            }
        });
        BOOL loaded = NO;
        if([OffLineMode getStoredNews:currentSite withSection:[sectionNamesArray objectAtIndex:0]]!=nil)
        {
//            NSLog(@"No Internet Connection!");
            for(int i=0;i<[sectionNamesArray count];i++)
            {
               self.newsList = [OffLineMode getStoredNews:currentSite withSection:[sectionNamesArray objectAtIndex:i]];
                //                if(self.newsList==nil)
                //                    break;
                
                if(self.newsList)
                {
//                    NSLog(@"Loading local data");
//                    [currentNewsContents addObject:self.newsList];
                    if([currentNewsContents count]<=i)
                    {
//                        [currentNewsContents insertObject:self.newsList atIndex:i];
                        [currentNewsContents addObject:self.newsList];
                    }
                    else
                    {
                        [currentNewsContents replaceObjectAtIndex:i withObject:self.newsList];
                    }
                    [newsContentsDic setObject:currentNewsContents forKey:currentSite];
                }
                dispatch_async(dispatch_get_main_queue(),^{
//                    NSLog(@"Now reloading main table");
                    if([OffLineMode isConnected])
                    {
                        isloading = YES;
                    }
                    else
                        isloading = NO;
                    [tableView reloadSections:[NSIndexSet indexSetWithIndex:2*i+1] withRowAnimation:UITableViewRowAnimationNone]; 
                    [tableView reloadSections:[NSIndexSet indexSetWithIndex:2*i] withRowAnimation:UITableViewRowAnimationNone]; 
                });
            }
            loaded = YES;
            isloading = YES;
        }        
        
        if([OffLineMode isConnected])
        {
            //remove the currentNewsContents
            for(int i=0;i<[sectionNamesArray count];i++)
            {
                self.newsList =[rss getRssRawData:[[database objectForKey:currentSite] objectForKey:[sectionNamesArray objectAtIndex:i]] newspaper:currentSite section:[sectionNamesArray objectAtIndex:i]];

                if(self.newsList && loaded)
                {
                    if([currentNewsContents count]<=i)
                    {
                        [currentNewsContents insertObject:self.newsList atIndex:i];
                    }
                    else
                    {
                        [currentNewsContents replaceObjectAtIndex:i withObject:self.newsList];
                    }
                    [newsContentsDic setObject:currentNewsContents forKey:currentSite];
                    
                    dispatch_async(dispatch_get_main_queue(),^{
                        isloading = NO;
                        
                        [tableView reloadSections:[NSIndexSet indexSetWithIndex:2*i] withRowAnimation:UITableViewRowAnimationMiddle]; 
                        [tableView reloadSections:[NSIndexSet indexSetWithIndex:2*i+1] withRowAnimation:UITableViewRowAnimationMiddle]; 
//                        NSLog(@"Now reloading section %d",i);
                    });
                }
                else
                {
                    [currentNewsContents addObject:self.newsList];
                    [newsContentsDic setObject:currentNewsContents forKey:currentSite];
                    dispatch_async(dispatch_get_main_queue(),^{
//                        NSLog(@"Now reloading section %d",i);
                        isloading = NO;
                        [tableView reloadSections:[NSIndexSet indexSetWithIndex:2*i] withRowAnimation:UITableViewRowAnimationBottom];                         
                        [tableView reloadSections:[NSIndexSet indexSetWithIndex:2*i+1] withRowAnimation:UITableViewRowAnimationBottom];                         
                    });
                }
            }
            //            dispatch_async(dispatch_get_main_queue(),^{
            //                NSLog(@"Now reloading main table");
            //                [tableView reloadData];
            //                [self stopLoading];
            //            });
//            NSLog(@"Now in the newsContentsDic there are %d objects", [newsContentsDic count]);
//            NSLog(@"Now in the newsContentsDic's currentSite array there are %d objects", [[newsContentsDic objectForKey:currentSite] count]);        
        } 
        isRefreshing = NO;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//        [UIApplication sharedApplication].statusBarHidden = YES;
//        NSLog(@"Now isRefreshing has been set to NO");
//        NSLog(isRefreshing);
        dispatch_async(dispatch_get_main_queue(),^{
            TabOfTableForm.enabled = YES;
        });

        

    });   
    dispatch_release(downloadQueue);
    
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setHeaderCell:nil];
    [self setNavigation:nil];
    [self setNavigator:nil];
    [self setBakImgView:nil];
    [self setContentView:nil];

    [self setNavigator:nil];
    [self setTabBar:nil];
    [self setTabOfWaveForm:nil];
    [self setTabOfTableForm:nil];
    [self setTableFormCell:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
//	self.title = NSLocalizedString(@"Front View", @"FrontView");
//    self.title = currentSite;
	
	if ([self.navigationController.parentViewController respondsToSelector:@selector(revealGesture:)] && [self.navigationController.parentViewController respondsToSelector:@selector(revealToggle:)])
	{
		// Check if a UIPanGestureRecognizer already sits atop our NavigationBar.
		if (![[self.navigationController.navigationBar gestureRecognizers] containsObject:self.navigationBarPanGestureRecognizer])
		{
			// If not, allocate one and add it.
			UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
			self.navigationBarPanGestureRecognizer = panGestureRecognizer;
			[panGestureRecognizer release];
			
			[self.navigationController.navigationBar addGestureRecognizer:self.navigationBarPanGestureRecognizer];
		}
		
		// Check if we have a revealButton already.
		if (![self.navigationItem leftBarButtonItem])
		{
			// If not, allocate one and add it.
			UIBarButtonItem *revealButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Reveal", @"Reveal") style:UIBarButtonItemStylePlain target:self.navigationController.parentViewController action:@selector(revealToggle:)];
//			self.navigationItem.leftBarButtonItem = revealButton;
            
            
            UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:@"ButtonMenu.png"] forState:UIControlStateNormal];
            [button addTarget:self.navigationController.parentViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
            [button setFrame:CGRectMake(2, 2, 28, 28)];
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];

            
            
			[revealButton release];
		}
	}
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];



}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    NSArray *sectionNamesArray;
    for(int i=0;i<[self.CopyOfNewsCategories count];i++)
    {
        if([[[self.CopyOfNewsCategories objectAtIndex:i]objectAtIndex:0] isEqual:currentSite])
        {
            sectionNamesArray = [[self.CopyOfNewsCategories objectAtIndex:i]objectAtIndex:1];
            //                break;
        }
    }

    if(isInWaveForm)
    {
        
        //    NSLog(@"The numberOfSectionsInTableView has been called. There are %d sections now", 2*[sectionNamesArray count]);
        return 2*[sectionNamesArray count] ;
    }
    else
    {
//        NSLog(@"In Table-form, there are %d sections", [sectionNamesArray count]);
        return [sectionNamesArray  count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(isInWaveForm)
    {
        return 1;
    }
    else
    {
//        NSLog(@"In Table form, there are %d rows in section %d",[[[newsContentsDic objectForKey:currentSite] objectAtIndex:section] count], section );
        return [[[newsContentsDic objectForKey:currentSite] objectAtIndex:section] count];
    }
    // Return the number of rows in the section.
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(isInWaveForm==NO)
    {
        // create the parent view that will hold header Label
        UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 320, 30)];
        
        // create the button object
        UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        headerLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"button2(2).jpg"]];	
//        headerLabel.backgroundColor =[UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:238.0/255.0 alpha:1];
        headerLabel.opaque = YES;
        headerLabel.alpha = 1;
        headerLabel.textColor = [UIColor whiteColor];
        headerLabel.highlightedTextColor = [UIColor whiteColor];
        headerLabel.font = [UIFont boldSystemFontOfSize:14];
        headerLabel.frame = CGRectMake(5, 0.0, 320, 30);
        headerLabel.autoresizingMask=UIViewAutoresizingFlexibleWidth;

        headerLabel.layer.cornerRadius = 5;
        // If you want to align the header text as centered
        // headerLabel.frame = CGRectMake(150.0, 0.0, 300.0, 44.0);
        //    NSString *title = [@"  " stringByAppendingString:[self.HeaderTitles objectAtIndex:section]];
        NSArray *sectionNamesArray;
        for(int i=0;i<[self.CopyOfNewsCategories count];i++)
        {
            if([[[self.CopyOfNewsCategories objectAtIndex:i]objectAtIndex:0] isEqual:currentSite])
            {
                sectionNamesArray = [[self.CopyOfNewsCategories objectAtIndex:i]objectAtIndex:1];
                //                break;
            }
        }

        
        
        NSString *HeaderTitle;
        HeaderTitle = [sectionNamesArray objectAtIndex:section];
//        NSLog(@"############The HeaderTItle is : %@", HeaderTitle);
//        headerLabel.text = HeaderTitle; // i.e. array element
        UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 20)];
        text.textColor = [UIColor whiteColor];
        text.text = HeaderTitle;
        text.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:16];
        text.backgroundColor = [UIColor clearColor];
        [headerLabel addSubview:text];
        [text.superview setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.4]];
        
        [customView addSubview:headerLabel];
        return customView;
    }
    else
        return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(isInWaveForm==NO)
        return 20.0;
    else
        return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    if(isInWaveForm)
    {
        TableViewCell *cell;
        static NSString *CellIdentifier1 = @"CellWithTableView";
        static NSString *CellIdentifier2 = @"HeaderCell";
        if(indexPath.section%2==1)
        {
            NSInteger *realSectionNumber = (indexPath.section-1)/2;
            
            cell = (TableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
            
            if (cell == nil) {
                //if the dic is not loaded
                if([[newsContentsDic objectForKey:currentSite] count] <= realSectionNumber)
                {
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"emptyCell"] autorelease];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
                [[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:self options:nil];
                CGAffineTransform rotateTable = CGAffineTransformMakeRotation(-M_PI_2);
                tableViewCellWithTableView.tableViewInsideCell.transform = rotateTable;
                tableViewCellWithTableView.tableViewInsideCell.frame = CGRectMake(0, 0,
                                                                                  tableViewCellWithTableView.tableViewInsideCell.frame.size.width,
                                                                                  tableViewCellWithTableView.tableViewInsideCell.frame.size.height);
                //            NSLog(@"Reload section %d", realSectionNumber);
                tableViewCellWithTableView.data = [[newsContentsDic objectForKey:currentSite] objectAtIndex:realSectionNumber];
                tableViewCellWithTableView.tableViewInsideCell.allowsSelection = YES;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell = tableViewCellWithTableView;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor lightGrayColor];
                cell.intOfRowForTagOfTheButton = realSectionNumber;
                cell.viewController = self;
                [cell setNeedsDisplay];
            }
        }
        else
        {
            NSArray *sectionNamesArray;
            for(int i=0;i<[self.CopyOfNewsCategories count];i++)
            {
                if([[[self.CopyOfNewsCategories objectAtIndex:i]objectAtIndex:0] isEqual:currentSite])
                {
                    sectionNamesArray = [[self.CopyOfNewsCategories objectAtIndex:i]objectAtIndex:1];
                    //                break;
                }
            }
            
            NSInteger *realSectionNumber = indexPath.section/2;
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2] autorelease];
            cell.frame = CGRectMake(0, 0, 320, 20);
            //        cell.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            cell.textLabel.text = [sectionNamesArray objectAtIndex:realSectionNumber] ;
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.textLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:16];
            
            
            
            if(isloading == YES)
            {
                UIActivityIndicatorView* activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
                [activity startAnimating];
                [cell setAccessoryView: activity];
                //    [cell.contentView addSubview:activity];
                [activity release];
            }
        }
        return cell;

    }
    else
    {
        static NSString *CellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }

        UIColor *thisCellColor;
        
        UIColor *viewColor=[[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1] retain];
        UIColor *viewColor2=[[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1] retain];

        if(([indexPath section]+[indexPath row])%2==0)
        {
            thisCellColor=viewColor;
        }
        else
        {
            thisCellColor=viewColor2;
        }
        
        [cell setBackgroundColor:thisCellColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

//        [(UITableView *)self.view setSeparatorColor:[UIColor clearColor]];

        for(UIView *view in cell.contentView.subviews)
        {
            [view removeFromSuperview];
        }
        
        NSDictionary *curNews=[[[newsContentsDic objectForKey:currentSite] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
        int title_x=5, title_y=5, date_x=5, date_y=75, image_x=0, image_y=0;
        int title_width=300, title_height=60;

        if(self.interfaceOrientation == UIInterfaceOrientationPortrait)
        {
            int title_width=300, title_height=60;
        }
        else
        {
            int title_width=450, title_height=60;
        }
        int date_width=30, date_height=2;
        int image_width=65, image_height=60;
        
//        if([[curNews objectForKey:@"media"] count]==0)
//        {
//            title_x=5;
//            date_x=5;
//        }
//        else
//        {
            title_x=85;
            date_x=85;
            title_width-=85;
            
            image_x=10;
            image_y=10;
//        }
        
        //title
        //UILabel *titleLabel=[[[UILabel alloc] initWithFrame:titleFrame] autorelease];
        UILabel *titleLabel=[[[UILabel alloc] initWithFrame:CGRectMake(title_x, title_y, cell.frame.size.width-90, title_height)] autorelease];
        titleLabel.font=[UIFont fontWithName:@"Arial" size:16.0];
        titleLabel.backgroundColor=[UIColor clearColor];
        titleLabel.textAlignment=UITextAlignmentLeft;
        titleLabel.numberOfLines=3;
        titleLabel.baselineAdjustment=UIBaselineAdjustmentNone;
        titleLabel.textColor=[UIColor whiteColor];
        titleLabel.adjustsFontSizeToFitWidth=FALSE;
        titleLabel.lineBreakMode=UILineBreakModeTailTruncation;
        titleLabel.text=[curNews objectForKey:@"title"];
        titleLabel.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [cell.contentView addSubview:titleLabel];
//        [titleLabel release];
        
        UILabel *authorLabel=[[[UILabel alloc] initWithFrame:CGRectMake(date_x, date_y, date_width, date_height)] autorelease];
        authorLabel.font=[UIFont systemFontOfSize:6];
        authorLabel.backgroundColor=[UIColor whiteColor];
        authorLabel.textAlignment=UITextAlignmentLeft;
        authorLabel.textColor=[UIColor blueColor];
//        authorLabel.text=[curNews objectForKey:@"author"];
        [cell.contentView addSubview:authorLabel];


        //image
        UIImageView *labelImage=[[[UIImageView alloc] initWithFrame:CGRectMake(image_x, image_y, image_width, image_height)] autorelease];
        if([[curNews objectForKey:@"media"] count]!=0)
        {
            //UIImageView *lableImage=[[[UIImageView alloc] initWithFrame:imageFrame] autorelease];

            
            //improve
            NSArray *urls=[curNews objectForKey:@"media"];
            
            NSURL *tempUrl=[NSURL URLWithString:[urls objectAtIndex:0]];
            
//            NSLog(@"AAAAAAAAAAAAAAAAA");
            
            [labelImage setImageWithURL:tempUrl placeholderImage:[UIImage imageNamed:@"black.jpg"]];
            
            
        }
        else
        {
            [labelImage setImage:[UIImage imageNamed:@"logo-2.png"]];
        }
        [cell.contentView addSubview:labelImage];
//        [curNews release];
//        [labelImage release];

        
        
        return cell;
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    display = [[AbsDisplay alloc] init];
    display.newsInfo = [[[newsContentsDic objectForKey:currentSite] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    //    display.parentView = self;
    //    ViewController *viewCon = [[ViewController alloc] init];
    display.viewController = self;
    [self.navigationController pushViewController:display animated:YES];
}
- (IBAction)navigationPressed:(UIButton *)sender {
    
//    NSLog(sender.currentTitle);
    NSString *pic = [NSString stringWithFormat:@"%@.jpg",sender.currentTitle];
    UIImage *image = [UIImage imageNamed:pic];
    [UIView animateWithDuration:YES ? 1.7 : 0.0 animations:^{
//        [bakImgView setImage:image];

        [bakImgView setAlpha:0.0];
        [bakImgView setImage:image];
        [bakImgView setAlpha:1.0];
    }];
}



- (void)buttonPressed:(id)sender
{
    if(enableADCountDown)
    {
        revealController.counter--;

    }
    if(enableADCountDown && revealController.counter <=0 && revealController.ADisLoaded)
    {
//        NSLog(@"Click the AD below to continue");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Like the app?"
                                                        message:@"Support the app by tapping the Ad below to continue viewing news."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: @"Buy",nil];
        [alert show];
        [alert release];

    }
    else
    {
//        NSLog(@"Now counter = %d",revealController.counter);
        //    NSLog(@"The tag is %d", [sender tag]);
        NSInteger *row = [sender tag]/(NSInteger)100;
        NSInteger *column = [sender tag]%100;
        
        display = [[AbsDisplay alloc] init];
        display.newsInfo = [[[newsContentsDic objectForKey:currentSite] objectAtIndex:row] objectAtIndex:column];
        //    display.parentView = self;
        //    ViewController *viewCon = [[ViewController alloc] init];
        display.viewController = self;
        [self.navigationController pushViewController:display animated:YES];

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(isInWaveForm)
    {
        if(indexPath.section%2==1)
            return 100;
        else
            return 30;
    }
    else
    {
        return 80;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        UIImageView* backgroundImage = [[UIImageView alloc] initWithFrame:self.navigationController.navigationBar.frame];
        backgroundImage.image = [UIImage imageNamed:@"navHomeRot.png"];
        
        backgroundImage.contentMode = UIViewContentModeLeft;
        
        
        //    [self.navigationController.navigationBar insertSubview:backgroundImage atIndex:0];
        
        [self.navigationController.navigationBar setBackgroundImage:backgroundImage.image forBarMetrics:UIBarMetricsDefault];
        [backgroundImage release];

    }
    if(toInterfaceOrientation == UIInterfaceOrientationPortrait)
    {
        UIImageView* backgroundImage = [[UIImageView alloc] initWithFrame:self.navigationController.navigationBar.frame];
        backgroundImage.image = [UIImage imageNamed:@"homeNav.png"];
        
        backgroundImage.contentMode = UIViewContentModeLeft;
        
        
        //    [self.navigationController.navigationBar insertSubview:backgroundImage atIndex:0];
        
        [self.navigationController.navigationBar setBackgroundImage:backgroundImage.image forBarMetrics:UIBarMetricsDefault];
        [backgroundImage release];

    }
}

- (void)dealloc {
    [tableView release];
    [headerCell release];
//    [navigator release];
    [bakImgView release];
    [_contentView release];
    [navigator release];
    [tabBar release];
    [TabOfWaveForm release];
    [TabOfTableForm release];
    [TableFormCell release];
    [super dealloc];
}

- (void)refresh
{
//    NSLog(@"local refresh has been called");
//    if(isInWaveForm)
//    {
//        NSLog(@"Now it's in wave form");
//    }
    if(isRefreshing == NO && isInWaveForm)
    {
//        NSLog(@"refreshing has been executed");
        CopyOfNewsCategories = [self deepCopyNewsCatgorie:NewsCategories];
        [self performSelector:@selector(displayNews) withObject:nil afterDelay:1.0];
        [self stopLoading];

//        [self displayNews];
    } 
    else
    {
        self.stopLoading;
    }
}



#pragma mar - click button
-(IBAction) gotoHome:(id) sender
{
    savedNews=[[SavedNews alloc] init];
    
    [self.navigationController pushViewController:savedNews animated:YES];
}






@end
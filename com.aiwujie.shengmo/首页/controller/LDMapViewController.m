//
//  LDMapViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 16/12/22.
//  Copyright © 2016年 a. All rights reserved.
//

#import "LDMapViewController.h"
#import "LDMapFindViewController.h"
#import "LDGroupSpuareViewController.h"
#import "LDMemberViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface LDMapViewController ()<UISearchBarDelegate,MAMapViewDelegate,AMapLocationManagerDelegate,AMapSearchDelegate,UITableViewDelegate,UITableViewDataSource>{

    AMapLocationManager *_locationManager;
    
    MAMapView *_mapView;
    
    MAPointAnnotation *_annotation;
}

//查看按钮
@property (weak, nonatomic) IBOutlet UIButton *lookButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lookButtonBottomY;

//上方搜索框
@property (strong, nonatomic)  UISearchBar *searchBar;

//高德地图模糊搜索相关类
@property (nonatomic,strong)AMapSearchAPI *search;
@property (nonatomic,strong)MAUserLocation *location;
@property (nonatomic,strong)AMapInputTipsSearchRequest *request;

//搜索内容的展示用tableview
@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSMutableArray *annotationArr;
@property (nonatomic,strong)NSMutableArray *poisArray;

@property (nonatomic,assign)NSInteger index;

//存储经纬,地理位置,省,市
@property (nonatomic,assign) CGFloat lat;
@property (nonatomic,assign) CGFloat lng;
@property (nonatomic,copy) NSString *loca;
@property (nonatomic,copy) NSString *province;
@property (nonatomic,copy) NSString *city;

@end

@implementation LDMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    
    if (ISIPHONEX) {
   
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 44, WIDTH, 44)];
        
        _lookButtonBottomY.constant = IPHONEXBOTTOMH;
        
    }else{
        
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 20, WIDTH, 44)];
    }

    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    
    _searchBar.delegate = self;
    
    _searchBar.showsCancelButton = YES;
    
    _searchBar.returnKeyType = UIReturnKeyDefault;
    
    _searchBar.placeholder = @"搜索";
    
    [self setCancelButton];
    
    [self setPoiSearchMapWithKeyword:@""];
    
    //令searchbar得搜索按钮为一直可按
    UITextField *searchBarTextField = nil;
    
    for(id cc in [self.searchBar.subviews[0] subviews])
    {
        if([cc isKindOfClass:[UITextField class]])
        {
            searchBarTextField = (UITextField *)cc;
            
            break;
        }
    }

    searchBarTextField.enablesReturnKeyAutomatically = NO;
    
    self.annotationArr = [[NSMutableArray alloc] init];
    
    [self.navigationController.view addSubview:_searchBar];
    
    [self createLocation];
    
    [self setTableView];
    
    if ([self.groupString isEqualToString:@"yes"]) {
        
        [self.lookButton setTitle:@"确定" forState:UIControlStateNormal];
        
    }else{
    
        [self.lookButton setTitle:@"查看" forState:UIControlStateNormal];
    }
    
}
- (IBAction)lookButtonClick:(UIButton *)sender {
    
    if ([self.groupString isEqualToString:@"yes"]){
        
//        NSLog(@"%f,%f,%@,%@,%@",_lat,_lng,_city,_province,_loca);
        
        if(_lat == 0 || _lng == 0 || _province.length == 0 || _loca.length == 0){
        
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"获取位置信息失败~"];
            
        }else{
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/friend/addGroup"];
            
            if (_province.length != 0 && _city.length == 0) {
                
                _city = _province;
                
            }
            
            NSDictionary *parameters = @{@"lat":[NSString stringWithFormat:@"%f",_lat],@"lng":[NSString stringWithFormat:@"%f",_lng],@"groupname":self.groupname,@"introduce":self.introduce,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"province":_province,@"city":_city,@"group_pic":self.headUrl};
            
            [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
                
                NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
                
                if (integer != 2000) {
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
                    
                }else{
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    for (UIViewController *view in self.navigationController.viewControllers) {
                        
                        if ([view isKindOfClass:[LDGroupSpuareViewController class]]) {
                            
                            [self.navigationController popToViewController:view animated:YES];
                        }
                    }
                    
                    
                }
            } failed:^(NSString *errorMsg) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }];
        }

    }else{
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"vip"] intValue] == 1) {
            
            LDMapFindViewController *mfc = [[LDMapFindViewController alloc] init];
            
            mfc.lat = _lat;
            
            mfc.lng = _lng;
            
            mfc.location = _loca;
            
            [self.navigationController pushViewController:mfc animated:YES];
            
        }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"vip"] intValue] == 0){
        
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"地图找人功能VIP会员可用哦~"    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"开通会员" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
                
                
                LDMemberViewController *mvc = [[LDMemberViewController alloc] init];
                
                [self.navigationController pushViewController:mvc animated:YES];
                
                
            }];
            
            UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault  handler:nil];
            
            [alert addAction:cancelAction];
            
            [alert addAction:action];
            
            [self presentViewController:alert animated:YES completion:nil];
        } 
    }
}

- (void)setTableView{
    
    self.tableView = [[UITableView alloc] init];
    
    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width,264);
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    self.tableView.hidden = YES;
    
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.poisArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identify = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
    }
    
    AMapTip *poi = (AMapTip *)self.poisArray[indexPath.row];
    
    cell.textLabel.text = poi.name;
    
    cell.detailTextLabel.text = poi.address;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.tableView.hidden = YES;
    
    self.searchBar.text = nil;
    
    [self.searchBar resignFirstResponder];
    
    [self setCancelButton];
    
    self.searchBar.text = [self.poisArray[indexPath.row] name];
    
    //先移除掉上次搜索的大头针
    [_mapView removeAnnotations:self.annotationArr];
    
    [self.annotationArr removeAllObjects];
    
    AMapTip *poi = self.poisArray[indexPath.row];
//    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
    
    //地图中心点 设置为选中的点
    _mapView.centerCoordinate = coordinate;
//    annotation.coordinate = coordinate;
//    //以下两句 就是气泡的显示内容
//    annotation.title = poi.name;
//    annotation.subtitle = poi.address;
//    
//    [self.annotationArr addObject:annotation];
//    
//    [_mapView addAnnotation:annotation];
    
}


-(void)createLocation{

    [AMapServices sharedServices].apiKey =@"1f4626e1f2643f5e8876fc9a490f26e2";
    
    [[AMapServices sharedServices] setEnableHTTPS:YES];

    ///初始化地图
    if (ISIPHONEX) {
        
        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - IPHONEXBOTTOMH)];
        
    }else{
        
        _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    }
    
    
    _mapView.delegate = self;
    
    ///把地图添加至view
    [self.view addSubview:_mapView];
    
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    [_mapView setMapType:MAMapTypeStandard];
    [_mapView setZoomLevel:16 animated:NO];
    
    //定位
    _locationManager = [[AMapLocationManager alloc] init];
    
    [_locationManager setDelegate:self];
    
    [_locationManager setPausesLocationUpdatesAutomatically:NO];
    
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    _mapView.allowsBackgroundLocationUpdates = NO;//iOS9以上系统必须配置
    
    //带逆地理定位
    [_locationManager setLocatingWithReGeocode:YES];
    [_locationManager startUpdatingLocation];
    
    if (ISIPHONEX) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((WIDTH - 20) / 2, (HEIGHT - 120 - 34 - 24) / 2, 20, 30)];
        
        imageView.image = [UIImage imageNamed:@"定位"];
        
        [self.view addSubview:imageView];
        
    }else{
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((WIDTH - 20) / 2, (HEIGHT - 120) / 2, 20, 30)];
        
        imageView.image = [UIImage imageNamed:@"定位"];
        [self.view addSubview:imageView];
    }

     [self.view addSubview:_lookButton];

}

- (void)setPoiSearchMapWithKeyword:(NSString *)keyword{
    //初始化检索对象
    self.search = [[AMapSearchAPI alloc] init];
    //构建AMapPlaceSearchRequest对象
    self.request = [[AMapInputTipsSearchRequest alloc] init];
    //搜索类型  关键字搜索
//    self.request.searchType = AMapSearchType_PlaceKeyword;
    //设置搜索关键字
    self.request.keywords = keyword;
    //搜索地点 广州
//    self.request.city = keyword;
    
    self.search.delegate = self;

    //发起POI搜索
    [self.search AMapInputTipsSearch:self.request];
    
}

/* 输入提示回调. */
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response
{
    //解析response获取提示词，具体解析见 Demo
    
    if (response.count == 0) {
        
        return;
    }
    
    
    self.poisArray = [[NSMutableArray alloc] init];
    
    for (AMapTip *poi in response.tips) {
        
        if (poi.location.latitude != 0 && poi.location.longitude != 0) {
            
            [self.poisArray addObject:poi];
            
        }
        
//        NSLog(@"%@,%f,%f",poi.name,poi.location.latitude,poi.location.longitude);
        
    }
    
    [self.tableView reloadData];
}

#pragma mark --AMapLocationManagerDelegate
- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    //定位错误
    NSLog(@"%s, amapLocationManager = %@, error = %@", __func__, [manager class], error);
}
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    //定位结果
    //    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    
}

- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated

{
    MACoordinateRegion region;
    
    CLLocationCoordinate2D centerCoordinate = mapView.centerCoordinate;
    
    region.center = centerCoordinate;
    
    _lat = centerCoordinate.latitude;
    
    _lng = centerCoordinate.longitude;
    
    [self getNameByLatitude:centerCoordinate.latitude andLongTitude:centerCoordinate.longitude];
    
}

- (void)getNameByLatitude:(CLLocationDegrees)latitude andLongTitude:(CLLocationDegrees)longtitud
{
    
    AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc]init];
    
    regeoRequest.location = [AMapGeoPoint locationWithLatitude:latitude longitude:longtitud];
    
//    regeoRequest.radius =2000;
    
    regeoRequest.requireExtension =YES;
    
    [self.search AMapReGoecodeSearch:regeoRequest];  // 发起检索
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    
    if (response.regeocode != nil) {
        
        AMapReGeocode *regeocode = response.regeocode;

        NSString *address = regeocode.formattedAddress; // 获得检索位置
        
        _province = regeocode.addressComponent.province;
        
        _city = regeocode.addressComponent.city;
        
//        NSLog(@"dafafsafafafafa%@",regeocode.addressComponent.city);
        
        _loca = address;
      
    }
}


-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
        
    [self setPoiSearchMapWithKeyword:self.searchBar.text];
    
   [self setCancelButton];
    
    return YES;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if (searchText.length == 0) {
        
        self.tableView.hidden = YES;
        
    }else{
    
        self.tableView.hidden = NO;
        
        [self setPoiSearchMapWithKeyword:self.searchBar.text];
    }
    
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    searchBar.text = nil;
    
    [self.navigationController popViewControllerAnimated:YES];
    
    [searchBar resignFirstResponder];
    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
    
    [self setCancelButton];
    
}

-(void)setCancelButton{

    for(id cc in [self.searchBar.subviews[0] subviews])
    {
        if([cc isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cc;
        
            btn.userInteractionEnabled = YES;
            
            [btn setEnabled:YES];
            
            [btn setTitleColor:MainColor forState:UIControlStateNormal];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    _searchBar.hidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    
    _searchBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

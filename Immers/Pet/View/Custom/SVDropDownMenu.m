//
//  SVDropDownMenu.m
//  Immers
//
//  Created by developer on 2022/11/17.
//

#import "SVDropDownMenu.h"
#import "SVDevice.h"
@interface SVDropDownMenu()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *listTable;

@property (nonatomic, strong) UIButton *headerBtn;

@property (nonatomic, assign) BOOL headerSelected;

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@property (nonatomic, assign) NSInteger selectIndex;
@end

static NSString * const kDropMenuCellIdentifier = @"DropMenuCellIdentifier";
static const CGFloat kCellDefaultHeight = 44.f;

@implementation SVDropDownMenu

//MARK: - Life Circle
-(instancetype)initWithFrame:(CGRect)frame;{
    self = [super initWithFrame:frame];
    if(self){
        [self configData];
        [self setupUI];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configData];
        [self setupUI];
    }
    return self;
}


- (void)configData{

    self.indicatorColor = [UIColor blackColor];
    
    self.textColor = [UIColor blackColor];
    
    self.font = [UIFont systemFontOfSize:14.f];

}
//MARK: - About UI
- (void)setupUI{
    self.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1].CGColor;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor colorWithHex:0x000000 alpha:0.05].CGColor;
    self.layer.cornerRadius = 6.f;
    self.layer.masksToBounds = YES;
    self.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1].CGColor;
    self.layer.shadowOffset = CGSizeMake(5,5);
    self.layer.shadowOpacity = 10;
    self.layer.shadowRadius = 10;
    
    [self addSubview:self.listTable];
    
    
    [_listTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.listTable registerClass:[UITableViewCell class] forCellReuseIdentifier:kDropMenuCellIdentifier];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.headerSelected) {
        self.mj_h = self.datas.count*self.rowHeight + self.rowHeight;
    }else{
        self.mj_h = self.rowHeight;
    }

    //self.listTable.frame = self.bounds;
}
//MARK: - Event response
- (void)sectionHeaderClicked{
    if(_datas.count==0){
        if(self.noDeviceBlock){
            self.noDeviceBlock();
        }
        return;
    }
    self.headerSelected = !self.headerSelected;
    if (self.openMenuBlock) {
        self.openMenuBlock(self.headerSelected);
    }
    [self setNeedsLayout];
    __weak typeof(self) weakSelf = self;
    [self animateIndicator:self.shapeLayer Forward:self.headerSelected complete:^{
        [weakSelf cellInsertOrDelete:self.headerSelected];
        weakSelf.headerBtn.layer.borderWidth = self.headerSelected?1:0;
    }];
    
    
    
    
}
//MARK: - Pravite Method
- (CAShapeLayer *)createIndicatorWithColor:(UIColor *)color andPosition:(CGPoint)point {
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(12, 0)];
    [path addLineToPoint:CGPointMake(6, 7)];
    [path closePath];
    
    layer.path = path.CGPath;
    layer.lineWidth = 1.0;
    layer.fillColor = color.CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    
    CGPathRelease(bound);
    
    layer.position = point;
    
    return layer;
}


- (void)animateIndicator:(CAShapeLayer *)indicator Forward:(BOOL)forward complete:(void(^)(void))complete {
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.25];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithControlPoints:0.4 :0.0 :0.2 :1.0]];
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    anim.values = forward ? @[ @0, @(M_PI) ] : @[ @(M_PI), @0 ];
    
    if (!anim.removedOnCompletion) {
        [indicator addAnimation:anim forKey:anim.keyPath];
    } else {
        [indicator addAnimation:anim forKey:anim.keyPath];
        [indicator setValue:anim.values.lastObject forKeyPath:anim.keyPath];
    }
    
    [CATransaction commit];
    
    complete();
}


- (void)cellInsertOrDelete:(BOOL)insert{
    
    [self.listTable beginUpdates];
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:self.datas.count];
    
    [self.datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSIndexPath *indexP = [NSIndexPath indexPathForRow:idx inSection:0];
        [indexPaths addObject:indexP];
    }];
    
    if (insert) {
        [self.listTable insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
    }else{
        [self.listTable deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationBottom];
    }
    
    
    
    [self.listTable endUpdates];
}
//MARK: - Public Method
- (void)closeMenu{
    if (self.headerSelected) {
        [self sectionHeaderClicked];
    }
}
//MARK: - Getters/Setters/Lazy
- (UITableView *)listTable{
    if (!_listTable) {
        _listTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.mj_h, kCellDefaultHeight) style:UITableViewStylePlain];
        _listTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listTable.delegate = self;
        _listTable.dataSource = self;
        _listTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _listTable.showsHorizontalScrollIndicator = NO;
        _listTable.bounces = NO;
        if (@available(iOS 15.0, *)) {
            _listTable.sectionHeaderTopPadding = 0;
        } else {
            // Fallback on earlier versions
        }
    }
    return _listTable;
}


- (void)setDatas:(NSArray *)datas{
    _datas = datas;
    [self.listTable reloadData];
}


- (void)setRowHeight:(CGFloat)rowHeight{
    _rowHeight = rowHeight;
    
    [self setNeedsDisplay];
}
//MARK: - Delegate methods

//MARK: - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.headerSelected?self.datas.count:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDropMenuCellIdentifier];
    SVDevice *device = self.datas[indexPath.row];
    cell.textLabel.text = device.name?:@"holo";
    cell.textLabel.font = self.font;
    cell.textLabel.textColor = device.onlineStatus?self.textColor:UIColor.grayColor5;
    cell.contentView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

//MARK: - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SVDevice *device = self.datas[indexPath.row];
    if (device.onlineStatus) {
        _selectIndex = indexPath.row;
        [self.headerBtn setTitle:device.name forState:UIControlStateNormal];
        if (self.autoCloseWhenSelected) {
            [self closeMenu];
        }
    }
//    if(self.cellClickedBlock){
//        self.cellClickedBlock(device.name, indexPath.row);
//    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    SVDevice *device;
    if(self.datas.count>0){
        device = self.datas[self.datas.count>_selectIndex?_selectIndex:0];
    }
    
    UIButton *headerBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, tableView.mj_w, self.rowHeight==0?kCellDefaultHeight:self.rowHeight)];
    headerBtn.titleLabel.font = self.font;
    [headerBtn setTitleColor:device.onlineStatus?self.textColor:UIColor.grayColor5 forState:UIControlStateNormal];
    [headerBtn setTitle:device.name forState:UIControlStateNormal];
    [headerBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [headerBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    [headerBtn addTarget:self action:@selector(sectionHeaderClicked) forControlEvents:UIControlEventTouchUpInside];
    headerBtn.layer.borderColor = UIColor.grassColor.CGColor;
    headerBtn.layer.borderWidth = 0;
    [headerBtn corner];
    CGPoint position = CGPointMake(headerBtn.mj_w-kWidth(12),headerBtn.mj_h/2.f);
    CAShapeLayer *shapeLayer = [self createIndicatorWithColor:self.indicatorColor andPosition:position];
    [headerBtn.layer addSublayer:shapeLayer];
    if (_datas.count==0) {
        [headerBtn setTitle:SVLocalized(@"tip_unBind_device") forState:0];
        [headerBtn setTitleColor:UIColor.grayColor5 forState:0];
    }
    self.shapeLayer = shapeLayer;
    self.headerBtn = headerBtn;
    return headerBtn;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return self.rowHeight==0?kCellDefaultHeight:self.rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return self.rowHeight==0?kCellDefaultHeight:self.rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.001f;
}

@end

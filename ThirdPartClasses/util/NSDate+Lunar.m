//
//  NSDate+Lunar.m
//  ChildrenCalendar
//
//  Created by yangxi zou on 11-1-28.
//  Copyright 2011 shenzhen shuangmeng  computer co.,ltd. All rights reserved.
//

#import "NSDate+Lunar.h"


@implementation NSDate(Lunar)

int year;
int month;
int day;
BOOL leap;

+(NSArray*)lunrarinfo
{
	return  [NSArray arrayWithObjects:	
			 @"19416",@"19168",@"42352",@"21717",@"53856",@"55632",@"91476",@"22176",@"39632",@"21970",
			 @"19168",@"42422",@"42192",@"53840",@"119381",@"46400",@"54944",@"44450",@"38320",@"84343",
			 @"18800",@"42160",@"46261",@"27216",@"27968",@"109396",@"11104",@"38256",@"21234",@"18800",
			 @"25958",@"54432",@"59984",@"28309",@"23248",@"11104",@"100067",@"37600",@"116951",@"51536",
			 @"54432",@"120998",@"46416",@"22176",@"107956",@"9680",@"37584",@"53938",@"43344",@"46423",
			 @"27808",@"46416",@"86869",@"19872",@"42448",@"83315",@"21200",@"43432",@"59728",@"27296",
			 @"44710",@"43856",@"19296",@"43748",@"42352",@"21088",@"62051",@"55632",@"23383",@"22176",
			 @"38608",@"19925",@"19152",@"42192",@"54484",@"53840",@"54616",@"46400",@"46496",@"103846",
			 @"38320",@"18864",@"43380",@"42160",@"45690",@"27216",@"27968",@"44870",@"43872",@"38256",
			 @"19189",@"18800",@"25776",@"29859",@"59984",@"27480",@"21952",@"43872",@"38613",@"37600",
			 @"51552",@"55636",@"54432",@"55888",@"30034",@"22176",@"43959",@"9680",@"37584",@"51893",
			 @"43344",@"46240",@"47780",@"44368",@"21977",@"19360",@"42416",@"86390",@"21168",@"43312",
			 @"31060",@"27296",@"44368",@"23378",@"19296",@"42726",@"42208",@"53856",@"60005",@"54576",
			 @"23200",@"30371",@"38608",@"19415",@"19152",@"42192",@"118966",@"53840",@"54560",@"56645",
			 @"46496",@"22224",@"21938",@"18864",@"42359",@"42160",@"43600",@"111189",@"27936",@"44448", nil];
}
//====== 传回农历 y年闰哪个月 1-12 , 没闰传回 0 
+(int) leapMonth:(int )y {   
	return (int) ([[ [ NSDate lunrarinfo ] objectAtIndex:y - 1900 ] intValue] & 0xf);   
}   
//====== 传回农历 y年闰月的天数
+(int) leapDays:(int )y {   
	if ([NSDate leapMonth:y] != 0) {   
		if (([[ [ NSDate lunrarinfo ] objectAtIndex:y - 1900 ] intValue] & 0x10000) != 0)   
			return 30;   
		else  
			return 29;   
	} else  
		return 0;   
}   
//====== 传回农历 y年的总天数
+(int) yearDays:(int ) y{   
	int i, sum = 348;   
	for (i = 0x8000; i > 0x8; i >>= 1) {   
		if (([[ [ NSDate lunrarinfo ] objectAtIndex:y - 1900 ] intValue]  & i) != 0) sum += 1;   
	}   
	return (sum + [NSDate leapDays:y]);   
} 
//====== 传回农历 y年m月的总天数  
+(int) monthDays:(int)y  m:(int)m {   
	if (([[ [ NSDate lunrarinfo ] objectAtIndex:y - 1900 ] intValue] & (0x10000 >> m)) == 0)   
		return 29;   
	else  
		return 30;   
}   
//====== 传回农历 y年的生肖   
-(NSString*) animalsYear {   
	NSArray *sx = [NSArray arrayWithObjects:@"鼠", @"牛", @"虎", @"兔", @"龙", @"蛇", @"马", @"羊", @"猴", @"鸡", @"狗", @"猪",nil];   
	return  [sx objectAtIndex:(year - 4) % 12];   
}   

//====== 传入 月日的offset 传回干支, 0=甲子   
+(NSString*) cyclicalm:(int) num { 
//+(NSString*) cyclicalm { 
	 
	NSArray *gan = [NSArray arrayWithObjects:@"甲", @"乙", @"丙", @"丁", @"戊", @"己", @"庚", @"辛", @"壬", @"癸",nil];   
	NSArray *zhi = [NSArray arrayWithObjects:@"子", @"丑", @"寅", @"卯", @"辰", @"巳", @"午", @"未", @"申", @"酉", @"戌", @"亥",nil];   
	return [NSString stringWithFormat:@"%@%@",   [gan objectAtIndex: num % 10 ]  ,  [zhi objectAtIndex: num % 12]];   
}   

//====== 传入 offset 传回干支, 0=甲子   
-(NSString*) cyclical  {   
	int num = year - 1900 + 36;   
	return  [NSDate cyclicalm:num];   
}   
+(NSString*)getChineseNumber:(int )x
{
	NSArray *cnnum = [NSArray arrayWithObjects:@"一", @"二", @"三", @"四", @"五", @"六", @"七", @"八", @"九", @"十", @"十一", @"十二",nil];
	return [cnnum objectAtIndex:x];
}
+(NSString*)getChineseNumber0:(int )x
{
	NSArray *cnnum = [NSArray arrayWithObjects:@"零",@"一", @"二", @"三", @"四", @"五", @"六", @"七", @"八", @"九",nil];
	return [cnnum objectAtIndex:x];
}
+(NSString*) getChinaDayString:(int )day {   
	NSArray *chineseTen = [NSArray arrayWithObjects:@"初", @"十", @"廿", @"卅",nil];   
	int n = day % 10 == 0 ? 9 : day % 10 - 1;   
	if (day > 30)   
		return @"";   
	if (day == 10)   
		return @"初十";  
	else  
		return [NSString stringWithFormat:@"%@%@", [chineseTen  objectAtIndex:day/10 ] , [ NSDate getChineseNumber:n] ] ;   
}   
-(NSString*) getChinaYearString {   
	  
	return [NSString stringWithFormat:@"%@%@%@%@", [NSDate getChineseNumber0:year/1000 ] , [NSDate getChineseNumber0:(year-2000)/100 ] , [NSDate getChineseNumber0:(year-2000)/10 ] , [NSDate getChineseNumber0:(year-2000)%10 ]] ;   
}   
int daysOfLunadMonth=0;
int leapwMonth =0;
-(void)initLunar
{
	//dlog(@"%i",[@"111189" intValue]>>1);
	//dlog(@"%i",[[[ NSDate lunrarinfo ] objectAtIndex:0] intValue]>>1);
	/*for (int i=1900; i<2050; i++) {
	 //dlog(@"y:%i", [NSDate yearDays:i]);
	 } */
	int yearCyl, monCyl, dayCyl;
	int leapMonth = 0; 
	//求出和1900年1月31日相差的天数 
	NSDate *basedate= [NSDate dateFromString:@"1900-01-31" withFormat:@"yyyy-MM-dd"] 	;
	//int offset = [self timeIntervalSinceDate:basedate ] /86400;
	//dlog(@"t:%d t1:%d", offset,[basedate daysAgo:self]);
	int offset = [basedate daysAgo:self];
	
	dayCyl = offset + 40;   
	monCyl = 14;
	
	//用offset减去每农历年的天数
	// 计算当天是农历第几天
	//i最终结果是农历的年份
	//offset是当年的第几天
	int iYear, daysOfYear = 0;   
	for (iYear = 1900; iYear < 2050 && offset > 0; iYear++) {   
		daysOfYear = [NSDate yearDays:iYear];   
		offset -= daysOfYear;   
		monCyl += 12;   
	}   
	if (offset < 0) {   
		offset += daysOfYear;   
		iYear--;   
		monCyl -= 12;   
	}   
	//农历年份   
	year = iYear;   
	yearCyl = iYear - 1864;   
	leapMonth = [NSDate leapMonth:iYear]; //闰哪个月,1-12 
	leapwMonth = leapMonth;
	leap = NO;   
	
	//用当年的天数offset,逐个减去每月（农历）的天数，求出当天是本月的第几天   
	int iMonth, daysOfMonth = 0;   
	for (iMonth = 1; iMonth < 13 && offset > 0; iMonth++) {   
		//闰月   
		if (leapMonth > 0 && iMonth == (leapMonth + 1) && !leap) {   
			--iMonth;   
			leap = true;   
			daysOfMonth = [NSDate leapDays:year];   
		} else  
			daysOfMonth = [NSDate monthDays:year m: iMonth];   
		
		offset -= daysOfMonth;   
		//解除闰月   
		if (leap && iMonth == (leapMonth + 1)) leap = false;   
		if (!leap) monCyl++;   
	}   
	//offset为0时，并且刚才计算的月份是闰月，要校正   
	if (offset == 0 && leapMonth > 0 && iMonth == leapMonth + 1) {   
		if (leap) {   
			leap = false;   
		} else {   
			leap = true;   
			--iMonth;   
			--monCyl;   
		}   
	}   
	//offset小于0时，也要校正   
	if (offset < 0) {   
		offset += daysOfMonth;   
		--iMonth;   
		--monCyl;   
	}   
	
	daysOfLunadMonth = daysOfMonth;
	
	month = iMonth;   
	day = offset + 1;  
	
	//dlog(@"%d",offset daysOfLunadMonth);
	//return [self description];
	//return self;
}
-(void)initLunar_x
{
	//dlog(@"%i",[@"111189" intValue]>>1);
	//dlog(@"%i",[[[ NSDate lunrarinfo ] objectAtIndex:0] intValue]>>1);
	/*for (int i=1900; i<2050; i++) {
		//dlog(@"y:%i", [NSDate yearDays:i]);
	} */
	int yearCyl, monCyl, dayCyl;
	int leapMonth = 0; 
	//求出和1900年1月31日相差的天数 
	NSDate *basedate= [NSDate dateFromString:@"1900-01-31" withFormat:@"yyyy-MM-dd"] 	;
	//int offset = [self timeIntervalSinceDate:basedate ] /86400;
	//dlog(@"t:%d t1:%d", offset,[basedate daysAgo:self]);
	int offset = [basedate daysAgo:[self dateAfterDay:-1]];

	dayCyl = offset + 40;   
	monCyl = 14;
	
	//用offset减去每农历年的天数
	// 计算当天是农历第几天
	//i最终结果是农历的年份
	//offset是当年的第几天
	int iYear, daysOfYear = 0;   
	for (iYear = 1900; iYear < 2050 && offset > 0; iYear++) {   
		daysOfYear = [NSDate yearDays:iYear];   
		offset -= daysOfYear;   
		monCyl += 12;   
	}   
	if (offset < 0) {   
		offset += daysOfYear;   
		iYear--;   
		monCyl -= 12;   
	}   
	//农历年份   
	year = iYear;   
	yearCyl = iYear - 1864;   
	leapMonth = [NSDate leapMonth:iYear]; //闰哪个月,1-12 
	leapwMonth = leapMonth;
	leap = NO;   
	
	//用当年的天数offset,逐个减去每月（农历）的天数，求出当天是本月的第几天   
	int iMonth, daysOfMonth = 0;   
	for (iMonth = 1; iMonth < 13 && offset > 0; iMonth++) {   
		//闰月   
		if (leapMonth > 0 && iMonth == (leapMonth + 1) && !leap) {   
			--iMonth;   
			leap = true;   
			daysOfMonth = [NSDate leapDays:year];   
		} else  
			daysOfMonth = [NSDate monthDays:year m: iMonth];   
		
		offset -= daysOfMonth;   
		//解除闰月   
		if (leap && iMonth == (leapMonth + 1)) leap = false;   
		if (!leap) monCyl++;   
	}   
	//offset为0时，并且刚才计算的月份是闰月，要校正   
	if (offset == 0 && leapMonth > 0 && iMonth == leapMonth + 1) {   
		if (leap) {   
			leap = false;   
		} else {   
			leap = true;   
			--iMonth;   
			--monCyl;   
		}   
	}   
	//offset小于0时，也要校正   
	if (offset < 0) {   
		offset += daysOfMonth;   
		--iMonth;   
		--monCyl;   
	}   
	
	daysOfLunadMonth = daysOfMonth;
	
	month = iMonth;   
	day = offset + 1;  
	
	//dlog(@"%d",offset daysOfLunadMonth);
	//return [self description];
	//return self;
}

+(NSArray*)SolarTerm
{
	return [NSArray arrayWithObjects:@"小寒", @"大寒", @"立春", @"雨水",
	@"惊蛰", @"春分", @"清明", @"谷雨", @"立夏", @"小满", @"芒种", @"夏至", @"小暑", @"大暑", @"立秋",
	@"处暑", @"白露", @"秋分", @"寒露", @"霜降", @"立冬", @"小雪", @"大雪", @"冬至",nil];
}
+(NSArray*)STermInfo
{
	return [NSArray arrayWithObjects: @"0", @"21208", @"42467", @"63836", @"85337",
			@"107014", @"128867", @"150921", @"173149", @"195551", @"218072", @"240693", @"263343",
			@"285989", @"308563", @"331033", @"353350", @"375494", @"397447", @"419210", @"440795",
			@"462224", @"483532", @"504758",nil];
}

//  ===== y年的第n个节气为几日(从0小寒起算)

+(int)sTerm:(int)y n:(int)n 
{
	NSDate *cal = [NSDate dateFromString:@"1900-01-06 02:05" withFormat:@"yyyy-MM-dd HH:mm"];
	double temp = [cal timeIntervalSince1970];
	NSDate *xd = [NSDate dateWithTimeIntervalSince1970:(31556925.9747 * (y - 1900) + [[[NSDate STermInfo]objectAtIndex:n] intValue] * 60  + temp )];
	return [xd getDay];
}
//核心方法 根据日期(y年m月d日)得到节气  
-(NSString*) getSoralTerm
{
	int y,m,d;
	y=[self getYear];
	m=[self getMonth];
	d =[self getDay];
	NSString *solarTerms;
	if (d == [ NSDate sTerm:y n:(m - 1) * 2]  )
		solarTerms = [ [NSDate SolarTerm]objectAtIndex: (m - 1) * 2];
	else if (d == [ NSDate sTerm :y n:(m - 1) * 2 + 1])
		solarTerms = [ [NSDate SolarTerm] objectAtIndex: (m - 1) * 2 + 1];
	else{
		//到这里说明非节气时间
		solarTerms = @"";
	}
	return  solarTerms;
}
 
-(void)nextLunarDay
{
	  
}

-(NSString*)toLunarShortDate_x
{
	//[self initLunar];
	
	day = day+1;
	if (daysOfLunadMonth< day ) {
		day=1;
		if(leapwMonth!=month)month=month+1;
		if (month==13) {
			month=1;
			year=year+1;
		}
	}	
	//dlog(@"%d,%d m:%d", daysOfLunadMonth,day,month);
	
	int iMonth=month;
	int iDay=day;
	
	//优先返回节日
	if(iMonth == 12){
		if(iDay==30)return @"除夕";		
	}
	if(iMonth == 1){		
		if(iDay==1)return @"春节";
		if(iDay==15)return @"元宵";
	}
	
	if(iMonth == 2&&iDay==21)return @"清明";
	if(iMonth == 5&&iDay==5)return @"端午";
	if(iMonth == 7&&iDay==7)return @"七夕";
	if(iMonth == 8&&iDay==15)return @"中秋";
	if(iMonth == 9&&iDay==9)return @"重阳";
		
	//第二返回节气
	NSString *jq = [self getSoralTerm ];
	if (![jq isEqualToString:@""]) {
		return jq;
	}
	NSString *sCalendar = @"";
	
	//dlog(@"iMonth:%d",month );
	if(iMonth > 12)
	{
		iMonth -= 12;
		sCalendar = [sCalendar stringByAppendingString:@"闰"];
	}
	if(iMonth == 12)
		sCalendar = [sCalendar stringByAppendingString:@"腊月"];
	else
		if(iMonth == 11)
			sCalendar = [sCalendar stringByAppendingString:@"冬月"];
		else
			if(iMonth == 1)
				sCalendar = [sCalendar stringByAppendingString:@"正月"];
			else
				sCalendar =  [NSString stringWithFormat:@"%@%@月" ,sCalendar , [NSDate getChineseNumber:iMonth-1] ];
	
	
	
	
	
	if(iDay==1)return sCalendar;
	
	//[sCalendar release];
	//sCalendar=@"";
	
	return [NSDate getChinaDayString:day];
}

-(NSString*)toLunarShortDate
{
	[self initLunar];
	
	
	//dlog(@"%d,%d m:%d", daysOfLunadMonth,day,month);
	
	int iMonth=month;
	int iDay=day;
	
	//优先返回节日
	if(iMonth == 12){
		if(iDay==30)return @"除夕";		
	}
	if(iMonth == 1){		
		if(iDay==1)return @"春节";
		if(iDay==15)return @"元宵";
	}
	
	if(iMonth == 2&&iDay==21)return @"清明";
	if(iMonth == 5&&iDay==5)return @"端午";
	if(iMonth == 7&&iDay==7)return @"七夕";
	if(iMonth == 8&&iDay==15)return @"中秋";
	if(iMonth == 9&&iDay==9)return @"重阳";
	
	//第二返回节气
	NSString *jq = [self getSoralTerm ];
	if (![jq isEqualToString:@""]) {
		return jq;
	}
	NSString *sCalendar = @"";
	
	//dlog(@"iMonth:%d",month );
	if(iMonth > 12)
	{
		iMonth -= 12;
		sCalendar = [sCalendar stringByAppendingString:@"闰"];
	}
	if(iMonth == 12)
		sCalendar = [sCalendar stringByAppendingString:@"腊月"];
	else
		if(iMonth == 11)
			sCalendar = [sCalendar stringByAppendingString:@"冬月"];
		else
			if(iMonth == 1)
				sCalendar = [sCalendar stringByAppendingString:@"正月"];
			else
				sCalendar =  [NSString stringWithFormat:@"%@%@月" ,sCalendar , [NSDate getChineseNumber:iMonth-1] ];
	
	
	
	
	
	if(iDay==1)return sCalendar;
	
	//[sCalendar release];
	//sCalendar=@"";
	
	return [NSDate getChinaDayString:day];
}


-(int)getLunarYear
{
	return year;
}
-(int)getLunarMonth
{
	return month;
}
-(int)getLunarDay
{
	return day;
}
  
-(NSString *)toLunarLongDate  {  
	//dlog(@"Month:%d",month );
	[self initLunar];
	
	int iMonth=month;
	NSString *sCalendar = @"";
	
	//dlog(@"iMonth:%d",month );
	if(iMonth > 12)
	{
		iMonth -= 12;
		sCalendar = [sCalendar stringByAppendingString:@"闰"];
	}
	if(iMonth == 12)
		sCalendar = [sCalendar stringByAppendingString:@"腊月"];
	else
		if(iMonth == 11)
			sCalendar = [sCalendar stringByAppendingString:@"冬月"];
		else
			if(iMonth == 1)
				sCalendar = [sCalendar stringByAppendingString:@"正月"];
			else
				sCalendar =  [NSString stringWithFormat:@"%@%@月" ,sCalendar , [NSDate getChineseNumber:iMonth-1] ];
	
	
	
	if(leap){//农历
		return  [NSString stringWithFormat:@"%@%@年 %@%@%@" ,[self cyclical], [self animalsYear ] ,@"",   sCalendar ,  [NSDate getChinaDayString:day]];
		}else{
		return  [NSString stringWithFormat:@"%@%@年 %@%@%@" ,[self cyclical],  [self animalsYear ] , @"",   sCalendar ,  [NSDate getChinaDayString:day]];
	}		 
}		
@end

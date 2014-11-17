source $shellmy

查询的内容 > /路径/文件 
------------------------------------------------------

app store baidu map key: 1mcOoiwLnNBhYjSeXM15agTV

test baidu map key: dAvREXQbGy7RTC8hEBu3WLem
------------------------------------------------------

APP ID:1103289287
APP KEY:Xia55nk5Pzziyzq9

------------------------------------------------------
#if (CN == 1)

#else

#endif

------------------------------------------------------

CitySelectionView
CityListSelectionView


------------------------------------------------------
@"link" : @"http://uat.openrice.com.cn/beijing/restaurant/sr2.htm?shopid=824523"	
@"description" : @"地址 : 朝阳区大望路东四环中路力源里8号东恒时代北门外商铺(近四惠地铁站E口)\n "	
@"caption" : @"http://uat.openrice.com.cn/beijing/restaurant/sr2.htm?shopid=824523"	
@"name" : @"没名儿生煎 (大望路)"	
@"picture" : @""	
@"shareLink" : @""	
@"cityname" : @"北京"	
------------------------------------------------------
@"couponName" : @"九月优惠"	
@"restaurantName" : @"梭索丽江太安洋芋鸡 (丰台区)"	
@"couponUrl" : @"http://uat.openrice.com.cn/beijing/coupon/detail.htm?couponid=3235"	
@"image" : @"http://uat.openrice.com.cn/userphoto/Coupon/0/17/0008LAC2AE3D65CBAA6182n.jpg"	
@"expiryDate" : @"\n有效期 2013-09-30"	
------------------------------------------------------


void getNext (String *str, int next[]) {
	int i = 0, j = -1;
	next[0] = -1;

	while (i < str->length) {
		if (j == -1 || str->base[i] == str->base[j]) {
			i++;
			j++;
			next[i] = j;
		}else {
			j = next[j];
		}
	}
}

------------------------------------------------------


int min;                             //存放lowcost数组中最小的权值
    
    int vexs[MAXSIZE];                   //保存哪个顶点到哪个顶点的关系
    int lowcost[MAXSIZE];                //两个顶点之间的边权值
    
    /**
     *      vexs[i] = j ==>> j号顶点 -(到)-> i号顶点
     *
     *      lowcost[i] = k ==>> j号顶点 -(到)-> i号顶点的权值为 == k
     */
    
    //设置0号顶点到0号顶点之间的权值为0 (不存在回路)
    vexs[0] = 0;
    lowcost[0] = 0;
    
    /**
     *  将0号顶点 到 其他所有顶点 的权值 都存入lowcost数组中
     */
    int i;
    for (i = 1; i < g->vexnum; i++) {
        vexs[i] = 0;                     //顶点0到其他所有顶点n
        lowcost[i] = g->matrix[0][i];    //顶点0到其他所有顶点n 的权值 (从图的邻接矩阵中的第0行)
    }
    
    for (i = 1; i < g->vexnum; i++) {
        
        min = NOT_ARRIVE;               //保存当前顶点到k号顶点的最小权值
        int k = 0;                      //k: 保存当前顶点到k号顶点
        
        //计算当前顶点边中权值最小的边
        int j;
        for (j = 1; j < g->vexnum; j++) {
            if (lowcost[j] != 0 && lowcost[j] < min)  {
                min = lowcost[j];
                k = j;
            }
        }
    }

------------------------------------------------------


void getNext(String str, int next[]) {
    int i = 0, j = -1;
    next[0] = -1;

    while (i < str.length){
        if (j == -1 && str.bass[i] == str.base[j])
        {
            i++;
            j++;
            next[i] = j;
        }else {
            j = next[j];
        }
    }
}


------------------------------------------------------

typedef struct UnionSet{
    int parant[MAXSIZE];
    int rank[MAXSIZE];
}UnionSet;

void Init_UnionSet(UnionSet * u) {
    for (int i = 0; i < MAXSIZE; ++i)
    {
        u->parant[i] = i;
        rank[i] = 0;
    }
}

int Find(UnionSet * u, int x){
    if (u->parant[x] != x)
    {
        u->parant[x] = Find(u, u->parant[x]);
    }
    return u->parant[x];
}

void Union(UnionSet * u, int , int y) {
    x = Find(u, x);
    y = Find(u, y);
    if (rank[x] < rank[y])
    {
        u->parant[x] = y;
    }else {
        u->parant[y] = x;
        if (u->rank[x] == u->rank[y])
        {
            u->rank[x]++;
        }
    }
}


typedef struct Graph {
    char vexs[MAXSIZE];
    int arc[MAXSIZE][MAXSIZE];
    int vexnum;
}Graph;

typedef struct Edge
{
    int begin;
    int end;
    int weight;
}Edge;

void kruskal(Graph * g, int * sum) {
    Edge edges[MAXSIZE];

    for (int i = 0; i < g->vexnum; ++i)
    {
        for (int j = 0; j < g->vexnum; ++j)
        {   
            if (g->arc[i][j] != 65535)
            {
                Edge * e = (Edge *)malloc(sizeof(Edge));
                e->begin = i;
                e->end = j;
                e->weight = g->arc[i][j];
            }
        }
    }

    //sort

    UnionSet set;
    Init_UnionSet(&set);
    sum = 0;

    for (int i = 0; i < strlen(edges)/sizeof(Edge); ++i)
    {
        int n = Find(edges[i].begin);
        int m = Find(edges[i].end);

        if (n != m)
        {
            set.parant[n] = m;
            sum += edges[i].weight;
        }
    }
}












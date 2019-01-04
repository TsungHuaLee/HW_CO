#include<stdio.h>
#include<stdlib.h>
#include<stdbool.h>
#include<string.h>
#include<math.h>
typedef struct Block_
{
    bool valid;
    bool dirty;
    int tag;
    int data;
    int flag;   /* for FIFO & LRU */
}Block;
typedef struct Cache_
{
    int cache_size;
    int block_size;
    int asso;
    int policy; /* 0 -> FIFO, 1 ->LRU */
    char* file;
    Block *block;
    int blockNum;
    int setsNum;
}Cache;

int demandFetch = 0, cacheHit = 0, cacheMiss = 0, missRate = 0, readData = 0, writeData = 0, BFM = 0, BTM = 0;

void setParameter(int argc, char** argv, Cache *cache)
{
    if(argc != 6)
    {
        printf("Missing parameter!!!\n");
        exit(1);
    }
    cache->cache_size = atoi(argv[1])<<10;
    cache->block_size = atoi(argv[2]);
    cache->asso = (strcmp(argv[3], "f") == 0)?cache->block_size:atoi(argv[3]);
    if(strcmp(argv[4], "FIFO") == 0)
        cache->policy = 0;
    else if(strcmp(argv[4], "LRU") == 0)
        cache->policy = 1;
    else
    {
        printf("unknown replace policy!!!\n");
        exit(1);
    }
    cache->file = argv[5];
    /* setting block */
    cache->blockNum = cache->cache_size / cache->block_size;
    cache->block = (Block*)malloc(sizeof(Block)*(cache->blockNum+1));
    cache->setsNum = cache->blockNum / cache->asso;
    return;
}

void simulation(Cache *cache)
{
    FILE *fp = fopen(cache->file, "r");
    if(fp == NULL)
    {
        printf("File not existed\n");
        exit(2);
    }
    int label = 0, addr = 0, index = 0, tag = 0;
    int offsetNum = log2(cache->block_size), set = 0;
    while(fscanf(fp, "%d %x\n", &label, &addr) != EOF)
    {
        demandFetch++;
        /* omit offset */
        addr = addr >> offsetNum;
        index = addr % cache->setsNum;
        tag = addr / cache->setsNum;
        /* check $ hit */
        bool hitCheck = false;
        for(int i = set = index * cache->asso; i < set + cache->asso && !hitCheck; i++)
        {
            if(cache->block[i].valid && cache->block[i].tag == tag)
            {
                hitCheck = true;
                cacheHit++;
                /* read -> return data
                   write -> write the new data into cache block */
                /* write -> mark cache as dirty */
                if(label == 1)
                    cache->block[i].dirty = 1;
                if(cache->policy) // LRU -> update flag
                    cache->block[i].flag = demandFetch;
                break;
            }
        }
        if(hitCheck == false)
        {
            cacheMiss++;
            // locate a cache block to use
            bool locate = false;
            int replacePos = -1, replaceFlag = demandFetch;
            for(int i = index * cache->asso, set = i; i < set + cache->asso && !hitCheck; i++)
            {
                // (1) unused block
                if(!cache->block[i].valid)
                {
                    cache->block[i].valid = true;
                    cache->block[i].dirty = (label==1)?true:false;
                    cache->block[i].tag = tag;
                    cache->block[i].flag = demandFetch;
                    locate = true;
                    break;
                }
                // (2) replace by policy
                if(cache->block[i].flag < replaceFlag)
                {
                    replaceFlag = cache->block[i].flag;
                    replacePos = i;
                }
            }
            if(!locate)
            {
                // dirty ? write previous data back to lower memory
                BTM = (cache->block[replacePos].dirty)?BTM+1:BTM;
                cache->block[replacePos].valid = true;
                cache->block[replacePos].dirty = (label==1)?true:false;
                cache->block[replacePos].tag = tag;
                cache->block[replacePos].flag = demandFetch;
                locate = true;
            }
            // read data from lower memory to cache block
            BFM++;
        }
        if(label == 0)
            readData++;
        else if(label == 1)
            writeData++;
    }
    /* end simulation*/
    for(int i = 0; i < cache->blockNum; i++)
    {
        if(cache->block[i].dirty)
            BTM++;
    }
    printf("Input file = %s\n", cache->file);
    printf("Demand Fetch = %d\n", demandFetch);
    printf("Cache hit = %d\n", cacheHit);
    printf("Cache miss = %d\n", cacheMiss);
    printf("Miss rate = %.4f\n", ((double)cacheMiss / (double)demandFetch));
    printf("Read data = %d\n", readData);
    printf("Write data = %d\n", writeData);
    printf("Bytes from memory = %d\n", BFM*cache->block_size);
    printf("Bytes to memory = %d\n", BTM*cache->block_size);
    return;
}
int main(int argc, char** argv)
{
    Cache cache;
    setParameter(argc, argv, &cache);
    simulation(&cache);
    return 0;
}

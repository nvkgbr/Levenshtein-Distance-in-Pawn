new matrix[128][128];
stock Levenshtein_distance(string1[], string2[])//https://en.wikibooks.org/wiki/Algorithm_Implementation/Strings/Levenshtein_distance#C
{
    static x,y,s1len, s2len;
 
    s1len = strlen(string1);
    s2len  = strlen(string2);
 
    matrix[0][0] = 0;
 
    for (x = 1; x <= s2len ; x++) matrix[x][0] = matrix[x-1][0] + 1;
    for(y = 1; y <= s1len; y++) matrix[0][y] = matrix[0][y-1] + 1;
    for (x = 1; x <= s2len ; x++)
    {
        for (y = 1; y <= s1len; y++) matrix[x][y] = MIN3(matrix[x-1][y] + 1,matrix[x][y-1] + 1,matrix[x-1][y-1] + _: !(string1[y-1] == string2[x-1]));
    }
    return(matrix[s2len][s1len]);
}
MIN3(a,b,c) return a<b?a<c?a:c:b<c?b:c;
 

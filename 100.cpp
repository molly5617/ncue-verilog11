#include <iostream>
using namespace std;
int main()
{
    int i, j;
    while (cin >> i >> j)
    {
        int a = i;
        int b = j;
        if (i > j)
        {
            int temp = i;
            i = j;
            j = temp;
        }
        int max = 0;
        for (int k = i; k <= j; k++)
        {
            int n = k;
            int len = 0;
            while (true)
            {
                if (n == 1)
                    break;
                else if (n % 2 == 1)
                    n = 3 * n + 1;
                else
                    n = n / 2;

                len++;
            }
            len++;
            if (len > max)
                max = len;
        }
        cout << a << " " << b << " " << max << endl;
    }
}
#include <iostream>
#include <fstream>
#include <string>
#include <vector>
using namespace std;

int main ()
{
    //variables:
    vector<double>x,y;
    double dx{0},integral{0};
    string line;

    //input/output:
    ifstream in {"z.grad"};
    ofstream out {"z.pmf"};
    for(double col1{0},col2{0}; in >> col1 >> col2;)
    {
        x.push_back(col1);
        y.push_back(col2);
    }
    dx = x[1]-x[0];

    //simpson's rule:
    //integral = dx/3 * (y0+4y1+2y2+4y3+2y4+...+yn)
    integral = 0;
    for(int i{0}; i<x.size(); ++i)
    {
        if(i==0||i==x.size()-1)
            integral+= y[i] *dx/3;
        else if(i%2==1)
            integral+=4* y[i] *dx/3;
        else
            integral+=2* y[i] *dx/3;
        out << x[i] << '\t' << integral << endl;
    }

    return 0;
}


//However, the PMF as function of the radial spherical coordinate should be zero at the maximum radial distance, not at the minimum. Thus the following code should be run after the previous one, only for that variable:

#include <iostream>
#include <fstream>
#include <string>
#include <vector>
using namespace std;

int main ()
{
    //variables:
    vector<double>x,y;
    string line;

    //input:
    ifstream in {"z.pmf"};
    ofstream out {"z1.pmf"};
    for(double col1{0},col2{0}; in >> col1 >> col2;)
    {
      x.push_back(col1);
      y.push_back(col2);
    }

    //output:
    for(int i{0}; i<x.size(); ++i)
      out << x[i] << '\t' << y[i]-y.back() << endl;
    return 0;
}

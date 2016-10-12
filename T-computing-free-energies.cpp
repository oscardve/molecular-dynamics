#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <math.h>
using namespace std;

int main ()
{
    //constants:
    constexpr double PI{3.1416},kB{0.001986},T{300};
    double beta = 1/(kB*T);
    double equilVal{0},kspring{0};
    cin >> equilVal >> kspring;
    cout << equilVal << '\t' << kspring << endl;

    //variables:
    vector<double>x,y;
    double dx{0},integral{0},num{0},den{0};
    string line;

    //input:
    ifstream in {"z.pmf"};
    for(double col1{0},col2{0}; in >> col1 >> col2;)
    {
        x.push_back(col1);
        y.push_back(col2);
    }
    dx = x[1]-x[0];

    //simpson's rule: integral = dx/3 * (y0 + 4y1 + 2y2 + 4y3 + 2y4 + ... + yn)
    integral = 0;
    for(int i{0}; i<x.size(); ++i)
    {
        if(i==0||i==x.size()-1)
            integral+=   exp(-beta*y[i]);
        else if(i%2==1)
            integral+=4* exp(-beta*y[i]);
        else
            integral+=2* exp(-beta*y[i]);
    }
    num = dx/3*integral;
    cout << "Numerator: " << num << '\n';

    //simpson's rule: integral = dx/3 * (y0 + 4y1 + 2y2 + 4y3 + 2y4 + ... + yn)
    integral = 0;
    for(int i{0}; i<x.size(); ++i)
    {
        if(i==0||i==x.size()-1)
            integral+=   exp(-beta*(y[i]+0.5*kspring*pow(x[i]-equilVal,2)));
        else if(i%2==1)
            integral+=4* exp(-beta*(y[i]+0.5*kspring*pow(x[i]-equilVal,2)));
        else
            integral+=2* exp(-beta*(y[i]+0.5*kspring*pow(x[i]-equilVal,2)));
    }
    den = dx/3*integral;
    cout << "Denominator: " << den << '\n';
    
    cout << "Free energy: " << log(num/den)/beta << '\n';

    return 0;
}

//Suppose the name of this code is "dg.cpp", and the PMF simulation involves a restraint over the Euler angle Theta, whose equilibrium value is 114.23 degrees and whose spring constant is 0.1, then the free energy may be computed by pasting the following in a Linux terminal:

equilVal=114.23
kspring=0.1
./dg << EOF
$equilVal
$kspring
EOF

//However, the free energy corresponding to the radial spherical coordinate is computed from different expressions, as explained in the methodology. Suppose the equilibrium values of the spherical angles are 30.988 and 108.011 degrees, and that their spring constants are 0.1. Then the free energy may be computed through the following code:

#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <math.h>
using namespace std;

int main ()
{
    //constants:
    constexpr double PI{3.1416},kB{0.001986},T{300},c0{0.000602};
    double beta = 1/(kB*T);
    double theta0{30.988*PI/180},ktheta{0.1*180/PI*180/PI};
    double phi0{108.011*PI/180},kphi{0.1*180/PI*180/PI};
    cout<<"beta = "<<beta<<endl;

    //variables:
    vector<double>x,y,theta,phi;
    double integral{0},num{0},den{0},dx{0};
    double rinf{0},thetaInt{0},phiInt{0},I{0},S{0};
    string line;
    for(int i=0; i<=180; ++i)
        theta.push_back(i*PI/180);
    double dtheta = theta[1]-theta[0];
    for(int i=0; i<=360; ++i)
        phi.push_back(i*PI/180);
    double dphi = phi[1]-phi[0];

    //input:
    ifstream in {"z.pmf"};
    getline(in,line);//ignore 1st line
    for(double col1{0},col2{0}; in >> col1 >> col2;)
    {
        x.push_back(col1);
        y.push_back(col2);
    }
    dx = x[1]-x[0]; rinf = x.back();

    //simpson's rule: integral = dx/3 * (y0 + 4y1 + 2y2 + 4y3 + 2y4 + ... + yn)
    integral = 0;
    for(int i{0}; i<x.size(); ++i)
    {
        if(i==0||i==x.size()-1)
            integral+=   exp(-beta*(y[i]-y.back()));
        else if(i%2==1)
            integral+=4* exp(-beta*(y[i]-y.back()));
        else
            integral+=2* exp(-beta*(y[i]-y.back()));
    }
    I = dx/3*integral;
    cout << "I: " << I << '\n';

    //theta integral = dx/3 * (y0 + 4y1 + 2y2 + 4y3 + 2y4 + ... + yn)
    integral = 0;
    for(int i{0}; i<theta.size(); ++i)
    {
        if(i==0||i==theta.size()-1)
            integral+=   sin(theta[i])*exp(-beta*0.5*ktheta*pow(theta[i]-theta0,2));
        else if(i%2==1)
            integral+=4* sin(theta[i])*exp(-beta*0.5*ktheta*pow(theta[i]-theta0,2));
        else
            integral+=2* sin(theta[i])*exp(-beta*0.5*ktheta*pow(theta[i]-theta0,2));
    }
    thetaInt = dtheta/3*integral;
    cout << "thetaInt " << thetaInt <<endl;
    
    //phi integral = dx/3 * (y0 + 4y1 + 2y2 + 4y3 + 2y4 + ... + yn)
    integral = 0;
    for(int i{0}; i<phi.size(); ++i)
    {
        if(i==0||i==phi.size()-1)
            integral+=   exp(-beta*0.5*kphi*pow(phi[i]-phi0,2));
        else if(i%2==1)
            integral+=4* exp(-beta*0.5*kphi*pow(phi[i]-phi0,2));
        else
            integral+=2* exp(-beta*0.5*kphi*pow(phi[i]-phi0,2));
    }
    phiInt = dphi/3*integral;
    cout << "phiInt " << phiInt <<endl;
    S = pow(rinf,2)*thetaInt*phiInt;

    cout << "S: " << S << '\n';
    cout << "Free energy: " << -log(S*I*c0)/beta << '\n';

    return 0;
}

/*
  Author : Aziz Amerul Faozi
  Description :
  This code to provide access for c api.
*/

//#include<aishiteru/capi.h>
#include<iostream>

using namespace std;
class mantap{
public:
  mantap();
  ~mantap();
  
private:
  int x_mantap;
  int y_mantap;

};

mantap::mantap(){
  cout<<"mantap"<<endl;
}

mantap::~mantap(){
  cout<<"destruktor"<<endl;

}

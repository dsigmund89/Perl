#include<iostream>
#include<fstream>
#include<string>

using namespace std;

int main()
{
	ifstream fin("input.txt");
	ofstream fout("output.txt");

	string text;
	fin >> text;
	fout << text;

	fin.close();
	fout.close();

	return 0;
}
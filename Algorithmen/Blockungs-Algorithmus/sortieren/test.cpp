#include <gecode/driver.hh>
#include <gecode/int.hh>
#include <gecode/minimodel.hh>
#include <gecode/gist.hh>
#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
#include <map>
#include <vector>
#include <windows.h>
#include <WinBase.h>
#include <random>
#include <vector>

using namespace Gecode;

typedef std::vector<std::pair<std::string, int>> TVariablesIndices;
typedef std::pair<std::string, int> TVariableIndex;
typedef std::vector<std::pair<std::string, BoolVar>> TVariablesList;
typedef std::map<std::string, BoolVar> TVariablesMap;
typedef std::pair<std::string, BoolVar> TVariablesPair;

class File2Constraints : public Script {
protected:
	BoolVarArray allVariables;
	TVariablesIndices variablesIndices;
	int varCounter = 0;
	int constrCounter = 0;
	double PCFreq = 0.0;
	__int64 CounterStart = 0;
	bool isGist = false;
public:
	File2Constraints(const Options& opt)
	{

		if (opt.mode() == SM_GIST)
		{
			isGist = true;
		}

		TVariablesMap variablesMap;
		TVariablesList variablesList;

		std::cout << "Reading model.txt" << std::endl;
		std::ifstream infile("C:\\Users\\Philipp\\Desktop\\ba\\gecode-tests\\model.txt");
		std::string line;
		while (std::getline(infile, line))
		{
			std::istringstream iss(line);
			std::string command;
			if (!(iss >> command)) continue;

			if (command == "BINVAR")
			{
				std::string varName;
				if (!(iss >> varName))
				{
					std::cout << "Fehler varName fehlt";
					throw "Fehler varName fehlt";
				}

				BoolVar newVar(*this, 0, 1);
				variablesMap.insert(TVariablesPair(varName, newVar));
				variablesList.push_back(TVariablesPair(varName, newVar));
				varCounter++;
			}
			else if (command == "SUMEQ")
			{
				int sumValue;
				if (!(iss >> sumValue))
				{
					std::cout << "Summe konnte nicht gelesen werden";
					throw "Summe konnte nicht gelesen werden";
				}

				std::string varName;
				std::vector<BoolVar> variables;
				while (iss >> varName)
				{
					variables.push_back(variablesMap[varName]);
				}

				BoolVarArgs varArgs(variables);
				linear(*this, varArgs, IRT_EQ, sumValue);
				constrCounter++;

			}
			else if (command == "SUMLEQ")
			{
				int sumValue;
				if (!(iss >> sumValue))
				{
					std::cout << "Summe konnte nicht gelesen werden";
					throw "Summe konnte nicht gelesen werden";
				}

				std::string varName;
				std::vector<BoolVar> variables;
				while (iss >> varName)
				{
					variables.push_back(variablesMap[varName]);
				}

				BoolVarArgs varArgs(variables);
				linear(*this, varArgs, IRT_LQ, sumValue);
				constrCounter++;

			}
			else if (command == "MAXONESET")
			{
				std::string varName;
				std::vector<BoolVar> variables;
				while (iss >> varName)
				{
					variables.push_back(variablesMap[varName]);
				}

				BoolVarArgs varArgs(variables);
				linear(*this, varArgs, IRT_LQ, 1);

				/*int varCount = variables.size();
				for (int i = 0; i < varCount - 1; i++)
				{
				for (int j = i + 1; j < varCount; j++)
				{
				rel(*this, variables[i], BOT_AND, variables[j], 0);
				}
				}*/


				constrCounter++;
			}
			else if (command == "EXACTLYONESET")
			{
				std::string varName;
				std::vector<BoolVar> variables;
				while (iss >> varName)
				{
					variables.push_back(variablesMap[varName]);
				}

				BoolVarArgs varArgs(variables);
				linear(*this, varArgs, IRT_EQ, 1);

				constrCounter++;
			}
			else if (command == "VARSEQ")
			{
				std::string varName1;
				if (!(iss >> varName1)) {
					std::cout << "Fehler varName1 für VARSEQ fehlt";
					throw "Fehler varName1 für VARSEQ fehlt";
				}

				std::string varName2;
				if (!(iss >> varName2)) {
					std::cout << "Fehler varName2 für VARSEQ fehlt";
					throw "Fehler varName2 für VARSEQ fehlt";
				}

				rel(*this, variablesMap[varName1], IRT_EQ, variablesMap[varName2]);
				constrCounter++;
			}
			else if (command == "VARSLEQ")
			{
				std::string varName1;
				if (!(iss >> varName1)) {
					std::cout << "Fehler varName1 für VARSLEQ fehlt";
					throw "Fehler varName1 für VARSLEQ fehlt";
				}

				std::string varName2;
				if (!(iss >> varName2)) {
					std::cout << "Fehler varName2 für VARSLEQ fehlt";
					throw "Fehler varName2 für VARSLEQ fehlt";
				}

				rel(*this, variablesMap[varName1], IRT_LQ, variablesMap[varName2]);
				constrCounter++;
			}
			else if (command == "VARLEQSUM")
			{
				std::string varName1;
				if (!(iss >> varName1)) {
					std::cout << "Fehler varName1 für VARLEQSUM fehlt";
					throw "Fehler varName1 für VARLEQSUM fehlt";
				}

				std::string varName;
				std::vector<BoolVar> variables;
				while (iss >> varName)
				{
					variables.push_back(variablesMap[varName]);
				}

				// varName1 <= \sum variables
				// entspricht   -VarName1 OR variables
				BoolVarArgs varArgs(variables);
				std::vector<BoolVar> negVariables;
				negVariables.push_back(variablesMap[varName1]);
				BoolVarArgs negVarArgs(negVariables);
				clause(*this, BOT_OR, varArgs, negVarArgs, 1);
				constrCounter++;
			}
			else if (command == "FIXONE")
			{
				std::string varName;
				if (!(iss >> varName))
				{
					std::cout << "Fehler varName für FIXONE fehlt";
					throw "Fehler varName für FIXONE fehlt";
				}

				rel(*this, variablesMap[varName], IRT_EQ, 1);
				constrCounter++;
			}
			else if (command == "FIXZERO")
			{
				std::string varName;
				if (!(iss >> varName))
				{
					std::cout << "Fehler varName für FIXZERO fehlt";
					throw "Fehler varName für FIXZERO fehlt";
				}

				rel(*this, variablesMap[varName], IRT_EQ, 0);
				constrCounter++;
			}
			else
			{
				std::cout << "Fehler unbekannter Befehl " << command;
				throw "Fehler unbekannter Befehl";
			}
		}

		std::cout << "Stats: " << varCounter << " Vars, " << constrCounter << " Constraints" << std::endl;

		allVariables = BoolVarArray(*this, variablesList.size());
		
		int varsCount = variablesList.size();
		int varIndex = 0;
		for (TVariablesList::iterator it = variablesList.begin(); it != variablesList.end(); ++it)
		{
			allVariables[varIndex] = it->second;
			variablesIndices.push_back(TVariableIndex(it->first, varIndex));
			varIndex++;
		}

		std::cout << "Through" << std::endl;

		/*Rnd firstRnd;
		Rnd secondRnd;
		firstRnd.time();
		Sleep(20);
		secondRnd.time();*/

		LARGE_INTEGER li;
		if (!QueryPerformanceFrequency(&li))
			std::cout << "QueryPerformanceFrequency failed!\n";
		PCFreq = double(li.QuadPart) / 1000.0;
		QueryPerformanceCounter(&li);
		CounterStart = li.QuadPart;

		//branch(*this, allVariablesArgs, INT_VAR_RND(firstRnd), INT_VAL_RND(secondRnd));
		branch(*this, allVariables, INT_VAR_NONE(), INT_VAL_MAX());

	}

	// Print solution
	virtual void
		print(std::ostream& os) const {
			LARGE_INTEGER li;
			QueryPerformanceCounter(&li);
			double elapsedTime;
			elapsedTime = double(li.QuadPart - CounterStart) / PCFreq;
			if (isGist)
			{
				int zeitslotsCount = 38;
				int varsCount = allVariables.size();
				if (varsCount % zeitslotsCount != 0) {
					os << "WARNING: ZeitslotsCount is wrong, i.e. table layout is not correct.";
				}
				for (int i = 0; i < varsCount; i++)
				{
					if (i % zeitslotsCount == 0) os << std::endl;
					else os << "\t";
					os << allVariables[i];
				}
			}
			else
			{
				std::ofstream myfile;
				myfile.open("results.txt");
				os << "\t" << allVariables << std::endl;
				int unassignedCount = 0;
				int setCount = 0;
				int unsetCount = 0;
				for (TVariablesIndices::const_iterator it = variablesIndices.begin(); it != variablesIndices.end(); ++it)
				{
					//os << "\t" << it->first << ": ";
					BoolVar variable = allVariables[it->second];
					if (variable.assigned())
					{
						//os << it->second.val() << std::endl;
						if (variable.val() == 1)
						{
							myfile << it->first << std::endl;
							setCount++;
						}
						else
						{
							unsetCount++;
						}
					}
					else
					{
						unassignedCount++;
						//os << "-" << std::endl;
					}
				}
				os << "Stats: " << varCounter << " Vars, " << constrCounter << " Constraints" << std::endl;
				os << "Time: " << elapsedTime << "ms" << std::endl;
				os << "Set to 1: " << setCount << "; Set to 0: " << unsetCount << "; Unassigned: " << unassignedCount << std::endl;
				myfile.close();
				os << "Wrote results.txt" << std::endl;
			}
		}

	// Constructor for cloning
	File2Constraints(bool share, File2Constraints& s) : Script(share, s) {
		varCounter = s.varCounter;
		constrCounter = s.constrCounter;
		PCFreq = s.PCFreq;
		CounterStart = s.CounterStart;
		isGist = s.isGist;
		allVariables.update(*this, share, s.allVariables);
		variablesIndices = s.variablesIndices;
	}

	// Copy during cloning
	virtual Space*
		copy(bool share) {
			//std::cout << "Cloning" << std::endl;
			return new File2Constraints(share, *this);
		}
};

int
main(int argc, char* argv[]) {
	Options opt("File2Constraints");
	//opt.icl(ICL_BND);
	opt.mode(SM_GIST);
	opt.parse(argc, argv);
	std::cout << "C_D: " << opt.c_d() << std::endl;
	std::cout << "A_D: " << opt.c_d() << std::endl;
	Script::run<File2Constraints, DFS, Options>(opt);
	return 0;
}

// STATISTICS: example-any

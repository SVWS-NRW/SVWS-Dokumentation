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

using namespace Gecode;

typedef std::map<std::string, int> TVariablesIndices;
typedef std::pair<std::string, int> TVariableIndex;
typedef std::map<std::string, IntVar> TVariablesMap;
typedef std::pair<std::string, IntVar> TVariablesPair;
typedef std::map<std::string, BoolVar> TBoolVariablesMap;
typedef std::pair<std::string, BoolVar> TBoolVariablesPair;

class File2Constraints : public Script {
protected:
	IntVarArray allVariables;
	BoolVarArray allBoolVariables;
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
		TBoolVariablesMap boolVariablesMap;

		std::cout << "Reading model.txt" << std::endl;
		std::ifstream infile("model.txt");
		std::string line;
		while (std::getline(infile, line))
		{
			std::istringstream iss(line);
			std::string command;
			if (!(iss >> command)) continue;

			if (command == "INTVAR")
			{

				int minValue;
				if (!(iss >> minValue))
				{
					std::cout << "Minimum konnte nicht gelesen werden";
					throw "Minimum konnte nicht gelesen werden";
				}

				int maxValue;
				if (!(iss >> maxValue))
				{
					std::cout << "Maximum konnte nicht gelesen werden";
					throw "Maximum konnte nicht gelesen werden";
				}

				std::string varName;
				if (!(iss >> varName))
				{
					std::cout << "Fehler varName fehlt";
					throw "Fehler varName fehlt";
				}

				IntVar newVar(*this, minValue, maxValue);
				variablesMap.insert(TVariablesPair(varName, newVar));
				varCounter++;
			}
			else if (command == "BINVAR")
			{
				std::string varName;
				if (!(iss >> varName))
				{
					std::cout << "Fehler varName fehlt";
					throw "Fehler varName fehlt";
				}

				BoolVar newVar(*this, 0, 1);
				boolVariablesMap.insert(TBoolVariablesPair(varName, newVar));
				varCounter++;
			}
			else if (command == "ALLDIFF")
			{
				std::string varName;
				std::vector<IntVar> variables;
				while (iss >> varName)
				{
					variables.push_back(variablesMap[varName]);
				}

				IntVarArgs varArgs(variables);
				distinct(*this, varArgs);
				constrCounter++;

			}
			else if (command == "SORTED")
			{
				std::string varName;
				std::vector<IntVar> variables;
				while (iss >> varName)
				{
					variables.push_back(variablesMap[varName]);
				}

				IntVarArgs varArgs(variables);
				rel(*this, varArgs, IRT_LE);
				constrCounter++;
			}
			else if (command == "COUNT")
			{
				int countResult;
				if (!(iss >> countResult))
				{
					std::cout << "CountResult konnte nicht gelesen werden";
					throw "CountResult konnte nicht gelesen werden";
				}

				int countValue;
				if (!(iss >> countValue))
				{
					std::cout << "CountValue konnte nicht gelesen werden";
					throw "CountValue konnte nicht gelesen werden";
				}

				std::string varName;
				std::vector<IntVar> variables;
				while (iss >> varName)
				{
					variables.push_back(variablesMap[varName]);
				}

				IntVarArgs varArgs(variables);
				count(*this, varArgs, countValue, IRT_EQ, countResult);
				constrCounter++;
			}
			else if (command == "NEQTO")
			{
				int rhs;
				if (!(iss >> rhs))
				{
					std::cout << "rhs konnte nicht gelesen werden";
					throw "rhs konnte nicht gelesen werden";
				}

				std::string varName;
				std::vector<IntVar> variables;
				while (iss >> varName)
				{
					variables.push_back(variablesMap[varName]);
				}

				IntVarArgs varArgs(variables);
				rel(*this, varArgs, IRT_NQ, rhs);
				constrCounter++;
			}
			else if (command == "FIX")
			{
				int rhs;
				if (!(iss >> rhs))
				{
					std::cout << "rhs konnte nicht gelesen werden";
					throw "rhs konnte nicht gelesen werden";
				}

				std::string varName;
				if (!(iss >> varName))
				{
					std::cout << "varName konnte nicht gelesen werden";
					throw "varName konnte nicht gelesen werden";
				}

				rel(*this, variablesMap[varName], IRT_EQ, rhs);
				constrCounter++;
			}
			else if (command == "DOPPCONSTR")
			{
				std::string firstVarName;
				if (!(iss >> firstVarName))
				{
					std::cout << "firstVarName konnte nicht gelesen werden";
					throw "firstVarName konnte nicht gelesen werden";
				}

				int firstValue;
				if (!(iss >> firstValue))
				{
					std::cout << "firstValue konnte nicht gelesen werden";
					throw "firstValue konnte nicht gelesen werden";
				}

				std::string secondVarName;
				if (!(iss >> secondVarName))
				{
					std::cout << "secondVarName konnte nicht gelesen werden";
					throw "secondVarName konnte nicht gelesen werden";
				}

				int secondValue;
				if (!(iss >> secondValue))
				{
					std::cout << "secondValue konnte nicht gelesen werden";
					throw "secondValue konnte nicht gelesen werden";
				}

				BoolVar firstReifiedVar(*this, 0, 1);
				boolVariablesMap.insert(TBoolVariablesPair(firstVarName + "=" + std::to_string(firstValue), firstReifiedVar));
				varCounter++;

				BoolVar secondReifiedVar(*this, 0, 1);
				boolVariablesMap.insert(TBoolVariablesPair(secondVarName + "=" + std::to_string(secondValue), secondReifiedVar));
				varCounter++;

				rel(*this, variablesMap[firstVarName], IRT_EQ, firstValue, firstReifiedVar);
				constrCounter++;

				rel(*this, variablesMap[secondVarName], IRT_EQ, secondValue, secondReifiedVar);
				constrCounter++;

				rel(*this, firstReifiedVar, IRT_EQ, secondReifiedVar);
				constrCounter++;
			}
			else
			{
				std::cout << "Fehler unbekannter Befehl " << command;
				throw "Unbekannter Befehl";
			}
		}

		std::cout << "Stats: " << varCounter << " Vars, " << constrCounter << " Constraints" << std::endl;

		allVariables = IntVarArray(*this, variablesMap.size());
		allBoolVariables = BoolVarArray(*this, boolVariablesMap.size());
		
		int varIndex = 0;
		for (TVariablesMap::iterator it = variablesMap.begin(); it != variablesMap.end(); ++it)
		{
			allVariables[varIndex] = it->second;
			variablesIndices.insert(TVariableIndex(it->first, varIndex));
			varIndex++;
		}

		varIndex = 0;
		for (TBoolVariablesMap::iterator it = boolVariablesMap.begin(); it != boolVariablesMap.end(); ++it)
		{
			allBoolVariables[varIndex] = it->second;
			varIndex++;
		}


		std::cout << "Through" << std::endl;

		Rnd firstRnd;
		firstRnd.time();
		/*Sleep(20);
		Rnd secondRnd;
		secondRnd.time();*/

		LARGE_INTEGER li;
		if (!QueryPerformanceFrequency(&li))
			std::cout << "QueryPerformanceFrequency failed!\n";
		PCFreq = double(li.QuadPart) / 1000.0;
		QueryPerformanceCounter(&li);
		CounterStart = li.QuadPart;

		//branch(*this, allVariablesArgs, INT_VAR_RND(firstRnd), INT_VAL_RND(secondRnd));
		//branch(*this, allVariables, INT_VAR_SIZE_MIN(), INT_VAL_MIN());
		branch(*this, allVariables, INT_VAR_NONE(), INT_VAL_MIN());
		//branch(*this, allVariables, INT_VAR_RND(firstRnd), INT_VAL_MIN());

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
				for (TVariablesIndices::const_iterator it = variablesIndices.begin(); it != variablesIndices.end(); ++it)
				{
					//os << "\t" << it->first << ": ";
					IntVar variable = allVariables[it->second];
					if (variable.assigned())
					{
						myfile << it->first << " == " << variable.val() << std::endl;
					}
					else
					{
						unassignedCount++;
					}
				}
				os << "Stats: " << varCounter << " Vars, " << constrCounter << " Constraints" << std::endl;
				os << "Time: " << elapsedTime << "ms" << std::endl;
				os << "Unassigned: " << unassignedCount << std::endl;
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
		allBoolVariables.update(*this, share, s.allBoolVariables);
		variablesIndices = s.variablesIndices;
		//variablesMap = s.variablesMap;
		//allVariablesArgs = BoolVarArgs(s.allVariablesArgs);
		//allVariablesArgs.update(*this, share, s.allVariablesArgs);
		//sallVariablesArgs = new BoolVarArgs(s.allVariablesArgs)
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

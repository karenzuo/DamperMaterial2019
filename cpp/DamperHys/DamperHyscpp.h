#include <UniaxialMaterial.h>

class DamperHyscpp : public UniaxialMaterial
{
	public:
		DamperHyscpp(int tag, double k1, double k2, double k3, double ey, double eu);	// constructor 1
		DamperHyscpp();									// constructor 2

		~DampesrHyscpp();								// destructor

		int setTrialStrain(double strain, double strainRate = 0.0)
		double getStrain(void);
		double getStress(void);
		double getTangent(void);
		double getInitialTangent(void) { return E; };

		int commitState(void);
		int revertToLastCommit(void);
		int revertToStart(void);

		UniaxialMaterial *getCopy(void);
		int sendSelf(int commitTag, Channel &theChannel);
		int recvSelf(int commitTag, Channel &theChannel,
			FEM_ObjectBroker &theBroker);

		void Print(OPS_Stream &s, int flag = 0);

	protected:

	private:
		double k1;				// Stiffness k1
		double k2;              // Stiffness k2
		double k3;
		double ey;
		double eu;
		double stressT;
		double strainT;
		double tangentT;
		double dstrainT;
		double stressC;
		double strainC;
		double tangentC;
		double dstrainC;
		double strainCmin;
		double strainCmax;			// 
};
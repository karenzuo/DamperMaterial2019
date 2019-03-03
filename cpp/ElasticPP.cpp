/* ****************************************************************** **
**    OpenSees - Open System for Earthquake Engineering Simulation    **
**          Pacific Earthquake Engineering Research Center            **
**                                                                    **
**                                                                    **
** (C) Copyright 1999, The Regents of the University of California    **
** All Rights Reserved.                                               **
**                                                                    **
** Commercial use of this program without express permission of the   **
** University of California, Berkeley, is strictly prohibited.  See   **
** file 'COPYRIGHT'  in main directory for information on usage and   **
** redistribution,  and for a DISCLAIMER OF ALL WARRANTIES.           **
**                                                                    **
** Developed by:                                                      **
**   Frank McKenna (fmckenna@ce.berkeley.edu)                         **
**   Gregory L. Fenves (fenves@ce.berkeley.edu)                       **
**   Filip C. Filippou (filippou@ce.berkeley.edu)                     **
**                                                                    **
** ****************************************************************** */
                                                                        
// $Revision: 1.7 $
// $Date: 2009/03/23 23:17:04 $
// $Source: /usr/local/cvs/OpenSees/PACKAGES/NewMaterial/cpp/DamperHyscpp.cpp,v $
                                                                        
// Written: fmk 
//
// Description: This file contains the class implementation for 
// ElasticMaterial. 
//
// What: "@(#) DamperHyscpp.C, revA"


#include <elementAPI.h>
#include "DamperHyscpp.h"
#include <Vector.h>
#include <Channel.h>
#include <math.h>
#include <float.h>


#ifdef _USRDLL
#define OPS_Export extern "C" _declspec(dllexport)
#elif _MACOSX
#define OPS_Export extern "C" __attribute__((visibility("default")))
#else
#define OPS_Export extern "C"
#endif

 /////////////////// Static variables //////////////////////////
static int numDamperHyscpp = 0;    

OPS_Export void *
OPS_DamperHyscpp()
{
  // print out some KUDO's
  if (numDamperHyscpp == 0) {
    opserr << "DamperHyscpp unaxial material - Written by fmk UC Berkeley Copyright 2008 - Use at your Own Peril\n";
    numDamperHyscpp =1;
  }

  // Pointer to a uniaxial material that will be returned
  UniaxialMaterial *theMaterial = 0;

  //
  // parse the input line for the material parameters
  //

  int    iData[1];
  double dData[2];
  int numData;
  numData = 1;
  if (OPS_GetIntInput(&numData, iData) != 0) {
    opserr << "WARNING invalid uniaxialMaterial DamperHys tag" << endln;
    return 0;
  }

  numData = 2;
  if (OPS_GetDoubleInput(&numData, dData) != 0) {
    opserr << "WARNING invalid E & ep\n";
    return 0;	
  }

  // 
  // create a new material
  //

  theMaterial = new DamperHyscpp(iData[0], dData[0], dData[1], dData[2], dData[3], dData[4]);  //??

  if (theMaterial == 0) {
    opserr << "WARNING could not create uniaxialMaterial of type DamperHyscpp\n";
    return 0;
  }

  // return the material
  return theMaterial;
}




DamperHyscpp::DamperHyscpp(int tag, double k1, double k2, double k3, double ey, double eu)
:UniaxialMaterial(tag, 0),
 ezero(0.0), strainT(0.0), stressT(0.0), tangentT(0.0), dstrainT(0.0)
 strainC(0.0), stressC(0.0), tangentC(0.0), dstrainC(0.0), strainCmax(0.0), strainCend(0.0), Result(0.0)
{
  fyp = E*eyp;
  fyn = -fyp;   ///delete?
}

DamperHyscpp::DamperHyscpp()
:UniaxialMaterial(0, 0),
 fyp(0.0), fyn(0.0), ///delete? 
	ezero(0.0), strainT(0.0), stressT(0.0), tangentT(0.0), dstrainT(0.0)
	strainC(0.0), stressC(0.0), tangentC(0.0), dstrainC(0.0), strainCmax(0.0), strainCend(0.0), Result(0.0)

}
///////////////  Destructor  //////////////////
DamperHyscpp::~DamperHyscpp()
{
  // does nothing
}
//////////////   setTrianlStrain() Method   ////////////////
int 
DamperHyscpp::setTrialStrain(double strain, double strainRate)
{
	dstrainT = strainT - strainC;         ///Trial - Commit

		//////////////////// 1 /////////////////////////
		if  strainT >= strainCmax
			strainCmax = strainT;
	if strainT > 0 && strainT < ey
		Result = stressC + k1 * dstrainT;
	    tangentT = k1;
	else  if strainT > ey && strainT < eu
		Result = stressC + k2 * dstrainT;
	    tangentT = k2;
	

		/////////////////////// 2 //////////////////////////////
		else if strainT <= strainCmin
		strainCmin = strainT;
	if strainT < 0 && strainT > -ey
		Result = stressC + k1 * dstrainT;
	    tangentT = k1;
	    else  if strainT > -eu && strainT < -ey
		Result = stressC + k2 * dstrainT;
	    tangentT = k2;
	

		//////////////////////  3 ///////////////////////////////////
		else if dstrainT > 0 && dstrainC < 0 % direction from - to +
		if strainT > -ey && strainT < ey
			Result = stressC + k1 * dstrainT;
	        tangentT = k1;
	    else if strainT < -ey
		Result = -k1 * ey + (strainT + ey)*k3;
	    tangentT = 1e10; %stub
		else if strainT > ey
		Result = k1 * ey + (strainT - ey)*k2;
	    tangentT = k2;


		else if dstrainT < 0 && dstrainC > 0 % direction from + to -
		if strainT > -ey && strainT < ey
			Result = stressC + k1 * dstrainT;
	        tangentT = k1;
	    else if strainT > ey
		Result = k1 * ey + (strainT - ey)*k3;
	    tangentT = 1e10; %stub
		else if strainT < -ey
		Result = -k1 * ey + (strainT + ey)*k2;
	    tangentT = k2;


		/////////////////////  4 /////////////////////////////
		else if dstrainT > 0
		if strainT < -ey
			Result = stressC + k3 * dstrainT;
	        tangentT = k3;
	    else if strainT > -ey && strainT < ey
		Result = stressC + k1 * dstrainT;
	    tangentT = k1;
		else if straintT > ey && strainT < eu
			Result = stressC + k2 * dstrainT;
	        tangentT = k2;
	

		/////////////////////// 5 /////////////////////////////
		else if dstrainT <= 0
		if strainT < eu && strainT > ey
			Result = stressC + k3 * dstrainT;
	        tangentT = k3;
	    else if strainT > -ey && strainT < ey
		Result = stressC + k1 * dstrainT;
	    tangentT = k1;
		else if straintT > -eu && strainT < -ey
			Result = stressC + k2 * dstrainT;
	        tangentT = k2;
	

double 
DamperHyscpp::getStrain(void)
{
  return strainT;
}

double 
DamperHyscpp::getStress(void)
{
  return stressT;
}


double 
DamperHyscpp::getTangent(void)
{
  return tangentT;
}

int 
DamperHyscpp::commitState(void)
{
    double sigtrial;	// trial stress
    double f;		// yield function

    // compute trial stress
    sigtrial = E * ( trialStrain - ezero - ep );

    // evaluate yield function
    if ( sigtrial >= 0.0 )
	f =  sigtrial - fyp;
    else
	f = -sigtrial + fyn;

    double fYieldSurface = - E * DBL_EPSILON;
    if ( f > fYieldSurface ) {
      // plastic
      if ( sigtrial > 0.0 ) {
	ep += f / E;
      } else {
	ep -= f / E;
      }
    }

    strainC = strainT;
    tangentC = tangentT;
    stressC = stressT;

    return 0;
}	


int 
DamperHyscpp::revertToLastCommit(void)
{
  strainT = strainC;
  tangentT = tangentC;
  stressT = stressC;

  return 0;
}


int 
DamperHyscpp::revertToStart(void)
{
  strainT = strainC = 0.0;
  tangentT = tangentC = E;
  stressT = stressC = 0.0;

  ep = 0.0;

  return 0;
}


UniaxialMaterial *
DamperHyscpp::getCopy(void)
{
  DamperHyscpp *theCopy =
    new DamperHyscpp(this->getTag(),E,fyp/E);
  theCopy->ep = this->ep;
  
  return theCopy;
}


int 
DamperHyscpp::sendSelf(int cTag, Channel &theChannel)
{
  int res = 0;
  static Vector data(9);
  data(0) = this->getTag();
  data(1) = k1;
  data(2) = k2;
  data(3) = k3;
  data(4) = ey;
  data(5) = eu;
  data(6) = stressT;
  data(7) = strainT;
  data(8) = tangentT;
  data(9) = dstrainT;
  data(10) = stressC;
  data(11) = strainC;
  data(12) = tangentC;
  data(13) = dstrainC;
  data(14) = strainCmin;
  data(15) = strainCmax;

  res = theChannel.sendVector(this->getDbTag(), cTag, data);
  if (res < 0) 
    opserr << "DamperHyscpp::sendSelf() - failed to send data\n";

  return res;
}

int 
DamperHyscpp::recvSelf(int cTag, Channel &theChannel, 
				 FEM_ObjectBroker &theBroker)
{
  int res = 0;
  static Vector data(9);
  res = theChannel.recvVector(this->getDbTag(), cTag, data);
  if (res < 0) 
    opserr << "DamperHyscpp::recvSelf() - failed to recv data\n";
  else {
    this->setTag(data(0));
    k1    = data(1);
    k2     = data(2);
    k3 = data(3);
    ey   = data(4);
    eu   = data(5);  
	stressT =data(6);
	strainT=data(7);
	tangentT =data(8);
    strainT = strainC;
    tangentT= tangentC;
    stressT = stressC;
	dstrainC = dstrainT;
  }

  return res;
}

void 
DamperHyscpp::Print(OPS_Stream &s, int flag)
{
  s << "DamperHyscpp tag: " << this->getTag() << endln;
  s << "  E: " << E << endln;
  s << "  ep: " << ep << endln;
  s << "  stress: " << stressT << " tangent: " << tangentT << endln;
}


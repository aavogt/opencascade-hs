#include <gp_Lin.hxx>
#include "hs_gp_Lin.h"

gp_Lin * hs_new_gp_Lin(gp_Pnt * pnt, gp_Dir * dir){
    return new gp_Lin(*pnt, *dir);
}

void hs_delete_gp_Lin(gp_Lin* lin){
    delete lin;
}

gp_Pnt * hs_gp_Lin_Location(gp_Lin * lin){
    return new gp_Pnt(lin->Location());
}

gp_Dir * hs_gp_Lin_Direction(gp_Lin * lin){
    return new gp_Dir(lin->Direction());
}

void hs_gp_Lin_SetLocation(gp_Lin * lin, gp_Pnt * pnt){
    lin->SetLocation(*pnt);
}

void hs_gp_Lin_SetDirection(gp_Lin * lin, gp_Dir * dir){
    lin->SetDirection(*dir);
}

gp_Ax1* hs_gp_Lin_Position(gp_Lin * lin){
    return new gp_Ax1(lin->Position());
}

double hs_gp_Lin_Angle(gp_Lin * a, gp_Lin * b){
    return a->Angle(*b);
}

bool hs_gp_Lin_Contains(gp_Lin * lin, gp_Pnt * pnt, double linearTolerance){
    return lin->Contains(*pnt, linearTolerance);
}

bool hs_gp_Lin_Distance(gp_Lin * lin, gp_Pnt * pnt){
    return lin->Distance(*pnt, *pnt);
}

bool hs_gp_Lin_DistanceL(gp_Lin * lin, gp_Lin * other){
    return lin->Distance(*other);
}

double hs_gp_Lin_SquareDistance(gp_Lin * lin, gp_Pnt * pnt){
    return lin->SquareDistance(*pnt);
}

double hs_gp_Lin_SquareDistanceL(gp_Lin * lin, gp_Lin * other){
    return lin->SquareDistance(*other);
}

gp_Lin * hs_gp_Lin_Normal(gp_Lin * lin, gp_Pnt * pnt){
    return new gp_Lin(lin->Normal(*pnt));
}

void hs_gp_Lin_Mirror(gp_Lin * lin, gp_Pnt * pnt){
    lin->Mirror(*pnt);
}

gp_Lin * hs_gp_Lin_Mirrored(gp_Lin * lin, gp_Pnt * pnt){
    return new gp_Lin(lin->Mirrored(*pnt));
}

void hs_gp_Lin_Rotate(gp_Lin * lin, gp_Ax1 * ax1, double amount){
    lin->Rotate(*ax1, amount);
}

gp_Lin * hs_gp_Lin_Rotated(gp_Lin * lin, gp_Ax1 * ax1, double amount){
    return new gp_Lin(lin->Rotated(*ax1, amount));
}

void hs_gp_Lin_Scale(gp_Lin * lin, gp_Pnt * pnt, double scale){
    lin->Scale(*pnt, scale);
}

gp_Lin * hs_gp_Lin_Scaled(gp_Lin * lin, gp_Pnt * pnt, double scale){
    return new gp_Lin(lin->Scaled(*pnt, scale));
}

void hs_gp_Lin_Transform(gp_Lin * lin, gp_Trsf * trsf){
    lin->Transform(*trsf);
}

gp_Lin * hs_gp_Lin_Transformed(gp_Lin * lin, gp_Trsf * trsf){
    return new gp_Lin(lin->Transformed(*trsf));
}

void hs_gp_Lin_Translate(gp_Lin * lin, gp_Vec * vec){
    lin->Translate(*vec);
}

gp_Lin * hs_gp_Lin_Translated(gp_Lin * lin, gp_Vec * vec){
    return new gp_Lin(lin->Translated(*vec));
}

void hs_gp_Lin_TranslateP(gp_Lin * lin, gp_Pnt * p1, gp_Pnt * p2){
    lin->Translate(*p1, *p2);
}

gp_Lin * hs_gp_Lin_TranslatedP(gp_Lin * lin, gp_Pnt * p1, gp_Pnt * p2){
    return new gp_Lin(lin->Translated(*p1, *p2));
}

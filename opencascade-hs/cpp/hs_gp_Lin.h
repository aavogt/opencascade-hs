#ifndef HS_GP_LIN_H
#define HS_GP_LIN_H

#include "hs_types.h"

#ifdef __cplusplus
extern "C" {
#endif

gp_Lin * hs_new_gp_Lin(gp_Pnt *pnt, gp_Dir *dir);

void hs_delete_gp_Lin(gp_Lin* lin);

gp_Pnt * hs_gp_Lin_Location(gp_Lin * lin);

gp_Dir * hs_gp_Lin_Direction(gp_Lin * lin);

void hs_gp_Lin_SetLocation(gp_Lin * lin, gp_Pnt * pnt);

void hs_gp_Lin_SetDirection(gp_Lin * lin, gp_Dir * dir);

gp_Ax1* hs_gp_Lin_Position(gp_Lin * lin);

double hs_gp_Lin_Angle(gp_Lin * a, gp_Lin * b);

bool hs_gp_Lin_Contains(gp_Lin * lin, gp_Pnt * pnt, double linearTolerance);

bool hs_gp_Lin_Distance(gp_Lin * lin, gp_Pnt * pnt);

bool hs_gp_Lin_DistanceL(gp_Lin * lin, gp_Lin * other);

double hs_gp_Lin_SquareDistance(gp_Lin * lin, gp_Pnt * pnt);

double hs_gp_Lin_SquareDistanceL(gp_Lin * lin, gp_Lin * other);

gp_Lin * hs_gp_Lin_Normal(gp_Lin * lin, gp_Pnt * pnt);

void hs_gp_Lin_Mirror(gp_Lin * lin, gp_Pnt * pnt);

gp_Lin * hs_gp_Lin_Mirrored(gp_Lin * lin, gp_Pnt * pnt);

void hs_gp_Lin_Rotate(gp_Lin * lin, gp_Ax1 * ax1, double amount);

gp_Lin * hs_gp_Lin_Rotated(gp_Lin * lin, gp_Ax1 * ax1, double amount);

void hs_gp_Lin_Scale(gp_Lin * lin, gp_Pnt * pnt, double scale);

gp_Lin * hs_gp_Lin_Scaled(gp_Lin * lin, gp_Pnt * pnt, double scale);

void hs_gp_Lin_Transform(gp_Lin * lin, gp_Trsf * trsf);

gp_Lin * hs_gp_Lin_Transformed(gp_Lin * lin, gp_Trsf * trsf);

void hs_gp_Lin_Translate(gp_Lin * lin, gp_Vec * vec);

gp_Lin * hs_gp_Lin_Translated(gp_Lin * lin, gp_Vec * vec);

void hs_gp_Lin_TranslateP(gp_Lin * lin, gp_Pnt * p1, gp_Pnt * p2);

gp_Lin * hs_gp_Lin_TranslatedP(gp_Lin * lin, gp_Pnt * p1, gp_Pnt * p2);


#ifdef __cplusplus
}
#endif

#endif // HS_GP_DIR_H

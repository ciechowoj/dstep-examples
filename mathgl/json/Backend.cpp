#include <QMessageBox>
#include <QTextStream>
#include <QFile>
#include <QDebug>
#include "Backend.hpp"
#include <mgl2/mgl.h>
//-----------------------------------------------------------------------------
Backend::Backend(QObject *parent) : QObject(parent) { }
//-----------------------------------------------------------------------------
QString Backend::show(const QString& text) const
{
	qDebug() << __FUNCTION__;
	const char *tmp = tmpnam(0);
	wchar_t *wtext;
	mglGraph gr;
	gr.SetFaceNum(200);
	mglParse pr;
	pr.AllowSetSize(true);
	setlocale(LC_CTYPE, "");
	setlocale(LC_NUMERIC, "C");
	wtext = new wchar_t[text.size()+1];
	text.toWCharArray(wtext);
	wtext[text.size()] = 0;
	pr.Execute(&gr,wtext);
	delete[] wtext;
	gr.WriteJSON(tmp);
	setlocale(LC_NUMERIC, "");

	QFile f(tmp);
	f.open(QIODevice::ReadOnly);
	QTextStream ts(&f);
	ts.setAutoDetectUnicode(true);
	const QString json = ts.readAll();
	f.remove();
	return json;
}
//-----------------------------------------------------------------------------
QString Backend::coor(const QString& xy, const QString& text) const
{
	wchar_t *wtext;
	qDebug() << __FUNCTION__;
	mglGraph gr;
	mglParse pr;
	pr.AllowSetSize(true);
	setlocale(LC_CTYPE, "");
	setlocale(LC_NUMERIC, "C");
	wtext = new wchar_t[text.size()+1];
	text.toWCharArray(wtext);
	wtext[text.size()] = 0;
	pr.Execute(&gr,wtext);
	delete[] wtext;
	gr.Finish();

	int x = (int)xy.section(" ",0,0).toDouble();
	int y = (int)xy.section(" ",1,1).toDouble();
	mglPoint p = gr.CalcXYZ(x,y);
	QString res;
	res.sprintf("x = %g, y = %g, z = %g for point (%d, %d)\n", p.x, p.y, p.z, x,y);
	qDebug() << res+"\nask"+xy;
	return res+"\nask"+xy;
}
//-----------------------------------------------------------------------------
QString Backend::geometry(const QString& mgl) const
{
	qDebug() << __FUNCTION__;
	const char *tmp = tmpnam(0);
	wchar_t *wmgl;
	mglGraph gr;
#if 0
	gr.SetFaceNum(200);
#endif
	mglParse pr;
	pr.AllowSetSize(true);
	setlocale(LC_CTYPE, "");
	setlocale(LC_NUMERIC, "C");
	wmgl = new wchar_t[mgl.size()+1];
	mgl.toWCharArray(wmgl);
	wmgl[mgl.size()] = 0;
	pr.Execute(&gr,wmgl);
	delete[] wmgl;
	gr.WriteJSON(tmp);
	setlocale(LC_NUMERIC, "");

	QFile f(tmp);
	f.open(QIODevice::ReadOnly);
	QTextStream ts(&f);
	ts.setAutoDetectUnicode(true);
	const QString json = ts.readAll();
	f.remove();
	return json;
}
//-----------------------------------------------------------------------------
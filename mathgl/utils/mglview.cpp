/***************************************************************************
 * mglview.cpp is part of Math Graphic Library
 * Copyright (C) 2007-2016 Alexey Balakin <mathgl.abalakin@gmail.ru>       *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program; if not, write to the                         *
 *   Free Software Foundation, Inc.,                                       *
 *   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
 ***************************************************************************/
#include <locale.h>
#include <getopt.h>

#include "mgl2/mgl.h"
#include "mgl2/qt.h"
#include "mgl2/parser.h"
//-----------------------------------------------------------------------------
std::wstring str, opt;
mglParse p(true);
//-----------------------------------------------------------------------------
int show(mglGraph *gr)
{
	p.Execute(gr,str.c_str());
	printf("%s\n",gr->Message());
	return 0;
}
//-----------------------------------------------------------------------------
int main(int argc, char **argv)
{
	char iname[256]="";
	mgl_suppress_warn(true);
	bool gray = false;
	while(1)
	{
		int ch = getopt(argc, argv, "1:2:3:4:5:6:7:8:9:hL:s:g:v:");
		if(ch>='1' && ch<='9')	p.AddParam(ch-'0', optarg);
		else if(ch=='s')
		{
			setlocale(LC_CTYPE, "");
			FILE *fp = fopen(optarg,"r");
			if(fp)
			{
				wchar_t ch;
				while(!feof(fp) && size_t(ch=fgetwc(fp))!=WEOF)	opt.push_back(ch);
				fclose(fp);
			}
		}
		else if(ch=='v')	p.SetVariant(atoi(optarg));
		else if(ch=='g')	gray= atoi(optarg);
		else if(ch=='L')	setlocale(LC_CTYPE, optarg);
		else if(ch=='h' || (ch==-1 && optind>=argc))
		{
			printf("mglview show plot from MGL script or MGLD file.\nCurrent version is 2.%g\n",MGL_VER2);
			printf("Usage:\tmglview [parameter(s)] scriptfile\n");
			printf(
				"\t-1 str       set str as argument $1 for script\n"
				"\t...          ...\n"
				"\t-9 str       set str as argument $9 for script\n"
				"\t-g val       set gray-scale mode (val=0|1)\n"
				"\t-v val       set variant of arguments\n"
				"\t-s opt       set MGL script for setting up the plot\n"
				"\t-L loc       set locale to loc\n"
				"\t-            get script from standard input\n"
				"\t-h           print this message\n" );
			return 0;
		}
		else if(ch==-1 && optind<argc)
		{	strncpy(iname, argv[optind][0]=='-'?"":argv[optind],256);	break;	}
	}

	bool mgld=(*iname && iname[strlen(iname)-1]=='d');
	if(!mgld)
	{
		str = opt + L"\n";
		setlocale(LC_CTYPE, "");
		FILE *fp = *iname?fopen(iname,"r"):stdin;
		if(fp)
		{
			wchar_t ch;
			while(!feof(fp) && size_t(ch=fgetwc(fp))!=WEOF)	str.push_back(ch);
			fclose(fp);
		}
		else	{	printf("No file for MGL script\n");	return 0;	}
	}

	mgl_ask_func = mgl_ask_gets;
	mgl_ask_func = mgl_ask_qt;
	mglQT gr(mgld?NULL:show, *iname?iname:"mglview");
	if(gray)	gr.Gray(gray);

	if(mgld)
	{
		gr.Setup(false);
		gr.NewFrame();	setlocale(LC_NUMERIC, "C");
		if(!opt.empty())
		{
			p.Execute(&gr,opt.c_str());
			printf("Setup script: %s\n",gr.Message());
			gr.ImportMGLD(iname,true);
		}
		else	gr.ImportMGLD(iname);
		setlocale(LC_NUMERIC, "");	gr.EndFrame();
		gr.Update();
	}
	if(!mglGlobalMess.empty())	printf("%s",mglGlobalMess.c_str());
	return gr.Run();
}
//-----------------------------------------------------------------------------

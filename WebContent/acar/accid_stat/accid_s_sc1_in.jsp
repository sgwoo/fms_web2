<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.accid.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

//-->
</script>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"0":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"3":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"4":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"desc":request.getParameter("asc");
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");	
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	int tot_su = request.getParameter("tot_su")==null?0:AddUtil.parseInt(request.getParameter("tot_su"));
	int size1 = 0;
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();	
	
	Hashtable accid = as_db.getAccidStat01(br_id, gubun1, gubun2, gubun3, brch_id, st_dt, end_dt, s_kd, t_wd, sort, asc, car_comp_id);
	float su[] = new float[8];
	float max_su = 0;
	for(int i=1; i<9; i++){
		su[i-1] = Float.parseFloat(String.valueOf(accid.get("SU"+i)));
		//최대값 찾기
		if(max_su < su[i-1])	max_su = su[i-1];
	}
%>
<form name='form1' action='../accid_mng/accid_u_frame.jsp' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='m_id' value=''>
<input type='hidden' name='l_cd' value=''>
<input type='hidden' name='c_id' value=''>
<input type='hidden' name='accid_id' value=''>
<input type='hidden' name='accid_st' value=''>
<input type='hidden' name='cmd' value=''>
<input type='hidden' name='car_comp_id' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td colspan=5 style='height:1; background-color:e7e7e8;'></td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td>&nbsp; 
        <font color=red>♣ <%=c_db.getNameById(car_comp_id, "CAR_COM")%> 
        연식별</font></td>
    </tr>
    <tr> 
      <td> 
        <table width="700" border="0" cellspacing="0" cellpadding="0" align="center">
            <tr> 
                <td width="30" align="right">&nbsp;</td>
                <td width="90">&nbsp;</td>
                <td width="30">&nbsp;</td>
                <td width="90">&nbsp;</td>
                <td width="30">&nbsp;</td>
                <td width="90">&nbsp;</td>
                <td width="30">&nbsp;</td>
                <td width="90">&nbsp;</td>
                <td width="30">&nbsp;</td>
                <td width="90">&nbsp;</td>
                <td width="30">&nbsp;</td>
                <td width="90">&nbsp;</td>
                <td width="30">&nbsp;</td>
                <td width="90">&nbsp;</td>
                <td width="30">&nbsp;</td>
                <td width="90">&nbsp;</td>
                <td width="30">&nbsp;</td> 
                <td width="70">&nbsp;</td>
            </tr>
            <tr> 
            <td style="border-top: #000000 0px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 1px solid" height="120" valign="top" align="center"> 
              <font size="1">사<br>
              고<br>
              건<br>
              수</font> <font size="1">
              <%//=Math.round(max_su)%>
              </font> </td>
            <td>&nbsp;</td>
            <td> <table width="30" border="0" cellspacing="0" cellpadding="0" height="120">
                <tr> 
                  <td height="<%=100-Math.round(su[0]/max_su*100)%>" valign="bottom" align="center"><%=accid.get("SU1")%>건</td>
                </tr>
                <tr> 
                  <td height="<%=Math.round(su[0]/max_su*100)%>" valign="bottom"><img src=../../images/menu_back.gif width=30 height=<%=Math.round(su[0]/max_su*100)%>></td>
                </tr>
              </table></td>
            <td>&nbsp;</td>
            <td> <table width="30" border="0" cellspacing="0" cellpadding="0" height="120">
                <tr> 
                  <td height="<%=100-Math.round(su[1]/max_su*100)%>" valign="bottom" align="center"><%=accid.get("SU2")%>건</td>
                </tr>
                <tr> 
                  <td height="<%=Math.round(su[1]/max_su*100)%>" valign="bottom"><img src=../../images/menu_back.gif width=30 height=<%=Math.round(su[1]/max_su*100)%>></td>
                </tr>
              </table></td>
            <td>&nbsp;</td>
            <td> <table width="30" border="0" cellspacing="0" cellpadding="0" height="120">
                <tr> 
                  <td height="<%=100-Math.round(su[2]/max_su*100)%>" valign="bottom" align="center"><%=accid.get("SU3")%>건</td>
                </tr>
                <tr> 
                  <td height="<%=Math.round(su[2]/max_su*100)%>" valign="bottom"><img src=../../images/menu_back.gif width=30 height=<%=Math.round(su[2]/max_su*100)%>></td>
                </tr>
              </table></td>
            <td>&nbsp;</td>
            <td> <table width="30" border="0" cellspacing="0" cellpadding="0" height="120">
                <tr> 
                  <td height="<%=100-Math.round(su[3]/max_su*100)%>" valign="bottom" align="center"><%=accid.get("SU4")%>건</td>
                </tr>
                <tr> 
                  <td height="<%=Math.round(su[3]/max_su*100)%>" valign="bottom"><img src=../../images/menu_back.gif width=30 height=<%=Math.round(su[3]/max_su*100)%>></td>
                </tr>
              </table></td>
            <td>&nbsp;</td>
            <td> <table width="30" border="0" cellspacing="0" cellpadding="0" height="120">
                <tr> 
                  <td height="<%=100-Math.round(su[4]/max_su*100)%>" valign="bottom" align="center"><%=accid.get("SU5")%>건</td>
                </tr>
                <tr> 
                  <td height="<%=Math.round(su[4]/max_su*100)%>" valign="bottom"><img src=../../images/menu_back.gif width=30 height=<%=Math.round(su[4]/max_su*100)%>></td>
                </tr>
              </table></td>
            <td>&nbsp;</td>
            <td> <table width="30" border="0" cellspacing="0" cellpadding="0" height="120">
                <tr> 
                  <td height="<%=100-Math.round(su[5]/max_su*100)%>" valign="bottom" align="center"><%=accid.get("SU6")%>건</td>
                </tr>
                <tr> 
                  <td height="<%=Math.round(su[5]/max_su*100)%>" valign="bottom"><img src=../../images/menu_back.gif width=30 height=<%=Math.round(su[5]/max_su*100)%>></td>
                </tr>
              </table></td>
            <td>&nbsp;</td>
            <td> <table width="30" border="0" cellspacing="0" cellpadding="0" height="120">
                <tr> 
                  <td height="<%=100-Math.round(su[6]/max_su*100)%>" valign="bottom" align="center"><%=accid.get("SU7")%>건</td>
                </tr>
                <tr> 
                  <td height="<%=Math.round(su[6]/max_su*100)%>" valign="bottom"><img src=../../images/menu_back.gif width=30 height=<%=Math.round(su[6]/max_su*100)%>></td>
                </tr>
              </table></td>
            <td>&nbsp;</td>
            <td> <table width="30" border="0" cellspacing="0" cellpadding="0" height="120">
                <tr> 
                  <td height="<%=100-Math.round(su[7]/max_su*100)%>" valign="bottom" align="center"><%=accid.get("SU8")%>건</td>
                </tr>
                <tr> 
                  <td height="<%=Math.round(su[7]/max_su*100)%>" valign="bottom"><img src=../../images/menu_back.gif width=30 height=<%=Math.round(su[7]/max_su*100)%>></td>
                </tr>
              </table></td>
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
            <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid">&nbsp;</td>
            <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">2000</td>
            <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">&nbsp;</td>
            <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">2001</td>
            <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">&nbsp;</td>
            <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">2002</td>
            <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">&nbsp;</td>
            <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">2003</td>
            <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">&nbsp;</td>
            <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">2004</td>
            <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">&nbsp;</td>
            <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">2005</td>
            <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">&nbsp;</td>
            <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">2006</td>
            <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">&nbsp;</td>
            <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">2007</td>
            <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="right"><font size=1>연식</font></td>
          </tr>
        </table>
      </td>
    </tr>
	<!--
    <tr> 
      <td>&nbsp;</td>
    </tr>-->
    <tr> 
      <td>&nbsp;<font color=red>♣ <%=c_db.getNameById(car_comp_id, "CAR_COM")%> 
        차종별</font></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td class='title' width='10%'>차종</td>
                    <%	Vector accids2 = as_db.getAccidStat02(br_id, gubun1, gubun2, gubun3, brch_id, st_dt, end_dt, s_kd, t_wd, sort, asc, car_comp_id);
        				int accid_size2 = accids2.size();
        				int a=accid_size2;
        				int listsize=6;
        				if(a < listsize) listsize=a;
        				for (int i = 0 ; i < listsize ; i++){
        					Hashtable accid2 = (Hashtable)accids2.elementAt(i);%>
                    <td class='title'><%=accid2.get("CAR_NM")%></td>
                    <%	}%>
                    <td class='title' width="7%">기타차종</td>
                    <td class='title' width="7%">계</td>
                </tr>
                <tr> 
                    <td class='title'>건수</td>
                    <%	int cnt1 = 0;
        				for (int i = 0 ; i < listsize ; i++){
        					Hashtable accid2 = (Hashtable)accids2.elementAt(i);%>
                    <td align="center"><%=accid2.get("TOT_SU")%>건</td>
                    <%		cnt1  = cnt1  + Integer.parseInt(String.valueOf(accid2.get("TOT_SU")));
        				}%>
                    <td align="center">
                      <%=tot_su-cnt1%>
                      건</td>
                    <td align="center">
                      <%=tot_su%>
                      건</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td>&nbsp;</td>
    </tr>
</table>
</form>
</body>
</html>

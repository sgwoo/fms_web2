<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cus_pre.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String year = request.getParameter("year")==null?"":request.getParameter("year");
	String dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	
	if(year.equals(""))	year = AddUtil.getDate(1);
	
	int tot_vst=0, tot_serv1=0, tot_serv2=0, tot_serv3=0, tot_maint=0, tot_maint2=0, tot_ires=0, tot_deli=0, tot_ret=0;
	
	CusPre_Database cp_db = CusPre_Database.getInstance();
	int[] vst 		= cp_db.getTg_year_vst(year);
	int[] serv1 	= cp_db.getTg_year_serv1(year);	//순회
	int[] serv2 	= cp_db.getTg_year_serv2(year); //일반
	int[] serv3 	= cp_db.getTg_year_serv3(year); //보증
	int[] maint 	= cp_db.getTg_year_maint(year);
	int[] maint2 	= cp_db.getTg_year_maint2(year);
	int[] ires 		= cp_db.getTg_year_ires(year);
	int[] deli 		= cp_db.getTg_year_deli(year); //배차
	int[] ret 		= cp_db.getTg_year_ret(year);   //반차	

%>
<html>
<head>
<title>:: FMS ::</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
function search(){
	document.form1.submit();	
}				
-->
</script>
</head>

<body>
<form name="form1" method="post" action="cus_pre_tg_year.jsp" target="c_body">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td><div align="left"> 
            <select name='year'>
    			<option value="2000" <% if(year.equals("2000")) out.print("selected"); %>> 2000 </option>
    			<option value="2001" <% if(year.equals("2001")) out.print("selected"); %>> 2001 </option>
    			<option value="2002" <% if(year.equals("2002")) out.print("selected"); %>> 2002 </option>
    			<option value="2003" <% if(year.equals("2003")) out.print("selected"); %>> 2003 </option>
    			<option value="2004" <% if(year.equals("2004")) out.print("selected"); %>> 2004 </option>
    			<option value="2005" <% if(year.equals("2005")) out.print("selected"); %>> 2005 </option>
    			<option value="2006" <% if(year.equals("2006")) out.print("selected"); %>> 2006 </option>
    			<option value="2007" <% if(year.equals("2007")) out.print("selected"); %>> 2007 </option>
    			<option value="2008" <% if(year.equals("2008")) out.print("selected"); %>> 2008 </option>
            </select>
            년도 <a href='javascript:search()' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_search.gif"  align="absmiddle" border="0"></a> 
          </div></td>
        <td align=right><div align="right">(단위: 건,대)</div></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                  <td class='title' align="center" width=9% rowspan="2">월</td>
                  <td class='title' align="center" rowspan="2" width=8%>거래처방문</td>
                  <td class='title' align="center" colspan="4">자동차정비</td>
                  <td class='title' align="center" rowspan="2" width=8%>정기검사</td>
                  <td width=8% class='title' align="center" rowspan="2">정밀검사</td>
                  <td width=9% class='title' align="center" rowspan="2">고객정비요청</td>
                  <td class='title' align="center" colspan="3">예약시스템</td>
                </tr>
                <tr> 
                  <td width=8% class='title' align="center">순회점검</td>
                  <td width=8% class='title' align="center">일반정비</td>
                  <td width=8% class='title' align="center">보증정비</td>
                  <td width=9% class='title' align="center">계</td>
                  <td width=8% class='title' align="center">배차</td>
                  <td width=8% class='title' align="center">반차</td>
                  <td width=8% class='title' align="center">계</td>
                </tr>
                <% for(int i=0; i<vst.length; i++){
        			tot_vst += vst[i]; tot_serv1 += serv1[i]; tot_serv2 += serv2[i]; tot_serv3 += serv3[i];
        			tot_maint += maint[i]; tot_maint2 += maint2[i]; tot_ires += ires[i]; tot_deli += deli[i]; tot_ret += ret[i]; %>
                <tr> 
                  <td align="center"><%= i+1 %>월</td>
                  <td align="right"><%= vst[i] %>&nbsp;&nbsp;&nbsp;</td>
                  <td align="right"><%= serv1[i] %>&nbsp;&nbsp;&nbsp;</td>
                  <td align="right"><%= serv2[i] %>&nbsp;&nbsp;&nbsp;</td>
                  <td align="right"><%= serv3[i] %>&nbsp;&nbsp;&nbsp;</td>
                  <td align="right"><%= serv1[i]+serv2[i]+serv3[i] %>&nbsp;&nbsp;&nbsp;</td>
                  <td align="right"><%= maint[i] %>&nbsp;&nbsp;&nbsp;</td>
                  <td align="right"><%= maint2[i] %>&nbsp;&nbsp;&nbsp;</td>
                  <td align="right"><%= ires[i] %>&nbsp;&nbsp;&nbsp;</td>
                  <td align="right"><%= deli[i] %>&nbsp;&nbsp;&nbsp;</td>
                  <td align="right"><%= ret[i] %>&nbsp;&nbsp;&nbsp;</td>
                  <td align="right"><%= deli[i]+ret[i] %>&nbsp;&nbsp;&nbsp;</td>
                </tr>
                <% } %>
                <tr> 
                  <td class='title' align="center">계</td>
                  <td class="title" style="text-align:right"><%= tot_vst %>&nbsp;&nbsp;&nbsp;</td>
                  <td class='title' style="text-align:right"><%= tot_serv1 %>&nbsp;&nbsp;&nbsp;</td>
                  <td class='title' style="text-align:right"><%= tot_serv2 %>&nbsp;&nbsp;&nbsp;</td>
                  <td class='title' style="text-align:right"><%= tot_serv3 %>&nbsp;&nbsp;&nbsp;</td>
                  <td class='title' style="text-align:right"><%= tot_serv1 + tot_serv2 + tot_serv3 %>&nbsp;&nbsp;&nbsp;</td>
                  <td class='title' style="text-align:right"><%= tot_maint %>&nbsp;&nbsp;&nbsp;</td>
                  <td class='title' style="text-align:right"><%= tot_maint2 %>&nbsp;&nbsp;&nbsp;</td>
                  <td class='title' style="text-align:right"><%= tot_ires %>&nbsp;&nbsp;&nbsp;</td>
                  <td class='title' style="text-align:right"><%= tot_deli %>&nbsp;&nbsp;&nbsp;</td>
                  <td class='title' style="text-align:right"><%= tot_ret %>&nbsp;&nbsp;&nbsp;</td>
                  <td class='title' style="text-align:right"><%= tot_deli + tot_ret %>&nbsp;&nbsp;&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td colspan="2">&nbsp;</td>
    </tr>
</table>
</form>
</body>
</html>

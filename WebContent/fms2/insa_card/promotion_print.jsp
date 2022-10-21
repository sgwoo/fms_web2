<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*,acar.common.*, acar.insa_card.*" %>
<jsp:useBean id="ic_db" scope="page" class="acar.insa_card.InsaCardDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	//사용자별 정보 조회 및 수정 페이지
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	LoginBean login = LoginBean.getInstance();
	
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String basic_dt 	= request.getParameter("basic_dt")==null?"":request.getParameter("basic_dt");

	String acar_id = login.getCookieValue(request, "acar_id");
			
	if(basic_dt.equals("")){
		 basic_dt = AddUtil.getDate(1)+"0101";
	}
	

	//사용자 정보 조회
	Vector vt = ic_db.Insa_promotion(basic_dt);
	int vt_size = vt.size();
	
	
%>
<HTML>
<HEAD>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<TITLE>진급자현황 리스트</TITLE>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript' src='/include/common.js'></script>

<script language='javascript'>
<!--
function search2(){
		var fm = document.form1;		
		fm.action = "promotion_print.jsp";
		fm.target='_self';
		fm.submit();
	}
		function excel_list(){
		var fm = document.form1;
		fm.target = "_blank";
		fm.action = "promotion_excel_list.jsp?ck_acar_id=<%=ck_acar_id%>";
		fm.submit();
	}
//-->
</script>
</HEAD>

<BODY>
<form action="" name="form1" method="POST" >
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">  
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr> 
        <td colspan=>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>인사관리 > 조직관리 > <span class=style5> 진급자현황 인쇄
					</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>            
    </tr>
    <tr> 
        <td class=h></td>            
    </tr>
    <tr> 
		<td align="">기준일자 : <SELECT NAME="basic_dt">
							<OPTION VALUE="20090101" <%if(basic_dt.equals("20090101")){%>selected<%}%>>2009-01-01</OPTION>
							<OPTION VALUE="20100101" <%if(basic_dt.equals("20100101")){%>selected<%}%>>2010-01-01</OPTION>
							<OPTION VALUE="20110101" <%if(basic_dt.equals("20110101")){%>selected<%}%>>2011-01-01</OPTION>
							<OPTION VALUE="20120101" <%if(basic_dt.equals("20120101")){%>selected<%}%>>2012-01-01</OPTION>
							<OPTION VALUE="20130101" <%if(basic_dt.equals("20130101")){%>selected<%}%>>2013-01-01</OPTION>
							<OPTION VALUE="20140101" <%if(basic_dt.equals("20140101")){%>selected<%}%>>2014-01-01</OPTION>
							<OPTION VALUE="20150101" <%if(basic_dt.equals("20150101")){%>selected<%}%>>2015-01-01</OPTION>
							<OPTION VALUE="20160101" <%if(basic_dt.equals("20160101")){%>selected<%}%>>2016-01-01</OPTION>
							<OPTION VALUE="20170101" <%if(basic_dt.equals("20170101")){%>selected<%}%>>2017-01-01</OPTION>
							<OPTION VALUE="20180101" <%if(basic_dt.equals("20180101")){%>selected<%}%>>2018-01-01</OPTION>
							<OPTION VALUE="20190101" <%if(basic_dt.equals("20190101")){%>selected<%}%>>2019-01-01</OPTION>
							<OPTION VALUE="20200101" <%if(basic_dt.equals("20200101")){%>selected<%}%>>2020-01-01</OPTION>
						</SELECT> &nbsp;<a href="javascript:search2()"><img src=/acar/images/center/button_see.gif align=absmiddle border=0></a>
						&nbsp;<a href="javascript:excel_list()"><img src=/acar/images/center/button_excel.gif align=absmiddle border=0></a>
						</td>
    </tr>
	
	<tr>
		<td class=line>
			<table border=0 cellspacing=1 width=100%>
				<tr>
					<td rowspan="3" colspan="1" class="title">연번</td>
					<td rowspan="3" colspan="1" class="title">부서명</td>
					<td rowspan="3" colspan="1" class="title">성명</td>
					<td rowspan="3" colspan="1" class="title">나이</td>
					<td rowspan="3" colspan="1" class="title">입사일자</td>
					<td rowspan="1" colspan="2" class="title">재직기간</td>
					<td rowspan="1" colspan="4" class="title">현재직급</td>
					<td rowspan="1" colspan="2" class="title">진급(심사)대상직급</td>
				</tr>
				<tr>
					<td rowspan="2" colspan="1" class="title">년</td>
					<td rowspan="2" colspan="1" class="title">월</td>
					<td rowspan="2" colspan="1" class="title">직급</td>
					<td rowspan="2" colspan="1" class="title">발령일자</td>
					<td rowspan="1" colspan="2" class="title">발령후 경과기간</td>
					<td rowspan="2" colspan="1" class="title">심사직급</td>
					<td rowspan="2" colspan="1" class="title">심사결과</td>
					<!--<td rowspan="2" colspan="1" class="title">적요</td>-->
					</tr>
				<tr>
					<td class="title">년</td>
					<td class="title">월</td>
				</tr>
<%// if(vt_size > 0)	{
	int count =0;
	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
			if(String.valueOf(ht.get("USER_NM")).equals("김기웅")) continue;
			count++;
%> 						
				<tr>
					<td align="center"><%=count%></td>
					<td align="center"><%=ht.get("DEPT_NM")%></td>
					<td align="center"><%=ht.get("USER_NM")%></td>
					<td align="center"><%=ht.get("AGE")%>세 <%=ht.get("AGE_MONTH")%>월</td>
					<td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ENTER_DT")))%></td>
					<td align="center"><%=ht.get("YEAR")%></td>
					<td align="center"><%=ht.get("MONTH")%></td>
					<td align="center"><%=ht.get("USER_POS")%></td>
					<td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("JG_DT")))%></td>
					<td align="center"><%=ht.get("J_YEAR")%></td>
					<td align="center"><%=ht.get("J_MONTH")%></td>
					<td align="center"><%=ht.get("NEXT_POS")%></td>
					<td align="center"></td>
					<!--<td align="center"><%//=ht.get("NOTE")%></td>-->
				</tr>
<%}%>
			</table>
		</td>
	</tr>
    <tr> 
        <td class=h></td>
    </tr>
	<tr>
		<td>※ 진급축하금지급 : 일금 20만원 <br>※ 진급조건 최소연령기준은 만 30세 이상</td>
	</tr>
</table>
</form>

<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</BODY>

</HTML>


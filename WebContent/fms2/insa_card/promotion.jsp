<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*,acar.common.*, acar.insa_card.*" %>
<jsp:useBean id="ic_db" scope="page" class="acar.insa_card.InsaCardDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	//사용자별 정보 조회 및 수정 페이지
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	LoginBean login = LoginBean.getInstance();
	
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String basic_dt 	= request.getParameter("basic_dt")==null?"":request.getParameter("basic_dt");

	String acar_id = login.getCookieValue(request, "acar_id");
	int st_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("s_year"));	
	int st_mon = request.getParameter("s_mon")==null?AddUtil.getDate2(2):Integer.parseInt(request.getParameter("s_mon"));	
	int year =AddUtil.getDate2(1);
	
	if(basic_dt.equals("")){
		 basic_dt = (AddUtil.parseInt(AddUtil.getDate(1))+1)+"0101";
	}
	

	//사용자 정보 조회
	Vector vt = ic_db.Insa_promotion(basic_dt);
	int vt_size = vt.size();
	
	
%>
<HTML>
<HEAD>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<TITLE>사원카드</TITLE>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript' src='/include/common.js'></script>

<script language='javascript'>
<!--
function search2(){
		var fm = document.form1;		
		fm.action = "promotion.jsp";
		fm.target='_self';
		fm.submit();
	}
	
function printer()
{
	var SUBWIN="promotion_print.jsp?basic_dt=<%=basic_dt%>";	
	window.open(SUBWIN, "printer", "left=100, top=100, width=1000, height=750, scrollbars=yes");
}

function printer_excel()
{
	var SUBWIN="promotion_excel_list.jsp?basic_dt=<%=basic_dt%>";	
	window.open(SUBWIN, "excel", "left=100, top=100, width=1000, height=750, scrollbars=yes");
}


//확정처리
function jg_dt(user_id, next_pos){
	var fm = document.form1;
	fm.user_id.value = user_id;
	fm.pos.value = next_pos;
	fm.jg_dt.value = fm.basic_dt.value ;
	fm.cmd.value = 'jg';
	
	if(confirm('진급처리 하시겠습니까?')){	
		fm.action="insa_card_null.jsp";
		fm.target='i_no';
		fm.submit();
	}
}

//-->
</script>
</HEAD>

<BODY>
<form action="" name="form1" method="POST" >
<input type="hidden" name="auth_rw" value="<%=auth_rw%>"> 
<input type="hidden" name="user_id"  >  
<input type="hidden" name="pos" > 
<input type="hidden" name="jg_dt" > 
<input type="hidden" name="cmd" > 
<input type="hidden" name="from_page" value="promotion.jsp" > 
<input type="hidden" name="br_dt"  value="<%=AddUtil.getDate(4)%>"> 

<div class="navigation">
	<span class=style1>인사관리 >조직관리 ></span><span class=style5></span>
</div>
<div class="search-area">
	<label><i class="fa fa-check-circle"></i> 기준일자</label>
	<SELECT NAME="basic_dt" class="select" style="width:150px;">
		<OPTION VALUE="20120101" <%if(basic_dt.equals("20120101")){%>selected<%}%>>2012-01-01</OPTION>
		<OPTION VALUE="20130101" <%if(basic_dt.equals("20130101")){%>selected<%}%>>2013-01-01</OPTION>
		<OPTION VALUE="20140101" <%if(basic_dt.equals("20140101")){%>selected<%}%>>2014-01-01</OPTION>
		<OPTION VALUE="20150101" <%if(basic_dt.equals("20150101")){%>selected<%}%>>2015-01-01</OPTION>
		<OPTION VALUE="20160101" <%if(basic_dt.equals("20160101")){%>selected<%}%>>2016-01-01</OPTION>
		<OPTION VALUE="20170101" <%if(basic_dt.equals("20170101")){%>selected<%}%>>2017-01-01</OPTION>
		<OPTION VALUE="20180101" <%if(basic_dt.equals("20180101")){%>selected<%}%>>2018-01-01</OPTION>
		<OPTION VALUE="20190101" <%if(basic_dt.equals("20190101")){%>selected<%}%>>2019-01-01</OPTION>
		<OPTION VALUE="20200101" <%if(basic_dt.equals("20200101")){%>selected<%}%>>2020-01-01</OPTION>
		<OPTION VALUE="20210101" <%if(basic_dt.equals("20210101")){%>selected<%}%>>2021-01-01</OPTION>
		<OPTION VALUE="20220101" <%if(basic_dt.equals("20220101")){%>selected<%}%>>2022-01-01</OPTION>
		<OPTION VALUE="20230101" <%if(basic_dt.equals("20230101")){%>selected<%}%>>2023-01-01</OPTION>
		<OPTION VALUE="20250101" <%if(basic_dt.equals("20240101")){%>selected<%}%>>2024-01-01</OPTION>
		<OPTION VALUE="20260101" <%if(basic_dt.equals("20250101")){%>selected<%}%>>2025-01-01</OPTION>
	</SELECT>
<input type="button" class="button" value="검색" onclick="search2()"/> 	
<input type="button" class="button" value="인쇄" onclick="printer()" style="float:right"/> 	
<input type="button" class="button" value="엑셀" onclick="printer_excel()" style="float:right"/> 	

</div> 

<table width="100%" border="0" cellpadding="0" cellspacing="0">

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
				</tr>
				<tr>
					<td rowspan="2" colspan="1" class="title">년</td>
					<td rowspan="2" colspan="1" class="title">월</td>
					<td rowspan="2" colspan="1" class="title">직급</td>
					<td rowspan="2" colspan="1" class="title">발령일자</td>
					<td rowspan="1" colspan="2" class="title">발령후 경과기간</td>
				</tr>
				<tr>
					<td class="title">년</td>
					<td class="title">월</td>
				</tr>
<%// if(vt_size > 0)	{
	int count =0;
	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
		
			count++;
%> 						
				<tr>									
					<td align="center"><%=count%></td>
					<td align="center"><%=ht.get("DEPT_NM")%></td>
					<td align="center"><%=ht.get("USER_NM")%>
				<!--  진급자 확정처리  -->	
					<%if(acar_id.equals("000063") && !String.valueOf(ht.get("NEXT_POS")).equals("") ){%>
					<a href="javascript:jg_dt('<%=ht.get("USER_ID")%>','<%=ht.get("NEXT_POS")%>')"><img src=/acar/images/center/button_in_dec.gif border=0 align=absmiddle></a>
					<%}	%>					
					</td>
					
					<td align="center"><%=ht.get("AGE")%>세 <%=ht.get("AGE_MONTH")%>월</td>
					<td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ENTER_DT")))%></td>
					<td align="center"><%=ht.get("YEAR")%></td>
					<td align="center"><%=ht.get("MONTH")%></td>
					<td align="center"><%=ht.get("USER_POS")%></td>
					<td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("JG_DT")))%></td>
					<td align="center"><%=ht.get("J_YEAR")%></td>
					<td align="center"><%=ht.get("J_MONTH")%></td>
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


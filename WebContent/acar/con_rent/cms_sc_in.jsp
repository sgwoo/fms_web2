<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	
	
	Vector vt = a_db.getCmsRentContList(s_kd, t_wd, st_dt, end_dt, gubun1, gubun2, gubun3, gubun4, gubun5);
	int vt_size = vt.size();
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	/* Title 고정 */
	function setupEvents()
	{
			window.onscroll = moveTitle ;
			window.onresize = moveTitle ; 
	}
	
	function moveTitle()
	{
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
	}
	
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body onLoad="javascript:init()">
<table border="0" cellspacing="0" cellpadding="0" width='1340'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width='370' id='td_title' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
			<tr>
			    <td width='40' class='title'>연번</td>
			    <td width='40' class='title'>구분</td>
		            <td width='100' class='title'>계약번호</td>
        		    <td width='70' class='title'>계약일</td>
		            <td width="120" class='title'>고객</td>
				</tr>
			</table>
		</td>
		<td class='line' width='970'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td width='80' class='title'>차량번호</td>
					<td width='80' class='title'>대여개시일</td>
					<td width='60'  class='title'>결제원</td>
					<td width='80' class='title'>은행명</td>
					<td width='150' class='title'>계좌번호</td>
					<td width='150' class='title'>예금주</td>									
					<td width='60' class='title'>출금일</td>					
					<td width='60' class='title'>스케줄</td>
					<td width='60' class='title'>구분</td>
					<td width='60' class='title'>신청자</td>
					<td width='80' class='title'>신청일자</td>
					<td width='60' class='title'>계약</td>
				</tr>
			</table>
		</td>
	</tr>
<%
	if(vt_size > 0)
	{
%>
	<tr>
		<td class='line' width='370' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(i);

%>
				<tr>
					<td  width='40' align='center'><%=i+1%></td>
					<td  width='40' align='center'><%=ht.get("USE_ST")%></td>
					<td  width='100' align='center'><a href="javascript:parent.cms_mng('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("CLIENT_ID")%>', '<%=ht.get("RENT_S_CD")%>')" onMouseOver="window.status=''; return true"><%=ht.get("RENT_L_CD")%></a></td>
					<td  width='70' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%></td>
					<td  width='120'>&nbsp;<span title='<%=ht.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 8)%></span></td>
					
				</tr>
<%
		}
%>
			</table>
		</td>
		<td class='line' width='970'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
<%
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(i);

%>			
				<tr>
					<td  width='80' align='center'><%=ht.get("CAR_NO")%></td>
					<td  width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%></td>					
					<td  width='60' align='center'><%=ht.get("CBIT")%></td>					
					<td  width='80' align='center'><%=ht.get("CMS_BANK")%></td>					
					<td  width='150' align='center'><%=ht.get("CMS_ACC_NO")%></td>
					<td  width='150' align='center'><%=Util.subData(String.valueOf(ht.get("CMS_DEP_NM")), 8)%></td>										
					<td  width='60' align='center'><%=ht.get("CMS_DAY")%>일</td>										
					<td  width='60' align='center'><%=ht.get("SCD_YN")%></td>
					<td  width='60' align='center'><%=ht.get("REG_ST")%></td>					
					<td  width='60' align='center'><%=ht.get("APP_NM")%></td>
					<td  width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("APP_DT")))%></td>					
					<td  width='60' align='center'>
					<%if(String.valueOf(ht.get("RENT_ST")).equals("12")){%>
					월렌트
					<%}else{%>
					단기대여
					<%}%>
					</td>					
				</tr>
<%
		}
%>
			</table>
		</td>
<%	}                  
	else               
	{
%>                     
	<tr>
		<td class='line' width='370' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td align='center'>
					<%if(t_wd.equals("")){%>검색어를 입력하십시오.
					<%}else{%>등록된 데이타가 없습니다<%}%></td>
				</tr>
			</table>
		</td>
		<td class='line' width='970'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td>&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
<%                     
	}                  
%>
</table>
<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=vt_size%>';
//-->
</script>
</body>
</html>

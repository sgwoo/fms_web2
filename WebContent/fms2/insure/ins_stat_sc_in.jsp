<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.insur.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	
	InsDatabase ai_db = InsDatabase.getInstance();
	
	Vector vt = ai_db.getInsureStatList(s_kd, t_wd, gubun1);
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
<table border="0" cellspacing="0" cellpadding="0" width='2280'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width='530' id='td_title' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='530'>
			  <tr>
				<td width='40' rowspan="2" class='title'>연번</td>
				<td colspan="5" class='title'>차량사항</td>
			  </tr>    
			  <tr>
				<td style="font-size:8pt" width='100' class='title'>차량번호</td>
		        <td style="font-size:8pt" width='80' class='title'>차종소분류</td>
		        <td style="font-size:8pt" width='80' class='title'>현차종코드</td>
		        <td style="font-size:8pt" width='80' class='title'>구차종코드</td>
		        <td style="font-size:8pt" width='150' class='title'>차명</td>
		      </tr>
			</table>
		</td>
		<td class='line' width='1750'>
			<table border="0" cellspacing="1" cellpadding="0" width='1750'>
				<tr>
				  <td colspan="2" class='title'>&nbsp;</td>
				  <td style="font-size:8pt" width='150' rowspan="2" class='title'>피보험자</td>
				  <td style="font-size:8pt" colspan="7" class='title'>보험가입사항</td>
				  <td style="font-size:8pt" colspan="2" class='title'>보험기간</td>
			      <td style="font-size:8pt" colspan="9" class='title'>보험료</td>
		      </tr>
				<tr>
				  <td style="font-size:8pt" width='80' class='title'>최초등록일</td>
				  <td style="font-size:8pt" width='80' class='title'>에어백</td>
				  <td style="font-size:8pt" width='80' class='title'>보험종류</td>
				  <td style="font-size:8pt" width='80' class='title'>가입연령</td>
				  <td style="font-size:8pt" width='80' class='title'>대물</td>
				  <td style="font-size:8pt" width='80' class='title'>자손-사망</td>
				  <td style="font-size:8pt" width='80' class='title'>자손-부상</td>				  
				  <td style="font-size:8pt" width='80' class='title'>자차-차가</td>
			      <td style="font-size:8pt" width='80' class='title'>자차-자기</td>
			      <td style="font-size:8pt" width='80' class='title'>시작일</td>
			      <td style="font-size:8pt" width='80' class='title'>만료일</td>
			      <td style="font-size:8pt" width='80' class='title'>대인배상1</td>
			      <td style="font-size:8pt" width='80' class='title'>대인배상2</td>
			      <td style="font-size:8pt" width='80' class='title'>대물배상</td>
			      <td style="font-size:8pt" width='80' class='title'>자기신체</td>
			      <td style="font-size:8pt" width='80' class='title'>무보험차</td>
			      <td style="font-size:8pt" width='80' class='title'>분담금할증</td>
			      <td style="font-size:7pt" width='80' class='title'>자기차량손해</td>
			      <td style="font-size:8pt" width='80' class='title'>특약</td>
			      <td style="font-size:8pt" width='80' class='title'>총보험료</td>
			  </tr>
			</table>
		</td>
	</tr>
<%
	if(vt_size > 0)
	{
%>
	<tr>
		<td class='line' width='530' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='530'>
<%
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(i);

%>
				<tr>
					<td style="font-size:8pt"  width='40' align='center'><%=i+1%></td>
					<td style="font-size:8pt"  width='100' align='center'><%=ht.get("차량번호")%></td>
					<td style="font-size:8pt"  width='80' align='center'><%=ht.get("차종소분류")%></td>
					<td style="font-size:8pt"  width='80' align='center'><%=ht.get("현차종코드")%></td>
					<td style="font-size:8pt"  width='80' align='center'><%=ht.get("구차종코드")%></td>
					<td style="font-size:8pt"  width='150' align='center'><span title='<%=ht.get("차명")%>'><%=Util.subData(String.valueOf(ht.get("차명")), 10)%></span></td>
				</tr>
<%
		}
%>
			</table>
		</td>
		<td class='line' width='1750'>
			<table border="0" cellspacing="1" cellpadding="0" width='1750'>
<%
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(i);

%>			
				<tr>
					<td style="font-size:8pt"  width='80' align='center'><%=ht.get("최초등록일")%></td>
					<td style="font-size:8pt"  width='80' align='center'><%=ht.get("에어백")%></td>
					<td style="font-size:8pt"  width='150' align='center'><span title='<%=ht.get("피보험자")%>'><%=Util.subData(String.valueOf(ht.get("피보험자")), 10)%></span></td>
					<td style="font-size:8pt"  width='80' align='center'><%=ht.get("보험종류")%></td>
					<td style="font-size:8pt"  width='80' align='center'><%=ht.get("연령범위")%></td>
					<td style="font-size:8pt"  width='80' align='center'><%=ht.get("대물배상")%></td>
					<td style="font-size:8pt"  width='80' align='center'><%=ht.get("자기신체사고_사망장애")%></td>
					<td style="font-size:8pt"  width='80' align='center'><%=ht.get("자기신체사고_부상")%></td>
					<td style="font-size:8pt"  width='80' align='center'><%=ht.get("자차차량")%></td>
					<td style="font-size:8pt"  width='80' align='center'><%=ht.get("자차자기부담금")%></td>					
					<td style="font-size:8pt"  width='80' align='center'><%=ht.get("보험시작일")%></td>
					<td style="font-size:8pt"  width='80' align='center'><%=ht.get("보험만료일")%></td>										
				    <td style="font-size:8pt"  width='80' align='right'><%=ht.get("대인1")%>&nbsp;</td>
				    <td style="font-size:8pt"  width='80' align='right'><%=ht.get("대인2")%>&nbsp;</td>
				    <td style="font-size:8pt"  width='80' align='right'><%=ht.get("대물")%>&nbsp;</td>
				    <td style="font-size:8pt"  width='80' align='right'><%=ht.get("자손")%>&nbsp;</td>
				    <td style="font-size:8pt"  width='80' align='right'><%=ht.get("무보험")%>&nbsp;</td>
				    <td style="font-size:8pt"  width='80' align='right'><%=ht.get("분담금")%>&nbsp;</td>
				    <td style="font-size:8pt"  width='80' align='right'><%=ht.get("자차")%>&nbsp;</td>
				    <td style="font-size:8pt"  width='80' align='right'><%=ht.get("특약")%>&nbsp;</td>
				    <td style="font-size:8pt"  width='80' align='right'><%=ht.get("총보험료")%>&nbsp;</td>
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
		<td class='line' width='530' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='530'>
				<tr>
					<td align='center'>
					<%if(t_wd.equals("")){%>검색어를 입력하십시오.
					<%}else{%>등록된 데이타가 없습니다<%}%></td>
				</tr>
			</table>
		</td>
		<td class='line' width='1750'>
			<table border="0" cellspacing="1" cellpadding="0" width='1750'>
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

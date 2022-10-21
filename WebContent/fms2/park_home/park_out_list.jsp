<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.parking.*, java.*"%>
<jsp:useBean id="pk_db" scope="page" class="acar.parking.ParkIODatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	String brid 	= request.getParameter("brid")==null?"":request.getParameter("brid");
	int count =0;
	
	String reg_dt = Util.getDate();
				
	Vector vt = pk_db.ParkRentCont(reg_dt);
	int vt_size = vt.size();	

%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	// Title 고정 
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
	function init() 
	{
		
		setupEvents();
	}
	
//문자 보내기
	function SandSms(tel, car_no){
		var fm = document.form1;				
		//if(fm.destphone.value == ''){ alert("경매장을 선택하세요."); return;	}
		if(confirm('문자를 보내시겠습니까?'))				
		{				
			
			fm.action = "sms_send.jsp?&destphone="+tel+"&car_no="+car_no;
			fm.target = "i_no";		
			fm.submit();	
		}
	}
//-->
</script>

<style>

.listnum2 a:link {color:#ff0000; text-decoration:underline;} 
.listnum2 a:visited {color:#ff0000; text-decoration:underline;} 
.listnum2 a:hover {color:#ff0000; text-decoration:underline;} 

</style>

</head>

<body onLoad="javascript:init()">
<form name='form1' action='' method='post'>


<table border="0" cellspacing="0" cellpadding="0" width='100%'>
	<tr><td colspan="2" align="center"><h3>배차 체크 현황</h3></td></tr>
	<tr><td colspan="2" align="right">작성일 :<%= reg_dt%></td></tr>
	<tr>
	<td class=h></td>
	</tr>
	<tr><td class=line2 colspan="2"></td></tr>
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' id='td_title' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%' height="43">
				<tr> 
					<td class='title' width="5%" >연번</td>
					<td class='title' width="15%" >차종</td>
					<td class='title' width="15%" >차량번호</td>
					<td class='title' width="15%" >비고</td>
				
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class='line' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<% 
    if ( vt_size > 0) { 		
		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);

%>         
				<tr>
					<td align="center" width="5%"><%=i+1%></td>
					<td align="center" width="15%"><%=ht.get("CAR_NM")%><%if(!ht.get("MNG_ID").equals("")){%>&nbsp;<a href="javascript:SandSms('<%=ht.get("USER_M_TEL")%>','<%=ht.get("CAR_NO")%>')"><img src="/acar/images/icon_tel.gif" align=absmiddle border=0></a><%}%></td>
					<td align="center" width="15%"><%=ht.get("CAR_NO")%></td>		
					<td align="center" width="15%"></td>
				</tr>
  
 <%  }
  }  else{	%>                    
			<tr>		
				<td class=''>
					<table border="0" cellspacing="1" cellpadding="0" width='100%'>
						<tr> 
							<td align='center'>등록된 데이타가 없습니다</td>
						</tr>
					</table>
				</td>
			</tr>
 <%	}	%>		
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
	<tr>
		<td class=>※배차 체크 현황 정리방법.</td>
	</tr>
	<tr>
		<td class=>1.주차장현황에 없는데 보유차관리에 있는경우로 담당자들이 대차등을 하고서 배반차를 안잡는 경우이므로 담당자들에게 연락해서 배반차 처리를 하도록 통보해준다. <p/></td>
	</tr>
	<tr>
		<td class=>2. 주차장에서 공업사로 차량정비나 검사를 받으러 갔는데 보유차관리에 현위치가 주차장으로 되어 있는 경우. 현위치를 수정해 준다.</td>
	</tr>
</table>

</form>
</body>
</html>

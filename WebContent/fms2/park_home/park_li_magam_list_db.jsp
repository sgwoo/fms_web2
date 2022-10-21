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
	
	Vector vt = pk_db.Park_li_Magam(save_dt, t_wd, brid);
	int vt_size = vt.size();	
	
	String remarks = "";

%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table_t.css">
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
	

//-->
</script>

<style>

.listnum2 a:link {color:#ff0000; text-decoration:underline;} 
.listnum2 a:visited {color:#ff0000; text-decoration:underline;} 
.listnum2 a:hover {color:#ff0000; text-decoration:underline;} 

</style>

</head>
<!-- MeadCo ScriptX -->
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30"></object>

<body onLoad="javascript:init()">
<form name='form1' action='' method='post'>


<table border="0" cellspacing="0" cellpadding="0" width='100%'>
	<tr><td colspan="2" align="center"><h3><%if(brid.equals("1")){%>본사<%}else if(brid.equals("3")){%>부산<%}else{%>대전<%}%>주차장 차량현황(매각차량포함)</h3></td></tr>
	<tr><td colspan="2" align="right">작성일 : <%=AddUtil.ChangeDate2(save_dt)%></td></tr>
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
					<td class='title' width="10%" >차키</td>
					<td class='title' width="5%" >위치</td>
					<td class='title' width="20%" >FMS</td>
					<td class='title' width="15%" >메모</td>
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
			remarks = String.valueOf(ht.get("REMARKS")) ;

%>         
				<tr>
					<td align="center" width="5%"><%=i+1%></td>
					<td align="center" width="15%"><%=ht.get("CAR_NM")%></td>
					<td align="center" width="15%"><%=ht.get("CAR_NO")%></td>
					<td align="center" width="10%"><%if(ht.get("CAR_KEY").equals("X")){%>
							<%=ht.get("CAR_KEY_CAU")%>
						<%}else if(ht.get("CAR_KEY").equals("O")){%>
							O
						<%}%></td>
					<td align="center" width="5%"><%=ht.get("AREA")%></td>
					<td align="center" width="20%"><%if(!ht.get("FIRM_NM").equals("(주)아마존카")){%><%=ht.get("FIRM_NM")%><%}else if(ht.get("RENT_ST_NM").equals("매각확정")){%>매각확정<%}%></td>
					<td align="center" width="15%">
													<%if(!ht.get("FIRM_NM").equals("(주)아마존카") && !ht.get("CLS_ST").equals("")) {%>
														<%=ht.get("USER_NM")%>
													<%}else if(!ht.get("FIRM_NM").equals("(주)아마존카") && ht.get("CLS_ST").equals("")){%>
														<%=ht.get("USER_NM")%>
													<%}%>
					</td>
					<td align="center" width="15%"><%if(ht.get("CAR_ST").equals("4")){%>신차<%}else if(ht.get("RENT_START_DT").equals("") && ht.get("CAR_GU").equals("0")){%>재리스<%}%><%if(!ht.get("IN_DT").equals("") && ht.get("CLS_ST").equals("")){%>임시회수<%}%><%if(!ht.get("CLS_ST").equals("")){%>해지처리중<%}%></td>
				
				</tr>
  
 <%  }
  }  else{	%>                    
			<tr>		
				<td class='line'>
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
		<td class="h"></td>
	</tr>
		<tr>
		<td class="h">※특이사항</td>
	</tr>	
		
	<tr>	
		<td align="center"><textarea rows='2' name='park_note' cols='125' style='IME-MODE: active' ><%=remarks%></textarea>
			
		</td>
	</tr>	
			
</table>
</form>
</body>
</html>

<script>
onprint();

function onprint(){
factory.printing.header = ""; //폐이지상단 인쇄
factory.printing.footer = ""; //폐이지하단 인쇄
factory.printing.portrait = true; //true-세로인쇄, false-가로인쇄    
factory.printing.leftMargin = 5.0; //좌측여백   
factory.printing.topMargin = 40.0; //상단여백    
factory.printing.rightMargin = 5.0; //우측여백
factory.printing.bottomMargin = 5.0; //하단여백
factory.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
}
</script>

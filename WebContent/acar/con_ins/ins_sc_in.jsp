<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.con_ins.*"%>
<jsp:useBean id="ai_db" scope="page" class="acar.con_ins.AddInsurDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	/* Title 고정 */
	function setupEvents(){
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
	}	
	function moveTitle(){
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    	    
	}
	function init(){		
		setupEvents();
	}	
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body onLoad="javascript:init()">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":AddUtil.ChangeString(request.getParameter("st_dt"));
	String end_dt = request.getParameter("end_dt")==null?"":AddUtil.ChangeString(request.getParameter("end_dt"));
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String f_list = request.getParameter("f_list")==null?"now":request.getParameter("f_list");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	int total_su = 0;
	long total_amt = 0;
	
	
	Vector inss = ai_db.getInsPayList(f_list, br_id, gubun1, gubun2, gubun3, gubun4, st_dt, end_dt, s_kd, t_wd, sort_gubun, asc, gubun);
	int ins_size = inss.size();
	
	
	int t_table_width = 0;		
	int tr_table1_width = 0;		
	int tr_table2_width = 0;		
	
	if(gubun.equals("")){
		if(f_list.equals("now"))		t_table_width = 1240;
		else if(f_list.equals("renew"))		t_table_width = 1030;
		else					t_table_width = 950;
	}else{
		t_table_width = 1040;
	}
	
	if(gubun.equals("cls"))	tr_table1_width = 440;
	else			tr_table1_width = 560;
	
	
	if(gubun.equals("cls")){		tr_table2_width = 600;
	}else{
		if(f_list.equals("now"))	tr_table2_width = 690;
		else if(f_list.equals("renew"))	tr_table2_width = 480;
		else				tr_table2_width = 400;
	}

	t_table_width 	= t_table_width+120; 
	tr_table2_width = tr_table2_width+120; 	

	t_table_width 	= t_table_width+60; 
	tr_table2_width = tr_table2_width+60; 	
	
%>
<table border="0" cellspacing="0" cellpadding="0" width='<%=t_table_width%>'>
	<tr>
	    <td class=line2 colspan=2></td>
	</tr>
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width='<%=tr_table1_width%>' id='td_title' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td width='65' class='title'>연번</td>
					<td width='105' class='title'>계약번호</td>
					<%if(gubun.equals("")){%>
					<td width='120' class='title'>상호</td>
					<%}%>
					<td width='120' class='title'>차량번호</td>
					<td width='150' class='title'>차명</td>
				</tr>
			</table>
		</td>
		<td class='line' width='<%=tr_table2_width%>'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<%if(gubun.equals("")){%>				
					<td width='50' class='title'>에어백</td>
					<td width='80' class='title'>가입연령</td>
					<%}%>					
					<td width='100' class='title'>보험사</td>
					<td width='60' class='title'>용도</td>
					<td width='120' class='title'>증권번호</td>
					<td width='80' class='title'>보험계약일</td>
					<td width='80' class='title'><%if(gubun.equals("")) {%>보험만료<%}else{%>해지발생<%}%>일</td>
					<%if(gubun.equals("cls")){%>
					<td width='80' class='title'>청구일자</td>
					<%}%>
					<%if(f_list.equals("now")){%>
					<%if(gubun.equals("")){%>									
					<td width='40' class='title'>회차</td>
					<%}%>
					<td width='80' class='title'><%if(gubun.equals("cls")) {%>입금예정일 <%}else{%> 납부예정일 <%}%></td>
					<td width='100' class='title'><%if(gubun.equals("cls")) {%>환급예정 <%}else{%> 납부 <%}%>금액</td>
					<td width='80' class='title'><%if(gubun.equals("cls")) {%>환급 <%}else{%> 납부 <%}%>일</td>
					<%}else if(f_list.equals("renew")){%>
					<td width='80' class='title'>갱신구분</td>
					<%}else{%><%}%>					
				</tr>
			</table>
		</td>
	</tr>
<%	if(ins_size > 0){%>
	<tr>
		<td class='line' width='<%=tr_table1_width%>' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%		for(int i = 0 ; i < ins_size ; i++){
				Hashtable ins = (Hashtable)inss.elementAt(i);%>
				<tr>
					<td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center' width='65'><%=i+1%><%if(ins.get("USE_YN").equals("N")) out.println("(해지)");%></td>
					<td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center' width='104'><a href="javascript:parent.view_ins('<%=ins.get("RENT_MNG_ID")%>', '<%=ins.get("RENT_L_CD")%>', '<%=ins.get("CAR_MNG_ID")%>', '<%=ins.get("INS_ST")%>')" onMouseOver="window.status=''; return true"><%=ins.get("RENT_L_CD")%></a></td>
					<%if(gubun.equals("")){%>					
					<td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='left'   width='120'>&nbsp;<span title='<%=ins.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(ins.get("FIRM_NM")), 8)%></span></td>
					<%}%>					
					<td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center' width='120'><%=ins.get("CAR_NO")%></td>
					<td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center' width='150'><span title='<%=ins.get("CAR_NM")%> <%=ins.get("CAR_NAME")%>'><%=Util.subData(String.valueOf(ins.get("CAR_NM"))+" "+String.valueOf(ins.get("CAR_NAME")), 11)%></span></td>
				</tr>
<%		}%>
				<tr>
            		<td class="title" align='center'>
					<td class="title">&nbsp;</td>
					<td class="title" align='center'>합계</td>
					<td class="title">&nbsp;</td>
				</tr>
			</table>
		</td>
		<td class='line' width='<%=tr_table2_width%>'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%		for(int i = 0 ; i < ins_size ; i++){
				Hashtable ins = (Hashtable)inss.elementAt(i);%>			
				<tr>
					<%if(gubun.equals("")){%>								
					<td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center' width='50' ><%if(String.valueOf(ins.get("AIR")).equals("0")){%>-<%}else{%><%=ins.get("AIR")%>개 <%}%></td>
					<td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center' width='80' ><%=ins.get("AGE_SCP")%></td>
					<%}%>
					<td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center' width='100'><%=ins.get("INS_COM_NM")%></td>
					<td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center' width='60'><%if(String.valueOf(ins.get("CAR_USE")).equals("1")){%>영업용<%}else{%>업무용<%}%></td>
					<td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center' width='120'><%=ins.get("INS_CON_NO")%></td>
					<td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center' width='80' ><%=ins.get("INS_START_DT")%></td>
					<td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center' width='80' ><%=AddUtil.ChangeDate2(String.valueOf(ins.get("EXP_DT")))%></td>					
					<%if(gubun.equals("cls")){%>
					<td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center' width='80' ><%=AddUtil.ChangeDate2(String.valueOf(ins.get("CLS_REQ_DT")))%></td>
					<%}%>
					<%if(f_list.equals("now")){//납부리스트%>
					<%if(gubun.equals("")){%>												
					<td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center' width='40' ><%if(String.valueOf(ins.get("INS_TM")).equals("9")){%>추가<%}else{%><%=ins.get("INS_TM")%>회<%}%></td>
					<td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center' width='80' ><%=ins.get("R_INS_EST_DT")%></td>
					<%}else{%>
					<td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center' width='80' ><%=ins.get("R_INS_EST_DT")%></td>
					<%}%>
					<td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='right'  width='100' ><%=Util.parseDecimal(String.valueOf(ins.get("PAY_AMT")))%>원&nbsp;</td>
					<td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center' width='80'>
					<%if(String.valueOf(ins.get("PAY_YN")).equals("1")){%>
						<%=ins.get("PAY_DT")%>
					<%}else{%>
					<%//if(auth_rw.equals("R/W")){%>
					<%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
						
					<%	}else{%>-<%}
					  }%>
					</td>
				<%}else if(f_list.equals("renew")){//갱신리스트%>
					<td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center' width='80'>
					<%//if(auth_rw.equals("R/W")){%>
					<%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>		
						<%if(!String.valueOf(ins.get("INS_STS")).equals("4")){%>			
					<a href="javascript:parent.remake_ins('<%=ins.get("RENT_MNG_ID")%>', '<%=ins.get("RENT_L_CD")%>', '<%=ins.get("CAR_MNG_ID")%>', '<%=ins.get("INS_ST")%>')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_gs.gif align=absmiddle border=0></a>&nbsp;&nbsp;
						<%}%>
					<a href="javascript:parent.disable_renew('<%=ins.get("CAR_MNG_ID")%>', '<%=ins.get("INS_ST")%>')" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_in_mr.gif align=absmiddle border=0></a>
					<%}else{%>갱신 가능<%}%>
					</td>				
				<%}else{//만료리스트%><%}%>		
				</tr>
<%
				total_su = total_su + 1;
				total_amt = total_amt + Long.parseLong(String.valueOf(ins.get("PAY_AMT")));
		}
%>
				<tr>
					<%if(gubun.equals("")){%>												
					<td class="title">&nbsp;</td>
					<td class="title">&nbsp;</td>
					<%}%>					
					<td class="title">&nbsp;</td>
					<td class="title">&nbsp;</td>
					<td class="title">&nbsp;</td>
					<td class="title">&nbsp;</td>	
					<td class="title">&nbsp;</td>					
					<%if(gubun.equals("cls")){%>
					<td class="title">&nbsp;</td>	
					<%}%>
					<%if(f_list.equals("now")){%>
					<%	if(gubun.equals("")){%>																	
					<td class="title">&nbsp;</td>
					<%	}%>					
					<td class="title">&nbsp;</td>					
					<td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt)%></td>
					<td class="title">&nbsp;</td>
					<%}else if(f_list.equals("renew")){%>
					<td class="title">&nbsp;</td>
					<%}else{%><%}%>					
				</tr>
			</table>
		</td>
	</tr>
<%	}else{%>                     
	<tr>
		<td class='line' width='<%=tr_table1_width%>' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td align='center'>등록된 데이타가 없습니다</td>
				</tr>
			</table>
		</td>
		<td class='line' width='<%=tr_table2_width%>'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td>&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
<%	}%>
</table>
</body>
</html>

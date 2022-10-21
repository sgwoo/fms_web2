<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,java.text.*, acar.util.*"%>
<%@ page import="acar.insur.*, acar.client.* "%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="ins" 	scope="page" class="acar.insur.InsurBean"/>
<%@ include file="/acar/cookies.jsp" %>

<%

	InsDatabase in_db = InsDatabase.getInstance();
	String client_id = request.getParameter("client_id");
	//고객정보
	ClientBean client = al_db.getNewClient(client_id); 
	
	
	
	Vector info = in_db.getInsComEmpInfo4(client_id, "");
	int info_size = info.size();
	
	 Date d = new Date();
	 SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
	 String sysdate =   sdf.format(d);	
	
%> 
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script src='/include/common.js'></script>
<script>
	function sendRegPage(){
		  window.history.back();
	}
	function printEmpInfo(){
		/* window.open("ins_u_sh_emp_print2.jsp", "VIEW_HELP_INS_COM", "left=500, top=50, width=800, height=900, scrollbars=yes"); */
		var fm = document.form1;
		var url = "ins_u_sh_emp_print2.jsp";
		window.open("" ,"popForm", 
		      "left=500, top=50, width=800, height=900, scrollorbars=yes"); 
		fm.action =url; 
		fm.method="post";
		fm.target="popForm";
		fm.submit();

	}
</script>
<style>
	td.title{height:26px;}
	input{height:20px;}
	select{height:20px;}
	input[type=button]{height:20px;font-size:8pt;}
	input[type=radio]{height:13px;}
</style>
</head>
<body>
<form name='form1' method='post' action=''>
 <input type='hidden' name='client_id' value='<%=client_id%>'>
<table width=100% border=0 cellpadding=0 cellspacing=0>
	<tr>
		<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
		<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>사고관리 > 보험관리 > 임직원보험가입확인서 ><span class=style5>
			임직원보험가입 상세내용</span></span></td>
		<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
	</tr>
</table>
<br>
<div style="font-size:9pt;margin-bottom:5px;">
	<img src="/acar/images/center/button_back_p.gif" onclick="sendRegPage()" style="margin-bottom:20px;float:right;cursor:pointer;">
</div>
<div style="text-align:left;font-size:13pt;font-weight:normal;margin-top:30px;">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	      <tr> 
	        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>고객피보험정보</span></td>
	    </tr>
	    <tr>
	        <td class=line2></td>
	    </tr>
	    <tr> 
	        <td class=line colspan="2"> 
	            <table border="0" cellspacing="1" width=100%>
	                <tr> 
	                 	<td class="title">고객명(상호)</td>
						<td align="center"><%=client.getFirm_nm() %></td>
						<td class="title">사업자등록번호</td>
						<td align="center"><%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%></td>
					</tr>
	               <tr>
						<td class="title">대표이사</td>
						<td align="center"><%=client.getClient_nm() %></td>
						<td class="title">법인등록번호</td>
						<td align="center"> <%=client.getSsn1()%>-<%=client.getSsn2()%></td>
					</tr>
	            </table>
	        </td>
	    </tr>
	      <tr>
	        <td class=line2></td>
	    </tr>
	</table>
</div>
<br>
<div style="text-align:left;font-size:13pt;font-weight:normal;margin-top:30px;">
	<div style="font-size:10.5pt;display:inline-block;float: right;">
		<span style="margin-right:10px;"> 기준연도 <input type="text" name="base_year" style="width:40px;" value="<%=Integer.parseInt(sysdate.substring(0,4))-1%>"/> </span> 
		<img src="/acar/images/center/button_print.gif" onclick="printEmpInfo()" style="float:right;cursor:pointer;"> 
	</div>
</div>
<div>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	      <tr> 
	        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>임직원 전용 자동차보험 가입내역</span>	</td>
	    </tr>
	    <tr>
	        <td class=line2></td>
	    </tr>
	    <tr> 
	        <td class=line colspan="2"> 
	            <table border="0" cellspacing="1" width=100%>
	                <tr style="height:30;">
						<td width="25" class="title">연번</td>				
						<td width="50" class="title">차량번호</td>				
						<td width="50" class="title">차명</td>				
						<td width="60" class="title">보험사</td>				
						<td width="70" class="title">증권번호</td>				
						<td width="140" class="title">임직원 전용 자동차보험 가입기간</td>				
			
					</tr>
	               <%for(int i = 0 ; i < info_size ; i++){
 					Hashtable ht = (Hashtable)info.elementAt(i);%>
		  				<tr style="font-size:12pt;">
							<td align="center"><%=i+1%></td>		
							<td align="center"><%=ht.get("CAR_NO")%></td>		
							<td align="center"><%=ht.get("CAR_NM")%></td>			
							<td align="center"><%=ht.get("INS_COM_NM")%></td>		
							<td align="center"><%=ht.get("INS_CON_NO")%></td>		
							<td align="center"><%=AddUtil.ChangeDate(String.valueOf(ht.get("COM_EMP_START_DT")),"YYYY-MM-DD")%> ~ 
											<%if(!String.valueOf(ht.get("COM_EMP_EXP_DT")).equals("확인서 발급일 현재")){%>	
												<%=AddUtil.ChangeDate(String.valueOf(ht.get("COM_EMP_EXP_DT")),"YYYY-MM-DD")%>
											<%}else{%>
												<%=ht.get("COM_EMP_EXP_DT")%>	
											<%}%>
							</td>		
						</tr>	
		 				<%} %>
		 				
	 				<%if(info_size < 8){%>
	 					<%for(int i = 0 ; i < 7-info_size ; i++){%>
					<tr>
						<td></td>		
						<td></td>		
						<td></td>			
						<td></td>		
						<td></td>		
						<td></td>		
					</tr>			
						<%} %>
					<%} %>
	            </table>
	        </td>
	    </tr>
	      <tr>
	        <td class=line2></td>
	    </tr>
	</table>
</div>

	
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>

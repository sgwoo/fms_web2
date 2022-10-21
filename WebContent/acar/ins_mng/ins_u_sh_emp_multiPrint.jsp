<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,java.text.*, acar.util.*, acar.client.*,acar.insur.*"%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String ch_cd[] 	= request.getParameterValues("ch_cd");
	String base_year 	= request.getParameter("base_year")==null?"":request.getParameter("base_year");

	InsDatabase in_db = InsDatabase.getInstance();

%>
<!DOCTYPE html>
<html>
<head><title>FMS</title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
<script language='JavaScript' src='/include/common.js'></script>
<style>
@import url(http://fonts.googleapis.com/earlyaccess/nanumgothic.css);	
@import url(http://fonts.googleapis.com/earlyaccess/nanummyeongjo.css);
body {
    width: 100%;
    height: 100%;
    margin: 0;
    padding: 0;
    background-color: #ddd;
   /*  font-family: NanumBarunGothic, "굴림", gulim,"돋움", dotum, arial, helvetica, sans-serif; */ 
}
* {
    box-sizing: border-box;
    -moz-box-sizing: border-box;
}
.paper {
    width: 210mm;
    min-height: 297mm;
    padding: 10mm; /* set contents area */
    margin: 10mm auto;
    border-radius: 5px;
    background: #fff;
    box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
}
.content {
    padding: 20px;
   /*  border: 1px #888 solid ; */
    height: 273mm;
}
@page {
    size: A4;
    margin: 0;
}
@media print {
    html, body {
        width: 210mm;
        height: 297mm;
        background: #fff;
    }
    .paper {
        margin: 0;
        border: initial;
        border-radius: initial;
        width: initial;
        min-height: initial;
        box-shadow: initial;
        background: initial;
        page-break-after: always;
    }
   
}
	/* #contents {font-size:9pt}; */
 table {
     border: 2px solid #444444;
    border-collapse: collapse; 
  }
  th, td {
   	border: 1px solid #444444;
    font-size:9pt;
    text-align:center;
  }
  input {border:0px;font-size:11pt;font-family: 'Nanum Gothic',sans-serif;}
.title{text-align:center;background-color: #4442;font-size:9pt;font-weight:bold;}  
.contents {font-size:9pt; font-family:돋움; }
.contents tr{ height:30px;}

#wrap{ font-family: '돋움',sans-serif; vertical-align: middle;}
	
</style>
</head>
<body>
<form action="" name="form1" method="POST" >
<%
	for(int j=0; j< ch_cd.length; j++){
		
		String client_id = ch_cd[j];
		
		//고객정보
		ClientBean client = al_db.getNewClient(client_id); 
		
		String int_reg_dt = "";
		
		Vector info = in_db.getInsComEmpInfo4(client_id, base_year);
		int info_size = info.size();
		
		for(int i = 0 ; i < info_size ; i++){
			Hashtable ht = (Hashtable)info.elementAt(i);
			if(i == 0) int_reg_dt = String.valueOf(ht.get("COM_EMP_START_DT"));
		}
		if(!int_reg_dt.equals("")){
			String year = int_reg_dt.substring(0,4);
			String mon = int_reg_dt.substring(4,6);
			String day =int_reg_dt.substring(6,8);
			int_reg_dt = year+"년 "+mon +"월 "+day+"일";
		}
		
		
		Date d = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		String sysdate =   sdf.format(d);	
	
		int count = 0;	
		
		
%>	
	<input type="hidden" name="pageWidth" value="">
	<input type="hidden" name="pageHeight" value="">
    <div class="paper">
    <div class="content">
		<div id="wrap" style="width:100%;">
			<div style="">
				<div style="text-align:center;margin-bottom:15px;margin-top:30px;font-size:20pt;font-weight:bold;  text-decoration: underline; font-family: 'Nanum Myeongjo'">
					임직원 전용 자동차보험 가입사실 확인서
				</div>
			</div>
			<br>
			<div style="margin-top:30px;">
				<div style="margin-bottom:8px;font-weight:bold;"> &nbsp;<span style="font-size:11pt;">※</span>고객사항&nbsp;</div>  
				<table border="0" cellspacing="0" cellpadding='0' width='100%' class="contents" style="table-layout:fixed;">
					<tr>
						<td class="title">고객명(상호)</td>
						<td><%=client.getFirm_nm() %></td>
						<td class="title">사업자등록번호</td>
						<td><%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%></td>
					</tr>
					<tr>
						<td class="title">대표이사</td>
						<td><%=client.getClient_nm() %></td>
						<td class="title">법인등록번호</td>
						<td><%=client.getSsn1()%>-<%=client.getSsn2()%></td>
					</tr>
				</table>
			</div>			
			<br>
			<div style="margin-top:30px;">
				<div>
				<div style="margin-bottom:8px;font-weight:bold;display:inline-block;"> &nbsp;<span style="font-size:11pt;">※</span>임직원 전용 자동차보험 가입내역</div> 
				<div style="margin-bottom:8px;font-weight:bold;font-size:11pt;display:inline-block;float: right;"> [ 기준연도 : <%=base_year%> ]</div> 
				</div>
				<table border="0" cellspacing="0" cellpadding='0' width='100%' class="contents" style="table-layout:fixed; word-break:break-all;font-size:12pt;">
					<tr style="height:30;">
						<td width="25" class="title">연번</td>				
						<td width="50" class="title">차량번호</td>				
						<td width="50" class="title">차명</td>				
						<td width="60" class="title">보험사</td>				
						<td width="70" class="title">증권번호</td>				
						<td width="140" class="title">임직원 전용 자동차보험 가입기간</td>				

					</tr>
							
					 <%for(int i = 0 ; i < info_size ; i++){
						if(count == 10) break; 
    					Hashtable ht = (Hashtable)info.elementAt(i);%>
	    				<tr>
							<td><%=i+1%></td>		
							<td><%=ht.get("CAR_NO")%></td>		
							<td><%=ht.get("CAR_NM")%></td>			
							<td><%=ht.get("INS_COM_NM")%></td>		
							<td><%=ht.get("INS_CON_NO")%></td>		
							<td><%=AddUtil.ChangeDate(String.valueOf(ht.get("COM_EMP_START_DT")),"YYYY-MM-DD")%> ~ 
								<%if(!String.valueOf(ht.get("COM_EMP_EXP_DT")).equals("확인서 발급일 현재")){%>	
									<%=AddUtil.ChangeDate(String.valueOf(ht.get("COM_EMP_EXP_DT")),"YYYY-MM-DD")%>
								<%}else{%>
									<%=ht.get("COM_EMP_EXP_DT")%>	
								<%}%>
							</td>		
						</tr>
						<%count++;%>	
    				<%} %>
    				
    				<%if(info_size < 10){%>
    					<%for(int i = 0 ; i < 10-info_size ; i++){%>
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
			</div>
			<div style="text-align:center;margin-top:20px;font-size:12pt;margin-top:50px;">
				<span style="text-align:center">상기 대여 차량에 위와 같이 임직원 전용 자동차 보험이 가입된 사실이 있음을 확인합니다.</span>
			</div>
			<div style="text-align:center;margin-top:60px;font-size:13pt;">
				<span style="text-align:left"><%=sysdate.substring(0,4)%>&nbsp;년&nbsp;&nbsp;<%=sysdate.substring(4,6)%>&nbsp;월&nbsp;&nbsp;<%=sysdate.substring(6,8)%>&nbsp;일</span>
			</div>
			<div style="margin-left:150px;margin-top:100px;font-size:16pt;font-weight:bold;">
				<div style="">(주)아마존카 대표이사</div>
				<div style="position:relative;z-index:1;top:-60px;margin-left:240px;"><img src="/acar/images/content/sign.gif" width="" height=""></div> 
			</div>
		</div>
	</div>
	</div>
	<%if(info_size > 10) {%>
	<div class="paper">
    <div class="content">
		<div id="wrap" style="width:100%;">
			<div style="">
				<div style="text-align:center;margin-bottom:15px;margin-top:30px;font-size:20pt;font-weight:bold;  text-decoration: underline; font-family: 'Nanum Myeongjo'">
					임직원 전용 자동차보험 가입사실 확인서
				</div>
			</div>
			<br>
			<div style="margin-top:30px;">
				<div style="margin-bottom:8px;font-weight:bold;"> &nbsp;<span style="font-size:11pt;">※</span>고객사항&nbsp;</div>  
				<table border="0" cellspacing="0" cellpadding='0' width='100%' class="contents" style="table-layout:fixed;">
					<tr>
						<td class="title">고객명(상호)</td>
						<td><%=client.getFirm_nm() %></td>
						<td class="title">사업자등록번호</td>
						<td><%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%></td>
					</tr>
					<tr>
						<td class="title">대표이사</td>
						<td><%=client.getClient_nm() %></td>
						<td class="title">법인등록번호</td>
						<td><%=client.getSsn1()%>-<%=client.getSsn2()%></td>
					</tr>
				</table>
			</div>			
			<br>
			<div style="margin-top:30px;">
				<div>
				<div style="margin-bottom:8px;font-weight:bold;display:inline-block;"> &nbsp;<span style="font-size:11pt;">※</span>임직원 전용 자동차보험 가입내역</div> 
				<div style="margin-bottom:8px;font-weight:bold;font-size:11pt;display:inline-block;float: right;"> [ 기준연도 : <%=base_year%> ]</div> 
				</div>
				<table border="0" cellspacing="0" cellpadding='0' width='100%' class="contents" style="table-layout:fixed; word-break:break-all;font-size:12pt;">
					<tr style="height:30;">
						<td width="25" class="title">연번</td>				
						<td width="50" class="title">차량번호</td>				
						<td width="50" class="title">차명</td>				
						<td width="60" class="title">보험사</td>				
						<td width="70" class="title">증권번호</td>				
						<td width="140" class="title">임직원 전용 자동차보험 가입기간</td>				
					</tr>
							
					 <%for(int i = 10 ; i < info_size ; i++){
						if(count == 20) break; 
    					Hashtable ht = (Hashtable)info.elementAt(i);%>
	    				<tr>
							<td><%=i+1%></td>		
							<td><%=ht.get("CAR_NO")%></td>		
							<td><%=ht.get("CAR_NM")%></td>			
							<td><%=ht.get("INS_COM_NM")%></td>		
							<td><%=ht.get("INS_CON_NO")%></td>		
							<td><%=AddUtil.ChangeDate(String.valueOf(ht.get("COM_EMP_START_DT")),"YYYY-MM-DD")%> ~ 
								<%if(!String.valueOf(ht.get("COM_EMP_EXP_DT")).equals("확인서 발급일 현재")){%>	
									<%=AddUtil.ChangeDate(String.valueOf(ht.get("COM_EMP_EXP_DT")),"YYYY-MM-DD")%>
								<%}else{%>
									<%=ht.get("COM_EMP_EXP_DT")%>	
								<%}%>
							</td>		
						</tr>
						<%count++;%>	
    				<%} %>
    				
    				<%if(info_size < 20){%>
    					<%for(int i = 0 ; i < 20-info_size ; i++){%>
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
			</div>
			<div style="text-align:center;margin-top:20px;font-size:12pt;margin-top:50px;">
				<span style="text-align:center">상기 대여 차량에 위와 같이 임직원 전용 자동차 보험이 가입된 사실이 있음을 확인합니다.</span>
			</div>
			<div style="text-align:center;margin-top:60px;font-size:13pt;">
				<span style="text-align:left"><%=sysdate.substring(0,4)%>&nbsp;년&nbsp;&nbsp;<%=sysdate.substring(4,6)%>&nbsp;월&nbsp;&nbsp;<%=sysdate.substring(6,8)%>&nbsp;일</span>
			</div>
			<div style="margin-left:150px;margin-top:100px;font-size:16pt;font-weight:bold;">
				<div style="">(주)아마존카 대표이사</div>
				<div style="position:relative;z-index:1;top:-60px;margin-left:240px;"><img src="/acar/images/content/sign.gif" width="" height=""></div> 
			</div>
		</div>
	</div>
	</div>
	<%} %>
	<%if(info_size > 20) {%>
	<div class="paper">
    <div class="content">
		<div id="wrap" style="width:100%;">
			<div style="">
				<div style="text-align:center;margin-bottom:15px;margin-top:30px;font-size:20pt;font-weight:bold;  text-decoration: underline; font-family: 'Nanum Myeongjo'">
					임직원 전용 자동차보험 가입사실 확인서
				</div>
			</div>
			<br>
			<div style="margin-top:30px;">
				<div style="margin-bottom:8px;font-weight:bold;"> &nbsp;<span style="font-size:11pt;">※</span>고객사항&nbsp;</div>  
				<table border="0" cellspacing="0" cellpadding='0' width='100%' class="contents" style="table-layout:fixed;">
					<tr>
						<td class="title">고객명(상호)</td>
						<td><%=client.getFirm_nm() %></td>
						<td class="title">사업자등록번호</td>
						<td><%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%></td>
					</tr>
					<tr>
						<td class="title">대표이사</td>
						<td><%=client.getClient_nm() %></td>
						<td class="title">법인등록번호</td>
						<td><%=client.getSsn1()%>-<%=client.getSsn2()%></td>
					</tr>
				</table>
			</div>			
			<br>
			<div style="margin-top:30px;">
				<div>
				<div style="margin-bottom:8px;font-weight:bold;display:inline-block;"> &nbsp;<span style="font-size:11pt;">※</span>임직원 전용 자동차보험 가입내역</div> 
				<div style="margin-bottom:8px;font-weight:bold;font-size:11pt;display:inline-block;float: right;"> [ 기준연도 : <%=base_year%> ]</div> 
				</div>
				<table border="0" cellspacing="0" cellpadding='0' width='100%' class="contents" style="table-layout:fixed; word-break:break-all;font-size:12pt;">
					<tr style="height:30;">
						<td width="25" class="title">연번</td>				
						<td width="50" class="title">차량번호</td>				
						<td width="50" class="title">차명</td>				
						<td width="60" class="title">보험사</td>				
						<td width="70" class="title">증권번호</td>				
						<td width="140" class="title">임직원 전용 자동차보험 가입기간</td>				
					</tr>
							
					 <%for(int i = 20 ; i < info_size ; i++){
						if(count == 30) break; 
    					Hashtable ht = (Hashtable)info.elementAt(i);%>
	    				<tr style="font-size:12pt;">
							<td><%=i+1%></td>		
							<td><%=ht.get("CAR_NO")%></td>		
							<td><%=ht.get("CAR_NM")%></td>			
							<td><%=ht.get("INS_COM_NM")%></td>		
							<td><%=ht.get("INS_CON_NO")%></td>		
							<td><%=AddUtil.ChangeDate(String.valueOf(ht.get("COM_EMP_START_DT")),"YYYY-MM-DD")%> ~ 
								<%if(!String.valueOf(ht.get("COM_EMP_EXP_DT")).equals("확인서 발급일 현재")){%>	
									<%=AddUtil.ChangeDate(String.valueOf(ht.get("COM_EMP_EXP_DT")),"YYYY-MM-DD")%>
								<%}else{%>
									<%=ht.get("COM_EMP_EXP_DT")%>	
								<%}%>
							</td>		
						</tr>
						<%count++;%>	
    				<%} %>
    				
    				<%if(info_size < 30){%>
    					<%for(int i = 0 ; i < 30-info_size ; i++){%>
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
			</div>
			<div style="text-align:center;margin-top:20px;font-size:12pt;margin-top:50px;">
				<span style="text-align:center">상기 대여 차량에 위와 같이 임직원 전용 자동차 보험이 가입된 사실이 있음을 확인합니다.</span>
			</div>
			<div style="text-align:center;margin-top:60px;font-size:13pt;">
				<span style="text-align:left"><%=sysdate.substring(0,4)%>&nbsp;년&nbsp;&nbsp;<%=sysdate.substring(4,6)%>&nbsp;월&nbsp;&nbsp;<%=sysdate.substring(6,8)%>&nbsp;일</span>
			</div>
			<div style="margin-left:150px;margin-top:100px;font-size:16pt;font-weight:bold;">
				<div style="">(주)아마존카 대표이사</div>
				<div style="position:relative;z-index:1;top:-60px;margin-left:240px;"><img src="/acar/images/content/sign.gif" width="" height=""></div> 
			</div>
		</div>
	</div>
	</div>
	<%} %>
<%	
	}
%>
</form>
</body>
<script>
	function iframeAutoResize(i){
		var width = window.frames[i].document.form1.pageWidth.value;
		var height = window.frames[i].document.form1.pageHeight.value;
		document.getElementsByName("frame1")[i].width = width;
		document.getElementsByName("frame1")[i].height = height;
		document.getElementById("content").height +=height;
	}
	window.onload = function(){
		window.document.body.scroll = "auto";
	}

</script>
</html>
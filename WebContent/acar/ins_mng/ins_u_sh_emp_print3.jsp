<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,java.text.*, acar.util.*"%>
<%@ page import="acar.insur.*, acar.client.* "%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="ins" 	class="acar.insur.InsurBean" 			scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	 	
	InsDatabase in_db = InsDatabase.getInstance();
	
	
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String ins_st 	= request.getParameter("ins_st")==null?"":request.getParameter("ins_st");
	String base_year 	= request.getParameter("base_year")==null?"":request.getParameter("base_year");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	

	
	String int_reg_dt = "";
	
	Vector info = in_db.getInsComEmpInfo3(rent_l_cd);
	int info_size = info.size();
	
	
	//고객정보
	ClientBean client = al_db.getNewClient(client_id); 
/* 	
	Vector info = in_db.getInsComEmpInfo4(client_id, base_year);
	int info_size = info.size(); */
	/*
	 for(int i = 0 ; i < info_size ; i++){
		Hashtable ht = (Hashtable)info.elementAt(i);
	//	if(i == 0) int_reg_dt = String.valueOf(ht.get("COM_EMP_START_DT"));
	}
	if(!int_reg_dt.equals("")){
		String year = int_reg_dt.substring(0,4);
		String mon = int_reg_dt.substring(4,6);
		String day =int_reg_dt.substring(6,8);
		int_reg_dt = year+"년 "+mon +"월 "+day+"일";
	} */
	
	 Date d = new Date();
	 SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
	 String sysdate =   sdf.format(d);	
	 
	 int count = 0;
	
%>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<%@ include file="/acar/getNaviCookies.jsp" %>
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
  input {border:0px;font-size:9pt;font-family: 'Nanum Gothic',sans-serif; text-align:center; color:black;}
.title{text-align:center;background-color: #4442;font-size:9pt;font-weight:bold;}  
.contents {font-size:9pt; font-family:돋움; }
.contents tr{ height:30px;}

#wrap{ font-family: '돋움',sans-serif; vertical-align: middle;}
	
</style>
</head>
<body leftmargin="15" topmargin="1" style="overflow-x:hidden">
<object id="factory" style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,4,438,06"> 
</object> 
<form action="" name="form1" method="POST" >
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
						<td><input type="text" value="<%=client.getFirm_nm()%>"></td>
						<td class="title">사업자등록번호</td>
						<td><input type="text" value="<%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%>"></td>
					</tr>
					<tr>
						<td class="title">대표이사</td>
						<td><input type="text" value="<%=client.getClient_nm() %>"></td>
						<td class="title">법인등록번호</td>
						<td><input type="text" value="<%=client.getSsn1()%>-<%=client.getSsn2()%>"></td>
					</tr>
				</table>
			</div>			
			<br>
			<div style="margin-top:30px;">
				<div>
				<div style="margin-bottom:8px;font-weight:bold;display:inline-block;"> &nbsp;<span style="font-size:11pt;">※</span>임직원 전용 자동차보험 가입내역</div> 
				<%-- <div style="margin-bottom:8px;font-weight:bold;font-size:11pt;display:inline-block;float: right;"> [ 기준연도 : <%=base_year%> ]</div> --%> 
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
							<td><input style="width:30px" type="text" value="<%=i+1%>"></td>		
							<td><input style="width:70px" type="text" value="<%=ht.get("CAR_NO")%>"></td>		
							<td><input style="width:65px" type="text" value="<%=ht.get("CAR_NM")%>"></td>			
							<td><input style="width:85px" type="text" value="<%=ht.get("INS_COM_NM")%>"></td>		
							<td><input style="width:95px" type="text" value="<%=ht.get("INS_CON_NO")%>"></td>		
							<td><input style="width:225px" type="text" value="<%=ht.get("INS_START_DT")%>~<%=ht.get("INS_END_DT")%>"></td>		
						</tr>
						<%count++;%>	
    				<%} %>
    				
    				<%if(info_size < 10){%>
    					<%for(int i = 0 ; i < 10-info_size ; i++){%>
						<tr>
							<td><input type="text" value="" style="width:30px"></td>		
							<td><input type="text" value="" style="width:70px"></td>		
							<td><input type="text" value="" style="width:65px"></td>			
							<td><input type="text" value="" style="width:85px"></td>		
							<td><input type="text" value="" style="width:95px"></td>		
							<td><input type="text" value="" style="width:225px"></td>		
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
				<div style="position:relative;z-index:1;top:-60;margin-left:240px;"><img src="/acar/images/content/sign.gif" width="" height=""></div> 
			</div>
		</div>
	</div>
	</div>
	<%if(info_size > 10) {%>
	
	<%} %>
	<%if(info_size > 20) {%>
	<%} %>
</form>
</body>
<script>
	var fm = document.form1;	
	fm.pageWidth.value = document.body.scrollWidth;
	fm.pageHeight.value = document.body.scrollHeight;
	window.onload = function(){
		window.document.body.scroll = "auto";
	}


</script>
</head>
</html>
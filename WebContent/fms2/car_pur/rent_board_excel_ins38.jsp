<%//@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=rent_board_excel_ins38.xls");
%>
<%@ page import="java.util.*, acar.util.*, acar.cont.* "%>
<%@ include file="/acar/cookies.jsp" %>
<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");	
	String mod_st 	= request.getParameter("mod_st")==null?"":request.getParameter("mod_st");		
	
	Vector vt = ec_db.getRentBoardInsList("99", "렌트", gubun1, gubun2, st_dt, end_dt, mod_st);
	int vt_size = vt.size();
%>

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>FMS</title>
</head>
<body>

<table border="0" cellspacing="0" cellpadding="0" width='1340'>
    <tr>
        <td height="40" align="center" style="font-size : 20pt;"><b>공제조합신청서</b></td>
    </tr>
    <tr>
        <td align='right'>총건수 : <%=vt_size%>건</td>
    </tr>    
    <tr>
	<td height="25" style="font-size : 12pt;">귀사와 체결한 모든 자동차 보험 청약서에 자필서명(직인날인)을 하여야 하나 부득이한 사유로 인하여 하기건에 대해서는 본확인서로 대체하고자합니다.</td>
    </tr>    
    <tr> 
      <td height="10" align='center'></td>
    </tr>    
    <tr>
	<td height="25" style="font-size : 12pt;">귀사와 체결한 자동차 보험 청약서 상의 모든 조건을 인정하며 특히 하기 조건에 대하여 다시한번 확인하며 어떠한 이의도 제기하지 않을 것을 확인합니다.</td>
    </tr>    
    <tr>
	<td>&nbsp;</td>
    </tr>           
    <tr>
	<td align='right' height="50" style="font-size : 15pt;">
	    <table width="100%" border="0" cellspacing="1" cellpadding="0">
	        <tr>
	            <td width='860' >&nbsp;</td>
	            <td width='100' valign="top" >피공제자 : </td>
	            <td width='300' >서울시 영등포구 의사당대로 8,<br>
	                             802호 (여의도동, 까뮤이앤씨빌딩)<br><br>
	                             <span class=style6>(주)아마존카 대표이사 &nbsp;&nbsp;&nbsp;&nbsp;조 &nbsp;&nbsp;&nbsp;&nbsp;성 &nbsp;&nbsp;&nbsp;&nbsp;희
	            </td>
	            <td width='80' ><img src="http://fms1.amazoncar.co.kr/acar/images/stamp.png" width="75" height="75"></td>
	        </tr>
	    </table>
	</td>
    </tr>           
    <tr>
	<td>&nbsp;</td>
    </tr>                   
    <tr bgcolor="#000000">
        <td>
	    <table width="100%" border="1" cellspacing="1" cellpadding="0">
		<tr bgcolor="#A6FFFF" align="center"> 			        
			<td align='center' width='30' rowspan='2' style="font-size : 8pt;">연번</td>
			<td height="25" align='center' colspan='2' style="font-size : 8pt;">고객정보</td>
			<td align='center' colspan='4' style="font-size : 8pt;">차량정보</td>
			<td align='center' colspan='4' style="font-size : 8pt;">담보명세</td>
			<td align='center' colspan='3' style="font-size : 8pt;">블랙박스</td>
			
		</tr>					
		<tr bgcolor="#A6FFFF" align="center"> 								
			<td height="25" align='center' width="120" style="font-size : 8pt;">고객</td>
			<td align='center' width="100" style="font-size : 8pt;">사업자등록번호</td>			
			<td align='center' width='140' style="font-size : 8pt;">차명</td>				  
			<td align='center' width='80' style="font-size : 8pt;">차량번호</td>
			<td align='center' width='150' style="font-size : 8pt;">차대번호</td>
			<td align='center' width='100' style="font-size : 8pt;">차량소비자가</td>			
			<td align='center' width='80' style="font-size : 8pt;">운전자연령</td>
			<td align='center' width='80' style="font-size : 8pt;">대물배상</td>
			<td align='center' width='80' style="font-size : 8pt;">자기신체사고</td>
			<td align='center' width='100' style="font-size : 8pt;">임직원전용자동차보험</td>	
			<td align='center' width='100' style="font-size : 8pt;">블랙박스</td>
			<td align='center' width='80' style="font-size : 8pt;">가격(공급가)</td>
			<td align='center' width='100' style="font-size : 8pt;">시리얼번호</td>			
		</tr>					
		<%	if(vt_size > 0){%>
		<%		for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);
					
							String b_amt = String.valueOf(ht.get("B_AMT"));
							if(!String.valueOf(ht.get("B_MODEL_NM")).equals("") && AddUtil.parseDecimal(b_amt).equals("0")){
								b_amt = "92727";
							}
							String b_model_nm = String.valueOf(ht.get("B_COM_NM"))+"-"+String.valueOf(ht.get("B_MODEL_NM"));
							if(String.valueOf(ht.get("B_SERIAL_NO")).equals("") && AddUtil.parseDecimal(b_amt).equals("0")){
								b_model_nm = "";
							}
		%>
		<tr bgcolor="#FFFFFF" align="center">			        
			<td height="25" align='center' style="font-size : 8pt;"><%=i+1%></td>
			<td align='center' style="font-size : 8pt;"><%=ht.get("FIRM_NM")%></td>
			<td align='center' style="font-size : 8pt;"><%=AddUtil.ChangeEnpH(String.valueOf(ht.get("SSN")))%></td>
			<td align='center' style="font-size : 8pt;"><%=ht.get("CAR_NM")%>&nbsp;<%=ht.get("CAR_NAME")%></td>
			<td align='center' style="font-size : 8pt;"><%=ht.get("CAR_NO")%></td>
			<td align='center' style="font-size : 8pt;"><%=ht.get("CAR_NUM")%></td>
			<td align='right' style="font-size : 8pt;"><%=AddUtil.parseDecimal(String.valueOf(ht.get("TOT_AMT")))%></td>
			<td align='center' style="font-size : 8pt;"><%String driving_age = (String)ht.get("DRIVING_AGE");%><%if(driving_age.equals("0")){%>26세이상<%}else if(driving_age.equals("3")){%>24세이상<%}else if(driving_age.equals("1")){%>21세이상<%}else if(driving_age.equals("5")){%>30세이상<%}else if(driving_age.equals("6")){%>35세이상<%}else if(driving_age.equals("7")){%>43세이상<%}else if(driving_age.equals("8")){%>48세이상<%}else if(driving_age.equals("2")){%>모든운전자<%}%></td>			
			<td align='center' style="font-size : 8pt;"><%String gcp_kd = (String)ht.get("GCP_KD");%><%if(gcp_kd.equals("1")){%>5천만원<%}else if(gcp_kd.equals("2")){%>1억원<%}else if(gcp_kd.equals("3")){%>5억원<%}else if(gcp_kd.equals("4")){%>2억원<%}else if(gcp_kd.equals("8")){%>3억원<%}%></td>
			<td align='center' style="font-size : 8pt;"><%String bacdt_kd = (String)ht.get("BACDT_KD");%><%if(bacdt_kd.equals("1")){%>5천만원<%}else if(bacdt_kd.equals("2")){%>1억원<%}%></td>
			<td align='center' style="font-size : 8pt;"><%=ht.get("COM_EMP_YN")%></td>
			<td align='center' style="font-size : 8pt;"><%=b_model_nm%></td>
			<td align='right' style="font-size : 8pt;"><%=AddUtil.parseDecimal(b_amt)%></td>
			<td align='center' style="font-size : 8pt;"><%=ht.get("B_SERIAL_NO")%></td>
		</tr>
		<%		}%>
		<%	}%>                  
	    </table>
	</td>
    </tr>  		    		  
</table>
</body>
</html>


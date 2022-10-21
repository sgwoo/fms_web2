<%//@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=rent_board_excel3.xls");
%>

<%@ page import="java.util.*,acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>

<%
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	String mod_st = request.getParameter("mod_st")==null?"":request.getParameter("mod_st");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	Vector vt = ec_db.getRentBoardInsList(s_kd, t_wd, gubun1, gubun2, st_dt, end_dt, mod_st);
	int vt_size = vt.size();
%>

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
</head>
<body>
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/fms2/car_pur/pur_doc_frame.jsp'>
<table border="0" cellspacing="0" cellpadding="0" width='1650'>
	<tr>
		<td class='line' width='100%'>
			<table border="1" cellspacing="1" cellpadding="0" width='100%'>
			    <tr>					
					<td width='30' class='title'>연번</td>					
					<td width="100" class='title'>고객</td>
					<td width="110" class='title'>사업자등록번호</td>					
					<td width='50' class='title'>용도</td>
					<td width='50' class='title'>저공해스티커</td>
					<td width='50' class='title'>견인고리</td>
					<td width='90' class='title'>차명</td>				  					
					<td width='100' class='title'>등록예정일</td>					
					<td width='90' class='title'>차량번호</td>
					<td width='140' class='title'>차대번호</td>
					<td width='140' class='title'>차량소비자가</td>
					<td width='100' class='title'>보험계약자</td>
					<td width='100' class='title'>피보험자</td>
					<td width='100' class='title'>운전자연령</td>					
					<td width='100' class='title'>대물배상</td>					
					<td width='100' class='title'>블랙박스</td>
					<td width='100' class='title'>가격(공급가)</td>
					<td width='100' class='title'>시리얼번호</td>					
					<td width='100' class='title'>임직원전용자동차보험</td>
			  </tr>
			</table>
		</td>
	</tr>
<%
	if(vt_size > 0)
	{
%>
	<tr>
		<td class='line' width='100%'>
			<table border="1" cellspacing="1" cellpadding="0" width='100%'>
<%
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(i);
			
%>
				<tr>					
					<td  width='30' align='center'><%=i+1%></td>
					<td  width='100' align='center'><%=ht.get("FIRM_NM")%></td>
					<td  width='110' align='center'><%=AddUtil.ChangeEnpH(String.valueOf(ht.get("SSN")))%></td>						
					<td  width='50' align='center'><%if(String.valueOf(ht.get("CAR_ST")).equals("리스")){%><font color=red><%}%><%=ht.get("CAR_ST")%><%if(String.valueOf(ht.get("CAR_ST")).equals("리스")){%></font><%}%></td>
					<td  width='50' align='center'><%if(String.valueOf(ht.get("JG_G_16")).equals("1")){%><font color=red>[저공해]</font><%}%></td>
					<td  width='50' align='center'><%if(String.valueOf(ht.get("HOOK_YN")).equals("Y")){%><font color=red>[견인고리]</font><%}%></td>
					<td  width='90' align='center'><%=ht.get("CAR_NM")%>&nbsp;<%=ht.get("CAR_NAME")%></td>
					<td  width='100' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_EST_DT")))%></td>					
					<td  width='90' align='center'><%=ht.get("CAR_NO")%></td>
					<td  width='140' align='center'><%=ht.get("CAR_NUM")%></td>										
					<td  width='140' align='center'><%=ht.get("TOT_AMT")%></td>
					<td  width='100' align='center'><%=ht.get("INSURANT")%></td>
					<td  width='100' align='center'><%=ht.get("INSUR_PER")%></td>
					<td  width='100' align='center'>
						<%String driving_age = (String)ht.get("DRIVING_AGE");%><%if(driving_age.equals("0")){%>26세이상<%}else if(driving_age.equals("3")){%>24세이상<%}else if(driving_age.equals("1")){%>21세이상<%}else if(driving_age.equals("5")){%>30세이상<%}else if(driving_age.equals("6")){%>35세이상<%}else if(driving_age.equals("7")){%>43세이상<%}else if(driving_age.equals("8")){%>48세이상<%}else if(driving_age.equals("2")){%>모든운전자<%}%>
					</td>					
					<td  width='100' align='center'><%String gcp_kd = (String)ht.get("GCP_KD");%><%if(gcp_kd.equals("1")){%>5천만원<%}else if(gcp_kd.equals("2")){%>1억원<%}else if(gcp_kd.equals("3")){%>5억원<%}else if(gcp_kd.equals("4")){%>2억원<%}else if(gcp_kd.equals("8")){%>3억원<%}%></td>
					<td  width='100' align='center'>
					<%if(String.valueOf(ht.get("CAR_COMP_ID")).equals("0056")){%>
						내장형
					<%}else{%>
					<%=ht.get("B_COM_NM")%>-<%=ht.get("B_MODEL_NM")%>
					<%}%>
					</td>
					<td  width='100' align='right'>
					<%if(String.valueOf(ht.get("B_COM_NM")).equals("이노픽스") &&String.valueOf(ht.get("B_COM_NM")).equals("이노픽스") && (String.valueOf(ht.get("B_MODEL_NM")).equals("LX100") || String.valueOf(ht.get("B_MODEL_NM")).equals("IX200") || String.valueOf(ht.get("B_MODEL_NM")).equals("IX-200")) && AddUtil.parseDecimal(String.valueOf(ht.get("B_AMT"))).equals("0")){%>
						<%//if(AddUtil.parseInt(String.valueOf(ht.get("REG_EST_DT")).substring(0,8)) < 20160201){%>
						<!--104,545-->
						<%//}else{%>
						92,727
						<%//}%>
					<%}else{%>
					<%=AddUtil.parseDecimal(String.valueOf(ht.get("B_AMT")))%>
					<%}%>
					</td>
					<td  width='100' align='center'>
					<%if(String.valueOf(ht.get("CAR_COMP_ID")).equals("0056")){%>
						내장형
					<%}else{%>
						<%=ht.get("B_SERIAL_NO")%>
					<%}%>
					
					</td>										
					<td  width='100' align='center'><%=ht.get("COM_EMP_YN")%></td>										
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
		<td class='line' width='100%'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td align='center'>
					<%if(t_wd.equals("")){%>검색어를 입력하십시오.
					<%}else{%>등록된 데이타가 없습니다<%}%></td>
				</tr>
			</table>
		</td>
	</tr>
<%                     
	}                  
%>
</table>
</form>

<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=vt_size%>';
//-->
</script>
</body>
</html>


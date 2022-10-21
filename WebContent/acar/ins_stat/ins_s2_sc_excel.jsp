<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.insur.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename="+AddUtil.getDate(4)+"_ins_s2_sc_excel.xls");
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun0 = request.getParameter("gubun0")==null?"":request.getParameter("gubun0");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"3":request.getParameter("gubun6");	
	String gubun7 = request.getParameter("gubun7")==null?"":request.getParameter("gubun7");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");	
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	String mod_st = request.getParameter("mod_st")==null?"":request.getParameter("mod_st");
	
	if(!st_dt.equals("")) st_dt = AddUtil.replace(st_dt, "-", "");
	if(!end_dt.equals("")) end_dt = AddUtil.replace(end_dt, "-", "");
	
	
	InsEtcDatabase ie_db = InsEtcDatabase.getInstance();
	
	Vector inss = ie_db.getInsStatList1_excel(br_id, gubun1, gubun2, gubun3, gubun4, brch_id, st_dt, end_dt, s_kd, t_wd, sort, asc, s_st, mod_st);
	int ins_size = inss.size();
%>

<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='ins_size' value='<%=ins_size%>'>
<table border="0" cellspacing="0" cellpadding="0" width='2400'>
    <tr> 
        <td class=line> 
     		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    
                    <td width='50' class='title'>연번</td>				
                    <td width='100' class='title'>전보험사</td>
                    <td width='100' class='title'>가입보험사</td>
                    <td width='100' class='title'>시작일</td>
                    <td width='100' class='title'>차량번호</td>
                    <td width='150' class='title'>차대번호</td>					
                    <td width='150' class='title'>차명</td>
                    <td width='50' class='title'>차명코드</td>
                    <td width='100' class='title'>차종</td>					
                    <td width='50' class='title'>승차<br>정원</td>					
                    <td width='100' class='title'>최초등록일</td>										
                    <td width='50' class='title'>에어백</td>
					<td width='50' class='title'>자동<br>변속기</td>
					<td width='50' class='title'>ABS<br>장치</td>					
					<td width='50' class='title'>블랙<br>박스</td>					
                    <td width='50' class='title'>연령</td>
                    <td width='70' class='title'>대물</td>						
                    <td width='70' class='title'>자기신체<br>사망</td>						
                    <td width='70' class='title'>자기신체<br>부상</td>						
                    <td width='70' class='title'>자차</td>						
                    <td width='70' class='title'>무보험</td>						
                    <td width='70' class='title'>긴출</td>
                    <td width='100' class='title'>임직원전용자동차보험</td>												
                    <td width='130' class='title'>증권번호</td>						
                    <td width='150' class='title'>장기거래처</td>
					<td width='150' class='title'>사업자번호</td>
					<td width='150' class='title'>대여기간</td>
					<%if(gubun1.equals("2")) {%>
						<td width='150' class='title'>계약자</td>
						<td width='150' class='title'>피보험자</td>
						<td width='150' class='title'>관리담당자</td>
					<%}%>
                </tr>			
              <% 		for (int i = 0 ; i < ins_size ; i++){
    			Hashtable ins = (Hashtable)inss.elementAt(i);%>
                <tr> 
                    
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=i+1%></td>
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("INS_COM_NM")%></td>					
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'>&nbsp;</td>														
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align="center"><%=AddUtil.ChangeDate2(String.valueOf(ins.get("INS_EXP_DT")))%></td>					
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("CAR_NO")%></td>
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("CAR_NUM")%></td>					
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("CAR_NM")%> <%=ins.get("CAR_NAME")%></td>
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("JG_CODE")%></td>
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("CAR_KD")%></td>					
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("TAKING_P")%></td>					
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=AddUtil.ChangeDate2(String.valueOf(ins.get("INIT_REG_DT")))%></td>										
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("AIR")%></td>					
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("AUTO")%></td>										
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("ABS")%></td>															
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("BLACKBOX")%></td>															
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("AGE_SCP")%></td>					
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("VINS_GCP_KD")%></td>										
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("VINS_BACDT_KD")%></td>
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("VINS_BACDT_KC2")%></td>
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("VINS_CACDT2")%></td>
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("VINS_CANOISR2")%><!--N--></td>
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("VINS_SPE2")%></td>
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("COM_EMP_YN")%></td>
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'>&nbsp;</td>					
                    <td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("FIRM_NM")%></td>
		   			<td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("ENP_NO")%></td>
		    		<td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("RENT_START_DT")%>~<%=ins.get("RENT_END_DT")%></td>
		    		<%if(gubun1.equals("2")) {%>
			    		<td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("CONR_NM")%></td>
			   			<td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("CON_F_NM")%></td>
			   			<td <%if(ins.get("USE_YN").equals("N")){%>class='is'<%}%> align='center'><%=ins.get("USER_NM")%></td>
		   			<%}%>
                </tr>
              <%		}%>
            </table>
        </td>
    </tr>
</table>
<script language='javascript'>
<!--
//-->
</script>
</form>
</body>
</html>

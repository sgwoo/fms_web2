<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.condition.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	ConditionDatabase cdb = ConditionDatabase.getInstance();
	
	Vector vt = cdb.getRentCondStatList(gubun1, gubun2, gubun3, gubun4, gubun5, s_kd, t_wd);
	int vt_size = vt.size();
	
	String b_dt1 = "기준월";
	String b_dt2 = "전월";
	String b_dt3 = "전년";
	
	if(gubun3.equals("")){
		b_dt1 = "기준년";
		b_dt2 = "전년";
		b_dt3 = "전전년";
	}
%>	
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--

//-->
</script>
</head>
<body>
  <table border=0 cellspacing=0 cellpadding=0 width=1650>
<%	if(vt_size>0){
		Hashtable ht1 = (Hashtable)vt.elementAt(0);
		Hashtable ht2 = (Hashtable)vt.elementAt(1);
		Hashtable ht3 = (Hashtable)vt.elementAt(2);
%>  
    <tr>
	  <td class=line2 ></td>
	</tr>
    <tr>
      <td class=line>
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td colspan="2" rowspan="2" class='title'>구분</td>
            <td colspan="9" class='title'>계약기간</td>
            <td colspan="3" class='title'>관리구분</td>
            <td colspan="2" class='title'>계약고(VAT별도)</td>
          </tr>
          <tr>
            <td class='title' width="70">6개월미만</td>
            <td class='title' width="70">12개월미만</td>
            <td class='title' width="70">12개월</td>						
            <td class='title' width="70">24개월</td>
            <td class='title' width="75">36개월</td>
            <td class='title' width="75">48개월</td>
            <td class='title' width="70">60개월</td>
            <td class='title' width="70">기타</td>
            <td class='title' width="120">합계</td>
            <td class='title' width="100">일반식</td>
            <td class='title' width="100">기본식</td>
            <td class='title' width="120">합계</td>
            <td class='title' width="225">월대여료</td>
            <td class='title' width="225">총대여료</td>
          </tr>
          <tr>
            <td width='40' rowspan="3" class='title'>렌트</td>
            <td width='150' class='title'><%=b_dt1%>실적</td>
            <td align="center"><%=ht1.get("R_5")  %></td>
            <td align="center"><%=ht1.get("R_6")  %></td>
            <td align="center"><%=ht1.get("R_12")  %></td>
            <td align="center"><%=ht1.get("R_24")  %></td>
            <td align="center"><%=ht1.get("R_36")  %></td>
            <td align="center"><%=ht1.get("R_48")  %></td>
            <td align="center"><%=ht1.get("R_60")  %></td>
            <td align="center"><%=ht1.get("R_99")  %></td>
            <td align="center"><%=ht1.get("R_CONT")%></td>
            <td align="center"><%=ht1.get("R_S")   %></td>
            <td align="center"><%=ht1.get("R_B")   %></td>
            <td align="center"><%=ht1.get("R_CONT")%></td>
            <td align="center"><%=AddUtil.parseDecimal(AddUtil.parseLong(String.valueOf(ht1.get("R_MFEE"))))%></td>
            <td align="center"><%=AddUtil.parseDecimal(AddUtil.parseLong(String.valueOf(ht1.get("R_TFEE"))))%></td>
          </tr>
          <tr>
            <td class='title'><%=b_dt2%>실적/증감대수(%)</td>
            <td align="center"><%=ht2.get("R_5")   %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_5")))   -AddUtil.parseInt(String.valueOf(ht2.get("R_5")))   %>(<%=ht2.get("HR_5")   %>)</td>
            <td align="center"><%=ht2.get("R_6")   %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_6")))   -AddUtil.parseInt(String.valueOf(ht2.get("R_6")))   %>(<%=ht2.get("HR_6")   %>)</td>
            <td align="center"><%=ht2.get("R_12")  %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_12")))  -AddUtil.parseInt(String.valueOf(ht2.get("R_12")))  %>(<%=ht2.get("HR_12")  %>)</td>						
            <td align="center"><%=ht2.get("R_24")  %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_24")))  -AddUtil.parseInt(String.valueOf(ht2.get("R_24")))  %>(<%=ht2.get("HR_24")  %>)</td>
            <td align="center"><%=ht2.get("R_36")  %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_36")))  -AddUtil.parseInt(String.valueOf(ht2.get("R_36")))  %>(<%=ht2.get("HR_36")  %>)</td>
            <td align="center"><%=ht2.get("R_48")  %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_48")))  -AddUtil.parseInt(String.valueOf(ht2.get("R_48")))  %>(<%=ht2.get("HR_48")  %>)</td>
            <td align="center"><%=ht2.get("R_60")  %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_60")))  -AddUtil.parseInt(String.valueOf(ht2.get("R_60")))  %>(<%=ht2.get("HR_60")  %>)</td>
            <td align="center"><%=ht2.get("R_99")  %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_99")))  -AddUtil.parseInt(String.valueOf(ht2.get("R_99")))  %>(<%=ht2.get("HR_99")  %>)</td>
            <td align="center"><%=ht2.get("R_CONT")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_CONT")))-AddUtil.parseInt(String.valueOf(ht2.get("R_CONT")))%>(<%=ht2.get("HR_CONT")%>)</td>
            <td align="center"><%=ht2.get("R_S")   %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_S")))   -AddUtil.parseInt(String.valueOf(ht2.get("R_S")))   %>(<%=ht2.get("HR_S")   %>)</td>
            <td align="center"><%=ht2.get("R_B")   %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_B")))   -AddUtil.parseInt(String.valueOf(ht2.get("R_B")))   %>(<%=ht2.get("HR_B")   %>)</td>
            <td align="center"><%=ht2.get("R_CONT")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_CONT")))-AddUtil.parseInt(String.valueOf(ht2.get("R_CONT")))%>(<%=ht2.get("HR_CONT")%>)</td>
            <td align="center"><%=AddUtil.parseDecimal(AddUtil.parseLong(String.valueOf(ht2.get("R_MFEE"))))%>/<%=AddUtil.parseDecimal(AddUtil.parseLong(String.valueOf(ht1.get("R_MFEE")))-AddUtil.parseLong(String.valueOf(ht2.get("R_MFEE"))))%>(<%=ht2.get("HR_MFEE")%>)</td>
            <td align="center"><%=AddUtil.parseDecimal(AddUtil.parseLong(String.valueOf(ht2.get("R_TFEE"))))%>/<%=AddUtil.parseDecimal(AddUtil.parseLong(String.valueOf(ht1.get("R_TFEE")))-AddUtil.parseLong(String.valueOf(ht2.get("R_TFEE"))))%>(<%=ht2.get("HR_TFEE")%>)</td>
          </tr>
          <tr>
            <td class='title'><%=b_dt3%>실적/증감대수(%)</td>
            <td align="center"><%=ht3.get("R_5")   %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_5")))   -AddUtil.parseInt(String.valueOf(ht3.get("R_5")))   %>(<%=ht3.get("HR_5") 	%>)</td>
            <td align="center"><%=ht3.get("R_6")   %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_6")))   -AddUtil.parseInt(String.valueOf(ht3.get("R_6")))   %>(<%=ht3.get("HR_6") 	%>)</td>
            <td align="center"><%=ht3.get("R_12")  %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_12")))  -AddUtil.parseInt(String.valueOf(ht3.get("R_12")))  %>(<%=ht3.get("HR_12")	%>)</td>
            <td align="center"><%=ht3.get("R_24")  %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_24")))  -AddUtil.parseInt(String.valueOf(ht3.get("R_24")))  %>(<%=ht3.get("HR_24")	%>)</td>
            <td align="center"><%=ht3.get("R_36")  %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_36")))  -AddUtil.parseInt(String.valueOf(ht3.get("R_36")))  %>(<%=ht3.get("HR_36")	%>)</td>
            <td align="center"><%=ht3.get("R_48")  %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_48")))  -AddUtil.parseInt(String.valueOf(ht3.get("R_48")))  %>(<%=ht3.get("HR_48")	%>)</td>
            <td align="center"><%=ht3.get("R_60")  %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_60")))  -AddUtil.parseInt(String.valueOf(ht3.get("R_60")))  %>(<%=ht3.get("HR_60")	%>)</td>
            <td align="center"><%=ht3.get("R_99")  %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_99")))  -AddUtil.parseInt(String.valueOf(ht3.get("R_99")))  %>(<%=ht3.get("HR_99")	%>)</td>
            <td align="center"><%=ht3.get("R_CONT")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_CONT")))-AddUtil.parseInt(String.valueOf(ht3.get("R_CONT")))%>(<%=ht3.get("HR_CONT")%>)</td>
            <td align="center"><%=ht3.get("R_S")   %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_S")))   -AddUtil.parseInt(String.valueOf(ht3.get("R_S")))   %>(<%=ht3.get("HR_S")	%>)</td>
            <td align="center"><%=ht3.get("R_B")   %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_B")))   -AddUtil.parseInt(String.valueOf(ht3.get("R_B")))   %>(<%=ht3.get("HR_B")	%>)</td>
            <td align="center"><%=ht3.get("R_CONT")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_CONT")))-AddUtil.parseInt(String.valueOf(ht3.get("R_CONT")))%>(<%=ht3.get("HR_CONT")%>)</td>
            <td align="center"><%=AddUtil.parseDecimal(AddUtil.parseLong(String.valueOf(ht3.get("R_MFEE"))))%>/<%=AddUtil.parseDecimal(AddUtil.parseLong(String.valueOf(ht1.get("R_MFEE")))-AddUtil.parseLong(String.valueOf(ht3.get("R_MFEE"))))%>(<%=ht3.get("HR_MFEE")%>)</td>
            <td align="center"><%=AddUtil.parseDecimal(AddUtil.parseLong(String.valueOf(ht3.get("R_TFEE"))))%>/<%=AddUtil.parseDecimal(AddUtil.parseLong(String.valueOf(ht1.get("R_TFEE")))-AddUtil.parseLong(String.valueOf(ht3.get("R_TFEE"))))%>(<%=ht3.get("HR_TFEE")%>)</td>
          </tr>  
          <tr>
            <td rowspan="3" class='title'>리스</td>
            <td class='title'><%=b_dt1%>실적</td>
            <td align="center"><%=ht1.get("L_5")%></td>
            <td align="center"><%=ht1.get("L_6")%></td>
            <td align="center"><%=ht1.get("L_12")%></td>						
            <td align="center"><%=ht1.get("L_24")%></td>
            <td align="center"><%=ht1.get("L_36")%></td>
            <td align="center"><%=ht1.get("L_48")%></td>
            <td align="center"><%=ht1.get("L_60")%></td>
            <td align="center"><%=ht1.get("L_99")%></td>
            <td align="center"><%=ht1.get("L_CONT")%></td>
            <td align="center"><%=ht1.get("L_S")%></td>
            <td align="center"><%=ht1.get("L_B")%></td>
            <td align="center"><%=ht1.get("L_CONT")%></td>
            <td align="center"><%=AddUtil.parseDecimal(AddUtil.parseLong(String.valueOf(ht1.get("L_MFEE"))))%></td>
            <td align="center"><%=AddUtil.parseDecimal(AddUtil.parseLong(String.valueOf(ht1.get("L_TFEE"))))%></td>
          </tr>
          <tr>
            <td class='title'><%=b_dt2%>실적/증감대수(%)</td>
            <td align="center"><%=ht2.get("L_5")   %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_5")))   -AddUtil.parseInt(String.valueOf(ht2.get("L_5")))   %>(<%=ht2.get("HL_5")   %>)</td>
            <td align="center"><%=ht2.get("L_6")   %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_6")))   -AddUtil.parseInt(String.valueOf(ht2.get("L_6")))   %>(<%=ht2.get("HL_6")   %>)</td>
            <td align="center"><%=ht2.get("L_12")  %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_12")))  -AddUtil.parseInt(String.valueOf(ht2.get("L_12")))  %>(<%=ht2.get("HL_12")  %>)</td>						
            <td align="center"><%=ht2.get("L_24")  %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_24")))  -AddUtil.parseInt(String.valueOf(ht2.get("L_24")))  %>(<%=ht2.get("HL_24")  %>)</td>
            <td align="center"><%=ht2.get("L_36")  %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_36")))  -AddUtil.parseInt(String.valueOf(ht2.get("L_36")))  %>(<%=ht2.get("HL_36")  %>)</td>
            <td align="center"><%=ht2.get("L_48")  %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_48")))  -AddUtil.parseInt(String.valueOf(ht2.get("L_48")))  %>(<%=ht2.get("HL_48")  %>)</td>
            <td align="center"><%=ht2.get("L_60")  %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_60")))  -AddUtil.parseInt(String.valueOf(ht2.get("L_60")))  %>(<%=ht2.get("HL_60")  %>)</td>
            <td align="center"><%=ht2.get("L_99")  %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_99")))  -AddUtil.parseInt(String.valueOf(ht2.get("L_99")))  %>(<%=ht2.get("HL_99")  %>)</td>
            <td align="center"><%=ht2.get("L_CONT")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_CONT")))-AddUtil.parseInt(String.valueOf(ht2.get("L_CONT")))%>(<%=ht2.get("HL_CONT")%>)</td>
            <td align="center"><%=ht2.get("L_S")   %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_S")))   -AddUtil.parseInt(String.valueOf(ht2.get("L_S")))   %>(<%=ht2.get("HL_S")   %>)</td>
            <td align="center"><%=ht2.get("L_B")   %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_B")))   -AddUtil.parseInt(String.valueOf(ht2.get("L_B")))   %>(<%=ht2.get("HL_B")   %>)</td>
            <td align="center"><%=ht2.get("L_CONT")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_CONT")))-AddUtil.parseInt(String.valueOf(ht2.get("L_CONT")))%>(<%=ht2.get("HL_CONT")%>)</td>
            <td align="center"><%=AddUtil.parseDecimal(AddUtil.parseLong(String.valueOf(ht2.get("L_MFEE"))))%>/<%=AddUtil.parseDecimal(AddUtil.parseLong(String.valueOf(ht1.get("L_MFEE")))-AddUtil.parseLong(String.valueOf(ht2.get("L_MFEE"))))%>(<%=ht2.get("HL_MFEE")%>)</td>
            <td align="center"><%=AddUtil.parseDecimal(AddUtil.parseLong(String.valueOf(ht2.get("L_TFEE"))))%>/<%=AddUtil.parseDecimal(AddUtil.parseLong(String.valueOf(ht1.get("L_TFEE")))-AddUtil.parseLong(String.valueOf(ht2.get("L_TFEE"))))%>(<%=ht2.get("HL_TFEE")%>)</td>
          </tr>
          <tr>
            <td class='title'><%=b_dt3%>실적/증감대수(%)</td>
            <td align="center"><%=ht3.get("L_5")   %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_5")))   -AddUtil.parseInt(String.valueOf(ht3.get("L_5")))   %>(<%=ht3.get("HL_5")	%>)</td>
            <td align="center"><%=ht3.get("L_6")   %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_6")))   -AddUtil.parseInt(String.valueOf(ht3.get("L_6")))   %>(<%=ht3.get("HL_6")	%>)</td>
            <td align="center"><%=ht3.get("L_12")  %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_12")))  -AddUtil.parseInt(String.valueOf(ht3.get("L_12")))  %>(<%=ht3.get("HL_12")	%>)</td>						
            <td align="center"><%=ht3.get("L_24")  %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_24")))  -AddUtil.parseInt(String.valueOf(ht3.get("L_24")))  %>(<%=ht3.get("HL_24")	%>)</td>
            <td align="center"><%=ht3.get("L_36")  %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_36")))  -AddUtil.parseInt(String.valueOf(ht3.get("L_36")))  %>(<%=ht3.get("HL_36")	%>)</td>
            <td align="center"><%=ht3.get("L_48")  %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_48")))  -AddUtil.parseInt(String.valueOf(ht3.get("L_48")))  %>(<%=ht3.get("HL_48")	%>)</td>
            <td align="center"><%=ht3.get("L_60")  %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_60")))  -AddUtil.parseInt(String.valueOf(ht3.get("L_60")))  %>(<%=ht3.get("HL_60")	%>)</td>
            <td align="center"><%=ht3.get("L_99")  %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_99")))  -AddUtil.parseInt(String.valueOf(ht3.get("L_99")))  %>(<%=ht3.get("HL_99")	%>)</td>
            <td align="center"><%=ht3.get("L_CONT")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_CONT")))-AddUtil.parseInt(String.valueOf(ht3.get("L_CONT")))%>(<%=ht3.get("HL_CONT")%>)</td>
            <td align="center"><%=ht3.get("L_S")   %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_S")))   -AddUtil.parseInt(String.valueOf(ht3.get("L_S")))   %>(<%=ht3.get("HL_S")	%>)</td>
            <td align="center"><%=ht3.get("L_B")   %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_B")))   -AddUtil.parseInt(String.valueOf(ht3.get("L_B")))   %>(<%=ht3.get("HL_B")	%>)</td>
            <td align="center"><%=ht3.get("L_CONT")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_CONT")))-AddUtil.parseInt(String.valueOf(ht3.get("L_CONT")))%>(<%=ht3.get("HL_CONT")%>)</td>
            <td align="center"><%=AddUtil.parseDecimal(AddUtil.parseLong(String.valueOf(ht3.get("L_MFEE"))))%>/<%=AddUtil.parseDecimal(AddUtil.parseLong(String.valueOf(ht1.get("L_MFEE")))-AddUtil.parseLong(String.valueOf(ht3.get("L_MFEE"))))%>(<%=ht3.get("HL_MFEE")%>)</td>
            <td align="center"><%=AddUtil.parseDecimal(AddUtil.parseLong(String.valueOf(ht3.get("L_TFEE"))))%>/<%=AddUtil.parseDecimal(AddUtil.parseLong(String.valueOf(ht1.get("L_TFEE")))-AddUtil.parseLong(String.valueOf(ht3.get("L_TFEE"))))%>(<%=ht3.get("HL_TFEE")%>)</td>
          </tr>  
          <tr>
            <td rowspan="3" class='title'>합계</td>
            <td class='title'><%=b_dt1%>실적</td>
            <td align="center"><%=ht1.get("T_5")%></td>
            <td align="center"><%=ht1.get("T_6")%></td>
            <td align="center"><%=ht1.get("T_12")%></td>						
            <td align="center"><%=ht1.get("T_24")%></td>
            <td align="center"><%=ht1.get("T_36")%></td>
            <td align="center"><%=ht1.get("T_48")%></td>
            <td align="center"><%=ht1.get("T_60")%></td>
            <td align="center"><%=ht1.get("T_99")%></td>
            <td align="center"><%=ht1.get("T_CONT")%></td>
            <td align="center"><%=ht1.get("T_S")%></td>
            <td align="center"><%=ht1.get("T_B")%></td>
            <td align="center"><%=ht1.get("T_CONT")%></td>
            <td align="center"><%=AddUtil.parseDecimal(AddUtil.parseLong(String.valueOf(ht1.get("T_MFEE"))))%></td>
            <td align="center"><%=AddUtil.parseDecimal(AddUtil.parseLong(String.valueOf(ht1.get("T_TFEE"))))%></td>
          </tr>
          <tr>
            <td class='title'><%=b_dt2%>실적/증감대수(%)</td>
            <td align="center"><%=ht2.get("T_5")   %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_5")))   -AddUtil.parseInt(String.valueOf(ht2.get("T_5")))   %>(<%if(String.valueOf(ht2.get("T_5")).equals("0")||String.valueOf(ht1.get("T_5")).equals("0")){  %>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_5")))/AddUtil.parseFloat(String.valueOf(ht2.get("T_5")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht2.get("T_6")   %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_6")))   -AddUtil.parseInt(String.valueOf(ht2.get("T_6")))   %>(<%if(String.valueOf(ht2.get("T_6")).equals("0")||String.valueOf(ht1.get("T_6")).equals("0")){  %>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_6")))/AddUtil.parseFloat(String.valueOf(ht2.get("T_6")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht2.get("T_12")  %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_12")))  -AddUtil.parseInt(String.valueOf(ht2.get("T_12")))  %>(<%if(String.valueOf(ht2.get("T_12")).equals("0")||String.valueOf(ht1.get("T_12")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_12")))/AddUtil.parseFloat(String.valueOf(ht2.get("T_12")))*100,0)%><%}%>)</td>						
            <td align="center"><%=ht2.get("T_24")  %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_24")))  -AddUtil.parseInt(String.valueOf(ht2.get("T_24")))  %>(<%if(String.valueOf(ht2.get("T_24")).equals("0")||String.valueOf(ht1.get("T_24")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_24")))/AddUtil.parseFloat(String.valueOf(ht2.get("T_24")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht2.get("T_36")  %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_36")))  -AddUtil.parseInt(String.valueOf(ht2.get("T_36")))  %>(<%if(String.valueOf(ht2.get("T_36")).equals("0")||String.valueOf(ht1.get("T_36")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_36")))/AddUtil.parseFloat(String.valueOf(ht2.get("T_36")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht2.get("T_48")  %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_48")))  -AddUtil.parseInt(String.valueOf(ht2.get("T_48")))  %>(<%if(String.valueOf(ht2.get("T_48")).equals("0")||String.valueOf(ht1.get("T_48")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_48")))/AddUtil.parseFloat(String.valueOf(ht2.get("T_48")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht2.get("T_60")  %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_60")))  -AddUtil.parseInt(String.valueOf(ht2.get("T_60")))  %>(<%if(String.valueOf(ht2.get("T_60")).equals("0")||String.valueOf(ht1.get("T_60")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_60")))/AddUtil.parseFloat(String.valueOf(ht2.get("T_60")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht2.get("T_99")  %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_99")))  -AddUtil.parseInt(String.valueOf(ht2.get("T_99")))  %>(<%if(String.valueOf(ht2.get("T_99")).equals("0")||String.valueOf(ht1.get("T_99")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_99")))/AddUtil.parseFloat(String.valueOf(ht2.get("T_99")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht2.get("T_CONT")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_CONT")))-AddUtil.parseInt(String.valueOf(ht2.get("T_CONT")))%>(<%if(String.valueOf(ht2.get("T_CONT")).equals("0")||String.valueOf(ht1.get("T_CONT")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_CONT")))/AddUtil.parseFloat(String.valueOf(ht2.get("T_CONT")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht2.get("T_S")   %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_S")))   -AddUtil.parseInt(String.valueOf(ht2.get("T_S")))   %>(<%if(String.valueOf(ht2.get("T_S")).equals("0")||String.valueOf(ht1.get("T_S")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_S")))/AddUtil.parseFloat(String.valueOf(ht2.get("T_S")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht2.get("T_B")   %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_B")))   -AddUtil.parseInt(String.valueOf(ht2.get("T_B")))   %>(<%if(String.valueOf(ht2.get("T_B")).equals("0")||String.valueOf(ht1.get("T_B")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_B")))/AddUtil.parseFloat(String.valueOf(ht2.get("T_B")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht2.get("T_CONT")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_CONT")))-AddUtil.parseInt(String.valueOf(ht2.get("T_CONT")))%>(<%if(String.valueOf(ht2.get("T_CONT")).equals("0")||String.valueOf(ht1.get("T_CONT")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_CONT")))/AddUtil.parseFloat(String.valueOf(ht2.get("T_CONT")))*100,0)%><%}%>)</td>
            <td align="center"><%=AddUtil.parseDecimal(AddUtil.parseLong(String.valueOf(ht2.get("T_MFEE"))))%>/<%=AddUtil.parseDecimal(AddUtil.parseLong(String.valueOf(ht1.get("T_MFEE")))-AddUtil.parseLong(String.valueOf(ht2.get("T_MFEE"))))%>(<%if(String.valueOf(ht2.get("T_MFEE")).equals("0")||String.valueOf(ht1.get("T_MFEE")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_MFEE")))/AddUtil.parseFloat(String.valueOf(ht2.get("T_MFEE")))*100,0)%><%}%>)</td>
            <td align="center"><%=AddUtil.parseDecimal(AddUtil.parseLong(String.valueOf(ht2.get("T_TFEE"))))%>/<%=AddUtil.parseDecimal(AddUtil.parseLong(String.valueOf(ht1.get("T_TFEE")))-AddUtil.parseLong(String.valueOf(ht2.get("T_TFEE"))))%>(<%if(String.valueOf(ht2.get("T_TFEE")).equals("0")||String.valueOf(ht1.get("T_TFEE")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_TFEE")))/AddUtil.parseFloat(String.valueOf(ht2.get("T_TFEE")))*100,0)%><%}%>)</td>
          </tr>
          <tr>
            <td class='title'><%=b_dt3%>실적/증감대수(%)</td>
            <td align="center"><%=ht3.get("T_5")   %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_5")))   -AddUtil.parseInt(String.valueOf(ht3.get("T_5")))   %>(<%if(String.valueOf(ht3.get("T_5")).equals("0")||String.valueOf(ht1.get("T_5")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_5")))/AddUtil.parseFloat(String.valueOf(ht3.get("T_5")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht3.get("T_6")   %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_6")))   -AddUtil.parseInt(String.valueOf(ht3.get("T_6")))   %>(<%if(String.valueOf(ht3.get("T_6")).equals("0")||String.valueOf(ht1.get("T_6")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_6")))/AddUtil.parseFloat(String.valueOf(ht3.get("T_6")))*100,0)%><%}%>)</td>			
            <td align="center"><%=ht3.get("T_12")  %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_12")))  -AddUtil.parseInt(String.valueOf(ht3.get("T_12")))  %>(<%if(String.valueOf(ht3.get("T_12")).equals("0")||String.valueOf(ht1.get("T_12")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_12")))/AddUtil.parseFloat(String.valueOf(ht3.get("T_12")))*100,0)%><%}%>)</td>						
            <td align="center"><%=ht3.get("T_24")  %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_24")))  -AddUtil.parseInt(String.valueOf(ht3.get("T_24")))  %>(<%if(String.valueOf(ht3.get("T_24")).equals("0")||String.valueOf(ht1.get("T_24")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_24")))/AddUtil.parseFloat(String.valueOf(ht3.get("T_24")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht3.get("T_36")  %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_36")))  -AddUtil.parseInt(String.valueOf(ht3.get("T_36")))  %>(<%if(String.valueOf(ht3.get("T_36")).equals("0")||String.valueOf(ht1.get("T_36")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_36")))/AddUtil.parseFloat(String.valueOf(ht3.get("T_36")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht3.get("T_48")  %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_48")))  -AddUtil.parseInt(String.valueOf(ht3.get("T_48")))  %>(<%if(String.valueOf(ht3.get("T_48")).equals("0")||String.valueOf(ht1.get("T_48")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_48")))/AddUtil.parseFloat(String.valueOf(ht3.get("T_48")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht3.get("T_60")  %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_60")))  -AddUtil.parseInt(String.valueOf(ht3.get("T_60")))  %>(<%if(String.valueOf(ht3.get("T_60")).equals("0")||String.valueOf(ht1.get("T_60")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_60")))/AddUtil.parseFloat(String.valueOf(ht3.get("T_60")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht3.get("T_99")  %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_99")))  -AddUtil.parseInt(String.valueOf(ht3.get("T_99")))  %>(<%if(String.valueOf(ht3.get("T_99")).equals("0")||String.valueOf(ht1.get("T_99")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_99")))/AddUtil.parseFloat(String.valueOf(ht3.get("T_99")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht3.get("T_CONT")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_CONT")))-AddUtil.parseInt(String.valueOf(ht3.get("T_CONT")))%>(<%if(String.valueOf(ht3.get("T_CONT")).equals("0")||String.valueOf(ht1.get("T_CONT")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_CONT")))/AddUtil.parseFloat(String.valueOf(ht3.get("T_CONT")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht3.get("T_S")   %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_S")))   -AddUtil.parseInt(String.valueOf(ht3.get("T_S")))   %>(<%if(String.valueOf(ht3.get("T_S")).equals("0")||String.valueOf(ht1.get("T_S")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_S")))/AddUtil.parseFloat(String.valueOf(ht3.get("T_S")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht3.get("T_B")   %>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_B")))   -AddUtil.parseInt(String.valueOf(ht3.get("T_B")))   %>(<%if(String.valueOf(ht3.get("T_B")).equals("0")||String.valueOf(ht1.get("T_B")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_B")))/AddUtil.parseFloat(String.valueOf(ht3.get("T_B")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht3.get("T_CONT")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_CONT")))-AddUtil.parseInt(String.valueOf(ht3.get("T_CONT")))%>(<%if(String.valueOf(ht3.get("T_CONT")).equals("0")||String.valueOf(ht1.get("T_CONT")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_CONT")))/AddUtil.parseFloat(String.valueOf(ht3.get("T_CONT")))*100,0)%><%}%>)</td>
            <td align="center"><%=AddUtil.parseDecimal(AddUtil.parseLong(String.valueOf(ht3.get("T_MFEE"))))%>/<%=AddUtil.parseDecimal(AddUtil.parseLong(String.valueOf(ht1.get("T_MFEE")))-AddUtil.parseLong(String.valueOf(ht3.get("T_MFEE"))))%>(<%if(String.valueOf(ht3.get("T_MFEE")).equals("0")||String.valueOf(ht1.get("T_MFEE")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_MFEE")))/AddUtil.parseFloat(String.valueOf(ht3.get("T_MFEE")))*100,0)%><%}%>)</td>
            <td align="center"><%=AddUtil.parseDecimal(AddUtil.parseLong(String.valueOf(ht3.get("T_TFEE"))))%>/<%=AddUtil.parseDecimal(AddUtil.parseLong(String.valueOf(ht1.get("T_TFEE")))-AddUtil.parseLong(String.valueOf(ht3.get("T_TFEE"))))%>(<%if(String.valueOf(ht3.get("T_TFEE")).equals("0")||String.valueOf(ht1.get("T_TFEE")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_TFEE")))/AddUtil.parseFloat(String.valueOf(ht3.get("T_TFEE")))*100,0)%><%}%>)</td>
          </tr>  		  
		</table>
	  </td>
    </tr>	
    <tr>
	  <td>&nbsp;</td>
	</tr>	
    <tr>
	  <td class=line2 ></td>
	</tr>
    <tr>
      <td class=line>
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td colspan="2" rowspan="2" class='title'>구분</td>
            <td colspan="7" class='title'>자력영업</td>
            <td colspan="4" class='title'>영업사원</td>
            <td colspan="4" class='title'>에이젼트</td>
            <td width="110" rowspan="2" class='title'>합계</td>
          </tr>
          <tr>
            <td class='title' width="90">기존업체</td>
            <td class='title' width="90">업체소개</td>
            <td class='title' width="90">인터넷</td>
            <td class='title' width="90">모바일</td>
            <td class='title' width="90">전화상담</td>
            <td class='title' width="90">기타</td>
            <td class='title' width="90">소계</td>
            <td class='title' width="90">신규</td>
            <td class='title' width="90">증차</td>
            <td class='title' width="90">대차</td>
            <td class='title' width="90">소계</td>
            <td class='title' width="90">신규</td>
            <td class='title' width="90">증차</td>
            <td class='title' width="90">대차</td>
            <td class='title' width="90">소계</td>
          </tr>
		  <%
		  		String r_bus71 = String.valueOf( AddUtil.parseInt(String.valueOf(ht1.get("RB_CONT"))) - AddUtil.parseInt(String.valueOf(ht1.get("R_BUS6"))) - AddUtil.parseInt(String.valueOf(ht1.get("R_BUS7"))) );
				String r_bus72 = String.valueOf( AddUtil.parseInt(String.valueOf(ht2.get("RB_CONT"))) - AddUtil.parseInt(String.valueOf(ht2.get("R_BUS6"))) - AddUtil.parseInt(String.valueOf(ht2.get("R_BUS7"))) );
				String r_bus73 = String.valueOf( AddUtil.parseInt(String.valueOf(ht3.get("RB_CONT"))) - AddUtil.parseInt(String.valueOf(ht3.get("R_BUS6"))) - AddUtil.parseInt(String.valueOf(ht3.get("R_BUS7"))) );
		  		String l_bus71 = String.valueOf( AddUtil.parseInt(String.valueOf(ht1.get("LB_CONT"))) - AddUtil.parseInt(String.valueOf(ht1.get("L_BUS6"))) - AddUtil.parseInt(String.valueOf(ht1.get("L_BUS7"))) );
				String l_bus72 = String.valueOf( AddUtil.parseInt(String.valueOf(ht2.get("LB_CONT"))) - AddUtil.parseInt(String.valueOf(ht2.get("L_BUS6"))) - AddUtil.parseInt(String.valueOf(ht2.get("L_BUS7"))) );
				String l_bus73 = String.valueOf( AddUtil.parseInt(String.valueOf(ht3.get("LB_CONT"))) - AddUtil.parseInt(String.valueOf(ht3.get("L_BUS6"))) - AddUtil.parseInt(String.valueOf(ht3.get("L_BUS7"))) );
		  		String t_bus71 = String.valueOf( AddUtil.parseInt(String.valueOf(ht1.get("TB_CONT"))) - AddUtil.parseInt(String.valueOf(ht1.get("T_BUS6"))) - AddUtil.parseInt(String.valueOf(ht1.get("T_BUS7"))) );
				String t_bus72 = String.valueOf( AddUtil.parseInt(String.valueOf(ht2.get("TB_CONT"))) - AddUtil.parseInt(String.valueOf(ht2.get("T_BUS6"))) - AddUtil.parseInt(String.valueOf(ht2.get("T_BUS7"))) );
				String t_bus73 = String.valueOf( AddUtil.parseInt(String.valueOf(ht3.get("TB_CONT"))) - AddUtil.parseInt(String.valueOf(ht3.get("T_BUS6"))) - AddUtil.parseInt(String.valueOf(ht3.get("T_BUS7"))) );
		  %>
          <tr>
            <td width='40' rowspan="3" class='title'>렌트</td>
            <td width='150' class='title'><%=b_dt1%>실적</td>
            <td align="center"><%=ht1.get("R_BUS1")%></td>
            <td align="center"><%=ht1.get("R_BUS2")%></td>
            <td align="center"><%=ht1.get("R_BUS3")%></td>
            <td align="center"><%=ht1.get("R_BUS9")%></td>
            <td align="center"><%=ht1.get("R_BUS4")%></td>
            <td align="center"><%=ht1.get("R_BUS5")%></td>
            <td align="center"><%=r_bus71%></td>
            <td align="center"><%=ht1.get("R_BUS61")%></td>
            <td align="center"><%=ht1.get("R_BUS62")%></td>
            <td align="center"><%=ht1.get("R_BUS63")%></td>			
            <td align="center"><%=ht1.get("R_BUS6")%></td>
            <td align="center"><%=ht1.get("R_BUS71")%></td>
            <td align="center"><%=ht1.get("R_BUS72")%></td>
            <td align="center"><%=ht1.get("R_BUS73")%></td>			
            <td align="center"><%=ht1.get("R_BUS7")%></td>
            <td align="center"><%=ht1.get("RB_CONT")%></td>
          </tr>
          <tr>
            <td class='title'><%=b_dt2%>실적/증감대수(%)</td>
            <td align="center"><%=ht2.get("R_BUS1")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_BUS1")))-AddUtil.parseInt(String.valueOf(ht2.get("R_BUS1")))%>(<%=ht2.get("HR_BUS1")%>)</td>
            <td align="center"><%=ht2.get("R_BUS2")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_BUS2")))-AddUtil.parseInt(String.valueOf(ht2.get("R_BUS2")))%>(<%=ht2.get("HR_BUS2")%>)</td>
            <td align="center"><%=ht2.get("R_BUS3")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_BUS3")))-AddUtil.parseInt(String.valueOf(ht2.get("R_BUS3")))%>(<%=ht2.get("HR_BUS3")%>)</td>
            <td align="center"><%=ht2.get("R_BUS9")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_BUS9")))-AddUtil.parseInt(String.valueOf(ht2.get("R_BUS9")))%>(<%=ht2.get("HR_BUS9")%>)</td>
            <td align="center"><%=ht2.get("R_BUS4")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_BUS4")))-AddUtil.parseInt(String.valueOf(ht2.get("R_BUS4")))%>(<%=ht2.get("HR_BUS4")%>)</td>
            <td align="center"><%=ht2.get("R_BUS5")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_BUS5")))-AddUtil.parseInt(String.valueOf(ht2.get("R_BUS5")))%>(<%=ht2.get("HR_BUS5")%>)</td>
            <td align="center"><%=r_bus72%>/<%=AddUtil.parseInt(r_bus71)-AddUtil.parseInt(r_bus72)%>(<%if(r_bus71.equals("0")||r_bus72.equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(r_bus71)/AddUtil.parseFloat(r_bus72)*100,0)%><%}%>)</td>
            <td align="center"><%=ht2.get("R_BUS61")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_BUS61")))-AddUtil.parseInt(String.valueOf(ht2.get("R_BUS61")))%>(<%=ht2.get("HR_BUS61")%>)</td>
            <td align="center"><%=ht2.get("R_BUS62")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_BUS62")))-AddUtil.parseInt(String.valueOf(ht2.get("R_BUS62")))%>(<%=ht2.get("HR_BUS62")%>)</td>
            <td align="center"><%=ht2.get("R_BUS63")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_BUS63")))-AddUtil.parseInt(String.valueOf(ht2.get("R_BUS63")))%>(<%=ht2.get("HR_BUS63")%>)</td>
            <td align="center"><%=ht2.get("R_BUS6")%> /<%=AddUtil.parseInt(String.valueOf(ht1.get("R_BUS6"))) -AddUtil.parseInt(String.valueOf(ht2.get("R_BUS6")))%> (<%=ht2.get("HR_BUS6")%>)</td>									
            <td align="center"><%=ht2.get("R_BUS71")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_BUS71")))-AddUtil.parseInt(String.valueOf(ht2.get("R_BUS71")))%>(<%=ht2.get("HR_BUS71")%>)</td>
            <td align="center"><%=ht2.get("R_BUS72")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_BUS72")))-AddUtil.parseInt(String.valueOf(ht2.get("R_BUS72")))%>(<%=ht2.get("HR_BUS72")%>)</td>
            <td align="center"><%=ht2.get("R_BUS73")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_BUS73")))-AddUtil.parseInt(String.valueOf(ht2.get("R_BUS73")))%>(<%=ht2.get("HR_BUS73")%>)</td>
            <td align="center"><%=ht2.get("R_BUS7")%> /<%=AddUtil.parseInt(String.valueOf(ht1.get("R_BUS7"))) -AddUtil.parseInt(String.valueOf(ht2.get("R_BUS7")))%> (<%=ht2.get("HR_BUS7")%>)</td>									
            <td align="center"><%=ht2.get("RB_CONT")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("RB_CONT")))-AddUtil.parseInt(String.valueOf(ht2.get("RB_CONT")))%>(<%=ht2.get("HR_CONT")%>)</td>
          </tr>
          <tr>
            <td class='title'><%=b_dt3%>실적/증감대수(%)</td>
            <td align="center"><%=ht3.get("R_BUS1")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_BUS1")))-AddUtil.parseInt(String.valueOf(ht3.get("R_BUS1")))%>(<%=ht3.get("HR_BUS1")%>)</td>
            <td align="center"><%=ht3.get("R_BUS2")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_BUS2")))-AddUtil.parseInt(String.valueOf(ht3.get("R_BUS2")))%>(<%=ht3.get("HR_BUS2")%>)</td>
            <td align="center"><%=ht3.get("R_BUS3")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_BUS3")))-AddUtil.parseInt(String.valueOf(ht3.get("R_BUS3")))%>(<%=ht3.get("HR_BUS3")%>)</td>
            <td align="center"><%=ht3.get("R_BUS9")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_BUS9")))-AddUtil.parseInt(String.valueOf(ht3.get("R_BUS9")))%>(<%=ht3.get("HR_BUS9")%>)</td>
            <td align="center"><%=ht3.get("R_BUS4")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_BUS4")))-AddUtil.parseInt(String.valueOf(ht3.get("R_BUS4")))%>(<%=ht3.get("HR_BUS4")%>)</td>
            <td align="center"><%=ht3.get("R_BUS5")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_BUS5")))-AddUtil.parseInt(String.valueOf(ht3.get("R_BUS5")))%>(<%=ht3.get("HR_BUS5")%>)</td>
            <td align="center"><%=r_bus73%>/<%=AddUtil.parseInt(r_bus71)-AddUtil.parseInt(r_bus73)%>(<%if(r_bus71.equals("0")||r_bus73.equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(r_bus71)/AddUtil.parseFloat(r_bus73)*100,0)%><%}%>)</td>
            <td align="center"><%=ht3.get("R_BUS61")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_BUS61")))-AddUtil.parseInt(String.valueOf(ht3.get("R_BUS61")))%>(<%=ht3.get("HR_BUS61")%>)</td>
            <td align="center"><%=ht3.get("R_BUS62")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_BUS62")))-AddUtil.parseInt(String.valueOf(ht3.get("R_BUS62")))%>(<%=ht3.get("HR_BUS62")%>)</td>
            <td align="center"><%=ht3.get("R_BUS63")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_BUS63")))-AddUtil.parseInt(String.valueOf(ht3.get("R_BUS63")))%>(<%=ht3.get("HR_BUS63")%>)</td>
            <td align="center"><%=ht3.get("R_BUS6")%> /<%=AddUtil.parseInt(String.valueOf(ht1.get("R_BUS6"))) -AddUtil.parseInt(String.valueOf(ht3.get("R_BUS6")))%> (<%=ht3.get("HR_BUS6")%>)</td>									
            <td align="center"><%=ht3.get("R_BUS71")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_BUS71")))-AddUtil.parseInt(String.valueOf(ht3.get("R_BUS71")))%>(<%=ht3.get("HR_BUS71")%>)</td>
            <td align="center"><%=ht3.get("R_BUS72")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_BUS72")))-AddUtil.parseInt(String.valueOf(ht3.get("R_BUS72")))%>(<%=ht3.get("HR_BUS72")%>)</td>
            <td align="center"><%=ht3.get("R_BUS73")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_BUS73")))-AddUtil.parseInt(String.valueOf(ht3.get("R_BUS73")))%>(<%=ht3.get("HR_BUS73")%>)</td>
            <td align="center"><%=ht3.get("R_BUS7")%> /<%=AddUtil.parseInt(String.valueOf(ht1.get("R_BUS7"))) -AddUtil.parseInt(String.valueOf(ht3.get("R_BUS7")))%> (<%=ht3.get("HR_BUS7")%>)</td>									
            <td align="center"><%=ht3.get("RB_CONT")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("RB_CONT")))-AddUtil.parseInt(String.valueOf(ht3.get("RB_CONT")))%>(<%=ht3.get("HR_CONT")%>)</td>
          </tr>  
          <tr>
            <td rowspan="3" class='title'>리스</td>
            <td class='title'><%=b_dt1%>실적</td>
            <td align="center"><%=ht1.get("L_BUS1")%></td>
            <td align="center"><%=ht1.get("L_BUS2")%></td>
            <td align="center"><%=ht1.get("L_BUS3")%></td>
            <td align="center"><%=ht1.get("L_BUS9")%></td>
            <td align="center"><%=ht1.get("L_BUS4")%></td>
            <td align="center"><%=ht1.get("L_BUS5")%></td>
            <td align="center"><%=l_bus71%></td>
            <td align="center"><%=ht1.get("L_BUS61")%></td>
            <td align="center"><%=ht1.get("L_BUS62")%></td>
            <td align="center"><%=ht1.get("L_BUS63")%></td>
            <td align="center"><%=ht1.get("L_BUS6")%></td>									
            <td align="center"><%=ht1.get("L_BUS71")%></td>
            <td align="center"><%=ht1.get("L_BUS72")%></td>
            <td align="center"><%=ht1.get("L_BUS73")%></td>
            <td align="center"><%=ht1.get("L_BUS7")%></td>									
            <td align="center"><%=ht1.get("LB_CONT")%></td>
          </tr>
          <tr>
            <td class='title'><%=b_dt2%>실적/증감대수(%)</td>
            <td align="center"><%=ht2.get("L_BUS1")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_BUS1")))-AddUtil.parseInt(String.valueOf(ht2.get("L_BUS1")))%>(<%=ht2.get("HL_BUS1")%>)</td>
            <td align="center"><%=ht2.get("L_BUS2")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_BUS2")))-AddUtil.parseInt(String.valueOf(ht2.get("L_BUS2")))%>(<%=ht2.get("HL_BUS2")%>)</td>
            <td align="center"><%=ht2.get("L_BUS3")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_BUS3")))-AddUtil.parseInt(String.valueOf(ht2.get("L_BUS3")))%>(<%=ht2.get("HL_BUS3")%>)</td>
            <td align="center"><%=ht2.get("L_BUS9")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_BUS9")))-AddUtil.parseInt(String.valueOf(ht2.get("L_BUS9")))%>(<%=ht2.get("HL_BUS9")%>)</td>
            <td align="center"><%=ht2.get("L_BUS4")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_BUS4")))-AddUtil.parseInt(String.valueOf(ht2.get("L_BUS4")))%>(<%=ht2.get("HL_BUS4")%>)</td>
            <td align="center"><%=ht2.get("L_BUS5")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_BUS5")))-AddUtil.parseInt(String.valueOf(ht2.get("L_BUS5")))%>(<%=ht2.get("HL_BUS5")%>)</td>
            <td align="center"><%=l_bus72%>/<%=AddUtil.parseInt(l_bus71)-AddUtil.parseInt(l_bus72)%>(<%if(l_bus71.equals("0")||l_bus72.equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(l_bus71)/AddUtil.parseFloat(l_bus72)*100,0)%><%}%>)</td>
            <td align="center"><%=ht2.get("L_BUS61")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_BUS61")))-AddUtil.parseInt(String.valueOf(ht2.get("L_BUS61")))%>(<%=ht2.get("HL_BUS61")%>)</td>
            <td align="center"><%=ht2.get("L_BUS62")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_BUS62")))-AddUtil.parseInt(String.valueOf(ht2.get("L_BUS62")))%>(<%=ht2.get("HL_BUS62")%>)</td>
            <td align="center"><%=ht2.get("L_BUS63")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_BUS63")))-AddUtil.parseInt(String.valueOf(ht2.get("L_BUS63")))%>(<%=ht2.get("HL_BUS63")%>)</td>
            <td align="center"><%=ht2.get("L_BUS6")%> /<%=AddUtil.parseInt(String.valueOf(ht1.get("L_BUS6"))) -AddUtil.parseInt(String.valueOf(ht2.get("L_BUS6")))%> (<%=ht2.get("HL_BUS6")%>)</td>									
            <td align="center"><%=ht2.get("L_BUS71")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_BUS71")))-AddUtil.parseInt(String.valueOf(ht2.get("L_BUS71")))%>(<%=ht2.get("HL_BUS71")%>)</td>
            <td align="center"><%=ht2.get("L_BUS72")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_BUS72")))-AddUtil.parseInt(String.valueOf(ht2.get("L_BUS72")))%>(<%=ht2.get("HL_BUS72")%>)</td>
            <td align="center"><%=ht2.get("L_BUS73")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_BUS73")))-AddUtil.parseInt(String.valueOf(ht2.get("L_BUS73")))%>(<%=ht2.get("HL_BUS73")%>)</td>
            <td align="center"><%=ht2.get("L_BUS7")%> /<%=AddUtil.parseInt(String.valueOf(ht1.get("L_BUS7"))) -AddUtil.parseInt(String.valueOf(ht2.get("L_BUS7")))%> (<%=ht2.get("HL_BUS7")%>)</td>									
            <td align="center"><%=ht2.get("LB_CONT")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("LB_CONT")))-AddUtil.parseInt(String.valueOf(ht2.get("LB_CONT")))%>(<%=ht2.get("HL_CONT")%>)</td>
          </tr>
          <tr>
            <td class='title'><%=b_dt3%>실적/증감대수(%)</td>
            <td align="center"><%=ht3.get("L_BUS1")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_BUS1")))-AddUtil.parseInt(String.valueOf(ht3.get("L_BUS1")))%>(<%=ht3.get("HL_BUS1")%>)</td>
            <td align="center"><%=ht3.get("L_BUS2")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_BUS2")))-AddUtil.parseInt(String.valueOf(ht3.get("L_BUS2")))%>(<%=ht3.get("HL_BUS2")%>)</td>
            <td align="center"><%=ht3.get("L_BUS3")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_BUS3")))-AddUtil.parseInt(String.valueOf(ht3.get("L_BUS3")))%>(<%=ht3.get("HL_BUS3")%>)</td>
            <td align="center"><%=ht3.get("L_BUS9")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_BUS9")))-AddUtil.parseInt(String.valueOf(ht3.get("L_BUS9")))%>(<%=ht3.get("HL_BUS9")%>)</td>
            <td align="center"><%=ht3.get("L_BUS4")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_BUS4")))-AddUtil.parseInt(String.valueOf(ht3.get("L_BUS4")))%>(<%=ht3.get("HL_BUS4")%>)</td>
            <td align="center"><%=ht3.get("L_BUS5")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_BUS5")))-AddUtil.parseInt(String.valueOf(ht3.get("L_BUS5")))%>(<%=ht3.get("HL_BUS5")%>)</td>
            <td align="center"><%=l_bus73%>/<%=AddUtil.parseInt(l_bus71)-AddUtil.parseInt(l_bus73)%>(<%if(l_bus71.equals("0")||l_bus73.equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(l_bus71)/AddUtil.parseFloat(l_bus73)*100,0)%><%}%>)</td>
            <td align="center"><%=ht3.get("L_BUS61")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_BUS61")))-AddUtil.parseInt(String.valueOf(ht3.get("L_BUS61")))%>(<%=ht3.get("HL_BUS61")%>)</td>
            <td align="center"><%=ht3.get("L_BUS62")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_BUS62")))-AddUtil.parseInt(String.valueOf(ht3.get("L_BUS62")))%>(<%=ht3.get("HL_BUS62")%>)</td>
            <td align="center"><%=ht3.get("L_BUS63")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_BUS63")))-AddUtil.parseInt(String.valueOf(ht3.get("L_BUS63")))%>(<%=ht3.get("HL_BUS63")%>)</td>
            <td align="center"><%=ht3.get("L_BUS6")%> /<%=AddUtil.parseInt(String.valueOf(ht1.get("L_BUS6"))) -AddUtil.parseInt(String.valueOf(ht3.get("L_BUS6")))%> (<%=ht3.get("HL_BUS6")%>)</td>									
            <td align="center"><%=ht3.get("L_BUS71")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_BUS71")))-AddUtil.parseInt(String.valueOf(ht3.get("L_BUS71")))%>(<%=ht3.get("HL_BUS71")%>)</td>
            <td align="center"><%=ht3.get("L_BUS72")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_BUS72")))-AddUtil.parseInt(String.valueOf(ht3.get("L_BUS72")))%>(<%=ht3.get("HL_BUS72")%>)</td>
            <td align="center"><%=ht3.get("L_BUS73")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_BUS73")))-AddUtil.parseInt(String.valueOf(ht3.get("L_BUS73")))%>(<%=ht3.get("HL_BUS73")%>)</td>
            <td align="center"><%=ht3.get("L_BUS7")%> /<%=AddUtil.parseInt(String.valueOf(ht1.get("L_BUS7"))) -AddUtil.parseInt(String.valueOf(ht3.get("L_BUS7")))%> (<%=ht3.get("HL_BUS7")%>)</td>									
            <td align="center"><%=ht3.get("LB_CONT")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("LB_CONT")))-AddUtil.parseInt(String.valueOf(ht3.get("LB_CONT")))%>(<%=ht3.get("HL_CONT")%>)</td>
          </tr>  
          <tr>
            <td rowspan="3" class='title'>합계</td>
            <td class='title'><%=b_dt1%>실적</td>
            <td align="center"><%=ht1.get("T_BUS1")%></td>
            <td align="center"><%=ht1.get("T_BUS2")%></td>
            <td align="center"><%=ht1.get("T_BUS3")%></td>
            <td align="center"><%=ht1.get("T_BUS9")%></td>
            <td align="center"><%=ht1.get("T_BUS4")%></td>
            <td align="center"><%=ht1.get("T_BUS5")%></td>
            <td align="center"><%=t_bus71%></td>
            <td align="center"><%=ht1.get("T_BUS61")%></td>
            <td align="center"><%=ht1.get("T_BUS62")%></td>
            <td align="center"><%=ht1.get("T_BUS63")%></td>
            <td align="center"><%=ht1.get("T_BUS6")%></td>									
            <td align="center"><%=ht1.get("T_BUS71")%></td>
            <td align="center"><%=ht1.get("T_BUS72")%></td>
            <td align="center"><%=ht1.get("T_BUS73")%></td>
            <td align="center"><%=ht1.get("T_BUS7")%></td>									
            <td align="center"><%=ht1.get("TB_CONT")%></td>
          </tr>
          <tr>
            <td class='title'><%=b_dt2%>실적/증감대수(%)</td>
            <td align="center"><%=ht2.get("T_BUS1")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_BUS1")))-AddUtil.parseInt(String.valueOf(ht2.get("T_BUS1")))%>(<%if(String.valueOf(ht2.get("T_BUS1")).equals("0")||String.valueOf(ht1.get("T_BUS1")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_BUS1")))/AddUtil.parseFloat(String.valueOf(ht2.get("T_BUS1")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht2.get("T_BUS2")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_BUS2")))-AddUtil.parseInt(String.valueOf(ht2.get("T_BUS2")))%>(<%if(String.valueOf(ht2.get("T_BUS2")).equals("0")||String.valueOf(ht1.get("T_BUS2")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_BUS2")))/AddUtil.parseFloat(String.valueOf(ht2.get("T_BUS2")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht2.get("T_BUS3")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_BUS3")))-AddUtil.parseInt(String.valueOf(ht2.get("T_BUS3")))%>(<%if(String.valueOf(ht2.get("T_BUS3")).equals("0")||String.valueOf(ht1.get("T_BUS3")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_BUS3")))/AddUtil.parseFloat(String.valueOf(ht2.get("T_BUS3")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht2.get("T_BUS9")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_BUS9")))-AddUtil.parseInt(String.valueOf(ht2.get("T_BUS9")))%>(<%if(String.valueOf(ht2.get("T_BUS9")).equals("0")||String.valueOf(ht1.get("T_BUS9")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_BUS9")))/AddUtil.parseFloat(String.valueOf(ht2.get("T_BUS9")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht2.get("T_BUS4")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_BUS4")))-AddUtil.parseInt(String.valueOf(ht2.get("T_BUS4")))%>(<%if(String.valueOf(ht2.get("T_BUS4")).equals("0")||String.valueOf(ht1.get("T_BUS4")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_BUS4")))/AddUtil.parseFloat(String.valueOf(ht2.get("T_BUS4")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht2.get("T_BUS5")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_BUS5")))-AddUtil.parseInt(String.valueOf(ht2.get("T_BUS5")))%>(<%if(String.valueOf(ht2.get("T_BUS5")).equals("0")||String.valueOf(ht1.get("T_BUS5")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_BUS5")))/AddUtil.parseFloat(String.valueOf(ht2.get("T_BUS5")))*100,0)%><%}%>)</td>
            <td align="center"><%=t_bus72%>/<%=AddUtil.parseInt(t_bus71)-AddUtil.parseInt(t_bus72)%>(<%if(t_bus71.equals("0")||t_bus72.equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(t_bus71)/AddUtil.parseFloat(t_bus72)*100,0)%><%}%>)</td>
            <td align="center"><%=ht2.get("T_BUS6")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_BUS6")))-AddUtil.parseInt(String.valueOf(ht2.get("T_BUS6")))%>(<%if(String.valueOf(ht2.get("T_BUS6")).equals("0")||String.valueOf(ht1.get("T_BUS61")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_BUS61")))/AddUtil.parseFloat(String.valueOf(ht2.get("T_BUS61")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht2.get("T_BUS6")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_BUS6")))-AddUtil.parseInt(String.valueOf(ht2.get("T_BUS6")))%>(<%if(String.valueOf(ht2.get("T_BUS6")).equals("0")||String.valueOf(ht1.get("T_BUS62")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_BUS62")))/AddUtil.parseFloat(String.valueOf(ht2.get("T_BUS62")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht2.get("T_BUS6")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_BUS6")))-AddUtil.parseInt(String.valueOf(ht2.get("T_BUS6")))%>(<%if(String.valueOf(ht2.get("T_BUS6")).equals("0")||String.valueOf(ht1.get("T_BUS63")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_BUS63")))/AddUtil.parseFloat(String.valueOf(ht2.get("T_BUS63")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht2.get("T_BUS6")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_BUS6")))-AddUtil.parseInt(String.valueOf(ht2.get("T_BUS6")))%>(<%if(String.valueOf(ht2.get("T_BUS6")).equals("0")||String.valueOf(ht1.get("T_BUS6")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_BUS6")))/AddUtil.parseFloat(String.valueOf(ht2.get("T_BUS6")))*100,0)%><%}%>)</td>									
            <td align="center"><%=ht2.get("T_BUS7")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_BUS7")))-AddUtil.parseInt(String.valueOf(ht2.get("T_BUS7")))%>(<%if(String.valueOf(ht2.get("T_BUS7")).equals("0")||String.valueOf(ht1.get("T_BUS71")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_BUS71")))/AddUtil.parseFloat(String.valueOf(ht2.get("T_BUS71")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht2.get("T_BUS7")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_BUS7")))-AddUtil.parseInt(String.valueOf(ht2.get("T_BUS7")))%>(<%if(String.valueOf(ht2.get("T_BUS7")).equals("0")||String.valueOf(ht1.get("T_BUS72")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_BUS72")))/AddUtil.parseFloat(String.valueOf(ht2.get("T_BUS72")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht2.get("T_BUS7")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_BUS7")))-AddUtil.parseInt(String.valueOf(ht2.get("T_BUS7")))%>(<%if(String.valueOf(ht2.get("T_BUS7")).equals("0")||String.valueOf(ht1.get("T_BUS73")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_BUS73")))/AddUtil.parseFloat(String.valueOf(ht2.get("T_BUS73")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht2.get("T_BUS7")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_BUS7")))-AddUtil.parseInt(String.valueOf(ht2.get("T_BUS7")))%>(<%if(String.valueOf(ht2.get("T_BUS7")).equals("0")||String.valueOf(ht1.get("T_BUS7")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_BUS7")))/AddUtil.parseFloat(String.valueOf(ht2.get("T_BUS7")))*100,0)%><%}%>)</td>									
            <td align="center"><%=ht2.get("TB_CONT")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("TB_CONT")))-AddUtil.parseInt(String.valueOf(ht2.get("TB_CONT")))%>(<%if(String.valueOf(ht2.get("TB_CONT")).equals("0")||String.valueOf(ht1.get("TB_CONT")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("TB_CONT")))/AddUtil.parseFloat(String.valueOf(ht2.get("TB_CONT")))*100,0)%><%}%>)</td>
          </tr>
          <tr>
            <td class='title'><%=b_dt3%>실적/증감대수(%)</td>
            <td align="center"><%=ht3.get("T_BUS1")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_BUS1")))-AddUtil.parseInt(String.valueOf(ht3.get("T_BUS1")))%>(<%if(String.valueOf(ht3.get("T_BUS1")).equals("0")||String.valueOf(ht1.get("T_BUS1")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_BUS1")))/AddUtil.parseFloat(String.valueOf(ht3.get("T_BUS1")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht3.get("T_BUS2")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_BUS2")))-AddUtil.parseInt(String.valueOf(ht3.get("T_BUS2")))%>(<%if(String.valueOf(ht3.get("T_BUS2")).equals("0")||String.valueOf(ht1.get("T_BUS2")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_BUS2")))/AddUtil.parseFloat(String.valueOf(ht3.get("T_BUS2")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht3.get("T_BUS3")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_BUS3")))-AddUtil.parseInt(String.valueOf(ht3.get("T_BUS3")))%>(<%if(String.valueOf(ht3.get("T_BUS3")).equals("0")||String.valueOf(ht1.get("T_BUS3")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_BUS3")))/AddUtil.parseFloat(String.valueOf(ht3.get("T_BUS3")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht3.get("T_BUS9")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_BUS9")))-AddUtil.parseInt(String.valueOf(ht3.get("T_BUS9")))%>(<%if(String.valueOf(ht3.get("T_BUS9")).equals("0")||String.valueOf(ht1.get("T_BUS9")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_BUS9")))/AddUtil.parseFloat(String.valueOf(ht3.get("T_BUS9")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht3.get("T_BUS4")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_BUS4")))-AddUtil.parseInt(String.valueOf(ht3.get("T_BUS4")))%>(<%if(String.valueOf(ht3.get("T_BUS4")).equals("0")||String.valueOf(ht1.get("T_BUS4")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_BUS4")))/AddUtil.parseFloat(String.valueOf(ht3.get("T_BUS4")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht3.get("T_BUS5")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_BUS5")))-AddUtil.parseInt(String.valueOf(ht3.get("T_BUS5")))%>(<%if(String.valueOf(ht3.get("T_BUS5")).equals("0")||String.valueOf(ht1.get("T_BUS5")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_BUS5")))/AddUtil.parseFloat(String.valueOf(ht3.get("T_BUS5")))*100,0)%><%}%>)</td>
            <td align="center"><%=t_bus73%>/<%=AddUtil.parseInt(t_bus71)-AddUtil.parseInt(t_bus73)%>(<%if(t_bus71.equals("0")||t_bus73.equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(t_bus71)/AddUtil.parseFloat(t_bus73)*100,0)%><%}%>)</td>
            <td align="center"><%=ht3.get("T_BUS6")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_BUS6")))-AddUtil.parseInt(String.valueOf(ht3.get("T_BUS6")))%>(<%if(String.valueOf(ht3.get("T_BUS6")).equals("0")||String.valueOf(ht1.get("T_BUS61")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_BUS61")))/AddUtil.parseFloat(String.valueOf(ht3.get("T_BUS61")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht3.get("T_BUS6")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_BUS6")))-AddUtil.parseInt(String.valueOf(ht3.get("T_BUS6")))%>(<%if(String.valueOf(ht3.get("T_BUS6")).equals("0")||String.valueOf(ht1.get("T_BUS62")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_BUS62")))/AddUtil.parseFloat(String.valueOf(ht3.get("T_BUS62")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht3.get("T_BUS6")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_BUS6")))-AddUtil.parseInt(String.valueOf(ht3.get("T_BUS6")))%>(<%if(String.valueOf(ht3.get("T_BUS6")).equals("0")||String.valueOf(ht1.get("T_BUS63")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_BUS63")))/AddUtil.parseFloat(String.valueOf(ht3.get("T_BUS63")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht3.get("T_BUS6")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_BUS6")))-AddUtil.parseInt(String.valueOf(ht3.get("T_BUS6")))%>(<%if(String.valueOf(ht3.get("T_BUS6")).equals("0")||String.valueOf(ht1.get("T_BUS6")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_BUS6")))/AddUtil.parseFloat(String.valueOf(ht3.get("T_BUS6")))*100,0)%><%}%>)</td>									
            <td align="center"><%=ht3.get("T_BUS7")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_BUS7")))-AddUtil.parseInt(String.valueOf(ht3.get("T_BUS7")))%>(<%if(String.valueOf(ht3.get("T_BUS7")).equals("0")||String.valueOf(ht1.get("T_BUS71")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_BUS71")))/AddUtil.parseFloat(String.valueOf(ht3.get("T_BUS71")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht3.get("T_BUS7")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_BUS7")))-AddUtil.parseInt(String.valueOf(ht3.get("T_BUS7")))%>(<%if(String.valueOf(ht3.get("T_BUS7")).equals("0")||String.valueOf(ht1.get("T_BUS72")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_BUS72")))/AddUtil.parseFloat(String.valueOf(ht3.get("T_BUS72")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht3.get("T_BUS7")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_BUS7")))-AddUtil.parseInt(String.valueOf(ht3.get("T_BUS7")))%>(<%if(String.valueOf(ht3.get("T_BUS7")).equals("0")||String.valueOf(ht1.get("T_BUS73")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_BUS73")))/AddUtil.parseFloat(String.valueOf(ht3.get("T_BUS73")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht3.get("T_BUS7")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_BUS7")))-AddUtil.parseInt(String.valueOf(ht3.get("T_BUS7")))%>(<%if(String.valueOf(ht3.get("T_BUS7")).equals("0")||String.valueOf(ht1.get("T_BUS7")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_BUS7")))/AddUtil.parseFloat(String.valueOf(ht3.get("T_BUS7")))*100,0)%><%}%>)</td>									
            <td align="center"><%=ht3.get("TB_CONT")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("TB_CONT")))-AddUtil.parseInt(String.valueOf(ht3.get("TB_CONT")))%>(<%if(String.valueOf(ht3.get("TB_CONT")).equals("0")||String.valueOf(ht1.get("T_CONT")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("TB_CONT")))/AddUtil.parseFloat(String.valueOf(ht3.get("TB_CONT")))*100,0)%><%}%>)</td>
          </tr>  
		</table>
	  </td>
    </tr>	
    <tr>
	  <td>※ 영업구분현황에서 재리스/연장계약은 제외하였습니다.&nbsp;</td>
	</tr>		
    <tr>
	  <td>&nbsp;</td>
	</tr>		
    <tr>
	  <td class=line2 ></td>
	</tr>
    <tr>
      <td class=line>
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td colspan="2" rowspan="2" class='title'>구분</td>
            <td colspan="4" class='title'>신차</td>
            <td colspan="4" class='title'>재리스</td>
            <td colspan="4" class='title'>중고차</td>
            <td width="80" rowspan='2' class='title'>연장</td>
            <td colspan="5" class='title'>합계</td>
          </tr>
          <tr>
            <td width="80" class='title'>신규</td>
            <td width="80" class='title'>증차</td>
            <td width="80" class='title'>대차</td>
            <td width="80" class='title'>소계</td>
            <td width="80" class='title'>신규</td>
            <td width="80" class='title'>증차</td>
            <td width="80" class='title'>대차</td>
            <td width="80" class='title'>소계</td>
            <td width="80" class='title'>신규</td>
            <td width="80" class='title'>증차</td>
            <td width="80" class='title'>대차</td>
            <td width="80" class='title'>소계</td>
            <td width="80" class='title'>신규</td>
            <td width="80" class='title'>증차</td>
            <td width="80" class='title'>대차</td>
            <td width="80" class='title'>연장</td>			
            <td width="100" class='title'>합계</td>
          </tr>
          <tr>
            <td width='40' rowspan="3" class='title'>렌트</td>
            <td width='150' class='title'><%=b_dt1%>실적</td>
            <td align="center"><%=ht1.get("R_RENT11")%></td>
            <td align="center"><%=ht1.get("R_RENT12")%></td>
            <td align="center"><%=ht1.get("R_RENT13")%></td>
            <td align="center"><%=ht1.get("R_RENT14")%></td>
            <td align="center"><%=ht1.get("R_RENT21")%></td>
            <td align="center"><%=ht1.get("R_RENT22")%></td>
            <td align="center"><%=ht1.get("R_RENT23")%></td>
            <td align="center"><%=ht1.get("R_RENT24")%></td>
            <td align="center"><%=ht1.get("R_RENT31")%></td>
            <td align="center"><%=ht1.get("R_RENT32")%></td>
            <td align="center"><%=ht1.get("R_RENT33")%></td>
            <td align="center"><%=ht1.get("R_RENT34")%></td>
<!--        <td align="center"><%=ht1.get("R_RENT41")%></td>
            <td align="center"><%=ht1.get("R_RENT42")%></td>
            <td align="center"><%=ht1.get("R_RENT43")%></td>-->
            <td align="center"><%=ht1.get("R_RENT44")%></td>
            <td align="center"><%=ht1.get("R_RENT51")%></td>
            <td align="center"><%=ht1.get("R_RENT52")%></td>
            <td align="center"><%=ht1.get("R_RENT53")%></td>
            <td align="center"><%=ht1.get("R_RENT44")%></td>			
            <td align="center"><%=ht1.get("R_CONT")%></td>
          </tr>
          <tr>
            <td class='title'><%=b_dt2%>실적/증감대수(%)</td>
            <td align="center"><%=ht2.get("R_RENT11")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_RENT11")))-AddUtil.parseInt(String.valueOf(ht2.get("R_RENT11")))%>(<%=ht2.get("HR_RENT11")%>)</td>
            <td align="center"><%=ht2.get("R_RENT12")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_RENT12")))-AddUtil.parseInt(String.valueOf(ht2.get("R_RENT12")))%>(<%=ht2.get("HR_RENT12")%>)</td>
            <td align="center"><%=ht2.get("R_RENT13")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_RENT13")))-AddUtil.parseInt(String.valueOf(ht2.get("R_RENT13")))%>(<%=ht2.get("HR_RENT13")%>)</td>
            <td align="center"><%=ht2.get("R_RENT14")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_RENT14")))-AddUtil.parseInt(String.valueOf(ht2.get("R_RENT14")))%>(<%if(String.valueOf(ht2.get("R_RENT14")).equals("0")||String.valueOf(ht1.get("R_RENT14")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("R_RENT14")))/AddUtil.parseFloat(String.valueOf(ht2.get("R_RENT14")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht2.get("R_RENT21")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_RENT21")))-AddUtil.parseInt(String.valueOf(ht2.get("R_RENT21")))%>(<%=ht2.get("HR_RENT21")%>)</td>
            <td align="center"><%=ht2.get("R_RENT22")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_RENT22")))-AddUtil.parseInt(String.valueOf(ht2.get("R_RENT22")))%>(<%=ht2.get("HR_RENT22")%>)</td>
            <td align="center"><%=ht2.get("R_RENT23")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_RENT23")))-AddUtil.parseInt(String.valueOf(ht2.get("R_RENT23")))%>(<%=ht2.get("HR_RENT23")%>)</td>
            <td align="center"><%=ht2.get("R_RENT24")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_RENT24")))-AddUtil.parseInt(String.valueOf(ht2.get("R_RENT24")))%>(<%if(String.valueOf(ht2.get("R_RENT24")).equals("0")||String.valueOf(ht1.get("R_RENT24")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("R_RENT24")))/AddUtil.parseFloat(String.valueOf(ht2.get("R_RENT24")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht2.get("R_RENT31")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_RENT31")))-AddUtil.parseInt(String.valueOf(ht2.get("R_RENT31")))%>(<%=ht2.get("HR_RENT31")%>)</td>
            <td align="center"><%=ht2.get("R_RENT32")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_RENT32")))-AddUtil.parseInt(String.valueOf(ht2.get("R_RENT32")))%>(<%=ht2.get("HR_RENT32")%>)</td>
            <td align="center"><%=ht2.get("R_RENT33")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_RENT33")))-AddUtil.parseInt(String.valueOf(ht2.get("R_RENT33")))%>(<%=ht2.get("HR_RENT33")%>)</td>
            <td align="center"><%=ht2.get("R_RENT34")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_RENT34")))-AddUtil.parseInt(String.valueOf(ht2.get("R_RENT34")))%>(<%if(String.valueOf(ht2.get("R_RENT34")).equals("0")||String.valueOf(ht1.get("R_RENT34")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("R_RENT34")))/AddUtil.parseFloat(String.valueOf(ht2.get("R_RENT34")))*100,0)%><%}%>)</td>
<!--        <td align="center"><%=ht2.get("R_RENT41")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_RENT41")))-AddUtil.parseInt(String.valueOf(ht2.get("R_RENT41")))%>(<%=ht2.get("HR_RENT41")%>)</td>
            <td align="center"><%=ht2.get("R_RENT42")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_RENT42")))-AddUtil.parseInt(String.valueOf(ht2.get("R_RENT42")))%>(<%=ht2.get("HR_RENT42")%>)</td>
            <td align="center"><%=ht2.get("R_RENT43")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_RENT43")))-AddUtil.parseInt(String.valueOf(ht2.get("R_RENT43")))%>(<%=ht2.get("HR_RENT43")%>)</td>-->
            <td align="center"><%=ht2.get("R_RENT44")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_RENT44")))-AddUtil.parseInt(String.valueOf(ht2.get("R_RENT44")))%>(<%if(String.valueOf(ht2.get("R_RENT44")).equals("0")||String.valueOf(ht1.get("R_RENT44")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("R_RENT44")))/AddUtil.parseFloat(String.valueOf(ht2.get("R_RENT44")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht2.get("R_RENT51")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_RENT51")))-AddUtil.parseInt(String.valueOf(ht2.get("R_RENT51")))%>(<%=ht2.get("HR_RENT51")%>)</td>
            <td align="center"><%=ht2.get("R_RENT52")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_RENT52")))-AddUtil.parseInt(String.valueOf(ht2.get("R_RENT52")))%>(<%=ht2.get("HR_RENT52")%>)</td>
            <td align="center"><%=ht2.get("R_RENT53")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_RENT53")))-AddUtil.parseInt(String.valueOf(ht2.get("R_RENT53")))%>(<%=ht2.get("HR_RENT53")%>)</td>
            <td align="center"><%=ht2.get("R_RENT44")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_RENT44")))-AddUtil.parseInt(String.valueOf(ht2.get("R_RENT44")))%>(<%if(String.valueOf(ht2.get("R_RENT44")).equals("0")||String.valueOf(ht1.get("R_RENT44")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("R_RENT44")))/AddUtil.parseFloat(String.valueOf(ht2.get("R_RENT44")))*100,0)%><%}%>)</td>			
            <td align="center"><%=ht2.get("R_CONT")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_CONT")))-AddUtil.parseInt(String.valueOf(ht2.get("R_CONT")))%>(<%=ht2.get("HR_CONT")%>)</td>
          </tr>
          <tr>
            <td class='title'><%=b_dt3%>실적/증감대수(%)</td>
            <td align="center"><%=ht3.get("R_RENT11")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_RENT11")))-AddUtil.parseInt(String.valueOf(ht3.get("R_RENT11")))%>(<%=ht3.get("HR_RENT11")%>)</td>
            <td align="center"><%=ht3.get("R_RENT12")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_RENT12")))-AddUtil.parseInt(String.valueOf(ht3.get("R_RENT12")))%>(<%=ht3.get("HR_RENT12")%>)</td>
            <td align="center"><%=ht3.get("R_RENT13")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_RENT13")))-AddUtil.parseInt(String.valueOf(ht3.get("R_RENT13")))%>(<%=ht3.get("HR_RENT13")%>)</td>
            <td align="center"><%=ht3.get("R_RENT14")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_RENT14")))-AddUtil.parseInt(String.valueOf(ht3.get("R_RENT14")))%>(<%if(String.valueOf(ht3.get("R_RENT14")).equals("0")||String.valueOf(ht1.get("R_RENT14")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("R_RENT14")))/AddUtil.parseFloat(String.valueOf(ht3.get("R_RENT14")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht3.get("R_RENT21")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_RENT21")))-AddUtil.parseInt(String.valueOf(ht3.get("R_RENT21")))%>(<%=ht3.get("HR_RENT21")%>)</td>
            <td align="center"><%=ht3.get("R_RENT22")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_RENT22")))-AddUtil.parseInt(String.valueOf(ht3.get("R_RENT22")))%>(<%=ht3.get("HR_RENT22")%>)</td>
            <td align="center"><%=ht3.get("R_RENT23")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_RENT23")))-AddUtil.parseInt(String.valueOf(ht3.get("R_RENT23")))%>(<%=ht3.get("HR_RENT23")%>)</td>
            <td align="center"><%=ht3.get("R_RENT24")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_RENT24")))-AddUtil.parseInt(String.valueOf(ht3.get("R_RENT24")))%>(<%if(String.valueOf(ht3.get("R_RENT24")).equals("0")||String.valueOf(ht1.get("R_RENT24")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("R_RENT24")))/AddUtil.parseFloat(String.valueOf(ht3.get("R_RENT24")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht3.get("R_RENT31")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_RENT31")))-AddUtil.parseInt(String.valueOf(ht3.get("R_RENT31")))%>(<%=ht3.get("HR_RENT31")%>)</td>
            <td align="center"><%=ht3.get("R_RENT32")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_RENT32")))-AddUtil.parseInt(String.valueOf(ht3.get("R_RENT32")))%>(<%=ht3.get("HR_RENT32")%>)</td>
            <td align="center"><%=ht3.get("R_RENT33")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_RENT33")))-AddUtil.parseInt(String.valueOf(ht3.get("R_RENT33")))%>(<%=ht3.get("HR_RENT33")%>)</td>
            <td align="center"><%=ht3.get("R_RENT34")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_RENT34")))-AddUtil.parseInt(String.valueOf(ht3.get("R_RENT34")))%>(<%if(String.valueOf(ht3.get("R_RENT34")).equals("0")||String.valueOf(ht1.get("R_RENT34")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("R_RENT34")))/AddUtil.parseFloat(String.valueOf(ht3.get("R_RENT34")))*100,0)%><%}%>)</td>
<!--        <td align="center"><%=ht3.get("R_RENT41")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_RENT41")))-AddUtil.parseInt(String.valueOf(ht3.get("R_RENT41")))%>(<%=ht3.get("HR_RENT41")%>)</td>
            <td align="center"><%=ht3.get("R_RENT42")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_RENT42")))-AddUtil.parseInt(String.valueOf(ht3.get("R_RENT42")))%>(<%=ht3.get("HR_RENT42")%>)</td>
            <td align="center"><%=ht3.get("R_RENT43")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_RENT43")))-AddUtil.parseInt(String.valueOf(ht3.get("R_RENT43")))%>(<%=ht3.get("HR_RENT43")%>)</td>-->
            <td align="center"><%=ht3.get("R_RENT44")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_RENT44")))-AddUtil.parseInt(String.valueOf(ht3.get("R_RENT44")))%>(<%if(String.valueOf(ht3.get("R_RENT44")).equals("0")||String.valueOf(ht1.get("R_RENT44")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("R_RENT44")))/AddUtil.parseFloat(String.valueOf(ht3.get("R_RENT44")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht3.get("R_RENT51")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_RENT51")))-AddUtil.parseInt(String.valueOf(ht3.get("R_RENT51")))%>(<%=ht3.get("HR_RENT51")%>)</td>
            <td align="center"><%=ht3.get("R_RENT52")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_RENT52")))-AddUtil.parseInt(String.valueOf(ht3.get("R_RENT52")))%>(<%=ht3.get("HR_RENT52")%>)</td>
            <td align="center"><%=ht3.get("R_RENT53")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_RENT53")))-AddUtil.parseInt(String.valueOf(ht3.get("R_RENT53")))%>(<%=ht3.get("HR_RENT53")%>)</td>
            <td align="center"><%=ht3.get("R_RENT44")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_RENT44")))-AddUtil.parseInt(String.valueOf(ht3.get("R_RENT44")))%>(<%if(String.valueOf(ht3.get("R_RENT44")).equals("0")||String.valueOf(ht1.get("R_RENT44")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("R_RENT44")))/AddUtil.parseFloat(String.valueOf(ht3.get("R_RENT44")))*100,0)%><%}%>)</td>			
            <td align="center"><%=ht3.get("R_CONT")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("R_CONT")))-AddUtil.parseInt(String.valueOf(ht3.get("R_CONT")))%>(<%=ht3.get("HR_CONT")%>)</td>
          </tr>  
          <tr>
            <td rowspan="3" class='title'>리스</td>
            <td class='title'><%=b_dt1%>실적</td>
            <td align="center"><%=ht1.get("L_RENT11")%></td>
            <td align="center"><%=ht1.get("L_RENT12")%></td>
            <td align="center"><%=ht1.get("L_RENT13")%></td>
            <td align="center"><%=ht1.get("L_RENT14")%></td>
            <td align="center"><%=ht1.get("L_RENT21")%></td>
            <td align="center"><%=ht1.get("L_RENT22")%></td>
            <td align="center"><%=ht1.get("L_RENT23")%></td>
            <td align="center"><%=ht1.get("L_RENT24")%></td>
            <td align="center"><%=ht1.get("L_RENT31")%></td>
            <td align="center"><%=ht1.get("L_RENT32")%></td>
            <td align="center"><%=ht1.get("L_RENT33")%></td>
            <td align="center"><%=ht1.get("L_RENT34")%></td>
<!--        <td align="center"><%=ht1.get("L_RENT41")%></td>
            <td align="center"><%=ht1.get("L_RENT42")%></td>
            <td align="center"><%=ht1.get("L_RENT43")%></td>-->
            <td align="center"><%=ht1.get("L_RENT44")%></td>
            <td align="center"><%=ht1.get("L_RENT51")%></td>
            <td align="center"><%=ht1.get("L_RENT52")%></td>
            <td align="center"><%=ht1.get("L_RENT53")%></td>
            <td align="center"><%=ht1.get("L_RENT44")%></td>			
            <td align="center"><%=ht1.get("L_CONT")%></td>
          </tr>		  
          <tr>
            <td class='title'><%=b_dt2%>실적/증감대수(%)</td>
            <td align="center"><%=ht2.get("L_RENT11")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_RENT11")))-AddUtil.parseInt(String.valueOf(ht2.get("L_RENT11")))%>(<%=ht2.get("HL_RENT11")%>)</td>
            <td align="center"><%=ht2.get("L_RENT12")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_RENT12")))-AddUtil.parseInt(String.valueOf(ht2.get("L_RENT12")))%>(<%=ht2.get("HL_RENT12")%>)</td>
            <td align="center"><%=ht2.get("L_RENT13")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_RENT13")))-AddUtil.parseInt(String.valueOf(ht2.get("L_RENT13")))%>(<%=ht2.get("HL_RENT13")%>)</td>
            <td align="center"><%=ht2.get("L_RENT14")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_RENT14")))-AddUtil.parseInt(String.valueOf(ht2.get("L_RENT14")))%>(<%if(String.valueOf(ht2.get("L_RENT14")).equals("0")||String.valueOf(ht1.get("L_RENT14")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("L_RENT14")))/AddUtil.parseFloat(String.valueOf(ht2.get("L_RENT14")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht2.get("L_RENT21")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_RENT21")))-AddUtil.parseInt(String.valueOf(ht2.get("L_RENT21")))%>(<%=ht2.get("HL_RENT21")%>)</td>
            <td align="center"><%=ht2.get("L_RENT22")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_RENT22")))-AddUtil.parseInt(String.valueOf(ht2.get("L_RENT22")))%>(<%=ht2.get("HL_RENT22")%>)</td>
            <td align="center"><%=ht2.get("L_RENT23")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_RENT23")))-AddUtil.parseInt(String.valueOf(ht2.get("L_RENT23")))%>(<%=ht2.get("HL_RENT23")%>)</td>
            <td align="center"><%=ht2.get("L_RENT24")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_RENT24")))-AddUtil.parseInt(String.valueOf(ht2.get("L_RENT24")))%>(<%if(String.valueOf(ht2.get("L_RENT24")).equals("0")||String.valueOf(ht1.get("L_RENT24")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("L_RENT24")))/AddUtil.parseFloat(String.valueOf(ht2.get("L_RENT24")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht2.get("L_RENT31")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_RENT31")))-AddUtil.parseInt(String.valueOf(ht2.get("L_RENT31")))%>(<%=ht2.get("HL_RENT31")%>)</td>
            <td align="center"><%=ht2.get("L_RENT32")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_RENT32")))-AddUtil.parseInt(String.valueOf(ht2.get("L_RENT32")))%>(<%=ht2.get("HL_RENT32")%>)</td>
            <td align="center"><%=ht2.get("L_RENT33")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_RENT33")))-AddUtil.parseInt(String.valueOf(ht2.get("L_RENT33")))%>(<%=ht2.get("HL_RENT33")%>)</td>
            <td align="center"><%=ht2.get("L_RENT34")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_RENT34")))-AddUtil.parseInt(String.valueOf(ht2.get("L_RENT34")))%>(<%if(String.valueOf(ht2.get("L_RENT34")).equals("0")||String.valueOf(ht1.get("L_RENT34")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("L_RENT34")))/AddUtil.parseFloat(String.valueOf(ht2.get("L_RENT34")))*100,0)%><%}%>)</td>
<!--        <td align="center"><%=ht2.get("L_RENT41")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_RENT41")))-AddUtil.parseInt(String.valueOf(ht2.get("L_RENT41")))%>(<%=ht2.get("HL_RENT41")%>)</td>
            <td align="center"><%=ht2.get("L_RENT42")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_RENT42")))-AddUtil.parseInt(String.valueOf(ht2.get("L_RENT42")))%>(<%=ht2.get("HL_RENT42")%>)</td>
            <td align="center"><%=ht2.get("L_RENT43")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_RENT43")))-AddUtil.parseInt(String.valueOf(ht2.get("L_RENT43")))%>(<%=ht2.get("HL_RENT43")%>)</td>-->
            <td align="center"><%=ht2.get("L_RENT44")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_RENT44")))-AddUtil.parseInt(String.valueOf(ht2.get("L_RENT44")))%>(<%if(String.valueOf(ht2.get("L_RENT44")).equals("0")||String.valueOf(ht1.get("L_RENT44")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("L_RENT44")))/AddUtil.parseFloat(String.valueOf(ht2.get("L_RENT44")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht2.get("L_RENT51")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_RENT51")))-AddUtil.parseInt(String.valueOf(ht2.get("L_RENT51")))%>(<%=ht2.get("HL_RENT51")%>)</td>
            <td align="center"><%=ht2.get("L_RENT52")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_RENT52")))-AddUtil.parseInt(String.valueOf(ht2.get("L_RENT52")))%>(<%=ht2.get("HL_RENT52")%>)</td>
            <td align="center"><%=ht2.get("L_RENT53")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_RENT53")))-AddUtil.parseInt(String.valueOf(ht2.get("L_RENT53")))%>(<%=ht2.get("HL_RENT53")%>)</td>
            <td align="center"><%=ht2.get("L_RENT44")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_RENT44")))-AddUtil.parseInt(String.valueOf(ht2.get("L_RENT44")))%>(<%if(String.valueOf(ht2.get("L_RENT44")).equals("0")||String.valueOf(ht1.get("L_RENT44")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("L_RENT44")))/AddUtil.parseFloat(String.valueOf(ht2.get("L_RENT44")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht2.get("L_CONT")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_CONT")))-AddUtil.parseInt(String.valueOf(ht2.get("L_CONT")))%>(<%=ht2.get("HL_CONT")%>)</td>
          </tr>
          <tr>
            <td class='title'><%=b_dt3%>실적/증감대수(%)</td>
            <td align="center"><%=ht3.get("L_RENT11")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_RENT11")))-AddUtil.parseInt(String.valueOf(ht3.get("L_RENT11")))%>(<%=ht3.get("HL_RENT11")%>)</td>
            <td align="center"><%=ht3.get("L_RENT12")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_RENT12")))-AddUtil.parseInt(String.valueOf(ht3.get("L_RENT12")))%>(<%=ht3.get("HL_RENT12")%>)</td>
            <td align="center"><%=ht3.get("L_RENT13")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_RENT13")))-AddUtil.parseInt(String.valueOf(ht3.get("L_RENT13")))%>(<%=ht3.get("HL_RENT13")%>)</td>
            <td align="center"><%=ht3.get("L_RENT14")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_RENT14")))-AddUtil.parseInt(String.valueOf(ht3.get("L_RENT14")))%>(<%if(String.valueOf(ht3.get("L_RENT14")).equals("0")||String.valueOf(ht1.get("L_RENT14")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("L_RENT14")))/AddUtil.parseFloat(String.valueOf(ht3.get("L_RENT14")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht3.get("L_RENT21")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_RENT21")))-AddUtil.parseInt(String.valueOf(ht3.get("L_RENT21")))%>(<%=ht3.get("HL_RENT21")%>)</td>
            <td align="center"><%=ht3.get("L_RENT22")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_RENT22")))-AddUtil.parseInt(String.valueOf(ht3.get("L_RENT22")))%>(<%=ht3.get("HL_RENT22")%>)</td>
            <td align="center"><%=ht3.get("L_RENT23")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_RENT23")))-AddUtil.parseInt(String.valueOf(ht3.get("L_RENT23")))%>(<%=ht3.get("HL_RENT23")%>)</td>
            <td align="center"><%=ht3.get("L_RENT24")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_RENT24")))-AddUtil.parseInt(String.valueOf(ht3.get("L_RENT24")))%>(<%if(String.valueOf(ht3.get("L_RENT24")).equals("0")||String.valueOf(ht1.get("L_RENT24")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("L_RENT24")))/AddUtil.parseFloat(String.valueOf(ht3.get("L_RENT24")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht3.get("L_RENT31")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_RENT31")))-AddUtil.parseInt(String.valueOf(ht3.get("L_RENT31")))%>(<%=ht3.get("HL_RENT31")%>)</td>
            <td align="center"><%=ht3.get("L_RENT32")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_RENT32")))-AddUtil.parseInt(String.valueOf(ht3.get("L_RENT32")))%>(<%=ht3.get("HL_RENT32")%>)</td>
            <td align="center"><%=ht3.get("L_RENT33")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_RENT33")))-AddUtil.parseInt(String.valueOf(ht3.get("L_RENT33")))%>(<%=ht3.get("HL_RENT33")%>)</td>
            <td align="center"><%=ht3.get("L_RENT34")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_RENT34")))-AddUtil.parseInt(String.valueOf(ht3.get("L_RENT34")))%>(<%if(String.valueOf(ht3.get("L_RENT34")).equals("0")||String.valueOf(ht1.get("L_RENT34")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("L_RENT34")))/AddUtil.parseFloat(String.valueOf(ht3.get("L_RENT34")))*100,0)%><%}%>)</td>
<!--        <td align="center"><%=ht3.get("L_RENT41")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_RENT41")))-AddUtil.parseInt(String.valueOf(ht3.get("L_RENT41")))%>(<%=ht3.get("HL_RENT41")%>)</td>
            <td align="center"><%=ht3.get("L_RENT42")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_RENT42")))-AddUtil.parseInt(String.valueOf(ht3.get("L_RENT42")))%>(<%=ht3.get("HL_RENT42")%>)</td>
            <td align="center"><%=ht3.get("L_RENT43")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_RENT43")))-AddUtil.parseInt(String.valueOf(ht3.get("L_RENT43")))%>(<%=ht3.get("HL_RENT43")%>)</td>-->
            <td align="center"><%=ht3.get("L_RENT44")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_RENT44")))-AddUtil.parseInt(String.valueOf(ht3.get("L_RENT44")))%>(<%if(String.valueOf(ht3.get("L_RENT44")).equals("0")||String.valueOf(ht1.get("L_RENT44")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("L_RENT44")))/AddUtil.parseFloat(String.valueOf(ht3.get("L_RENT44")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht3.get("L_RENT51")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_RENT51")))-AddUtil.parseInt(String.valueOf(ht3.get("L_RENT51")))%>(<%=ht3.get("HL_RENT51")%>)</td>
            <td align="center"><%=ht3.get("L_RENT52")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_RENT52")))-AddUtil.parseInt(String.valueOf(ht3.get("L_RENT52")))%>(<%=ht3.get("HL_RENT52")%>)</td>
            <td align="center"><%=ht3.get("L_RENT53")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_RENT53")))-AddUtil.parseInt(String.valueOf(ht3.get("L_RENT53")))%>(<%=ht3.get("HL_RENT53")%>)</td>
            <td align="center"><%=ht3.get("L_RENT44")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_RENT44")))-AddUtil.parseInt(String.valueOf(ht3.get("L_RENT44")))%>(<%if(String.valueOf(ht3.get("L_RENT44")).equals("0")||String.valueOf(ht1.get("L_RENT44")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("L_RENT44")))/AddUtil.parseFloat(String.valueOf(ht3.get("L_RENT44")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht3.get("L_CONT")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("L_CONT")))-AddUtil.parseInt(String.valueOf(ht3.get("L_CONT")))%>(<%=ht3.get("HL_CONT")%>)</td>
          </tr>  
          <tr>
            <td rowspan="3" class='title'>합계</td>
            <td class='title'><%=b_dt1%>실적</td>
            <td align="center"><%=ht1.get("T_RENT11")%></td>
            <td align="center"><%=ht1.get("T_RENT12")%></td>
            <td align="center"><%=ht1.get("T_RENT13")%></td>
            <td align="center"><%=ht1.get("T_RENT14")%></td>
            <td align="center"><%=ht1.get("T_RENT21")%></td>
            <td align="center"><%=ht1.get("T_RENT22")%></td>
            <td align="center"><%=ht1.get("T_RENT23")%></td>
            <td align="center"><%=ht1.get("T_RENT24")%></td>
            <td align="center"><%=ht1.get("T_RENT31")%></td>
            <td align="center"><%=ht1.get("T_RENT32")%></td>
            <td align="center"><%=ht1.get("T_RENT33")%></td>
            <td align="center"><%=ht1.get("T_RENT34")%></td>
<!--        <td align="center"><%=ht1.get("T_RENT41")%></td>
            <td align="center"><%=ht1.get("T_RENT42")%></td>
            <td align="center"><%=ht1.get("T_RENT43")%></td>-->
            <td align="center"><%=ht1.get("T_RENT44")%></td>
            <td align="center"><%=ht1.get("T_RENT51")%></td>
            <td align="center"><%=ht1.get("T_RENT52")%></td>
            <td align="center"><%=ht1.get("T_RENT53")%></td>
            <td align="center"><%=ht1.get("T_RENT44")%></td>			
            <td align="center"><%=ht1.get("T_CONT")%></td>
          </tr>
          <tr>
            <td class='title'><%=b_dt2%>실적/증감대수(%)</td>
            <td align="center"><%=ht2.get("T_RENT11")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_RENT11")))-AddUtil.parseInt(String.valueOf(ht2.get("T_RENT11")))%>(<%if(String.valueOf(ht2.get("T_RENT11")).equals("0")||String.valueOf(ht1.get("T_RENT11")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_RENT11")))/AddUtil.parseFloat(String.valueOf(ht2.get("T_RENT11")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht2.get("T_RENT12")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_RENT12")))-AddUtil.parseInt(String.valueOf(ht2.get("T_RENT12")))%>(<%if(String.valueOf(ht2.get("T_RENT12")).equals("0")||String.valueOf(ht1.get("T_RENT12")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_RENT12")))/AddUtil.parseFloat(String.valueOf(ht2.get("T_RENT12")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht2.get("T_RENT13")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_RENT13")))-AddUtil.parseInt(String.valueOf(ht2.get("T_RENT13")))%>(<%if(String.valueOf(ht2.get("T_RENT13")).equals("0")||String.valueOf(ht1.get("T_RENT13")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_RENT13")))/AddUtil.parseFloat(String.valueOf(ht2.get("T_RENT13")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht2.get("T_RENT14")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_RENT14")))-AddUtil.parseInt(String.valueOf(ht2.get("T_RENT14")))%>(<%if(String.valueOf(ht2.get("T_RENT14")).equals("0")||String.valueOf(ht1.get("T_RENT14")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_RENT14")))/AddUtil.parseFloat(String.valueOf(ht2.get("T_RENT14")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht2.get("T_RENT21")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_RENT21")))-AddUtil.parseInt(String.valueOf(ht2.get("T_RENT21")))%>(<%if(String.valueOf(ht2.get("T_RENT21")).equals("0")||String.valueOf(ht1.get("T_RENT21")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_RENT21")))/AddUtil.parseFloat(String.valueOf(ht2.get("T_RENT21")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht2.get("T_RENT22")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_RENT22")))-AddUtil.parseInt(String.valueOf(ht2.get("T_RENT22")))%>(<%if(String.valueOf(ht2.get("T_RENT22")).equals("0")||String.valueOf(ht1.get("T_RENT22")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_RENT22")))/AddUtil.parseFloat(String.valueOf(ht2.get("T_RENT22")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht2.get("T_RENT23")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_RENT23")))-AddUtil.parseInt(String.valueOf(ht2.get("T_RENT23")))%>(<%if(String.valueOf(ht2.get("T_RENT23")).equals("0")||String.valueOf(ht1.get("T_RENT23")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_RENT23")))/AddUtil.parseFloat(String.valueOf(ht2.get("T_RENT23")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht2.get("T_RENT24")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_RENT24")))-AddUtil.parseInt(String.valueOf(ht2.get("T_RENT24")))%>(<%if(String.valueOf(ht2.get("T_RENT24")).equals("0")||String.valueOf(ht1.get("T_RENT24")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_RENT24")))/AddUtil.parseFloat(String.valueOf(ht2.get("T_RENT24")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht2.get("T_RENT31")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_RENT31")))-AddUtil.parseInt(String.valueOf(ht2.get("T_RENT31")))%>(<%if(String.valueOf(ht2.get("T_RENT31")).equals("0")||String.valueOf(ht1.get("T_RENT31")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_RENT31")))/AddUtil.parseFloat(String.valueOf(ht2.get("T_RENT31")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht2.get("T_RENT32")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_RENT32")))-AddUtil.parseInt(String.valueOf(ht2.get("T_RENT32")))%>(<%if(String.valueOf(ht2.get("T_RENT32")).equals("0")||String.valueOf(ht1.get("T_RENT32")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_RENT32")))/AddUtil.parseFloat(String.valueOf(ht2.get("T_RENT32")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht2.get("T_RENT33")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_RENT33")))-AddUtil.parseInt(String.valueOf(ht2.get("T_RENT33")))%>(<%if(String.valueOf(ht2.get("T_RENT33")).equals("0")||String.valueOf(ht1.get("T_RENT33")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_RENT33")))/AddUtil.parseFloat(String.valueOf(ht2.get("T_RENT33")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht2.get("T_RENT34")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_RENT34")))-AddUtil.parseInt(String.valueOf(ht2.get("T_RENT34")))%>(<%if(String.valueOf(ht2.get("T_RENT34")).equals("0")||String.valueOf(ht1.get("T_RENT34")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_RENT34")))/AddUtil.parseFloat(String.valueOf(ht2.get("T_RENT34")))*100,0)%><%}%>)</td>
<!--        <td align="center"><%=ht2.get("T_RENT41")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_RENT41")))-AddUtil.parseInt(String.valueOf(ht2.get("T_RENT41")))%>(<%if(String.valueOf(ht2.get("T_RENT41")).equals("0")||String.valueOf(ht1.get("T_RENT41")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_RENT14")))/AddUtil.parseFloat(String.valueOf(ht2.get("T_RENT14")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht2.get("T_RENT42")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_RENT42")))-AddUtil.parseInt(String.valueOf(ht2.get("T_RENT42")))%>(<%if(String.valueOf(ht2.get("T_RENT42")).equals("0")||String.valueOf(ht1.get("T_RENT42")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_RENT24")))/AddUtil.parseFloat(String.valueOf(ht2.get("T_RENT24")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht2.get("T_RENT43")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_RENT43")))-AddUtil.parseInt(String.valueOf(ht2.get("T_RENT43")))%>(<%if(String.valueOf(ht2.get("T_RENT43")).equals("0")||String.valueOf(ht1.get("T_RENT43")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_RENT34")))/AddUtil.parseFloat(String.valueOf(ht2.get("T_RENT34")))*100,0)%><%}%>)</td>-->
            <td align="center"><%=ht2.get("T_RENT44")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_RENT44")))-AddUtil.parseInt(String.valueOf(ht2.get("T_RENT44")))%>(<%if(String.valueOf(ht2.get("T_RENT44")).equals("0")||String.valueOf(ht1.get("T_RENT44")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_RENT44")))/AddUtil.parseFloat(String.valueOf(ht2.get("T_RENT44")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht2.get("T_RENT51")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_RENT51")))-AddUtil.parseInt(String.valueOf(ht2.get("T_RENT51")))%>(<%if(String.valueOf(ht2.get("T_RENT51")).equals("0")||String.valueOf(ht1.get("T_RENT51")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_RENT51")))/AddUtil.parseFloat(String.valueOf(ht2.get("T_RENT51")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht2.get("T_RENT52")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_RENT52")))-AddUtil.parseInt(String.valueOf(ht2.get("T_RENT52")))%>(<%if(String.valueOf(ht2.get("T_RENT52")).equals("0")||String.valueOf(ht1.get("T_RENT52")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_RENT52")))/AddUtil.parseFloat(String.valueOf(ht2.get("T_RENT52")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht2.get("T_RENT53")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_RENT53")))-AddUtil.parseInt(String.valueOf(ht2.get("T_RENT53")))%>(<%if(String.valueOf(ht2.get("T_RENT53")).equals("0")||String.valueOf(ht1.get("T_RENT53")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_RENT53")))/AddUtil.parseFloat(String.valueOf(ht2.get("T_RENT53")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht2.get("T_RENT44")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_RENT44")))-AddUtil.parseInt(String.valueOf(ht2.get("T_RENT44")))%>(<%if(String.valueOf(ht2.get("T_RENT44")).equals("0")||String.valueOf(ht1.get("T_RENT44")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_RENT44")))/AddUtil.parseFloat(String.valueOf(ht2.get("T_RENT44")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht2.get("T_CONT")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_CONT")))-AddUtil.parseInt(String.valueOf(ht2.get("T_CONT")))      %>(<%if(String.valueOf(ht2.get("T_CONT")).equals("0")||String.valueOf(ht1.get("T_CONT")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_CONT")))/AddUtil.parseFloat(String.valueOf(ht2.get("T_CONT")))*100,0)%><%}%>)</td>
          </tr>
          <tr>
            <td class='title'><%=b_dt3%>실적/증감대수(%)</td>
            <td align="center"><%=ht3.get("T_RENT11")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_RENT11")))-AddUtil.parseInt(String.valueOf(ht3.get("T_RENT11")))%>(<%if(String.valueOf(ht3.get("T_RENT11")).equals("0")||String.valueOf(ht1.get("T_RENT11")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_RENT11")))/AddUtil.parseFloat(String.valueOf(ht3.get("T_RENT11")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht3.get("T_RENT12")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_RENT12")))-AddUtil.parseInt(String.valueOf(ht3.get("T_RENT12")))%>(<%if(String.valueOf(ht3.get("T_RENT12")).equals("0")||String.valueOf(ht1.get("T_RENT12")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_RENT12")))/AddUtil.parseFloat(String.valueOf(ht3.get("T_RENT12")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht3.get("T_RENT13")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_RENT13")))-AddUtil.parseInt(String.valueOf(ht3.get("T_RENT13")))%>(<%if(String.valueOf(ht3.get("T_RENT13")).equals("0")||String.valueOf(ht1.get("T_RENT13")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_RENT13")))/AddUtil.parseFloat(String.valueOf(ht3.get("T_RENT13")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht3.get("T_RENT14")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_RENT14")))-AddUtil.parseInt(String.valueOf(ht3.get("T_RENT14")))%>(<%if(String.valueOf(ht3.get("T_RENT14")).equals("0")||String.valueOf(ht1.get("T_RENT14")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_RENT14")))/AddUtil.parseFloat(String.valueOf(ht3.get("T_RENT14")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht3.get("T_RENT21")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_RENT21")))-AddUtil.parseInt(String.valueOf(ht3.get("T_RENT21")))%>(<%if(String.valueOf(ht3.get("T_RENT21")).equals("0")||String.valueOf(ht1.get("T_RENT21")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_RENT21")))/AddUtil.parseFloat(String.valueOf(ht3.get("T_RENT21")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht3.get("T_RENT22")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_RENT22")))-AddUtil.parseInt(String.valueOf(ht3.get("T_RENT22")))%>(<%if(String.valueOf(ht3.get("T_RENT22")).equals("0")||String.valueOf(ht1.get("T_RENT22")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_RENT22")))/AddUtil.parseFloat(String.valueOf(ht3.get("T_RENT22")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht3.get("T_RENT23")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_RENT23")))-AddUtil.parseInt(String.valueOf(ht3.get("T_RENT23")))%>(<%if(String.valueOf(ht3.get("T_RENT23")).equals("0")||String.valueOf(ht1.get("T_RENT23")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_RENT23")))/AddUtil.parseFloat(String.valueOf(ht3.get("T_RENT23")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht3.get("T_RENT24")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_RENT24")))-AddUtil.parseInt(String.valueOf(ht3.get("T_RENT24")))%>(<%if(String.valueOf(ht3.get("T_RENT24")).equals("0")||String.valueOf(ht1.get("T_RENT24")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_RENT24")))/AddUtil.parseFloat(String.valueOf(ht3.get("T_RENT24")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht3.get("T_RENT31")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_RENT31")))-AddUtil.parseInt(String.valueOf(ht3.get("T_RENT31")))%>(<%if(String.valueOf(ht3.get("T_RENT31")).equals("0")||String.valueOf(ht1.get("T_RENT31")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_RENT31")))/AddUtil.parseFloat(String.valueOf(ht3.get("T_RENT31")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht3.get("T_RENT32")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_RENT32")))-AddUtil.parseInt(String.valueOf(ht3.get("T_RENT32")))%>(<%if(String.valueOf(ht3.get("T_RENT32")).equals("0")||String.valueOf(ht1.get("T_RENT32")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_RENT32")))/AddUtil.parseFloat(String.valueOf(ht3.get("T_RENT32")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht3.get("T_RENT33")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_RENT33")))-AddUtil.parseInt(String.valueOf(ht3.get("T_RENT33")))%>(<%if(String.valueOf(ht3.get("T_RENT33")).equals("0")||String.valueOf(ht1.get("T_RENT33")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_RENT33")))/AddUtil.parseFloat(String.valueOf(ht3.get("T_RENT33")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht3.get("T_RENT34")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_RENT34")))-AddUtil.parseInt(String.valueOf(ht3.get("T_RENT34")))%>(<%if(String.valueOf(ht3.get("T_RENT34")).equals("0")||String.valueOf(ht1.get("T_RENT34")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_RENT34")))/AddUtil.parseFloat(String.valueOf(ht3.get("T_RENT34")))*100,0)%><%}%>)</td>
<!--        <td align="center"><%=ht3.get("T_RENT41")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_RENT41")))-AddUtil.parseInt(String.valueOf(ht3.get("T_RENT41")))%>(<%if(String.valueOf(ht3.get("T_RENT41")).equals("0")||String.valueOf(ht1.get("T_RENT41")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_RENT41")))/AddUtil.parseFloat(String.valueOf(ht3.get("T_RENT41")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht3.get("T_RENT42")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_RENT42")))-AddUtil.parseInt(String.valueOf(ht3.get("T_RENT42")))%>(<%if(String.valueOf(ht3.get("T_RENT42")).equals("0")||String.valueOf(ht1.get("T_RENT42")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_RENT42")))/AddUtil.parseFloat(String.valueOf(ht3.get("T_RENT42")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht3.get("T_RENT43")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_RENT43")))-AddUtil.parseInt(String.valueOf(ht3.get("T_RENT43")))%>(<%if(String.valueOf(ht3.get("T_RENT43")).equals("0")||String.valueOf(ht1.get("T_RENT43")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_RENT43")))/AddUtil.parseFloat(String.valueOf(ht3.get("T_RENT43")))*100,0)%><%}%>)</td>-->
            <td align="center"><%=ht3.get("T_RENT44")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_RENT44")))-AddUtil.parseInt(String.valueOf(ht3.get("T_RENT44")))%>(<%if(String.valueOf(ht3.get("T_RENT44")).equals("0")||String.valueOf(ht1.get("T_RENT44")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_RENT44")))/AddUtil.parseFloat(String.valueOf(ht3.get("T_RENT44")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht3.get("T_RENT51")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_RENT51")))-AddUtil.parseInt(String.valueOf(ht3.get("T_RENT51")))%>(<%if(String.valueOf(ht3.get("T_RENT51")).equals("0")||String.valueOf(ht1.get("T_RENT51")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_RENT51")))/AddUtil.parseFloat(String.valueOf(ht3.get("T_RENT51")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht3.get("T_RENT52")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_RENT52")))-AddUtil.parseInt(String.valueOf(ht3.get("T_RENT52")))%>(<%if(String.valueOf(ht3.get("T_RENT52")).equals("0")||String.valueOf(ht1.get("T_RENT52")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_RENT52")))/AddUtil.parseFloat(String.valueOf(ht3.get("T_RENT52")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht3.get("T_RENT53")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_RENT53")))-AddUtil.parseInt(String.valueOf(ht3.get("T_RENT53")))%>(<%if(String.valueOf(ht3.get("T_RENT53")).equals("0")||String.valueOf(ht1.get("T_RENT53")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_RENT53")))/AddUtil.parseFloat(String.valueOf(ht3.get("T_RENT53")))*100,0)%><%}%>)</td>
            <td align="center"><%=ht3.get("T_RENT44")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_RENT44")))-AddUtil.parseInt(String.valueOf(ht3.get("T_RENT44")))%>(<%if(String.valueOf(ht3.get("T_RENT44")).equals("0")||String.valueOf(ht1.get("T_RENT44")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_RENT44")))/AddUtil.parseFloat(String.valueOf(ht3.get("T_RENT44")))*100,0)%><%}%>)</td>			
            <td align="center"><%=ht3.get("T_CONT")%>/<%=AddUtil.parseInt(String.valueOf(ht1.get("T_CONT")))-AddUtil.parseInt(String.valueOf(ht3.get("T_CONT")))      %>(<%if(String.valueOf(ht3.get("T_CONT")).equals("0")||String.valueOf(ht1.get("T_CONT")).equals("0")){%>0<%}else{%><%=AddUtil.parseFloatCipher2(AddUtil.parseFloat(String.valueOf(ht1.get("T_CONT")))/AddUtil.parseFloat(String.valueOf(ht3.get("T_CONT")))*100,0)%><%}%>)</td>
          </tr>  
		</table>
	  </td>
    </tr>	
<%	}else{%>	
    <tr>
	  <td>※ 검색된 데이타가 없습니다.</td>
	</tr>
<%	}%>			  
  </table>
</body>
</html>
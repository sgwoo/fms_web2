<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=off_ls_after_excel.xls");
%>

<%@ page import="java.util.*, acar.util.*, acar.offls_after.* "%>
<%@ page import="acar.insur.*"%>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String migr_gu = request.getParameter("migr_gu")==null?"3":request.getParameter("migr_gu");

	
	if(!st_dt.equals("")) st_dt = AddUtil.replace(st_dt, "-", "");
	if(!end_dt.equals("")) end_dt = AddUtil.replace(end_dt, "-", "");
	
	
	
	Offls_afterDatabase olfD = Offls_afterDatabase.getInstance();
	Vector mExcelList = olfD.getOffls_after_excel_lst(st_dt, end_dt,migr_gu);
	int vsize = mExcelList.size();

%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<table border="0" cellspacing="0" cellpadding="0" width='800'>
    <tr>
        <td height="40" align="center" style="font-size : 20pt;"><b>해지신청요청서</b></td>
    </tr>
    <tr>
        <td align='right'>총건수 : <%=vsize%>건</td>
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
    <tr> 
        <td class=line> 
     		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    
                    <td width='50' class='title'>연번</td>				
                    <td width='100' class='title'>등록날짜</td>
                    <td width='100' class='title'>명의이전날짜</td>
                    <td width='100' class='title'>차량번호</td>
                    <td width='100' class='title'>차명</td>
                    <td width='150' class='title'>보험사</td>					
                    <td width='150' class='title'>증권번호</td>
                    <td width='100' class='title'>가입일자</td>
                    <td width='100' class='title'>해지일자</td>					
                </tr>			
           </table>
        </td>
    </tr>
    <%if(mExcelList.size() > 0 ){%>
	            <tr>
                    <td width=530 class='line' id='td_con' style='position:relative;'> 
                        <table border="0" cellspacing="1" cellpadding="0" width="100%" >
                <% for(int i=0; i< mExcelList.size(); i++){
					Hashtable car = (Hashtable)mExcelList.elementAt(i); %>
                            <tr> 
                                <td width='40' align='center'><%=i+1%></td>								
                        		<td width='150' align='center'><%=car.get("REG_DT")%></td>
                            <td width='100' align='center'><%=car.get("MIGR_DT")%></td>
                            <td width='100' align='left'>&nbsp;<%=car.get("CAR_NO")%></td>
                            	 <td width='100' align='left'>&nbsp;<%=car.get("CAR_NM")%></td>
                            <td width='100' align='left'>&nbsp;<%=car.get("INS_COM_NM")%></td>
                            <td width='100' align='left'>&nbsp;<%=car.get("INS_CON_NO")%></td>
                            <td width='100' align='left'>&nbsp;<%=car.get("INS_START_DT")%></td>
                            <td width='100' align='left'>&nbsp;<%=car.get("INS_EXP_DT")%></td>
                           
                            </tr>
                <%}%>
                            <tr> 
                                <td class='title' colspan='9'>&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                  	            </tr>
<%}else{%>
	            <tr>
	                <td width=200 class='line' id='td_con' style='position:relative;'> 
	                    <table border="0" cellspacing="1" cellpadding="0" width="100%" >
                            <tr> 
                                <td align='center'></td>
                            </tr>
                        </table>
                    </td>
	                <td class='line' width=600> 
                        <table border="0" cellspacing="1" cellpadding="0" width="100%" >
                            <tr> 
                                <td  align='left' >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;해당 차량이 없읍니다.</td>
                            </tr>          
                        </table>
		            </td>
	            </tr>
<%}%>		
            </table>
        </td>
    </tr>
</table>
</body>
</html>

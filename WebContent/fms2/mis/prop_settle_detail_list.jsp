<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.cost.CostDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");	
	
	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");	
	String s_month = request.getParameter("s_month")==null?"":request.getParameter("s_month");	

	String mng_id = request.getParameter("mng_id")==null?"":request.getParameter("mng_id");
	String dt		= request.getParameter("dt")==null?"2":request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	String mng_nm 	= request.getParameter("mng_nm")==null?"":request.getParameter("mng_nm");

	
	int amt1 	= request.getParameter("amt1")==null?0:AddUtil.parseInt(request.getParameter("amt1"));
	int amt3 	= request.getParameter("amt3")==null?0:AddUtil.parseInt(request.getParameter("amt3"));
	int amt1_per 	= request.getParameter("amt1_per")==null?0:AddUtil.parseInt(request.getParameter("amt1_per"));
 
	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
//팝업윈도우 열기
function MM_openBrWindow(theURL,winName,features) { //v2.0
	window.open(theURL,winName,features);
}
//-->	
</script>
</head>

<body>
<form action="" name="form1" method="POST">
<table border="0" cellspacing="0" cellpadding="0" width="100%">

  <tr> 
  	  <td align='left' colspan=2>&nbsp;제안평가: 평가점수:제안일, 제안채택평가금액:제안일 기준<br> 
  	                             &nbsp;댓글평가: 평가점수:제안일 기준 </td>
  	
  </tr>
  <tr> 
  	  <td align='right' colspan=2> &nbsp;성명 : <%=mng_nm%>&nbsp;&nbsp;</td>
  </tr>
  <tr>
   	<td colspan=2 class=line2></td>
  </tr>
  <tr id='tr_title' style='position:relative;z-index:1'>
	<td class='line' width='100%' id='td_title' style='position:relative;'> 
<%	Vector vts2 = ac_db.getPropCostStatList(dt, ref_dt1, ref_dt2, mng_id, amt1, amt3, amt1_per);
	int vt_size2 = vts2.size();%>	

	    <table border="0" cellspacing="1" cellpadding="0" width='100%' height="31">
          <tr> 
            <td width="8%"  class="title">연번</td>
            <td width="10%"  class="title">구분</td>
            <td width="62%"  class="title">내용</td>
            <td width="10%"  class="title">평가점수</td>    
            <td width="10%"  class="title">제안채택<br>평가금액</td>         
          </tr>
        </table></td>

  </tr>	
<%	if(vt_size2 > 0){%>
  <tr>
	  <td class='line' width='100%' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <%	float t_amt1[] = new float[1];
      		long t_amt2[] = new long[1];
        	long t_amt3[] = new long[1];
        	
 		  	float e_amt= 0;
        
 		    long  l_e_amt= 0;
 		    long  l_p_amt= 0;
 		        
        %>
        <%	for(int i = 0 ; i < vt_size2 ; i++){
					Hashtable ht = (Hashtable)vts2.elementAt(i);
					
					for(int j=0; j<1; j++){
									
						e_amt = AddUtil.parseFloat(String.valueOf(ht.get("E_AMT")));
						
						l_p_amt = AddUtil.parseLong(String.valueOf(ht.get("P_AMT")));
							
																		 
						t_amt1[j] += e_amt;
						t_amt2[j] += l_p_amt;
											
					}
						%>
          <tr> 
          	<td width='8%' align='center'><%=i+1%></td>
            <td width="10%" align="center"><%=ht.get("GUBUN")%></td>
            <td width="62%" align="left"><%=Util.subData(String.valueOf(ht.get("TITLE")), 40)%></td>
            <td width='10%' align="right"><%=Util.parseDecimal(e_amt)%></td>
            <td width='10%' align="right"><%=Util.parseDecimal(l_p_amt)%></td>
                           
          </tr>
          <%}%>
          <tr> 
           <td class=title style='text-align:center;' colspan="3">합계</td>
           <td class=title style='text-align:right;'><%= Util.parseDecimal(t_amt1[0])%></td>
           <td class=title style='text-align:right;'><%= Util.parseDecimal(t_amt2[0])%></td>
          </tr>		  
        </table></td>
	
  </tr>
<%	}else{%>                     
  <tr>
	  <td class='line' width='100%' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td align='center'>&nbsp;등록된 데이타가 없습니다</td>
          </tr>
        </table></td>
	
  </tr>
<% 	}%>
  </table>
</form>
</body>
</html>

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
	String bb_cnt 	= request.getParameter("bb_cnt")==null?"0":request.getParameter("bb_cnt");
	String ii_cnt 	= request.getParameter("ii_cnt")==null?"0":request.getParameter("ii_cnt");
	
	int amt1 	= request.getParameter("amt1")==null?0:AddUtil.parseInt(request.getParameter("amt1"));
	int amt2 	= request.getParameter("amt2")==null?0:AddUtil.parseInt(request.getParameter("amt2"));
	int amt1_per 	= request.getParameter("amt1_per")==null?0:AddUtil.parseInt(request.getParameter("amt1_per"));
	int amt2_per 	= request.getParameter("amt2_per")==null?0:AddUtil.parseInt(request.getParameter("amt2_per"));
	int amt3_per 	= request.getParameter("amt3_per")==null?0:AddUtil.parseInt(request.getParameter("amt3_per"));
	
	int bus_cost_per 	= request.getParameter("bus_cost_per")==null?0:AddUtil.parseInt(request.getParameter("bus_cost_per"));
	int mng_cost_per 	= request.getParameter("mng_cost_per")==null?0:AddUtil.parseInt(request.getParameter("mng_cost_per"));
	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="../../include/table_t.css">
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
  	  <td align='left' colspan=2>&nbsp;&nbsp;<img src=/acar/images/center/icon_arrow.gif align=absmiddle>&nbsp;성명 : <%=mng_nm%>&nbsp;&nbsp;&nbsp;&nbsp; 관리대수 : 기본식 (<%=bb_cnt%>), 일반식(<%=ii_cnt%>)&nbsp;&nbsp;</td>
  </tr>
  <tr>
   	<td colspan=2 class=line2></td>
  </tr>
  <tr id='tr_title' style='position:relative;z-index:1'>
	<td class='line' width='44%' id='td_title' style='position:relative;'> 
<%	Vector vts2 = ac_db.getDlyCostStatMList(dt, ref_dt1, ref_dt2, mng_id, amt1, amt2, amt1_per, amt2_per, amt3_per, bus_cost_per, mng_cost_per);
	int vt_size2 = vts2.size();%>	

	    <table border="0" cellspacing="1" cellpadding="0" width='100%' height="31">
          <tr> 
            <td width="14%"  class="title">연번</td>
            <td width="32%"  class="title">계약번호</td>
            <td width="24%"  class="title">상호</td>
            <td width="20%"  class="title">차량</td>
          </tr>
        </table></td>
	<td class='line' width='56%'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
         <tr>
            <td width="17%"  class="title">차명</td>
            <td width="13%"  class="title">대여방식</td>
            <td width="16%"  class="title">구분</td>
            <td width="12%"  class="title">정비일자</td>
            <td width="10%"  class="title">과실<br>비율</td>
            <td width="16%"  class="title">적용금액</td>
           
          </tr>
        </table>
	</td>
  </tr>	
<%	if(vt_size2 > 0){%>
  <tr>
	  <td class='line' width='44%' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <%	long t_amt1[] = new long[1];
      		long t_amt2[] = new long[1];
        	long t_amt3[] = new long[1];
        	float a_amt= 0;
        	float l_amt= 0;
 		    long  l_a_amt= 0;
 		    long  l_l_amt= 0;
 		        
        %>
        <%	for(int i = 0 ; i < vt_size2 ; i++){
					Hashtable ht = (Hashtable)vts2.elementAt(i);%>
          <tr> 
          	  <td <%if(ht.get("USE_YN").equals("N")){%>class='is'<%}%> width='14%' align='center'><a name="<%=i+1%>"><%=i+1%> 
              <%if(ht.get("USE_YN").equals("Y")){%>
              <%}else{%>
              (해약) 
              <%}%>
            </a></td>
            
            <td width="32%" align="center"><span title='<%=ht.get("RENT_L_CD")%>'><%=Util.subData(String.valueOf(ht.get("RENT_L_CD")), 13)%></span></td>
            <td width="24%" align="left"><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 7)%></td>
            <td width="20%" align="center"><%=ht.get("CAR_NO")%></td>
                                        
          </tr>
          <%}%>
          <tr> 
           <td class=title style='text-align:center;' colspan="4">합계</td>
          </tr>		  
        </table></td>
	<td class='line' width='56%'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <%for(int i = 0 ; i < vt_size2 ; i++){
					Hashtable ht = (Hashtable)vts2.elementAt(i);
					for(int j=0; j<1; j++){
						
						a_amt = AddUtil.parseFloat(String.valueOf(ht.get("AMT")));
						l_a_amt = (long) a_amt;
																		 
						t_amt1[j] += l_a_amt;
											
					}
										
					%>
          <tr> 
            <td width='17%' align="center"><%=Util.subData(String.valueOf(ht.get("CAR_NM")), 6)%></td>
            <td width='13%' align="center"><%=Util.subData(String.valueOf(ht.get("RENT_WAY")),5)%> </td>
            <td width='16%' align="center"><%=ht.get("GUBUN")%></td>
            <td width='12%' align="center"><%=ht.get("SERV_DT")%></td>
            <td width='10%' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("PER")))%></td>
            <td width='16%' align="right"><%=Util.parseDecimal(l_a_amt)%></td>
           
          </tr>
		 <%}%>
          <tr> 
            <td class=title style='text-align:right;'> </td>
            <td class=title style='text-align:right;'> </td>
            <td class=title style='text-align:right;'> </td>
            <td class=title style='text-align:right;'> </td>
            <td class=title style='text-align:right;'> </td>
            <td class=title style='text-align:right;'><%= Util.parseDecimal(t_amt1[0])%></td>
                      
          </tr>	  
        </table>
	</td>
  </tr>
<%	}else{%>                     
  <tr>
	  <td class='line' width='44%' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td align='center'>&nbsp;</td>
          </tr>
        </table></td>
	<td class='line' width='56%'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
		  <td>등록된 데이타가 없습니다</td>
		</tr>
	  </table>
	</td>
  </tr>
<% 	}%>
  </table>
</form>
</body>
</html>

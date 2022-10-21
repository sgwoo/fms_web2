<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String settle_year 	= request.getParameter("settle_year")==null?"":request.getParameter("settle_year");
	String table_width	= request.getParameter("table_width")==null?"":request.getParameter("table_width");
	
	Vector vt = ad_db.getSettleAccount_list23(settle_year);
	int vt_size = vt.size();
	
	table_width = "1100";
	
	int r_cal = 0;
	int r_amt = 0;
	int t_amt = 0;
	
	float  f_amt = 0;
	
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' action='' method='post'>
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>
  <input type='hidden' name='settle_year' value='<%=settle_year%>'>
  <table border="0" cellspacing="0" cellpadding="0" width=<%=table_width%>>
  
	<tr>
	  <td align="center"><%=AddUtil.parseInt(settle_year)%>년  미사용연차현황 </td>
	</tr>		
	<tr>
	  <td align="right"><%=AddUtil.parseInt(settle_year)%>년12월31일 기준</td>	  
    </tr>				
 	<tr>
        <td class=line2></td>
    </tr>
	<tr> 
		<td class=line>
		  	<table width="100%" border="0" cellspacing="1" cellpadding="0">			
			    <tr>
			      <td width="50" rowspan='3' class="title">연번</td>
				  <td width="100" rowspan='3' class="title">근무지</td>			   
				  <td width="100" rowspan='3' class="title">사번</td>
				  <td width="100" rowspan='3' class="title">성명</td>				  
			      <td width="100" rowspan='3' class="title">입사일자</td>
			      <td colspan='6' class="title">당기발생연차현황</td>
			      <td colspan='4' class="title">당기말기준 미발생(경과기간)연차</td>			
			      <td colspan='3' class="title"></td>	
			     </tr>
			   <tr>     
				  <td colspan='3' class="title">계속근무기간</td>
				  <td colspan='3' class="title">연차현황</td>	
				  <td colspan='2' class="title">경과기간(미발생연차)</td>	
				  <td colspan='2' class="title">미발생연차 계산기준</td>
				  <td colspan='2' class="title">계산기준</td>
				  <td rowspan='2' width="150" class="title">연차수당계<br>(임원제외)</td>	
				  			  
			    </tr>	
			    <tr>
			      <td width="50" class="title">년</td>
				  <td width="50" class="title">월</td>
			      <td width="50" class="title">일</td>
				  <td width="100" class="title">연차일수</td>
				  <td width="100" class="title">사용</td>		
				  <td width="100" class="title">미사용(소수점=반차)<br>【A】</td>				
				  <td width="50" class="title">월</td>
			      <td width="50" class="title">일</td>
			      <td width="100" class="title">연차계산기준연차일수<br>(주석①)</td>
				  <td width="100" class="title">미발생연차일수<br>(주석②)<br>【B】</td>	
				  <td width="100" class="title">연차일수<br>【A】+【B】</td>
			      <td width="100" class="title">기준급여</td>			  		  
			    </tr>				    		    
			    <%	for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);
					r_cal = (int) (AddUtil.parseDouble((String)ht.get("VACATION"))-AddUtil.parseDouble((String)ht.get("SU"))+AddUtil.parseDouble((String)ht.get("R_VACATION")));
					
					f_amt = AddUtil.parseFloat("1000000") / AddUtil.parseFloat("209")  *r_cal*8;
										
					r_amt = (int) f_amt;
					
					t_amt = t_amt + AddUtil.l_th_rnd(r_amt);
									
					
				%>
			    <tr>
				  <td class="title"><%=i+1%></td>			
				  <td align="center"><%=ht.get("DEPT_NM")%></td>
				  <td align="center"><%=ht.get("ID")%></td>
				  <td align="center"><%=ht.get("USER_NM")%></td>
				  <td align="center"><%=ht.get("ENTER_DT")%></td>
				  <td align="center"><%=ht.get("YEAR")%></td>
				  <td align="center"><%=ht.get("MONTH")%></td>
				  <td align="center"><%=ht.get("DAY")%></td>
				  <td align="center"><%=ht.get("VACATION")%></td>
				  <td align="center"><%=ht.get("SU")%></td>
				  <td align="center"><%= AddUtil.parseDouble((String)ht.get("VACATION"))-AddUtil.parseDouble((String)ht.get("SU")) %></td>
				  <td align="center"><%=ht.get("R_MONTH")%></td>
				  <td align="center"><%=ht.get("R_DAY")%></td>
				  <td align="center"><%=ht.get("VACATION")%></td>
				  <td align="center"><%=ht.get("R_VACATION")%></td>
				  <td align="center"><%=r_cal%></td>
				  <td align="right">1,000,000</td>
				  <td align="right"><%=Util.parseDecimal(AddUtil.l_th_rnd(r_amt))%></td>
			    </tr>
			    <%	}%>	
			    <tr> 
                    <td colspan="16"  class="title">소계(A)</td>
                    <td align="right"><%=Util.parseDecimal(1000000*vt_size) %></td>
                    <td align="right"><%=Util.parseDecimal(t_amt) %></td>
                </tr>
			</table>
		</td>
	</tr>
	
	<tr> 
        <td><div align="left"> <span class=style2>※ 근로기준법</span></div></td>
    </tr>
    <tr> 
        <td>
          <p> ① 사용자는 1년간 80퍼센트 이상 출근한 근로자에게 15일의 유급휴가를 주어야 한다.	<br>
            ② 사용자는 계속하여 근로한 기간이 1년 미만인 근로자 또는 1년간 80퍼센트 미만 출근한 근로자에게 1개월 개근 시 1일의 유급휴가를 주어야 한다.	
          </p>     
        </td>
     </tr>
     <tr> 
        <td><div align="left"> <span class=style2>※ 주석</span></div></td>
    </tr>
    <tr> 
        <td>
          <p> ① 1년만근이 아님으로 가산예정일수(1일 또는 0일)는 반영하지 않음 <br>
            ② 연차계산기준일수/12*미발생연차경과기간의 월, 일수는 만근이 안됐음으로 버림
          </p>     
        </td>
     </tr> 		    
  </table>
</form>
<script language='javascript'>
<!--
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>

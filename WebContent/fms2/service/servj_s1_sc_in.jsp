<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*, acar.user_mng.*, acar.cus_reg.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");

	String off_id 	= request.getParameter("off_id")==null?"":request.getParameter("off_id");
			
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	
	CusReg_Database cr_db = CusReg_Database.getInstance();
		
	Vector vt = cr_db.getServjListNew(s_kd, t_wd, gubun1, gubun4, gubun3, off_id);  
	int vt_size = vt.size();
		
	long total_amt1= 0;
	long total_amt2 = 0;
	long total_amt3= 0;
	long total_amt4 = 0;
	long total_amt5 = 0;
	long total_amt6 = 0;
	long total_amt7 = 0;
	long total_amt8 = 0;
	
	long amt1 = 0;
	long amt2 = 0;
	long amt4 = 0;
	
	long amt5 = 0;
	long amt6 = 0;
			
%>

<html>
<head><title>FMS</title>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">


<body>
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='off_id' 	value='<%=off_id%>'> 
  
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/fms2/service/servj_s1_frame.jsp'>
  <input type='hidden' name='rent_mng_id' value=''>
  <input type='hidden' name='rent_l_cd' value=''>
  <input type='hidden' name='tint_no' value=''>  
  <input type='hidden' name='mode' value=''>    
  <table border="0" cellspacing="0" cellpadding="0" width='800'>
     <tr>
        <td class=line2></td>
    </tr>
	<tr>
	  <td class='line'> 
		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
		  <tr>	
		   	<td  rowspan=2 width='140' class='title'  style='height:70'>거래월</td> 			
			<td colspan="2" class='title'>입출고현황(댓수)</td>					  
			<td colspan="2" class='title' style='height:23'>정비비거래현황</td>			
		  </tr>
		  <tr>
			<td rowspan=2 width='150' class='title'>입고</td>
			<td rowspan=2 width='150' class='title'>출고</td>								  
			<td rowspan=2 width='180' class='title'>청구금액</td>
			<td rowspan=2 width='180' class='title'>지급금액</td>		  			
					  
		  </tr>
		
		</table>
	  </td>
	</tr>

 <%
	if(vt_size > 0)
	{
%>
	<tr>
		<td class='line' >
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(i);
			
			amt1 	= AddUtil.parseLong(String.valueOf(ht.get("IP_CNT")));
			amt2 	= AddUtil.parseLong(String.valueOf(ht.get("CH_CNT")));
			amt4 	= AddUtil.parseLong(String.valueOf(ht.get("TOT_CNT")));
			
			amt5 	= AddUtil.parseLong(String.valueOf(ht.get("TOT_AMT")));
			amt6 	= AddUtil.parseLong(String.valueOf(ht.get("PAY_AMT")));
		
			total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("IP_CNT")));
			total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("CH_CNT")));
			total_amt4 	= total_amt4 + AddUtil.parseLong(String.valueOf(ht.get("TOT_CNT")));
				
			total_amt5 	= total_amt5 + AddUtil.parseLong(String.valueOf(ht.get("TOT_AMT")));
			total_amt6 	= total_amt6 + AddUtil.parseLong(String.valueOf(ht.get("PAY_AMT")));
		
%>
				<tr>
						  
				          <td class='title'>&nbsp;<%=String.valueOf(ht.get("SERV_MM"))%>월</td>			  				  				  				  
				
					<td  width='150' align='right'><%=Util.parseDecimal(amt1)%></td>
					<td  width='150' align='right'><%=Util.parseDecimal(amt2)%></td>		
					<td  width='180' align='right'><%=Util.parseDecimal(amt5)%></td>					
					<td  width='180' align='right'><%=Util.parseDecimal(amt6)%></td>					
				
				</tr>	
<% 		   } %>				
				<tr>
				  <td class='title' style='height:50' >합계</td>											  				  				  
				  <td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt1)%><br><%=Util.parseDecimal(total_amt1/vt_size)%></td>	
				  <td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt2)%><br><%=Util.parseDecimal(total_amt2/vt_size)%></td>	
				  <td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt5)%><br><%=Util.parseDecimal(total_amt5/vt_size)%></td>	
				  <td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt6)%><br><%=Util.parseDecimal(total_amt6/vt_size)%></td>		  				  				  				  
			  				  				  				  				  
				</tr>
			</table>
		</td>
	</tr>	
<%	}                  
	else               
	{
%>                     
	<tr>
		<td class='line' width='370' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td align='center'>
					<%if(t_wd.equals("")){%>검색어를 입력하십시오.
					<%}else{%>등록된 데이타가 없습니다<%}%></td>
				</tr>
			</table>
		</td>
		<td class='line' width='1370'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td>&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
<%                     
	}                  
%>

</table>
</form>

</body>
</html>


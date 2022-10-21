<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="pl_db" scope="page" class="acar.plit.PlItDatabase"/>


<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소

	String st_year = request.getParameter("st_year")==null?"":request.getParameter("st_year");	
	String st_mon = request.getParameter("st_mon")==null?"":request.getParameter("st_mon");
	
			
	Vector vt =  new Vector();
	int vt_size = 0;
	
	long  t_commi = 0;	
	long  t_inc = 0;	
	long  t_res = 0;
	
	int kk = 0;
	
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">

<link rel="stylesheet" href="//code.jquery.com/ui/1.11.2/themes/smoothness/jquery-ui.css">

<style type="text/css">

ul.easytabs li a { 
font-weight:bold;
} 
</style>

<script src="//code.jquery.com/jquery-1.10.2.js"></script>
<script src="//code.jquery.com/ui/1.11.2/jquery-ui.js"></script>

<script language='JavaScript' src='/include/common.js'></script>

<script>

$(function() {
    $( "#tab_example" ).tabs();
});
</script>
</head>
<body>

<form action="" name="form1" method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='st_year' value='<%=st_year%>'>
<input type='hidden' name='st_mon' value='<%=st_mon%>'>

<div id="tab_example" style="width:100%;">
  <ul class="easytabs" >
    <li ><a href="#t1">사업소득자료</a></li>
    <li ><a href="#t2">기타소득자료</a></li>
  
  </ul>
  
  <div id="t1" >
    	<table border="0" cellspacing="0" cellpadding="0" width='100%'>
		  	<tr>
		         <td class=line2></td>
		    </tr>
		                
			 <tr> 
		          <td class=line>
		             <table border="0" cellspacing="1" cellpadding="0" width=100%>
		                <tr> 
		                  <td  class='title'  align='center' width='5%'>연번</td>
		                  <td  class='title' align='center'  width='8%'>주민번호</td>           
		                  <td  class='title' align='center'  width='8%'>신청인</td>                
		                  <td  class='title' align='center'  width='8%'>귀속년월</td>
		                  <td  class='title' align='center'  width='26%'>주소</td>
		                  <td  class='title' align='center'  width='6%'>업종코드</td>               
		                  <td  class='title' align='center'  width='8%'>지급수수료</td>
		                  <td  class='title' align='center'  width='8%'>소득세</td>
		                  <td  class='title' align='center'  width='8%'>주민세</td>
		                  <td  class='title' align='center'  width='8%'>세율</td>
		                  <td  class='title' align='center'  width='10%'>지급일</td>
		                </tr>
					</table>
		    	</td>
			</tr>
		    <tr>
		          <td class=line>
		             <table border=0 cellspacing=1 width=100%>
		<% 
			t_commi = 0;
			t_inc = 0;
			t_res = 0;
		    kk = 0;
			vt = pl_db.Insa_template_list("insa_template3", st_year, AddUtil.addZero(st_mon) );
			vt_size = vt.size();
		
			if(vt_size > 0)	{
				for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);
											
						if ( String.valueOf(ht.get("T_RATE")).equals("3.3") ) {
							t_commi += AddUtil.parseLong((String)ht.get("T_COMMI"));
						//	System.out.println("i=" + i +"| "+ t_commi);
							t_inc += AddUtil.parseLong((String)ht.get("T_INC_AMT"));
							t_res += AddUtil.parseLong((String)ht.get("T_RES_AMT"));
							
							kk++;
		%>             	
		            	<tr>
		            		<td width='5%' align="center"><%=kk%></td>
		            		<td width='8%' align="center"><%=String.valueOf(ht.get("ID")).substring(0,6)%>-<%=String.valueOf(ht.get("ID")).substring(6)%></td>      
		            		<td width='8%' align="center"><%=ht.get("USER_NM")%></td>            		
		            		<td width='8%' align="center"><%=ht.get("P_YEAR")%>년&nbsp;<%=ht.get("P_MON")%>월</td>
		            		<td width='26%' align="center"><%=ht.get("ADDR")%></td>		            	       	
		            		<td width='6%' align="center"><%=ht.get("BIZ_CODE")%></td>
		            		<td width='8%' align="right"><%=AddUtil.parseDecimal(ht.get("T_COMMI"))%></td>     
		            		<td width='8%' align="right"><%=AddUtil.parseDecimal(ht.get("T_INC_AMT"))%></td>     
		            		<td width='8%' align="right"><%=AddUtil.parseDecimal(ht.get("T_RES_AMT"))%></td>  
		            		<td width='8%' align="center"><%=ht.get("T_RATE")%></td>     
		            		<td width='10%' align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("JIGUB_DT")))%></td>        
		            	</tr>
		<%}%>
		<%}  %>
						<tr>
							<td colspan="6" align="center">합계</td>
							<td align="right"><%=AddUtil.parseDecimalLong(t_commi)%> </td>
							<td align="right"><%=AddUtil.parseDecimal(t_inc)%></td>
							<td align="right"><%=AddUtil.parseDecimal(t_res)%></td>
							<td colspan="2" align="center">&nbsp;</td>
						</tr>
		<%}else{%>            	
			            <tr>
		    	            <td colspan=10 align=center height=25>등록된 데이터가 없습니다.</td>
		        	    </tr>
		<%}%>        	    
		            </table>
		        </td>
		    </tr>
		</table>
  </div>
  <div id="t2">
    	<table border="0" cellspacing="0" cellpadding="0" width='100%'>
		  	<tr>
		         <td class=line2></td>
		    </tr>
		                
			 <tr> 
		          <td class=line>
		             <table border="0" cellspacing="1" cellpadding="0" width=100%>
		                <tr> 
		                  <td  class='title'  align='center' width='5%'>연번</td>
		                  <td  class='title' align='center'  width='8%'>주민번호</td>      
		                  <td  class='title' align='center'  width='8%'>신청인</td>                
		                  <td  class='title' align='center'  width='8%'>귀속년월</td>
		                  <td  class='title' align='center'  width='26%'>주소</td>
		                  <td  class='title' align='center'  width='6%'>업종코드</td>               
		                  <td  class='title' align='center'  width='8%'>지급수수료</td>
		                  <td  class='title' align='center'  width='8%'>소득세</td>
		                  <td  class='title' align='center'  width='8%'>주민세</td>
		                  <td  class='title' align='center'  width='8%'>세율</td>
		                  <td  class='title' align='center'  width='10%'>지급일</td>
		                </tr>
					</table>
		    	</td>
			</tr>
		    <tr>
		          <td class=line>
		             <table border=0 cellspacing=1 width=100%>
		<% 
			t_commi = 0;
			t_inc = 0;
			t_res = 0;
			kk = 0;
			
			vt = pl_db.Insa_template_list("insa_template3", st_year, AddUtil.addZero(st_mon) );
			vt_size = vt.size();
		
			if(vt_size > 0)	{
				for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);
											
						if ( !String.valueOf(ht.get("T_RATE")).equals("3.3") ) {
							t_commi += AddUtil.parseLong((String)ht.get("T_COMMI"));
							t_inc += AddUtil.parseLong((String)ht.get("T_INC_AMT"));
							t_res += AddUtil.parseLong((String)ht.get("T_RES_AMT"));
							
							kk++;
		%>             	
		            	<tr>
		            		<td width='5%' align="center"><%=kk%></td>
		            		<td width='8%' align="center"><%=String.valueOf(ht.get("ID")).substring(0,6)%>-<%=String.valueOf(ht.get("ID")).substring(6)%></td>      
		            		<td width='8%' align="center"><%=ht.get("USER_NM")%></td>            		
		            		<td width='8%' align="center"><%=ht.get("P_YEAR")%>년&nbsp;<%=ht.get("P_MON")%>월</td>
		            		<td width='26%' align="center"><%=ht.get("ADDR")%></td>		            	       	
		            		<td width='6%' align="center"><%=ht.get("BIZ_CODE")%></td>
		            		<td width='8%' align="right"><%=AddUtil.parseDecimal(ht.get("T_COMMI"))%></td>     
		            		<td width='8%' align="right"><%=AddUtil.parseDecimal(ht.get("T_INC_AMT"))%></td>     
		            		<td width='8%' align="right"><%=AddUtil.parseDecimal(ht.get("T_RES_AMT"))%></td>  
		            		<td width='8%' align="center"><%=ht.get("T_RATE")%></td>     
		            		<td width='10%' align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("JIGUB_DT")))%></td>        
		            	</tr>
		<%}%>
		<%}%>
						<tr>
							<td colspan="6" align="center">합계</td>
							<td align="right"><%=AddUtil.parseDecimalLong(t_commi)%></td>
							<td align="right"><%=AddUtil.parseDecimal(t_inc)%></td>
							<td align="right"><%=AddUtil.parseDecimal(t_res)%></td>
							<td colspan="2" align="center">&nbsp;</td>
						</tr>
		<%}else{%>            	
			            <tr>
		    	            <td colspan=10 align=center height=25>등록된 데이터가 없습니다.</td>
		        	    </tr>
		<%}%>        	    
		            </table>
		        </td>
		    </tr>
		</table>

	
  </div>
  
</div>


</body>
</html>

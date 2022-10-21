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
	
	int jg_time_t = 0;		
	
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
    <li ><a href="#t1">사원관리</a></li>
    <li ><a href="#t2">휴직관리</a></li>
    <li ><a href="#t3">특근등록</a></li>
    <li ><a href="#t4">급여외수당</a></li>
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
		                  <td  class='title' align='center'  width='10%'>사번</td> 
		                  <td  class='title' align='center'  width='10%'>성명</td>                
		                  <td  class='title' align='center'  width='10%'>변경일</td>
		                  <td  class='title' align='center'  width='6%'>구분</td>		              
		                  <td  class='title' align='center'  width='6%'>코드</td>            
		                  <td  class='title' align='center'  width='28%'>변경내용</td>
		                </tr>
					</table>
		    	</td>
			</tr>
		    <tr>
		          <td class=line>
		             <table border=0 cellspacing=1 width=100%>
		<% 
		
			vt = pl_db.Insa_template_list("insa_template4", st_year, AddUtil.addZero(st_mon));
			vt_size = vt.size();
		
			if(vt_size > 0)	{
				for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);					
		%>              
		            	<tr>
		            		<td width='5%' align="center"><%=i+1%></td>
		            		<td width='10%' align="center"><%=ht.get("ID")%></td>      
		            		<td width='10%' align="center"><%=ht.get("USER_NM")%></td>            		
		            		<td width='10%' align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("T_DT")))%></td>            	
		            		<td width='6%' align="center">
		            		<% if ( String.valueOf(ht.get("T_GUBUN")).equals("01") ) {%>직급
		            		<% } else if ( String.valueOf(ht.get("T_GUBUN")).equals("02") ) {%>부서		            	
		            		<% } else if ( String.valueOf(ht.get("T_GUBUN")).equals("03") ) {%>집전화
		            		<% } else if ( String.valueOf(ht.get("T_GUBUN")).equals("04") ) {%>핸드폰
		            		<% } else if ( String.valueOf(ht.get("T_GUBUN")).equals("05") ) {%>이메일
		            		<% } else if ( String.valueOf(ht.get("T_GUBUN")).equals("06") ) {%>주소 
		            		<% } %>
		            		</td>		            		     	
		            		<td width='6%' align="center"><%=ht.get("T_CODE")%></td>
		            		<td width='28%' align="center"><%=ht.get("T_CONTENT")%></td>
		            	</tr>
			<% } %>
						
		<%}else{%>            	
			            <tr>
		    	            <td colspan=7 align=center height=25>등록된 데이터가 없습니다.</td>
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
		                  <td  class='title' align='center'  width='10%'>사번</td> 
		                  <td  class='title' align='center'  width='10%'>성명</td>                
		                  <td  class='title' align='center'  width='10%'>변경일</td>
		                  <td  class='title' align='center'  width='10%'>구분</td>
		                  <td  class='title' align='center'  width='8%'>시작일</td>   
		                  <td  class='title' align='center'  width='8%'>종료일</td> 		                                     
		                  <td  class='title' align='center'  width='15%'>내용</td>
		                  <td  class='title' align='center'  width='5%'>처리</td>
		                  <td  class='title' align='center'  width='8%'>변경시작일</td>   
		                  <td  class='title' align='center'  width='8%'>변경종료일</td> 		
		                </tr>
					</table>
		    	</td>
			</tr>
		    <tr>
		          <td class=line>
		             <table border=0 cellspacing=1 width=100%>
		<% 
			
			vt = pl_db.Insa_template_list("insa_template6", st_year, AddUtil.addZero(st_mon));
			vt_size = vt.size();
		
			if(vt_size > 0)	{
				for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);					
		%>             	
		            	<tr>
		            		<td width='5%' align="center"><%=i+1%></td>
		            		<td width='10%' align="center"><%=ht.get("ID")%></td>      
		            		<td width='10%' align="center"><%=ht.get("USER_NM")%></td>            		
		            		<td width='10%' align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("T_DT")))%></td>
		            		<td width='10%' align="center">
		            		<% if ( String.valueOf(ht.get("T_GUBUN")).equals("4") ) {%>출산휴가
		            		<% } else if ( String.valueOf(ht.get("T_GUBUN")).equals("5") ) {%>휴직		            	
		            		<% } else if ( String.valueOf(ht.get("T_GUBUN")).equals("8") ) {%>병가
		            		<% } %>
		            		</td>
		            		<td width='8%' align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("START_DAY")))%></td>  
		            		<td width='8%' align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("END_DAY")))%></td>            	
		            		<td width='15%' align="center"><%=ht.get("T_REM")%></td>
		            		<td width='5%' align="center">
		            		<% if ( String.valueOf(ht.get("PROSS")).equals("N") ) {%>신규
		            		<% } else if ( String.valueOf(ht.get("PROSS")).equals("C") ) {%>취소		            	
		            		<% } else if ( String.valueOf(ht.get("PROSS")).equals("M") ) {%>변경
		            		<% } %></td>
		            		<td width='8%' align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("M_START_DAY")))%></td>  
		            		<td width='8%' align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("M_END_DAY")))%></td>       
		            		
		            	</tr>
			<% } %>
						
		<%}else{%>            	
			            <tr>
		    	            <td colspan=11 align=center height=25>등록된 데이터가 없습니다.</td>
		        	    </tr>
		<%}%>        	    
		            </table>
		        </td>
		    </tr>
		</table>
  </div>
  
  <div id="t3">
		<table border="0" cellspacing="0" cellpadding="0" width='100%'>
		  	<tr>
		         <td class=line2></td>
		    </tr>
		                
			 <tr> 
		          <td class=line>
		             <table border="0" cellspacing="1" cellpadding="0" width=100%>
		                <tr> 
		                  <td  class='title' align='center' width='5%'>연번</td>
		                  <td  class='title' align='center'  width='10%'>사번</td> 
		                  <td  class='title' align='center'  width='10%'>성명</td>                
		                  <td  class='title' align='center'  width='10%'>귀속년월</td>
		                  <td  class='title' align='center'  width='15%'>출근시간</td>
		                  <td  class='title' align='center'  width='15%'>퇴근시간</td>               
		                  <td  class='title' align='center'  width='9%'>근로시간</td>
		                </tr>
					</table>
		    	</td>
			</tr>
		    <tr>
		          <td class=line>
		             <table border=0 cellspacing=1 width=100%>
		<% 
			jg_time_t = 0;
			vt = pl_db.Insa_template_list("insa_template1", st_year, AddUtil.addZero(st_mon));
			vt_size = vt.size();
		
			if(vt_size > 0)	{
				for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);
						jg_time_t = jg_time_t + AddUtil.parseInt((String)ht.get("JB_TIME"));
		%>             	
		            	<tr>
		            		<td width='5%' align="center"><%=i+1%></td>
		            		<td width='10%' align="center"><%=ht.get("ID")%></td>      
		            		<td width='10%' align="center"><%=ht.get("USER_NM")%></td>            		
		            		<td width='10%' align="center"><%=ht.get("P_YEAR")%>년&nbsp;<%=ht.get("P_MON")%>월</td>
		            		<td width='15%' align="center"><%=ht.get("START_DAY")%></td>
		            		<td width='15%' align="center"><%=ht.get("END_DAY")%></td>            	
		            		<td width='9%' align="center"><%=ht.get("JB_TIME")%></td>
		            	</tr>
			<% } %>
						<tr>
							<td colspan="6" align="center">합계</td>
							<td align="center"><%=jg_time_t%></td>
						</tr>
		<%}else{%>            	
			            <tr>
		    	            <td colspan=7 align=center height=25>등록된 데이터가 없습니다.</td>
		        	    </tr>
		<%}%>        	    
		            </table>
		        </td>
		    </tr>
		</table>
  </div>
  
  <div id="t4">
  <table border="0" cellspacing="0" cellpadding="0" width='100%'>
		  	<tr>
		         <td class=line2></td>
		    </tr>
		                
			 <tr> 
		          <td class=line>
		             <table border="0" cellspacing="1" cellpadding="0" width=100%>
		                <tr> 
		                  <td  class='title' align='center' width='10%'>연번</td>
		                  <td  class='title' align='center'  width='15%'>구분</td>
		                  <td  class='title' align='center'  width='15%'>사번</td>  
		                  <td  class='title' align='center'  width='15%'>성명</td>  
		                  <td  class='title' align='center'  width='15%'>지급일자</td>  
		                  <td  class='title' align='center'  width='15%'>금액</td>              
		            	  <td  class='title' align='center'  width='15%'>귀속년월<br>(급여반영)</td>             
		                </tr>
					</table>
		    	</td>
			</tr>
		    <tr>
		          <td class=line>
		             <table border=0 cellspacing=1 width=100%>
		<% 
			jg_time_t = 0;
			vt = pl_db.Insa_template_list(st_year, AddUtil.addZero(st_mon));
			vt_size = vt.size();
		
			if(vt_size > 0)	{
				for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);
				//		jg_time_t +=  AddUtil.parseInt((String)ht.get("T_AMT"));						
		%>             	
		            	<tr>
		            		<td width='10%' align="center"><%=i+1%></td>
		            		<td width='15%' align="center">
		            		<% if (String.valueOf(ht.get("T_GUBUN")).equals("합계")) {%><%=ht.get("T_GUBUN")%><% }else {%>&nbsp;<% } %> 
		            		<% if ( String.valueOf(ht.get("T_GUBUN")).equals("30") ) {%>비용캠페인(1군)
		            		<% } else if ( String.valueOf(ht.get("T_GUBUN")).equals("29") ) {%>비용캠페인(2군)
		            		<% } else if ( String.valueOf(ht.get("T_GUBUN")).equals("6") )  {%>제안캠페인
		            		<% } else if ( String.valueOf(ht.get("T_GUBUN")).equals("1") )  {%>채권캠페인
		            		<% } else if ( String.valueOf(ht.get("T_GUBUN")).equals("2") ) {%>영업캠페인
		            		<% } else if ( String.valueOf(ht.get("T_GUBUN")).equals("9") ) {%>제안포상금
		            		<% } %>
		            		</td>
		            		<td align="center"><%=ht.get("ID")%></td> 
		             <% if (String.valueOf(ht.get("ID")).equals("소계")) {%> 
		            		<td align="center">&nbsp;</td> 
		            		<td align="center"><%=ht.get("T_CNT")%>&nbsp;건</td>
		             <% } else { %> 		               	 	
		        		    <td width='15%' align="center"><%=ht.get("USER_NM")%></td> 
			            	<td width='15%' align="center"><%=ht.get("REAL_DT")%></td> 
		            <% } %> 		
		            		<td width='15%' align="right"><%=AddUtil.parseDecimal(ht.get("T_AMT"))%></td>   
		            		<td width='15%' align="center">
		            		<% if (String.valueOf(ht.get("T_GUBUN")).equals("합계") || String.valueOf(ht.get("ID")).equals("소계") ) {%>
		            		&nbsp;<% }else {%>
							<%=st_year%>년&nbsp;<%=AddUtil.addZero(st_mon)%>월<% } %></td> 
		            	</tr>
			<% } %>
				
		<%}else{%>            	
			            <tr>
		    	            <td colspan=7 align=center height=25>등록된 데이터가 없습니다.</td>
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

<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="pl_db" scope="page" class="acar.plit.PlItDatabase"/>


<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������

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
    <li ><a href="#t1">�������</a></li>
    <li ><a href="#t2">��������</a></li>
    <li ><a href="#t3">Ư�ٵ��</a></li>
    <li ><a href="#t4">�޿��ܼ���</a></li>
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
		                  <td  class='title'  align='center' width='5%'>����</td>
		                  <td  class='title' align='center'  width='10%'>���</td> 
		                  <td  class='title' align='center'  width='10%'>����</td>                
		                  <td  class='title' align='center'  width='10%'>������</td>
		                  <td  class='title' align='center'  width='6%'>����</td>		              
		                  <td  class='title' align='center'  width='6%'>�ڵ�</td>            
		                  <td  class='title' align='center'  width='28%'>���泻��</td>
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
		            		<% if ( String.valueOf(ht.get("T_GUBUN")).equals("01") ) {%>����
		            		<% } else if ( String.valueOf(ht.get("T_GUBUN")).equals("02") ) {%>�μ�		            	
		            		<% } else if ( String.valueOf(ht.get("T_GUBUN")).equals("03") ) {%>����ȭ
		            		<% } else if ( String.valueOf(ht.get("T_GUBUN")).equals("04") ) {%>�ڵ���
		            		<% } else if ( String.valueOf(ht.get("T_GUBUN")).equals("05") ) {%>�̸���
		            		<% } else if ( String.valueOf(ht.get("T_GUBUN")).equals("06") ) {%>�ּ� 
		            		<% } %>
		            		</td>		            		     	
		            		<td width='6%' align="center"><%=ht.get("T_CODE")%></td>
		            		<td width='28%' align="center"><%=ht.get("T_CONTENT")%></td>
		            	</tr>
			<% } %>
						
		<%}else{%>            	
			            <tr>
		    	            <td colspan=7 align=center height=25>��ϵ� �����Ͱ� �����ϴ�.</td>
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
		                  <td  class='title'  align='center' width='5%'>����</td>
		                  <td  class='title' align='center'  width='10%'>���</td> 
		                  <td  class='title' align='center'  width='10%'>����</td>                
		                  <td  class='title' align='center'  width='10%'>������</td>
		                  <td  class='title' align='center'  width='10%'>����</td>
		                  <td  class='title' align='center'  width='8%'>������</td>   
		                  <td  class='title' align='center'  width='8%'>������</td> 		                                     
		                  <td  class='title' align='center'  width='15%'>����</td>
		                  <td  class='title' align='center'  width='5%'>ó��</td>
		                  <td  class='title' align='center'  width='8%'>���������</td>   
		                  <td  class='title' align='center'  width='8%'>����������</td> 		
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
		            		<% if ( String.valueOf(ht.get("T_GUBUN")).equals("4") ) {%>����ް�
		            		<% } else if ( String.valueOf(ht.get("T_GUBUN")).equals("5") ) {%>����		            	
		            		<% } else if ( String.valueOf(ht.get("T_GUBUN")).equals("8") ) {%>����
		            		<% } %>
		            		</td>
		            		<td width='8%' align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("START_DAY")))%></td>  
		            		<td width='8%' align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("END_DAY")))%></td>            	
		            		<td width='15%' align="center"><%=ht.get("T_REM")%></td>
		            		<td width='5%' align="center">
		            		<% if ( String.valueOf(ht.get("PROSS")).equals("N") ) {%>�ű�
		            		<% } else if ( String.valueOf(ht.get("PROSS")).equals("C") ) {%>���		            	
		            		<% } else if ( String.valueOf(ht.get("PROSS")).equals("M") ) {%>����
		            		<% } %></td>
		            		<td width='8%' align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("M_START_DAY")))%></td>  
		            		<td width='8%' align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("M_END_DAY")))%></td>       
		            		
		            	</tr>
			<% } %>
						
		<%}else{%>            	
			            <tr>
		    	            <td colspan=11 align=center height=25>��ϵ� �����Ͱ� �����ϴ�.</td>
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
		                  <td  class='title' align='center' width='5%'>����</td>
		                  <td  class='title' align='center'  width='10%'>���</td> 
		                  <td  class='title' align='center'  width='10%'>����</td>                
		                  <td  class='title' align='center'  width='10%'>�ͼӳ��</td>
		                  <td  class='title' align='center'  width='15%'>��ٽð�</td>
		                  <td  class='title' align='center'  width='15%'>��ٽð�</td>               
		                  <td  class='title' align='center'  width='9%'>�ٷνð�</td>
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
		            		<td width='10%' align="center"><%=ht.get("P_YEAR")%>��&nbsp;<%=ht.get("P_MON")%>��</td>
		            		<td width='15%' align="center"><%=ht.get("START_DAY")%></td>
		            		<td width='15%' align="center"><%=ht.get("END_DAY")%></td>            	
		            		<td width='9%' align="center"><%=ht.get("JB_TIME")%></td>
		            	</tr>
			<% } %>
						<tr>
							<td colspan="6" align="center">�հ�</td>
							<td align="center"><%=jg_time_t%></td>
						</tr>
		<%}else{%>            	
			            <tr>
		    	            <td colspan=7 align=center height=25>��ϵ� �����Ͱ� �����ϴ�.</td>
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
		                  <td  class='title' align='center' width='10%'>����</td>
		                  <td  class='title' align='center'  width='15%'>����</td>
		                  <td  class='title' align='center'  width='15%'>���</td>  
		                  <td  class='title' align='center'  width='15%'>����</td>  
		                  <td  class='title' align='center'  width='15%'>��������</td>  
		                  <td  class='title' align='center'  width='15%'>�ݾ�</td>              
		            	  <td  class='title' align='center'  width='15%'>�ͼӳ��<br>(�޿��ݿ�)</td>             
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
		            		<% if (String.valueOf(ht.get("T_GUBUN")).equals("�հ�")) {%><%=ht.get("T_GUBUN")%><% }else {%>&nbsp;<% } %> 
		            		<% if ( String.valueOf(ht.get("T_GUBUN")).equals("30") ) {%>���ķ����(1��)
		            		<% } else if ( String.valueOf(ht.get("T_GUBUN")).equals("29") ) {%>���ķ����(2��)
		            		<% } else if ( String.valueOf(ht.get("T_GUBUN")).equals("6") )  {%>����ķ����
		            		<% } else if ( String.valueOf(ht.get("T_GUBUN")).equals("1") )  {%>ä��ķ����
		            		<% } else if ( String.valueOf(ht.get("T_GUBUN")).equals("2") ) {%>����ķ����
		            		<% } else if ( String.valueOf(ht.get("T_GUBUN")).equals("9") ) {%>���������
		            		<% } %>
		            		</td>
		            		<td align="center"><%=ht.get("ID")%></td> 
		             <% if (String.valueOf(ht.get("ID")).equals("�Ұ�")) {%> 
		            		<td align="center">&nbsp;</td> 
		            		<td align="center"><%=ht.get("T_CNT")%>&nbsp;��</td>
		             <% } else { %> 		               	 	
		        		    <td width='15%' align="center"><%=ht.get("USER_NM")%></td> 
			            	<td width='15%' align="center"><%=ht.get("REAL_DT")%></td> 
		            <% } %> 		
		            		<td width='15%' align="right"><%=AddUtil.parseDecimal(ht.get("T_AMT"))%></td>   
		            		<td width='15%' align="center">
		            		<% if (String.valueOf(ht.get("T_GUBUN")).equals("�հ�") || String.valueOf(ht.get("ID")).equals("�Ұ�") ) {%>
		            		&nbsp;<% }else {%>
							<%=st_year%>��&nbsp;<%=AddUtil.addZero(st_mon)%>��<% } %></td> 
		            	</tr>
			<% } %>
				
		<%}else{%>            	
			            <tr>
		    	            <td colspan=7 align=center height=25>��ϵ� �����Ͱ� �����ϴ�.</td>
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

<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.parking.*"%>
<jsp:useBean id="pk_db" scope="page" class="acar.parking.ParkIODatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String st_year = request.getParameter("st_year")==null?"":request.getParameter("st_year");
	String st_mon = request.getParameter("st_mon")==null?"":request.getParameter("st_mon");

	if(st_mon.equals("1")){
		st_mon = "01";
	}else if(st_mon.equals("2")){
		st_mon = "02";
	}else if(st_mon.equals("3")){
		st_mon = "03";
	}else if(st_mon.equals("4")){
		st_mon = "04";
	}else if(st_mon.equals("5")){
		st_mon = "05";
	}else if(st_mon.equals("6")){
		st_mon = "06";
	}else if(st_mon.equals("7")){
		st_mon = "07";
	}else if(st_mon.equals("8")){
		st_mon = "08";
	}else if(st_mon.equals("9")){
		st_mon = "09";
	}		
		
	Vector park_s = new Vector();
	park_s = pk_db.Park_subOffice_list(st_year, st_mon, "����");
	int park_s_size = park_s.size();
	
	Vector park_b = new Vector();
	park_b = pk_db.Park_subOffice_list(st_year, st_mon, "�λ�");
	int park_b_size = park_b.size();

	Vector park_k = new Vector();
	park_k = pk_db.Park_subOffice_list(st_year, st_mon, "�뱸");
	int park_k_size = park_k.size();

	Vector park_d = new Vector();
	park_d = pk_db.Park_subOffice_list(st_year, st_mon, "����");
	int park_d_size = park_d.size();

	Vector park_g = new Vector();
	park_g = pk_db.Park_subOffice_list(st_year, st_mon, "����");
	int park_g_size = park_g.size();	
	
   int cnt[]	 	= new int[31];
   int t_cnt[]	 	= new int[31];
   int t_cnt2[]	 	= new int[31];
   int arr[]		= new int[31];
	

%>
<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

	/* Title ���� */
	function setupEvents(){
			window.onscroll = moveTitle ;
			window.onresize = moveTitle ; 
	}	
	function moveTitle(){
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    	    
	}
	function init(){		
		setupEvents();
	}
		
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' action='' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>

<table border="0" cellspacing="0" cellpadding="0" width=1740>
    <tr> 
        <td class=h></td>
    </tr>
    <tr>
	    <td class='line'>			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td class='title' width="150">������</td>
					<td class='title' width="250">����</td>
					<td class='title' width="100">����</td>
					<td class='title' width="40">1��</td>
					<td class='title' width="40">2��</td>
					<td class='title' width="40">3��</td>								
					<td class='title' width="40">4��</td>
					<td class='title' width="40">5��</td>
					<td class='title' width="40">6��</td>
					<td class='title' width="40">7��</td>
					<td class='title' width="40">8��</td>
					<td class='title' width="40">9��</td>
					<td class='title' width="40">10��</td>
					<td class='title' width="40">11��</td>
					<td class='title' width="40">12��</td>
					<td class='title' width="40">13��</td>								
					<td class='title' width="40">14��</td>
					<td class='title' width="40">15��</td>
					<td class='title' width="40">16��</td>
					<td class='title' width="40">17��</td>
					<td class='title' width="40">18��</td>
					<td class='title' width="40">19��</td>
					<td class='title' width="40">20��</td>
					<td class='title' width="40">21��</td>
					<td class='title' width="40">22��</td>
					<td class='title' width="40">23��</td>								
					<td class='title' width="40">24��</td>
					<td class='title' width="40">25��</td>
					<td class='title' width="40">26��</td>
					<td class='title' width="40">27��</td>
					<td class='title' width="40">28��</td>
					<td class='title' width="40">29��</td>
					<td class='title' width="40">30��</td>
					<td class='title' width="40">31��</td>
				</tr>
				
					
				<tr>
					<td align="center" rowspan=""  width="150">����<br>(����������)</td>
					<td colspan="33" class='line' width=1590>
						 <table border="0" cellspacing="1" cellpadding="0" >
			<%								 
				 	for(int i=0; i <31; i++){
						cnt[i] = 0;
						t_cnt[i] = 0;
					}
					
					for(int i=0; i < park_s_size; i++){
						
						Hashtable pt = (Hashtable)park_s.elementAt(i);
						//�Ұ�
						for(int h = 1 ; h <= 31 ; h++){
    	    						cnt[h -1] +=  AddUtil.parseLong(String.valueOf(pt.get("D"+h)));	
    	    						t_cnt[h -1] +=  AddUtil.parseLong(String.valueOf(pt.get("D"+h)));	
						}				
				%>	
						<%
							if(pt.get("GUBUN").equals("�Ű�Ȯ��")){
								for(int k = 1 ; k <= 31 ; k++){
									arr[k-1] = AddUtil.parseInt(String.valueOf(pt.get("D"+k)));
								}
							}else{	
						%>
							<tr>
								  <td align="center" width="247"><%=pt.get("GUBUN")%><br><%if(pt.get("GUBUN").equals("������")){%>(������ ��/���ó�� ���� ���� ���)<%}else if(pt.get("GUBUN").equals("����")){%>(��ǰ�غ��Ȳ���� �԰�ó��)<%}else if(pt.get("GUBUN").equals("����")){%>(������ ��/��� ó�� ���� ���� ���)<%}else if(pt.get("GUBUN").equals("�Ű�")){%>(�Ű����з�����/�Ű�Ȯ������)<%}%></td>
								  <td align="center" width="100"><%if(!pt.get("GUBUN").equals("����") && !pt.get("GUBUN").equals("�Ű�") ){%>�����帶�� <%} else {%> ���� <%}%></td>
								<%for(int k = 1 ; k <= 31 ; k++){%>
                		     		<td  align="right" width="40">
									<% if(pt.get("GUBUN").equals("�Ű�")){%>
										<%=arr[k-1]%>/<%=  pt.get("D"+ k) %><%-- (<%=arr[k-1] + AddUtil.parseInt(String.valueOf(pt.get("D"+k))) %>) --%>&nbsp;
                		     		<%}else{ %>					
                		     			<%=  pt.get("D"+ k) %>&nbsp;
									<%} %>	                		     		
                		     		</td>
								<%}%>			
							</tr>
						<%} %>	
					<%}%>
						</table>
					</td>
				</tr>
				
				<tr>
					   <td class='title'></td>
					   <td class='title' >�Ұ�</td>
					   <td class='title'></td>
					<%for(int k = 0 ; k < 31 ; k++){%>
                   <td class='title'><%=AddUtil.parseDecimal(cnt[k]) %>&nbsp;</td>					
					<%}%>				
				</tr>
				<!-- �Ұ�2(�Ұ�-�԰���)�߰� (2018.01.29) -->
				<tr>
				   <td class='title'></td>
				   <td class='title' >�Ұ�2</td>
				   <td class='title'>�Ұ�-�԰���</td>
				   <%for(int k = 0 ; k < 31 ; k++){%>
                   <td class='title'>
                      	<%if(park_s_size>0){ %> 
                   			<%for(int i=park_s_size-1; i < park_s_size; i++){
								Hashtable pt = (Hashtable)park_s.elementAt(i);
								int cnt2 = cnt[k] - Integer.parseInt((String)pt.get("D"+ (k+1)));
								t_cnt2[k] += cnt2;
							%>
                   		 	 <%=AddUtil.parseDecimal(cnt2) %>&nbsp;
                   			<%} %>
                   	  	<%} %>
                   </td>					
				   <%}%>				
				</tr>
				
				<tr>
					<td align="center" rowspan="">�λ�<br>(����������)</td>
					<td colspan="33" class='line' width=1590>
						 <table border="0" cellspacing="1" cellpadding="0" >			
			<%
												 
				 	for(int i=0; i <31; i++){
				 			cnt[i] = 0;
					}
					
					for(int i=0; i < park_b_size; i++){
																	
						Hashtable pt = (Hashtable)park_b.elementAt(i); 		
												
						//�Ұ�
						for(int h = 1 ; h <= 31 ; h++){
    	    						cnt[h -1] +=  AddUtil.parseLong(String.valueOf(pt.get("D"+h)));	
    	    						t_cnt[h -1] +=  AddUtil.parseLong(String.valueOf(pt.get("D"+h)));	
						}				
				%>		
					<%
						if(pt.get("GUBUN").equals("�Ű�Ȯ��")){
							for(int k = 1 ; k <= 31 ; k++){
								arr[k-1] = AddUtil.parseInt(String.valueOf(pt.get("D"+k)));
							}
						}else{	
					%>		
							<tr>
								<td align="center" width="247"><%=pt.get("GUBUN")%><br><%if(pt.get("GUBUN").equals("������")){%>(������ ��/���ó�� ���� ���� ���)<%}else if(pt.get("GUBUN").equals("����")){%>(��ǰ�غ��Ȳ���� �԰�ó��)<%}else if(pt.get("GUBUN").equals("����")){%>(������ ��/��� ó�� ���� ���� ���)<%}else if(pt.get("GUBUN").equals("�Ű�")){%>(�Ű����з�����/�Ű�Ȯ������)<%}%></td>
								<td align="center" width="100"><%if(!pt.get("GUBUN").equals("����") && !pt.get("GUBUN").equals("�Ű�") ){%>�����帶�� <%} else {%> ���� <%}%></td>
								<%for(int k = 1 ; k <= 31 ; k++){%>
                		     	<td  align="right" width="40">
                		     		<% if(pt.get("GUBUN").equals("�Ű�")){%>
										<%=arr[k-1]%>/<%=  pt.get("D"+ k) %><%-- (<%=arr[k-1] + AddUtil.parseInt(String.valueOf(pt.get("D"+k))) %>) --%>&nbsp;
                		     		<%}else{ %>					
                		     			<%=  pt.get("D"+ k) %>&nbsp;
									<%} %>
                		     </td>					
								<%}%>	
							</tr>
					<%  }%>	
				<%  }%>
						</table>
					</td>
				</tr>
				
				<tr>
					   <td class='title'></td>
				    	<td class='title' >�Ұ�</td>
						<td class='title'></td>
					<%for(int k = 0 ; k < 31 ; k++){%>
                   <td class='title'><%=AddUtil.parseDecimal(cnt[k]) %>&nbsp;</td>					
					<%}%>					
				</tr>
				<!-- �Ұ�2(�Ұ�-�԰���)�߰� (2018.01.29) -->
				<tr>
				   <td class='title'></td>
				   <td class='title' >�Ұ�2</td>
				   <td class='title'>�Ұ�-�԰���</td>
				   <%for(int k = 0 ; k < 31 ; k++){%>
                   <td class='title'>
                   		<%if(park_b_size>0){ %> 
                   			<%for(int i=park_b_size-1; i < park_b_size; i++){
								Hashtable pt = (Hashtable)park_b.elementAt(i);
								int cnt2 = cnt[k] - Integer.parseInt((String)pt.get("D"+ (k+1)));
								t_cnt2[k] += cnt2;
							%>
                   		 	 <%=AddUtil.parseDecimal(cnt2) %>&nbsp;
                   			<%} %>
                   		<%} %>	
                   </td>					
				   <%}%>				
				</tr>
				<tr>
					<td align="center" rowspan="">�뱸<br>(��������)</td>
					<td colspan="33" class='line' width=1590>
						 <table border="0" cellspacing="1" cellpadding="0" >
				 <%
												 
				 	for(int i=0; i <31; i++){
				 			cnt[i] = 0;
					}
					
					for(int i=0; i < park_k_size; i++){
																	
						Hashtable pt = (Hashtable)park_k.elementAt(i); 		
												
						//�Ұ�
						for(int h = 1 ; h <= 31 ; h++){
    	    						cnt[h -1] +=  AddUtil.parseLong(String.valueOf(pt.get("D"+h)));	
    	    						t_cnt[h -1] +=  AddUtil.parseLong(String.valueOf(pt.get("D"+h)));	
						}					
				%>	
					<%
						if(pt.get("GUBUN").equals("�Ű�Ȯ��")){
							for(int k = 1 ; k <= 31 ; k++){
								arr[k-1] = AddUtil.parseInt(String.valueOf(pt.get("D"+k)));
							}
						}else{	
					%>
							<tr>
								<td align="center" width="247"><%=pt.get("GUBUN")%><br><%if(pt.get("GUBUN").equals("������")){%>(������ ��/���ó�� ���� ���� ���)<%}else if(pt.get("GUBUN").equals("����")){%>(��ǰ�غ��Ȳ���� �԰�ó��)<%}else if(pt.get("GUBUN").equals("����")){%>(������ ��/��� ó�� ���� ���� ���)<%}else if(pt.get("GUBUN").equals("�Ű�")){%>(�Ű����з�����/�Ű�Ȯ������)<%}%></td>
								<td align="center" width="100"><%if(!pt.get("GUBUN").equals("����") && !pt.get("GUBUN").equals("�Ű�") ){%>�����帶�� <%} else {%> ���� <%}%></td>
								<%for(int k = 1 ; k <= 31 ; k++){%>
	                		    <td  align="right" width="40">
	                		     	<% if(pt.get("GUBUN").equals("�Ű�")){%>
										<%=arr[k-1]%>/<%=  pt.get("D"+ k) %><%-- (<%=arr[k-1] + AddUtil.parseInt(String.valueOf(pt.get("D"+k))) %>) --%>&nbsp;
        		     				<%}else{ %>					
      		     						<%=pt.get("D"+ k) %>&nbsp;
									<%} %>
	                		    </td>					
								<%}%>								
							</tr>
						<%}%>
					<%}%>
						</table>
					</td>
				</tr>
				
				<tr>
					<td class='title'></td>
					<td class='title' >�Ұ�</td>
					<td class='title'></td>
					<%for(int k = 0 ; k < 31 ; k++){%>
                   <td class='title'><%=AddUtil.parseDecimal(cnt[k]) %>&nbsp;</td>
                   		<%t_cnt2[k] += cnt[k]; %>					
					<%}%>				
				</tr>
				<!-- �Ұ�2(�Ұ�-�԰���)�߰� (2018.01.29) -->
				<%-- <tr>
				   <td class='title'></td>
				   <td class='title' >�Ұ�2</td>
				   <td class='title'>�Ұ�-�԰���</td>
				   <%for(int k = 0 ; k < 31 ; k++){%>
                   <td class='title'>
                   		<%if(park_k_size>0){ %> 
                   			<%for(int i=park_k_size-1; i < park_k_size; i++){
								Hashtable pt = (Hashtable)park_k.elementAt(i);
								int cnt2 = cnt[k] - Integer.parseInt((String)pt.get("D"+ (k+1)));
								t_cnt2[k] += cnt2;
							%>
                   		 	 <%=AddUtil.parseDecimal(cnt2) %>&nbsp;
                   			<%} %>
                   		<%} %>
                   </td>					
					<%}%>				
				</tr> --%>
				<tr>
					<td align="center" rowspan="">����<br>(1�ޱ�ȣ, ����ī��ũ)</td>
					<td colspan="33" class='line' width=1590>
						 <table border="0" cellspacing="1" cellpadding="0" >
					 <%
												 
				 	for(int i=0; i <31; i++){
				 			cnt[i] = 0;
					}
					
					for(int i=0; i < park_d_size; i++){
																	
						Hashtable pt = (Hashtable)park_d.elementAt(i); 		
												
						//�Ұ�
						for(int h = 1 ; h <= 31 ; h++){
    	    						cnt[h -1] +=  AddUtil.parseLong(String.valueOf(pt.get("D"+h)));	
    	    						t_cnt[h -1] +=  AddUtil.parseLong(String.valueOf(pt.get("D"+h)));	
						}					
				%>	
					 <%
						if(pt.get("GUBUN").equals("�Ű�Ȯ��")){
							for(int k = 1 ; k <= 31 ; k++){
								arr[k-1] = AddUtil.parseInt(String.valueOf(pt.get("D"+k)));
							}
						}else{	
					 %>
							<tr>
								<td align="center" width="247"><%=pt.get("GUBUN")%><br><%if(pt.get("GUBUN").equals("������")){%>(������ ��/���ó�� ���� ���� ���)<%}else if(pt.get("GUBUN").equals("����")){%>(��ǰ�غ��Ȳ���� �԰�ó��)<%}else if(pt.get("GUBUN").equals("����")){%>(������ ��/��� ó�� ���� ���� ���)<%}else if(pt.get("GUBUN").equals("�Ű�")){%>(�Ű����з�����/�Ű�Ȯ������)<%}%></td>
								<td align="center" width="100"><%if(!pt.get("GUBUN").equals("����") && !pt.get("GUBUN").equals("�Ű�") ){%>�����帶�� <%} else {%> ���� <%}%></td>
							<%for(int k = 1 ; k <= 31 ; k++){%>
                		     <td  align="right" width="40">
                		     	<%if(pt.get("GUBUN").equals("�Ű�")){%>
									<%=arr[k-1]%>/<%=  pt.get("D"+ k) %><%-- (<%=arr[k-1] + AddUtil.parseInt(String.valueOf(pt.get("D"+k))) %>) --%>&nbsp;
   		     					<%}else{ %>					
   		     						<%=pt.get("D"+ k) %>&nbsp;
								<%} %>
                		     </td>					
							<%}%>							
							</tr>
						<%}%>
					<%}%>
						</table>
					</td>
				</tr>
				
				<tr>
					  <td class='title'></td>
					  <td class='title' >�Ұ�</td>
					  <td class='title'></td>
					<%for(int k = 0 ; k < 31 ; k++){%>
                   <td class='title'><%=AddUtil.parseDecimal(cnt[k]) %>&nbsp;</td>					
					<%}%>						
				</tr>
				<!-- �Ұ�2(�Ұ�-�԰���)�߰� (2018.01.29) -->
				<tr>
				   <td class='title'></td>
				   <td class='title' >�Ұ�2</td>
				   <td class='title'>�Ұ�-�԰���</td>
				   <%for(int k = 0 ; k < 31 ; k++){%>
                   <td class='title'>
                   		<%if(park_d_size>0){ %> 
                   			<%for(int i=park_d_size-1; i < park_d_size; i++){
								Hashtable pt = (Hashtable)park_d.elementAt(i);
								int cnt2 = cnt[k] - Integer.parseInt((String)pt.get("D"+ (k+1)));
								t_cnt2[k] += cnt2;
							%>
                  	   	 	 <%=AddUtil.parseDecimal(cnt2) %>&nbsp;
                  			<%} %>
                  		<%} %>
                   </td>					
					<%}%>				
				</tr>
				<tr>
					<td align="center" rowspan="">����<br>(��1��)</td>
					<td colspan="33" class='line' width=1590>
						 <table border="0" cellspacing="1" cellpadding="0" >
						 	 <%				 
				 	for(int i=0; i <31; i++){
				 			cnt[i] = 0;
					}
					
					for(int i=0; i < park_g_size; i++){
																	
						Hashtable pt = (Hashtable)park_g.elementAt(i); 		
												
						//�Ұ�
						for(int h = 1 ; h <= 31 ; h++){
    	    						cnt[h -1] +=  AddUtil.parseLong(String.valueOf(pt.get("D"+h)));	
    	    						t_cnt[h -1] +=  AddUtil.parseLong(String.valueOf(pt.get("D"+h)));	
						}					
				%>					
					<%
						if(pt.get("GUBUN").equals("�Ű�Ȯ��")){
							for(int k = 1 ; k <= 31 ; k++){
								arr[k-1] = AddUtil.parseInt(String.valueOf(pt.get("D"+k)));
							}
						}else{	
					%>
							<tr>
								<td align="center" width="247"><%=pt.get("GUBUN")%><br><%if(pt.get("GUBUN").equals("������")){%>(������ ��/���ó�� ���� ���� ���)<%}else if(pt.get("GUBUN").equals("����")){%>(��ǰ�غ��Ȳ���� �԰�ó��)<%}else if(pt.get("GUBUN").equals("����")){%>(������ ��/��� ó�� ���� ���� ���)<%}else if(pt.get("GUBUN").equals("�Ű�")){%>(�Ű����з�����/�Ű�Ȯ������)<%}%></td>
								<td align="center" width="100"><%if(!pt.get("GUBUN").equals("����") && !pt.get("GUBUN").equals("�Ű�") ){%>�����帶�� <%} else {%> ���� <%}%></td>
							<%for(int k = 1 ; k <= 31 ; k++){%>
                		     	<td  align="right" width="40">
               		     		<%if(pt.get("GUBUN").equals("�Ű�")){%>
									<%=arr[k-1]%>/<%=  pt.get("D"+ k) %><%-- (<%=arr[k-1] + AddUtil.parseInt(String.valueOf(pt.get("D"+k))) %>) --%>&nbsp;
               		     		<%}else{ %>					
               		     			<%=pt.get("D"+ k) %>&nbsp;
								<%} %>
                		     	</td>					
							<%}%>	
							</tr>
						<%}%>
					<%}%>
						</table>
					</td>
				</tr>
				<tr>
					<td class='title'></td>
					<td class='title' >�Ұ�</td>
					<td class='title'></td>
					<%for(int k = 0 ; k < 31 ; k++){%>
                   <td class='title'><%=AddUtil.parseDecimal(cnt[k]) %>&nbsp;
                   		<%t_cnt2[k] += cnt[k]; %>
                   </td>					
					<%}%>				
				</tr>
				<!-- �Ұ�2(�Ұ�-�԰���)�߰� (2018.01.29) -->
				<%-- <tr>
				   <td class='title'></td>
				   <td class='title' >�Ұ�2</td>
				   <td class='title'>�Ұ�-�԰���</td>
				   <%for(int k = 0 ; k < 31 ; k++){%>
                   <td class='title'>
                   		<%if(park_g_size>0){ %> 
                   			<%for(int i=park_g_size-1; i < park_g_size; i++){
								 Hashtable pt = (Hashtable)park_g.elementAt(i);
								 int cnt2 = cnt[k] - Integer.parseInt((String)pt.get("D"+ (k+1)));
								 t_cnt2[k] += cnt2;
							%>
                  		  	  <%=AddUtil.parseDecimal(cnt2) %>&nbsp;
                   			<%} %>
                   		<%} %>
                   </td>					
				   <%}%>				
				</tr> --%>
				<tr>
					<td class='title' > </td>
					<td class='title' >�հ� </td>
					<td class='title' width="100"></td>
					<%for(int k = 0 ; k < 31 ; k++){%>
                    <td class='title'><%=AddUtil.parseDecimal(t_cnt[k]) %>&nbsp;</td>					
					<%}%>
				</tr>
				<!-- �հ�2(�Ұ�2 total)�߰� (2018.01.29) -->
				<tr>
					<td class='title' > </td>
					<td class='title' >�հ�2 </td>
					<td class='title' width="100">�հ�-�԰���</td>
					<%for(int k = 0 ; k < 31 ; k++){%>
                    <td class='title'><%=AddUtil.parseDecimal(t_cnt2[k]) %>&nbsp;</td>					
					<%}%>
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>
</body>
</html>

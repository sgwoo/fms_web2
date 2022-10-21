<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.parking.*"%>
<jsp:useBean id="pk_db" scope="page" class="acar.parking.ParkIODatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
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
	park_s = pk_db.Park_subOffice_list(st_year, st_mon, "본사");
	int park_s_size = park_s.size();
	
	Vector park_b = new Vector();
	park_b = pk_db.Park_subOffice_list(st_year, st_mon, "부산");
	int park_b_size = park_b.size();

	Vector park_k = new Vector();
	park_k = pk_db.Park_subOffice_list(st_year, st_mon, "대구");
	int park_k_size = park_k.size();

	Vector park_d = new Vector();
	park_d = pk_db.Park_subOffice_list(st_year, st_mon, "대전");
	int park_d_size = park_d.size();

	Vector park_g = new Vector();
	park_g = pk_db.Park_subOffice_list(st_year, st_mon, "광주");
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

	/* Title 고정 */
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
					<td class='title' width="150">차고지</td>
					<td class='title' width="250">구분</td>
					<td class='title' width="100">참고</td>
					<td class='title' width="40">1일</td>
					<td class='title' width="40">2일</td>
					<td class='title' width="40">3일</td>								
					<td class='title' width="40">4일</td>
					<td class='title' width="40">5일</td>
					<td class='title' width="40">6일</td>
					<td class='title' width="40">7일</td>
					<td class='title' width="40">8일</td>
					<td class='title' width="40">9일</td>
					<td class='title' width="40">10일</td>
					<td class='title' width="40">11일</td>
					<td class='title' width="40">12일</td>
					<td class='title' width="40">13일</td>								
					<td class='title' width="40">14일</td>
					<td class='title' width="40">15일</td>
					<td class='title' width="40">16일</td>
					<td class='title' width="40">17일</td>
					<td class='title' width="40">18일</td>
					<td class='title' width="40">19일</td>
					<td class='title' width="40">20일</td>
					<td class='title' width="40">21일</td>
					<td class='title' width="40">22일</td>
					<td class='title' width="40">23일</td>								
					<td class='title' width="40">24일</td>
					<td class='title' width="40">25일</td>
					<td class='title' width="40">26일</td>
					<td class='title' width="40">27일</td>
					<td class='title' width="40">28일</td>
					<td class='title' width="40">29일</td>
					<td class='title' width="40">30일</td>
					<td class='title' width="40">31일</td>
				</tr>
				
					
				<tr>
					<td align="center" rowspan=""  width="150">본사<br>(영남주차장)</td>
					<td colspan="33" class='line' width=1590>
						 <table border="0" cellspacing="1" cellpadding="0" >
			<%								 
				 	for(int i=0; i <31; i++){
						cnt[i] = 0;
						t_cnt[i] = 0;
					}
					
					for(int i=0; i < park_s_size; i++){
						
						Hashtable pt = (Hashtable)park_s.elementAt(i);
						//소계
						for(int h = 1 ; h <= 31 ; h++){
    	    						cnt[h -1] +=  AddUtil.parseLong(String.valueOf(pt.get("D"+h)));	
    	    						t_cnt[h -1] +=  AddUtil.parseLong(String.valueOf(pt.get("D"+h)));	
						}				
				%>	
						<%
							if(pt.get("GUBUN").equals("매각확정")){
								for(int k = 1 ; k <= 31 ; k++){
									arr[k-1] = AddUtil.parseInt(String.valueOf(pt.get("D"+k)));
								}
							}else{	
						%>
							<tr>
								  <td align="center" width="247"><%=pt.get("GUBUN")%><br><%if(pt.get("GUBUN").equals("예비차")){%>(보유차 입/출고처리 후의 차량 대수)<%}else if(pt.get("GUBUN").equals("신차")){%>(납품준비상황에서 입고처리)<%}else if(pt.get("GUBUN").equals("고객차")){%>(고객차량 입/출고 처리 후의 차량 대수)<%}else if(pt.get("GUBUN").equals("매각")){%>(매각대상분류차량/매각확정차량)<%}%></td>
								  <td align="center" width="100"><%if(!pt.get("GUBUN").equals("신차") && !pt.get("GUBUN").equals("매각") ){%>주차장마감 <%} else {%> 별도 <%}%></td>
								<%for(int k = 1 ; k <= 31 ; k++){%>
                		     		<td  align="right" width="40">
									<% if(pt.get("GUBUN").equals("매각")){%>
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
					   <td class='title' >소계</td>
					   <td class='title'></td>
					<%for(int k = 0 ; k < 31 ; k++){%>
                   <td class='title'><%=AddUtil.parseDecimal(cnt[k]) %>&nbsp;</td>					
					<%}%>				
				</tr>
				<!-- 소계2(소계-입고대기)추가 (2018.01.29) -->
				<tr>
				   <td class='title'></td>
				   <td class='title' >소계2</td>
				   <td class='title'>소계-입고대기</td>
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
					<td align="center" rowspan="">부산<br>(조양주차장)</td>
					<td colspan="33" class='line' width=1590>
						 <table border="0" cellspacing="1" cellpadding="0" >			
			<%
												 
				 	for(int i=0; i <31; i++){
				 			cnt[i] = 0;
					}
					
					for(int i=0; i < park_b_size; i++){
																	
						Hashtable pt = (Hashtable)park_b.elementAt(i); 		
												
						//소계
						for(int h = 1 ; h <= 31 ; h++){
    	    						cnt[h -1] +=  AddUtil.parseLong(String.valueOf(pt.get("D"+h)));	
    	    						t_cnt[h -1] +=  AddUtil.parseLong(String.valueOf(pt.get("D"+h)));	
						}				
				%>		
					<%
						if(pt.get("GUBUN").equals("매각확정")){
							for(int k = 1 ; k <= 31 ; k++){
								arr[k-1] = AddUtil.parseInt(String.valueOf(pt.get("D"+k)));
							}
						}else{	
					%>		
							<tr>
								<td align="center" width="247"><%=pt.get("GUBUN")%><br><%if(pt.get("GUBUN").equals("예비차")){%>(보유차 입/출고처리 후의 차량 대수)<%}else if(pt.get("GUBUN").equals("신차")){%>(납품준비상황에서 입고처리)<%}else if(pt.get("GUBUN").equals("고객차")){%>(고객차량 입/출고 처리 후의 차량 대수)<%}else if(pt.get("GUBUN").equals("매각")){%>(매각대상분류차량/매각확정차량)<%}%></td>
								<td align="center" width="100"><%if(!pt.get("GUBUN").equals("신차") && !pt.get("GUBUN").equals("매각") ){%>주차장마감 <%} else {%> 별도 <%}%></td>
								<%for(int k = 1 ; k <= 31 ; k++){%>
                		     	<td  align="right" width="40">
                		     		<% if(pt.get("GUBUN").equals("매각")){%>
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
				    	<td class='title' >소계</td>
						<td class='title'></td>
					<%for(int k = 0 ; k < 31 ; k++){%>
                   <td class='title'><%=AddUtil.parseDecimal(cnt[k]) %>&nbsp;</td>					
					<%}%>					
				</tr>
				<!-- 소계2(소계-입고대기)추가 (2018.01.29) -->
				<tr>
				   <td class='title'></td>
				   <td class='title' >소계2</td>
				   <td class='title'>소계-입고대기</td>
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
					<td align="center" rowspan="">대구<br>(성서현대)</td>
					<td colspan="33" class='line' width=1590>
						 <table border="0" cellspacing="1" cellpadding="0" >
				 <%
												 
				 	for(int i=0; i <31; i++){
				 			cnt[i] = 0;
					}
					
					for(int i=0; i < park_k_size; i++){
																	
						Hashtable pt = (Hashtable)park_k.elementAt(i); 		
												
						//소계
						for(int h = 1 ; h <= 31 ; h++){
    	    						cnt[h -1] +=  AddUtil.parseLong(String.valueOf(pt.get("D"+h)));	
    	    						t_cnt[h -1] +=  AddUtil.parseLong(String.valueOf(pt.get("D"+h)));	
						}					
				%>	
					<%
						if(pt.get("GUBUN").equals("매각확정")){
							for(int k = 1 ; k <= 31 ; k++){
								arr[k-1] = AddUtil.parseInt(String.valueOf(pt.get("D"+k)));
							}
						}else{	
					%>
							<tr>
								<td align="center" width="247"><%=pt.get("GUBUN")%><br><%if(pt.get("GUBUN").equals("예비차")){%>(보유차 입/출고처리 후의 차량 대수)<%}else if(pt.get("GUBUN").equals("신차")){%>(납품준비상황에서 입고처리)<%}else if(pt.get("GUBUN").equals("고객차")){%>(고객차량 입/출고 처리 후의 차량 대수)<%}else if(pt.get("GUBUN").equals("매각")){%>(매각대상분류차량/매각확정차량)<%}%></td>
								<td align="center" width="100"><%if(!pt.get("GUBUN").equals("신차") && !pt.get("GUBUN").equals("매각") ){%>주차장마감 <%} else {%> 별도 <%}%></td>
								<%for(int k = 1 ; k <= 31 ; k++){%>
	                		    <td  align="right" width="40">
	                		     	<% if(pt.get("GUBUN").equals("매각")){%>
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
					<td class='title' >소계</td>
					<td class='title'></td>
					<%for(int k = 0 ; k < 31 ; k++){%>
                   <td class='title'><%=AddUtil.parseDecimal(cnt[k]) %>&nbsp;</td>
                   		<%t_cnt2[k] += cnt[k]; %>					
					<%}%>				
				</tr>
				<!-- 소계2(소계-입고대기)추가 (2018.01.29) -->
				<%-- <tr>
				   <td class='title'></td>
				   <td class='title' >소계2</td>
				   <td class='title'>소계-입고대기</td>
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
					<td align="center" rowspan="">대전<br>(1급금호, 현대카독크)</td>
					<td colspan="33" class='line' width=1590>
						 <table border="0" cellspacing="1" cellpadding="0" >
					 <%
												 
				 	for(int i=0; i <31; i++){
				 			cnt[i] = 0;
					}
					
					for(int i=0; i < park_d_size; i++){
																	
						Hashtable pt = (Hashtable)park_d.elementAt(i); 		
												
						//소계
						for(int h = 1 ; h <= 31 ; h++){
    	    						cnt[h -1] +=  AddUtil.parseLong(String.valueOf(pt.get("D"+h)));	
    	    						t_cnt[h -1] +=  AddUtil.parseLong(String.valueOf(pt.get("D"+h)));	
						}					
				%>	
					 <%
						if(pt.get("GUBUN").equals("매각확정")){
							for(int k = 1 ; k <= 31 ; k++){
								arr[k-1] = AddUtil.parseInt(String.valueOf(pt.get("D"+k)));
							}
						}else{	
					 %>
							<tr>
								<td align="center" width="247"><%=pt.get("GUBUN")%><br><%if(pt.get("GUBUN").equals("예비차")){%>(보유차 입/출고처리 후의 차량 대수)<%}else if(pt.get("GUBUN").equals("신차")){%>(납품준비상황에서 입고처리)<%}else if(pt.get("GUBUN").equals("고객차")){%>(고객차량 입/출고 처리 후의 차량 대수)<%}else if(pt.get("GUBUN").equals("매각")){%>(매각대상분류차량/매각확정차량)<%}%></td>
								<td align="center" width="100"><%if(!pt.get("GUBUN").equals("신차") && !pt.get("GUBUN").equals("매각") ){%>주차장마감 <%} else {%> 별도 <%}%></td>
							<%for(int k = 1 ; k <= 31 ; k++){%>
                		     <td  align="right" width="40">
                		     	<%if(pt.get("GUBUN").equals("매각")){%>
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
					  <td class='title' >소계</td>
					  <td class='title'></td>
					<%for(int k = 0 ; k < 31 ; k++){%>
                   <td class='title'><%=AddUtil.parseDecimal(cnt[k]) %>&nbsp;</td>					
					<%}%>						
				</tr>
				<!-- 소계2(소계-입고대기)추가 (2018.01.29) -->
				<tr>
				   <td class='title'></td>
				   <td class='title' >소계2</td>
				   <td class='title'>소계-입고대기</td>
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
					<td align="center" rowspan="">광주<br>(상무1급)</td>
					<td colspan="33" class='line' width=1590>
						 <table border="0" cellspacing="1" cellpadding="0" >
						 	 <%				 
				 	for(int i=0; i <31; i++){
				 			cnt[i] = 0;
					}
					
					for(int i=0; i < park_g_size; i++){
																	
						Hashtable pt = (Hashtable)park_g.elementAt(i); 		
												
						//소계
						for(int h = 1 ; h <= 31 ; h++){
    	    						cnt[h -1] +=  AddUtil.parseLong(String.valueOf(pt.get("D"+h)));	
    	    						t_cnt[h -1] +=  AddUtil.parseLong(String.valueOf(pt.get("D"+h)));	
						}					
				%>					
					<%
						if(pt.get("GUBUN").equals("매각확정")){
							for(int k = 1 ; k <= 31 ; k++){
								arr[k-1] = AddUtil.parseInt(String.valueOf(pt.get("D"+k)));
							}
						}else{	
					%>
							<tr>
								<td align="center" width="247"><%=pt.get("GUBUN")%><br><%if(pt.get("GUBUN").equals("예비차")){%>(보유차 입/출고처리 후의 차량 대수)<%}else if(pt.get("GUBUN").equals("신차")){%>(납품준비상황에서 입고처리)<%}else if(pt.get("GUBUN").equals("고객차")){%>(고객차량 입/출고 처리 후의 차량 대수)<%}else if(pt.get("GUBUN").equals("매각")){%>(매각대상분류차량/매각확정차량)<%}%></td>
								<td align="center" width="100"><%if(!pt.get("GUBUN").equals("신차") && !pt.get("GUBUN").equals("매각") ){%>주차장마감 <%} else {%> 별도 <%}%></td>
							<%for(int k = 1 ; k <= 31 ; k++){%>
                		     	<td  align="right" width="40">
               		     		<%if(pt.get("GUBUN").equals("매각")){%>
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
					<td class='title' >소계</td>
					<td class='title'></td>
					<%for(int k = 0 ; k < 31 ; k++){%>
                   <td class='title'><%=AddUtil.parseDecimal(cnt[k]) %>&nbsp;
                   		<%t_cnt2[k] += cnt[k]; %>
                   </td>					
					<%}%>				
				</tr>
				<!-- 소계2(소계-입고대기)추가 (2018.01.29) -->
				<%-- <tr>
				   <td class='title'></td>
				   <td class='title' >소계2</td>
				   <td class='title'>소계-입고대기</td>
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
					<td class='title' >합계 </td>
					<td class='title' width="100"></td>
					<%for(int k = 0 ; k < 31 ; k++){%>
                    <td class='title'><%=AddUtil.parseDecimal(t_cnt[k]) %>&nbsp;</td>					
					<%}%>
				</tr>
				<!-- 합계2(소계2 total)추가 (2018.01.29) -->
				<tr>
					<td class='title' > </td>
					<td class='title' >합계2 </td>
					<td class='title' width="100">합계-입고대기</td>
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

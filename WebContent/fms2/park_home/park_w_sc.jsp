<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.parking.*, acar.user_mng.*, acar.cus0601.*"%>
<jsp:useBean id="pk_db" scope="page" class="acar.parking.ParkIODatabase"/>
<jsp:useBean id="calendar" class="acar.car_sche.CalendarBean" scope="page"/>
<jsp:useBean id="c61_soBn" class="acar.cus0601.ServOffBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String brid 	= request.getParameter("brid")==null?"":request.getParameter("brid");
	
	String park_id = request.getParameter("park_id")==null?"":request.getParameter("park_id");	
	String off_id = request.getParameter("off_id")==null?"":request.getParameter("off_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String start_dt 	= request.getParameter("start_dt")==null?"":request.getParameter("start_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
		
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height")); // ��ܱ���
	
	String height2 = request.getParameter("height")==null?"":request.getParameter("height");
	
	
	String s_yy 	= request.getParameter("s_yy")==null?AddUtil.getDate(1):request.getParameter("s_yy");
	String s_mm 	= request.getParameter("s_mm")==null?AddUtil.getDate(2):request.getParameter("s_mm");	
	
	int cnt = 3; //��Ȳ ����Ѽ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-180; // ��Ȳ ���μ���ŭ ���� ���������� ������
	
   	String values = "?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+"&brid="+brid+
						"&gubun1="+gubun1+"&gubun2="+gubun2+"&start_dt="+start_dt+"&end_dt="+end_dt+
						"&s_kd="+s_kd+"&t_wd="+t_wd+"&sort="+sort+
					   	"&sh_height="+height;
				   	
	
	int temp_day_num = 0;
	String day_num = "";
	String full_date = "";
	String start_date = "";
	String end_date = "";
	
	int start_year = 0;
	int start_month = 0;
	int start_day = 1;
	
	int nyear = 0;
	int nmonth = 0;
	int nday = 0;
	String tr_color = "";
	String whatday = "";
	
	nyear = Util.parseInt(s_yy);
	nmonth = Util.parseInt(s_mm);
	nday = start_day;
	
	String thisyear = Integer.toString(nyear);
	String thismonth = Integer.toString(nmonth);
	String thismonth2 = Integer.toString(nmonth-1);
	String thisday = Integer.toString(nday);

	if(thismonth.length() == 1)		thismonth = "0"+thismonth;
	if(thismonth2.length() == 1)		thismonth2 = "0"+thismonth2;
	int day_of_week = 0;

	// �ش���� ������ ��¥ ��������
	int last_day = calendar.getMonthLastDay(nyear,nmonth);
		
	// TODO_���縦 �����Ͽ� ��ü�� �ܰ� ������ Ȯ���� �ʿ��Ͽ� �ӽ��ּ�
	//��೻��
	/* Vector vt2 = pk_db.getOffWashContList(off_id);
	int vt_size = vt.size(); */
	
	Cus0601_Database c61_db = Cus0601_Database.getInstance();
	ServOffBean[] c61_soBns = c61_db.getServ_offList("", "", "", "", "5");
	int c61_soBns_size = c61_soBns.length;
		
	if (off_id.equals("")) {
		if (c61_soBns_size > 0) {
			off_id = c61_soBns[1].getOff_id();
		} else {
			off_id = "";
		}
	}
	
	// ������Ȳ ���� �������
	Vector vt = pk_db.getParkWashStat(park_id, off_id, s_yy, s_mm);
	int vt_size = vt.size();
	
	
	// ������Ȳ �� �ջ����
	Hashtable total_ht  = pk_db.getParkWashTotalStat(park_id, off_id, s_yy, s_mm);
	int total_ht_size = total_ht.size();
	
	String pageName = request.getServletPath(); 
//	System.out.println(pageName);
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
	
	function Search2() {
		var fm = document.form1;
		fm.action = 'park_w_sc.jsp';
		fm.target = 'c_foot';
		fm.submit();
	}	

	function print() {
		
        var pop_title = "statPrint" ;
		 
	 	window.open("", pop_title, "left=10, top=20, width=1500, height=800, scrollbars=no"); 

		var fm = document.form1;
		fm.action = 'park_w_sc_print.jsp';
		fm.target = pop_title;
		fm.submit();
	}
</script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script type="text/javascript">
$('document').ready(function() {
	//div�� ȭ�� ���ð����� �ʱ�ȭ
	var frame_height = Number($("#height").val());
	var search_height = Number($("#search_height").height());
	
	var pageName = '<%=pageName%>';
	
	if(pageName != "/fms2/park_home/park_w_sc_print.jsp"){
		$("#screen_height").css("height", (frame_height - search_height) - 130);
	}else{
		$("body").css("zoom", "92%");
	}
});

</script>

</head>
<body leftmargin="15">
	<form name='form1' method='post'>
		<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
		<input type='hidden' name='gubun1' value='<%=gubun1%>'>
		<input type='hidden' name='brid' value='<%=brid%>'>
		<input type='hidden' name='user_id' value='<%=user_id%>'>
		<input type='hidden' name='br_id' value='<%=br_id%>'>

		<input type="hidden" name="height" id="height" value="<%=height2%>">
		<table id="search_height" border="0" cellspacing="0" cellpadding="0" width=100%>	
		<%	if(!pageName.equals("/fms2/park_home/park_w_sc_print.jsp")){%>	
		    <tr>
		        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�۾��庰 ����������Ȳ</span></td>
		        <!-- <td align="right">&nbsp;</td> -->
		    </tr>
    		
		    <tr>
		        <td class=h></td>
		    </tr>
		    <tr>
		        <td>
		            <table border=0 cellspacing=1>
		                <tr>
		                	<td>
					    		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gjij.gif align=absmiddle>
								<select name="park_id" id="park_id" >
									<% if (park_id.equals("")) { %>
										<option value="1" <%if(br_id.equals("S1")){%>selected<%}%>>����������</option>
										<%-- <option value="17" <%if(br_id.equals("B1")){%>selected<%}%>>�����̵�</option>
										<option value="7" >�λ�ΰ�</option>
										<option value="4" <%if(br_id.equals("D1")){%>selected<%}%>>��������</option>
										<option value="12" <%if(br_id.equals("J1")){%>selected<%}%>>��������</option>
										<option value="13" <%if(br_id.equals("G1")){%>selected<%}%>>�뱸����</option> --%>
									<% } else { %>
										<option value="1" <%if(park_id.equals("1")){%>selected<%}%>>����������</option>
										<%-- <option value="17" <%if(park_id.equals("17")){%>selected<%}%>>�����̵�</option>
										<option value="7" <%if(park_id.equals("7")){%>selected<%}%>>�λ�ΰ�</option>
										<option value="4" <%if(park_id.equals("4")){%>selected<%}%>>��������</option>										
										<option value="12" <%if(park_id.equals("12")){%>selected<%}%>>��������</option>
										<option value="13" <%if(park_id.equals("13")){%>selected<%}%>>�뱸����</option> --%>							
									<% } %>
								</select>
								&nbsp;
								<select name="off_id" <%if(acar_de.equals("8888")){%>disabled<%}%>>
								<% if (c61_soBns_size > 0) { %>
									<% for(int i=0; i< c61_soBns.length; i++){
											c61_soBn = c61_soBns[i];
									%>
										<option value="<%=c61_soBn.getOff_id()%>" <%if (off_id.equals(c61_soBn.getOff_id())) { %>selected<%} %>><%=c61_soBn.getOff_nm()%></option>
									<% } %>
								<% } else { %>
										<option value="">��ü����</option>
								<% } %>
								</select>
					    	</td>
					    	<td>
					    		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					    		<select name="s_yy">
					  			<%for(int i=2018; i<=AddUtil.getDate2(1); i++){%>
									<option value="<%=i%>" <%if(s_yy.equals(Integer.toString(i))){%>selected<%}%>><%=i%>��</option>
								<%}%>
								</select>
								
			        			<select name="s_mm">
			        				<option value="0">��ü</option>
			          			<%for(int i=1; i<=12; i++){%>
			          				<option value="<%=AddUtil.addZero2(i)%>" <%if(s_mm.equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>��</option>
			          			<%}%>
			        			</select>             			  
			           			  &nbsp;<a href="javascript:Search2();"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a>
					    	</td>
					    
					    	<td>
					    		<%if(!acar_de.equals("8888")){
					    			if(!pageName.equals("/fms2/park_home/park_w_sc_print.jsp")){%>
						    			<a href="javascript:print();"><img src=/acar/images/center/button_print.gif align=absmiddle border=0 style="margin-left: 20px;"></a>
					    			<%} %>
					    		<%} %>
					    	</td>
		                </tr>
		            </table>
		        </td>
		    </tr>
    		
		    <tr>
				<td></td>
			</tr>
			<%} %>	
			<tr>
				<td class=line2></td>
			</tr>
		</table>
					
	
		<div id="screen_height" <%if(!pageName.equals("/fms2/park_home/park_w_sc_print.jsp")){%>style="overflow-y: scroll;"<%} %>>
		
				
		<table border="0" cellspacing="0" cellpadding="0" width=100%>
			<tr>
		        <td class="line">
			        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		                <tr style="height: 20px;">
		                    <td width='6%'  rowspan="2" class='title'>����</td>
		                    <td width='4%'  rowspan="2" class='title'>����</td>
		                    <td colspan="3" class='title'>�����ܰ�</td>
		                    <td colspan="3" class='title' style="border-left:1px solid #b0baec;">�۾���� ������Ȳ</td>
		                    <td colspan="3" class='title' style="border-left:1px solid #b0baec;">���</td>
		                </tr>
                     	 <tr style="height: 20px;">
		                    <td width='5%' class='title'>����(�ǳ�����)</td>
		                    <td width='5%' class='title'>ũ����(��������)�߰�</td>
		                    <td width='5%' class='title'>�Ұ�</td>
		                    <td width='5%' class='title' style="border-left:1px solid #b0baec;">����(�ǳ�����)</td>
		                    <td width='5%' class='title'>ũ����(��������)�߰�</td>
		                    <td width='5%' class='title'>�Ұ�</td>
                       		<td width='5%' class='title' style="border-left:1px solid #b0baec;">����(�ǳ�����)</td>
                       		<td width='5%' class='title'>ũ����(��������)�߰�</td>
		                    <td width='5%' class='title'>�Ұ�</td>
		                </tr>
		
		<%
			 int totalMonth = 2; 
			
		for(int m=1; m<totalMonth; m++){
				
		%>
			<%if(s_mm.equals("0")){ %>
				<%	//���� ����
						// ������Ȳ ���� �������
						vt = pk_db.getParkWashMonStat(park_id, off_id, s_yy, s_mm);
						vt_size = vt.size();
						
						for(int i = 1 ; i < 13 ; i++){
							int dankaMM = 0;
							int endday = AddUtil.getMonthDate(Integer.parseInt(s_yy), i);
							start_date = s_yy + "-0" + i + "-01";
							end_date = s_yy + "-0" + i + "-"+ String.valueOf(endday);
							temp_day_num = i;
							day_num = "";
							if (temp_day_num <= 9) {
								day_num = "0" + AddUtil.toString(temp_day_num);
							} else {
								day_num = AddUtil.toString(temp_day_num);
							}
					%>			
					 	<tr>
		                	<td class='title' align="center">
                                <span id="<%=thisyear%><%=i%>"> 
                                	<%=i%>��
                                </span> 
		                	</td>
		                	<td align="center"></td>
		                
		                	<!--�����ܰ�  -->
		                	<td align="center">
		                	<% 
							    if( vt_size > 0) {
									for(int j = 0 ; j < vt_size ; j++) {
										Hashtable ht = (Hashtable)vt.elementAt(j);	
							%>
									<%if (day_num.equals(ht.get("REQ_MM")) && Integer.valueOf((String)ht.get("WASH_CNT")) > 0) {%>
										<%=AddUtil.parseDecimal("10000") %>
										<%dankaMM +=10000; %>
									<%}%>
							<%
									}
							    }
							%>
		                	</td>
		                	
		                	<!--�ǳ�ũ���״ܰ�  -->
		                	<td align="center">
		                	<% 
							    if( vt_size > 0) {
									for(int j = 0 ; j < vt_size ; j++) {
										Hashtable ht = (Hashtable)vt.elementAt(j);	
										int yyyymm = Integer.parseInt(s_yy+""+s_mm);
									 	if(yyyymm >= 202003 ){ 
											if (day_num.equals(ht.get("REQ_MM"))  && Integer.valueOf((String)ht.get("INCLEAN_CNT")) > 0) {%>
											<%=AddUtil.parseDecimal("20000") %>
							<%				dankaMM +=20000; 
											}
									 	}else{
									 		if (day_num.equals(ht.get("REQ_MM"))  && Integer.valueOf((String)ht.get("INCLEAN_CNT")) > 0) {%>
											<%=AddUtil.parseDecimal("30000") %>
							<%				dankaMM +=30000; 
									 		}
									 	}
									}
							    }
							%>
		                	</td>
		                	
		                	
	                		<!--�����ܰ� �Ұ�  -->
		                	<td align="center" >
	                		<% 
							    if( dankaMM > 0) {
							%>
									<%=AddUtil.parseDecimal(dankaMM) %>
							<%
							    }
							%>
		                	</td>
		                	
		                	<!--���� �۾����  -->
		                	<td align="center">
		                	
		                
	                		<% 
							    if( vt_size > 0) {
									for(int j = 0 ; j < vt_size ; j++) {
										Hashtable ht = (Hashtable)vt.elementAt(j);
										full_date = s_yy + "-" + s_mm + "-" + day_num;
							%>
									<%if (day_num.equals(ht.get("REQ_MM"))) {
										System.out.println(start_date);
									
									%>
										<a href="/fms2/park_home/park_wd_sc.jsp?park_id=<%=park_id%>&gubun1=5&start_dt=<%=start_date%>&end_dt=<%=end_date%>&height=<%=height2%>"><%=ht.get("WASH_CNT")%></a>
									<%}%>
							<%
									}
							    }
							%>
		                	</td>
		                	
		                	<!--�ǳ�ũ���� �۾����  -->
		                	<td align="center">
	                		<% 
							    if( vt_size > 0) {
									for(int j = 0 ; j < vt_size ; j++) {
										Hashtable ht = (Hashtable)vt.elementAt(j);
										full_date = s_yy + "-" + s_mm + "-" + day_num;
							%>
									<%if (day_num.equals(ht.get("REQ_MM"))) {%>
										<a href="/fms2/park_home/park_wd_sc.jsp?park_id=<%=park_id%>&gubun1=5&start_dt=<%=start_date%>&end_dt=<%=end_date%>&height=<%=height2%>"><%=ht.get("INCLEAN_CNT")%></a>
									<%}%>
							<%
									}
							    }
							%>
		                	</td>
		                	
		                	<!--�� �۾����  -->
		                	<td align="center">
	                		<% 
							    if( vt_size > 0) {
									for(int j = 0 ; j < vt_size ; j++) {
										Hashtable ht = (Hashtable)vt.elementAt(j);
										full_date = s_yy + "-" + s_mm + "-" + day_num;
							%>
									<%if (day_num.equals(ht.get("REQ_MM"))) {%>
										<a href="/fms2/park_home/park_wd_sc.jsp?park_id=<%=park_id%>&gubun1=5&start_dt=<%=start_date%>&end_dt=<%=end_date%>&height=<%=height2%>"><%=ht.get("TOTAL_CNT")%></a>
									<%}%>
							<%
									}
							    }
							%>
		                	</td>
		                	
		                	<!--�����ݾ� �հ�   -->
		                	<td align="center" style="border-left:1px solid #b0baec;">
		                	<% 
							    if( vt_size > 0) {
									for(int j = 0 ; j < vt_size ; j++) {
										Hashtable ht = (Hashtable)vt.elementAt(j);										
							%>
									<%if (day_num.equals(ht.get("REQ_MM"))) {%>
										<%=AddUtil.parseDecimal(ht.get("WASH_DD_PAY"))%>
									<%}%>
							<%
									}
							    }
							%>
		                	</td>
		                	
		                	<!--�ǳ�ũ���ױݾ� �հ�   -->
		                	<td align="center">
		                	<% 
							    if( vt_size > 0) {
									for(int j = 0 ; j < vt_size ; j++) {
										Hashtable ht = (Hashtable)vt.elementAt(j);										
							%>
									<%if (day_num.equals(ht.get("REQ_MM"))) {%>
										<%=AddUtil.parseDecimal(ht.get("INCLEAN_DD_PAY"))%>
									<%}%>
							<%
									}
							    }
							%>
		                	</td>
		                	<td align="center">
		                	<% 
							    if( vt_size > 0) {
									for(int j = 0 ; j < vt_size ; j++) {
										Hashtable ht = (Hashtable)vt.elementAt(j);										
							%>
									<%if (day_num.equals(ht.get("REQ_MM"))) {%>
										<%=AddUtil.parseDecimal(ht.get("TOTAL_DD_PAY"))%>
									<%}%>
							<%
									}
							    }
							%>
		                	</td>
		                </tr>
				<%} %>
		
		<%}else{ %>	
					<%	//���Ϻ� ����
						for(int i = 1 ; i < last_day + 1 ; i++){
							int dankaDD = 0;
							day_of_week = calendar.getDayOfWeek(nyear, nmonth, i);
							whatday = AddUtil.parseDateWeek("1", day_of_week);
							temp_day_num = i;
							day_num = "";
							if (temp_day_num <= 9) {
								day_num = "0" + AddUtil.toString(temp_day_num);
							} else {
								day_num = AddUtil.toString(temp_day_num);
							}
					%>			
						
		                <tr>
		                	<td class='title' align="center">
		                		<%if (i == 1) {%>
		                		<span id="<%=thisyear%><%=thismonth%><%=i%>"> 
                                	<%=thisyear%>�� <%=thismonth%>�� <%=i%>��<!-- AddUtil.toString(ht.get("START_DAY")) -->
                                </span> 
                                <%} else {%>
                                <span id="<%=thisyear%><%=thismonth%><%=i%>"> 
                                	<%=i%>��
                                </span> 
                                <%}%>
		                	</td>
		                	<td align="center"><%=whatday%></td>
		                	<!--�����ܰ�  -->
		                	<td align="center">
		                	<% 
							    if( vt_size > 0) {
									for(int j = 0 ; j < vt_size ; j++) {
										Hashtable ht = (Hashtable)vt.elementAt(j);	
											if (day_num.equals(ht.get("REQ_DD")) && Integer.valueOf((String)ht.get("WASH_CNT")) > 0) {%>
												<%=AddUtil.parseDecimal("10000") %>
												<%dankaDD += 10000; %>
											<%}
									}
							    }
							%>
		                	</td>
		                	
		                	<!--�ǳ�ũ���״ܰ�  -->
		                	<td align="center">
		                	<% 
							    if( vt_size > 0) {
									for(int j = 0 ; j < vt_size ; j++) {
										Hashtable ht = (Hashtable)vt.elementAt(j);
										int yyyymm = Integer.parseInt(s_yy+""+s_mm);
									 	if(yyyymm >= 202003 ){ 
											if (day_num.equals(ht.get("REQ_DD"))  && Integer.valueOf((String)ht.get("INCLEAN_CNT")) > 0) {%>
												<%=AddUtil.parseDecimal("20000") %>
							<% 					dankaDD += 20000; 
											}
									 	}else{
									 		if (day_num.equals(ht.get("REQ_DD"))  && Integer.valueOf((String)ht.get("INCLEAN_CNT")) > 0) {%>
												<%=AddUtil.parseDecimal("30000") %>
							<%					dankaDD += 30000; 
											}
									 	}
									}
							    }
							%>
		                	</td>
		                	
	                		<!--�����ܰ� �Ұ�  -->
		                	<td align="center" >
	                		<% 
							    if( dankaDD > 0) {
							%>
									
									<%=AddUtil.parseDecimal(dankaDD) %>
							<%
							    }
							%>
		                	</td>
		                	
		                		<!--���� �۾����  -->
		                	<td align="center" style="border-left:1px solid #b0baec;">
	                		<% 
							    if( vt_size > 0) {
									for(int j = 0 ; j < vt_size ; j++) {
										Hashtable ht = (Hashtable)vt.elementAt(j);
										full_date = s_yy + "-" + s_mm + "-" + day_num;
							%>
									<%if (day_num.equals(ht.get("REQ_DD"))) {%>
										<a href="/fms2/park_home/park_wd_sc.jsp?park_id=<%=park_id%>&gubun1=5&start_dt=<%=full_date%>&end_dt=<%=full_date%>&height=<%=height2%>"><%=ht.get("WASH_CNT")%></a>
									<%}%>
							<%
									}
							    }
							%>
		                	</td>
		                	
		                	<!--�ǳ�ũ���� �۾����  -->
		                	<td align="center">
	                		<% 
							    if( vt_size > 0) {
									for(int j = 0 ; j < vt_size ; j++) {
										Hashtable ht = (Hashtable)vt.elementAt(j);
										full_date = s_yy + "-" + s_mm + "-" + day_num;
							%>
									<%if (day_num.equals(ht.get("REQ_DD"))) {%>
										<a href="/fms2/park_home/park_wd_sc.jsp?park_id=<%=park_id%>&gubun1=5&start_dt=<%=full_date%>&end_dt=<%=full_date%>&height=<%=height2%>"><%=ht.get("INCLEAN_CNT")%></a>
									<%}%>
							<%
									}
							    }
							%>
		                	</td>
		                	
		                	<!--�� �۾����  -->
		                	<td align="center">
	                		<% 
							    if( vt_size > 0) {
									for(int j = 0 ; j < vt_size ; j++) {
										Hashtable ht = (Hashtable)vt.elementAt(j);
										full_date = s_yy + "-" + s_mm + "-" + day_num;
							%>
									<%if (day_num.equals(ht.get("REQ_DD"))) {%>
										<a href="/fms2/park_home/park_wd_sc.jsp?park_id=<%=park_id%>&gubun1=5&start_dt=<%=full_date%>&end_dt=<%=full_date%>&height=<%=height2%>"><%=ht.get("TOTAL_CNT")%></a>
									<%}%>
							<%
									}
							    }
							%>
		                	</td>
		                	
		                	<!--�����ݾ� �հ�   -->
		                	<td align="center" style="border-left:1px solid #b0baec;" >
		                	<% 
							    if( vt_size > 0) {
									for(int j = 0 ; j < vt_size ; j++) {
										Hashtable ht = (Hashtable)vt.elementAt(j);										
							%>
									<%if (day_num.equals(ht.get("REQ_DD"))) {%>
										<%=AddUtil.parseDecimal(ht.get("WASH_DD_PAY"))%>
									<%}%>
							<%
									}
							    }
							%>
		                	</td>
		                	
		                	<!--�ǳ�ũ���ױݾ� �հ�   -->
		                	<td align="center" >
		                	<% 
							    if( vt_size > 0) {
									for(int j = 0 ; j < vt_size ; j++) {
										Hashtable ht = (Hashtable)vt.elementAt(j);										
							%>
									<%if (day_num.equals(ht.get("REQ_DD"))) {%>
										<%=AddUtil.parseDecimal(ht.get("INCLEAN_DD_PAY"))%>
									<%}%>
							<%
									}
							    }
							%>
		                	</td>
		                	<td align="center">
		                	<% 
							    if( vt_size > 0) {
									for(int j = 0 ; j < vt_size ; j++) {
										Hashtable ht = (Hashtable)vt.elementAt(j);										
							%>
									<%if (day_num.equals(ht.get("REQ_DD"))) {%>
										<%=AddUtil.parseDecimal(ht.get("TOTAL_DD_PAY"))%>
									<%}%>
							<%
									}
							    }
							%>
		                	</td>
		                </tr>
		                <%
							}								
						%>
					 <%
						}								
					%>
						
		<% 	}%>
			<tr style="height: 25px;">
							<td class='title' colspan="5" align="center" style="font-weight: bold; border-top:1px solid #b0baec;">�� ��</td>
							<td align="center" style="font-weight: bold; border-left:1px solid #b0baec; border-top:1px solid #b0baec;">
								<%=total_ht.get("WASH_CNT")%>&nbsp;��
								</td>
							<td align="center" style="font-weight: bold; border-top:1px solid #b0baec;">
								<%=total_ht.get("INCLEAN_CNT")%>&nbsp;��
							</td>
							<td align="center" style="font-weight: bold; border-top:1px solid #b0baec;">
								<%=total_ht.get("TOTAL_CNT")%>&nbsp;��
							</td>
							<td align="center" style="font-weight: bold; border-left:1px solid #b0baec; border-top:1px solid #b0baec;">
								<%=AddUtil.parseDecimal(total_ht.get("WASH_TOTAL_PAY"))%>&nbsp;��
							</td>
							<td align="center" style="font-weight: bold; border-top:1px solid #b0baec;">
								<%=AddUtil.parseDecimal(total_ht.get("INCLEAN_TOTAL_PAY"))%>&nbsp;��
							</td>
							<td align="center" style="font-weight: bold; border-top:1px solid #b0baec;">
								<%=AddUtil.parseDecimal(total_ht.get("TOTAL_PAY"))%>&nbsp;��
							</td>
						</tr>
		            </table>
			    </td>
		 </tr>
		</table>
		</div>
	</form>
</body>
</html>

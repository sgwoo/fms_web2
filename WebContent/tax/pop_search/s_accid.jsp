<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.accid.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	String c_id		= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String l_cd		= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	
	
	AccidDatabase as_db = AccidDatabase.getInstance(); 
	
	Vector accids 	= null;
	Vector cars 	= null;
	Hashtable cons 	= null;
	int accid_size = 0;
	int car_size = 0;
	int cons_size = 0;
	
	if(mode.equals("sch_accid")){
		accids = as_db.getAccidSListPop(c_id, "");
		accid_size = accids.size();
	}else if(mode.equals("sch_car")){
		cars = as_db.getRentContCarPop(c_id, "");
		car_size = cars.size();
	}else if(mode.equals("sch_cons")){
		cons = as_db.getConsForAccidPop(c_id);
		cons_size = cons.size();
	}
	/* if(!t_wd.equals("")){
		accids = as_db.getAccidSListPop("", "", "", "");
		accid_size = accids.size();
	} */
%> 

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script type="text/javascript" src='/include/common.js'></script>
<script>
	function Search(s_st){
		var fm = document.search_form;
		fm.s_st.value = s_st;
		
		/* if(s_st == '1'){
			if(fm.gubun2.value == '5' && fm.st_dt.value != '')						fm.st_dt.value = ChangeDate3(fm.st_dt.value);
			if(fm.gubun2.value == '5' && fm.end_dt.value != '')						fm.end_dt.value = ChangeDate3(fm.end_dt.value);
			if(fm.gubun2.value == '5' && fm.st_dt.value !='' && fm.end_dt.value=='')fm.end_dt.value = getTodayBar();
			if(fm.gubun2.value == '3' && fm.s_mon.value != '')						fm.st_dt.value = fm.s_mon.value; 
		}else if(s_st == '3'){ */
			if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '7')		fm.t_wd.value = fm.s_mng.options[fm.s_mng.selectedIndex].value;
			if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '8')		fm.t_wd.value = fm.s_mng.options[fm.s_mng.selectedIndex].value;
			if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '11')	fm.t_wd.value = fm.s_mng.options[fm.s_mng.selectedIndex].value;			
			if (fm.t_wd.value == '') {
		     	alert("검색조건을 입력하셔야 합니다.")
		     	return;
		     }			
	//	}
		
		/* if(s_st == '4'){  //과실확정전 사전결재 - 검색조건부분만 조건반영  - 
			fm.action="s_accid.jsp";
			//fm.target="c_foot";		
			fm.submit();
		} else { */		
			fm.action="s_accid.jsp";
			//fm.target="c_foot";		
			fm.submit();
		//}
	} 
	
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') Search(3);
	}
	
	function drop()
	{
		var fm = document.search_form;
		var len = fm.gubun5.length;
		for(var i = 0 ; i < len ; i++){
			fm.gubun5.options[len-(i+1)] = null;
		}
	}			
	
	//디스플레이 타입(검색) -검색조건 선택시
	function cng_input3(){
		var fm = document.search_form;
		if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '7' || fm.s_kd.options[fm.s_kd.selectedIndex].value == '8' || fm.s_kd.options[fm.s_kd.selectedIndex].value == '11'){ //접수자,관리담당자,영업담당자
			td_input.style.display	= 'none';
			td_mng.style.display	= '';
		}else{
			td_input.style.display	= '';
			td_mng.style.display	= 'none';
		}
	}
	
	//20
	/* function AccidentDisp(accid_id, rent_mng_id, rent_l_cd, ins_com_id, ins_com_nm, client_id, client_st, client_nm, firm_nm, 
						  birth, enp_no, zip, addr, ins_req_amt, c_id, car_no, car_nm, accid_dt, ot_fault_per, ins_day_amt ){
		
		var o_fm = opener.form1;
		o_fm.ac_accid_id.value 		= accid_id;
		o_fm.ac_rent_mng_id.value 	= rent_mng_id;
		o_fm.ac_rent_l_cd.value 	= rent_l_cd;	
		o_fm.ins_com_id.value 		= ins_com_id;
		o_fm.ins_com_nm.value 		= ins_com_nm;
		o_fm.ac_client_id.value 	= client_id;
		o_fm.ac_client_st.value 	= client_st;
		o_fm.ac_client_nm.value 	= client_nm;
		o_fm.ac_firm_nm.value 		= firm_nm;
		if(client_st=='2'){	o_fm.ac_birth.value = birth.substr(0,6);	 alert(o_fm.ac_birth.value);	}
		o_fm.ac_enp_no.value 		= enp_no;
		o_fm.ac_zip.value 			= zip;
		o_fm.ac_addr.value 			= addr;
		if(ins_req_amt!=''&&ins_req_amt!='null'){	o_fm.ins_req_amt.value = ins_req_amt;	}
		o_fm.ac_car_mng_id.value 	= c_id;
		o_fm.ac_car_no.value	 	= car_no;
		o_fm.ac_car_nm.value	 	= car_nm;
		o_fm.accid_dt.value 		= accid_dt;
		o_fm.ac_ot_fault_per.value 	= ot_fault_per;
		o_fm.ins_day_amt.value 		= ins_day_amt;
		
		self.close();
	} */
	
	function AccidentDisp(car_mng_id, accid_id){
		var fm = document.form1;
		
		fm.mode.value 			= "sch_accid_detail";
		fm.car_mng_id.value 	= car_mng_id;
		fm.accid_id.value 		= accid_id;
		
		fm.action = "s_accid_a.jsp";
		fm.target = "_self";
		fm.submit();
	} 
	
	function view_client(m_id, l_cd, r_st){
		window.open("/fms2/con_fee/con_fee_client_s.jsp?m_id="+m_id+"&l_cd="+l_cd+"&r_st="+r_st, "VIEW_CLIENT", "left=20, top=20, width=820, height=700, scrollbars=yes");
	}
	
	//자동차등록정보 보기
	function view_car(m_id, l_cd, c_id){
		window.open("/acar/car_register/car_view.jsp?rent_mng_id="+m_id+"&rent_l_cd="+l_cd+"&car_mng_id="+c_id+"&cmd=ud", "VIEW_CAR", "left=100, top=100, width=850, height=700, scrollbars=yes");
	}
	
	function CarDisp(c_id, rent_s_cd){
		
		var fm = document.form1;
		
		fm.mode.value 			= "sch_car";
		fm.car_mng_id.value 	= c_id;
		fm.rent_s_cd.value 		= rent_s_cd;
		
		fm.action = "s_accid_a.jsp";
		fm.target = "_self";
		fm.submit();
	}
	
	function consDisp(c_id){
		var fm = document.form1;
		
		fm.mode.value 			= "sch_cons";
		fm.car_mng_id.value 	= c_id;
		
		fm.action = "s_accid_a.jsp";
		fm.target = "_self";
		fm.submit();	
	}
	
</script>
</head>
<body>

<form name='form1' action='' method='post' target='d_content'>
	<input type='hidden' name='accid_size' value='<%=accid_size%>'>
	<input type='hidden' name='mode' value=''>
	<input type='hidden' name='car_mng_id' value=''>
	<input type='hidden' name='accid_id' value=''>
	<input type='hidden' name='rent_s_cd' value=''>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td colspan=10>
				<table width=100% border=0 cellpadding=0 cellspacing=0>
					<tr>
						<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
						<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<%if(mode.equals("sch_accid")){ %>
							<span class=style5>사고조회</span> - 사고 및 보험>사고관리>휴/대차료관리 참고
						<%}else if(mode.equals("sch_car")){ %>
							<span class=style5>사고대차 조회</span>
						<%}else if(mode.equals("sch_cons")){ %>
							<span class=style5>탁송 조회</span> - 사고대차인도 차량검색
						<%} %>	
						</td>
						<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td class=h></td>
		</tr>
	</table>
	<%if(mode.equals("sch_accid")||mode.equals("sch_accid_detail")){ %>
	<table border="0" cellspacing="0" cellpadding="0" width='100%'>
	    <tr>
	        <td>
	            <table border="0" cellspacing="0" cellpadding="0" width="100%">
	                <tr>
	                    <td colspan=2 class=line2></td>
	                </tr>
	                <tr id='tr_title' style='position:relative;z-index:1'>
	            	    <td class='line' width='100%' id='td_title' style='position:relative;'> 
	            	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>            
	                          	<tr> 
		                            <td width='8%' class='title'>연번</td>
		                            <td width='6%' class='title'>상태</td>
		                            <td width='8%' class='title'>사고유형</td>
		                            <td width='12%' class='title'>계약번호</td>
		                            <td width='20%' class='title'>상호</td>
		                            <td width='12%' class='title'>차량번호</td>
		                            <td width='20%' class='title'>차명</td>
		                            <td width='*' class='title'>사고일시</td>
	                          	</tr>
	                        </table>
	                    </td>
	                </tr>
					<%	if(accid_size > 0){%>
	                <tr>
	            	    <td class='line' id='td_con' style='position:relative;'> 
                	    	<table border="0" cellspacing="1" cellpadding="0" width='100%'>
                           	<%for (int i = 0 ; i < accid_size ; i++){
                				Hashtable accid = (Hashtable)accids.elementAt(i);%>
                				<%-- <%
                					//대차료
	                				String i_start_dt = String.valueOf(accid.get("INS_USE_ST"));
	                		    	String i_start_h 	= "00";
	                		    	String i_start_s 	= "00";
	                		    	String get_start_dt = String.valueOf(accid.get("INS_USE_ST"));
	                		    	String deli_dt 		= String.valueOf(accid.get("DELI_DT"));
	                		    	String deli_dt_d	= "00"; 
	                				String deli_dt_h 	= "00";
	                				String deli_dt_s	= "00";
	                				if(deli_dt.length()==12){
		                		    	deli_dt_d	= deli_dt.substring(0,8); 
		                				deli_dt_h 	= deli_dt.substring(8,10);
		                				deli_dt_s 	= deli_dt.substring(10,12);
	                				}
	                		    	if(get_start_dt.length() == 12){
	                		    		i_start_dt 	= get_start_dt.substring(0,8);
	                		    		i_start_h 	= get_start_dt.substring(8,10);
	                		    		i_start_s	= get_start_dt.substring(10,12);
	                		    	}
	                		    	if(get_start_dt.length() == 10){
	                		    		i_start_dt 	= get_start_dt.substring(0,8);
	                		    		i_start_h 	= get_start_dt.substring(8,10);
	                		    	}
		                			if(AddUtil.parseInt(String.valueOf(accid.get("INS_REQ_AMT")))==0 && get_start_dt.length() == 8 
		                				&& !String.valueOf(accid.get("CAR_MNG_ID")).equals("") && get_start_dt.equals(deli_dt_d)){
		                				i_start_h 	= deli_dt_h;
		                		    	i_start_s	= deli_dt_s;
		                			}
		                			
	                				String i_end_dt 	= String.valueOf(accid.get("INS_USE_ET"));
	                		    	String i_end_h 		= "00";
	                		    	String i_end_s 		= "00";
	                		    	String get_end_dt 	= String.valueOf(accid.get("INS_USE_ET"));
	                		    	String ret_dt 		= String.valueOf(accid.get("RET_DT"));
	                		    	String ret_dt_d		= "00"; 
	                				String ret_dt_h 	= "00";
	                				String ret_dt_s		= "00";
	                				if(ret_dt.length()==12){
	                					ret_dt_d	= ret_dt.substring(0,8); 
	                					ret_dt_h 	= ret_dt.substring(8,10);
	                					ret_dt_s 	= ret_dt.substring(10,12);
	                				}
	                		    	if(get_end_dt.length() == 12){
	                		    		i_end_dt 	= get_end_dt.substring(0,8);
	                		    		i_end_h 	= get_end_dt.substring(8,10);
	                		    		i_end_s		= get_end_dt.substring(10,12);
	                		    	}
	                		    	if(get_end_dt.length() == 10){
	                		    		i_end_dt 	= get_end_dt.substring(0,8);
	                		    		i_end_h 	= get_end_dt.substring(8,10);
	                		    	}
	                		    	if(AddUtil.parseInt(String.valueOf(accid.get("INS_REQ_AMT")))==0 && get_end_dt.length() == 8 
	                		    		&& !String.valueOf(accid.get("CAR_MNG_ID")).equals("") && get_end_dt.equals(ret_dt_d)){
	                					i_end_h 	= ret_dt_h;
	                		    		i_end_s		= ret_dt_s;
	                				}
                					
	                		    	//사고대차회수	
	                		    	
                					//상대과실률
                					int ot_fault_per = accid.get("OT_FAULT_PER")==null?0:AddUtil.parseInt(String.valueOf(accid.get("OT_FAULT_PER")));
									if(ot_fault_per==0) ot_fault_per = Math.abs(AddUtil.parseInt(String.valueOf(accid.get("OUR_FAULT_PER")))-100);
                				%> --%>
                            	<tr> 
	                            	<td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> align='center' width='8%'><a name="<%=i+1%>"><%=i+1%> 
	                              	<%if(accid.get("USE_YN").equals("Y")){%>
	                              	<%}else{%>
	                              		(해약) 
	                              	<%}%>
	                            </a></td>
	                            	<td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> align='center' width='6%'> 
                              		<%if(String.valueOf(accid.get("SETTLE_ST")).equals("1")){%>종결 
	                                <%}else{%>
	                              		<font color="#FF6600">진행</font> 
	                              	<%}%>
		                            </td>
		                            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> align='center' width='8%'><%=accid.get("ACCID_ST_NM")%></td>
		                            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> align='center' width='12%'>
		                            	<%-- <a href="javascript:AccidentDisp('<%=accid.get("ACCID_ID")%>','<%=accid.get("RENT_MNG_ID")%>','<%=accid.get("RENT_L_CD")%>'
		                            		,'<%=accid.get("INS_COM_ID")%>','<%=accid.get("INS_COM_NM")%>','<%=accid.get("CLIENT_ID")%>','<%=accid.get("CLIENT_ST")%>','<%=accid.get("CLIENT_NM")%>'
		                            		,'<%=accid.get("FIRM_NM")%>','<%=accid.get("SSN")%>','<%=accid.get("ENP_NO")%>','<%=accid.get("O_ZIP")%>','<%=accid.get("O_ADDR")%>','<%=accid.get("INS_REQ_AMT")%>'
		                            		,'<%=accid.get("CAR_MNG_ID")%>','<%=accid.get("CAR_NO")%>','<%=accid.get("CAR_NM")%>','<%=accid.get("ACCID_DT")%>'
		                            		,'<%=ot_fault_per%>','<%=accid.get("INS_DAY_AMT")%>')"
		                            	   onMouseOver="window.status=''; return true" title='사고상세내역 보기'><%=accid.get("RENT_L_CD")%></a> --%>
		                            	<a href="javascript:AccidentDisp('<%=accid.get("CAR_MNG_ID")%>','<%=accid.get("ACCID_ID")%>')"
		                            	   onMouseOver="window.status=''; return true" title='사고상세내역 보기'><%=accid.get("RENT_L_CD")%></a>	   
		                            </td>
		                            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> align='center' width='20%'> 
	                              	<%if(accid.get("FIRM_NM").equals("(주)아마존카") && !accid.get("CUST_NM").equals("")){%>
	                              		<span title='(<%=accid.get("RES_ST")%>)<%=accid.get("CUST_NM")%>'><a href="javascript:view_client('<%=accid.get("RENT_MNG_ID")%>','<%=accid.get("RENT_L_CD")%>', '1')" onMouseOver="window.status=''; return true" title='계약약식내역 팝업'>(<%=accid.get("RES_ST")%>)<%=Util.subData(String.valueOf(accid.get("CUST_NM")), 5)%></a></span>	
	                              	<%}else{%>
	                              		<span title='<%=accid.get("FIRM_NM")%>'><a href="javascript:view_client('<%=accid.get("RENT_MNG_ID")%>', '<%=accid.get("RENT_L_CD")%>', '1')" onMouseOver="window.status=''; return true" title='계약약식내역 팝업'><%=Util.subData(String.valueOf(accid.get("FIRM_NM")), 9)%></a></span> 
	                              	<%}%>
	                            	</td>
		                            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> align='center' width='12%'><a href="javascript:view_car('<%=accid.get("RENT_MNG_ID")%>', '<%=accid.get("RENT_L_CD")%>', '<%=accid.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true" title='자동차등록내역 팝업'><%=accid.get("CAR_NO")%></a></td>
		                            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> align='center' width='20%'><span title='<%=accid.get("CAR_NM")%> <%=accid.get("CAR_NAME")%>'><%=Util.subData(String.valueOf(accid.get("CAR_NM"))+" "+String.valueOf(accid.get("CAR_NAME")), 12)%></span></td>
		                            <td <%if(accid.get("USE_YN").equals("N")){%>class='is'<%}%> align='center' width='*'><%=AddUtil.ChangeDate3(String.valueOf(accid.get("ACCID_DT")))%></td>
	                          	</tr>
	                          <%		}%>
	                        </table>
                    	</td>
                	</tr>
					<%}else{%>                     
	                <tr>
	            	  	<td class='line' width='100%' id='td_con' style='position:relative;'> 
	            	    	<table border="0" cellspacing="1" cellpadding="0" width='100%'>
	                      		<tr> 
	                        		<td align='center'>등록된 데이터가 없습니다</td>
	                      		</tr>
	                    	</table>
	                    </td>
	  				</tr>
					<%}%>
				</table>
	 		</td>
	    </tr>
	    <tr>
			<td class=h></td>
		</tr>
	    <tr> 
	      <td align="center"><a href="javascript:window.close();"><img src="/acar/images/center/button_close.gif"  border="0" align=absmiddle></a>		</td>
	    </tr>
	</table>
	<%}else if(mode.equals("sch_car")){ %>
	<table border="0" cellspacing="0" cellpadding="0" width='100%'>
	    <tr>
	        <td>
	            <table border="0" cellspacing="0" cellpadding="0" width="100%">
	                <tr>
	                    <td colspan=2 class=line2></td>
	                </tr>
	                <tr id='tr_title' style='position:relative;z-index:1'>
	            	    <td class='line' width='100%' id='td_title' style='position:relative;'> 
	            	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>            
	                          	<tr> 
		                            <td width='4%' class='title'>연번</td>
		                            <td width='8%' class='title'>계약구분</td>
		                            <td width='15%' class='title'>상호</td>
		                            <td width='10%' class='title'>차량번호</td>
		                            <td width='*' class='title'>차명</td>
		                            <td width='8%' class='title'>원인차량</td>
		                            <td width='10%' class='title'>계약일자</td>
		                            <td width='8%' class='title'>최초영업자</td>
		                            <td width='8%' class='title'>관리담당자</td>
	                          	</tr>
	                        </table>
	                    </td>
	                </tr>
					<%	if(car_size > 0){%>
	                <tr>
	            	    <td class='line' id='td_con' style='position:relative;'> 
                	    	<table border="0" cellspacing="1" cellpadding="0" width='100%'>
                           	<%for (int i = 0 ; i < car_size ; i++){
                				Hashtable car = (Hashtable)cars.elementAt(i);%>
                            	<tr> 
	                            	<td align='center' width="4%"><a name="<%=i+1%>"><%=i+1%></a></td>
	                            	<td align='center' width="8%"> 
                              			<font color="#0080C0"><b><%=car.get("RENT_ST")%></b></font>
		                            </td>
		                            <td align='center' width="15%">
		                            &nbsp;<font color="#808080"><span title='<%=car.get("CUST_NM")%>'><%=AddUtil.substringbdot(String.valueOf(car.get("CUST_NM")), 17)%></span></font>
			                      <%if(String.valueOf(car.get("CUST_NM")).equals("")){%>
			                    	<span title='<%=car.get("ETC")%>'><%=AddUtil.substringbdot(String.valueOf(car.get("ETC")), 15)%></span>
			                    	<%}%>
                    				</td>
		                            <td align='center' width="10%">
		                            	<%-- <a href="javascript:parent.view_cont('<%=car.get("RENT_S_CD")%>', '<%=car.get("CAR_MNG_ID")%>')" onMouseOver="window.status=''; return true"><%=car.get("CAR_NO")%></a> --%>
		                            	<%=car.get("CAR_NO")%>	   
		                            </td>
		                            <td align='center' width="*"> 
	                              	&nbsp;<span title='<%=car.get("CAR_NM")%> <%=car.get("CAR_NAME")%>'><%=AddUtil.substringbdot(String.valueOf(car.get("CAR_NM"))+" "+String.valueOf(car.get("CAR_NAME")), 25)%></span>
	                            	</td>
		                            <td align='center' width="8%">
		                            	<a href="javascript:CarDisp('<%=car.get("CAR_MNG_ID")%>','<%=car.get("RENT_S_CD")%>')"><%=car.get("D_CAR_NO")%></a>
		                            </td>
		                            <td align='center' width="10%"><%=AddUtil.ChangeDate2(String.valueOf(car.get("RENT_DT")))%></td>
		                            <td align='center' width="8%"><%=car.get("BUS_NM")%></td>
		                            <td align='center' width="8%"><%=car.get("MNG_NM")%></td>
	                          	</tr>
	                          <%		}%>
	                        </table>
                    	</td>
                	</tr>
					<%}else{%>                     
	                <tr>
	            	  	<td class='line' width='100%' id='td_con' style='position:relative;'> 
	            	    	<table border="0" cellspacing="1" cellpadding="0" width='100%'>
	                      		<tr> 
	                        		<td align='center'>등록된 데이터가 없습니다</td>
	                      		</tr>
	                    	</table>
	                    </td>
	  				</tr>
					<%}%>
				</table>
	 		</td>
	    </tr>
	    <tr>
			<td class=h></td>
		</tr>
	    <tr> 
	      <td align="center"><a href="javascript:window.close();"><img src="/acar/images/center/button_close.gif"  border="0" align=absmiddle></a>		</td>
	    </tr>
	</table>
	<%}else if(mode.equals("sch_cons")){%>
	<table border="0" cellspacing="0" cellpadding="0" width='100%'>
		<tr>
			<td align="center"><span style="font-weight: bold;">&lt;&nbsp;해당 차량의 가장 최근 사고대차인도 탁송건 조회&nbsp;&gt;</span></td>
		</tr>
	    <tr>
	        <td>
	            <table border="0" cellspacing="0" cellpadding="0" width="100%">
	                <tr>
	                    <td colspan=2 class=line2></td>
	                </tr>
					<%	if(cons_size > 0){%>
	                <tr id='tr_title' style='position:relative;z-index:1'>
	            	    <td class='line' width='100%' id='td_title' style='position:relative;'> 
	            	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>            
	                          	<tr>
		                            <td width='10%' class='title'>탁송번호</td>
		                            <td width='15%' align="center"><%=cons.get("CONS_NO")%>-<%=cons.get("SEQ")%></td>
		                            <td width='10%' class='title'>탁송업체</td>
		                            <td width='15%'>&nbsp;<%=cons.get("OFF_NM")%></td>
		                            <td width='10%' class='title' >구분</td>
		                            <td width='15%' align="center"><%=cons.get("CONS_ST_NM")%></td>
		                            <td width='10%' class='title'>탁송사유</td>
		                            <td width='15%' align="center"><%=cons.get("CONS_CAU_NM")%></td>
		                        </tr>
		                        <tr>    
		                            <td class='title'>차량번호</td>
		                            <td align="center"><%=cons.get("CAR_NO")%></td>
		                            <td class='title'>차명</td>
		                            <td colspan="2">&nbsp;<%=cons.get("CAR_NM")%></td>
		                            <td class='title'>상호</td>
		                            <td colspan="2">&nbsp;<%=cons.get("FIRM_NM")%></td>
	                          	</tr>
	                          	<tr>
	                          		<td class='title' rowspan="2">출발</td>
	                          		<td class='title'>장소</td>
	                          		<td colspan="2">&nbsp;<%=Util.subData(String.valueOf(cons.get("FROM_PLACE")), 20)%></td>
	                          		<td class='title' rowspan="2">도착</td>
	                          		<td class='title'>장소</td>
	                          		<td colspan="2">&nbsp;<%=Util.subData(String.valueOf(cons.get("TO_PLACE")), 20)%></td>
	                          	</tr>
	                          	<tr>
	                          		<td class='title'>시간</td>
	                          		<td colspan="2">&nbsp;<%=AddUtil.ChangeDate3(String.valueOf(cons.get("F_DT")))%></td>
	                          		<td class='title'>시간</td>
	                          		<td colspan="2">&nbsp;<%=AddUtil.ChangeDate3(String.valueOf(cons.get("T_DT")))%></td>
	                          	</tr>
	                        </table>
	                        <input type="hidden" name="t_dt" value="<%=cons.get("T_DT")%>">
	                        <input type="hidden" name="" value="">
	                        <input type="hidden" name="" value="">
	                        <input type="hidden" name="" value="">
	                        <input type="hidden" name="" value="">
	                        <input type="hidden" name="" value="">
	                        <input type="hidden" name="" value="">
	                        <input type="hidden" name="" value="">
	                    </td>
	                </tr>
					<%}else{%>                     
	                <tr>
	            	  	<td class='line' width='100%' id='td_con' style='position:relative;'> 
	            	    	<table border="0" cellspacing="1" cellpadding="0" width='100%'>
	                      		<tr> 
	                        		<td align='center'>등록된 데이터가 없습니다</td>
	                      		</tr>
	                    	</table>
	                    </td>
	  				</tr>
					<%}%>
				</table>
	 		</td>
	    </tr>
	    <tr>
			<td class=h></td>
		</tr>
	    <tr> 
	      <td align="center">
	      	<%if(cons_size > 0){ %>
	      		<a href="javascript:consDisp('<%=c_id%>');"><img src="/acar/images/center/button_conf.gif"  border="0" align=absmiddle></a>
	      	<%} %>
	      	<a href="javascript:window.close();"><img src="/acar/images/center/button_close.gif"  border="0" align=absmiddle></a>		
	      </td>
	    </tr>
	</table>	
	<%}%>
</form>
</body>
</html>

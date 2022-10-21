<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.accid.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id"); 
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	

	String c_id		= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String l_cd		= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String d_c_id	= request.getParameter("d_c_id")==null?"":request.getParameter("d_c_id");
	String d_l_cd	= request.getParameter("d_l_cd")==null?"":request.getParameter("d_l_cd");
	boolean view_yn = false;
	
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	
	Vector accids 	= null;
	Vector cars 	= null;
	Hashtable cons 	= null;
	int accid_size = 0;
	int car_size = 0;
	int cons_size = 0;
	
	//사고대차 조회	
	cars = as_db.getRentContCarPop(c_id, "");
	car_size = cars.size();
	
	//사고조회
	if(d_c_id.equals("")){
		if(car_size > 0){ 
			for (int i = 0 ; i < 1 ; i++){
				Hashtable car = (Hashtable)cars.elementAt(i);
				d_c_id = String.valueOf(car.get("D_CAR_MNG_ID"));
				d_l_cd = String.valueOf(car.get("SUB_L_CD"));
			}
		}
	}
	//accids = as_db.getAccidSListPop(d_c_id, "");
	accids = as_db.getAccidentListPop(d_c_id, d_l_cd,"");
	accid_size = accids.size();
	
	//탁송조회
	cons = as_db.getConsForAccidPop(c_id);
	cons_size = cons.size();
	
	/* if(accid_size > 0){
		for (int i = 0 ; i < accid_size ; i++){
			Hashtable accid = (Hashtable)accids.elementAt(i);
			//사고유형이 피해/쌍방 건일 경우에만 조회내역보여줌(나머지건들은 채권양도통지서 발송필요x)(20190311)
			//if(String.valueOf(accid.get("ACCID_ST")).equals("1")||String.valueOf(accid.get("ACCID_ST")).equals("3")){
			//	view_yn = true;
			//}
		}
	} */
	
%> 

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr "> 
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script type="text/javascript" src='/include/common.js'></script>
<script>
	
	function view_client(m_id, l_cd, r_st){
		window.open("/fms2/con_fee/con_fee_client_s.jsp?m_id="+m_id+"&l_cd="+l_cd+"&r_st="+r_st, "VIEW_CLIENT", "left=20, top=20, width=820, height=700, scrollbars=yes");
	}
	
	//자동차등록정보 보기
	function view_car(m_id, l_cd, c_id){
		window.open("/acar/car_register/car_view.jsp?rent_mng_id="+m_id+"&rent_l_cd="+l_cd+"&car_mng_id="+c_id+"&cmd=ud", "VIEW_CAR", "left=100, top=100, width=850, height=700, scrollbars=yes");
	}
	
	//수리기간 세팅하기(20181212)
	function set_ins_use_st(mode){
		var fm = document.form1;
		if(mode=='get_use_dt'){
			var car_size 	= '<%=car_size%>';
			var accid_size 	= '<%=accid_size%>';
			var c_id 	  = '';		//대차
			var rent_s_cd = '';
			var d_c_id 	  = '';	
			var accid_id  = '';
			//대차정보
			if(car_size>0){
				var sch_car_val = $("input:radio[name='sch_car']:checked").val().split("//");
				c_id = sch_car_val[0];		//대차
				rent_s_cd = sch_car_val[1];
			}
			//사고정보
			if(accid_size>0){
				if($("input:radio[name='sch_accid']:checked").val()!='N'){
					var sch_accid_val = $("input:radio[name='sch_accid']:checked").val().split("//");
					d_c_id = sch_accid_val[0];	//원계약차	
					accid_id = sch_accid_val[1];
				}
			}
			window.open("s_for_bond_trf_a.jsp?c_id="+c_id+"&rent_s_cd="+rent_s_cd+"&d_c_id="+d_c_id+"&accid_id="+accid_id, "USE_DT", "left=100, top=100, width=850, height=700, scrollbars=yes");
			
		}else if(mode=='set_use_dt'){
			var car_size 	= '<%=car_size%>';
			var accid_size 	= '<%=accid_size%>';
			var cons_size 	= '<%=cons_size%>';
			if(car_size>0 || accid_size>0 || cons_size>0){
				if(fm.s_dt1.value==""&&fm.e_dt1.value==""&&fm.s_dt2.value==""&&fm.e_dt2.value==""&&fm.s_dt3.value==""&&fm.e_dt3.value==""){
					alert("해당 내역을 선택 후 수리기간조회 해주세요."); 	return false;
				}
			}
			set_bond_trf_data();
			self.close();
		}
	}
	
	//사고조회(20181226)
	function go_redirect(d_c_id){
		var fm = document.form1;
		fm.d_c_id.value 	= d_c_id;
		
		fm.action = "s_for_bond_trf.jsp";
		fm.target = "_self";
		fm.submit();
	}
	
	function view_use_dt(){
		$("#s_dt1_span, #e_dt1_span, #s_dt2_span, #e_dt2_span, #s_dt3_span, #e_dt3_span").html("");
		var fm = document.form1;
		if(fm.s_dt1.value!="" && fm.s_dt1.value.length==12)		$("#s_dt1_span").html(fm.s_dt1.value.substr(0,4)+"년 "+fm.s_dt1.value.substr(4,2)+"월 "+fm.s_dt1.value.substr(6,2)+"일 "+fm.s_dt1.value.substr(8,2)+"시 "+fm.s_dt1.value.substr(10,2)+"분");
		if(fm.e_dt1.value!="" && fm.e_dt1.value.length==12)		$("#e_dt1_span").html(fm.e_dt1.value.substr(0,4)+"년 "+fm.e_dt1.value.substr(4,2)+"월 "+fm.e_dt1.value.substr(6,2)+"일 "+fm.e_dt1.value.substr(8,2)+"시 "+fm.e_dt1.value.substr(10,2)+"분");
		if(fm.s_dt2.value!="" && fm.s_dt2.value.length==12)		$("#s_dt2_span").html(fm.s_dt2.value.substr(0,4)+"년 "+fm.s_dt2.value.substr(4,2)+"월 "+fm.s_dt2.value.substr(6,2)+"일 "+fm.s_dt2.value.substr(8,2)+"시 "+fm.s_dt2.value.substr(10,2)+"분");
		if(fm.e_dt2.value!="" && fm.e_dt2.value.length==12)		$("#e_dt2_span").html(fm.e_dt2.value.substr(0,4)+"년 "+fm.e_dt2.value.substr(4,2)+"월 "+fm.e_dt2.value.substr(6,2)+"일 "+fm.e_dt2.value.substr(8,2)+"시 "+fm.e_dt2.value.substr(10,2)+"분");
		if(fm.s_dt3.value!="" && fm.s_dt3.value.length==12)		$("#s_dt3_span").html(fm.s_dt3.value.substr(0,4)+"년 "+fm.s_dt3.value.substr(4,2)+"월 "+fm.s_dt3.value.substr(6,2)+"일 "+fm.s_dt3.value.substr(8,2)+"시 "+fm.s_dt3.value.substr(10,2)+"분");
		if(fm.e_dt3.value!="" && fm.e_dt3.value.length==12)		$("#e_dt3_span").html(fm.e_dt3.value.substr(0,4)+"년 "+fm.e_dt3.value.substr(4,2)+"월 "+fm.e_dt3.value.substr(6,2)+"일 "+fm.e_dt3.value.substr(8,2)+"시 "+fm.e_dt3.value.substr(10,2)+"분");
	}
	
	function set_bond_trf_data(){
		var fm = document.form1;
		//기간 세팅
		var dt_term1 = 0;
		var dt_term2 = 0;
		var dt_term3 = 0;
		var ins_use_st = "";
		var ins_use_et = "";
		if(fm.s_dt1.value!="" && fm.s_dt1.value.length==12 && fm.e_dt1.value!="" && fm.e_dt1.value.length==12){	dt_term1 = fm.e_dt1.value - fm.s_dt1.value;		} 
		if(fm.s_dt2.value!="" && fm.s_dt2.value.length==12 && fm.e_dt2.value!="" && fm.e_dt2.value.length==12){	dt_term2 = fm.e_dt2.value - fm.s_dt2.value;		}
		if(fm.s_dt3.value!="" && fm.s_dt3.value.length==12 && fm.e_dt3.value!="" && fm.e_dt3.value.length==12){	dt_term3 = fm.e_dt3.value - fm.s_dt3.value;		}
		
		var min = Math.min(dt_term1==0?999999999999:dt_term1,dt_term2==0?999999999999:dt_term2,dt_term3==0?999999999999:dt_term3);
		if(dt_term3 != 0 && dt_term3 == min){			ins_use_st = fm.s_dt3.value;	ins_use_et = fm.e_dt3.value;	}
		else if(dt_term2 != 0 && dt_term2 == min){		ins_use_st = fm.s_dt2.value;	ins_use_et = fm.e_dt2.value;	}
		else if(dt_term1 != 0 && dt_term1 == min){		ins_use_st = fm.s_dt1.value;	ins_use_et = fm.e_dt1.value;	}
		
		opener.form1.ins_use_st.value = ins_use_st.substring(0,8);
		opener.form1.use_st_h.value 	= ins_use_st.substring(8,10);
		opener.form1.use_st_s.value 	= ins_use_st.substring(10,12);
		opener.form1.ins_use_et.value = ins_use_et.substring(0,8);
		opener.form1.use_et_h.value 	= ins_use_et.substring(8,10);
		opener.form1.use_et_s.value 	= ins_use_et.substring(10,12);
		
		//나머지 데이터 세팅
		opener.form1.ac_accid_id.value		= fm.ac_accid_id.value;
		opener.form1.ac_rent_mng_id.value	= fm.ac_rent_mng_id.value;
		opener.form1.ac_rent_l_cd.value		= fm.ac_rent_l_cd.value;
		opener.form1.ins_com_id.value		= fm.ins_com_id.value;
		opener.form1.ins_com_nm.value		= fm.ins_com_nm.value;
		opener.form1.ac_client_id.value		= fm.ac_client_id.value;
		opener.form1.ac_client_st.value		= fm.ac_client_st.value;
		opener.form1.ac_client_nm.value		= fm.ac_client_nm.value;
		opener.form1.ac_firm_nm.value		= fm.ac_firm_nm.value;
		opener.form1.ac_birth.value				= fm.ac_birth.value;
		opener.form1.ac_enp_no.value			= fm.ac_enp_no.value;
		opener.form1.ac_accid_id.value		= fm.ac_accid_id.value;
		opener.form1.ac_zip.value				= fm.ac_zip.value;
		opener.form1.ac_addr.value				= fm.ac_addr.value;
		opener.form1.ac_car_mng_id.value	= fm.ac_car_mng_id.value;
		opener.form1.ac_car_no.value			= fm.ac_car_no.value;
		opener.form1.ac_car_nm.value			= fm.ac_car_nm.value;
		opener.form1.ac_ins_req_gu.value	= fm.ac_ins_req_gu.value;
		opener.form1.ac_ot_fault_per.value	= fm.ac_ot_fault_per.value;
		opener.form1.ins_day_amt.value		= fm.ins_day_amt.value;
		opener.form1.accid_dt.value				= fm.accid_dt.value;
		opener.form1.ins_req_amt.value		= fm.ins_req_amt.value;
		
	}

	/* function init_fn(val){
		var o_fm = opener.form1;
		if(val=='true'){
			opener.$("#bond_trf_yn").val('Y');
			opener.$(".bondForm").css('display','block');
		}else{
			opener.$("#bond_trf_yn").val('N');
			opener.$(".bondForm").css('display','none');
		}
	} */
</script>
</head>
<body>
<form name='form1' action='' method='post' target='d_content'>
	<input type='hidden' name='accid_size' value='<%=accid_size%>'>
	<input type='hidden' name='mode' value=''>
	<input type='hidden' name='c_id' value='<%=c_id%>'>
	<input type='hidden' name='l_cd' value='<%=l_cd%>'>
	<input type='hidden' name='accid_id' value=''>
	<input type='hidden' name='rent_s_cd' value=''>
	<input type='hidden' name='d_c_id' value=''>
	
	<!-- 수리기간 적용할 파라미터 -->
	<input type="hidden" name="ac_accid_id" value="" />
	<input type="hidden" name="ac_rent_mng_id" value="" />
	<input type="hidden" name="ac_rent_l_cd" value="" />
	<input type="hidden" name="ins_com_id" value="" />
	<input type="hidden" name="ins_com_nm" value="" />
	<input type="hidden" name="ac_client_id" value="" />
	<input type="hidden" name="ac_client_st" value="" />
	<input type="hidden" name="ac_client_nm" value="" />
	<input type="hidden" name="ac_firm_nm" value="" />
	<input type="hidden" name="ac_birth" value="" />
	<input type="hidden" name="ac_enp_no" value="" />
	<input type="hidden" name="ac_zip" value="" />
	<input type="hidden" name="ac_addr" value="" />
	
	<input type="hidden" name="ac_car_mng_id" value="" />
	<input type="hidden" name="ac_car_no" value="" />
	<input type="hidden" name="ac_car_nm" value="" />
	<input type="hidden" name="ac_ins_req_gu" value="2" /><!-- 2:대차료 -->
	<input type="hidden" name="ac_ot_fault_per" value="100" /><!-- 이 시점에서의 상대과실률은 100% 로 계산 -->
	<input type="hidden" name="ins_day_amt" value="" />
	<input type="hidden" name="accid_dt" value=""/>
	<input type="hidden" name="ins_req_amt" value=""/>
    
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td colspan=10>
				<table width=100% border=0 cellpadding=0 cellspacing=0>
					<tr>
						<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
						<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
							<span class=style5>사고대차/사고/탁송 조회</span>	
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
<%-- <%if(view_yn==true){ %> --%>	
	<table border="0" cellspacing="0" cellpadding="0" width='100%'>
		<!-- 사고대차조회 -->
		<tr><td class=h></td></tr>
		<tr><td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>사고대차조회</span></td></tr>
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
		                            <td width='4%' class='title'></td>
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
	                            	<td align='center' width="4%">
	                            		<input type="radio" name="sch_car" value="<%=car.get("CAR_MNG_ID")%>//<%=car.get("RENT_S_CD")%>"
	                            			<%if(!d_c_id.equals("")){	if(d_c_id.equals(String.valueOf(car.get("D_CAR_MNG_ID")))){%>checked<%} %>	
	                            			<%}else{	if(i==0){%>checked<%}	}%>
		                            		onclick="javascript:go_redirect('<%=car.get("D_CAR_MNG_ID")%>');">
	                            	</td>
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
		                            	<%-- <a href="javascript:CarDisp('<%=car.get("D_CAR_MNG_ID")%>'"> --%><%=car.get("D_CAR_NO")%><!-- </a> -->
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
	    <tr><td class=h></td></tr>
	    
		<!-- 사고조회 -->
		<tr><td class=h></td></tr>
		<tr><td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>사고조회</span><span> - 사고대차조회의 원인차량에 대한 조회</span></td></tr>
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
		                            <td width='4%' class='title'></td>
		                            <!-- <td width='5%' class='title'>상태</td> -->
		                            <td width='6%' class='title'>사고유형</td>
		                            <td width='15%' class='title'>사고일시</td>
		                            <td width='18%' class='title'>사고장소</td>
		                            <td width='20%' class='title'>사고내용</td>
		                            <td width='8%' class='title'>접수자</td>
		                            <td width='*' class='title'>사고내용 추가입력</td>
	                          	</tr>
	                        </table>
	                    </td>
	                </tr>
					<%	if(accid_size > 0){%>
					<tr>
						<td class='line' id='td_con' style='position:relative;'> 
                	    	<table border="0" cellspacing="1" cellpadding="0" width='100%'>
                           	<%for (int i = 0 ; i < accid_size ; i++){
                				Hashtable accid = (Hashtable)accids.elementAt(i);
                				//상대차량 인적사항
                				OtAccidBean oa_r [] = as_db.getOtAccid(String.valueOf(accid.get("CAR_MNG_ID")), String.valueOf(accid.get("ACCID_ID")));
                				//보험청구내역(휴차/대차료)
                				MyAccidBean ma_bean = as_db.getMyAccid(String.valueOf(accid.get("CAR_MNG_ID")), String.valueOf(accid.get("ACCID_ID")));
                				
                				//if(String.valueOf(accid.get("ACCID_ST")).equals("1")||String.valueOf(accid.get("ACCID_ST")).equals("3")){
                				%>
                            	<tr>
	                            	<td align='center' width='4%'>
	                            		<input type="radio" name="sch_accid" value="<%=accid.get("CAR_MNG_ID")%>//<%=accid.get("ACCID_ID")%>"<%if(i==0){%>checked<%}%>>
	                            	</td>
	                            	<!-- <td align='center' width='5%'></td> -->
	                            	<td align='center' width='6%'><%=accid.get("ACCID_ST_HAN")%></td>
	                            	<td align='center' width='15%'><%=AddUtil.ChangeDate3(String.valueOf(accid.get("ACCID_DT")))%></td>
	                            	<td align='center' width='18%'><%=accid.get("ACCID_ADDR")%></td>
	                            	<td align='center' width='20%'><%=accid.get("ACCID_CONT")%></td>
	                            	<td align='center' width='8%'><%=accid.get("REG_NM")%></td>
	                            	<td align='center' width='*%'>
	                            		<%if(oa_r.length ==0){ %>상대차량 정보없음<br><%} %>
	                            		<%if(ma_bean.getAccid_id().equals("")){ %>대차료 정보없음<%} %>
	                            	</td>
	                          	</tr>
	                          	<%-- <%}%> --%>
                         	<%}%>
	                         	<!-- <tr>
	                          		<td align="center"><input type="radio" name="sch_accid" value="N"></td>
	                          		<td colspan="7" align="center">조회내역 중 해당건 없음</td>
	                          	</tr> -->
	                        </table>
                    	</td>
                	</tr>
                	<tr>
                    	<td>
	                        <div>※ 사고조회시 사고기본정보가 등록되어 있다하더라도, 사고내용 추가입력 정보가 없으면 사고조회내역은 채권양도 통지서에 사용되지 않습니다.</div>
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
	    <tr><td class=h></td></tr>
		<!-- 탁송조회 -->
		<tr><td class=h></td></tr>
		<tr><td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>탁송조회</span><span> - 해당 차량의 가장 최근 사고대차인도 탁송건 조회</span></td></tr>
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
	    <tr><td class=h></td></tr>
	    <tr><td><input type="button" class="button" value="수리기간조회" onclick ="javascript:set_ins_use_st('get_use_dt');"></td></tr>
	    <!-- 조회결과 -->
	    <tr><td class=h></td></tr>
		<tr><td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>조회결과 - 수리기간조회</span></td></tr>
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
	            	        		<td width='10%' class='title'></td>
	            	        		<td width='30%' class='title'>시작시간</td>
	            	        		<td width='30%' class='title'>완료시간</td>
	            	        		<td width='*' class='title'>비고</td>
	            	        	</tr>            
	                          	<tr>
		                            <td class='title'>사고대차</td>
		                            <td align='center'><input type="hidden" class="text white" name ="s_dt1" value="" ><span id="s_dt1_span"></span></td>
		                            <td align='center'><input type="hidden" class="text white" name ="e_dt1" value="" ><span id="e_dt1_span"></span></td>
		                            <td></td>
		                        </tr>
		                        <tr>    
		                            <td class='title'>사고조회</td>
		                            <td align='center'><input type="hidden" class="text white" name ="s_dt2" value="" ><span id="s_dt2_span"></span></td>
		                            <td align='center'><input type="hidden" class="text white" name ="e_dt2" value="" ><span id="e_dt2_span"></span></td>
		                            <td></td>
	                          	</tr>
	                          	<tr>
	                          		<td class='title'>탁송조회</td>
		                            <td align='center'><input type="hidden" class="text white" name ="s_dt3" value="" ><span id="s_dt3_span"></span></td>
		                            <td align='center'><input type="hidden" class="text white" name ="e_dt3" value="" ><span id="e_dt3_span"></span></td>
		                            <td></td>
	                          	</tr>
	                        </table>
	                    </td>
	                </tr>
				</table>
	 		</td>
	    </tr>
	    <tr>
			<td class=h></td>
		</tr>
	    <tr><td><div>- 수리기간조회 한 기간을 기준으로 가장 적은 기간을 자동적용 합니다.<br>- 조회한 내역이 없거나 대차/사고/탁송등록당시 입력한 기간이 정확하지않을경우(12자리,년월일시분) 자동적용에서 제외됩니다.<br>- 기간산출 불가시 수리기간을 직접입력해주세요.</div></td></tr>
	    <tr> 
	      <td align="center">
	      	<%-- <a href="javascript:consDisp('<%=c_id%>');"><img src="/acar/images/center/button_conf.gif"  border="0" align=absmiddle></a> --%>
	      	<input type="button" class="button" value="수리기간적용" onclick ="javascript:set_ins_use_st('set_use_dt');">
	      	<a href="javascript:window.close();"><img src="/acar/images/center/button_close.gif"  border="0" align=absmiddle></a>		
	      </td>
	    </tr>
	</table>	
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<%-- <%}else{%> --%>
<%-- <table border='0' cellspacing='0' cellpadding='0' width='100%'>
	<tr>
		<td>
			<br>
			<div>- 사고조회결과, 피해/쌍방건 등록내역이 없습니다. 채권양도통지서 및 위임장을 생성하지 않습니다.</div><br> 
			<div>- 채권양도통지서 및 위임장이 필요한 경우 사고등록을 먼저 해주세요.</div><br>
			<div align="center"><a href="javascript:window.close();"><img src="/acar/images/center/button_close.gif"  border="0" align=absmiddle></a></div>
		</td>
	</tr>
</table>	
<%} %> --%>	
</form>
</body>
</html>

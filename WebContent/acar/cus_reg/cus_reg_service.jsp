<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.client.*, acar.common.*, acar.cus_reg.*, acar.cont.*, acar.car_register.*, acar.res_search.*"%>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="rs_db" 	class="acar.res_search.ResSearchDatabase" 	scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String dept_id = acar_de;
	

	CommonDataBase c_db = CommonDataBase.getInstance();
	CusReg_Database cr_db = CusReg_Database.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	
	
	ClientBean client = al_db.getClient(client_id);
		
	CarInfoBean carinfoBn = cr_db.getCarInfo(car_mng_id);
	
	ServInfoBean[] siBns = cr_db.getServiceAll(car_mng_id);
	
	Vector mngs = cr_db.getMng(client_id);
	
	Hashtable cont_view = a_db.getContViewCase(carinfoBn.getRent_mng_id(), carinfoBn.getRent_l_cd());
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(carinfoBn.getRent_mng_id(), carinfoBn.getRent_l_cd());
	
	//차량정보
	cr_bean = crd.getCarRegBean(car_mng_id);
	
	//대차관리 배차상태
	Hashtable reserv = rs_db.getResCarCase(car_mng_id, "2");
	String use_st = String.valueOf(reserv.get("USE_ST"))==null?"":String.valueOf(reserv.get("USE_ST"));
	
	Hashtable reserv2 = rs_db.getResCarCase(car_mng_id, "1");
	String use_st2 = String.valueOf(reserv2.get("USE_ST"))==null?"":String.valueOf(reserv2.get("USE_ST"));
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
//스케쥴생성하기
function create_scd_serv(){
	var fm = document.form1;
	if(fm.first_serv_dt.value=="")		{	alert("최초점검일자를 입력해 주세요!"); 	fm.first_serv_dt.focus();	return; }
	if(fm.cycle_serv_mon.value=="")		{	alert("점검주기 개월을 입력해 주세요!"); 	fm.cycle_serv_mon.focus();	return; }
	//if(fm.cycle_serv_day.value=="")	{	alert("방문주기 일자를 입력해 주세요!"); 	fm.cycle_serv_day.focus();	return; }
	if(fm.tot_serv.value=="")			{	alert("총방문횟수를 입력해 주세요!"); 		fm.tot_serv.focus();		return; }
	if(!confirm("순회점검 스케쥴을 생성하시겠습니까?"))		return;
	fm.action = "create_scd_serv.jsp";		
	fm.target = 'i_no';	
	fm.submit();
}
function extend_scd_serv(){
	var fm = document.form1;
	if(!confirm("스케쥴을 추가 생성하시겠습니까?"))		return;
	fm.action = "extend_scd_serv.jsp";
	fm.target = "i_no";
	fm.submit();
}
function extend_last_cont_s(){
	var fm = document.form1;
	if(fm.first_serv_dt.value==""){		alert("최초점검일자를 입력해 주세요!"); fm.first_serv_dt.focus();	return; }
	if(fm.cycle_serv_mon.value==""){	alert("점검주기 개월을 입력해 주세요!"); fm.cycle_serv_mon.focus();	return; }
	//if(fm.cycle_serv_day.value==""){	alert("방문주기 일자를 입력해 주세요!"); fm.cycle_serv_day.focus();	return; }
	if(fm.tot_serv.value==""){	alert("총방문횟수를 입력해 주세요!"); fm.tot_serv.focus();	return; }
	if(get_length(fm.tot_serv.value)>2){	alert("최대 총 방문횟수는 99회까지입니다."); fm.tot_serv.focus(); return; }
	if(!confirm("순회점검 스케쥴을 생성하시겠습니까?"))		return;
	fm.action = "extend_last_cont_s.jsp";		
	fm.target = 'i_no';	
	fm.submit();
}
function deleteScdServ(serv_id){
	var fm = document.form1;
	fm.serv_id.value = serv_id;
	
	if(!confirm("해당 스케쥴을 삭제하시겠습니까?"))	 return;
	fm.action = "delete_scd_serv.jsp";
	fm.target = "i_no";
	fm.submit();	
}
//다음방문일변경
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}
function go_visit(firm_nm){
	parent.location.href = "cus_reg_frame.jsp?s_gubun1=1&s_kd=1&t_wd="+firm_nm;
}
	//자동차등록정보 보기
	function view_car(m_id, l_cd, c_id)
	{
		window.open("/acar/car_register/car_view.jsp?rent_mng_id="+m_id+"&rent_l_cd="+l_cd+"&car_mng_id="+c_id+"&cmd=ud", "VIEW_CAR", "left=100, top=100, width=850, height=700, resizable=yes, scrollbars=yes, status=yes");
	}		
	function pop_excel(){
		var fm = document.form1;
		fm.target = "_blak";
		fm.action = "/acar/cus0401/popup_excel.jsp";
		fm.submit();
	}	
	//차종내역 보기
	function view_car_service(car_id){
		window.open("/acar/secondhand_hp/service_history.jsp?c_id=<%=car_mng_id%>&from_page=/fms2/lc_rent/lc_b_s.jsp", "VIEW_CAR_SERV", "left=100, top=100, width=630, height=500, resizable=yes, scrollbars=yes, status=yes");		
	}
	
	//차종내역 보기
	function view_car_dist(car_id){
		window.open("car_dist_history.jsp?car_no=<%= carinfoBn.getCar_no() %>&c_id=<%=car_mng_id%>&from_page=/fms2/lc_rent/lc_b_s.jsp", "VIEW_CAR_DIST", "left=100, top=100, width=630, height=500, resizable=yes, scrollbars=yes, status=yes");		
	}

	//계약정보 보기
	function view_client()
	{
		window.open("/fms2/con_fee/con_fee_client_s.jsp?m_id=<%=carinfoBn.getRent_mng_id()%>&l_cd=<%=carinfoBn.getRent_l_cd()%>&r_st=1", "VIEW_CLIENT", "left=100, top=100, width=820, height=700, resizable=yes, scrollbars=yes, status=yes");
	}	
	
	//예약이력
	function view_sh_res_h(){
		var SUBWIN="/acar/secondhand/reserveCarHistory.jsp?car_mng_id=<%=car_mng_id%>";
		window.open(SUBWIN, "reserveCarHistory", "left=50, top=50, width=850, height=800, scrollbars=yes, status=yes");
	}	
	
	//중고차가
	function sh_car_amt(){
		window.open("/fms2/lc_rent/search_sh_car_amt.jsp?rent_mng_id=<%=carinfoBn.getRent_mng_id()%>&rent_l_cd=<%=carinfoBn.getRent_l_cd()%>", "CAR_AMT_S", "left=0, top=0, width=1100, height=550, status=yes, scrollbars=yes");	
	}
//-->
</script>
</head>

<body>
<form name="form1" method="post">
<input type="hidden" name="auth_rw" value="">
<input type="hidden" name="car_mng_id" value="<%= car_mng_id %>">
<input type="hidden" name="serv_id" value="">
<table width="100%" border="0" cellspacing="1" cellpadding="0">
    <tr>
        <td>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class=line2 colspan=2></td>
                </tr>
                <tr> 
                    <td class=line colspan="2"> 
                        <table border="0" cellspacing="1" cellpadding='0' width=100%>
                            <tr> 
                              <td class='title'>상호&nbsp; </td>
                              <td class='left' colspan="3">&nbsp;<%if(!dept_id.equals("8888")){%><a href="javascript:go_visit('<%=client.getFirm_nm()%>')" title='고객방문으로 이동합니다.'><%=client.getFirm_nm()%></a><%}else{%><%=client.getFirm_nm()%><%}%>                              
                              <%if(!use_st.equals("null")){%>
                              ( [배차] <%=reserv.get("RENT_ST")%> &nbsp;<%=reserv.get("FIRM_NM")%> &nbsp;<a href="javascript:view_sh_res_h()" title="이력"><img src=/acar/images/center/button_ir_ss.gif align=absmiddle border=0></a> )
                              <%}else{ %>
                              <%	if(!use_st2.equals("null")){%>
                              ( [예약] <%=reserv2.get("RENT_ST")%> &nbsp;<%=reserv2.get("FIRM_NM")%> &nbsp;<a href="javascript:view_sh_res_h()" title="이력"><img src=/acar/images/center/button_ir_ss.gif align=absmiddle border=0></a> )
                              <%	} %>
                              <%} %>
                              </td>
                              <td class='title'>계약자</td>
                              <td class='left'>&nbsp;<%=client.getClient_nm()%></td>
                              <td class='title'>관리구분</td>		
							  <td class='left'>&nbsp;
							  <a href="javascript:view_client()" onMouseOver="window.status=''; return true" title='계약상세내역을 팝업합니다.'>
							  <%=cont_view.get("RENT_WAY")%>
							  </a>
							  &nbsp;
							  <%if(base.getMng_id().equals("")){%>
							  (<%=c_db.getNameById(base.getBus_id2(),"USER")%>)
							  <%}else{%>
							  (<%=c_db.getNameById(base.getMng_id(),"USER")%>)
							  <%}%>
							  </td>						  							  
                            </tr>							
                            <tr> 
                              <td class='title'>차량번호</td>
                              <td class='left'>&nbsp;<b><a href="javascript:view_car('<%//=cont.getRent_mng_id()%>', '<%//=cont.getRent_l_cd()%>', '<%=car_mng_id%>')" onMouseOver="window.status=''; return true" title='자동차등록상세내역을 팝업합니다.'><%= carinfoBn.getCar_no() %></a></b></td>
                              <td class='title'>차명</td>
                              <td class='left' colspan="3">&nbsp;<b><%= carinfoBn.getCar_jnm()+" "+carinfoBn.getCar_nm() %></b></td>
                              <td class='title'>색상</td>		
							  <td class='left'>&nbsp;<%= carinfoBn.getColo() %></td>						  
                            </tr>
                            <tr> 
                              <td class='title' width=14%>최초등록일</td>
                              <td class='left' width=11%>&nbsp;<%= AddUtil.ChangeDate2(carinfoBn.getInit_reg_dt()) %></td>
                              <td class='title' width=10%>차령만료일</td>
                              <td class='left' width=10%>&nbsp;<%= AddUtil.ChangeDate2(cr_bean.getCar_end_dt()) %>
                              	<%if(cr_bean.getCar_use().equals("1")){
									int car_end_d_day = c_db.getCar_D_day("car_end_dt", car_mng_id);
								%>
								<%if(car_end_d_day <= 30){ %><font color=red>(D-day <%=car_end_d_day%>일)</font><%}else{ if(ck_acar_id.equals("000029")){%>:<%=car_end_d_day%>일<%}} %>
								<%}%>
                              </td>							  
                              <td class='title' width=10%>연료</td>
                              <td class='left' width=15%><b> 
                                &nbsp;<%=c_db.getNameByIdCode("0039", "", carinfoBn.getFuel_kd())%>                                
                                </b> </td>
                              <td class='title' width=10%>배기량</td>
                              <td class='left' width=20%>&nbsp;<%= carinfoBn.getDpm() %> cc</td>
                            </tr>
                            <tr> 
                              <td class='title'>일반성보증</td>
                              <td class='left' colspan="3">&nbsp;<%= carinfoBn.getGuar_gen_y() %> 년 <%= AddUtil.parseDecimal(carinfoBn.getGuar_gen_km()) %> Km</td>
                              <td class='title'>내구성보증</td>
                              <td class='left' colspan="3">&nbsp;<%= carinfoBn.getGuar_endur_y() %> 년 <%= AddUtil.parseDecimal(carinfoBn.getGuar_endur_km()) %> Km</td>
                            </tr>
							
                        </table>
                    </td>
                </tr>
                <tr> 
                    <td colspan="2">
						<%if(dept_id.equals("8888")){%>
						※ 차량번호를 클릭하면 자동차상세내역이 팝업됩니다. 여기서 자동차등록증상의 내용 및 스캔등록한 <b>자동차등록증</b>을 볼수 있습니다.
						<%}else{%>
						&nbsp;
						<%}%>
					</td>
                </tr>
                <tr> 
                    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>자동차점검 스케줄</span></td>
                    <td align="right"> 
              <!--<font color="#666666"> ♣ <a href="javascript:MM_openBrWindow('client_loop2.htm','popwin_loop','scrollbars=yes,status=no,resizable=no,width=600,height=600,top=50,left=50')">거래처방문주기</a> 
              : <font color="#FF0000">한달</font></font>-->
                    </td>
                </tr>
                <tr>
                    <td class=line2 colspan=2></td>
                </tr>
                <tr> 
                    <td class=line colspan="2"> 
                        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
							<tr> 
								<td class=title>검사유효기간</td>
								<td colspan="2">&nbsp; 
								  <input type="text" name="maint_st_dt" value="<%=AddUtil.ChangeDate2(carinfoBn.getMaint_st_dt())%>" size="10" class=whitetext>
								  ~ 
								  <input type="text" name="maint_end_dt" value="<%=AddUtil.ChangeDate2(carinfoBn.getMaint_end_dt())%>" size="10" class=whitetext>
								  &nbsp; 
								  <%	
        		    					int car_maint_d_day = c_db.getCar_D_day("car_maint_dt", car_mng_id);
								  %>
								   <%if(car_maint_d_day <= 30){ %><font color=red>(D-day <%=car_maint_d_day%>일)</font><%}else{ if(ck_acar_id.equals("000029")){%>:<%=car_maint_d_day%>일<%}} %>
								</td>
								<td class=title>점검유효기간</td>
								<td colspan="2">&nbsp; 
								  <input type="text" name="test_st_dt" value="<%=cr_bean.getTest_st_dt()%>" size="10" class=whitetext>
								  ~&nbsp; 
								  <input type="text" name="test_end_dt" value="<%=cr_bean.getTest_end_dt()%>" size="10" class=whitetext>
								</td>
							</tr>
                            <tr> 
                              <td width=14% class='title'>관리담당자</td>
                              <td width=19%>&nbsp;&nbsp;<%= c_db.getNameById(carinfoBn.getMng_id(),"USER") %></td>
                              <td width=14% class='title'>일평균주행거리</td>
                              <td width=19%>&nbsp;&nbsp;<%= AddUtil.parseDecimal(carinfoBn.getAverage_dist()) %> km </td>
                              <td width=14% class='title'>현재예상주행거리</td>
                              <td width=20%>&nbsp;&nbsp;<%= AddUtil.parseDecimal(carinfoBn.getToday_dist()) %> km 
    	    			  &nbsp;&nbsp;
				  <span class="b"><a href="javascript:view_car_service('')" onMouseOver="window.status=''; return true" title="정비내역보기"><img src=/acar/images/center/button_in_jhir.gif align=absmiddle border=0></a></span>							  
    	    			  &nbsp;&nbsp;
				  <a href="javascript:view_car_dist('')" onMouseOver="window.status=''; return true" title="주행거리확인하기">[확인]</a>
			      </td>
                            </tr>
                            <tr> 
                              <td class='title'>&nbsp;최초점검일자</td>
                              <td>&nbsp; <input type="text" name="first_serv_dt" size="12" class=text value="<%= AddUtil.ChangeDate2(carinfoBn.getFirst_serv_dt()) %>" onBlur='javascript:this.value=ChangeDate(this.value);'> 
                              </td>
                              <td class='title'>점검주기</td>
                              <td>&nbsp; <input type="text" name="cycle_serv_mon" size="2" class=text value="<%if(!carinfoBn.getCycle_serv().equals("")) out.print(carinfoBn.getCycle_serv().substring(0,2)); %>">
                                개월 
                                <input type="text" name="cycle_serv_day" size="2" class=text value="<%if(!carinfoBn.getCycle_serv().equals("")) out.print(carinfoBn.getCycle_serv().substring(2,4)); %>">
                                일</td>
                              <td class='title'>점검횟수</td>
                              <td>&nbsp; <input type="text" name="tot_serv" size="3" class=num value="<%= carinfoBn.getTot_serv().trim() %>">
                                회</td>
                            </tr>
                        </table>
                    </td>
                </tr>
    		<%if(!cr_bean.getDist_cng().equals("")){%>
    		<tr>
      		  <td colspan="2"><font color=green><b>* <%=cr_bean.getDist_cng()%></b></font></td>
    		</tr>
    		<%}%>                    
                <tr> 
                    <td colspan="2" align="right">
                    
                    <a href="javascript:sh_car_amt();" class="btn" title='중고차가계산'><img src=/acar/images/center/button_fee_jg.gif align=absmiddle border=0></a>&nbsp;
                    
        			<%if(!dept_id.equals("8888")){ //siBns.length ==0 && %>
        			<a href="javascript:MM_openBrWindow('change_panel.jsp?car_mng_id=<%= car_mng_id %>','popwin_scd_serv_cng_dt','scrollbars=no,status=no,resizable=no,width=450,height=380,top=200,left=300')">계기판교환</a>&nbsp;
        			<a href="javascript:create_scd_serv()"><img src=/acar/images/center/button_sch_cre.gif align=absmiddle border=0></a>
        			
        			<% } %>
        			
        			<%if(siBns.length >0 ){ %>
        			<%		if(!dept_id.equals("8888")){%>			
        			<a href="javascript:MM_openBrWindow('serv_reg.jsp?car_mng_id=<%= car_mng_id %>&cmd=b','popwin_serv_reg','scrollbars=yes,status=yes,resizable=yes,width=900,height=600,top=50,left=50')"><img src=/acar/images/center/button_reg_bjg.gif align=absmiddle border=0></a>&nbsp;
        			<a href="javascript:MM_openBrWindow('scd_serv_cng_dt.jsp?car_mng_id=<%= car_mng_id %>','popwin_scd_serv_cng_dt','scrollbars=no,status=no,resizable=no,width=350,height=180,top=200,left=300')"><img src=/acar/images/center/button_modify_yji.gif align=absmiddle border=0></a>&nbsp;
        			<a href="javascript:extend_last_cont_s()"><img src=/acar/images/center/button_gy_yj.gif align=absmiddle border=0></a>&nbsp;
        			<% 		}else{ %>
        			<a href="javascript:MM_openBrWindow('serv_accid_reg.jsp?car_mng_id=<%= car_mng_id %>&cmd=b','popwin_serv_reg','scrollbars=yes,status=yes,resizable=yes,width=900,height=600,top=50,left=50')"><img src=/acar/images/center/button_reg_bjg.gif align=absmiddle border=0></a>&nbsp;
        			<% 		}%>
        			<% }%>
        			
        			<%if(siBns.length >0 && !dept_id.equals("8888")){%>		
        			<a href="javascript:pop_excel()"><img src=/acar/images/center/button_excel_jb.gif align=absmiddle border=0></a>
        			<%}%>
        			
        			
        			</td>
                </tr>
                <tr>
                    <td></td>
                </tr>
                <tr> 
                    <td colspan="2"> 
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td class=line2></td>
                            </tr>
                            <tr>
                                <td class="line">
                                    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                                        <tr> 
                                            <td class='title' width=4%>회차</td>
                                            <td class='title' width=9%>점검예정일</td>
                                            <td class='title' width=9%>점검일</td>
                                            <td class='title' width=7%>점검자</td>
                                            <td class='title' width=7%>시행자</td>
                                            <td class='title' width=9%>정비분류</td>
                                            <td class='title' width=9%>정비구분</td>
                                            <td class='title' width=17%>정비내용</td>
                                            <td class='title' width=8%>주행거리</td>
                        					<td class='title' width=7%>정비금액</td>
                                            <td class='title' width=7%>등록</td>
                                            <td class='title' width=7%>삭제</td>
                                        </tr>
                                    </table>
                                 </td>
                                 <td width=16>&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td colspan="2"><iframe src="cus_reg_service_in.jsp?car_mng_id=<%=car_mng_id%>" name="scd_serv" width="100%" height="300" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > 
                    </iframe></td>
                </tr>
                <tr> 
                    <td colspan="2">&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>

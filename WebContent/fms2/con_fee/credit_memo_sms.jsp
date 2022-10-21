<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.fee.*, acar.cont.*, acar.client.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String r_st 	= request.getParameter("r_st")==null?"1":request.getParameter("r_st");
	String fee_tm 	= request.getParameter("fee_tm")==null?"A":request.getParameter("fee_tm");
	String tm_st1 	= request.getParameter("tm_st1")==null?"0":request.getParameter("tm_st1");
	String bus_id2 	= request.getParameter("bus_id2")==null?"":request.getParameter("bus_id2");
	String memo_st 	= request.getParameter("memo_st")==null?"client":request.getParameter("memo_st");
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	
	//해지관련 
	String cls_etc 	= request.getParameter("cls_etc")==null?"":request.getParameter("cls_etc");
	
	
	if(fee_tm.equals("")) fee_tm = "A";
	if(tm_st1.equals("")) tm_st1 = "0";
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	LoginBean login = LoginBean.getInstance();
	String reg_id = login.getCookieValue(request, "acar_id");
	
	//로그인
	UsersBean user_bean2 = umd.getUsersBean(reg_id);
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(m_id, l_cd);
	
	//cont_view
	Hashtable cont_base = a_db.getContViewCase(m_id, l_cd);
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//지점정보
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
	
	//고객관련자
	Vector car_mgrs = a_db.getCarMgrListNew(m_id, l_cd, "Y");
	int mgr_size = car_mgrs.size();
	
	if(base.getUse_yn().equals("Y") && memo_st.equals("client")){
		car_mgrs = a_db.getCarMgrClientList(base.getClient_id(), "Y");
		mgr_size = car_mgrs.size();
	}
	
	//영업담당자
	UsersBean user_bean = umd.getUsersBean(base.getBus_id2());
	
	if(base.getCar_st().equals("4")){
		user_bean = umd.getUsersBean(base.getMng_id());
	}
	
	//외근직일 경우 본인이 발신자
	if(!user_bean2.getLoan_st().equals("")){
		user_bean = user_bean2;
	}
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//연체내역확인 및 문자내용 자동산정
	function viewSmsMsg3(){
		var fm = document.form1;
		fm.msg.readOnly = true;
		document.getElementById("vbt").style.display = "none";
		var SUBWIN="view_sms_msg_3.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&r_st=<%=r_st%>&client_id=<%=client.getClient_id()%>&client=<%=client%>";	
		window.open(SUBWIN, "ViewSmsMsg", "left=100, top=100, width=1000, height=900, scrollbars=yes, status=yes");
	}
	
	//SMS 발송내역(100일이내발송분)
	function viewSmsHistory(){
		var fm = document.form1;
		var SUBWIN="view_sms_history.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&client_id=<%=client.getClient_id()%>&firm_nm=<%=client.getFirm_nm()%>";	
		window.open(SUBWIN, "ViewSmsHis", "left=50, top=100, width=1150, height=800, scrollbars=yes, status=yes");
	}
	
	//알림톡
	function viewSmsMsg(gubun){
		
		var m_id = '<%=m_id%>';
		var l_cd = '<%=l_cd%>';
		var client_id = '<%=client.getClient_id()%>';
		var client = '<%=client%>';		
		
		var fm = document.form1;
		fm.msg.readOnly = true;
		if (gubun == "accid" || gubun == "accid_ins") {
			document.getElementById("vbt").style.display = "";
		} else {
			document.getElementById("vbt").style.display = "none";
		}
		<%-- var SUBWIN="view_sms_msg_car.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&client_id=<%=client.getClient_id()%>&client=<%=client%>&msg_gubun="+gubun;	
		window.open(SUBWIN, "ViewSmsMsg", "left=100, top=100, width=850, height=800, scrollbars=yes, status=yes"); --%>
		<%-- fm.action = "view_sms_msg_car.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&client_id=<%=client.getClient_id()%>&client=<%=client%>&msg_gubun="+gubun; --%>
		fm.action = "view_sms_msg_car.jsp?m_id="+m_id+"&l_cd="+l_cd+"&client_id="+client_id+"&client="+client+"&msg_gubun="+gubun;
		fm.target = "i_no";
		fm.submit();
	}
	
	//직접입력
	function self_input(){
		var fm = document.form1;
		fm.msg.readOnly = false;
		fm.msg_subject.value = "";
		fm.msg.value = "";
		document.getElementById("vbt").style.display = "none";
	}	
	
	//해지
	function self_input1(){
		var m_id = '<%=m_id%>';
		var l_cd = '<%=l_cd%>';
		var client_id = '<%=client.getClient_id()%>';
		
		var fm = document.form1;
		fm.msg.readOnly = false;
		fm.msg_subject.value = "";
		fm.msg.value = "";
		document.getElementById("vbt").style.display = "none";
	
		fm.action = "view_sms_msg_cls.jsp?m_id="+m_id+"&l_cd="+l_cd+"&client_id="+client_id;		
		fm.target = "i_no";
		fm.submit();
		
	}	
		
	function display_cng(){
		var fm = document.form1;
		if(fm.memo_st.value == 'client'){
			fm.memo_st.value = '';
		}else{
			fm.memo_st.value = 'client';		
		}
		fm.action = 'credit_memo_sms.jsp';
		fm.submit();	
	}	
	
	//전체선택
	function AllSelected(){
		try{
			var f = form1;
			for (var i=0; i<f.lb_userList.options.length; i++)	{
				f.lb_userList.options[i].selected = "selected";
			}
			AddSubID();
		}
		catch (e){
			alert(e.description);
		}
	}
	//선택등록
	function AddSubID(){
		var f = form1;
		if (f.lb_userList.options.selectedIndex == -1){
			alert("사원을 선택하세요.");
			f.lb_userList.focus();
			return;
		};
				
		for (var i=0; i<f.lb_userList.options.length; i++){
			if (f.lb_userList.options[i].selected){		
				if(f.lb_userList.options[i].value.substr(0,1) == '1') continue;	
				var m_bAdd = false;
				for (var k=0; k<f.lb_userSelectedList.options.length; k++){
					if (f.lb_userSelectedList.options[k].value == f.lb_userList.options[i].value){
						m_bAdd = true;
						break;
					}
				}
				if (!m_bAdd){
					f.lb_userSelectedList.options.add(new Option(f.lb_userList.options[i].text, f.lb_userList.options[i].value));
				}
			}
		}
	}
	
	//삭제
	function SelectRemove(tp){
		var obj = form1.lb_userSelectedList;
			
		if (tp == "ALL")
			obj.options.length = 0;
		else{
			if (obj.options.selectedIndex == -1){
				alert("삭제할 항목을 선택하세요.");
				return;
			}
			for (var i=obj.options.length-1; i>=0; i--){
				if (obj.options[i].selected)
					obj.options.remove(i);
			}
		}
	}	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' method='post'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='r_st' value='<%=r_st%>'>
<input type='hidden' name='fee_tm' value='<%=fee_tm%>'>
<input type='hidden' name='tm_st1' value='<%=tm_st1%>'>
<input type='hidden' name='firm_nm' value='<%=client.getFirm_nm()%>'>
<input type='hidden' name='from_page' value='credit_memo'>
<input type='hidden' name='memo_st' value='<%=memo_st%>'>
<input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
<input type='hidden' name='msg_subject' 	value=''>

<input type='hidden' name='bond_msg_type' value=''>

<input type='hidden' name='mng_send' value=''>
<input type='hidden' id="customer_name" name='customer_name' value=''>
<input type='hidden' id="cur_date" name='cur_date' value=''>
<input type="hidden" id="car_no" name="car_no" value="">
<input type="hidden" id="car_nm" name="car_nm" value="">
<input type="hidden" id="car_count" name="car_count" value="">
<input type="hidden" id="car_num_name_count" name="car_num_name_count" value="">
<input type='hidden' id="short_url" name='short_url' value=''>
<input type='hidden' id="unpaid" name='unpaid' value=''>
<input type='hidden' id="bank_full" name='bank_full' value=''>

<input type='hidden' id="manager_name" name='manager_name' value=''>
<input type='hidden' id="manager_phone" name='manager_phone' value=''>
  
<table border="0" cellspacing="0" cellpadding="0" width=780>
	<tr> 
        <td colspan="2">
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>채권관리 > <span class=style5><%if(memo_st.equals("client")){%>거래처 통합<%}else{%>계약 <%=l_cd%><%}%></span></span></td>	
                    <td class=bar align="right">&nbsp;<%if(!acar_de.equals("1000")){%><a href="javascript:display_cng()">[<%if(memo_st.equals("client")){%>계약별<%}else{%>거래처통합<%}%> 보기]</a><%}%></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td colspan="2" class=h></td>
    </tr>		
    <tr>
	    <td>
		  <img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>문자발송</span>
		  </td>
	    <td align='right'>
			  <a href="javascript:viewSmsHistory();" title='SMS 발송내역'>[SMS 발송내역]</a>
		  </td>		  
	</tr>
	<tr>
        <td colspan="2" class=line2></td>
    </tr>
	<tr>
		<td colspan="2" class='line' width=780>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
            
                <tr> 
                    <td class="title" rowspan='2'>수신</td>
                    <td colspan="3"> 
			            <table border=0 cellspacing=0 cellpadding=5 width=100% align="center">
			                <tr>
			                    <td class=h></td>
			                </tr>
                            <tr> 
                                <td width=45% align="center">
            				    <select size="4" name="lb_userList" multiple="multiple" id="lb_userList" style="height:200px;width:250px;">
								<%if(!client.getM_tel().equals("")){%>
        				<option value="<%=client.getM_tel()%>">[대&nbsp;&nbsp;&nbsp;표&nbsp;&nbsp;&nbsp;자] <%=client.getM_tel()%> <%=client.getClient_nm()%></option>
        				<%}%>
        				<%if(!client.getCon_agnt_m_tel().equals("")){%>
        				<option value="<%=client.getCon_agnt_m_tel()%>">[세금계산서] <%=client.getCon_agnt_m_tel()%> <%=client.getCon_agnt_nm()%></option>
        				<%}%>
        				<%if(!site.getAgnt_m_tel().equals("")){%>
        				<option value="<%=site.getAgnt_m_tel()%>">[지점세금계산서] <%=site.getAgnt_m_tel()%> <%=site.getAgnt_nm()%></option>
        				<%}%>
        				<%for(int i = 0 ; i < mgr_size ; i++){
        					CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);
        					if(!mgr.getMgr_m_tel().equals("")){%>
        				<option value="<%=mgr.getMgr_m_tel()%>">[<%=mgr.getMgr_st()%>] <%=mgr.getMgr_m_tel()%> <%=mgr.getMgr_nm()%> <%=mgr.getMgr_title()%></option>
        				<%}}%>	
        				<option value="<%=user_bean.getUser_m_tel()%>">[영업담당자] <%=user_bean.getUser_m_tel()%> <%=user_bean.getUser_nm()%></option>
        				
        				
            					</select>
                                </td>
            				    <td width=10%><a href="javascript:AddSubID()" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_arrow.gif border=0></a>
                                </td>
            				    <td width=45% align="center">
            				    <select size="4" name="lb_userSelectedList" multiple="multiple" id="lb_userSelectedList" style="height:200px;width:250px;">
            					</select>
                                </td>
                            </tr>
                            <tr> 
                                <td align="center">
            				    <a href="javascript:AllSelected()"><img src=/acar/images/center/button_in_alls.gif border=0 align=absmiddle></a></span>
            				    &nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:AddSubID()"><img src=/acar/images/center/button_in_sreg.gif border=0 align=absmiddle></a>
                                </td>
            				    <td>
                                </td>
            				    <td align="center">
            				    <a href="javascript:SelectRemove('')"><img src=/acar/images/center/button_in_sdel.gif border=0 align=absmiddle></a>
            				    &nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:SelectRemove('ALL')"><img src=/acar/images/center/button_in_alldel.gif border=0 align=absmiddle></a>				  
                                </td>
                            </tr>
                            <tr>
			                    <td class=h></td>
			                </tr>
                        </table>
                    </td>
                </tr>	
                            
                <tr>                     
                    <td width=90%>
        			  &nbsp;&nbsp;직접입력 : <input type='text' size='15' name='destphone' value='' maxlength='100' class='text'>								
					</td>
			    </tr>
                <tr> 
                    <td class='title'>발신</td>
                    <td>
        			  &nbsp;&nbsp;발신번호 : <input type='text' size='15' name='sendphone' value='<%=user_bean.getUser_m_tel()%>' maxlength='100' class='text'>
        			  &nbsp;발신자명 : <input type='text' size='15' name='sendname' value='<%=user_bean.getUser_nm()%>' maxlength='100' class='text'> 
					</td>
			    </tr>			
			    <tr> 
		            <td class='title'>친구톡</td>		            
		            <td>&nbsp;&nbsp;<input type="radio" name="talk_gubun" id="talk_gubun_1" onchange="javascript:self_input();" <% if ( cls_etc.equals(""))  { %>checked<%} %>><label for="talk_gubun_1">직접입력</label>
		             <% if ( cls_etc.equals("Y"))  { %>   
		            &nbsp; <input type="radio" name="talk_gubun" id="talk_gubun_11" onchange="javascript:self_input1();" checked><label for="talk_gubun_11">해지안내</label>
		            <% } %>
		            </td>
			    </tr>						   
		    <% if ( !cls_etc.equals("Y"))  { %>     
			    <tr> 
            		  <td class='title'>알림톡</td>					  
					  <td>&nbsp;&nbsp;<input type="radio" name="talk_gubun" id="talk_gubun_2" onchange="javascript:viewSmsMsg3();"><label for="talk_gubun_2">채권</label>
					  	  &nbsp;<input type="radio" name="talk_gubun" id="talk_gubun_3" onchange="javascript:viewSmsMsg('accid');"><label for="talk_gubun_3">사고처리(단순연락처) 안내</label>
					  	  <%if(!base.getCar_mng_id().equals("")){%>
					  	  &nbsp;<input type="radio" name="talk_gubun" id="talk_gubun_4" onchange="javascript:viewSmsMsg('accid_ins');"><label for="talk_gubun_4">보험접수 및 사고처리안내</label>
					  	  <%}%>
					  	  <%if(String.valueOf(cont_base.get("RENT_WAY")).equals("일반식")){%>
					  	  &nbsp;<input type="radio" name="talk_gubun" id="talk_gubun_5" onchange="javascript:viewSmsMsg('service');"><label for="talk_gubun_5">정비(일반식)안내</label>
					  	  <%}%>
                <%if(base.getCar_st().equals("4")){%>
                &nbsp;<input type="radio" name="talk_gubun" id="talk_gubun_6" onchange="javascript:viewSmsMsg('mrent');"><label for="talk_gubun_6">월렌트 유의사항</label>
                <!--&nbsp;<input type="radio" name="talk_gubun" id="talk_gubun_6" onchange="javascript:viewSmsMsg('mrent1');"><label for="talk_gubun_6">월렌트 유의사항1</label>
                &nbsp;<input type="radio" name="talk_gubun" id="talk_gubun_7" onchange="javascript:viewSmsMsg('mrent2');"><label for="talk_gubun_6">월렌트 유의사항2</label>-->
                <%}%>
					  </td>
			    </tr>
			 <% } %>   
                <tr> 
                    <td class='title'>메세지</td>
                    <td>
        			  &nbsp;&nbsp;<textarea name='msg' rows='20' cols='72' class='text' style='IME-MODE: active'></textarea>
					</td>
			    </tr>		

                <tr> 
                    <td class='title'>예약일시</td>
                    <td>&nbsp;&nbsp;
					  	<div style="float: left; padding-left: 12px;">
						  	<input type="text" name="req_dt" size="11" class="text" value="" onBlur='javscript:this.value = ChangeDate(this.value);'>
							<select name="req_dt_h">
								<%for(int i=0; i<24; i++){%>
									<option value="<%=AddUtil.addZero2(i)%>"><%=AddUtil.addZero2(i)%>시</option>
								<%}%>
							</select>
							<select name="req_dt_s">
								<%for(int i=0; i<59; i+=5){%>
									<option value="<%=AddUtil.addZero2(i)%>"><%=AddUtil.addZero2(i)%>분</option>
								<%}%>
							</select>
						</div>
						&nbsp;&nbsp;
						<div id="vbt" style="float: left; padding-left: 20px; display: none;">
							<input type="checkbox" name="manager_send_use" id="manager_send_use" checked><label for="manager_send_use">관리담당자에게도 문자발송</label>
						</div>
					</td>
			    </tr>										

            </table>
		</td>
	</tr>	
	 
	<tr>
		<td colspan="2" align='right'> 
		  <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
		  <a href="javascript:SandSms()"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;
		  <%}%>
		  <a href="javascript:parent.close()"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
		</td>
	</tr>			
	
</table>
<input type='hidden' name='destphone_multi' value=''>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--
<% if ( cls_etc.equals("Y"))  { %>   
	self_input1();
<%}%>
	
	//문자 보내기
	function SandSms(){
		var check_use = document.getElementById("manager_send_use").checked;
		var fm = document.form1;
		
		var obj = fm.lb_userSelectedList;
		fm.destphone_multi.value = "";
		for(var i=0; i<obj.options.length; i++)
		{
			fm.destphone_multi.value += "////" + obj.options[i].value;
		}	
		
		if(fm.destphone.value == "" && obj.options.length == 0){		alert('수신번호를 입력 또는 선택해주세요.');	fm.lb_userList.focus();			return;	}
		
		if(fm.destphone.value != ""){
			fm.destphone_multi.value += "////" + fm.destphone.value;
		}
						
		if (fm.msg.value == "") {
			alert("메세지 내용을 입력해 주세요.");
			return;
		} 
			
		if (confirm('문자를 보내시겠습니까?')) {
				
				if (check_use) {
					fm.mng_send.value = "Y";
				} else {
					fm.mng_send.value = "N";
				}
				
				fm.action = "fee_memo_sms.jsp";
				fm.target = "i_no";						
				fm.submit();
		
		}
	}
//-->
</script>
</body>
</html>
